package com.kramer.resource.item
{
	/**
	 *@author Kramer 
	 */	
	import com.kramer.resource.constant.ResourceType;
	import com.kramer.resource.events.ResourceEvent;
	
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class LinkageItem extends SwfItem
	{
		private static const LINKAGE_NAME:String = "item";
		private var _itemClz:Class;
		
		public function LinkageItem(url:String)
		{
			super(url, null);
		}
		
		override public function copyContent(item:ILoadable):void
		{
			var linkageItem:LinkageItem = item as LinkageItem;
			_itemClz = linkageItem._itemClz;
			dispatchEvent(new ResourceEvent(ResourceEvent.COMPLETE, getContent()));
		}
		
		override public function getContent():*
		{
			var item:DisplayObject;
			if(_itemClz == null)
			{
				var appDomain:ApplicationDomain = _loader.contentLoaderInfo.applicationDomain;
				if(appDomain && appDomain.hasDefinition(LINKAGE_NAME))
				{
					_itemClz = appDomain.getDefinition(LINKAGE_NAME) as Class;
				}
			}
			item =  new _itemClz();
			return item;
		}
		
		override public function getType():String
		{
			return ResourceType.LINKAGE;
		}
	}
}