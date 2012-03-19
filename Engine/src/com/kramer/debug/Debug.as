package com.kramer.debug
{
	public class Debug
	{
		public static function assert(expression:Boolean, errorMessage:String):void
		{
			if(expression == false)
			{
				throw new AssertionError(errorMessage);
			}
		}
	}
}