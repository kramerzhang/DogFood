package com.kramer.resource
{
	/**
	 *@author Kramer 
	 */	
	import com.kramer.resource.cache.CacheHolder;
	import com.kramer.resource.cache.CacheType;
	import com.kramer.resource.item.BinaryItem;
	import com.kramer.resource.item.FrameSheetItem;
	import com.kramer.resource.item.ILoadable;
	import com.kramer.resource.item.ImageItem;
	import com.kramer.resource.item.LinkageItem;
	import com.kramer.resource.item.SoundItem;
	import com.kramer.resource.item.SwfItem;
	import com.kramer.resource.item.XmlItem;
	import com.kramer.trove.HashMap;
	
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import com.kramer.resource.constant.ResourcePriority;
	

	public class ResourceManager
	{
		private static var _cacheMap:HashMap;
		
		public function ResourceManager(blocker:Blocker)
		{
		}
		
		initialize();
		
		private static function initialize():void
		{
			_cacheMap = new HashMap();
		}
		
		public static function loadXml(url:String, 
									   completeHandler:Function, 
									   errHandler:Function = null, 
									   startHandler:Function = null, 
									   progressHandler:Function = null, 
									   priority:int = ResourcePriority.LOW):void
		{
			var xmlItem:XmlItem = new XmlItem(url);
			addItemToLoadingQueue(xmlItem, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		//DLL:dynamic linkage library, load SWFs to current application domain
		public static function loadDLLSwf(url:String, 
										  completeHandler:Function, 
										  errHandler:Function = null, 
										  startHandler:Function = null, 
										  progressHandler:Function = null, 
										  priority:int = ResourcePriority.LOW):void
		{
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			var swfItem:SwfItem = new SwfItem(url, loaderContext);
			addItemToLoadingQueue(swfItem, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		//load SWFs to sub application domain
		public static function loadSwf(url:String, 
									   completeHandler:Function, 
									   errHandler:Function = null, 
									   startHandler:Function = null, 
									   progressHandler:Function = null, 
									   priority:int = ResourcePriority.LOW):void
		{
			var swfItem:SwfItem = new SwfItem(url);
			addItemToLoadingQueue(swfItem, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		public static function loadLinkage(url:String, 
										   completeHandler:Function, 
										   errHandler:Function = null, 
										   startHandler:Function = null, 
										   progressHandler:Function = null, 
										   priority:int = ResourcePriority.LOW):void
		{
			var linkageItem:LinkageItem = new LinkageItem(url);
			addItemToLoadingQueue(linkageItem, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		public static function loadImage(url:String, 
										 completeHandler:Function, 
										 errHandler:Function = null, 
										 startHandler:Function = null, 
										 progressHandler:Function = null, 
										 priority:int = ResourcePriority.LOW):void
		{
			var imageItem:ImageItem = new ImageItem(url);
			addItemToLoadingQueue(imageItem, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		public static function loadFrameSheet(url:String, 
											  completeHandler:Function, 
											  errHandler:Function = null, 
											  startHandler:Function = null, 
											  progressHandler:Function = null, 
											  priority:int = ResourcePriority.LOW):void
		{
			var sheetItem:FrameSheetItem = new FrameSheetItem(url);
			addItemToLoadingQueue(sheetItem, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		public static function loadBinary(url:String, 
										  completeHandler:Function, 
										  errHandler:Function = null, 
										  startHandler:Function = null, 
										  progressHandler:Function = null, 
										  priority:int = ResourcePriority.LOW):void
		{
			var binaryItem:BinaryItem = new BinaryItem(url);
			addItemToLoadingQueue(binaryItem, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		private static function addItemToLoadingQueue(item:ILoadable, 
													  completeHandler:Function, 
													  errHandler:Function = null,
													  startHandler:Function = null, 
													  progressHandler:Function = null, 
													  priority:int = ResourcePriority.LOW):void
		{
			var loadableItem:LoadableItemWrapper = new LoadableItemWrapper(item, completeHandler, startHandler, progressHandler, errHandler, priority);
			LoadingManager.addItem(loadableItem);
		}
		
		public static function loadSound(url:String, 
										 completeHandler:Function, 
										 errHandler:Function = null, 
										 startHandler:Function = null, 
										 progressHandler:Function = null, 
										 priority:int = ResourcePriority.LOW):Sound
		{
			var soundItem:SoundItem = new SoundItem(url);
			addItemToLoadingQueue(soundItem, completeHandler, startHandler, progressHandler, errHandler, priority);
			return soundItem.getContent() as Sound;
		}
		
		public static function getCachedLinkageItem(url:String, 
													completeHandler:Function, 
													errHandler:Function = null, 
													startHandler:Function = null, 
													progressHandler:Function = null, 
													priority:int = ResourcePriority.LOW):void
		{
			var cacheHolder:CacheHolder = getCacheHolder(CacheType.LINKAGE);
			cacheHolder.getCachedItem(CacheType.LINKAGE, url, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		public static function getCachedBinaryItem(url:String, 
												   completeHandler:Function, 
												   errHandler:Function = null, 
												   startHandler:Function = null, 
												   progressHandler:Function = null, 
												   priority:int = ResourcePriority.LOW):void
		{
			var cacheHolder:CacheHolder = getCacheHolder(CacheType.BINARY);
			cacheHolder.getCachedItem(CacheType.BINARY, url, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		public static function getCachedFrameSheetItem(url:String, 
													   completeHandler:Function, 
													   errHandler:Function = null, 
													   startHandler:Function = null, 
													   progressHandler:Function = null, 
													   priority:int = ResourcePriority.LOW):void
		{
			var cacheHolder:CacheHolder = getCacheHolder(CacheType.FRAME_SHEET);
			cacheHolder.getCachedItem(CacheType.FRAME_SHEET, url, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		public static function getCachedItem(type:String, 
											 url:String, 
											 completeHandler:Function, 
											 errHandler:Function = null, 
											 startHandler:Function = null, 
											 progressHandler:Function = null, 
											 priority:int = ResourcePriority.LOW):void
		{
			var cacheHolder:CacheHolder = getCacheHolder(type);
			cacheHolder.getCachedItem(type, url, completeHandler, startHandler, progressHandler, errHandler, priority);
		}
		
		private static function getCacheHolder(type:String):CacheHolder
		{
			if(_cacheMap.containsKey(type))
			{
				return _cacheMap.get(type) as CacheHolder;
			}
			var cacheHolder:CacheHolder = new CacheHolder(type);
			_cacheMap.put(type, cacheHolder);
			return cacheHolder;
		}
		
		public static function cancel(url:String, completeHandler:Function):void
		{
			LoadingManager.cancel(url, completeHandler);
		}
		
		public static function cancelAll():void
		{
			LoadingManager.cancelAll();
		}
		
		public static function clearCache(type:String):void
		{
			if(_cacheMap.containsKey(type))
			{
				var cacheHolder:CacheHolder = _cacheMap.get(type) as CacheHolder;
				cacheHolder.clear();
			}
		}
	}
}

class Blocker{}