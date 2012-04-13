package com.kramer.IO
{
	import flash.utils.getTimer;

	public class Key
	{
		private var _isDown:Boolean;
		private var _keyCode:int;
		private var _releasedTime:uint;
		private var _pressedTime:uint;
		
		public function Key(keyCode:int)
		{
			_keyCode = keyCode;
		}
		
		public function registerAsUp():void
		{
			if(_isDown == true)
			{
				_isDown = false;
				_releasedTime = getTimer();
			}
		}
		
		public function registerAsDown():void
		{
			if(_isDown == false)
			{
				_isDown = true;
				_pressedTime = getTimer();
			}
		}
		
		public function get isDown():Boolean
		{
			return _isDown;
		}
		
		public function get isReleased():Boolean
		{
			var result:Boolean = _releasedTime > 0;
			_releasedTime = 0;
			return result;
		}
		
		public function get isPressed():Boolean
		{
			var result:Boolean = _pressedTime > 0;
			_pressedTime = 0;
			return result;
		}
		
		public function clear():void
		{
			_isDown = false;
			_pressedTime = 0;
			_releasedTime = 0;
		}
	}
}