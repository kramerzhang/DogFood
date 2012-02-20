package com.kramer.resource.item
{
	import com.kramer.core.lib_internal;
	import com.kramer.frameSheet.FrameSheet;
	import com.kramer.resource.constant.ResourceType;
	import com.kramer.resource.events.ResourceEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	
	use namespace lib_internal;

	public class FrameSheetItem extends BinaryItem implements ILoadable
	{
		private var _rawData:ByteArray;
		private var _imageLoader:Loader;
		private var _frameSheet:FrameSheet;
		
		public function FrameSheetItem(url:String)
		{
			super(url);
		}
		
		override protected function parseStream():void
		{
			_frameSheet = new FrameSheet();
			_rawData = new ByteArray();
			_streamLoader.readBytes(_rawData);
			_frameSheet.readDescription(_rawData);
			loadImage(_rawData);
		}
		
		private function loadImage(rawData:ByteArray):void
		{
			var imageData:ByteArray = new ByteArray();
			rawData.readBytes(imageData);
			_imageLoader = new Loader();
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onInternalLoadComplete);
			_imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onInternalLoadError);
			_imageLoader.loadBytes(imageData);
		}
		
		private function onInternalLoadComplete(evt:Event):void
		{
			removeLoaderInfoEventListener();
			var loaderInfo:LoaderInfo = evt.target as LoaderInfo;
			var bitmap:Bitmap = loaderInfo.content as Bitmap;
			_frameSheet.setSheetBitmap(bitmap);
			dispatchEvent(new ResourceEvent(ResourceEvent.COMPLETE, getContent()));
		}
		
		private function onInternalLoadError(evt:IOErrorEvent):void
		{
			removeLoaderInfoEventListener();
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "文件格式错误"));
		}
		
		private function removeLoaderInfoEventListener():void
		{
			_imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onInternalLoadComplete);
			_imageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onInternalLoadError);
		}
		
		override public function getContent():*
		{
			return _frameSheet;
		}
		
		override public function getType():String
		{
			return ResourceType.FRAME_SHEET;
		}
	}
}