package nl.comm
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class mLoad extends EventDispatcher
	{
		public var isLoaded  : Boolean; 
		public var isLoading : Boolean;
		private var parent : Sprite;
		public var mc : MovieClip;
		public var img : Bitmap;
		public var flvVideo:Video;
		public var flvNetStr:NetStream;
		private var cs:Number;
		private var visible : Boolean;
		private var onActive : Function;
		public var loader : Loader;
		public var surl : String;
		public var err : Boolean = false;
		private var x : Number = 0;
		private var y : Number = 0;
		private var URL : URLRequest;
		private var siteMode:uint = 0;
		private var initX:Number = 3;
		private var initY:Number = 3;
		private var self : mLoad;
		public var initW : Number = 890;
		public var initH : Number = 545;
		public var scale : Object = {"loaded" : 0, "total" : 0, "process" : 0};

		public function mLoad (u : String, p : Sprite = null)
		{ 
			isLoaded = false;
			isLoading = false;
			visible = true;
			surl = u;
			URL = new URLRequest(u);
			parent = p;
			cs = 0;
			loader = new Loader();
			self = this;
		}
	
		public function show(prm : Object = null, after : Sprite = null) : void
		{
			var f : Function = function () : void {
				if (after == null) { parent.addChild(mc); }
				else { parent.addChildAt(mc, parent.getChildIndex(after)); }
				if (prm == null) { self.dispatchEvent(new Event("MLOAD_SHOWED")); }
				else
				{
					var f1 : Function = function (e : Event) : void {
						if ( prm.step >= prm.count )
						{
							mc.removeEventListener(Event.ENTER_FRAME, f1);
							self.dispatchEvent(new Event("MLOAD_SHOWED"));
							return;
						}
						switch (prm.mode)
						{
						case 1 :
							if (prm.x != null) { mc.x = (1 - Math.sin((prm.step / prm.count) * 1.571)) * prm.x + self.x; }
							if (prm.y != null) { mc.y = (1 - Math.sin((prm.step / prm.count) * 1.571)) * prm.y + self.y; }
							break;
						case 2 :
							mc.alpha = prm.step / (prm.count - 1);
						}
						prm.step ++;
					};
					prm.step = 0;
					switch (prm.mode)
					{
					case 1 :
						if (prm.x != null) { mc.x = prm.x + self.x; }
						if (prm.y != null) { mc.y = prm.y + self.y; }
						break;
					case 2 :
						mc.alpha = 0;
					}
					mc.addEventListener(Event.ENTER_FRAME, f1);
				}
			};
			if (isLoaded) { f(); }
			else
			{
				addEventListener("MLOAD_LOADED", f);
				load();
			}
		}
		
		public function hide(prm : Object = null) : void
		{
			var f : Function = function () : void {
				if (prm == null)
				{
					parent.removeChild(mc);
					self.dispatchEvent(new Event("MLOAD_HIDED"));
				}
				else
				{
					var f1 : Function = function (e : Event) : void {
						if ( prm.step >= prm.count )
						{
							mc.removeEventListener(Event.ENTER_FRAME, f1);
							parent.removeChild(mc);
							self.dispatchEvent(new Event("MLOAD_HIDED"));
							return;
						}
						switch (prm.mode)
						{
						case 1 :
							if (prm.x != null) { mc.x = Math.sin((prm.step / prm.count) * 1.571) * prm.x + self.x; }
							if (prm.y != null) { mc.y = Math.sin((prm.step / prm.count) * 1.571) * prm.y + self.y; }
							break;
						case 2 :
							mc.alpha = (prm.count - prm.step) / prm.count;
							break;
						}
						if (prm.step * 2 >= prm.count && half) { self.dispatchEvent(new Event("MLOAD_HIDIMG")); half = false; }
						prm.step ++;
					};
					prm.step = 0;
					var half : Boolean = true;
					mc.addEventListener(Event.ENTER_FRAME, f1);
				}
			};
			if (isLoaded) { f(); }
			else
			{
				addEventListener("MLOAD_LOADED", f);
				load();
			}
		}
		
		public function load() : void
		{ 
			if (isLoading || isLoaded) { return; }
			var t : Timer = new Timer(500);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (evt:Event) : void {
				isLoaded = true;
				isLoading = false;
				if (evt.target.content is MovieClip) { mc = evt.target.content; }
				else if (evt.target.content is Bitmap) { img = evt.target.content; }
				loader.removeEventListener(Event.ENTER_FRAME, chkPrc);
				self.dispatchEvent(new Event("MLOAD_LOADED"));
				t.stop();
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function (e : IOErrorEvent) : void {
				self.err = true;
				self.dispatchEvent(new Event("MLOAD_IOERROR"));
			});
			loader.load(URL);
			t.addEventListener(TimerEvent.TIMER, chkPrc);
			t.start();
			isLoading = true;
			self.dispatchEvent(new Event("MLOAD_STARTLOAD"));
		}
		
		public function loadVdieo(w:int, h:int): void
		{
			var flvNetCon:NetConnection;
			var flvObject:Object=new Object();
			var flvURL:String = surl;
			flvNetCon=new NetConnection();
			flvNetCon.connect(null);
			flvNetStr=new NetStream(flvNetCon);
			flvNetStr.addEventListener(AsyncErrorEvent.ASYNC_ERROR,function(e:Event):void{
				self.dispatchEvent(new Event("MLOAD_LOADED"));
				trace("MLOAD_LOADED")
			});
			//flvNetStr.addEventListener(NetStatusEvent.NET_STATUS,当前视频流状态);
			flvNetStr.client=flvObject;
			flvNetStr.play(flvURL);
			flvVideo=new Video(w,h);
			flvVideo.attachNetStream(flvNetStr);
			self.dispatchEvent(new Event("MLOAD_STARTLOAD"));
			flvNetStr.pause();
			self.dispatchEvent(new Event("MLOAD_MOVIED_LOADED"));
			trace("loadVdieo")
			isLoaded = true;
		}
		
		public function Reload () : void
		{
			if (isLoaded)
			{
				loader.load(URL);
				parent.addChild(loader);
			}
		}
		
		private function chkPrc(e : TimerEvent) : void
		{
			scale.loader = loader.contentLoaderInfo.bytesLoaded;
			scale.total = loader.contentLoaderInfo.bytesTotal;
			scale.process = loader.contentLoaderInfo.bytesLoaded / loader.contentLoaderInfo.bytesTotal * 100;
			self.dispatchEvent(new Event("MLOAD_LOADING"));
		}
		
		private function site() : void
		{
			if (mc == null) return;
			switch (siteMode)
			{
				case 1:
					mc.x = initX + x;
					mc.y = initY + y;
				break;
				case 4:
					mc.x = x;
					mc.y = initH + initY + y;
				break;
				case 5:
					mc.x = initW / 2 + initX + x;
					mc.y = initH / 2 + initY + y;
				break;
				default:
				mc.x = x;
				mc.y = y;
				return;
			}
			return;
		}
		
		public function setSite(sx : Number, sy : Number, md : uint = 0) : void
		{
			x = sx;
			y = sy;
			siteMode = md;
			if (isLoaded) { site(); }
			else
			{
				var f : Function = function(e : Event) : void {
					site();
					removeEventListener("MLOAD_LOADED", f);
				};
				addEventListener("MLOAD_LOADED", f);
			}
		}
	
  }
}