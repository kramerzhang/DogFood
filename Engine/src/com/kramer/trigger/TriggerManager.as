package com.kramer.trigger
{
	import com.kramer.tick.ITickable;
	import com.kramer.tick.TickManager;
	import com.kramer.trove.HashMap;
	
	import flash.events.Event;

	public class TriggerManager implements ITickable
	{
		private static var _instance:TriggerManager;
		private var _triggerMap:HashMap;//key: eventType, value: trigger vector
		
		public function TriggerManager(blocker:Blocker)
		{
			_triggerMap = new HashMap();
		}
		
		public static function get instance():TriggerManager
		{
			if(_instance == null)
			{
				_instance = new TriggerManager(new Blocker());
			}
			return _instance;
		}
		
		public function update():void
		{
			feedEnterFrameEvent();
		}
		
		public function addTrigger(trigger:ITrigger):void
		{
			var vec:Vector.<ITrigger> = getTriggerVec(trigger.eventType);
			if(trigger.eventType == Event.ENTER_FRAME)
			{
				attachToTickManager();
			}
			var len:int = vec.length;
			for(var i:int = 0; i < len; i++)
			{
				var exist:ITrigger = vec[i];
				if(trigger.priority > exist.priority)
				{
					vec.splice(i, 0, trigger);
					return;
				}
			}
			vec.push(trigger);
		}
		
		private function getTriggerVec(eventType:String):Vector.<ITrigger>
		{
			if(_triggerMap.get(eventType) == null)
			{
				_triggerMap.put(eventType, new Vector.<ITrigger>());
			}
			return _triggerMap.get(eventType);
		}
		
		public function removeTrigger(trigger:ITrigger):void
		{
			var vec:Vector.<ITrigger> = getTriggerVec(trigger.eventType);
			var index:int = vec.indexOf(trigger);
			if(index > -1)
			{
				vec.splice(index, 1);
			}
			if(trigger.eventType == Event.ENTER_FRAME && vec.length == 0)
			{
				detachFromTickManager();
			}
		}
		
		public function feedEvent(evt:Event):void
		{
			var vec:Vector.<ITrigger> = getTriggerVec(evt.type);
			for each(var trigger:ITrigger in vec)
			{
				trigger.setEvent(evt);
				if(trigger.testCondition() == true)
				{
					trigger.doAction();
				}
			}
		}
		
		private function feedEnterFrameEvent():void
		{
			var vec:Vector.<ITrigger> = getTriggerVec(Event.ENTER_FRAME);
			for each(var trigger:ITrigger in vec)
			{
				if(trigger.testCondition() == true)
				{
					trigger.doAction();
				}
			}
		}
		
		private function attachToTickManager():void
		{
			TickManager.instance.attach(this);
		}
		
		private function detachFromTickManager():void
		{
			TickManager.instance.detach(this);
		}
	}
}

class Blocker{}