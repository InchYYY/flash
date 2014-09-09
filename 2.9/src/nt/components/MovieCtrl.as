package nt.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.HSlider;
	
	public class MovieCtrl
	{
		public var showFramePos: Function = null;		// function showFramePos(frame: int): void {}
		public var onStart: Function;
		public var onEnd: Function;
		public var onDragCommit: Function;

		private var _mv: MovieClip;
		private var _progress: HSlider;
		private var _btPlayPause: BrStateButton;
		private var _playing: Boolean = false;
		private var _draging: Boolean = false;
		private var _started: Boolean = true;
		private var _startPos: int = 2;
		private var _playPos: int;
		
		public function get isPlaying(): Boolean { return _playing; }
		public function get isDraging(): Boolean { return _draging; }
		public function set playPos(i: int): void { _playPos = i; }
		
		/**
		 * 播放进度控制
		 */
		public function MovieCtrl(mv: MovieClip, progress: HSlider, btPlayPause: BrStateButton = null, btReplay: Button = null, btStop: Button = null)
		{
			_mv = mv;
			_mv.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_mv.addFrameScript(mv.totalFrames - 1, finished);

			_progress = progress;
			_progress.maximum = mv.totalFrames;
			_progress.addEventListener(FlexEvent.CHANGE_START, onStartDrag);
			_progress.addEventListener(FlexEvent.CHANGE_END, onEndDrag);
			_progress.addEventListener(FlexEvent.VALUE_COMMIT, onProgress);

			if (btPlayPause) {
				_btPlayPause = btPlayPause;
				_btPlayPause.addEventListener(MouseEvent.CLICK, onPlayPauseClick);
				_btPlayPause.addEventListener(MouseEvent.DOUBLE_CLICK, onReplay);
			}
			if (btReplay) btReplay.addEventListener(MouseEvent.CLICK, onReplay);
			if (btStop) btStop.addEventListener(MouseEvent.CLICK, onStop);

			_playPos = _startPos;
		}
		
		public function start(): void
		{
			_started = true;
			_playPos = _startPos;
			play();
		}
		
		public function play(): void
		{
			if (_playing) return;
			
			if (_started) {
				_started = false;
				if (onStart != null) onStart();
			}

			if (_playPos == _mv.currentFrame) {
				_mv.play();
			} else {
				_mv.gotoAndPlay(_playPos);
			}

			if (_btPlayPause) _btPlayPause.state = 1;
			_playing = true;
		}
		
		public function stop(): void
		{
			if (!_playing) return;
			
			_mv.stop();
			_playPos = _mv.currentFrame;

			if (_btPlayPause) _btPlayPause.state = 0;
			_playing = false;
		}
		
		private function onEnterFrame(e: Event): void
		{
			if (!_draging) {
				_progress.value = _mv.currentFrame;
				if (showFramePos != null) showFramePos(_mv.currentFrame);
			}
		}
		
		private function onStartDrag(e: FlexEvent): void
		{
			if (_playing) _mv.stop();
			_draging = true;
		}

		private function onEndDrag(e: FlexEvent): void
		{
			_draging = false;
			_playPos = _mv.currentFrame;
			if (_playing) _mv.play();
		}

		private function onProgress(e: FlexEvent): void
		{
			if (_draging) {
				_mv.gotoAndStop(_progress.value);
				if (onDragCommit != null) { onDragCommit(); }
			}
		}

		private function finished(): void
		{
			stop();
			if (_draging) return;
			
			_playPos = _startPos;
			_started = true;
			if (onEnd != null) onEnd();
		}

		private function onPlayPauseClick(e: MouseEvent): void
		{
			if (_mv.isPlaying) {
				stop();
			} else {
				play();
			}
		}
		
		private function onStop(e: MouseEvent): void
		{
			stop();
		}
		
		private function onReplay(e: MouseEvent): void
		{
			start();
		}
	}
}
