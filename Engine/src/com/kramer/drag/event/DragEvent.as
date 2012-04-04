package com.kramer.drag.event
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class DragEvent extends Event
	{
		public static const DRAG_START:String	= "dragStart";
		public static const DRAG_STOP:String 	= "dragStop";
		
		public var source:DisplayObject;
		public var identifier:String;
		
		public function DragEvent(type:String, source:DisplayObject, identifier:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.source = source;
			this.identifier = identifier;
		}
	}
}