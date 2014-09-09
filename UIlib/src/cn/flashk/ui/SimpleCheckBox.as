package cn.flashk.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	/**
	 * 简单自定义复选框 
	 * 
	 * 事件：Event.CHANGE 用户/切换时触发
	 * @author flashk
	 * 
	 */
	public class SimpleCheckBox extends EventDispatcher
	{
		private var _mc:MovieClip;
		private var _selected:Boolean;
		
		public function SimpleCheckBox(target:MovieClip)
		{
			_mc = target;
			_selected = false;
			_mc.stop();
			_mc.addEventListener(MouseEvent.CLICK,switchSelect);
			_mc.mouseChildren = false;
		}
		
		/**
		 * 切换 
		 * @param event
		 * 
		 */
		public function switchSelect(event:MouseEvent=null):void
		{
			selected = !selected;
		}
		
		/**
		 * 复选框是否已经选择 
		 * @return 
		 * 
		 */
		public function get selected ():Boolean
		{
			return _selected;
		}

		/**
		 * 复选框是否已经选择
		 * @param value
		 * 
		 */
		public function set selected (value:Boolean):void
		{
			_selected = value;
			if(_selected == true)
			{
				_mc.gotoAndStop(2);
			}else
			{
				_mc.gotoAndStop(1);
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}

	}
}