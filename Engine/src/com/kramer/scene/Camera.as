package com.kramer.scene
{
	import com.kramer.utils.MathUtil;
	
	import flash.geom.Rectangle;

	public class Camera
	{
		private static const OFFSET_X:int = 250;
		private static const OFFSET_Y:int = 150;
		
		private var _x:Number;
		private var _y:Number;
		
		private var _scene:WorldScene;
		private var _viewport:Rectangle;
		
		private var _trackingTarget:ICameraTarget;
		private var _trackingRect:Rectangle;
		
		public function Camera(x:Number, y:Number, worldScene:WorldScene)
		{
			_x = x;
			_y = y;
			_scene = worldScene;
			_viewport = new Rectangle(_x, _y, _scene.screenWidth, _scene.screenHeight);
			_trackingRect = new Rectangle(_x + OFFSET_X, _y + OFFSET_Y, _scene.screenWidth - OFFSET_X * 2, _scene.screenHeight - OFFSET_Y * 2);
		}
		
		public function setViewportSize(width:int, height:int):void
		{
			_viewport.width = width;
			_viewport.height = height;
		}
		
		public function get viewport():Rectangle
		{
			return _viewport;
		}
		
		public function set trackingTarget(value:ICameraTarget):void
		{
			_trackingTarget = value;
		}
		
		public function  get trackingTarget():ICameraTarget
		{
			return _trackingTarget;
		}
		
		public function set x(value:Number):void
		{
			_x = MathUtil.clamp(value, (_scene.sceneWidth - _viewport.width), 0);
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set y(value:Number):void
		{
			_y = MathUtil.clamp(value, (_scene.sceneHeight - _viewport.height), 0);
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function update():void
		{
			if(_trackingTarget != null)
			{
				if(_trackingRect.contains(_trackingTarget.x, _trackingTarget.y) == true)
				{
					return;
				}
				if(_trackingTarget.x < _trackingRect.left)
				{
					x -= (_trackingRect.left - _trackingTarget.x);
				}
				else if(_trackingTarget.x > _trackingRect.right)
				{
					x += (_trackingTarget.x - _trackingRect.right);
				}
				if(_trackingTarget.y < _trackingRect.top)
				{
					y -= (_trackingRect.top - _trackingTarget.y);
				}
				else if(_trackingTarget.y > _trackingRect.bottom)
				{
					y += (_trackingTarget.y - _trackingRect.bottom);
				}
			}
		}
		
	}
}