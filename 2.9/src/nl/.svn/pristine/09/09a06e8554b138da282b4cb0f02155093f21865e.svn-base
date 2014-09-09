package nl.comm
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class LoadManage extends EventDispatcher
	{
		private var mcs   : Array;
		private var ls    : Array;
		private var order : int;
		private var autoLoad : Boolean;
		public var ErrUrl : String = "";
		private var self : LoadManage;

		public function LoadManage()
		{
			self = this;
			mcs = new Array();
			ls = new Array();
			autoLoad = true;
		}
	
		public function Add(u: String, p: Sprite, o: int): mLoad
		{
			var mc: mLoad = new mLoad(u, p);
			if (o == 1) { mcs.unshift(mc); }
			else { mcs.push(mc); }
			Load(null, 0);
			return mc;
		}
		
		public function Load(mc: mLoad, o: int) : void
		{
			var act : mLoad;
			if ((mc != null) && ! (mc.isLoaded && mc.isLoading)) { ls.push(mc); }
			if (o == 1 && mc != null) { act = mc; }
			else
			{
				var i : int = ls.length - 1;
				while (i >= 0)
				{
					if (ls[i].isLoaded || ls[i].err) { ls.splice(i, 1); }
					i --;
				}
				if (ls.length == 0)
				{
					for each (var m : mLoad in mcs)
					{
						if (! (m.isLoaded || m.isLoading))
						{
							ls.push(m);
							break;
						}
					}
					if (ls.length == 0) { return; }
				}
				if (ls[0].isLoading) { return; }
				act = ls[0];
			}
			if (act != null)
			{
				act.load();
				act.loader.addEventListener(Event.COMPLETE, function (evt:Event) : void {
					Load(null, 0);
				});
				act.addEventListener("MLOAD_IOERROR", function (e : Event) : void {
					self.ErrUrl = e.target.surl;
					self.dispatchEvent(new Event("LOADMANAGE_IOERROR"));
					Load(null, 0);
				});
			}
		}
	}
}