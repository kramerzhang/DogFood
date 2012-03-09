package com.kramer.SharedObject
{
	import flash.net.SharedObject;

	public class SharedObjectManager
	{
		private static const COMMON_FOLDER_NAME:String = "common";
		
		private static var _userName:String = "anonymous";
		
		public static function setUserName(userName:String):void
		{
			_userName = userName;
		}
		
		public static function getCommonSharedObject(name:String):SharedObject
		{
			return SharedObject.getLocal(COMMON_FOLDER_NAME + "/" + name, "/");
		}
		
		public static function getUserSharedObject(name:String):SharedObject
		{
			return SharedObject.getLocal(_userName + "/" + name, "/");
		}
	}
}