package com.kramer.utils
{
	import com.kramer.Config;
	import com.kramer.trove.HashMap;

	public class UrlUtil
	{
		/*
		url with version number: http://www.domain.com/assets/ui/main-2937.swf
		original url:            http://www.domain.com/assets/ui/main.swf	
		*/
		//reserved
		public static const VER_TOKEN:String = "-";
		
		//key: original url, value: version number
		private static var _data:HashMap;
		
		public static function getVersionByUrl(url:String):int
		{
			var lastDotIndex:int = url.lastIndexOf(".");
			var lastTokenIndex:int = url.lastIndexOf(VER_TOKEN);
			return int(url.substring(lastTokenIndex + 1, lastDotIndex));
		}
		
		public static function getVersionByOriginalUrl(originalUrl:String):int
		{
			if(_data == null || _data.get(originalUrl) == null)
			{
				return 0;
			}
			return _data.get(originalUrl);
		}
		
		public static function getOriginalUrl(url:String):String
		{
			var pattern:RegExp =/-\d*?\./;
			return url.replace(pattern, ".");
		}
		
		public static function getReletiveUrl(url:String):String
		{
			return url.substr(Config.ASSETS_PATH.length);
		}
		
		public static function setVersionData(data:HashMap):void
		{
			_data = data;
		}
		
		public static function getUrl(originalUrl:String):String
		{
			if(_data == null || _data.get(originalUrl) == null)
			{
				return originalUrl;
			}
			return insertVersionNumToUrl(originalUrl, _data.get(originalUrl));
		}
		
		public static function insertVersionNumToUrl(originalUrl:String, num:int):String
		{
			var lastDotIndex:int = originalUrl.lastIndexOf(".");
			var posfix:String = originalUrl.substr(lastDotIndex);
			return originalUrl.replace(posfix, VER_TOKEN + num + posfix);	
		}
	}
}