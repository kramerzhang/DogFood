package com.kramer.resource.item
{
	/**
	 *@author Kramer 
	 */	
	import com.kramer.resource.ResourceType;
	import com.kramer.resource.events.ResourceEvent;
	
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
			initialize();
		}
		
		private function initialize():void
		{
			_streamLoader = new URLStream();
		}
		
		public function load():void
		{
			addLoaderEventListener();
			_streamLoader.load(new URLRequest(_url));
		}
		
		private function addLoaderEventListener():void
		{
			_streamLoader.addEventListener(Event.OPEN, onLoadOpen);
			_streamLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_streamLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			_streamLoader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_streamLoader.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		private function onLoadOpen(evt:Event):void
		{
			dispatchEvent(evt.clone());
		}
		
		private function onLoadError(evt:Event):void
		{
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
			parseStream();
		}
		
		protected function parseStream():void
		{
			_content = new ByteArray();
			_streamLoader.readBytes(_content);
			_streamLoader.close();
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