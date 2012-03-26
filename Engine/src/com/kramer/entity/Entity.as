package com.kramer.entity
{
	import com.kramer.core.IDisposable;
	import com.kramer.scene.ICameraTarget;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Entity extends Sprite implements IDisposable, ICameraTarget
	{
		private var _id:int;
		private var _ignoreUpdate:Boolean;
		
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
		
		public function set ignoreUpdate(value:Boolean):void
		{
			_ignoreUpdate = value;
		}
		
		public function get ignoreUpdate():Boolean
		{
			return _ignoreUpdate;
		}
		
		public function update(currentTime:int):void
		{
			
		}
		
		public function dispose():void
		{
		}
	}
}