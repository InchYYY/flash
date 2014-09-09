package nl.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Run
	{
		public static function skipCount_runOnce_onEnterFrame(obj: EventDispatcher, exec: Function, count: int = 1): void
		{
			var onFunc: Function = function(e: Event): void {
				count --;
				if (count < 0) {
					obj.removeEventListener(Event.ENTER_FRAME, onFunc);
					exec();
				}
			};

			obj.addEventListener(Event.ENTER_FRAME, onFunc);
		}
		
		public static function runOnce_onEvent(obj: EventDispatcher, event: String, exec: Function): void
		{
			var onFunc: Function = function(e: Event): void {
				obj.removeEventListener(event, onFunc);
				exec();
			};

			obj.addEventListener(event, onFunc);
		}
	}
}