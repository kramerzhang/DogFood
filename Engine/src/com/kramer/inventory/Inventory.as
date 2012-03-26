package com.kramer.inventory
{
	/**
	 * 
	 */	
	import com.kramer.debug.Debug;
	import com.kramer.inventory.events.InventoryEvent;
	import com.kramer.log.LogLevel;
	import com.kramer.log.Logger;
	import com.kramer.trove.HashMap;
	import com.kramer.utils.StringUtil;
	
	import flash.events.EventDispatcher;

	[Event(name="update", type="com.kramer.inventory.events.InventoryEvent")]
	public class Inventory extends EventDispatcher
	{
		protected var _itemFactory:ItemFactory;
		protected var _capacity:int;
		protected var _logger:Logger;
		//keyed by index of item
		protected var _content:HashMap;
		protected var _usedCapacity:int;
		
		public function Inventory(itemFactory:ItemFactory)
		{
			super(this);
			_itemFactory = itemFactory;
			initialize();
		}
		
		private function initialize():void
		{
			_content = new HashMap();
			_logger = Logger.getLogger("Inventory");
			_logger.setLevel(LogLevel.ERROR);
		}
		
		public function set capacity(value:int):void
		{
			_capacity = value;
		}
		
		public function get capacity():int
		{
			return _capacity;
		}
		
		public function get usedCapacity():int
		{
			return _usedCapacity;
		}
		
		public function get availableCapacity():int
		{
			return _capacity - _usedCapacity;
		}
		
		public function isFull():Boolean
		{
			return _capacity > 0 && _usedCapacity >= _capacity;
		}
		
		public function isEmpty():Boolean
		{
			return _usedCapacity == 0;
		}
		
		public function canAddItem(id:int, num:int):Boolean
		{
			var item:Item = _itemFactory.getItem(id);
			var remainNum:int = num;
			remainNum = remainNum - this.availableCapacity * item.maxPackNum;
			if(remainNum <= 0)
			{
				return true;
			}
			var itemArr:Array = _content.getValues();
			for each(item in itemArr)
			{
				if(item.id == id)
				{
					remainNum = remainNum - (item.maxPackNum - item.num);
					if(remainNum <= 0)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		//add item according to server, do data verification in server side
		public function updateItem(index:int, id:int, num:int, canDispatchEvent:Boolean = true):void
		{
			var item:Item = _content.get(index);
			if(item != null)
			{
				item.num = num;
				if(num == 0)
				{
					_content.remove(index);
					_usedCapacity--;
				}
			}
			else
			{
				item = _itemFactory.getItem(id);
				item.num = num;
				_content.put(index, item);
				_usedCapacity++;
			}
			_logger.info(StringUtil.format("update at index:%d, id:%d, num:%d", index, id, num));
			if(canDispatchEvent == true)
			{
				dispatchInventoryEvent(InventoryEvent.UPDATE, index, id, num);
			}
		}
		
		protected function dispatchInventoryEvent(type:String, index:int, id:int, num:int):void
		{
			if(hasEventListener(type))
			{
				dispatchEvent(new InventoryEvent(type, index, id, num));
			}
		}
		
		public function hasItem(id:int):Boolean
		{
			return getItemNum(id) > 0;
		}
		
		public function getItemNum(id:int):int
		{
			var num:int = 0;
			var itemArr:Array = _content.getValues();
			for each(var item:Item in itemArr)
			{
				if(item.id == id)
				{
					num += item.num;
				}
			}
			return num;
		}
		
		public function getItemByIndex(index:int):Item
		{
			Debug.assert((index >= 0 && index < _capacity), "index out of ranage");
			return _content.get(index);
		}
		
		public function getContent():Vector.<Item>
		{
			return Vector.<Item>(_content.getValues());
		}
	}
}