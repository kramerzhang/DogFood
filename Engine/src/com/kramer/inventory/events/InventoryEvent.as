package com.kramer.inventory.events
{
	import flash.events.Event;
	
	public class InventoryEvent extends Event
	{
		public static const UPDATE:String = "UPDATE";
		
		private var _index:int;
		private var _id:int;
			
		public function InventoryEvent(type:String, index:int, id:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_index = index;
			_id = id;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		override public function clone():Event
		{
			return new InventoryEvent(this.type, _index, _id);
		}
	}
}