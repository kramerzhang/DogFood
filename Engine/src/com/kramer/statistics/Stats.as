package com.kramer.statistics
{
	import com.kramer.trove.Color;
	import com.kramer.trove.HtmlString;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	public class Stats extends Bitmap
	{
		private const WIDTH:int = 80;
		private const HEIGHT:int = 100;
		private const DOT_AREA_HEIGHT:int = 50;
		
		private var _lastUpdateTime:uint;
		private var _fps:int = 0;
		private var _fpsTxt:TextField;
		private var _fpsMatrix:Matrix;
		private var _memoryTxt:TextField;
		private var _memoryMatrix:Matrix;
		private var _peekTxt:TextField;
		private var _peekValue:Number = 0;
		private var _peakMatrix:Matrix;
		private var _memoryData:Vector.<Number>;
		private var _memoryRange:int = 1;
		
		
		public function Stats()
		{
			initialize();
		}
		
		private function initialize():void
		{
			_memoryData = new Vector.<Number>();
			createChildren();
			initMatrix();
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function createChildren():void
		{
			this.bitmapData = new BitmapData(WIDTH, HEIGHT, false, Color.BLUE);
			_fpsTxt = createTextField(2, 0);
			_memoryTxt = createTextField(2, 14);
			_peekTxt = createTextField(2, 28);
		}
		
		private function createTextField(xPos:int, yPos:int):TextField
		{
			var txt:TextField = new TextField();
			var format:TextFormat = new TextFormat("_sans");
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.selectable = false;
			txt.defaultTextFormat = format;
			txt.mouseEnabled = false;
			txt.x = xPos;
			txt.y = yPos;
			return txt;
		}
		
		private function initMatrix():void
		{
			_fpsMatrix = new Matrix(1, 0, 0, 1, _fpsTxt.x, _fpsTxt.y);
			_memoryMatrix = new Matrix(1, 0, 0, 1, _memoryTxt.x, _memoryTxt.y);
			_peakMatrix = new Matrix(1, 0, 0, 1, _peekTxt.x, _peekTxt.y);
		}
		
		private function onAddToStage(evt:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onRemoveFromStage(evt:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(evt:Event):void
		{
			_fps++;
			var currentTime:uint = getTimer();
			if((currentTime - _lastUpdateTime) > 1000)
			{
				clearBitmapdata();				
				var memoryValue:Number = System.totalMemory * 9.54e-007;
				drawFpsMemory(_fps, memoryValue);
				addMemoryRecord(memoryValue);
				drawMemoryRecord();
				_fps = 0;
				_lastUpdateTime = currentTime;
			}
		}
		
		private function drawFpsMemory(fps:int, memoryValue:Number):void
		{
			_fpsTxt.htmlText = new HtmlString( "FPS: " + _fps, getFpsColor(_fps)).toString();
			var memoryStr:String = memoryValue.toFixed(2);
			_memoryTxt.htmlText = new HtmlString("MEM: " + memoryStr, Color.GREEN).toString();
			_peekValue = memoryValue > _peekValue ? memoryValue : _peekValue;
			_peekTxt.htmlText = new HtmlString("PEEK: " + _peekValue.toFixed(2), Color.BLACK).toString();
			this.bitmapData.draw(_fpsTxt, _fpsMatrix);
			this.bitmapData.draw(_memoryTxt, _memoryMatrix);
			this.bitmapData.draw(_peekTxt, _peakMatrix);
		}
		
		private function clearBitmapdata():void
		{
			this.bitmapData.fillRect(new Rectangle(0, 0, WIDTH, HEIGHT), Color.BLUE);
		}
		
		private function addMemoryRecord(memoryValue:Number):void
		{
			while(memoryValue > _memoryRange)
			{
				_memoryRange *= 2;
			}
			_memoryData.push(memoryValue);
			if(_memoryData.length > WIDTH)
			{
				_memoryData.shift();
			}
		}
		
		private function drawMemoryRecord():void
		{
			this.bitmapData.fillRect(new Rectangle(0, HEIGHT - DOT_AREA_HEIGHT, WIDTH, DOT_AREA_HEIGHT), Color.BLUE);
			var len:int = _memoryData.length;
			for(var i:int = 0; i < len; i++)
			{
				var x:int = i;
				var y:int = HEIGHT - int(_memoryData[i] / _memoryRange * DOT_AREA_HEIGHT);
				this.bitmapData.setPixel(x, y, Color.YELLOW);
			}
		}
		
		private function getFpsColor(fps:uint):uint
		{
			if(fps < stage.frameRate * 0.5)
			{
				return Color.RED;
			}
			if(fps < stage.frameRate * 0.8)
			{
				return Color.YELLOW;
			}
			return Color.GREEN;
		}
	}
}