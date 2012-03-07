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
		
		public function AnimatedElement()
		{
			super();
		}
		
		public function set resourceUrl(value:String):void
		{
			_animation = new Animation();
			_animation.frameRate = 24;
			_animation.resourceUrl = value;
			_animation.addEventListener(Event.INIT, onAnimationInit);
		}
		
		public function get resourceUrl():String
		{
			return _animation.resourceUrl;
		}
		
		private function onAnimationInit(evt:Event):void
		{
			setAnimation(_animation);
			dispatchEvent(new EntityEvent(EntityEvent.CONSTRUCTED));
		}
		
		protected function setAnimation(animation:IAnimation):void
		{
			_animation = animation;
			addChild(_animation as DisplayObject);
		}
		
		public function playAction(action:String):void
		{
			_actionLabel = _animation.frameLabelMap.get(action);
			if(_actionLabel == null)
			{
				throw new ArgumentError("action not exist!");
			}
			_animation.setLoopRange(_actionLabel.startNum, _actionLabel.endNum);
			_animation.gotoAndPlay(_actionLabel.startNum);
		}
		
		public function set frameRate(value:int):void
		{
			if(value <= 0)
			{
				throw new ArgumentError("delay shoud be greater than 0");
			}
			_animation.frameRate = value;
		}
		
		public function get frameRate():int
		{
			return _animation.frameRate;
		}
		
		public function update(currentTime:int):void
		{
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