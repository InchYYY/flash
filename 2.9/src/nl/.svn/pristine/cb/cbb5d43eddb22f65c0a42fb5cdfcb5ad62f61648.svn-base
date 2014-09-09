package nl.paint
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import nl.paint.Round;

	import nl.themotionstudio.utils.DebugWindow;
	import nl.comm.PNGEncoder;
	
	public class DrawCurve extends MovieClip
	{
		public var pic : Sprite = new Sprite();
		public var picMouth : Bitmap = new Bitmap();
		public var msg : DebugWindow;
		public var ufUrl : String;
		public var headBitmap : Object;
		private var picMap : Sprite = new Sprite();
		private var pBitMap : Bitmap;
		private var picMsk : Sprite = new Sprite();
		private var head : Round;
		private var mouth : Round;
		private var a : Array = new Array();
		private var f : Array = new Array();
		private var self : MovieClip;
		private var msk : Sprite = new Sprite();
		private var drwHead : Sprite = new Sprite();
		private var drwMouth : sayMouth;
		private var picWidth : Number;
		private var picHeight : Number;
		private var stepIndex : int = 0;
		private var mthStep : Number = 1;
		private var uploadCount : int;
		private var uploadUrl : String;
		
		public function DrawCurve()
		{
			self = this;
			drawHead();
			pic.addEventListener(MouseEvent.MOUSE_DOWN, picDrag);
			pic.addEventListener(MouseEvent.MOUSE_UP, picStopDrag);
			pic.addEventListener(MouseEvent.MOUSE_OUT, picStopDrag);
			pc.addChild(pc.bg);
			pc.addChild(pic);
			pc.addChild(picMouth);
			pc.addChild(msk);
			msk.mouseEnabled = false;
			pc.topLine.mouseEnabled = false;
			pc.bottomLine.mouseEnabled = false;
			pc.addChild(drwHead);
			drawMouth();
			pc.addChild(pc.topLine);
			pc.addChild(pc.bottomLine);
			toolBar.addEventListener("TBPIC_ZOOM_CHANGE", function (e : Event) { setSize(toolBar.zoom); });
			toolBar.addEventListener("TBPIC_ROTATE_CHANGE", function (e : Event) { setRotation(toolBar.rotate); });
			toolBar.addEventListener("TBPIC_STEP_CHANGE", step);
			toolBar.addEventListener("TBPIC_HEAD_RESET", function (e : Event) { drawHead(); drawMsk(1); });
			toolBar.addEventListener("TBPIC_MOUTH_TEST", mouthPlay);
			toolBar.addEventListener("TBPIC_UPLOAD", upload);
			btClose.addEventListener(MouseEvent.CLICK, function (e : MouseEvent) { resetAll(); self.dispatchEvent(new Event("DRAWCURVE_CLOSE")); });
			if (stage) { msg = new DebugWindow(150, 120); }
		}
		private function resetAll()
		{
			drawHead();
			drwMouth.visible = false;
			drwMouth.R = null;
			drawMouth();
			drwMouth.visible = false;
		}
		private function drawHead()
		{
			if (head != null)
			{
				for (var i : Number = drwHead.numChildren - 1; i >= 0; i --) { drwHead.removeChildAt(i); }
			}
			head = new Round(new Point(5, -15));
			drwHead.addChild(head);
			head.addAnchor(0, -136, 70, -106 );
			head.addAnchor(-90, -29, -70, -106);
			head.addAnchor(-86, 38, -88, 16);
			head.addAnchor(0, 134, -58, 110);
			head.addAnchor(84, 38, 58, 110);
			head.addAnchor(89, -30, 87, 17);
			head.addEventListener("ROUND_CHANGE", function (e : Event) { drawMsk(1); })
		}
		
		private function drawMouth()
		{
			drwMouth = new sayMouth(pc, [[-23, 65, -23, 88], [35, 65, 5, 65], [35, 103, 35, 88], [-23, 103, 6, 113]]);
			drwMouth.addEventListener("SAYMOUTH_CHANGE", function (e : Event) { drawMsk(2); })
			mouth = drwMouth.R;
		}
		
		public function setPic(p : Bitmap)
		{
			if (pBitMap)
			{
				picMap.removeChild(pBitMap);
				picMap.x = picMap.y = 0;
				resetAll();
			}
			pBitMap = p;
			var k : Number = p.width / p.height;
			if (k > 400 / 340) { picWidth = 400; picHeight = 400 / k; }
			else { picWidth = 340 * k; picHeight = 340; }
			picMap.addChildAt(p, 0);
			pic.addChild(picMap);
			pic.addChild(picMsk);
			p.x = -p.width / 2;
			p.y = -p.height / 2;
			toolBar.setSite();
			toolBar.setZoom(.33);
			toolBar.setRotate(.5);
		}
		
		public function setSize(k : Number) : void
		{
			var r : Number = picMap.rotation;
			picMap.rotation = 0;
			picMap.width = picWidth * k;
			picMap.height = picHeight * k;
			picMap.rotation = r;
		}
		
		private function setRotation(r : Number) : void
		{
			var ox : Number = picMap.x;
			var oy : Number = picMap.y;
			picMap.x = -200;
			picMap.y = -170;
			picMap.rotation = r;
			picMap.x = ox;
			picMap.y = oy;
		}
		
		private function picDrag(m : MouseEvent) : void
		{
			if (stepIndex == 0) { picMap.startDrag(); }
		}
		
		private function picStopDrag(m : MouseEvent) : void
		{
			picMap.stopDrag();
		}
		
		private function drawMsk(mode : int = 0)
		{
			msk.graphics.clear();
			msk.graphics.beginFill(0x7DB1A6);
			switch (mode)
			{
			case 0 :
				head.draw(msk);
				break;
			case 1 :
				msk.graphics.drawRect(-206, -178, 410, 350);
				head.draw(msk);
				pic.mask = null;
				break;
			case 2 :
				head.draw(msk);
				pic.mask = msk;
				break;
			}
			msk.graphics.endFill();
			msk.alpha = 0.8;
		}
		
		public function step(e : Event = null) : void
		{
			stepIndex = e == null ? 0 : toolBar.stepIndex;
			toolBar.stopClick();
			switch (stepIndex)
			{
			case 0 :
				headBitmap = null;
				pc.topLine.visible = pc.bottomLine.visible = true;
				drwHead.visible = false;
				drwMouth.visible = false;
				pc.bg.visible = false;
				drawMsk(1);
				break;
			case 1 :
				pc.topLine.visible = pc.bottomLine.visible = false;
				drwHead.visible = true;
				drwMouth.visible = false;
				pc.bg.visible = false;
				drawMsk(1);
				break;
			case 2 :
				pc.topLine.visible = pc.bottomLine.visible = false;
				drwHead.visible = false;
				drwMouth.visible = true;
				pc.bg.visible = true;
				drawMsk(2);
				break;
			case 3 :
				pc.topLine.visible = pc.bottomLine.visible = false;
				drwHead.visible = false;
				drwMouth.visible = false;
				pc.bg.visible = true;
				drawMsk(2);
				break;
			}
		}
		
		private function mouthPlay(e : Event) : void
		{
			drwMouth.setMouth(picMap);
			drwMouth.say(1, 1, 3);
			drwMouth.R.visible = false;
			drwMouth.addEventListener("SAYMOUTH_SAYED", function (e : Event) {
				drwMouth.R.visible = true;
				drwMouth.clearMouth();
			});
		}
		
		private function imgUpload(bd : BitmapData, surl : String)
		{
			var request : URLRequest = new URLRequest(surl);
			request.data = PNGEncoder.encode(bd);
			request.method = URLRequestMethod.POST;
			request.contentType = "application/octet-stream";
			var loaders : URLLoader = new URLLoader();
			loaders.load(request);
			loaders.addEventListener(Event.COMPLETE, ulComplete);
		}
		
		private function actUpload(data : URLVariables, surl : String)
		{
			var rq : URLRequest = new URLRequest(surl);
			rq.method = URLRequestMethod.POST;
			//rq.contentType = "text/html";
			rq.data = data
			var loaders : URLLoader = new URLLoader();
			loaders.load(rq);
			loaders.addEventListener(Event.COMPLETE, ulComplete);
		}
		private function upload(e : Event) : void
		{
			self.dispatchEvent(new Event("DRAWCURVE_UPLOADING"));
			uploadCount = 2;
			//uploadUrl = "http://localhost/site/";
			uploadUrl = ufUrl + "User/Photo/";
			var obj : Object = head.getBitmapData(picMap, {width : 300, height : 360});
			headBitmap = {data : obj.data, url : "", zoom : obj.zoom, rect : obj.rect, url : ""}
			if (msg && msg.parent == stage) { self.dispatchEvent(new Event("DRAWCURVE_UPLOADED")); return; }
			imgUpload(headBitmap.data, uploadUrl + "UploadPhoto");
			resetAll();
		}
		
		private function ulComplete(e : Event)
		{
			if (msg) { msg.showMessage(uploadCount + "#" + e.target.data.slice(0, 20)); }
			uploadCount --;
			//if (uploadCount == 1) { imgUpload(getBitmapData(mouth, {width : 300, height : 360, round : head}).data, uploadUrl + "upload2"); }
			if (uploadCount == 1)
			{
				var v : URLVariables = new URLVariables();
				v.nm = "我的头像";
				//v.mouth = drwMouth.getPoints(150, 180, headBitmap.zoom);msg.showMessage(v.mouth);
				v.mouth = drwMouth.getPoints(headBitmap.rect.x, headBitmap.rect.y, headBitmap.zoom);
				headBitmap.mouth = v.mouth;
				headBitmap.name = v.nm;
				actUpload(v, uploadUrl + "AddMyHead");
			}
			if (uploadCount <= 0)
			{
				headBitmap.url = ufUrl + e.target.data;
				self.dispatchEvent(new Event("DRAWCURVE_UPLOADED"));
			}
		}
		
	}
}
