package nl.comm
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.controls.Alert;
	
	import spark.components.BorderContainer;
	
	import nl.bron.brCell;
	import nl.bron.brContainer;
	import nl.comm.JSONLoader;
	import nl.comm.LoadManage;
	import nl.comm.mLoad;
	import nl.util.json.JSON;
	import nl.util.Net;
	import nl.funnymessages.clipcontainer.ClipContainer;
	import nl.service.WebServer;
	
    public class changeHeadFx extends BorderContainer
	{
		protected var lm  : LoadManage;
		protected var lmv : mLoad;
		protected var prm : Object;
		protected var sUrl : String = "";
		protected var swfurl : String;
		protected var debug : Boolean = false;
		protected var msgEn : Boolean = false;
		protected var mvOld: ClipContainer;
		public var mv : brContainer;
		private var heads : Array = new Array();
		
		public function changeHeadFx()
		{
			lm = new LoadManage();
			addEventListener(Event.ADDED_TO_STAGE, function (e : Event) : void {
				lm.addEventListener("LOADMANAGE_IOERROR", function (e : Event) : void { Alert.show("IoError : " + e.target.ErrUrl); });
				swfurl = stage.loaderInfo.url.replace(/[^\/]*\.swf[\d\D]*/, "");
				if (debug) { loadMv(); }
				else
				{
					WebServer.initConfig(swfurl);
					if (! sUrl)
					{
						var re : RegExp = new RegExp("http://.*?/", "gi");
						sUrl = re.exec(swfurl);
					}
					JSONLoader.load(sUrl + getPrmUrl() + new Date().time, loadMv);
				}
			});
		}
		
		public function loadMv(r : Object = null) : void {}
		
		public function getPrmUrl() : String { return ""; }
		
		public function setHead(id : int, surl : String, mouthMrk : String = "", nm : String = "") : void
		{
			surl = trim(surl);
			heads[id] = nm + ";" + surl + ";" + mouthMrk;
			if (mouthMrk == "") { mouthMrk = "[[107,123,107,184],[251,119,188,156],[251,244,251,182],[107,244,188,247]]"; }
			var bm: Bitmap;
			var f : Function = function (e: Event = null) : void { mvOld.setHead(id, bm, nl.util.json.JSON.decode(mouthMrk)); };
			Net.getBitmap(surl, function (b: Bitmap): void {
				bm = b;
				if (mvOld) { f(); }
				else { lmv.addEventListener("MLOAD_LOADED", f); }
			});
		}
		
		public function setImage(cell : brCell, surl : String) : void
		{
			
		}
		
		public function getHeads() : String
		{
			var r : String = ""
			for each (var s : String in heads)
			{
				if (r != "") { r += "|"; }
				r += s.replace(sUrl, "");
			}
			return r;
		}
		public function getImag(o: DisplayObject, w: int = 640, h: int = 360) : BitmapData
		{
			var bd : BitmapData = new BitmapData(w, h, true, 0);
			bd.draw(o.parent);
			return bd;
		}
		public function trim(char : String) : String
		{
			if (char == null) return null;
			return rtrim(ltrim(char));
		}
		private function ltrim(char : String) : String
		{
			if (char == null) return null;
			var pattern : RegExp = /^\s*/;
			return char.replace(pattern, "");
		}
		private function rtrim(char : String) : String
		{
			if (char == null) return null;
			var pattern : RegExp = /\s*$/;
			return char.replace(pattern, "");
		}
		
		public function onceEnterFrame(fn: Function, times: int = 1): void
		{
			var i: int = 0;
			var onFn: Function = function (e: Event): void {
				if (i ++ < times) { return; }
				fn();
				removeEventListener(Event.ENTER_FRAME, onFn);
			};
			addEventListener(Event.ENTER_FRAME, onFn);
		}
   }
}