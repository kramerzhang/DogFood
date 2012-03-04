package com.kramer.manager
{
	/*
	注意：在使用attach添加定时轮询时，在使用对象释放资源时必须显式使用detach方法释放对callback的引用，
	否则会引起内存泄漏
	*/
	import com.kramer.trove.HashMap;
	
	import flash.events.TimerEvent;
	import flash.sampler.DeleteObjectSample;
	import flash.utils.Timer;

	public class TimerManager
	{
		private static var _timerMap:HashMap;
		private static var _callbackMap:HashMap;
		
		initialize();
		private static function initialize():void
		{
			_timerMap = new HashMap();
			_callbackMap = new HashMap();
		}
		
		public static function attach(interval:int, callback:Function):void
		{
			var timer:Timer = getTimer(interval);
			var callbackVec:Vector.<Function> = getCallbackVec(timer);
			callbackVec.push(callback);
		}
		
		private static function getTimer(interval:int):Timer
		{
			if(_timerMap.get(interval) == null)
			{
				var timer:Timer = new Timer(interval);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
				_timerMap.put(interval, timer);
			}
			return _timerMap.get(interval);
		}
		
		private static function getCallbackVec(timer:Timer):Vector.<Function>
		{
			if(_callbackMap.get(timer) == null)
			{
				var vec:Vector.<Function> = new Vector.<Function>();
				_callbackMap.put(timer, vec);
			}
			return _callbackMap.get(timer);
		}
		
		private static function onTimer(evt:TimerEvent):void
		{
			var timer:Timer = evt.target as Timer;
			var callbackVec:Vector.<Function> = getCallbackVec(timer);
			for each(var callback:Function in callbackVec)
			{
				callback();
			}
		}
		
		public static function detach(callback:Function):void
		{
			var keyArr:Array = _callbackMap.getKeys();
			var len:int = keyArr.length;
			for(var i:int = 0; i < len; i++)
			{
				var timer:Timer = keyArr[i];
				var vec:Vector.<Function> = _callbackMap.get(timer);
				var index:int = vec.indexOf(callback);
				if(index > -1)
				{
					vec.splice(index, 1);
					if(vec.length == 0)
					{
						timer.removeEventListener(TimerEvent.TIMER, onTimer);
						timer.stop();
						_callbackMap.remove(timer);
					}
					break;
				}
			}
		}
	}
}