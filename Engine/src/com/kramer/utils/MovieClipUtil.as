package com.kramer.utils
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class MovieClipUtil
	{
		public function MovieClipUtil(blocker:Blocker)
		{
		}
		
		public static function playToStop(mc:MovieClip, frameNum:int, callback:Function = null):void
		{
			if(mc.currentFrame == frameNum)
			{
				mc.stop();
				if(callback != null)callback();
				return;
			}
			
			mc.play();
			var onEnterFrame:Function = function (evt:Event):void
			{
				var target:MovieClip = evt.target as MovieClip;
				if(target.currentFrame == frameNum)
				{
					mc.stop();
					if(callback != null)callback();
					target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
			mc.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public static function doCallbackAtFrame(mc:MovieClip, frameNum:int, callback:Function, totalExecutetimes:int = 1):void
		{
			var executedTimes:int = 0;
			var onEnterFrame:Function = function (evt:Event):void
			{
				var target:MovieClip = evt.target as MovieClip;
				if(target.currentFrame == frameNum)
				{
					callback();
					executedTimes++;
					if(executedTimes >= totalExecutetimes)
					{
						target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					}
				}
			}
			mc.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}

class Blocker{}