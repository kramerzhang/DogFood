package com.kramer.animation
{
	import com.kramer.core.IDisposable;
	import com.kramer.frameSheet.Frame;
	import com.kramer.trove.HashMap;
	
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	public interface IAnimation extends IEventDispatcher, IDisposable
	{
		function set resourceUrl(value:String):void;
		function get resourceUrl():String;
		//帧编号，和MoiveClip习惯保持一致，从1开始
		function get totalFrameNum():int;
		function get currentFrameNum():int;
		
		function get currentFrame():Frame;
		
		function get currentLabel():String;
		function get frameLabelMap():HashMap;

		function play():void;
		function stop():void;
		
		function gotoAndPlay(frame:Object):void;
		function gotoAndStop(frame:Object):void;
		function setLoopRange(startNum:int, endNum:int):void;
		
		function set delay(value:int):void;
		function get delay():int;
		
		function step(currentTime:int):void;
		
	}
}