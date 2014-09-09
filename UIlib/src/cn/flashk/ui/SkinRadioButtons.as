package cn.flashk.ui
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 双帧单选管理器 
	 * @author flashk
	 * 
	 */
	public class SkinRadioButtons extends EventDispatcher
	{
		/**
		 *  当用户点击（或程序）切换选项卡的时候抛出此事件，然后使用nowIndex获取索引
		 */
		public static const CHANGE:String = "change";
		
		public var outFrame:int = 1;
		public var overFrame:int =1;
		public var downFrame:int =2;
		public var selectFrame:int = 3;
		public var isMouseDown:Boolean = false;
		
		protected var _all:Array;
		protected var _selectIndex:uint;
		protected var _hand:Boolean=false;
		protected var _lastIndex:uint = 0;
		
		public function SkinRadioButtons(showHandCuster:Boolean = false)
		{
			_hand = showHandCuster;
			_all = [];
		}
		
		/**
		 * 获得当前打开选项卡的索引
		 * @return 
		 * 
		 */
		public function get selectIndex():int
		{
			return _selectIndex;
		}
		
		/**
		 * 将选项卡按钮和对应的显示对象加入管理器，当单击 tabButton 时，tabView 将显示
		 * @param tabButton Flash CS 制作的SimpleButton实例
		 * @param tabView
		 * 
		 */
		public function add(tabButton:MovieClip):void
		{
			var btn:MovieClip = tabButton;
			_all.push([tabButton]);
			btn.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			if(isMouseDown == true){
				btn.addEventListener(MouseEvent.MOUSE_DOWN,onSwicthTabClick);
			}else{
				btn.addEventListener(MouseEvent.CLICK,onSwicthTabClick);
			}
			btn.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			btn.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			btn.stop();
			btn.useHandCursor = _hand;
			var len:int = btn.numChildren;
			var txt:TextField;
			for(var i:int=0;i<len;i++){
				txt = btn.getChildAt(i) as TextField;
				if(txt){
					txt.mouseEnabled = false;
					txt.selectable = false;
				}
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if(_all[_selectIndex][0] == event.currentTarget) return;
			var mc:MovieClip = event.currentTarget  as MovieClip;
			mc.gotoAndStop(overFrame);
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			if(_all[_selectIndex][0] == event.currentTarget) return;
			var mc:MovieClip = event.currentTarget  as MovieClip;
			mc.gotoAndStop(outFrame);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(_all[_selectIndex][0] == event.currentTarget) return;
			var mc:MovieClip = event.currentTarget  as MovieClip;
			mc.gotoAndStop(downFrame);
		}
		
		/**
		 * 初始化多个Tab 
		 * @param viewContainer 对应显示的父容器引用
		 * @param tabParentContainer tab的父容器引用
		 * @param max 个数
		 * @param viewName 对应显示的命名前缀，如果此处为空字符串""，则所以显示对象指向同个显示对象targetSameView，并且viewContainer可以为null
		 * @param tabName 对应tab的命名前缀
		 * @param startAt 从哪个个数起始
		 * @param isInitSwitchAtFirst 是否初始化完成后切换至第一个tab显示
		 * 
		 */
		public function initRadios(tabParentContainerOrName:*,max:uint,tabName:String="tab",
								 startAt:uint=1,isInitSwitchAtFirst:Boolean=true):void
		{
			var tabParentContainer:Sprite;
			tabParentContainer = tabParentContainerOrName as Sprite;
			for(var i:int=startAt;i<=max;i++){
					add(tabParentContainer.getChildByName(tabName+i) as MovieClip);
			}
			if(isInitSwitchAtFirst == true){
				switchToRadio(0);
			}
		}
		
		/**
		 * 将某个选项卡按钮和对应的显示对象从管理器移除，并移除事件侦听
		 * @param tabButton
		 * 
		 */
		public function remove(tabButton:SimpleButton):void
		{
			tabButton.removeEventListener(MouseEvent.CLICK,onSwicthTabClick);
			var i:int;
			var len:int = _all.length;
			for(i=0;i<len;i++){
				if(_all[i][0] == tabButton){
					_all.splice(i,1);
					break;
				}
			}
		}
		
		/**
		 * 主动代码切换到某个选项卡,从0开始索引
		 * @param index
		 * 
		 */
		public function switchToRadio(index:uint):void
		{
			if(index <0 || index >= _all.length) return;
			var btn:MovieClip;
			var max:uint = _all.length;
			_selectIndex = index;
			for(var i:int=1;i<=max;i++){
				btn = _all[i-1][0] as MovieClip;
				btn.gotoAndStop(outFrame);
				btn.mouseEnabled = true;
			}
			if(index>=0){
				btn = _all[index][0]  as MovieClip;
				btn.mouseEnabled = false;
				btn.gotoAndStop(selectFrame);
			}
			this.dispatchEvent(new Event(CHANGE));
			_lastIndex = _selectIndex;
		}
		
		public function setRadioSelect(radioIndex:int,select:Boolean):void
		{
			if(select == true){
				switchToRadio(radioIndex);
			}else{
				switchToRadio(0);
			}
		}
		
		public function set selectIndex(value:int):void
		{
			setRadioSelect(value,true);
		}
		
		/**
		 * 当某个选项卡被设定为禁止使用时，可以在 INDEX_CHANGE 事件中调用此方法来禁止切换到目标选项卡
		 * 
		 */
		public function backToLastTab():void
		{
			switchToRadio(_lastIndex);
		}
		
		/**
		 * 清除所有引用的事件侦听，不再启用 
		 * 
		 */
		public function clear():void
		{
			var len:int = _all.length;
			for(var i:int=0;i<len;i++){
				DisplayObject(_all[i][0]).removeEventListener(MouseEvent.CLICK,onSwicthTabClick);
			}
			_all = [];
		}
		
		/**
		 * 获得某个索引的显示对象，索引从0开始 
		 * @param index
		 * @return 
		 * 
		 */
		public function getRadioButtonAt(index:uint):MovieClip
		{
			return _all[index][0] as MovieClip;
		}
		
		/**
		 * 获得某个选项卡按钮的索引， 索引从0开始 
		 * @param btn
		 * @return 
		 * 
		 */
		public function getRadionButtonIndex(btn:MovieClip):uint
		{
			var index:uint =0;
			var len:int = _all.length;
			for(var i:int=0;i<len;i++){
				if(_all[i][0] == btn){
					index = i;
					break;
				}
			}
			return index;
		}
		
		protected function onSwicthTabClick(event:MouseEvent):void
		{
			var btn:MovieClip = event.currentTarget as MovieClip;
			var index:uint = getRadionButtonIndex(btn);
			var isInUnable:Boolean = false;
			switchToRadio(index);
		}
		
		
	}
}

