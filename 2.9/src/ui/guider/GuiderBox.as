package ui.guider
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import spark.components.BorderContainer;
	
	import nl.bron.HostCell;
	
	public class GuiderBox extends BorderContainer
	{
		private var _guider: Guider;
		private var _glow: GuiderGlow;

		public function get glowing(): Boolean { return _glow.glowing; }

		public function GuiderBox(guider: Guider)
		{
		//	G.dbg("new GuiderBox");
			_guider = guider;
			
			super();
			setStyle("creationComplete", "edMask.contentGroup.clipAndEnableScrolling = true;");
			setStyle("borderWeight", "1");
			setStyle("borderColor", "0xff0000");
			setStyle("backgroundAlpha", "0.3");
			setStyle("borderAlpha", "1.0");
			
			_glow = new GuiderGlow(0xff00a8);
			_glow.glowCount = 4;
			_glow.onGlowFinished = guider.emitShowGuider;
		}

		private function setBoundsTxt(cell: HostCell): void
		{
		//	G.dbg("setBoundsTxt()");
			var rcX: Number = 0;
			var rcY: Number = 0;
			var rcW: Number = 100;
			var rcH: Number = 100;
			
			if (cell.actor) {
				var rc: Rectangle = cell.actor.getBounds(parent);
				rcX = rc.x;
				rcY = rc.y;
				rcW = rc.width;
				rcH = rc.height;
				
				/*	if ((rcX + rcW) < MIN_VISIBLE) {
				rcX = MIN_VISIBLE - rcW;
				} else if (rcX >= rcW) {
				rcX = rcW - MIN_VISIBLE - 1;
				}
				
				if ((rcY + rcH) < MIN_VISIBLE) {
				rcY = MIN_VISIBLE - rcH;
				} else if (rcY >= rcH) {
				rcY = rcH - MIN_VISIBLE - 1;
				} */
			}
			
			this.x = rcX;
			this.y = rcY;
			this.width = rcW;
			this.height = rcH;
		}
		
		private function setBoundsPic(cell: HostCell): void
		{
		//	G.dbg("setBoundsPic()");
			var cellParent: Sprite = cell.parent as Sprite;
			if (!cellParent) {
				return;
			}
			
			var childIndex: int = cellParent.getChildIndex(cell.actCell);
			if (childIndex < 1) {
				G.popErr("视频模版错误：遮罩层不存在（cell_" + cell.ID + "）");
				return;
			}
			
			var cellMask: DisplayObject = cellParent.getChildAt(childIndex - 1);
			var rc: Rectangle = cellMask.getBounds(parent);
			//	var pg: Point = parent.localToGlobal(new Point(rc.x, rc.y));
			x = rc.x > 0 ? rc.x : 0;
			y = rc.y > 0 ? rc.y : 0;
			
			var v: DisplayObject = this.parent;
			width = (rc.right > v.width) ? (v.width - x) : rc.width;
			height = (rc.bottom > v.height) ? (v.height - y) : rc.height;
			//	addEventListener(Event.ENTER_FRAME, function (){
			//cellMask.width = cellMask.height = 0;
			//	});
		}
		
		public function show(cell: HostCell): void
		{
			if (visible) return;
			
			switch (cell.type) {
				case HostCell.TYPE_TEXT: setBoundsTxt(cell); break;
				case HostCell.TYPE_PICT: 
				default:                 setBoundsPic(cell);
			}
			visible = true;
			_glow.start(this);
		}
		
		public function hide(): void
		{
			if (visible)
				visible = false;
		}
		
		public function blink(): void
		{
			_glow.blink();
		}
	}
}