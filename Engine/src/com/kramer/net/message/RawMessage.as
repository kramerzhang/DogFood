package com.kramer.net.message
{
	import flash.utils.ByteArray;

	public class RawMessage
	{
		public static const HEAD_LENGTH:uint = 18;
		
		private var _messageLength:uint;
		private var _head:ByteArray;
		private var _body:ByteArray;
		
		public function RawMessage(receiveData:ByteArray = null)
		{
			createHead();
			createBody();
			if(receiveData != null)
			{
				_messageLength = receiveData.readUnsignedInt();
				readHead(receiveData);
				readBody(receiveData);
			}
		}
		
		private function createHead():void
		{
			_head = new ByteArray();
		}
		
		private function createBody():void
		{
			_body = new ByteArray()
		}
		
		private function readHead(data:ByteArray):void
		{
			data.readBytes(_head, 0, HEAD_LENGTH);
		}
		
		private function readBody(data:ByteArray):void
		{
			var bodyLen:int = _messageLength - HEAD_LENGTH; 
			if(bodyLen > 0)
			{
				data.readBytes(_body, 0, bodyLen);
			}
		}
		
		protected function setHead(head:ByteArray):void
		{
			head.readBytes(_head);
		}
		
		protected function getHead():ByteArray
		{
			return _head;
		}
		
		protected function setBody(body:ByteArray):void
		{
			body.readBytes(_body);
		}
		
		protected function getBody():ByteArray
		{
			return _body;
		}
		
		public function readDouble():Number
		{
			return _body.readDouble();
		}
		
		public function writeDouble(value:Number):void
		{
			_body.writeDouble(value);
		}
		
		public function readUInt():uint
		{
			return _body.readUnsignedInt();
		}
		
		public function writeUInt(value:uint):void
		{
			_body.writeUnsignedInt(value);
		}
		
		public function readInt():int
		{
			return _body.readInt();
		}
		
		public function writeInt(value:int):void
		{
			_body.writeInt(value);
		}
		
		public function readUShort():uint
		{
			return _body.readUnsignedShort();
		}
		
		public function writeUShort(value:uint):void
		{
			return _body.writeShort(value);
		}
		
		public function readShort():int
		{
			return _body.readShort();
		}
		
		public function writeShort(value:int):void
		{
			_body.writeShort(value);
		}
		
		public function readUByte():uint
		{
			return _body.readUnsignedByte();
		}
		
		public function writeUByte(value:uint):void
		{
			_body.writeByte(value);
		}
		
		public function readByte():int
		{
			return _body.readByte();
		}
		
		public function writeByte(value:int):void
		{
			_body.writeByte(value);
		}
		
		public function readUTF():String
		{
			return _body.readUTF();
		}
		
		public function writeUTF(value:String):void
		{
			_body.writeUTF(value);
		}
		
		public function readUTFBytes(length:uint):String
		{
			return _body.readUTFBytes(length);
		}
		
		public function pack():ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			_head.position = 0;
			_head.readBytes(buffer);
			_body.position = 0;
			_body.readBytes(buffer);
			return buffer;
		}
	
	}
}