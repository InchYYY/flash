package nl.bron
{
	import nl.service.FontUtil;
	import nl.service.WebServer;

	public class brTxtCell extends brCell
	{
		private var self : brTxtCell;

		public function brTxtCell()
		{
			super();
			self = this;
			if(_hostCell.filtersName) _hostCell.filtersName = _hostCell.filtersName;
		}
		
		public static function loadResource(res: Resource): void
		{
			if (!res) throw new Error("hostCell is null");
			if (!res.param) throw new Error("hostCell.param is null");

			WebServer.run(function (): void {
				FontUtil.getImage(res.param, res.drawBitmap);
			});
		}
		
		public static function updateState(hc: HostCell): void
		{
			if (!hc.actor) {
				throw new Error("actor is null");
			}
			
			hc.actor.x = hc.param.x;
			hc.actor.y = hc.param.y;
		}

	/*	public function movePoint(pnt: Point) : void
		{
			if (! parent) { return; }
			var p : Point = parent.globalToLocal(pnt);
			param.x = p.x;
			param.y = p.y;
			setState();
		} */

		override public function copyEditParam(dest : Object, src : Object): void
		{
			dest.hidden = src.hidden;
			dest.text  = src.text;
			dest.font  = src.font;
			dest.size  = src.size;
			dest.color = src.color;
			dest.bold  = src.bold;
			dest.x = src.x;
			dest.y = src.y;
		//	dest.italic = src.italic;
		//	dest.underline = src.underline;
			dest.editing = src.editing;
		}
	}
}
