package com.kramer.module
{
	import flash.events.IEventDispatcher;
	
	public interface IModuleLoadingBar extends IEventDispatcher
	{
		function show(title:String):void;
		function progress(percent:Number):void;
		function hide():void;
	}
}