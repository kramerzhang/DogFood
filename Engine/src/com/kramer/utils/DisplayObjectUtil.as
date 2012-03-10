package com.kramer.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.filters.ColorMatrixFilter;

	public class DisplayObjectUtil
	{
		public static function removeFromParent(displayObj:DisplayObject):void
		{
			if(displayObj != null && displayObj.parent != null)
			{
				displayObj.parent.removeChild(displayObj);
			}
		}
		
		public static function disableDisplayObject(displayObj:DisplayObject):void
		{
			if(displayObj is InteractiveObject)
			{
				(displayObj as InteractiveObject).mouseEnabled = false;
			}
			if(displayObj is DisplayObjectContainer)
			{
				(displayObj as DisplayObjectContainer).mouseChildren = false;
			}
			if(displayObj is SimpleButton)
			{
				(displayObj as SimpleButton).enabled = false;
			}
		}
		
		public static function enableDisplayObject(displayObj:DisplayObject):void
		{
			if(displayObj is InteractiveObject)
			{
				(displayObj as InteractiveObject).mouseEnabled = true;
			}
			if(displayObj is DisplayObjectContainer)
			{
				(displayObj as DisplayObjectContainer).mouseChildren = true;
			}
			if(displayObj is SimpleButton)
			{
				(displayObj as SimpleButton).enabled = true;
			}
		}
		
		public static function grayDisplayObject(displayObj:DisplayObject):void
		{
			var grayParam:Array = [0.33, 0.33, 0.33, 0, 0,
								   0.33, 0.33, 0.33, 0, 0,
								   0.33, 0.33, 0.33, 0, 0,
								   0, 0, 1, 0];
			var grayFilter:ColorMatrixFilter = new ColorMatrixFilter(grayParam);
			displayObj.filters = [grayFilter];
		}
		
		public static function ungrayDisplayObject(displayObj:DisplayObject):void
		{
			displayObj.filters = null;
		}
	}
}