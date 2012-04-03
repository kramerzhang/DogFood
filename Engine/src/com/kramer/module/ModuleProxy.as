package com.kramer.module
{
	import com.kramer.GameWorld;
	import com.kramer.module.event.ModuleEvent;
	import com.kramer.module.event.ModuleEventKind;
	import com.kramer.resource.ResourceManager;
	import com.kramer.resource.events.ResourceEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	public class ModuleProxy extends EventDispatcher
	{
		private static const STATE_LOADING:String 		= "loading";
		private static const STATE_SHOWING:String		= "showing";
		private static const STATE_HIDE:String 			= "hide";
		private static const STATE_ERROR:String 		= "error";
		private static const STATE_CANCELLED:String		= "cancelled";
		private var _state:String;
		
		private var _url:String;
		private var _loaderTitle:String;
		private var _module:Module;
		private var _moduleInitData:Object;
		private var _loadingBar:IModuleLoadingBar;
		private var _gameWorld:GameWorld;
		private var _loadingBarClz:Class;
		
		public function ModuleProxy(url:String, loaderTitle:String, gameWorld:GameWorld, loadingBarClz:Class)
		{
			super(this);
			_url = url;
			_loaderTitle = loaderTitle;
			_state = STATE_LOADING;
			_gameWorld = gameWorld;
			_loadingBarClz = loadingBarClz;
		}
		
		private function startLoad():void
		{
			_state = STATE_LOADING;
			dispatchStateChangEvent(ModuleEventKind.LOADING);
			ResourceManager.loadDLLSwf(_url, onLoadComplete, onLoadError, onLoadStart, onLoadProgress);
		}
		
		private function onLoadStart(evt:Event):void
		{
			_loadingBar = new _loadingBarClz() as IModuleLoadingBar
			_loadingBar.show(_loaderTitle);	
		}
		
		private function onLoadProgress(evt:ProgressEvent):void
		{
			var percent:int = Math.ceil((evt.bytesLoaded / evt.bytesTotal) * 100);
			_loadingBar.progress(percent);
		}
		
		private function onLoadError(evt:ErrorEvent):void
		{
			_state = STATE_ERROR;
			dispatchStateChangEvent(ModuleEventKind.ERROR);
		}
		
		private function onLoadComplete(evt:ResourceEvent):void
		{
			_loadingBar.hide();
			_module = evt.content as Module;
			_module.gameWorld = _gameWorld;
			doShowModule();
		}
		
		public function get module():Module
		{
			return _module;
		}
		
		public function show(data:Object = null):void
		{
			_moduleInitData = data;
			if(_module != null)
			{
				doShowModule();
			}
			else
			{
				startLoad();
			}
		}
		
		private function doShowModule():void
		{
			_module.data = _moduleInitData;
			_module.show();
			_state = STATE_SHOWING;
			_moduleInitData = null;
			dispatchStateChangEvent(ModuleEventKind.SHOWING);
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get isLoading():Boolean
		{
			return _state == STATE_LOADING;
		}
		
		public function get isShowing():Boolean
		{
			return _state == STATE_SHOWING;
		}
		
		public function get isHide():Boolean
		{
			return _state == STATE_HIDE;
		}
		
		public function cancel():void
		{
			if(_state == STATE_LOADING)
			{
				_loadingBar.hide();
				ResourceManager.cancel(_url, onLoadComplete);
				dispatchStateChangEvent(ModuleEventKind.CANCELLED);
			}
		}
		
		public function hide():void
		{
			_module.hide();
			_state = STATE_HIDE;
			dispatchStateChangEvent(ModuleEventKind.HIDE);
		}
		
		private function dispatchStateChangEvent(eventKind:String):void
		{
			if(hasEventListener(ModuleEvent.STATE_CHANGE) == true)
			{
				dispatchEvent(new ModuleEvent(ModuleEvent.STATE_CHANGE, eventKind));
			}
		}
	}
}