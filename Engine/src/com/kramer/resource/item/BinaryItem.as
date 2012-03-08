package com.kramer.resource.item
{
	/**
	 *@author Kramer 
	 */	
	import com.kramer.resource.constant.ResourceType;
	import com.kramer.resource.events.ResourceEvent;
	import com.kramer.resource.storage.FileStorage;
	
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	[Event(name="progress", type = "flash.events.ProgressEvent")]
	[Event(name="error", type = "flash.events.ErrorEvent")]
	[Event(name="open", type = "flash.events.Event")]
	[Event(name="complete", type = "com.kramer.resource.events.ResourceEvent")]
	public class BinaryItem extends EventDispatcher implements ILoadable
	{
		protected var _url:String;
		protected var _streamLoader:URLStream;
		
		protected var _content:ByteArray;
		protected var _bytesLoaded:uint;
		protected var _bytesTotal:uint;
		
		public function BinaryItem(url:String)
		{
			super(this);
			_url = url;
		}
		
		public function load():void
		{
			_content = FileStorage.getFile(_url);
			if(_content == null)
			{
				_streamLoader = new URLStream();
				addLoaderEventListener();
				_streamLoader.load(new URLRequest(_url));
			}
			else
			{
				parseStream();
			}
		}
		
		private function addLoaderEventListener():void
		{
			_streamLoader.addEventListener(Event.OPEN, onLoadOpen);
			_streamLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_streamLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			_streamLoader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_streamLoader.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		private function removeLoaderEventListener():void
		{
			_streamLoader.removeEventListener(Event.OPEN, onLoadOpen);
			_streamLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_streamLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			_streamLoader.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_streamLoader.removeEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		private function onLoadOpen(evt:Event):void
		{
			dispatchEvent(evt.clone());
		}
		
		private function onLoadError(evt:Event):void
		{
			removeLoaderEventListener();
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "文件未找到"));
		}
		
		private function onLoadProgress(evt:ProgressEvent):void
		{
			_bytesLoaded = evt.bytesLoaded;
			_bytesTotal = evt.bytesTotal;
			dispatchEvent(evt.clone() as ProgressEvent);
		}
		
		private function onLoadComplete(evt:Event):void
		{
			removeLoaderEventListener();
			readContent();
			parseStream();
			storeContent();
		}
		
		private function readContent():void
		{
			_content = new ByteArray();
			_streamLoader.readBytes(_content);
			_streamLoader.close();
		}
		
		private function storeContent():void
		{
			FileStorage.addFile(_url, _content);
		}
		
		protected function parseStream():void
		{
			dispatchEvent(new ResourceEvent(ResourceEvent.COMPLETE, getContent()));
		}
		
		public function getUrl():String
		{
			return _url;
		}
		
		public function getBytesLoaded():uint
		{
			return _bytesLoaded;
		}
		
		public function getBytesTotal():uint
		{
			return _bytesTotal;
		}
		
		public function copyContent(item:ILoadable):void
		{
			var binaryItem:BinaryItem = item as BinaryItem;
			var source:ByteArray = binaryItem._content;
			var sourcePostion:int = source.position;
			source.position = 0;
			_content = new ByteArray();
			source.readBytes(_content);
			source.position = sourcePostion;
			dispatchEvent(new ResourceEvent(ResourceEvent.COMPLETE, getContent()));
		}
		
		public function getContent():*
		{
			return _content;
		}
		
		public function getType():String
		{
			return ResourceType.BINARY;
		}
		
		public function cancel():Boolean
		{
			var result:Boolean = false;
			try
			{
				if(_streamLoader.connected)
				{
					_streamLoader.close();
					result = true;
				}
			}
			catch(e:IOError)
			{
				//ignore
			}
			return result;
		}
	}
}