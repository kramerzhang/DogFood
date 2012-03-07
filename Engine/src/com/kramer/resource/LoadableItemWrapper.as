package com.kramer.resource
{
	/**
	 *@author Kramer 
	 */	
	import com.kramer.core.IDisposable;
	import com.kramer.resource.events.ResourceEvent;
	import com.kramer.resource.item.ILoadable;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;

	public class LoadableItemWrapper implements IDisposable
	{
		private var _item:ILoadable;
		private var _completeHandler:Function;
		private var _startHandler:Function;
		private var _progressHandler:Function;
		private var _errorHandler:Function;
		private var _priority:int;
		
		public function LoadableItemWrapper(item:ILoadable, 
											completeHandler:Function, 
											startHandler:Function, 
											progressHandler:Function, 
											errorHandler:Function, 
											priority:int)
		{
			_item = item;
			_completeHandler = completeHandler;
			_startHandler = startHandler;
			_progressHandler = progressHandler;
			_errorHandler = errorHandler;
			_priority = priority;
			addItemEventListener();
		}
		
		public function get item():ILoadable
		{
			return _item;
		}
		
		public function get completeHandler():Function
		{
			return _completeHandler;
		}
		
		public function get startHandler():Function
		{
			return _startHandler;
		}
		
		public function get progressHandler():Function
		{
			return _progressHandler;
		}
		
		public function get errorHandler():Function
		{
			return _errorHandler;
		}
		
		public function get priority():int
		{
			return _priority;
		}
		
		private function addItemEventListener():void
		{
			if(_completeHandler != null)
			{
				_item.addEventListener(ResourceEvent.COMPLETE, _completeHandler, false, 1);
			}
			if(_startHandler != null)
			{
				_item.addEventListener(Event.OPEN, _startHandler, false, 1);
			}
			if(_progressHandler != null)
			{
				_item.addEventListener(ProgressEvent.PROGRESS, _progressHandler, false, 1);
			}
			if(_errorHandler != null)
			{
				_item.addEventListener(ErrorEvent.ERROR, _errorHandler, false, 1);
			}
		}
		
		private function removeItemEventListener():void
		{
			if(_completeHandler != null)
			{
				_item.removeEventListener(ResourceEvent.COMPLETE, _completeHandler);
			}
			if(_startHandler != null)
			{
				_item.removeEventListener(Event.OPEN, _startHandler);
			}
			if(_progressHandler != null)
			{
				_item.removeEventListener(ProgressEvent.PROGRESS, _progressHandler);
			}
			if(_errorHandler != null)
			{
				_item.removeEventListener(ErrorEvent.ERROR, _errorHandler);
			}
		}
		
		public function fireItemLoadStartEvent():void
		{
			_item.dispatchEvent(new Event(Event.OPEN));
		}
		
		public function fireItemLoadErrorEvent():void
		{
			_item.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			dispose();
		}
		
		public function fireItemLoadProgressEvent(bytesLoaded:Number, bytesTotal:Number):void
		{
			_item.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
		}
		
		public function copyContent(item:ILoadable):void
		{
			_item.copyContent(item);
		}
		
		public function dispose():void
		{
			removeItemEventListener();
			_item = null;
			_completeHandler = null;
			_startHandler = null;
			_progressHandler = null;
			_errorHandler = null;
		}
	}
}