package nl.comm
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import nl.util.Net;
	
	public class MovieLoader extends EventDispatcher
	{
		private var _loader: Loader;
		private var _timer: Timer;
		private var _errUrl: String = "";
		private var _loadStep: int = 0;		// 载入步伐： 0=载入前（未开始） 1=载入中  2=已载入（完成）
		private var _mvc: MovieClip;
		private var _bmp: Bitmap;
		private var _err : Boolean = false;
		private var _bytesTotal: int;
		private var _bytesLoaded: int;
	//	private var req : URLRequest;
		private var self: MovieLoader;
		
		public function get loader(): Loader { return _loader; }
		public function get errUrl(): String { return _errUrl; }
		public function get isLoaded(): Boolean { return _loadStep == 2; } 
		public function get isLoading(): Boolean { return _loadStep == 1; }
		public function get mvc(): MovieClip { return _mvc; }
		public function get bmp(): Bitmap { return _bmp; }
		public function get err(): Boolean { return _err; }
		public function get bytesTotal(): int { return _bytesTotal; }
		public function get bytesLoaded(): int { return _bytesLoaded; }
		
		public function MovieLoader()
		{
			super();
			self = this;
			_loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
		//	loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			
			_timer = new Timer(500);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function loadBytes(url: String): Boolean
		{
			Net.getStream(url, function (d: ByteArray): void {
				var lc: LoaderContext = new LoaderContext(); 
				lc.allowCodeImport = true;
				loader.loadBytes(d, lc);
			});
			return true;
		}
		
		public function load(url: String): Boolean
		{ 
			if (_loadStep > 0) return false;
			_errUrl = url;
			var req : URLRequest = new URLRequest(url);
			loader.load(req);
			_loadStep = 1;
			_timer.start();
			self.dispatchEvent(new Event("MOVIE_LOADER_START"));
			return true;
		}
		
		private function onLoaderComplete(e: Event): void
		{
			_loadStep = 2;
			_timer.stop();
			
			if (e.target.content is MovieClip) { _mvc = e.target.content; }
			else if (e.target.content is Bitmap) { _bmp = e.target.content; }
			
			self.dispatchEvent(new Event("MOVIE_LOADER_LOADED"));
		}
		
		private function onLoaderIOError(e: IOErrorEvent): void
		{
			_timer.stop();
			self._err = true;
			self.dispatchEvent(new Event("MOVIE_LOADER_IOERROR"));
		}
		
		/*private function onProgress(e: ProgressEvent) : void
		{
			_bytesLoaded = loader.contentLoaderInfo.bytesLoaded;
			_bytesTotal = loader.contentLoaderInfo.bytesTotal;
			self.dispatchEvent(new Event("MOVIE_LOADER_PROGRESS"));
		} */
		
		private function onTimer(e: TimerEvent): void
		{
			_bytesLoaded = loader.contentLoaderInfo.bytesLoaded;
			_bytesTotal = loader.contentLoaderInfo.bytesTotal;
			self.dispatchEvent(new Event("MOVIE_LOADER_PROGRESS"));
		}
	}
}
