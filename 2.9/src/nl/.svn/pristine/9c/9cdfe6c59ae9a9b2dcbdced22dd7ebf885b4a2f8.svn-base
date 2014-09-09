package nl.paint
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
    public class sayMouth extends MovieClip
	{
		public var R : Round;
		private var self : sayMouth;
		private var head : Sprite;
		public var mouth : Bitmap;
		private var length : Number;
		private var yo : Number;
		private var sayTimer : Timer;
		private var step : Number;
		private var sayC : int;
		private var picH : DisplayObject;
		
		public function sayMouth(h : Sprite, p : Array)
		{
			self = this;
			head = h;
			R = new Round();
			addChild(R);
			//var p : Array = [[-23, 65, -23, 88], [35, 65, 5, 65], [35, 103, 35, 88], [-23, 103, 6, 113]];
			var m0 : Anchor = R.addAnchor(p[0][0], p[0][1], p[0][2], p[0][3], null, true);
			var m1 : Anchor = R.addAnchor(p[1][0], p[1][1], p[1][2], p[1][3], null, true);
			var m2 : Anchor = R.addAnchor(p[2][0], p[2][1], p[2][2], p[2][3], null, true);
			var m3 : Anchor = R.addAnchor(p[3][0], p[3][1], p[3][2], p[3][3], null, true);
			//var m0 = R.addAnchor(-23, 65, -23, 88, null, true);
			//var m1 = R.addAnchor(35, 65, 5, 65, null, true);
			//var m2 = R.addAnchor(35, 103, 35, 88, null, true);
			//var m3 = R.addAnchor(-23, 103, 6, 113, null, true);
			m0.setPoint({finger : false})
			m2.setPoint({point : false, finger : false})
			m3.setPoint({point : false})
			var isM : Boolean = false;
			m1.addEventListener("ANCHOR_DRAW", function(e : Event) : void {
				if (isM) { return; }
				m2.x = m1.x;
				m2.finger.x = m1.x;
				m2.finger.y = (m1.y + m2.y) / 2;
				m3.finger.x = m1.finger.x;
				isM = true;
				m2.draw();
				m3.draw();
				isM = false;
			});
			m0.addEventListener("ANCHOR_DRAW", function(e : Event) : void {
				if (isM) { return; }
				m3.x = m0.x;
				m0.finger.x = m0.x;
				m0.finger.y = (m0.y + m3.y) / 2;
				isM = true;
				m3.draw();
				m2.draw();
				isM = false;
			});
			m3.addEventListener("ANCHOR_DRAW", function(e : Event) : void {
				if (isM) { return; }
				m3.y = m3.finger.y - (11 * (m3.finger.y / 143) - 1);
				m0.finger.y = (m3.y + m0.y) / 2;
				m2.y = m3.y;
				m2.finger.y = (m2.y + m1.y) / 2;
				m1.finger.x = m3.finger.x;
				isM = true;
				m0.draw();
				m1.draw();
				m2.draw();
				isM = false;
			});
			R.addEventListener("ROUND_CHANGE", function(e : Event) : void { self.dispatchEvent(new Event("SAYMOUTH_CHANGE")); })
			head.addChild(self);
			sayTimer = new Timer(100, 5);
			sayTimer.addEventListener(TimerEvent.TIMER, function(e : TimerEvent) : void {
				if (sayTimer.currentCount == sayC + 1) { step = (yo - mouth.y) / sayC; }
				if (sayTimer.currentCount <= sayC || sayTimer.repeatCount - sayTimer.currentCount < sayC) { mouth.y += step; }
			});
			sayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e : TimerEvent) : void { self.dispatchEvent(new Event("SAYMOUTH_SAYED")); });
		}
		
		public function setMouth(pic : DisplayObject) : void
		{
			clearMouth();
			picH = pic;
			var bd : Object = R.getBitmapData(pic);
			self.graphics.beginFill(0);
			R.draw(self, 0, 0);
			self.graphics.endFill();
			mouth = new Bitmap(bd.data);
			self.addChild(mouth);
			mouth.x = bd.rect.x;
			mouth.y = bd.rect.y;
			yo = mouth.y;
			length = bd.rect.height / 2;
		}
		
		public function clearMouth() : void
		{
			self.graphics.clear();
			if (mouth == null) { return; }
			self.removeChild(mouth);
			mouth = null;
		}
		
		public function getPoints(xo : Number, yo : Number, k : Number) : String
		{
			var p : Array = R.getPoints();
			var i : int;
			var r : String = "";
			for (i = 0; i < p.length; i += 2)
			{
				p[i] = int(p[i] * k - xo + .5);
				p[i + 1] = int(p[i + 1] * k - yo + .5);
			}
			for (i = 0; i < p.length; i += 4)
			{
				if (i > 0) { r += ","; }
				r += "[" + p[i] + "," + p [i + 1] + "," + p [i + 2] + "," + p [i + 3] + "]";
			}
			return "[" + r + "]";
		}
		
		public function say(v : Number = 1, c : int = 3, o : int = 0) : void
		{
			if (mouth == null) { return; }
			sayC = c;
			sayTimer.reset();
			sayTimer.repeatCount = c * 2 + o;
			step = ((length * v) + yo - mouth.y) / c;
			sayTimer.start();
		}
   }
}