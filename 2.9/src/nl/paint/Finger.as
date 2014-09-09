package nl.paint
{
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class Finger extends Sprite
	{
		private var center : Point;
		
		public function Finger(p : Point, prn : Sprite)
		{
			center = p;
			super();
			graphics.lineStyle(1, 0x0000FF);
			graphics.beginFill(0x5555aa, .5);
			graphics.drawRoundRect(-5, -5, 10, 10, 10);
			graphics.endFill();
			x = p.x;
			y = p.y;
			prn.addChild(this);
		}
	}
}