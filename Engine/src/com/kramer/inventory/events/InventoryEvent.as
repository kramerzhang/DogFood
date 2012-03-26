package com.kramer.inventory.events
{
	import flash.events.Event;
	
	public class InventoryEvent extends Event
	{
		public static const UPDATE:String = "update";
		
		private var _index:int;
		private var _id:int;
		private var _num:int;
			
		public function InventoryEvent(type:String, index:int, id:int, num:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_index = index;
			_id = id;
			_num = num;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get num():int
		{
			return _num;
		}
		
		override public function clone():Event
		{
			return new InventoryEvent(this.type, _index, _id, _num);
		}
	}
}