package com.kramer.resource.item
{
	/**
	 *@author Kramer 
	 */	
	import com.kramer.resource.constant.ResourceType;
	import com.kramer.resource.events.ResourceEvent;
	
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	[Event(name="progress", type = "flash.events.ProgressEvent")]
	[Event(name="error", type = "flash.events.ErrorEvent")]
	[Event(name="open", type = "flash.events.Event")]
	[Event(name="complete", type = "com.kramer.resource.events.ResourceEvent")]
	public class SoundItem extends EventDispatcher implements ILoadable
	{
		private var _url:String;
		private var _sound:Sound;
		
		public function SoundItem(url:String)
		{
			super(this);
			_url = url;
			initialize();
		}
		
		private function initialize():void
		{
			_sound = new Sound();
		}
		
		public function load():void
		{
			addSoundEventListener();
			var context:SoundLoaderContext = new SoundLoaderContext(20);
			_sound.load(new URLRequest(_url), context);
		}
		
		private function addSoundEventListener():void
		{
			_sound.addEventListener(Event.OPEN, onLoadOpen);
			_sound.addEventListener(Event.COMPLETE, onLoadComplete);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_sound.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
		}
		
		private function removeSoundEventListener():void
		{
			_sound.removeEventListener(Event.OPEN, onLoadOpen);
			_sound.removeEventListener(Event.COMPLETE, onLoadComplete);
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_sound.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
		}
		
		private function onLoadOpen(evt:Event):void
		{
			dispatchEvent(evt.clone());
		}
		
		private function onLoadError(evt:Event):void
		{
			removeSoundEventListener();
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
		
		private function onLoadComplete(evt:Event):void
		{
			removeSoundEventListener();
			dispatchEvent(new ResourceEvent(ResourceEvent.COMPLETE, getContent()));
		}
		
		private function onLoadProgress(evt:ProgressEvent):void
		{
			dispatchEvent(evt.clone() as ProgressEvent);
		}
		
		public function getBytesLoaded():uint
		{
			return _sound.bytesLoaded;
		}
		
		public function getBytesTotal():uint
		{
			return _sound.bytesTotal
		}
		
		public function copyContent(item:ILoadable):void
		{
			var soundItem:SoundItem = item as SoundItem;
			_sound = soundItem._sound;
		}
		
		public function getContent():*
		{
			return _sound;
		}
		
		public function getUrl():String
		{
			return _url;
		}
		
		public function getType():String
		{
			return ResourceType.SOUND;
		}
		
		public function cancel():Boolean
		{
			var result:Boolean = false;
			try
			{
				_sound.close();
				result = true;
			}
			catch(e:IOError)
			{
				//ignore
			}
			return result;
		}
	}
}