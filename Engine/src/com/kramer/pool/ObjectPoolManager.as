package com.kramer.pool
{
	public class ObjectPoolManager
	{
		private static var _instance:ObjectPoolManager;
		
		private var _pool:ObjectPool;
		
		public function ObjectPoolManager(blocker:Blocker)
		{
		}
		
		public static function getInstance():ObjectPoolManager
		{
			if(_instance == null)
			{
				_instance = new ObjectPoolManager(new Blocker());
			}
			return _instance;
		}
		
		public function getObject(clz:Class):IPoolableObject
		{
			var pool:ObjectPool = getPool(clz);
			return pool.getObject();
		}
		
		public function recycle(clz:Class, obj:IPoolableObject):void
		{
			var pool:ObjectPool = getPool(clz);
			pool.recycle(obj);
		}
		
		public function getPool(clz:Class):ObjectPool
		{
			if(_pool == null)
			{
				_pool = new ObjectPool(clz);
			}
			return _pool;
		}
	}
}

class Blocker{}