package com.kramer.resource.item
{
	/**
	 *@author Kramer 
	 */	
	import com.kramer.resource.ResourceType;
	
	import flash.system.LoaderContext;
	
	public class ImageItem extends SwfItem
	{
		public function ImageItem(url:String, loaderContext:LoaderContext=null)
		{
			super(url, loaderContext);
		}
		
		override public function getType():String
		{
			return ResourceType.IMGAE;
		}
	}
}