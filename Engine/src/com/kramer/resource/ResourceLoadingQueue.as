package com.kramer.resource
{
	import com.kramer.core.IDisposable;
	import com.kramer.debug.Debug;
	import com.kramer.resource.item.ILoadable;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	[Event(name="progress", type = "flash.events.ProgressEvent")]
	[Event(name="error", type = "flash.events.ErrorEvent")]
	[Event(name="open", type = "flash.events.Event")]
	[Event(name="complete", type = "flash.events.Event")]
	public class ResourceLoadingQueue extends EventDispatcher implements IDisposable
	{
		private var _itemQueue:Vector.<ILoadable>;
		private var _isStart:Boolean;
		private var _itemTotalNum:int;
		private var _itemLoadedNum:int;
		private var _activeItem:ILoadable;
		
		public function ResourceLoadingQueue()
		{
			super(this);
			initialize();
		}
		
		private function initialize():void
		{
			_itemQueue = new Vector.<ILoadable>();
			_isStart = false;
		}
		
		public function addLoadableItem(item:ILoadable):void
		{
			Debug.assert(_isStart ==  false, "Can't add item after loading start");
			_itemQueue.push(item);
		}
		
		public function start():void
		{
			if(_isStart == true)return;
			Debug.assert(_itemQueue.length > 0, "no item in queue to load");
			_itemTotalNum = _itemQueue.length;
			_isStart = true;
			if(hasEventListener(Event.OPEN))
			{
				dispatchEvent(new Event(Event.OPEN));
			}
			loadNextItem();
		}
		
		private function loadNextItem():void
		{
			_activeItem = _itemQueue.shift();
			addActiveItemEventListener(_activeItem);
			_activeItem.load();
		}
		
		private function addActiveItemEventListener(item:ILoadable):void
		{
			item.addEventListener(ErrorEvent.ERROR, onItemError);
			item.addEventListener(ProgressEvent.PROGRESS, onItemProgress);
			item.addEventListener(Event.COMPLETE, onItemComplete);
		}
		
		private function onItemError(evt:ErrorEvent):void
		{
			if(hasEventListener(ErrorEvent.ERROR))
			{
				dispatchEvent(evt.clone());
			}
		}
		
		private function onItemProgress(evt:ProgressEvent):void
		{
			if(hasEventListener(ProgressEvent.PROGRESS))
			{
				var bytesLoaded:Number = _itemLoadedNum/_itemTotalNum * 100 
					+ _activeItem.getBytesLoaded() / _activeItem.getBytesTotal() / _itemTotalNum * 100;
				var bytesTotal:Number = 100;
				var progressEvent:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal);
				dispatchEvent(progressEvent);
			}
		}
		
		private function onItemComplete(evt:Event):void
		{
			_itemLoadedNum++;
			removeActiveItemEventListener(_activeItem);
			if(_itemLoadedNum >= _itemTotalNum)
			{
				if(hasEventListener(Event.COMPLETE))
				{
					dispatchEvent(evt.clone());
				}
				dispose();
			}
			else
			{
				loadNextItem();
			}
		}
		
		private function removeActiveItemEventListener(item:ILoadable):void
		{
			item.removeEventListener(ErrorEvent.ERROR, onItemError);
			item.removeEventListener(ProgressEvent.PROGRESS, onItemProgress);
			item.removeEventListener(Event.COMPLETE, onItemComplete);
		}
	
		public function dispose():void
		{
			_activeItem = null;
			_itemQueue = null;
		}
	}
}