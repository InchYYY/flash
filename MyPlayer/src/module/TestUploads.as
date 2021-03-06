package project.test     
{    
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import cn.flashk.controls.Button;
	import cn.flashk.controls.ProgressBar;
	
	/**   
	 * @link kinglong@Gmail.com   
	 * @author Kinglong   
	 * @playerversion fp10      
	 */    
	[SWF(width="500", height="300", frameRate="24", backgroundColor="#FFFFFF")]   
	public class TestUploads extends Sprite {    
		
		private const DEFAULT_UPLOAD_PAGE:String = "http://test.klstudio.com/upload.asp";          
		private const BOX_WIDTH:uint = 500;    
		private const BOX_HEIGHT:uint = 300;    
		
		private const STATE_CACHE:String = "cache";    
		private const STATE_UPLOAD:String = "upload";    
		
		private var _filters:Array;    
		private var _file:FileReference;    
		private var _loader:Loader;    
		private var _progress:ProgressBar;    
		private var _state:String;    
		private var _buttons:Array;    
		private var _labels:Array;    
		private var _txts:Array;    
		private var _rect:Rectangle;    
		private var _state_txt:TextField;    
		
		public function TestUploads() {    
			Security.allowDomain("*");    
			
			_buttons = [];    
			_txts = [];    
			_labels = ["文件名称:","文件类型:","文件大小:","修改时间:"];    
			
			_rect = new Rectangle(20, 80, 180, 180);    
			_state = STATE_CACHE;    
			
			//背景;    
			this.graphics.beginFill(0x333333);    
			this.graphics.drawRoundRect(0, 0, BOX_WIDTH, BOX_HEIGHT, 10, 10);    
			this.graphics.endFill();    
			this.graphics.beginFill(0xEFEFEF);    
			this.graphics.drawRoundRect(1, 1, BOX_WIDTH - 2, BOX_HEIGHT - 2, 10, 10);   
			this.graphics.endFill();    
			this.graphics.beginFill(0x666666);    
			this.graphics.drawRoundRect(10, 30, BOX_WIDTH - 20, BOX_HEIGHT - 60, 20, 20);              
			this.graphics.endFill();    
			this.graphics.beginFill(0xFEFEFE);    
			this.graphics.drawRoundRect(11, 31, BOX_WIDTH - 22, BOX_HEIGHT - 62, 20, 20);   
			this.graphics.endFill();    
			
			this.graphics.beginFill(0xCCCCCC);    
			this.graphics.drawRect(11, 70, BOX_WIDTH - 22, 1);    
			this.graphics.endFill();    
			
			this.graphics.beginFill(0x000000);    
			this.graphics.drawRect(_rect.x-1, _rect.y-1, _rect.width+2, _rect.height+2);    
			this.graphics.endFill();                
			this.graphics.beginFill(0xEEEEEE);    
			this.graphics.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);    
			this.graphics.endFill();    
			
			
			//标题;    
			var label:TextField;                
			label = getLabel("图片上传（预览图片版） by Kinglong", getTextFormat(0xFFFFFF, 14, true));    
			label.x = 10;    
			label.y = 5;    
			label.filters = [getLabelFilter(0x000000)];    
			this.addChild(label);    
			
			for (var i:uint = 0; i < _labels.length; i++ ) {             
				label = getLabel(_labels[i], getTextFormat(0x333333, 12), false, false);                   
				label.x = _rect.right+5;    
				label.y = _rect.y + 25 * i;    
				label.width = 280;    
				label.height = 20;    
				_txts.push(label);    
				this.addChild(label);    
			}               
			
			_state_txt = getLabel("状态:", getTextFormat(0x333333, 12));    
			_state_txt.x = 10;    
			_state_txt.y = BOX_HEIGHT - _state_txt.height - 5;    
			this.addChild(_state_txt);    
			
			//按钮;    
			var button:Button;    
			button = getButton("选择文件", 80);              
			button = getButton("上传文件", 80);             
			button.setSize(190,40);
			button.enabled = false;    
			
			//进度条;    
			_progress = new ProgressBar();     
			_progress.setSize(290,22);    
		            
			this.addChild(_progress);    
			
			//文件类型;    
			_filters = [];    
			var filter:FileFilter;              
			filter = new FileFilter("所有支持图片文件(*.jpg,*.jpeg,*.gif,*.png)", "*.jpg;*.jpeg;*.gif;*.png");    
			_filters[_filters.length] = filter;    
			filter = new FileFilter("JPEG files(*.jpg,*.jpeg)","*.jpg;*.jpeg");    
			_filters[_filters.length] = filter;    
			filter = new FileFilter("GIF files (*.gif)","*.gif");    
			_filters[_filters.length] = filter;    
			filter = new FileFilter("PNG files(*.png)","*.png");    
			_filters[_filters.length] = filter;     
			
			_file = new FileReference();     
			_file.addEventListener(Event.COMPLETE, fileHandler);    
			_file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, fileHandler);   
			_file.addEventListener(Event.SELECT, fileHandler);    
			_file.addEventListener(Event.OPEN, fileHandler);                
			_file.addEventListener(ProgressEvent.PROGRESS, fileHandler);    
			_file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileHandler);   
			_file.addEventListener(IOErrorEvent.IO_ERROR, fileHandler);    
			_file.addEventListener(HTTPStatusEvent.HTTP_STATUS, fileHandler);    
			
			_loader = new Loader();    
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadHandler);   
			this.addChild(_loader);    
		}    
		
		public function get state():String {    
			return _state;    
		}    
		
		private function clickHandler(event:MouseEvent):void {    
			switch(event.target) {    
				case _buttons[0]:    
					_file.browse(_filters);    
					break;    
				case _buttons[1]:    
					_file.upload(new URLRequest(DEFAULT_UPLOAD_PAGE));    
					_state = STATE_UPLOAD;                      
					_buttons[0].enabled = false;    
					_buttons[1].enabled = false;    
					break;    
			}    
		}    
		
		private function loadHandler(event:Event):void {    
			_loader.scaleX = _loader.scaleY = 1;    
			var w:uint = _loader.width;    
			var h:uint = _loader.height;    
			if (w > _rect.width || h > _rect.height) {                    
				var ip:Number = w / h;    
				var lp:Number = _rect.width / _rect.height;             
				_loader.width = (ip > lp)?_rect.width:_rect.height*ip;    
				_loader.height = (ip > lp)?_rect.width / ip:_rect.height;    
			}    
			_loader.x = _rect.x + (_rect.width - _loader.width) / 2;    
			_loader.y = _rect.y + (_rect.height - _loader.height) / 2;              
			_loader.visible = true;    
		}    
		
		private function fileHandler(event:Event):void {    
			switch(event.type) {    
				case Event.COMPLETE:    
					if(state == STATE_CACHE){    
						_loader.loadBytes(_file.data);    
					}    
					break;    
				case DataEvent.UPLOAD_COMPLETE_DATA:    
					debug("图片上传完成!");    
					_buttons[0].enabled = true;    
					_buttons[1].enabled = false;     
					break;    
				case Event.SELECT:    
					_txts[0].text = _labels[0] + _file.name;    
					_txts[1].text = _labels[1] + _file.type;    
					_txts[2].text = _labels[2] + ((_file.size > 1024 * 1024)?Math.round(_file.size * 10 / (1024*1024))/10  
						+ "MB":Math.round(_file.size * 10 / 1024)/10 + "KB");                      
					_txts[3].text = _labels[3] + date2str(_file.modificationDate);    
					_buttons[0].enabled = true;    
					_buttons[1].enabled = true;    
					_file.load();    
					_state = STATE_CACHE;    
					_loader.visible = false;    
					debug("图片已经准备!");    
					break;    
				case Event.OPEN:    
					if(state == STATE_UPLOAD){    
						debug("正在上传图片...");    
					}    
					break;    
				case ProgressEvent.PROGRESS:    
					if (state == STATE_UPLOAD) {    
						var pEvent:ProgressEvent = event as ProgressEvent;    
						_progress.setProgress(pEvent.bytesLoaded, pEvent.bytesTotal);   
					}    
					break;    
				case SecurityErrorEvent.SECURITY_ERROR:    
				case IOErrorEvent.IO_ERROR:    
				case HTTPStatusEvent.HTTP_STATUS:                       
					if (state == STATE_UPLOAD) {    
						debug("图片上传失败!");    
						_buttons[0].enabled = true;    
						_buttons[1].enabled = true;    
					}else {    
						debug("图片缓冲失败!");    
					}    
					_progress.setXY(0, 1);    
					break;    
				
			}    
		}    
		
		private function getButton(lbl:String,width:uint=120):Button {    
			var button:Button = new Button();    
			button.label = lbl;    
			button.setSize(width, 22);      
			button.setStyle("textFormat", getTextFormat());    
			button.setStyle("disabledTextFormat", getTextFormat(0x999999));    
			button.setStyle("textPadding",4);    
			button.addEventListener(MouseEvent.CLICK, clickHandler);                
			this.addChild(button);    
			_buttons.push(button);    
			return button;    
		}    
		
		private function getLabel(label:String, format:TextFormat, selectable:  
								  Boolean = false, autoSize:Boolean = true):TextField {             
			var lbl:TextField = new TextField();    
			lbl.selectable = selectable;    
			lbl.defaultTextFormat = format;    
			if(autoSize){    
				lbl.autoSize = TextFieldAutoSize.LEFT;    
			}    
			lbl.text = label;    
			return lbl;    
		}    
		
		private function getTextFormat(color:uint=0x000000,size:uint = 12,bold:Boolean=false): 
			TextFormat {    
			var format:TextFormat = new TextFormat();    
			format.font = "宋体";    
			format.color = color;    
			format.size = size;    
			format.bold = bold;    
			return format;    
		}    
		
		private function getLabelFilter(color:uint=0xFFFFFF):BitmapFilter {    
			var alpha:Number = 0.8;    
			var blurX:Number = 2;    
			var blurY:Number = 2;    
			var strength:Number = 3;    
			var inner:Boolean = false;    
			var knockout:Boolean = false;    
			var quality:Number = BitmapFilterQuality.HIGH;    
			
			return new GlowFilter(color,    
				alpha,    
				blurX,    
				blurY,    
				strength,    
				quality,    
				inner,    
				knockout);    
		}    
		
		private function date2str(day:Date):String {    
			var str:String = day.getFullYear() + "-";    
			str += num2str(day.getMonth() + 1) + "-";    
			str += num2str(day.getDate()) + " ";    
			str += num2str(day.getHours()) + ":";    
			str += num2str(day.getMinutes()) + ":";    
			str += num2str(day.getSeconds());    
			return str;    
		}    
		
		private function num2str(val:Number):String {    
			var str:String = "00" + val;    
			return str.substr(str.length - 2, 2);               
		}    
		
		private function debug(message:String):void {    
			_state_txt.text = message;    
		}    
		
	}    
	
}