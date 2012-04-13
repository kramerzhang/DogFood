package com.kramer
{
	import com.kramer.module.ModuleManager;
	import com.kramer.objectProxy.ObjectProxy;
	import com.kramer.scene.WorldScene;
	import com.kramer.tick.TickManager;
	
	import flash.display.Stage;

	public class GameWorld
	{
		private var _stage:Stage;
		private var _info:ObjectProxy;
		private var _scene:WorldScene;
		private var _screenWidth:int;
		private var _screenHeight:int;
		
		public function GameWorld(stage:Stage)
		{
			_stage = stage;
			initialize();
		}
		
		private function initialize():void
		{
			_info = new ObjectProxy();
		}
		
		public function get info():ObjectProxy
		{
			return _info;
		}
		
		public function get stage():Stage
		{
			return _stage;
		}
		
		public function get screenWidth():int
		{
			return _screenWidth;
		}
		
		public function get screenHeight():int
		{
			return _screenHeight;
		}
	}
}