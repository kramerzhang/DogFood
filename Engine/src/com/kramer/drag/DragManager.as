package com.kramer.drag
{
	import com.kramer.drag.event.DragEvent;
	import com.kramer.utils.DisplayObjectUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class DragManager extends EventDispatcher
	{
		private static var _instance:DragManager;
		private static var _stage:Stage;
		private static var _source:DisplayObject;
		private static var _identifier:String;
		private static var _dragShot:DisplayObject;
		private static var _dragWrapper:Sprite;
		
		public function DragManager()
		{
		}
		
		public static function initialize(stage:Stage):void
		{
			_stage = stage;
			_instance = new DragManager();
			_dragWrapper = new Sprite();
			DisplayObjectUtil.disableDisplayObject(_dragWrapper);			
		}
		
		public static function startDrag(source:DisplayObject, identifier:String, dragShot:DisplayObject, offsetX:int = 0, offsetY:int = 0):void
		{
			_source = source;
			_identifier = identifier;
			if(dragShot == null)
			{
				_dragShot = createShotImage();
			}
			_dragShot.x = offsetX;
			_dragShot.y = offsetY;
			_dragWrapper.addChild(_dragShot);
			_stage.addChild(_dragWrapper);
			_dragWrapper.startDrag(true);
			dispatchDragEvent(DragEvent.DRAG_START);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		private static function onStageMouseUp(evt:MouseEvent):void
		{
			_dragWrapper.stopDrag();
			dispatchDragEvent(DragEvent.DRAG_STOP);
			dispose();
		}
		
		private static function dispose():void
		{
			DisplayObjectUtil.removeFromParent(_dragShot);
			DisplayObjectUtil.removeFromParent(_dragWrapper);
			_dragShot = null;
			_source = null;
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		private static function createShotImage():Bitmap
		{
			var result:Bitmap = new Bitmap()
			var bitmapData:BitmapData = new BitmapData(_source.width, _source.height, true, 0x00FFFFFF);
			bitmapData.draw(_source);
			result.bitmapData = bitmapData;
			return result;
		}
		
		private static function dispatchDragEvent(type:String):void
		{
			var evt:DragEvent = new DragEvent(type, _source, _identifier);
			_instance.dispatchEvent(evt);
		}
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_instance.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function):void
		{
			_instance.removeEventListener(type, listener);
		}
		
		public static function hasEventListener(type:String):Boolean
		{
			return _instance.hasEventListener(type);
		}
		
		public static function willTrigger(type:String):Boolean
		{
			return _instance.willTrigger(type);
		}
		
		public static function isDropOn(target:DisplayObject):Boolean
		{
			return target.hitTestPoint(_stage.mouseX, _stage.mouseY);
		}
	}
}