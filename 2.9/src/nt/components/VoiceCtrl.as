package nt.components
{
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import mx.events.FlexEvent;
	
	import spark.components.HSlider;
	
	public class VoiceCtrl
	{
		public var ctrl: HSlider;
		public var isSilence: Boolean;
		private var _allowCtrl: Boolean = true;
		private var _btState: BrStateButton;
		
		public function VoiceCtrl(ct: HSlider, stb: BrStateButton = null)
		{
			ctrl = ct;
			ct.maximum = 1;
			if (stb != null)
			{
				_btState = stb;
				_btState.addEventListener(MouseEvent.CLICK, onStClick);
			}
			ct.addEventListener(FlexEvent.VALUE_COMMIT, onChange);
			ct.stepSize = .01;
			ct.value = .67;
		}
		private function onChange(e: FlexEvent): void
		{
			if (!isSilence) { setVoice(ctrl.value); }
		}
		private function onStClick(e: MouseEvent): void
		{
			isSilence = (e.target as BrStateButton).state == 0;
			if (isSilence) { setVoice(0); }
			else { setVoice(ctrl.value); }
		}
		private function setVoice(vol : Number) : void
		{
			if(_allowCtrl){
				SoundMixer.soundTransform = new SoundTransform(vol, 0);
			}
		}
		public function off() : void
		{
			setVoice(0);
			_allowCtrl = false;
		}
		
		public function on() : void
		{
			_allowCtrl = true;
			setVoice(ctrl.value);
		}
	}
}