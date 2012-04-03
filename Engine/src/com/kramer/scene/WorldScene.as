package com.kramer.scene
{
	import flash.display.Sprite;
	
	public class WorldScene extends Sprite
	{
		private var _screenWidth:int;
		private var _screenHeight:int;
		private var _sceneWidth:int;
		private var _sceneHeight:int;

		private var _camera:Camera;
		
		public function WorldScene()
		{
			initialize();
		}
		
		private function initialize():void
		{
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

	}
}