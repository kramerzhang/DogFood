package com.kramer.resource.storage
{
	import com.kramer.SharedObject.SharedObjectManager;
	
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.system.Security;
	import flash.system.SecurityPanel;

	public class FileStorage
	{
		private static const BIG_VOLUME:int = 1024 * 1024;
		
		private static const STATE_REJECT:int = 2;
		private static const STATE_ACCEPT:int = 1;
		private static const STATE_SUSPEND:int = 0;
		
		private static var _state:int;
		private static var _versionObj:SharedObject;
		
		initialize();
		
		private static function initialize():void
		{
			_state = STATE_SUSPEND;
			_versionObj = SharedObjectManager.getCommonSharedObject("AssetsVersion");
			if(_versionObj.data["version"] == null)
			{
				_versionObj.data["version"] = new Object();
			}
			if(_versionObj.data["state"] != null)
			{
				_state = _versionObj.data["state"];
			}
			else
			{
				_versionObj.data["state"] = _state;
			}
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
			_versionObj.data["state"] = _state;
		}
	}
}