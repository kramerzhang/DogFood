package com.kramer.inventory
{
	public class ItemFactory
	{
		public function ItemFactory()
		{
		}
		
		public function getItem(id:int):Item
		{
			throw new Error("Should be implemented in subclass");
		}
	}
}