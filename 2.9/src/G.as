package 
{
	import mx.controls.Alert;
	import mx.events.DragEvent;
	import nl.bron.HostVideo;
	import nl.bron.brContainer;
	import nl.util.Net;

	public class G
	{
		public static var mov_W: int = 640;
		public static var mov_H: int = 360;
		public static var btm_W: int = 0;
		public static var btm_H: int = 160;
		public static var sideW: int = 385;
		public static var pad_X: int = 6;
		public static var gap_Y: int = 6;

		public static var err: Boolean = false;
		public static var app: FxPlayer;
		public static var mv: brContainer = null;
		public static var cfg: HostVideo;
		
		public static var debug:Boolean = true;

		
		public static function popMsg(text: String, title: String = "信息"): void { 	Alert.show(text, title); }
		public static function popErr(text: String): void { Alert.show(text, "错误"); }
		
		public static function dbgDragEvent(e: DragEvent, title: String): void
		{
			var s: String = "【" + title + "】local: (" + e.localX.toString() + ", " + e.localY.toString() +
				")　　stage: (" + e.stageX.toString() + ", " + e.stageY.toString() + ")";
		}
		
		public static function deBug(data:* = null, str:String = null): void {
			if(!debug)return;
			var tt:String = new Date().time.toString();
			var url:String = "deBug..." + (str?str:tt);
			Net.postData(
				url,
				data,
				function (data: *):void {},
				function (e: *):void {}
			);
		}
	}
}
