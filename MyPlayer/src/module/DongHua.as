package module
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import inch.BoFangT;

	/**
	 * 
	 * @author yuanyang
	 */
	public class DongHua extends Sprite
	{
		private var _ui:BoFangT;

		private static var _ins:DongHua;

		/**
		 * 
		 */
		public function DongHua()
		{
			super();
			_ui=new BoFangT();
			this.addChild(_ui);
			
			
			init();
		}

		/**
		 * 
		 * @return 
		 */
		public static function get instance():DongHua
		{
			if (_ins == null)
			{
				_ins=new DongHua();
			}
			return _ins as DongHua;
		}
		
		private function init():void{
			_ui.btn_1.addEventListener(MouseEvent.CLICK,onClock1);
		}
		
		protected function onClock1(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
	}
}
