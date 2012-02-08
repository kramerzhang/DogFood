package com.kramer.resource.item
{
	/**
	 *@author Kramer 
	 */	
	import flash.events.IEventDispatcher;

	public interface ILoadable extends IEventDispatcher
	{
		function load():void;
		
		function getUrl():String;
		
		function getBytesLoaded():uint;
		
		function getBytesTotal():uint;
		
		function getContent():*;
		
		function getType():String;
		
		function cancel():Boolean;
	}
}