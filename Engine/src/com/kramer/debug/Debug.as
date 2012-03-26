package com.kramer.debug
{
	import flash.debugger.enterDebugger;

	public class Debug
	{
		public static function assert(condition:Boolean, errorMessage:String, enterDebuggerMode:Boolean = false):void
		{
			if(condition == false)
			{
				if(enterDebuggerMode == true)
				{
					enterDebugger();
				}
				throw new AssertionError(errorMessage);
			}
		}
	}
}