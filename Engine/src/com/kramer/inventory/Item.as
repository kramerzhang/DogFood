package com.kramer.inventory
{
	/**
	 * 
	 * @author Kramer
	 * 
	 * 
	 */	
	public class Item
	{
		private var _id:int;
		private var _index:uint;
		private var _name:String;
		private var _num:int;
		private var _maxPackNum:int;
		private var _isLocked:Boolean;
		
		public function Item(id:int)
		{
			_id = id;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set num(value:int):void
		{
			_num = value;
		}
		
		public function get num():int
		{
			return _num;
		}
		
		public function set maxPackNum(value:int):void
		{
			_maxPackNum = value;
		}
		
		public function get maxPackNum():int
		{
			return _maxPackNum;
		}
		
		public function set isLocked(value:Boolean):void
		{
			_isLocked = value;
		}
		
		public function get isLocked():Boolean
		{
			return _isLocked;
		}
				
		public function get iconUrl():String
		{
			throw new Error("Should be implemented in sub class!");
		}
		
		public function clone():Item
		{
			throw new Error("Should be implemented in sub class!");
		}
		
		public function toString():String
		{
			return "Name:" + _name + " index: " + _index + " Id: " + _id + " Num: " + _num;
		}
	}
}