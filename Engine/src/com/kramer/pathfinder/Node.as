package com.kramer.pathfinder
{
	import com.kramer.pool.IPoolableObject;
	import com.kramer.utils.StringUtil;
	
	internal class Node implements IPoolableObject
	{
		public var g:Number;
		public var h:Number;
		public var u:int; //horizontal index
		public var v:int; //vertical index
		public var isVisited:Boolean;
		public var parent:Node;
		
		public function Node()
		{
			initialize();
		}
		
		public function checkout():void
		{
			initialize();
		}
		
		private function initialize():void
		{
			g = 0;
			h = 0;
			u = 0;
			v = 0;
			isVisited = false;
			parent = null;
		}
		
		public function get f():Number
		{
			return g + h;
		}
		
		public function checkin():void
		{
		}
		
		public function dispose():void
		{
			initialize();
		}
		
		public function toString():String
		{
			return StringUtil.format("%d_%d ,f: %d, g: %d, h: %d", u, v, f, g, h);
		}
	}
}