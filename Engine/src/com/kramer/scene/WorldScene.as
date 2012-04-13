package com.kramer.scene
{
	import com.kramer.core.IDisposable;
	import com.kramer.tick.ITickable;
	import com.kramer.tick.TickManager;
	
	import flash.display.Sprite;
	
	public class WorldScene extends Sprite implements ITickable, IDisposable
	{
		private var _screenWidth:int;
		private var _screenHeight:int;
		private var _sceneWidth:int;
		private var _sceneHeight:int;

		private var _camera:Camera;
		
		private var _tickManager:TickManager;
		
		public function WorldScene()
		{
			initialize();
		}
		
		private function initialize():void
		{
			_tickManager = TickManager.instance;
			_tickManager.attach(this);
			_camera = new Camera(0, 0, this);
		}
		
		public function setCameraTarget(cameraTarget:ICameraTarget):void
		{
			_camera.trackingTarget = cameraTarget;
		}
		
		public function set screenWidth(value:int):void
		{
			_screenWidth = value;
		}
		
		public function get screenWidth():int
		{
			return _screenWidth;
		}

		public function set screenHeight(value:int):void
		{
			_screenHeight = value;
		}

		public function get screenHeight():int
		{
			return _screenHeight;
		}
		
		public function get sceneWidth():int
		{
			return _sceneWidth;
		}
		
		public function get sceneHeight():int
		{
			return _sceneHeight;
		}
		
		public function update():void
		{
			
		}
		
		public function dispose():void
		{
			_tickManager.detach(this);
			_tickManager = null;
		}

	}
}