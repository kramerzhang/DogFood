package com.kramer.physics
{
	public class Vector2D
	{
		private var _x:Number;
		private var _y:Number;
		
		public function Vector2D(x:Number, y:Number)
		{
			_x = x;
			_y = y;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function get length():Number
		{
			return Math.sqrt(_x * _x + _y * _y);
		}
		
		public function normalize():Number
		{
			var tempLen:Number = length;
			_x /= tempLen;
			_y /= tempLen;
			return length;
		}
		
		public function add(vec:Vector2D):Vector2D
		{
			return new Vector2D(_x + vec._x, _y + vec._y);
		}
		
		public function incrementBy(vec:Vector2D):void
		{
			_x += vec._x;
			_y += vec._y;
		}
		
		public function subtract(vec:Vector2D):Vector2D
		{
			return new Vector2D(_x - vec._x, _y - vec._y);
		}
		
		public function decrementBy(vec:Vector2D):void
		{
			_x -= vec._x;
			_y -= vec._y;
		}
		
		public function scaleBy(k:Number):void
		{
			_x *= k;
			_y *= k;
		}
		
		public function dotProduct(vec:Vector2D):Number
		{
			return _x * vec._x + _y * vec._y;
		}
		
		public function clone():Vector2D
		{
			return new Vector2D(_x, _y);
		}
		
		public static function distance(vec0:Vector2D, vec1:Vector2D):Number
		{
			return vec0.subtract(vec1).length;
		}
		
		public static function angleBetween(vec0:Vector2D, vec1:Vector2D):Number
		{
			return Math.acos(vec0.dotProduct(vec1)/(vec0.length * vec1.length));
		}
		
	}
}