package com.kramer.resource.cache
{
	/**
	 *@author Kramer 
	 */	
	import com.kramer.core.IDisposable;
	import com.kramer.core.IReferenceCountable;
	import com.kramer.resource.LoadableItemWrapper;
	import com.kramer.resource.LoadingManager;
	import com.kramer.resource.events.ResourceEvent;
	import com.kramer.resource.item.ILoadable;
	import com.kramer.resource.item.LoadableItemFactory;
	import com.kramer.trove.HashMap;

	public class CacheHolder
	{
		private static const CLEAR_CACHE_SIZE_RATIO:Number = 0.4;
		private static const CAPACITY_MAX:int = 100;
		
		private var _capacity:int;
		private var _key:String;
		private var _cachedItemMap:HashMap;
		//热度指数
		private var _heatIndexMap:HashMap;
		
		public function CacheHolder(cacheKey:String)
		{
			_key = cacheKey;
			initialize();
		}
		
		private function initialize():void
		{
			_cachedItemMap = new HashMap();
			_heatIndexMap = new HashMap();
			_capacity = CAPACITY_MAX;
		}
		
		public function get size():int
		{
			return _cachedItemMap.length;
		}
		
		public function set capacity(value:int):void
		{
			_capacity = value;
		}
		
		public function get capacity():int
		{
			return _capacity;
		}
		
		public function getKey():String
		{
			return _key;
		}
		
		public function getCachedItem(type:String, url:String, completeHandler:Function, startHandler:Function, progressHandler:Function, errorHandler:Function, priority:int):void
		{
			getCache(type, url, completeHandler, startHandler, progressHandler, errorHandler, priority);
		}
		
		private function getCache(type:String, url:String, completeHandler:Function, startHandler:Function, progressHandler:Function, errorHandler:Function, priority:int):void
		{
			if(_cachedItemMap.containsKey(url))
			{
				recordToHeatIndexMap(url);
				var cachedItem:ILoadable = _cachedItemMap.get(url) as ILoadable;
				var newItem:ILoadable = LoadableItemFactory.createItem(type, url);
				newItem.copyContent(cachedItem);
			}
			else
			{
				loadCache(type, url, completeHandler, startHandler, progressHandler, errorHandler, priority);
			}
		}
		
		private function loadCache(type:String, url:String, completeHandler:Function, startHandler:Function, progressHandler:Function, errorHandler:Function, priority:int):void
		{
			var cache:ILoadable = LoadableItemFactory.createItem(type, url);
			var completeHandlerWrapper:CompleteHandlerWrapper = new CompleteHandlerWrapper(completeHandler, onCacheLoadComplete);
			var loadableItemWrapper:LoadableItemWrapper = new LoadableItemWrapper(cache, completeHandlerWrapper.completeHandler, startHandler, progressHandler, errorHandler, priority);
			LoadingManager.addCache(loadableItemWrapper);
		}
		
		private function onCacheLoadComplete(evt:ResourceEvent):void
		{
			var cache:ILoadable = evt.target as ILoadable;
			var url:String = cache.getUrl();
			recordToHeatIndexMap(url);
			if (_cachedItemMap.containsKey(url) == false && cache.getBytesLoaded() > 0)
			{
				var content:IReferenceCountable = cache.getContent() as IReferenceCountable;
				if(content != null)
				{
					content.referenceCount += 1;
				}
				_cachedItemMap.put(url, cache);
				arrangeCache();
			}
		}
		
		private function recordToHeatIndexMap(url:String):void
		{
			var entry:HeatIndexMapEntry;
			if(_heatIndexMap.containsKey(url))
			{
				entry = _heatIndexMap.get(url) as HeatIndexMapEntry;
				entry.heatIndex += 1;
				return;
			}
			entry = new HeatIndexMapEntry();
			entry.url = url;
			entry.heatIndex = 1;
			_heatIndexMap.put(url, entry);
		}
		
		private function arrangeCache():void
		{
			if(this.size <= _capacity)
			{
				return;
			}
			var entryArr:Array = _heatIndexMap.getValues();
			entryArr.sort(sortOnHeatIndex);
			var itemToRemoveNum:int = _capacity * CLEAR_CACHE_SIZE_RATIO;
			var itemRemovedNum:int = 0;
			var entryIndex:int = 0;
			while(itemRemovedNum < itemToRemoveNum)
			{
				var entry:HeatIndexMapEntry = entryArr[entryIndex] as HeatIndexMapEntry;
				if(_cachedItemMap.containsKey(entry.url))
				{
					reduceContentReferenceCount(_cachedItemMap.get(entry.url));
					_cachedItemMap.remove(entry.url);
					itemRemovedNum++;
				}
				entryIndex++;
			}
		}
		
		private function reduceContentReferenceCount(loadableItem:ILoadable):void
		{
			var content:IReferenceCountable = loadableItem.getContent() as IReferenceCountable;
			if(content != null)
			{
				content.referenceCount -= 1;
			}
		}
		
		private function sortOnHeatIndex(a:HeatIndexMapEntry, b:HeatIndexMapEntry):int
		{
			if(a.heatIndex > b.heatIndex)
			{
				return 1;
			}
			else if(a.heatIndex < b.heatIndex)
			{
				return -1;
			}
			return 0;
		}
		
		public function hasItem(url:String):Boolean
		{
			return _cachedItemMap.containsKey(url);
		}
		
		public function clear():void
		{
			var loadableItemArr:Array = _cachedItemMap.getValues();
			for each(var loadableItem:ILoadable in loadableItemArr)
			{
				reduceContentReferenceCount(loadableItem);
			}
			_cachedItemMap.clear();
			_heatIndexMap.clear();
		}
	}
}
import com.kramer.resource.events.ResourceEvent;
import com.kramer.resource.item.ILoadable;

class CompleteHandlerWrapper
{
	private var _completeHandler:Function;
	private var _cacheHolderCompleteHandler:Function;
	public function CompleteHandlerWrapper(completeHandler:Function, cacheHolderCompleteHandler:Function)
	{
		_completeHandler = completeHandler;
		_cacheHolderCompleteHandler = cacheHolderCompleteHandler;
	}
	
	public function completeHandler(evt:ResourceEvent):void
	{
		_cacheHolderCompleteHandler(evt);
		_completeHandler(evt);
		_completeHandler = null;
	}
}

class HeatIndexMapEntry
{
	public var url:String;
	public var heatIndex:int;
	
	public function HeatIndexMapEntry()
	{
	}
}