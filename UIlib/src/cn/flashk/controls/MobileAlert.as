package cn.flashk.controls
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import cn.flashk.controls.events.AlertCloseEvent;
	import cn.flashk.controls.managers.DefaultStyle;
	import cn.flashk.controls.managers.SkinLoader;
	import cn.flashk.controls.managers.SourceSkinLinkDefine;
	import cn.flashk.controls.managers.StyleManager;
	import cn.flashk.controls.managers.UISet;
	import cn.flashk.controls.modeStyles.ButtonMode;
	import cn.flashk.controls.modeStyles.ButtonStyle;
	import cn.flashk.controls.support.ColorConversion;
	import cn.flashk.controls.support.Scale9GridBitmap;
	import cn.flashk.controls.support.UIComponent;

	public class MobileAlert extends Sprite
	{
		
		public static var useMobileAlert:Boolean = false;
		/**
		 * 如果对Alert.show默认不传递父级显示对象，使用此值 
		 */
		public static var defaultAlertParent:DisplayObjectContainer;
		/**
		 * 需要模糊化的显示对象，默认为文档类的实例
		 */
		public static var blurDisplayObject:DisplayObject;
		/**
		 * 文本文字的显示滤镜 
		 */
		public static var textFilter:Array = null;
		/**
		 * 模糊的滤镜数组
		 */
		public static var blurFilters:Array = null;
		/**
		 * 当不允许其他操作时遮盖的颜色
		 */
		public static var maskColor:uint = 0x0;
		/**
		 * 当不允许其他操作时遮盖颜色的透明度
		 */
		public static var maskAlpha:Number = 0.5;
		/**
		 * Alert的最大宽度，请注意此属性和Window实例属性的区别
		 */
		public static var maxWidth:Number = 800;
		/**
		 * Alert的最小宽度，请注意此属性和Window实例属性的区别
		 */
		public static var minWidth:Number = 210;
		public static var maxHeight:Number = 960;
		public static var paddingBottom:Number = 40;
		public static var sureLabels:Array = ["确定"];
		public static var customLabels2:Array = ["确定" , "取消"];
		public static var customLabelsModify:Array = ["修改" , "取消"];
		public static var customLabelsDel:Array = ["删除" , "取消"];
		public static var customLabelsYesNo:Array = ["是" , "否"];
		public static var mark:Sprite;
		
		
		public var titleBold:Boolean = true;
		protected var txt:TextField;
		private static var skin:DisplayObject;
		protected var bp:Scale9GridBitmap;
		private static var bd:BitmapData;
		protected var sx:Number;
		protected var sy:Number;
		protected var _callBackFun:Function;
		protected var _textStr:String;
		protected var _paddingLeft:Number = 0;
		protected var _paddingBottom:Number = 0;
		protected var tiHeight:Number;
		
		
		protected var _compoWidth:Number = 10;
		protected var _compoHeight:Number = 10;
		protected var closeBtn:Button;
		protected var tf:TextFormat;
		public static var titleTextAlign:String = "center";
		
		private static var _blurArray:Array = [];
		
		
		protected var _info:TextField;
		protected var _tf2:TextFormat;
		protected var _btns:Array;

		public function get compoHeight():Number
		{
			return _compoHeight;
		}

		public function get compoWidth():Number
		{
			return _compoWidth;
		}
		
		public function MobileAlert(text:String , title:String , icon:Object , buttonLabels:Array , closeFunction:Function , alertWidth:Number = 0)
		{
			
			closeBtn = new Button();
			
			closeBtn.useSkinSize = true;
			closeBtn.setSkin(SkinLoader.getClassFromSkinFile(SourceSkinLinkDefine.WINDOW_CLOSE_BUTTON));
			closeBtn.setSize(34,16);
			closeBtn.y = -12;
			closeBtn.mode = ButtonMode.JUST_ICON;
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			this.addChild(closeBtn);
			
			txt = new TextField();
			txt.x =0 ;
			txt.height = tiHeight;
			txt.textColor = 0xFFFFFF;
			txt.y = 5;
			txt.mouseEnabled = false;
			txt.embedFonts = StyleManager.embedFonts;
			this.addChild(txt);
			tf = new TextFormat();
			tf.font = DefaultStyle.font;
			tf.size = DefaultStyle.titleFontSize;
			tf.align = titleTextAlign;
			tf.color = ColorConversion.transformWebColor(DefaultStyle.panelTitleColor);
			
			_callBackFun = closeFunction;
			_tf2 = new TextFormat ();
			_tf2.font = DefaultStyle.font;
			_tf2.size = DefaultStyle.fontSize;
			_tf2.color = ColorConversion.transformWebColor( DefaultStyle.textColor );
			_tf2.leading = 7;
			tiHeight = DefaultStyle.windowTitleHeight;
			_info = new TextField ();
			_info.multiline = true;
			_info.wordWrap = true;
			_info.y = tiHeight + 25;
			_info.x = _paddingLeft + 10;
			_info.embedFonts = StyleManager.embedFonts;
			if (alertWidth > 0)
			{
				_info.width = alertWidth - _info.x * 2;
			}
			else
			{
				_info.width = maxWidth - 50;
			}
			_info.selectable = false;
			_info.htmlText = text;
			_info.setTextFormat( _tf2 );
			_info.width = _info.textWidth + 15;
			_info.height = 600;
			_info.height = _info.textHeight + 20;
			if(_info.height > maxHeight - 138){
				_info.height = maxHeight - 138;
			}
			_info.blendMode = BlendMode.LAYER;
			_info.filters = textFilter;
			this.title = title;
			this.addChild ( _info );
			if ( icon != null )
			{
				this.icon = icon;
			}
			var wi:Number = _info.width + _info.x * 2;
			if ( wi < Alert.minWidth ) wi = Alert.minWidth;
			if ( wi > Alert.maxWidth ) wi = Alert.maxWidth;
			setSize( wi, _info.height + tiHeight + 51 + Button.defaultHeihgt );
			_btns = new Array ();
			var btn:Button;
			for ( var i:int = 0 ; i < buttonLabels.length ; i++ )
			{
				btn = new Button ();
				btn.label = String ( buttonLabels[ i ] );
				_btns.push ( btn );
				this.addChild ( btn );
				btn.y = _compoHeight - Alert.paddingBottom - btn.height + 19;
				btn.addEventListener ( MouseEvent.CLICK , close );
			}
			var space:Number = 10;
			if ( _btns.length == 2 )
				space = 20;
			if ( _btns.length == 3 )
				space = 15;
			if ( _btns.length == 4 )
				space = 10;
			if ( _btns.length > 4 )
				space = 5;
			var allw:Number = 0;
			for ( i = 0 ; i < _btns.length ; i++ )
			{
				allw += Button ( _btns[ i ] ).compoWidth + space;
			}
			allw -= space;
			var stx:Number = int ( ( _compoWidth - allw ) / 2 );
			if (stx < 20)
				stx = 20;
			Button ( _btns[ 0 ] ).x = stx;
			var btnWidth:Number = 0;
			if ( _btns.length > 1 )
			{
				for ( i = 1 ; i < _btns.length ; i++ )
				{
					Button ( _btns[ i ]).x = Button ( _btns[ i - 1 ]).x + Button ( _btns[ i - 1 ]).compoWidth + space;
				}
			}
			
			
			
			btnWidth = Button ( _btns[ _btns.length - 1 ]).x + Button ( _btns[ _btns.length - 1 ]).width + stx;
			if ( btnWidth > wi )
			{
				wi = btnWidth;
				setSize ( wi , _info.height + tiHeight + 51 + Button.defaultHeihgt );
			}
		}
		
		/**
		 * 以编程方式关闭此消息弹出窗口
		 */
		 public function close(event:Event = null):void
		{
			var index:uint;
			var lab:String;
			
			if (event != null)
			{
				if (event is AlertCloseEvent)
				{
					index = AlertCloseEvent (event).clickButtonIndex;
					if (index == 0)
					{
						lab = "alertClose";
					}
					else
					{
						lab = Button (_btns[index - 1]).label;
					}
				}
				else
				{
					if (event.currentTarget == closeBtn)
					{
						index = 0;
						lab = "alertClose";
					}
					else
					{
						for (var i:int = 0 ; i < _btns.length ; i++)
						{
							if (_btns[i] == event.currentTarget)
							{
								index = i + 1;
								lab = Button (_btns[i]).label;
							}
						}
					}
				}
				if (_callBackFun != null)
				{
					_callBackFun (new AlertCloseEvent ("close" , index , lab));
				}
			}
			if(this.parent){
				this.parent.removeChild(this);
			}
			this.dispatchEvent(new Event("close"));
		}
		public function set icon(value:Object):void{
			
		}
		
		public function set title(value:String):void{
			if(titleBold == true){
				txt.htmlText= "<b>"+value+"</b>";
			}else{
				txt.htmlText= value;
			}
			txt.setTextFormat(tf);
		}
		
		public function reDraw(event:Event=null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE,reDraw);
			var Skin:Class= SkinLoader.getClassFromSkinFile(SourceSkinLinkDefine.PANEL)
			if(skin == null){
				skin = new Skin() as DisplayObject;
			}
			if(bp == null){
				bp = new Scale9GridBitmap();
				bp.smoothing = UISet.sourceSkinBitmapSmoothing;
				var rect:Rectangle = skin.getRect(skin);
				sx = -rect.x;
				sy = -rect.y;
				bp.leftLineSpace = skin.scale9Grid.x+sx;
				bp.topLineSpace = skin.scale9Grid.y +sy;
				bp.rightLineSpace = skin.width-skin.scale9Grid.x-skin.scale9Grid.width-sx;
				bp.bottomLineSpace = skin.height-skin.scale9Grid.y-skin.scale9Grid.height-sy;
				bp.x = -sx;
				bp.y = -sy;
			}
			if(bd == null){
				bd=new BitmapData(skin.width,skin.height,true,0);
				bd.draw(skin,new Matrix(1,0,0,1,sx,sy));
			}
			bp.sourceBitmapData = bd;
			this.addChildAt(bp,0);
			//			bp.width = tar.compoWidth+sx*2;
			//			bp.height = tar.compoHeight+sy*2;
			bp.setSize(compoWidth+sx*2,compoHeight+sy*2);
		}
		
		
		/**
		 * 弹出一个提示框，以通知用户或者让用户处理完此消息前不得进行其他操作，如果不希望显示关闭按钮，可以对返回的Alert实例设置showCloseButton属性
		 *
		 * @param text 要显示的消息，可以使用flash支持的HTML文本。
		 * @param parentContainer 弹出消息要添加进的父容器，大部分情况下应该是Stage
		 * @param closeFunction 监听此窗口关闭的函数，函数应该只有一个参数，类型为AlertCloseEvent，如果不提供此函数，同样可以监听close事件，但close事件没有任何反应用户操作哪个按钮的属性
		 * @param title 消息窗口的标题
		 * @param icon 消息窗口的小图标
		 * @param buttonLabels 消息窗口要显示按钮的标签，不限个数，之后你可以通过Alert实例的buttons属性来访问这些按钮，比如添加图标和重新排列等等，如["删除","放弃","重新来过"]
		 * @param isUnableMouse 弹出消息后是否允许用户操作下面的界面。如果为true，可以设置Alert.maskColor和Alert.maskAlpha来更改颜色和透明度
		 *
		 * @see cn.flashk.controls.events.AlertCloseEvent
		 */
		public static function show(text:String , parentContainer:DisplayObjectContainer =null, closeFunction:Function = null , title:String = "消息" , icon:Object = null , buttonLabels:Array = null , isUnableMouse:Boolean = true , alertWidth:Number = 0):MobileAlert
		{
			if (buttonLabels == null)
				buttonLabels = sureLabels;
			if(parentContainer==null) parentContainer = Alert.defaultAlertParent;
			if(parentContainer==null) parentContainer = UIComponent.stage;
			var alert:MobileAlert = new MobileAlert (text , title , icon , buttonLabels , closeFunction , alertWidth);
			alert.x = int ((parentContainer.stage.stageWidth*UISet.stageScale - alert.compoWidth) / 2);
			alert.y = int ((parentContainer.stage.stageHeight*UISet.stageScale - alert.compoHeight) / 2);
			if (alert.x < 0)
				alert.x = 0;
			if (alert.y < 0)
				alert.y = 0;
			if (isUnableMouse == true)
			{
				markCount++;
				if(mark==null){
					mark = new Sprite ();
					mark.graphics.clear ();
					mark.graphics.beginFill (maskColor , maskAlpha);
					mark.graphics.drawRect (-100 , -100 , 840 , 1160);
					mark.addEventListener(MouseEvent.CLICK,onMarkClick);
				}
				if(mark.parent == null){
					parentContainer.addChild (mark);
				}
			}
			parentContainer.addChild (alert);
			alert.addEventListener ("close" , checkRemoveMark);
			return alert;
		}
		public static var markCount:int =0 ;
		
		protected static function onMarkClick(event:MouseEvent):void
		{
			nowAlert = mark.parent.getChildAt(mark.parent.numChildren-1) as MobileAlert;
			if(nowAlert){
				index = -1;
				nowAlert.addEventListener(Event.ENTER_FRAME,showFocus);
			}
			
		}
		
		protected static function showFocus(event:Event):void
		{
			index++;
			if(index < maskClickAlphas.length){
				nowAlert.alpha = maskClickAlphas[index];
			}else{
				nowAlert.removeEventListener(Event.ENTER_FRAME,showFocus);
			}
		}
		
		private static var nowAlert:MobileAlert;
		private static var index:int=0;
		
		public static var maskClickAlphas:Array = [0.8,1,0.8,1,0.8,1,0.8,1];
		
		public function setSize(newWidth:Number , newHeight:Number):void
		{
			_compoWidth = newWidth;
			_compoHeight = newHeight;
			txt.width = _compoWidth-25;
			if (_info)
			{
				_info.width = newWidth - _info.x * 2;
			}
			if(closeBtn){
				closeBtn.x = _compoWidth-closeBtn.compoWidth-StyleManager.globalWindowButtonsXLess+3;
			}
			if(this.stage){
				reDraw();
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE,reDraw);
			}
		}
		
		private static function checkRemoveMark(event:Event):void
		{
			DisplayObject (event.currentTarget).removeEventListener ("close" , checkRemoveMark);
			markCount--;
			if (mark.parent != null && markCount<=0)
			{
				mark.parent.removeChild (mark);
			}
		}
		
	}
}