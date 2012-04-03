package com.kramer.scene
{
	import flash.display.Sprite;

	public class LayerManager
	{
		private static var _module:Sprite;
		
		public static function get module():Sprite
		{
			if(_module == null)
			{
				_module = new Sprite();
				_module.mouseEnabled = false;
			}
			return _module;
		}
	}
}