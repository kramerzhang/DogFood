package com.kramer.resource.item
{
	import com.kramer.resource.cache.CacheType;

	public class LoadableItemFactory
	{
		public function LoadableItemFactory(blocker:Blocker)
		{
		}
		
		public static function createItem(type:String, url:String):ILoadable
		{
			switch(type)
			{
				case CacheType.BINARY:
					return new BinaryItem(url);
				case CacheType.LINKAGE:
					return new LinkageItem(url);
				case CacheType.SOUND:
					return new SoundItem(url);
				case CacheType.FRAME_SHEET:
					return new FrameSheetItem(url);
			}
			return null;
		}
	}
}
class Blocker{}