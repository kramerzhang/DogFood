package com.kramer.frameSheet
{
	import com.kramer.core.IDisposable;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Frame implements IDisposable
	{
		//关键帧编号
		private var _keyNum:uint;
		//帧的宽高
		private var _size:Rectangle;
		//帧注册点相对于帧左上角坐标值
		private var _anchor:Point;
		//帧上可视范围相对帧左上角的偏移量
		private var _contentOffset:Point;
		//帧上附带的命令
		private var _command:FrameCommand;
		//记录frame在framesheet中的位置，绘制时使用
		private var _matrix:Matrix;
		
		public function Frame(keyNum:int, size:Rectangle, anchor:Point, contentOffset:Point, matrix:Matrix)
		{
			_keyNum = keyNum;
			_size = size;
			_anchor = anchor;
			_contentOffset = contentOffset;
			_matrix = matrix;
		}
		
		public function get keyNum():int
		{
			return _keyNum;
		}

		public function get size():Rectangle
		{
			return _size;
		}
		
		public function get anchor():Point
		{
			return _anchor;
		}

		public function get contentOffset():Point
		{
			return _contentOffset;
		}
		
		public function set command(value:FrameCommand):void
		{
			_command = value;
		}
		
		public function get command():FrameCommand
		{
			return _command;
		}
		
		public function get matrix():Matrix
		{
			return _matrix;
		}
		
		public function dispose():void
		{
			_command = null;
			_matrix = null;
		}
		
	}
}