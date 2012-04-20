package com.kramer.pathfinder
{
	public class ManhattanHeuristic implements IHeuristic
	{
		public function ManhattanHeuristic()
		{
		}
		
		public function evaluate(currentNode:Node, targetNode:Node):Number
		{
			return Math.abs(currentNode.u - targetNode.u) + Math.abs(currentNode.v - targetNode.v);
		}
	}
}