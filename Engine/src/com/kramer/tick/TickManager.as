package com.kramer.tick
{
	import flash.display.Shape;
	import flash.events.Event;

	public class TickManager
	{
		private static var _instance:TickManager;
		
		private var _isRunning:Boolean;
		private var _tickableVec:Vector.<ITickable>;
		private var _shape:Shape;
		
		public function TickManager(blocker:Blocker)
		{
			initialize();
		}
		
		private function initialize():void
		{
			_tickableVec = new Vector.<ITickable>();
			_shape = new Shape();
			_isRunning = false;
		}
		
		public static function get instance():TickManager
		{
			if(_instance == null)
			{
				_instance = new TickManager(new Blocker());
			}
			return _instance;
		}
		
		public function start():void
		{
			_isRunning = true;
			_shape.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(evt:Event):void
		{
			for each(var obj:ITickable in _tickableVec)
			{
				obj.update();
			}
		}
		
		public function stop():void
		{
			_isRunning = false;
			_shape.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function get isRunning():Boolean
		{
			return _isRunning;
		}
		
		public function attach(tickableObj:ITickable):void
		{
			_tickableVec.push(tickableObj);
		}
		
		public function detach(tickableObj:ITickable):void
		{
			var index:int = _tickableVec.indexOf(tickableObj);
			if(index > -1)
			{
				_tickableVec.splice(index, 1);
			}
		}
	}
}
class Blocker{}