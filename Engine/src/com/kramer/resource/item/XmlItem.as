package com.kramer.resource.item
{
	/**
	 *@author Kramer 
	 */	
	import com.kramer.resource.ResourceType;
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
			_xml = XML(_streamLoader.readUTFBytes(_streamLoader.bytesAvailable));
			_streamLoader.close();
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