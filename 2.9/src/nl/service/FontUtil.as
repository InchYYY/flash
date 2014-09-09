package nl.service
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class FontUtil
	{
		//public static var fontURL : String = "http://font.yxp.126.net/fontservlet";

		public function FontUtil()
		{
			throw new Error("FontService is final class");
		}

		public static function getColorInt(color: String) : uint
		{
			color = color.replace("#", "");
			color = "0x" + color;
			return uint(color);
		}
		
		public static function getColorHex(color: String): String
		{
			return color.replace("#", "0x");
		}
		
		/**
		 http://fonts.fans-me.com/ftsvr/?text=&color=16763904&fontfamily=jdzyt&fontsize=68&bold=0&italic=0&align=0&width=200&height=100&layout=0
		 */
		public static function encodeFontURI(param: Object): String
		{
			return "/?text="		+ encodeURIComponent(param.text) +
				"&color="		+ getColorInt(param.color) +
				"&fontfamily="+ encodeURIComponent(param.font) +
				"&fontsize="	+ (param.size ? param.size.toString() : "10") +
				"&bold="		+ (param.bold ? "1" : "0") +
				"&italic=0"	+
				"&align=0"		+
				"&width=200"	+
				"&height=100"	+
				"&layout=0"; 
		}

		public static function getFont(param : Object) : URLVariables
		{
			var vars : URLVariables = new URLVariables();
			vars.layout = 0;
			vars.fontfamily = param.font;
			vars.fontsize = param.size;
			vars.color = getColorInt(param.color);
			vars.bold = param.bold;
			vars.align = 0;
			vars.width = 200;
			vars.height = 100;
			vars.text = param.text;
			vars.italic = 0;
			return vars;
		}

		public static function getImage(param: Object, callback: Function) : void
		{
			var fontLoader : URLLoader = new URLLoader();
			fontLoader.dataFormat = URLLoaderDataFormat.BINARY;

			var url: String = param.editing ? WebServer.fontServiceUrlPlus : WebServer.fontServiceUrl;
			param.editing = undefined;

			url = url + encodeFontURI(param);
			var request : URLRequest = new URLRequest(url);
		//	request.data = getFont(param);
			request.method = URLRequestMethod.GET;

			fontLoader.load(request);
			fontLoader.addEventListener(Event.COMPLETE, function (e: Event) : void {
				var l : Loader = new Loader();
				l.loadBytes(e.currentTarget.data);
				l.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e : Event) : void {
					callback(e.target.content as Bitmap);
				});
			});
		}
	}
}
