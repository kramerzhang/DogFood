package com.kramer.resource.storage
{
	import com.kramer.Config;
	import com.kramer.sharedObject.SharedObjectManager;
	import com.kramer.utils.UrlUtil;
	
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.ByteArray;

	public class FileStorage
	{
		public static const STATE_REJECT:int = 2;
		public static const STATE_ACCEPT:int = 1;
		public static const STATE_SUSPEND:int = 0;
		
		private static const BIG_VOLUME:int = 31457300;
		
		private static const ASSETS_SO_NAME:String = "AssetsVersion";
		
		private static const KEY_VERSION:String = "vresion";
		private static const KEY_STATE:String = "state";
		private static const KEY_DATA:String = "data";
		
		
		private static var _state:int;
		private static var _versionObj:SharedObject;
		
		initialize();
		
		private static function initialize():void
		{
			_state = STATE_SUSPEND;
			_versionObj = SharedObjectManager.getCommonSharedObject(ASSETS_SO_NAME);
			if(_versionObj != null)
			{
				if(_versionObj.data[KEY_VERSION] == null)
				{
					_versionObj.data[KEY_VERSION] = new Object();
				}
				if(_versionObj.data[KEY_STATE] != null)
				{
					_state = _versionObj.data[KEY_STATE];
				}
				else
				{
					_versionObj.data[KEY_STATE] = _state;
				}
			}
		}
		
		private static function isDebugMode():Boolean
		{
			return Config.DEBUG_MODE;
		}
		
		public static function askForStorageSpace():void
		{
			if(_state == STATE_ACCEPT)
			{
				return;
			}
			try
			{
				var result:String = _versionObj.flush(BIG_VOLUME);
				if(result == SharedObjectFlushStatus.PENDING)
				{
					openSettingPanel();
				}
				else
				{
					flushState(STATE_ACCEPT);
				}
			}
			catch(e:Error)
			{
				openSettingPanel();
			}
		}
		
		private static function openSettingPanel():void
		{
			Security.showSettings(SecurityPanel.LOCAL_STORAGE);
			_versionObj.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
		}
		
		private static function onStatus(evt:NetStatusEvent):void
		{
			if(evt.info.code == "SharedObject.Flush.Success")
			{
				flushState(STATE_ACCEPT);
			}
			else if(evt.info.code == "SharedObject.Flush.Failed")
			{
				flushState(STATE_REJECT);
			}
		}
		
		private static function flushState(state:int):void
		{
			_state = state;
			_versionObj.data[KEY_STATE] = _state;
			_versionObj.flush();
		}
		
		public static function getState():int
		{
			return _state;
		}
		
		public static function getFile(url:String):ByteArray
		{
			if(isDebugMode() == true)
			{
				return null;
			}
			var originalUrl:String = UrlUtil.getOriginalUrl(url);
			var soName:String = UrlUtil.getReletiveUrl(originalUrl);
			var ver:int = UrlUtil.getVersionByUrl(url);
			var storedVer:int = _versionObj.data[KEY_VERSION][soName];
			if(ver != storedVer)
			{
				return null;
			}
			var fileSO:SharedObject = SharedObjectManager.getCommonSharedObject(soName);
			if(fileSO != null)
			{
				return fileSO.data[KEY_DATA] as ByteArray;
			}
			return null;
		}
		
		public static function addFile(url:String, file:ByteArray):void
		{
			if(isDebugMode() == true)
			{
				return;
			}
			if(_state != STATE_ACCEPT)
			{
				return;
			}
			var originalUrl:String = UrlUtil.getOriginalUrl(url);
			var soName:String = UrlUtil.getReletiveUrl(originalUrl);
			var ver:int = UrlUtil.getVersionByUrl(url);
			updateFileVersion(soName, ver);
			var fileSO:SharedObject = SharedObjectManager.getCommonSharedObject(soName);
			if(fileSO != null)
			{
				fileSO.data[KEY_DATA] = file;
				fileSO.flush();
			}
		}
		
		private static function updateFileVersion(soName:String, version:int):void
		{
			_versionObj.data[KEY_VERSION][soName] = version;
		}
		
		public static function clearAll():void
		{
			_versionObj.data[KEY_VERSION] = new Object();
		}

	}
}