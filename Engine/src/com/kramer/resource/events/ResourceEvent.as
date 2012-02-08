package com.kramer.resource.events
{
	/**
	 *@author Kramer 
	 */	
	import flash.events.Event;
	
	public class ResourceEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		
		private var _content:*;
		
		public function ResourceEvent(type:String, content:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_content = content;
		}
		
		public function get content():*
		{
			return _content;
		}
	}
}