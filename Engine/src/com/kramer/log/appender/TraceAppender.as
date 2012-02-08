package com.kramer.log.appender
{
	import com.kramer.log.IAppender;

	/**
	 *@author Kramer 
	 */	
	public class TraceAppender implements IAppender
	{
		public function TraceAppender()
		{
		}
		
		public function append(msg:String):void
		{
			trace(msg);
		}
	}
}