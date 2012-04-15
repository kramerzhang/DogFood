package com.kramer.trigger
{
	import flash.events.Event;

	public interface ITrigger
	{
		function get eventType():String;
		function get priority():int;
		
		function setEvent(evt:Event):void;
		function testCondition():Boolean;
		function doAction():void;
	}
}