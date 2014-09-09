﻿package nl.bron 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	
	public class brSndCell extends brCell
	{
		public var isSetSound:Boolean = false;//用于判断是否已经初始化过。
		
		private var _startFrame:int;
		private var _lastFrame: int = -1;
		private var _playing: Boolean = false;
		
		private var _mv:brContainer;
		private var _music:Sound = new Sound();
		private var _url:URLRequest = new URLRequest();
		private var _channel:SoundChannel = new SoundChannel();
		private var _vol: SoundTransform = null;
		private var _loop:Boolean;
		
		public function brSndCell()
		{
			super();
		}
		
		public function setSound(mv:brContainer, url:String, loop:Boolean = false, startFrame: int = 2): void
		{
			if(isSetSound)_music = new Sound();
			_url.url = url;
			_music.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void{trace("音频文件不存在！")});
			_music.load(_url);
			_mv = mv;
			_loop = loop;
			_startFrame = startFrame;
			setMvVolume(0);
			if(!isSetSound)_mv.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			isSetSound = true;
		}
		
		private function onEnterFrame(e:Event): void
		{
			var cur: int = _mv.currentFrame;
			if (cur == _lastFrame || cur < _startFrame || cur >= _mv.totalFrames) {
				stopMusic();
			} else {
				if (!_playing || _lastFrame != (_mv.currentFrame-1)) playMusic();
			}

			_lastFrame = _mv.currentFrame;
		}
		
		private function onSndComplete(e:Event): void
		{
		//	trace("com")
			playMusic();
		}
		
		private function playMusic(): void
		{
			stopMusic();

			var p: Number = getPlayPos();
			if (p < 0) return;
			
			_channel.removeEventListener(Event.SOUND_COMPLETE, onSndComplete);
			_channel = _music.play(p, 0, _vol);
			_channel.addEventListener(Event.SOUND_COMPLETE, onSndComplete);
			_playing = true;
		}

		private function getPlayPos(): Number
		{
			var pp:Number = (_mv.currentFrame - _startFrame) * (1000/25);
			if(pp > _music.length){
				if (!_loop) {
					return -1;		// 终止播放
				}
				pp = pp % _music.length;
			}
			return pp;
		}
		
		private function stopMusic(): void
		{
		//	trace(_mv.currentFrame,_startFrame)
			if (_playing){
				_channel.stop();
				_playing = false;
			}
		}
		
		public function setMvVolume(value: Number): void
		{
			if(_mv)
				_mv.soundTransform = new SoundTransform(value, 0);
		}
		
		/**
		 * 设置附加音乐(_music)的音量
		 */
		public function setVolume(value: Number): void
		{
			_vol = new SoundTransform(value, 0);
		}
	}
}