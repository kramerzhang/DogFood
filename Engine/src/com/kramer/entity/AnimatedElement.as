package com.kramer.entity
{
	import com.kramer.animation.Animation;
	import com.kramer.animation.IAnimation;
	import com.kramer.entity.events.ActionEvent;
	import com.kramer.entity.events.CommandEvent;
	import com.kramer.entity.events.EntityEvent;
	import com.kramer.frameSheet.FrameCommand;
	import com.kramer.frameSheet.FrameLabel;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	[Event(name="constructed", type = "com.kramer.entity.events.EntityEvent")]
	[Event(name="command", type = "com.kramer.entity.events.CommandEvent")]
	[Event(name="actionStart", type = "com.kramer.entity.events.ActionEvent")]
	[Event(name="actionEnd", type = "com.kramer.entity.events.ActionEvent")]
	public class AnimatedElement extends Entity
	{
		private var _animation:IAnimation;
		private var _wrappers:Vector.<ListenerWrapper>;
		private var _actionLabel:FrameLabel;
		private var _frameRate:int;
		private var _action:String;
		private var _isReady:Boolean = false;
		
		public function AnimatedElement(defaultFrameRate:int = 24)
		{
			_frameRate = defaultFrameRate;
		}
		
		public function set resourceUrl(value:String):void
		{
			_animation = new Animation();
			_animation.addEventListener(Event.INIT, onAnimationInit);
			_animation.resourceUrl = value;
		}
		
		public function get resourceUrl():String
		{
			return _animation.resourceUrl;
		}
		
		private function onAnimationInit(evt:Event):void
		{
			setAnimation(_animation);
			_isReady = true;
			initAction();
			initFrameRate();
			dispatchEvent(new EntityEvent(EntityEvent.CONSTRUCTED));
		}
		
		protected function setAnimation(animation:IAnimation):void
		{
			_animation = animation;
			addChild(_animation as DisplayObject);
		}
		
		public function playAction(action:String):void
		{
			_action = action;
			if(_isReady == true)
			{
				initAction();
			}
		}
		
		private function initAction():void
		{
			if(_action != null)
			{
				_actionLabel = _animation.frameLabelMap.get(_action);
				if(_actionLabel == null)
				{
					throw new ArgumentError("action not exist!");
				}
				_animation.setLoopRange(_actionLabel.startNum, _actionLabel.endNum);
				_animation.gotoAndPlay(_actionLabel.startNum);
			}
			else
			{
				_actionLabel = new FrameLabel("none", 1, _animation.totalFrameNum);
			}
		}
		
		public function set frameRate(value:int):void
		{
			_frameRate = value;
			if(_isReady == true)
			{
				initFrameRate();
			}
		}
		
		private function initFrameRate():void
		{
			_animation.frameRate = _frameRate;
		}
		
		public function get frameRate():int
		{
			return _frameRate;
		}
				
		override public function update(currentTime:int):void
		{
			if(_isReady == false)
			{
				return;
			}
			if(_animation.currentFrameNum == _actionLabel.startNum)
			{
				dispatchActionEvent(ActionEvent.ACTION_START, _actionLabel.name);
			}
			else if(_animation.currentFrameNum == _actionLabel.endNum)
			{
				dispatchActionEvent(ActionEvent.ACTION_END, _actionLabel.name);
			}
			var frameCommand:FrameCommand = _animation.currentFrame.command; 
			if( frameCommand != null)
			{
				dispatchCommandEvent(frameCommand.content);
			}
			_animation.update(currentTime);
		}
		
		private function dispatchActionEvent(type:String, action:String):void
		{
			if(hasEventListener(type) == true)
			{
				dispatchEvent(new ActionEvent(type, action));
			}
		}
		
		private function dispatchCommandEvent(content:String):void
		{
			if(hasEventListener(CommandEvent.COMMAND) == true)
			{
				dispatchEvent(new CommandEvent(CommandEvent.COMMAND, content));
			}
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if(_wrappers == null)
			{
				_wrappers = new Vector.<ListenerWrapper>();
			}
			_wrappers.push(new ListenerWrapper(type, listener));
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			removeListenerWrapper(listener);
			super.removeEventListener(type, listener, useCapture);
		}
		
		private function removeListenerWrapper(listener:Function):void
		{
			if(_wrappers)
			{
				var len:int = _wrappers.length;
				for(var i:int = 0; i < len; i++)
				{
					if(_wrappers[i].listener == listener)
					{
						_wrappers.splice(i, 1);
						return;
					}
				}
			}
		}
		
		public function removeEventListenerByType(type:String):void
		{
			if(_wrappers == null)return;
			var len:int = _wrappers.length;
			for(var i:int = (len - 1); i > 0; i--)
			{
				var wrapper:ListenerWrapper = _wrappers[i];
				if(wrapper.type == type)
				{
					removeEventListener(wrapper.type, wrapper.listener);
				}
			}
		}
		
		private function removeAllListenerWrapper():void
		{
			for each(var wrapper:ListenerWrapper in _wrappers)
			{
				removeEventListener(wrapper.type, wrapper.listener);
			}
			_wrappers = null;
		}
		
		override public function dispose():void
		{
			removeAllListenerWrapper();
			_animation.dispose();
			_animation = null;
			_actionLabel = null;
		}
	}
}

class ListenerWrapper
{
	public var type:String;
	public var listener:Function;
	
	public function ListenerWrapper(type:String, listener:Function)
	{
		this.type = type;
		this.listener = listener;
	}
}