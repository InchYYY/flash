package cn.flashk.ui
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 简易可定制界面滚动条
	 * @author: flashk
	 * @version: 1.0
	 */ 

	public class SimpleScrollBar
	{
		public var miniSize:uint = 15;
		
		private var _ui:Sprite;
		private var _view:DisplayObject;
		private var _bg:InteractiveObject;
		private var _bar:Sprite;
		private var _viewHeight:Number;
		private var _moveSpeed:Number = 2.2;
		private var _to:int;
		private var _viewWidth:Number;
		
		public function SimpleScrollBar()
		{
		}
		/**
		 * 
		 * @param uiSprite 包含滚动槽和滚动条的Sprite，滚动槽被命名为background,滚动条被命名为bar
		 * @param viewport 要滚动的显示对象
		 * @param width 显示大小的宽度
		 * 
		 */
		public function init(uiSprite:Sprite,viewport:DisplayObject,width:Number=0):void{
			_ui = uiSprite;
			_view = viewport;
			_viewWidth = width;
			_bg = _ui.getChildByName("background") as InteractiveObject;
			_bar = _ui.getChildByName("bar") as Sprite;
			_bar.addEventListener(MouseEvent.MOUSE_DOWN,startDragBar);
			_bg.addEventListener(MouseEvent.CLICK,scrollToClick);
			update();
		}
		public function update():void{
			_view.scrollRect = null;
			_viewHeight = _view.height;
			_bar.height = _bg.height/_view.height*_bg.height;
			if(_bar.height<miniSize) _bar.height = miniSize;
			if(_view.height <= _bg.height){
				_bar.visible = false;
				_ui.mouseEnabled = false;
				_ui.mouseChildren = false;
			}else{
				_bar.visible = true;
				_ui.mouseEnabled = true;
				_ui.mouseChildren = true;
			}
			var w:Number = _viewWidth;
			if(w == 0) w = _view.width;
			_view.scrollRect = new Rectangle(0,0,w,_bg.height);
		}
		private function startDragBar(event:MouseEvent):void{
			_bar.startDrag(false,new Rectangle(0,0,0,_bg.height-_bar.height));
			_bar.stage.addEventListener(MouseEvent.MOUSE_UP,stopDragBar);
			_bar.stage.addEventListener(MouseEvent.MOUSE_MOVE,updateViewPos);
			_ui.removeEventListener(Event.ENTER_FRAME,moveToFrame);
		}
		private function stopDragBar(event:MouseEvent):void{
			_bar.stopDrag();
			_bar.stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragBar);
			_bar.stage.removeEventListener(MouseEvent.MOUSE_MOVE,updateViewPos);
		}
		private function updateViewPos(event:Event=null):void{
			var percent:Number = _bar.y/(_bg.height-_bar.height);
			var w:Number = _viewWidth;
			if(w == 0) w = _view.width;
			_view.scrollRect = new Rectangle(0,int(percent*(_viewHeight-_bg.height)),w,_bg.height);
		}
		private function scrollToClick(event:MouseEvent):void{
			_to = int(_ui.mouseY - _bar.height/2);
			if(_to < 0) _to = 0;
			if(_to > _bg.height-_bar.height) _to = _bg.height-_bar.height;
			_ui.addEventListener(Event.ENTER_FRAME,moveToFrame);
		}
		private function moveToFrame(event:Event):void{
			_bar.y += (_to-_bar.y)/_moveSpeed;
			if(Math.abs(_to-_bar.y) <1 ){
				_ui.removeEventListener(Event.ENTER_FRAME,moveToFrame);
				_bar.y = _to;
			}
			updateViewPos();
		}
	}
}