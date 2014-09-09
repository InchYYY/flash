package nl.themotionstudio.events
{
	import flash.events.Event;

	public class CustomEvent extends Event {
		
		public var eventObj:Object;
		
		public function CustomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, eventObj:Object = null){
			super(type, bubbles, cancelable);
			this.eventObj = eventObj;
		}
		
		public override function clone():Event{
			return new CustomEvent(type, bubbles, cancelable, eventObj);
		}
		
		public override function toString():String{
			return formatToString("CustomEvent", "type", "bubbles", "cancelable", "eventPhase", "eventObj");
		}
		
	}
}