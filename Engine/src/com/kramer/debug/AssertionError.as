package com.kramer.debug
{
	public class AssertionError extends Error
	{
		public function AssertionError(message:String)
		{
			super(message, 250);
		}
	}
}