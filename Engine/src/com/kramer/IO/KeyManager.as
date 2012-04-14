package com.kramer.IO
{
	import com.kramer.debug.Debug;
	import com.kramer.trove.HashMap;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	[Event(name="keyEvent", type = "com.kramer.IO.KeyManager")]
	public class KeyManager extends EventDispatcher
	{
		public static const KEY_EVENT:String = "keyEvent";
		
		private static var _instance:KeyManager;
		private static var _keyMap:HashMap;
		private static var _pressedKeyMap:HashMap;
		private static var _keyAliasMap:HashMap;
		private static var _keyCodeMap:HashMap;
		
		private var _stage:Stage;
		
		public function KeyManager(stage:Stage, blocker:Blocker)
		{
			super(this);
			_stage = stage;
			addStageKeyEventListener();
		}
		
		public static function initialize(stage:Stage):void
		{
			_instance = new KeyManager(stage, new Blocker());
			setupKeyCodeMap();
			setupKeyMap();
			_keyAliasMap = new HashMap();
			_pressedKeyMap = new HashMap();
		}
		
		private static function setupKeyMap():void
		{
			_keyMap = new HashMap();
			var keyCodeArr:Array = _keyCodeMap.getValues();
			for each(var keyCode:int in keyCodeArr)
			{
				_keyMap.put(keyCode, new Key(keyCode));
			}
		}
		
		private static function setupKeyCodeMap():void
		{
			_keyCodeMap = new HashMap();
			for(var i:int = Keyboard.A; i < Keyboard.Z; i++)
			{
				_keyCodeMap.put(String.fromCharCode(i), i);
			}
			for(var j:int = Keyboard.NUMBER_0; j < Keyboard.NUMBER_9; j++)
			{
				_keyCodeMap.put(String.fromCharCode(j), j);
			}
			_keyCodeMap.put("F1", 112);
			_keyCodeMap.put("F2", 113);
			_keyCodeMap.put("F3", 114);
			_keyCodeMap.put("F4", 115);
			_keyCodeMap.put("F5", 116);
			_keyCodeMap.put("F6", 117);
			_keyCodeMap.put("F7", 118);
			_keyCodeMap.put("F8", 119);
			_keyCodeMap.put("F9", 120);
			_keyCodeMap.put("F10", 121);
			_keyCodeMap.put("F11", 122);
			_keyCodeMap.put("F12", 123);
			_keyCodeMap.put("F13", 124);
			_keyCodeMap.put("F14", 125);
			_keyCodeMap.put("F15", 126);
			_keyCodeMap.put("NUM_LOCK", 144);
			_keyCodeMap.put("SCR_LOCK", 145);
			_keyCodeMap.put("PAUSE", 19);
			_keyCodeMap.put("NUMPAD_0", 96);
			_keyCodeMap.put("NUMPAD_1", 97);
			_keyCodeMap.put("NUMPAD_2", 98);
			_keyCodeMap.put("NUMPAD_3", 99);
			_keyCodeMap.put("NUMPAD_4", 100);
			_keyCodeMap.put("NUMPAD_5", 101);
			_keyCodeMap.put("NUMPAD_6", 102);
			_keyCodeMap.put("NUMPAD_7", 103);
			_keyCodeMap.put("NUMPAD_8", 104);
			_keyCodeMap.put("NUMPAD_9", 105);
			_keyCodeMap.put("NUMPAD_ADD", 107);
			_keyCodeMap.put("NUMPAD_DECIMAL", 110);
			_keyCodeMap.put("NUMPAD_DIVIDE", 111);
			_keyCodeMap.put("NUMPAD_ENTER", 108);
			_keyCodeMap.put("NUMPAD_MULTIPLY", 106);
			_keyCodeMap.put("NUMPAD_SUBTRACT", 109);
			_keyCodeMap.put("COLON", 186);
			_keyCodeMap.put("EQUALS", 187);
			_keyCodeMap.put("MINUS", 189);
			_keyCodeMap.put("FWD_SLASH", 191);
			_keyCodeMap.put("LSQR_BRACKET", 219);
			_keyCodeMap.put("RSQR_BRACKET", 221);
			_keyCodeMap.put("BACK_SLASH", 220);
			_keyCodeMap.put("COMMA", 188);
			_keyCodeMap.put("DOT", 190);
			_keyCodeMap.put("HOME", 36);
			_keyCodeMap.put("INSERT", 45);
			_keyCodeMap.put("PAGE_DOWN", 34);
			_keyCodeMap.put("PAGE_UP", 33);
			_keyCodeMap.put("SHIFT", 16);
			_keyCodeMap.put("SPACE", 32);
			_keyCodeMap.put("TAB", 9);
			_keyCodeMap.put("QUOTE", 34);
			_keyCodeMap.put("BACKSPACE", 8);
			_keyCodeMap.put("CAPS_LOCK", 20);
			_keyCodeMap.put("CONTROL", 17);
			_keyCodeMap.put("DELETE", 46);
			_keyCodeMap.put("END", 35);
			_keyCodeMap.put("ENTER", 13);
			_keyCodeMap.put("RETURN", 13);
			_keyCodeMap.put("ESCAPE", 27);
			_keyCodeMap.put("UP", 38);
			_keyCodeMap.put("LEFT", 37);
			_keyCodeMap.put("DOWN", 40);
			_keyCodeMap.put("RIGHT", 39);
		}
		
		public static function get instance():KeyManager
		{
			Debug.assert(_instance != null, "Should KeyboardManager.initialize first"); 
			return _instance;
		}
		
		private function addStageKeyEventListener():void
		{
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
			_stage.addEventListener(Event.ACTIVATE, onStageActivate);
			_stage.addEventListener(Event.DEACTIVATE, onStageDeactivate);
		}
		
		private function onStageKeyDown(evt:KeyboardEvent):void
		{
			var keyCode:int = evt.keyCode;
			var key:Key = _keyMap.get(keyCode) as Key;
			if(key != null)
			{
				_pressedKeyMap.put(keyCode, key);
				key.registerAsDown();
				if(hasEventListener(KEY_EVENT) == true)
				{
					dispatchEvent(new Event(KEY_EVENT));
				}
			}
		}
		
		private function onStageKeyUp(evt:KeyboardEvent):void
		{
			var keyCode:int = evt.keyCode;
			var key:Key = _keyMap.get(keyCode) as Key;
			if(key != null)
			{
				_pressedKeyMap.remove(keyCode);
				key.registerAsUp();
				if(hasEventListener(KEY_EVENT) == true)
				{
					dispatchEvent(new Event(KEY_EVENT));
				}
			}
		}
		
		private function onStageActivate(evt:Event):void
		{
			
		}
		
		private function onStageDeactivate(evt:Event):void
		{
			var keyArr:Array = _pressedKeyMap.getValues();
			for each(var key:Key in keyArr)
			{
				key.clear();
			}
			_pressedKeyMap.clear();
		}
		
		public static function isKeyDown(value:String):Boolean
		{
			var keyCode:int = getKeyCode(value);
			var key:Key = _keyMap.get(keyCode);
			if(key != null)
			{
				return key.isDown;
			}
			return false;
		}
		
		public static function isKeyPressed(value:String):Boolean
		{
			var keyCode:int = getKeyCode(value);
			var key:Key = _keyMap.get(keyCode);
			if(key != null)
			{
				return key.isPressed;
			}
			return false;
		}
		
		public static function isKeyReleased(value:String):Boolean
		{
			var keyCode:int = getKeyCode(value);
			var key:Key = _keyMap.get(keyCode);
			if(key != null)
			{
				return key.isReleased;
			}
			return false;
		}
		
		private static function getKeyCode(key:String):int
		{
			var upperCaseKey:String = key.toUpperCase();
			if(_keyAliasMap.get(upperCaseKey) != null)
			{
				return _keyAliasMap.get(upperCaseKey);
			}
			if(_keyCodeMap.get(upperCaseKey) != null)
			{
				return _keyCodeMap.get(upperCaseKey);
			}
			return -1;
		}
		
		public static function registerKeyAlias(alias:String, keyCode:int):void
		{
			_keyAliasMap.put(alias.toUpperCase(), keyCode);
		}
		
		public static function unregisterKeyAlias(alias:String, keyCode:int):void
		{
			_keyAliasMap.remove(alias.toUpperCase());
		}
		
	}
}
class Blocker{}