package com.kramer.debug
{
	import flash.debugger.enterDebugger;

	public class Debug
	{
		public static function assert(condition:Boolean, errorMessage:String, enterDebugger:Boolean = false):void
		{
			if(condition == false)
			{
				if(enterDebugger == true)
				{
					enterDebugger();
				}
				throw new AssertionError(errorMessage);
			}
		}
	}
}