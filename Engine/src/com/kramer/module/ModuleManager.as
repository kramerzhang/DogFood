package com.kramer.module
{
	import com.kramer.GameWorld;
	import com.kramer.log.Logger;
	import com.kramer.module.event.ModuleEvent;
	import com.kramer.module.event.ModuleEventKind;
	import com.kramer.trove.HashMap;
	
	import flash.events.MouseEvent;

	public class ModuleManager
	{
		private static var _logger:Logger;
		private static var _moduleMap:HashMap;
		
		//class should implement IModuleLoadingBar
		private static var _loadingBarClz:Class;
		private static var _gameWorld:GameWorld;
		
		public function ModuleManager(blocker:Blocker)
		{
		}
		
		public static function initialize(gameWorld:GameWorld, loadingBarClz:Class):void
		{
			_gameWorld = gameWorld;
			_loadingBarClz = loadingBarClz;
			_moduleMap = new HashMap();
			_logger = Logger.getLogger("ModuleManager");
		}
		
		public static function containsModule(url:String):Boolean
		{
			return _moduleMap.containsKey(url);
		}
		
		public static function isShowingModule(url:String):Boolean
		{
			var moduleProxy:ModuleProxy = getModule(url);
			if(moduleProxy == null)
			{
				return false;
			}
			return moduleProxy.isShowing;
		}
		
		public static function showModule(url:String, loaderTitle:String, data:Object = null):ModuleProxy
		{
			var moduleProxy:ModuleProxy = _moduleMap.get(url) as ModuleProxy;
			if(moduleProxy == null)
			{
				moduleProxy = createModule(url, loaderTitle);
			}
			moduleProxy.show(data);
			return moduleProxy;
		}
		
		public static function toggleModule(url:String, loaderTitle:String, data:Object = null):ModuleProxy
		{
			var moduleProxy:ModuleProxy = _moduleMap.get(url) as ModuleProxy;
			if(moduleProxy != null)
			{
				if(moduleProxy.isShowing == true)
				{
					moduleProxy.hide();
				}
				else
				{
					moduleProxy.show(data);
				}
			}
			else
			{
				moduleProxy = createModule(url, loaderTitle);
				moduleProxy.show(data);
			}
			return moduleProxy;
		}
		
		private static function createModule(url:String, loaderTitle:String):ModuleProxy
		{
			var moduleProxy:ModuleProxy = new ModuleProxy(url, loaderTitle, _gameWorld, _loadingBarClz);
			moduleProxy.addEventListener(ModuleEvent.STATE_CHANGE, onModuleStateChange);
			_moduleMap.put(url, moduleProxy);
			return moduleProxy;
		}
		
		private static function onModuleStateChange(evt:ModuleEvent):void
		{
			if(evt.kind == ModuleEventKind.ERROR)
			{
				var url:String = (evt.target as ModuleProxy).url;
				_logger.error("Module load error: " + url);
				removeModuleByUrl(url);
			}
		}
		
		public static function getModule(url:String):ModuleProxy
		{
			return _moduleMap.get(url) as ModuleProxy;
		}
		
		public static function cancelModule(url:String):void
		{
			var moduleProxy:ModuleProxy = _moduleMap.get(url) as ModuleProxy;
			if(moduleProxy != null)
			{
				moduleProxy.cancel();
			}
		}
		
		public static function hideModule(url:String):void
		{
			var moduleProxy:ModuleProxy = _moduleMap.get(url) as ModuleProxy;
			if(moduleProxy != null)
			{
				moduleProxy.hide();
			}
		}
		
		public static function hideAllModule(url:String):void
		{
			for each(var moduleProxy:ModuleProxy in _moduleMap.getValues())
			{
				if(moduleProxy.isShowing == true)
				{
					moduleProxy.hide();
				}
				else if(moduleProxy.isLoading == true)
				{
					moduleProxy.cancel();
				}
			}
		}
		
		private static function removeModuleByUrl(url:String):void
		{
			if(containsModule(url) == true)
			{
				_moduleMap.remove(url);
			}
		}
		
	}
}
class Blocker{}