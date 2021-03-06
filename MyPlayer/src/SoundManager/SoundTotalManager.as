package SoundManager
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	/**
	 *
	 * @author inch
	 */
	public class SoundTotalManager extends Sprite
	{
		/**
		 *
		 */
		public var btnPlay:SimpleButton;
		public var btnPause:SimpleButton;
		public var btnStop:SimpleButton;
		public var btnQuick:SimpleButton;
		public var btnVocUp:SimpleButton;
		public var btnVocDown:SimpleButton;
		public var btnPanUp:SimpleButton;
		public var btnPanDown:SimpleButton;

		private var testSound:Sound;
		private var testChannel:SoundChannel;
		private var testTrans:SoundTransform;
		private var testPosition:Number=0;
		private var isSoundPlay:Boolean;

		private static var _ins:SoundTotalManager;



		public static function get instance():SoundTotalManager
		{
			if (_ins == null)
			{
				_ins=new SoundTotalManager();
			}
			return _ins;
		}

		public function SoundTotalManager()
		{
			
		  btnPlay=new SimpleButton(); 
		  btnPause=new SimpleButton(); 
		  btnStop=new SimpleButton(); 
		  btnQuick=new SimpleButton(); 
		  btnVocUp=new SimpleButton(); 
		  btnVocDown=new SimpleButton(); 
		  btnPanUp=new SimpleButton(); 
		  btnPanDown=new SimpleButton(); 
			
		  this.addChild(btnPlay);
			
			
			testSound=new Sound();
			testChannel=new SoundChannel();
			testTrans=new SoundTransform();

			testSound.load(new URLRequest("test.mp3"));
			testSound.addEventListener(Event.COMPLETE, soundLoadOver);
		}


		private function soundPlay(e:MouseEvent):void
		{
			if (isSoundPlay)
			{
				return;
			}
			isSoundPlay=true;

			testChannel=testSound.play(testPosition);
		}

		private function soudPause(e:MouseEvent):void
		{
			if (!isSoundPlay)
			{
				return;
			}
			isSoundPlay=false;

			testPosition=testChannel.position;
			testChannel.stop();
		}

		private function soundStop(e:MouseEvent):void
		{
			isSoundPlay=false;
			testPosition=0
			testChannel.stop();
		}

		private function soudQuickPlay(e:MouseEvent):void
		{
			if (!isSoundPlay)
			{
				return;
			}

			testPosition=testChannel.position;
			testChannel.stop();
			testChannel=testSound.play(testPosition + 500);
		}


		private function upSoudVoc(e:MouseEvent):void
		{
			if (!isSoundPlay)
			{
				return;
			}

			testTrans=testChannel.soundTransform;
			var addedVoc:Number=testTrans.volume > 1 ? 1 : (testTrans.volume + 0.05);
			testTrans.volume=addedVoc;
			testChannel.soundTransform=testTrans;
		}

		private function downSoundVoc(e:MouseEvent):void
		{
			if (!isSoundPlay)
			{
				return;
			}

			testTrans=testChannel.soundTransform;
			var downVoc:Number=testTrans.volume < 0 ? 0 : (testTrans.volume - 0.05);
			testTrans.volume=downVoc;
			testChannel.soundTransform=testTrans;
		}

		private function upSoundPan(e:MouseEvent):void
		{
			if (!isSoundPlay)
			{
				return;
			}
			testTrans=testChannel.soundTransform;
			var addedPan:Number=testTrans.pan > 1 ? 1 : (testTrans.pan + 0.05);
			testTrans.pan=addedPan;
			testChannel.soundTransform=testTrans;
		}

		private function downSoundPan(e:MouseEvent):void
		{
			if (!isSoundPlay)
			{
				return;
			}
			testTrans=testChannel.soundTransform;
			var downPan:Number=testTrans.pan < 0 ? 0 : (testTrans.pan - 0.05);
			testTrans.pan=downPan;
			testChannel.soundTransform=testTrans;
		}

		//加载音乐并控制播放
		private function soundLoadOver(e:Event):void
		{
			testSound.removeEventListener(Event.COMPLETE, soundLoadOver);

			btnPause.addEventListener(MouseEvent.CLICK, soudPause);
			btnPlay.addEventListener(MouseEvent.CLICK, soundPlay);
			btnQuick.addEventListener(MouseEvent.CLICK, soudQuickPlay);
			btnStop.addEventListener(MouseEvent.CLICK, soundStop);
			btnVocUp.addEventListener(MouseEvent.CLICK, upSoudVoc);
			btnVocDown.addEventListener(MouseEvent.CLICK, downSoundVoc);
			btnPanUp.addEventListener(MouseEvent.CLICK, upSoundPan);
			btnPanDown.addEventListener(MouseEvent.CLICK, downSoundPan);
		}
	}
}
