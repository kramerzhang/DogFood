package com.kramer.entity
{
	import com.kramer.core.IDisposable;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Entity extends Sprite implements IDisposable
	{
		private var _id:int;
		private var _position:Point;
		
		public function Entity()
		{
			initialize();
		}
		
		private function initialize():void
		{
			this.mouseChildren = false;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set position(value:Point):void
		{
			this.x = value.x;
			this.y = value.y;
		}
		
		public function get position():Point
		{
			if(_position == null)
			{
				_position = new Point();
			}
			_position.x = this.x;
			_position.y = this.y;
			return _position;
		}
		
		public function dispose():void
		{
		}
	}
}