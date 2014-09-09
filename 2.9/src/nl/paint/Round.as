package nl.paint
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import nl.paint.Anchor;
	
	public class Round extends Sprite
	{
		private var begin : Anchor;
		private var end : Anchor;
		private var center : Point;
		private var self : Sprite;
		public var msg : String;
		public function Round(c : Point = null)
		{
			center = c ? c : new Point(0, 0);
			self = this;
		}
		
		public function addAnchor(ax : int, ay : int, fx : int, fy : int, p : Anchor = null, isStatic : Boolean = false) : Anchor
		{
			ax += center.x;
			ay += center.y;
			fx += center.x;
			fy += center.y; msg = ax + "/" + ay + "/" + fx + "/" + fy;
			var r : Anchor = new Anchor(self, new Point(ax, ay), new Point(fx, fy), center);
			r.addEventListener("ANCHOR_CHANGE", doChange);
			if (! isStatic)
			{
				r.line.doubleClickEnabled = true;
				r.line.addEventListener(MouseEvent.DOUBLE_CLICK, function(m : MouseEvent) : void {
					var p : Point = self.globalToLocal(new Point(m.stageX, m.stageY));
					var fl : Number = r.dist(r.finger.x, r.finger.y, r.x, r.y);
					var nl : Number = r.dist(p.x, p.y, r.x, r.y);
					if (fl < nl)
					{
						var a : int = r.controlX;
						var b : int = r.controlY;
						addAnchor(r.finger.x - center.x, r.finger.y - center.y, p.x - center.x, p.y - center.y, r);
						r.finger.x = ((a + r.x) / 2 + (r.next.x + r.x) / 2) / 2;
						r.finger.y = ((b + r.y) / 2 + (r.next.y + r.y) / 2) / 2;
					}
					else
					{
						addAnchor(r.finger.x - center.x, r.finger.y - center.y, ((r.controlX + r.next.x) / 2 + (r.finger.x + r.next.x) / 2) / 2 - center.x, ((r.controlY + r.next.y) / 2 + (r.finger.y + r.next.y) / 2) / 2 - center.y, r);
						r.finger.x = p.x;
						r.finger.y = p.y;
					}
					r.draw();
					r.next.draw();
					doChange();
				});
				r.finger.doubleClickEnabled = true;
				r.finger.addEventListener(MouseEvent.DOUBLE_CLICK, function(m : MouseEvent) : void {
					r.previou.next = r.next;
					r.next.previou = r.previou;
					if (begin == r) { begin = r.next; }
					if (end == r) { end = r.previou; }
					r.previou.finger.x = r.x;
					r.previou.finger.y = r.y;
					r.graphics.clear();
					r.finger.graphics.clear();
					self.removeChild(r.line);
					r.previou.draw();
					r.next.draw();
					doChange();
				});
			}
 			if (begin == null)
			{
				begin = r;
				end = r;
				r.previou = r;
				r.next = r;
				return r;
			}
			if (p == null) { p = end; };
			r.previou = p;
			r.next = p.next;
			p.next.previou = r;
			p.next = r;
			r.draw();
			r.previou.draw();
			doChange();
			return r;
		}
		
		private function doChange(e : Event = null) : void
		{
			self.dispatchEvent(new Event("ROUND_CHANGE"));
		}
		
		private function eachAnchor(f : Function, rev : Boolean = false) : void
		{
			var a : Anchor = begin;
			var i : Number = 0;
			do
			{
				f(a, i);
				i ++;
				a = rev ? a.previou : a.next;
			}
			while (a != begin);
		}
		
		public function getPoints() : Array
		{
			var r : Array = [];
			eachAnchor(function(a : Anchor, i : Number) : void {
				r.push(a.x);
				r.push(a.y);
				r.push(a.finger.x);
				r.push(a.finger.y);
			}, true);
			return r;
		}
		
		public function draw(mc : Sprite, xo : Number = 0, yo : Number = 0) : void
		{
			eachAnchor(function (a : Anchor, i : Number) : void {
				if (i == 0) { mc.graphics.moveTo(a.x + xo, a.y + yo); };
				mc.graphics.curveTo(a.controlX + xo, a.controlY + yo, a.next.x + xo, a.next.y + yo);
			});
		}
		
		public function drawMsk(prn : Sprite) : Sprite
		{
			var picMsk : Sprite = new Sprite();
			picMsk.graphics.beginFill(0);
			draw(picMsk);
			picMsk.graphics.endFill();
			prn.addChild(picMsk);
			return picMsk;
		}
		
		public function getBitmapData(pic : DisplayObject, rc : Object = null) : Object
		{
			var r : Rectangle;
			var k : Number = 1;
			var msk : Sprite;
			var prn : Sprite = Sprite(pic.parent);
			if (rc)
			{
				msk = (rc.round != null ? rc.round : self).drawMsk(prn);
				r = msk.getRect(prn);
				var kc : Number = rc.width / rc.height;
				var w : Number = r.width;
				var h : Number = r.height;
				if (r.width / r.height > kc)
				{
					k = rc.width / r.width;
					r.x = r.x * k;
					r.y = (r.y - (r.width / kc - r.height) / 2) * k;
					r.width = rc.width;
					r.height = rc.height;
				}
				else
				{
					k = rc.height / r.height;
					r.x = (r.x - (r.height * kc - r.width) / 2) * k;
					r.y = r.y * k;
					r.width = rc.width;
					r.height = rc.height;
				}
			}
			else
			{
				msk = drawMsk(prn);
				r = msk.getRect(prn);
			}
			var bd : BitmapData = new BitmapData(r.width, r.height, true, 0);
			var m : DisplayObject = prn.mask;
			prn.mask = null;
			pic.mask = msk;
			bd.draw(prn, new Matrix(k, 0, 0, k, -r.x, -r.y));
			pic.mask = null;
			prn.mask = m;
			prn.removeChild(msk);
			return {zoom : k, rect : r, data : bd}
		}
		
	}
}