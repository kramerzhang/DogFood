package com.kramer.frameSheet
{
	public class FrameCommand
	{
		public var _content:String;
		public var _type:String;
		
		public function FrameCommand(type:String, content:String)
		{
			_type = type;
			_content = content;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get content():String
		{
			return _content;
		}
		
	}
}