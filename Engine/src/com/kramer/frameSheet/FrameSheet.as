package com.kramer.frameSheet
{
	import com.kramer.core.IReferenceCountable;
	import com.kramer.core.lib_internal;
	import com.kramer.log.Logger;
	import com.kramer.trove.HashMap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	use namespace lib_internal;
	
	public class FrameSheet implements IReferenceCountable
	{
		private var _frames:Vector.<Frame>;
		private var _frameLabelMap:HashMap;
		
		private var _totalFrameNum:uint;
		private var _totalKeyFrameNum:uint;
		
		private var _frameAnchor:Point;
		private var _frameSize:Rectangle;
		
		private var _bitmap:Bitmap;
		private var _rowNum:int;
		private var _columnNum:int;
		
		//从frameSheet提取单元的个数，当单元都被提取后，释放frameSheet的大图资源
		private var _extractedNum:int;
		private var _totalUniqueFrameNum:int;
		//以frame索引值为Key，frame的BitmapData为Value
		private var _contentMap:HashMap;
		
		//引用计数，当引用计数为0时释放资源
		private var _referenceCount:int;
		
		public function FrameSheet()
		{
			initialize();
		}
		
		private function initialize():void
		{
			_contentMap = new HashMap();
		}
		
		public function readDescription(data:ByteArray):void
		{
			var descData:ByteArray = new ByteArray();
			var descDataLen:uint = data.readShort();
			data.readBytes(descData, 0, descDataLen);
			
			_totalFrameNum = descData.readShort();
			_frameAnchor = new Point(descData.readShort(), descData.readShort());
			_frameSize = new Rectangle(0, 0, descData.readShort(), descData.readShort());
			_totalKeyFrameNum = descData.readShort();
			
			readFrames(descData);
			readLabels(descData);
			_totalUniqueFrameNum = calculateTotalUniqueFrameNum();
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
				var frame:Frame = new Frame(keyNum, size, anchor, contentSize, contentOffset, sheetIndex);
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
		
		private function calculateTotalUniqueFrameNum():int
		{
			var maxSheetIndex:int = 0;
			var len:int = _frames.length;
			for(var i:int = 0; i < len; i ++)
			{
				var frame:Frame = _frames[i];
				if(frame.sheetIndex > maxSheetIndex)
				{
					maxSheetIndex = frame.sheetIndex;
				}
			}
			return maxSheetIndex + 1;
		}
		
		public function setSheetBitmap(bitmap:Bitmap):void
		{
			_bitmap = bitmap;
			_rowNum = _bitmap.height / _frameSize.height;
			_columnNum = _bitmap.width / _frameSize.width;
		}
		
		public function getFrame(frameNum:int):Frame
		{
			if(frameNum < 1 || frameNum > _totalFrameNum)
			{
				throw new ArgumentError("帧编号必须在 1～" + _totalFrameNum + "之间");
			}
			var frame:Frame = _frames[frameNum - 1];
			if(frame.hasContent == false)
			{
				frame.content = getFrameContent(frame.sheetIndex, frame.contenSize);				
			}
			return frame;
		}
		
		private function getFrameContent(sheetIndex:int, contentSize:Rectangle):BitmapData
		{
			if(_contentMap.containsKey(sheetIndex))
			{
				return _contentMap.get(sheetIndex) as BitmapData;
			}			
			var columnIndex:int = sheetIndex % _columnNum;
			var rowIndex:int = sheetIndex / _columnNum;
			var frameX:int = columnIndex * _frameSize.width;
			var frameY:int = rowIndex * _frameSize.height;
			var contentRect:Rectangle = new Rectangle(frameX, frameY, contentSize.width, contentSize.height);
			var bitmapData:BitmapData = new BitmapData(contentSize.width, contentSize.height, true, 0xFF33FF);
			bitmapData.copyPixels(_bitmap.bitmapData, contentRect, new Point(0, 0));
			_contentMap.put(sheetIndex, bitmapData);
			_extractedNum++;
			if(_extractedNum >= _totalUniqueFrameNum)
			{
				disposeBitmap();
			}
			return bitmapData;
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
			if(_referenceCount == 0)
			{
				dispose();
			}
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
		
		private function dispose():void
		{
			disposeBitmap();
			disposeFrames();
			_contentMap.clear();
			_contentMap = null;
			_frameAnchor = null;
			_frameSize = null;
			_frameLabelMap = null;
		}
		
	}
}