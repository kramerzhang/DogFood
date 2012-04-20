package com.kramer.pathfinder
{
	import com.kramer.pool.ObjectPool;
	import com.kramer.trove.HashMap;
	
	import flash.geom.Point;

	internal class NodeMatrix
	{
		public static const WLAKABLE:int 	= 0;
		public static const BLOCK:int 		= 1;
		
		private static const STEP_WEIGHT:Array 	= [1, 1, 1, 1];
		private static const MOVE_STEP:Array 	= [[0, -1], [1, 0], [0, 1], [-1, 0]];
		
		private var _data:Vector.<Vector.<int>>;
		private var _width:int;
		private var _height:int;
		
		private var _openedNodeVec:Vector.<Node>;
		private var _nodeMap:HashMap;
		private var _nodePool:ObjectPool;
		
		private var _startNode:Node;
		private var _targetNode:Node;
		private var _heuristic:IHeuristic;
		
		public function NodeMatrix()
		{
			initialize();
		}
		
		private function initialize():void
		{
			_nodeMap = new HashMap();
			_nodePool = new ObjectPool(Node);
		}
		
		public function setData(data:Vector.<Vector.<int>>):void
		{
			_data = data;
			_width = _data[0].length;
			_height = _data.length;
			reset();
		}
		
		public function set start(value:Point):void
		{
			_startNode = getNode(value.x, value.y);
			_openedNodeVec.push(_startNode);
		}
		
		public function set target(value:Point):void
		{
			_targetNode = getNode(value.x, value.y);
		}
		
		public function set heuristic(value:IHeuristic):void
		{
			_heuristic = value;
		}
		
		private function getNodeAdjacent(currentNode:Node):Vector.<Node>
		{
			var result:Vector.<Node> = new Vector.<Node>();
			var currentU:int = currentNode.u;
			var currentV:int = currentNode.v;
			var len:int = MOVE_STEP.length;
			for(var i:int = 0; i < len; i++)
			{
				var step:Array = MOVE_STEP[i];
				var u:int = currentU + step[0];
				var v:int = currentV + step[1];
				if(u < 0 || v < 0 || u > (_width - 1) || v > (_height - 1))
				{
					continue;
				}
				if(_data[v][u] == BLOCK)
				{
					continue;
				}
				var node:Node = getNode(u, v);
				if(node.isVisited == true)
				{
					continue;
				}
				var g:Number = currentNode.g + STEP_WEIGHT[i];
				if(node.g == 0 || (node.g > 0 && g < node.g))
				{
					node.g = g;
					node.h = _heuristic.evaluate(node, _targetNode);
					node.parent = currentNode;
				}
				result.push(node);
			}
			return result;
		}
		
		private function getNode(u:int, v:int):Node
		{
			var key:String = u + "_" + v;
			if(_nodeMap.containsKey(key) == false)
			{
				var node:Node = _nodePool.getObject() as Node;
				node.u = u;
				node.v = v;
				_nodeMap.put(key, node);
			}
			return _nodeMap.get(key);
		}
		
		public function findPath():Vector.<Point>
		{
			var result:Vector.<Point> = new Vector.<Point>();
			while(_openedNodeVec.length > 0)
			{
				var node:Node = _openedNodeVec.pop();
				node.isVisited = true;
				if(node == _targetNode)
				{
					result = constructPath(node);
					break;
				}
				var adjacentNodeVec:Vector.<Node> = getNodeAdjacent(node);
				for each(var adjacentNode:Node in adjacentNodeVec)
				{
					if(_openedNodeVec.indexOf(adjacentNode) == -1)
					{
						_openedNodeVec.push(adjacentNode);
					}
				}
			}
			return result;
		}
		
		private function constructPath(node:Node):Vector.<Point>
		{
			var result:Vector.<Point> = new Vector.<Point>();
			while(node != null)
			{
				var point:Point = new Point(node.u, node.v);
				result.unshift(point);
				node = node.parent;
			}
			return result;
		}
		
		private function sortOpenNode():void
		{
			_openedNodeVec = _openedNodeVec.sort(sortFunction);
		}
		
		private function sortFunction(a:Node, b:Node):int
		{
			if(a.f < b.f)
			{
				return 1;
			}
			if(a.f > b.f)
			{
				return -1;
			}
			return 0;
		}
		
		private function reset():void
		{
			var nodeArr:Array = _nodeMap.getValues();
			for each(var node:Node in nodeArr)
			{
				_nodePool.recycle(node);
			}
			_nodeMap.clear();
			_openedNodeVec = new Vector.<Node>();
		}
		
	}
}