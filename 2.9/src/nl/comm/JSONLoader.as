﻿package nl.comm
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	import nl.util.json.JSON;
	
	/**
	 * JSONLoader加载器，这个类是个工具类，可以同时加载多个xml数据 ，在JSONLoader内部使用奴隶与死囚优化法则来减小内存消耗。
	 * @author qiuxin
	 * 
	 */	
	public class JSONLoader extends URLLoader
	{
		private static var limbo:Dictionary = new Dictionary(true);
		
		private var loadding:Boolean;
		private var competeHandle:Function;
		private static var _url:String;
		
		public function JSONLoader(request:URLRequest = null)
		{
			super(request);
			
			addEventListener(Event.COMPLETE, xmlLoadComplete);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandle);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandle);
		}
		
		public static function load(url:String, competeHandle:Function, variables:URLVariables = null, method:String = "GET"):void
		{
			var request:URLRequest;
			var loader:JSONLoader
			_url = url;
			//在缓存寻找非运作的loader
			for (var criminal:Object in limbo)
			{
				if (! JSONLoader(criminal).loadding)
				{
					loader = criminal as JSONLoader;
					request = limbo[loader] as URLRequest;
					request.url = url;
					break;
				}
			}
			//未找到则重新创建
			if (! loader)
			{
				request = new URLRequest(url);
				loader = new JSONLoader(request);
				limbo[loader] = request;
			}
			request.data = variables;
			request.method = method;
			loader.competeHandle = competeHandle;
			loader.load(request);
			loader.loadding = true;
		}
		
		
		
		private function ioErrorHandle(event:IOErrorEvent):void
		{
			trace("加载xml时服务器未能返回");
			competeHandle({err : "加载xml时服务器未能返回"});
		}
		
		
		private function securityErrorHandle(event:SecurityErrorEvent):void
		{
			trace("加载xml时发生安全沙箱错误");
			competeHandle({err : "加载xml时发生安全沙箱错误"});
		}
		
		
		private function xmlLoadComplete(event:Event) : void
		{
			loadding = false;
			var result:Object = nl.util.json.JSON.decode(event.target.data);
			result.resultData = event.target.data;
			competeHandle(result);
		}
	}
}

