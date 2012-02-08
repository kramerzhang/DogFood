package com.kramer.frameSheet
{
	public class FrameLabel
	{
		private var _name:String;
		//num编号，从1开始；index索引号，从0开始
		private var _startNum:int;
		private var _endNum:int;
		
		public function FrameLabel(name:String, startNum:int, endNum:int)
		{
			_name = name;
			_startNum = startNum;
			_endNum = endNum;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get startNum():int
		{
			return _startNum;
		}
		
		public function get endNum():int
		{
			return _endNum;
		}
		
		public function toString():String
		{
			return "{name: " + _name + " start: " + _startNum + " end: " + _endNum + "}"
		}
	}
}