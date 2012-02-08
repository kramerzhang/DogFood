package com.kramer.net
{
	import com.kramer.log.Logger;
	import com.kramer.net.message.RawMessage;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.flash_proxy;
	
	[Event(name="connect", type = "flash.events.Event")]
	[Event(name="close", type = "flash.events.Event")]
	[Event(name="ioError", type = "flash.events.IOErrorEvent")]
	[Event(name="securityError", type = "flash.events.SecurityErrorEvent")]
	[Event(name="data", type = "flash.events.DataEvent")]
	public class TcpSocket extends EventDispatcher
	{
		//describe how bytes long of this message
		private const MESSAGE_FIRST_TOKEN_LEN:int = 4;
		private var _sendBuffer:ByteArray;
		private var _tempBuffer:ByteArray;
		private var _chunkBuffer:ByteArray;
		private var _socket:Socket;
		private var _messageQueue:Vector.<RawMessage>
		
		//ip string
		private var _host:String;
		private var _port:uint;
		
		private var _logger:Logger;
		
		public function TcpSocket()
		{
			super(this);
			initialize();
		}
		
		private function initialize():void
		{
			_sendBuffer = new ByteArray();
			_sendBuffer.endian = Endian.LITTLE_ENDIAN
			_tempBuffer = new ByteArray();
			_tempBuffer.endian = Endian.LITTLE_ENDIAN
			_chunkBuffer = new ByteArray();
			_chunkBuffer.endian = Endian.LITTLE_ENDIAN
			_messageQueue = new Vector.<RawMessage>();
			_logger = Logger.getLogger("TcpSocket");
		}
		
		public function get isConnected():Boolean
		{
			return _socket && _socket.connected;
		}
		
		public function connect(host:String, port:uint):void
		{
			if(isConnected == false)
			{
				_socket = new Socket();
				_socket.endian = Endian.LITTLE_ENDIAN;
				_socket.addEventListener(Event.CONNECT, onConnectSuccess);
				_socket.addEventListener(Event.CLOSE, onConnectionClose);
				_socket.addEventListener(IOErrorEvent.IO_ERROR, onConnectIoError);
				_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);
				_socket.connect(host, port);
			}
		}
		
		private function onConnectSuccess(evt:Event):void
		{
			dispatchEvent(evt.clone());
		}
		
		private function onConnectionClose(evt:Event):void
		{
			dispatchEvent(evt.clone());
		}
		
		private function onConnectIoError(evt:IOErrorEvent):void
		{
			dispatchEvent(evt.clone() as IOErrorEvent);
		}
		
		private function onSocketSecurityError(evt:SecurityErrorEvent):void
		{
			dispatchEvent(evt.clone() as SecurityErrorEvent);
		}
		
		private function onSocketData(evt:ProgressEvent):void
		{
			_chunkBuffer.clear();
			if(_tempBuffer.length > 0)
			{
				_tempBuffer.position = 0;
				_tempBuffer.readBytes(_chunkBuffer, 0, _tempBuffer.length);
				_tempBuffer.clear();
			}
			_socket.readBytes(_chunkBuffer, _chunkBuffer.length, _socket.bytesAvailable);
			while(_chunkBuffer.bytesAvailable > 0)
			{
				if(_chunkBuffer.bytesAvailable > MESSAGE_FIRST_TOKEN_LEN)
				{
					var msgLen:int = _chunkBuffer.readUnsignedInt() - MESSAGE_FIRST_TOKEN_LEN;
					if(msgLen > _chunkBuffer.bytesAvailable)
					{
						_chunkBuffer.position = _chunkBuffer.position - MESSAGE_FIRST_TOKEN_LEN;
						_chunkBuffer.readBytes(_tempBuffer, 0, _chunkBuffer.bytesAvailable);
					}
					else
					{
						_chunkBuffer.position = _chunkBuffer.position - MESSAGE_FIRST_TOKEN_LEN;
						var msg:RawMessage = new RawMessage(_chunkBuffer);
						_messageQueue.push(msg);
						dispatchEvent(new DataEvent(DataEvent.DATA));
					}
				}
				else
				{
					_chunkBuffer.readBytes(_tempBuffer, 0, _chunkBuffer.bytesAvailable);
				}
			}
		}
		
		public function getMessageQueue():Vector.<RawMessage>
		{
			var result:Vector.<RawMessage> = new Vector.<RawMessage>();
			while(_messageQueue.length > 0)
			{
				result.push(_messageQueue.shift());
			}
			return result;
		}
		
		public function send(message:RawMessage):void
		{
			if(isConnected == true)
			{
				_sendBuffer.clear();
				_sendBuffer.position = 0;
				_sendBuffer.writeBytes(message.pack());
				_socket.writeBytes(_sendBuffer);
				_socket.flush();
			}
			else
			{
				_logger.error("连接已断开");
			}
		}
		
		public function close():void
		{
			if(isConnected == true)
			{
				_socket.close();
				_socket = null;
			}
			else
			{
				_logger.error("连接已断开");
			}
		}
	}
}