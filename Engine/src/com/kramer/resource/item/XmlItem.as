package com.kramer.resource.item
{
	/**
	 *@author Kramer 
	 */	
	import com.kramer.resource.constant.ResourceType;
	import com.kramer.resource.events.ResourceEvent;
	
	public class XmlItem extends BinaryItem implements ILoadable
	{
		private var _xml:XML;
		
		public function XmlItem(url:String)
		{
			super(url);
		}
		
		override protected function parseStream():void
		{
			_xml = XML(_content.readUTFBytes(_content.bytesAvailable));
			dispatchEvent(new ResourceEvent(ResourceEvent.COMPLETE, getContent()));
		}
		
		override public function copyContent(item:ILoadable):void
		{
			var xmlItem:XmlItem = item as XmlItem;
			_xml = xmlItem._xml;
			dispatchEvent(new ResourceEvent(ResourceEvent.COMPLETE, getContent()));
		}
		
		override public function getContent():*
		{
			return _xml;
		}
		
		override public function getType():String
		{
			return ResourceType.XML;
		}
	}
}