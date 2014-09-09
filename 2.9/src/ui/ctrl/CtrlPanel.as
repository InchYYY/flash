package ui.ctrl 
{
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.BorderContainer;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HSlider;
	
	import nt.components.BrStateButton;
	
	public class CtrlPanel extends BorderContainer
	{
		public var btCamera: Button;
		public var btMovic: BrStateButton;
		public var btVoice: BrStateButton;
		public var slMovic: HSlider;
		public var slVoice: HSlider;
		public var topBar: Group;
		public var showTime: Function;
		private var sk: skinCtrlPanel;
		
		public function CtrlPanel()
		{
			super();
			setStyle("skinClass", skinCtrlPanel);
			addEventListener(FlexEvent.CREATION_COMPLETE, function (e : FlexEvent): void {
				sk = skin as skinCtrlPanel;
				btCamera = sk.btCamera;
				btMovic = sk.btMovic;
				btVoice = sk.btVoice;
				slMovic = sk.slMovic;
				slVoice = sk.slVoice;
				topBar = sk.topBar;
				showTime = sk.showTime;
				parent.addEventListener(MouseEvent.ROLL_OVER, function (e: MouseEvent): void { sk.currentState = ""; });
				parent.addEventListener(MouseEvent.ROLL_OUT, function (e: MouseEvent): void { sk.currentState = "disabled"; });
			});
		}
	}
}