package com.kramer.frameSheet
{
	import com.kramer.core.IDisposable;
	import com.kramer.core.IReferenceCountable;
	import com.kramer.core.lib_internal;
	import com.kramer.log.Logger;
	import com.kramer.trove.HashMap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.ByteArray;

	use namespace lib_internal;
	
	public class FrameSheet implements IDisposable, IReferenceCountable
	{
		private var _descData:ByteArray;
		private var _frames:Vector.<Frame>;
		private var _frameLabelMap:HashMap;
		
		private var _totalFrameNum:uint;
		private var _totalKeyFrameNum:uint;
		
		private var _frameAnchor:Point;
		private var _frameSize:Rectangle;
		
		private var _bitmap:Bitmap;
		private var _rowNum:int;
		private var _columnNum:int;
		
		//以frame索引值为Key，frame的BitmapData为Value
		private var _contentMap:HashMap;
		
		//引用计数，当引用计数为0时释放资源
		private var _referenceCount:int;
		
		private var _logger:Logger;
		
		public function FrameSheet()
		{
			initialize();
		}
		
		private function initialize():void
		{
			_referenceCount = 0;
			_logger = Logger.getLogger("frameSheet");
		}
		
		lib_internal function readDescription(data:ByteArray):void
		{
			_descData = new ByteArray();;
			var descDataLen:uint = data.readShort();
			data.readBytes(_descData, 0, descDataLen);
		}
		
		lib_internal function setSheetBitmap(bitmap:Bitmap):void
		{
			_bitmap = bitmap;
			parseDescription();
		}
		
		private function parseDescription():void
		{
			_totalFrameNum = _descData.readShort();
			_frameAnchor = new Point(_descData.readShort(), _descData.readShort());
			_frameSize = new Rectangle(0, 0, _descData.readShort(), _descData.readShort());
			_columnNum = _bitmap.width / _frameSize.width;
			_rowNum = _bitmap.height / _frameSize.height;
			_totalKeyFrameNum = _descData.readShort();
			
			readFrames(_descData);
			readLabels(_descData);
		}
		
		private function readFrames(descData:ByteArray):void
		{
			var keyFrames:Vector.<Frame> = readKeyFrames(descData);
			_frames = new Vector.<Frame>();
			var lastKeyFrame:Frame;
			for(var i:int = 0; i < _totalFrameNum; i++)
			{
				var frameNum:int = i + 1;
				if(keyFrames.length > 0 && frameNum == keyFrames[0].keyNum)
				{
					lastKeyFrame = keyFrames.shift();
				}
				_frames.push(lastKeyFrame);
			}
		}
		
		private function readKeyFrames(descData:ByteArray):Vector.<Frame>
		{
			var result:Vector.<Frame> = new Vector.<Frame>();
			for(var i:int = 0; i < _totalKeyFrameNum; i++)
			{
				var keyNum:int = descData.readShort();
				var size:Rectangle = _frameSize.clone();
				var anchor:Point = _frameAnchor.clone();
				var contentOffset:Point = new Point(descData.readShort(), descData.readShort());
				var contentSize:Rectangle = new Rectangle(0, 0, descData.readShort(), descData.readShort());
				var sheetIndex:int = descData.readShort();
				var columnIndex:int = sheetIndex % _columnNum;
				var rowIndex:int = sheetIndex / _columnNum;
				var contentX:int = columnIndex * _frameSize.width;
				var contentY:int = rowIndex * _frameSize.height;
				var matrix:Matrix = new Matrix(1, 0, 0, 1, _bitmap.width - contentX, _bitmap.height - contentY);
				var frame:Frame = new Frame(keyNum, size, anchor, contentSize, contentOffset, matrix);
				result.push(frame);
			}
			return result;
		}
		
		private function readLabels(descData:ByteArray):void
		{
			if(descData.bytesAvailable > 0)
			{
				var concatStr:String = descData.readUTFBytes(descData.bytesAvailable);
				var arr:Array = concatStr.split(":");
				var labelStr:String = arr[0];
				var labelNumStr:String = arr[1];
				parseLabelStr(labelStr, labelNumStr);
			}
		}
		
		private function parseLabelStr(lableStr:String, labelNumStr:String):void
		{
			_frameLabelMap = new HashMap();
			var labelArr:Array = lableStr.split(",");
			var labeNumArr:Array = labelNumStr.split(",");
			var labelLen:int = labelArr.length;
			for(var i:int = 0; i < labelLen; i++)
			{
				var label:FrameLabel = new FrameLabel(labelArr[i], labeNumArr[i*2], labeNumArr[i*2 + 1]);
				_frameLabelMap.put(label.name, label);
			}
		}
		
		public function getFrame(frameNum:int):Frame
		{
			if(frameNum < 1 || frameNum > _totalFrameNum)
			{
				throw new ArgumentError("帧编号必须在 1～" + _totalFrameNum + "之间");
			}
			return _frames[frameNum - 1];
		}
		
		public function get totalFrameNum():int
		{
			return _totalFrameNum;
		}
		
		public function get frameSize():Rectangle
		{
			return _frameSize;
		}
		
		public function get frameAnchor():Point
		{
			return _frameAnchor;
		}
		
		public function get frameLabelMap():HashMap
		{
			return _frameLabelMap;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmap.bitmapData;
		}
		
		public function set referenceCount(value:int):void
		{
			_referenceCount = value;
		}
		
		public function get referenceCount():int
		{
			return _referenceCount;
		}
		
		private function disposeBitmap():void
		{
			if(_bitmap != null)
			{
				_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
		}
		
		private function disposeFrames():void
		{
			for each(var frame:Frame in _frames)
			{
				frame.dispose();
			}
			_frames = null;
		}
		
		public function dispose():void
		{
			this.referenceCount -= 1;
			if(_referenceCount == 0)
			{
				disposeBitmap();
				disposeFrames();
				_frameLabelMap = null;
			}
		}
		
	}
}