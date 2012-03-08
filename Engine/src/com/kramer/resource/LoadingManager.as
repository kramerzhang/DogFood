package com.kramer.resource
{
	/**
	 *@author Kramer 
	 */	
	
	import com.kramer.log.LogLevel;
	import com.kramer.log.Logger;
	import com.kramer.resource.events.ResourceEvent;
	import com.kramer.resource.item.ILoadable;
	import com.kramer.trove.HashMap;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	public class LoadingManager
	{
		private static const PARALLEL_MAX_NUM:int = 2;
		private static var _loadingItemNum:int = 0;
		
		private static var _itemQueue:Vector.<LoadableItemWrapper>;
		private static var _urlDuplicatedVec:Vector.<LoadableItemWrapper>;
		private static var _loadingItemMap:HashMap;
		private static var _logger:Logger;
		
		public function LoadingManager(blocker:Blocker){}
		
		initialize();
		private static function initialize():void
		{
			_itemQueue = new Vector.<LoadableItemWrapper>();
			_urlDuplicatedVec = new Vector.<LoadableItemWrapper>();
			_loadingItemMap = new HashMap();
			_logger = Logger.getLogger("LoadingManager");
			_logger.setLevel(LogLevel.ALL);
		}
		
		public static function addItem(wrapper:LoadableItemWrapper):void
		{
			if(checkItemDuplication(wrapper) == false)
			{
				if(checkUrlDuplication(wrapper) == false)
				{
					_itemQueue.push(wrapper);
					_logger.info(wrapper.item.getUrl() + " 加入下载队列");
					loadNextItem();
				}
				else
				{
					_urlDuplicatedVec.push(wrapper);
				}
			}
			else
			{
				_logger.warn(wrapper.item.getUrl() + "加载项重复");
			}
		}
		
		public static function addCache(wrapper:LoadableItemWrapper):void
		{
			addItem(wrapper);
		}
		
		private static function checkItemDuplication(wrapper:LoadableItemWrapper):Boolean
		{
			if(checkItemInQueue(wrapper))
			{
				return true;
			}
			if(checkItemInLoadingMap(wrapper))
			{
				return true;
			}
			return false;
		}
		
		private static function checkItemInQueue(wrapper:LoadableItemWrapper):Boolean
		{
			for each(var existItemWrapper:LoadableItemWrapper in _itemQueue)
			{
				if(existItemWrapper.item.getUrl() == wrapper.item.getUrl()
					&& existItemWrapper.completeHandler == wrapper.completeHandler)
				{
					return true;
				}
			}
			return false;
		}
		
		private static function checkItemInLoadingMap(wrapper:LoadableItemWrapper):Boolean
		{
			var loadingItemArr:Array = _loadingItemMap.getValues();
			for each(var loadingItemWrapper:LoadableItemWrapper in loadingItemArr)
			{
				if(loadingItemWrapper.item.getUrl() == wrapper.item.getUrl()
					&& loadingItemWrapper.completeHandler == wrapper.completeHandler)
				{
					return true;
				}
			}
			return false;
		}
		
		private static function checkUrlDuplication(wrapper:LoadableItemWrapper):Boolean
		{
			if(checkUrlInQueue(wrapper))
			{
				return true;
			}
			if(checkUrlInLoadingMap(wrapper))
			{
				return true;
			}
			return false;
		}
		
		private static function checkUrlInQueue(wrapper:LoadableItemWrapper):Boolean
		{
			for each(var existItemWrapper:LoadableItemWrapper in _itemQueue)
			{
				if(existItemWrapper.item.getUrl() == wrapper.item.getUrl())
				{
					return true;
				}
			}
			return false;
		}
		
		private static function checkUrlInLoadingMap(wrapper:LoadableItemWrapper):Boolean
		{
			var loadingItemArr:Array = _loadingItemMap.getValues();
			for each(var existItemWrapper:LoadableItemWrapper in loadingItemArr)
			{
				if(existItemWrapper.item.getUrl() == wrapper.item.getUrl())
				{
					return true;
				}
			}
			return false;
		}
		
		private static function loadNextItem():void
		{
			if(_loadingItemNum >= PARALLEL_MAX_NUM)
			{
				return;
			}
			if(_itemQueue.length != 0)
			{
				_loadingItemNum++;
				_itemQueue.sort(sortItemByPriority);
				var itemWrapper:LoadableItemWrapper = _itemQueue.shift(); 
				_loadingItemMap.put(itemWrapper.item, itemWrapper);
				loadItem(itemWrapper);
			}
		}
		
		private static function sortItemByPriority(a:LoadableItemWrapper, b:LoadableItemWrapper):int
		{
			if(a.priority > b.priority)
			{
				return 1;
			}
			if(a.priority < b.priority)
			{
				return -1
			}
			return 0;
		}
		
		private static function loadItem(wrapper:LoadableItemWrapper):void
		{
			var loadableItem:ILoadable = wrapper.item;
			addItemEventListener(loadableItem);
			loadableItem.load();
			_logger.info(loadableItem.getUrl() + " 开始下载");
		}
		
		private static function addItemEventListener(item:ILoadable):void
		{
			item.addEventListener(Event.OPEN, onLoadStart);
			item.addEventListener(ErrorEvent.ERROR, onLoadError);
			item.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			item.addEventListener(ResourceEvent.COMPLETE, onLoadComplete);
		}
		
		private static function removeItemEventListener(item:ILoadable):void
		{
			item.removeEventListener(Event.OPEN, onLoadStart);
			item.removeEventListener(ErrorEvent.ERROR, onLoadError);
			item.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			item.removeEventListener(ResourceEvent.COMPLETE, onLoadComplete);
		}
		
		private static function onLoadStart(evt:Event):void
		{
			var item:ILoadable = evt.target as ILoadable;
			for each(var existItemWrapper:LoadableItemWrapper in _urlDuplicatedVec)
			{
				if(existItemWrapper.item.getUrl() == item.getUrl())
				{
					existItemWrapper.fireItemLoadStartEvent();
				}
			}
		}
		
		private static function onLoadComplete(evt:ResourceEvent):void
		{
			var loadedItem:ILoadable = evt.target as ILoadable;
			removeItemEventListener(loadedItem);
			
			var loadedItemWrapper:LoadableItemWrapper = _loadingItemMap.get(loadedItem);
			loadedItemWrapper.dispose();
			_loadingItemMap.remove(loadedItem);
			
			var len:int = _urlDuplicatedVec.length;
			for(var i:int = (len - 1); i >= 0; i--)
			{
				var duplicatedItemWrapper:LoadableItemWrapper = _urlDuplicatedVec[i];
				if(duplicatedItemWrapper.item.getUrl() == loadedItem.getUrl())
				{
					duplicatedItemWrapper.copyContent(loadedItem);
					_urlDuplicatedVec.splice(i, 1);
				}
			}
			_logger.info(loadedItem.getUrl() + " 下载完成");
			_loadingItemNum--;
			loadNextItem();
		}
		
		private static function onLoadError(evt:ErrorEvent):void
		{
			var errorItem:ILoadable = evt.target as ILoadable;
			removeItemEventListener(errorItem);
			
			var errorItemWrapper:LoadableItemWrapper = _loadingItemMap.get(errorItem);
			errorItemWrapper.dispose();
			_loadingItemMap.remove(errorItem);
			
			var len:int = _urlDuplicatedVec.length;
			for(var i:int = (len - 1); i >= 0; i--)
			{
				var duplicatedItemWrapper:LoadableItemWrapper = _urlDuplicatedVec[i];
				if(duplicatedItemWrapper.item.getUrl() == errorItem.getUrl())
				{
					duplicatedItemWrapper.fireItemLoadErrorEvent();
					duplicatedItemWrapper.dispose();
					_urlDuplicatedVec.splice(i, 1);
				}
			}
			_logger.error(errorItem.getUrl() + " " + evt.text);
			
			_loadingItemNum--;
			loadNextItem();
		}
		
		private static function onLoadProgress(evt:ProgressEvent):void
		{
			var item:ILoadable = evt.target as ILoadable;
			for each(var existItemWrapper:LoadableItemWrapper in _urlDuplicatedVec)
			{
				if(existItemWrapper.item.getUrl() == item.getUrl())
				{
					existItemWrapper.fireItemLoadProgressEvent(evt.bytesLoaded, evt.bytesTotal);
				}
			}
		}
		
		public static function cancelAll():void
		{
			_itemQueue = new Vector.<LoadableItemWrapper>();
			_urlDuplicatedVec = new Vector.<LoadableItemWrapper>();
			var loadingItemArr:Array = _loadingItemMap.getValues();
			for each(var itemInfo:LoadableItemWrapper in loadingItemArr)
			{
				var item:ILoadable = itemInfo.item;
				var result:Boolean = item.cancel();
				if(result)
				{
					_loadingItemMap.remove(item);
				}
			}
			_logger.info("清空下载队列，并停止正在加载项");
		}
		
		public static function cancel(url:String, completeHandler:Function):void
		{
			var isCancelInQueue:Boolean = cancelInQueue(url, completeHandler);
			var isCancelInLoadingMap:Boolean = cancelInLoadingMap(url, completeHandler);
			
			if(isCancelInQueue || isCancelInLoadingMap)
			{
				loadFirstOfUrlDuplicatedVec(url);
			}
		}
		
		private static function loadFirstOfUrlDuplicatedVec(url:String):void
		{
			var len:int = _urlDuplicatedVec.length;
			for(var i:int = (len - 1); i >= 0; i--)
			{
				var itemWrapper:LoadableItemWrapper = _urlDuplicatedVec[i];
				if(itemWrapper.item.getUrl() == url)
				{
					_urlDuplicatedVec.splice(i, 1);
					addItem(itemWrapper);
					return;
				}
			}
		}
		
		private static function cancelInQueue(url:String, completeHandler:Function):Boolean
		{
			var queueLen:int = _itemQueue.length;
			for(var i:int = 0; i <queueLen; i++)
			{
				var queueItemWrapper:LoadableItemWrapper = _itemQueue[i];
				if(queueItemWrapper.item.getUrl() == url && queueItemWrapper.completeHandler == completeHandler)
				{
					_itemQueue.splice(i, 1);
					_logger.info("下载队列中" + queueItemWrapper.item.getUrl() + "取消");
					return true;
				}
			}
			return false;
		}
		
		private static function cancelInLoadingMap(url:String, completeHandler:Function):Boolean
		{
			var loadingItemArr:Array = _loadingItemMap.getValues();
			for each(var existItemWrapper:LoadableItemWrapper in loadingItemArr)
			{
				if(existItemWrapper.item.getUrl() == url && existItemWrapper.completeHandler == completeHandler)
				{
					var result:Boolean = existItemWrapper.item.cancel();
					if(result == true)
					{
						_loadingItemMap.remove(existItemWrapper.item);
						_loadingItemNum--;
						_logger.info("正在下载队列中" + existItemWrapper.item.getUrl() + "取消");
						return true;
					}
				}
			}
			return false;
		}
	}
}
class Blocker{}