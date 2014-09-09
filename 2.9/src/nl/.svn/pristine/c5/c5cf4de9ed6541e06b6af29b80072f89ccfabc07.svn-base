package nl.bron
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	import nl.util.Str;
	import nl.service.WebServer;
	import nl.util.Net;
	
	public class brCell extends Sprite
	{
		protected var _hostCell: HostCell;		// 宿主对象
		protected var _container: brContainer;

		public function get hostCell(): HostCell { return _hostCell; }
		public function get actor(): DisplayObject { return _hostCell.actor; }
		public function get param(): Object { return _hostCell.param; }
		public function get ID(): int { return _hostCell.ID; }
		
		public function brCell()
		{
			super();
			_container = findParentContainer();
			if (_container) {
				var id: int = (this.name.indexOf('cell_') != 0) ? -1 : Str.toInt(this.name.substr(5));
				_hostCell = _container.regCell(id, this);	// 注册到宿主对象
			}
		}
		
		private function findParentContainer(): brContainer
		{
			var p: Object = this.parent;
			var result: brContainer;
			while (p && typeof(p) == "object") {
				result = p as brContainer;
				if (result)
					return result;
				p = p["parent"];	// get the parent's parent
			}
			return null;
		}
		
		public static function loadImgResource(res: Resource): void
		{
			if (!res.param) {
				throw new Error("hostCell.param is null");
			}
			
			var url: String = res.param.url;
			if (!url) {
				res.drawDefaultImage();
				return;
			}
			
			url = WebServer.picServiceUrl + url;
			Net.getImage(url, function (b: Bitmap): void {
				res.drawBitmap(b);
			});
		}

		public function setState(): void {}
		public function updateParameter(p: Object): void {}
		public function copyEditParam(dest: Object, src: Object): void {}
		public function draw(container: brContainer = null) : void {}
	}
}
