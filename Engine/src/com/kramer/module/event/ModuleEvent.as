package com.kramer.module.event
{
	import flash.events.Event;
	
	public class ModuleEvent extends Event
	{
		public static const STATE_CHANGE:String = "stateChange";
		
		public var kind:String;
		
		public function ModuleEvent(type:String, kind:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.kind = kind;
		}
	}
}