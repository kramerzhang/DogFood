package com.kramer.entity.events
{
	import flash.events.Event;
	
	public class ActionEvent extends Event
	{
		public static const ACTION_START:String 	= "actionStart";
		public static const ACTION_END:String 		= "actionEnd";
		
		private var _name:String;
		
		public function ActionEvent(type:String, name:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_name = name;
			super(type, bubbles, cancelable);
		}
		
		public function get name():String
		{
			return _name;
		}
	}
}