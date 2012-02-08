package com.kramer.entity.events
{
	import flash.events.Event;
	
	public class EntityEvent extends Event
	{
		public static const CONSTRUCTED:String = "constructed";
		
		public function EntityEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}