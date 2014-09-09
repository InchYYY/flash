package cn.flashk.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *  BitmapText 是一个将文本自动转化为Bitmap和BitmapData的显示对象
	 * 
	 * 
	 * @author flashk
	 * 
	 */
	public class BitmapText extends Bitmap
	{
		public static var defaultTextWidth:int = 600;
		
		public var addWidth:int = 4;
		public var addHeight:int = 2;
		
		protected var _txt:TextField;
		protected var _tf:TextFormat;
		protected var _text:String;
		protected var _isUseHTML:Boolean = false;
		protected var _isSmoothing:Boolean = false;
		protected var _isResetTextWidthHeight:Boolean = false;
		protected var _isTarget:Boolean;
		
		public function BitmapText()
		{
			_tf = new TextFormat("_sans");
			_txt = new TextField();
			_txt.width = defaultTextWidth;
			_txt.selectable = false;
			_txt.mouseEnabled = false;
		}
		
		public function target(tf:TextField,isSetXY:Boolean=true):void
		{
			_isTarget = true;
			tf.mouseEnabled = false;
			if(tf.parent){
				tf.parent.removeChild(tf);
			}
			if(isSetXY){
				this.x = int(tf.x);
				this.y = int(tf.y);
			}
			_txt = tf;
		}
		
		public function get isResetTextWidthHeight():Boolean
		{
			return _isResetTextWidthHeight;
		}

		public function set isResetTextWidthHeight(value:Boolean):void
		{
			_isResetTextWidthHeight = value;
		}

		public function get isSmoothing():Boolean
		{
			return _isSmoothing;
		}

		public function set isSmoothing(value:Boolean):void
		{
			_isSmoothing = value;
		}

		public function set textFilter(filters:Array):void
		{
			_txt.filters = filters;
		}
		
		public function get isUseHTML():Boolean
		{
			return _isUseHTML;
		}

		public function set isUseHTML(value:Boolean):void
		{
			_isUseHTML = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function get textFormat():TextFormat
		{
			return _tf;
		}

		public function set textFormat(value:TextFormat):void
		{
			_tf = value;
		}

		public function get textField():TextField
		{
			return _txt;
		}

		public function set textField(value:TextField):void
		{
			_txt = value;
		}

		public function set text(value:String):void
		{
			_text = value;
			if(_isUseHTML == false){
				_txt.text = _text;
			}else{
				_txt.htmlText = _text;
			}
			if(_isTarget == false){
				_txt.setTextFormat(_tf);
			}
			if(bitmapData){
				bitmapData.dispose();
			}
			if(_isResetTextWidthHeight == true){
				_txt.width = _txt.textWidth+addWidth;
				_txt.height = _txt.textHeight+addHeight;
			}
			bitmapData = new BitmapData(_txt.textWidth+addWidth,_txt.textHeight+addHeight,true,0x0);
			bitmapData.draw(_txt);
			smoothing = _isSmoothing;
		}
	}
}