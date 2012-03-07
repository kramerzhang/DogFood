package com.kramer.frameSheet
{
	import com.kramer.core.IDisposable;
	
	import flash.display.BitmapData;
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
		//帧上可视范围的宽高
		private var _contentSize:Rectangle;
		//帧上可视范围相对帧左上角的偏移量
		private var _contentOffset:Point
		//帧上可视内容在图片序列中的索引号，从0开始
		private var _sheetIndex:int;
		//帧的可视位图内容
		private var _content:BitmapData;
		private var _hasContent:Boolean;
		//帧上附带的命令
		private var _command:FrameCommand;
		
		public function Frame(keyNum:int, size:Rectangle, anchor:Point, contentSize:Rectangle, contentOffset:Point, sheetIndex:int)
		{
			_keyNum = keyNum;
			_size = size;
			_anchor = anchor;
			_contentSize = contentSize;
			_contentOffset = contentOffset;
			_sheetIndex = sheetIndex;
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
		
		public function get contenSize():Rectangle
		{
			return _contentSize;
		}
		
		public function get contentOffset():Point
		{
			return _contentOffset;
		}
		
		public function get sheetIndex():int
		{
			return _sheetIndex;
		}
		
		public function get content():BitmapData
		{
			return _content;
		}
		
		public function set content(value:BitmapData):void
		{
			_content = value;
			_hasContent = true;
		}
		
		public function get hasContent():Boolean
		{
			return _hasContent;
		}
		
		public function set command(value:FrameCommand):void
		{
			_command = value;
		}
		
		public function get command():FrameCommand
		{
			return _command;
		}
		
		public function dispose():void
		{
			if(_content != null)
			{
				_content.dispose();
				_content = null;
			}
		}
		
	}
}