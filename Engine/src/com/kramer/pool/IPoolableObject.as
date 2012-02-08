package com.kramer.pool
{
	import com.kramer.core.IDisposable;

	public interface IPoolableObject extends IDisposable
	{
		function checkout():void;
		function checkin():void;
	}
}