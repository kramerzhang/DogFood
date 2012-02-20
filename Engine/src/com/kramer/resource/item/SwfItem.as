package com.kramer.resource.item
{
	/**
	 *@author Kramer 
	 */	
	import com.kramer.resource.constant.ResourceType;
	import com.kramer.resource.events.ResourceEvent;
	
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public class SwfItem extends BinaryItem implements ILoadable
	{
		protected var _loader:Loader;
		protected var _loaderContext:LoaderContext;
		
		public function SwfItem(url:String, loaderContext:LoaderContext = null)
		{
			super(url);
			_loaderContext = loaderContext;
		}
		
		override protected function parseStream():void
		{
			var byteArr:ByteArray = new ByteArray();
			_streamLoader.readBytes(byteArr);
			_streamLoader.close();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onInternalLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onInternalLoadError);
			_loader.loadBytes(byteArr, _loaderContext);
		}
		
		private function onInternalLoadComplete(evt:Event):void
		{
			removeLoaderInfoEventListener();
			dispatchEvent(new ResourceEvent(ResourceEvent.COMPLETE, getContent()));
		}
		
		private function onInternalLoadError(evt:IOErrorEvent):void
		{
			removeLoaderInfoEventListener();
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
		
		private function removeLoaderInfoEventListener():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onInternalLoadComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onInternalLoadError);
		}
		
		override public function getContent():*
		{
			return _loader.contentLoaderInfo.content;
		}
		
		override public function getType():String
		{
			return ResourceType.SWF;
		}
	}
}