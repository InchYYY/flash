package nl.effects.tween
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class GlowTween
	{
		private static const _repeatMax: int = 2;
		private static const _items: Array = [		// alpha: 透明度（0=全透明, 1=不透明），blur: 模糊度（0~255）
			{ alpha: 0.0, blur: 0 },
			{ alpha: 0.1, blur: 2 },
			{ alpha: 0.2, blur: 4 },
			{ alpha: 0.3, blur: 6 },
			{ alpha: 0.4, blur: 8 },
		//	{ alpha: 0.5, blur: 10 },
			{ alpha: 0.5, blur: 12 },
		//	{ alpha: 0.5, blur: 14 },
			{ alpha: 0.6, blur: 16 },
		//	{ alpha: 0.6, blur: 18 },
			{ alpha: 0.7, blur: 20 },
		//	{ alpha: 0.6, blur: 22 },
			{ alpha: 0.8, blur: 24 },
		//	{ alpha: 0.8, blur: 26 },
			{ alpha: 0.9, blur: 28 },
		//	{ alpha: 0.9, blur: 30 },
			{ alpha: 1.0, blur: 32 }
		];

		private var _target: InteractiveObject;
		private var _color: uint;
		private var _itemIndex: int;
		private var _repeat: int;
		private var _reverse: Boolean = false;
		private var _glowing: Boolean = false;

		private var _onGlowFinished: Function = null;		// 闪动次数完毕后执行的函数
		private var _glowCount: int = 0;					// 闪动次数（半程为1次）
		private var _glowIndex: int;
		
		public function get glowing(): Boolean { return _glowing; }
		public function set glowCount(count: int): void { _glowCount = count; }
		public function set onGlowFinished(exec: Function): void { _onGlowFinished = exec; }
		
		public function GlowTween(color: uint = 0xff0000)
		{
			_color = color;
		}
		
	/*	public function startMouseEvent(): void
		{
			_target.addEventListener(MouseEvent.ROLL_OVER, startGlow);
			_target.addEventListener(MouseEvent.ROLL_OUT, stopGlow);
		}
		
		public function stopMouseEvent(): void
		{
			_target.removeEventListener(MouseEvent.ROLL_OVER, startGlow);
			_target.removeEventListener(MouseEvent.ROLL_OUT, stopGlow);
			stopGlow();
		} */
		
		public function start(target: InteractiveObject): void
		{
			if (_glowing) return;

			_glowing = true;
			_target = target;
			init();
		//	_target.addEventListener(Event.ENTER_FRAME, blinkHandler, false, 0, true);
		}
		
		public function stop(): void
		{
			if (!_glowing) return;
			
		//	_target.removeEventListener(Event.ENTER_FRAME, blinkHandler);
			_target.filters = null;
			_glowing = false;
		}
		
		private function init(): void
		{
			_itemIndex = 0;
			_reverse = false;
			_repeat = _repeatMax;
			_glowIndex = 0;
		}
		
		public function blink(): void
		{
			var i: Object = _items[_itemIndex];
			var glow: GlowFilter = new GlowFilter(_color, i.alpha, i.blur, i.blur, 2, 2);
			_target.filters = [glow];
			
			_repeat--;
			if (_repeat > 0) return;
			
			_repeat = _repeatMax;
			if (_reverse) {
				_itemIndex--;
				if (_itemIndex < 0) {
					_itemIndex = 0;
					_reverse = false;
					countGlow();
				}
			} else {
				_itemIndex++;				// 下组参数
				if (_itemIndex >= _items.length) {
					_itemIndex = _items.length - 1;
					_reverse = true;
					countGlow();
				}
			}
		}
		
		private function countGlow(): void
		{
			if (_glowCount == 0) return;
			
			_glowIndex++;
			if (_glowIndex < _glowCount) return;
			
			stop();
			init();
			if (_onGlowFinished != null) _onGlowFinished();
		}
	}
}
