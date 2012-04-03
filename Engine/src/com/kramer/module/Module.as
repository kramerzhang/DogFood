package com.kramer.module
{
	import com.kramer.GameWorld;
	import com.kramer.module.event.ModuleEvent;
	import com.kramer.scene.LayerManager;
	import com.kramer.utils.DisplayObjectUtil;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Module extends Sprite
	{
		protected var _gameWorld:GameWorld;
		protected var _ui:MovieClip;
		protected var _closeBtn:SimpleButton;
		protected var _dragMc:Sprite;
		protected var _data:Object;
		
		public function Module()
		{
			initialize();
		}
		
		private function initialize():void
		{
			addStageEventListener();
		}
		
		private function addStageEventListener():void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		protected function onAddToStage(evt:Event):void
		{
			//add logic handler here
		}
		
		protected function onRemoveFromStage(evt:Event):void
		{
			//remove logic handler here
		}
		
		public function set gameWorld(value:GameWorld):void
		{
			_gameWorld = value;
		}
		
		protected function setUI(ui:MovieClip):void
		{
			_ui = ui;
			_closeBtn = _ui["closeBtn"] as SimpleButton;
			_dragMc = _ui["dragMC"] as Sprite;
			addChild(_ui);
			addBtnEventListener();
		}
		
		private function addBtnEventListener():void
		{
			if(_closeBtn != null)
			{
				_closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			}
			if(_dragMc != null)
			{
				_dragMc.buttonMode = true;
				_dragMc.addEventListener(MouseEvent.MOUSE_DOWN, onDragStart);
				_dragMc.addEventListener(MouseEvent.MOUSE_UP, onDragEnd);
			}
		}
		
		protected function onClose(evt:MouseEvent):void
		{
			hide();
		}
		
		private function onDragStart(evt:MouseEvent):void
		{
			DisplayObjectUtil.bringToTop(this);
			startDrag();
		}
		
		private function onDragEnd(evt:Event):void
		{
			stopDrag();
		}
		
		public function set data(data:Object):void
		{
			_data = data;
			update();
		}
		
		protected function update():void
		{
			//to update ui according to the data
		}
		
		public function show():void
		{
			LayerManager.module.addChild(this);
			//todo
			DisplayObjectUtil.align(this, new Rectangle(0, 0, _gameWorld.screenWidth, _gameWorld.screenHeight));
		}
		
		public function hide():void
		{
			DisplayObjectUtil.removeFromParent(this);
			releaseExternalObject();
		}
		
		protected function releaseExternalObject():void
		{
			_data = null;
		}
	}
}