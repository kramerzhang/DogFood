package com.kramer.entity.events
{
	import flash.events.Event;
	
	public class CommandEvent extends Event
	{
		public static const COMMAND:String = "command";

		private var _content:String;
		public function CommandEvent(type:String, content:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_content = content;
			super(type, bubbles, cancelable);
		}
		
		public function get content():String
		{
			return _content;
		}
	}
}