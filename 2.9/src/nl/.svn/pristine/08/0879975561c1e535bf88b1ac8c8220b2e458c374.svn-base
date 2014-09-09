package nl.paint
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;
	import nl.paint.Finger;
	
	public class Anchor extends Sprite
	{
		public var previou : Anchor;
		public var next : Anchor;
		public var finger : Finger;
		public var line : Sprite;
		public var self : Anchor;
		public var controlX : int;
		public var controlY : int;
		private var center : Point;
		private var pointVisible : Boolean = true;;
		
		public function Anchor(prn : Sprite, a : Point, f : Point, c : Point)
		{
			super();
			center = c;
			self = this;
			x = a.x;
			y = a.y;
			prn.addChild(this);
			addEventListener(MouseEvent.MOUSE_DOWN, fnDrag); 
			addEventListener(MouseEvent.MOUSE_UP, fnStopDrag);
			finger = new Finger(f, prn);
			finger.addEventListener(MouseEvent.MOUSE_DOWN, fnDrag); 
			finger.addEventListener(MouseEvent.MOUSE_UP, fnStopDrag);
			line = new Sprite();
			prn.addChildAt(line, 0);
		}
		
		public function draw() : void
		{
			if (next == null) { return; }
			var k : Number = 1 / (1 + dist(x, y, finger.x, finger.y) / dist(x, y, previou.finger.x, previou.finger.y)) / 2 + .25;
			var cx : Number = (previou.finger.x - finger.x) * k + finger.x;
			var cy : Number = (previou.finger.y - finger.y) * k + finger.y;
			var l : Number = dist(center.x, center.y, x, y);
			var cos : Number = (x - center.x) / l;
			var sin : Number = (y - center.y) / l;
			graphics.clear();
			if (pointVisible)
			{
				graphics.lineStyle(1.5, 0x444D4B);
				graphics.beginFill(0x4e5857, .5);
				graphics.moveTo(10 * cos - 5 * sin, 5 * cos + 10 * sin);
				graphics.lineTo(0, 0);
				graphics.lineTo(10 * cos + 5 * sin, -5 * cos + 10 * sin);
				graphics.lineStyle(1, 0x0000FF, 0);
				graphics.endFill();
			}
			controlX = finger.x * 2 - (next.x + x) / 2;
			controlY = finger.y * 2 - (next.y + y) / 2;
			line.graphics.clear();
			line.graphics.lineStyle(3, 0, .1);
			line.graphics.moveTo(x, y);
			line.graphics.curveTo(controlX, controlY, next.x, next.y);
			line.graphics.lineStyle(1.5, 0x4e5857);//**************线条大小颜色**********************
			line.graphics.moveTo(x, y);
			line.graphics.curveTo(controlX, controlY, next.x, next.y);
			self.dispatchEvent(new Event("ANCHOR_DRAW"));
			//var a : Anchor = self;
			//trace("----------------------");
			//do
			//{
			//	trace(a.x + ", " + a.y + ", " + a.finger.x + ", " + a.finger.y);
			//	a = a.next;
			//}
			//while (a != self)
		}
		
		public function setPoint(obj : Object) : void
		{
			if (obj.point != null && pointVisible)
			{
				pointVisible = obj.point;
				draw();
			}
			if (obj.finger != null) { finger.visible = obj.finger; }
		}
		
		public function dist(x1 : Number, y1 : Number, x2 :Number, y2 : Number) : Number
		{
			return Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
		}
		
		private function fnDrag (m : MouseEvent) : void
		{
			m.target.startDrag();
			m.target.addEventListener(Event.ENTER_FRAME, fnEnter);
		}
		
		private function fnStopDrag (m : MouseEvent) : void
		{
			m.target.stopDrag();
			m.target.removeEventListener(Event.ENTER_FRAME, fnEnter);
			self.dispatchEvent(new Event("ANCHOR_CHANGE"));
		}
		
		private function fnEnter (v : Event) : void
		{
			draw();
			if (v.target != finger) { previou.draw(); }
			if (v.target == self)
			{
				graphics.lineStyle(1, 0x3333aa, 0);
				graphics.beginFill(0x5555aa, 0);
				graphics.moveTo(0, 0);
				graphics.drawRoundRect(-10, -10, 20, 20, 20);
				graphics.endFill();
			}
		}
	}
}