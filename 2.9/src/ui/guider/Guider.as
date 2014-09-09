package ui.guider
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import spark.components.Group;
	
	import nl.bron.HostCell;
	import nl.bron.HostSite;
	import nl.bron.HostVideo;
	
	import nt.components.MovieCtrl;

	public class Guider extends EventDispatcher
	{
		private var _on: Boolean = false;
		private var _hv: HostVideo;
		private var _mv: MovieClip;
		private var _ctrl: MovieCtrl;
		private var _boxParent: Group;
		private var _currentSite: HostSite = null;
		private var _currentCell: HostCell = null;
		private var _sites: Array;
		private var _guideBox: GuiderBox;
		private var _lastFrame: int;

		public function Guider(player: Group, ctrl: MovieCtrl, hv: HostVideo)
		{
			_guideBox = new GuiderBox(this);
			_guideBox.visible = false;
			
			_hv = hv;
			_mv = hv.mainClip;
			_ctrl = ctrl;
			_boxParent = player;
			_boxParent.addElement(_guideBox);
			
			initSites();
			addEventListener("SHOW_GUIDER", showGuider);
		}
		
		public function initSites(): void
		{
			_sites = new Array();
			_sites.length = _mv.totalFrames;
			
			var p: HostSite;
			var i: int;
			for each (p in _mv.sites) {
				if (p) {
					i = p.frameId;
					_sites[i] = p;
		//			trace("site: frameId=" + i);
				}
			}
		//	trace("");
		//	for (i = 0; i <= _mv.totalFrames; i++) {
		//		p = HostSite(_sites[i]);
		//		if (p) {
		//			trace("site: frameId=" + p.frameId);
		//		}
		//	}
		}
		
		public function start(): void
		{
			if (_on) return;
			
			_on = true;
			_lastFrame = 0;
			_mv.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_ctrl.start();
		//	trace("start: play()");
		}
		
		public function stop(): void
		{
			if (!_on) return;
			
			_on = false;
			_ctrl.stop();
			_mv.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			closeGuide();
		//	trace("stop: play()");
		}

		private function onEnterFrame(e: Event): void
		{
		//	trace("onEnterFrame", _mv.isPlaying, _mv.currentFrame);
			
			if (_ctrl.isDraging) {
				if (_currentCell) closeGuide();
				return;
			}
			
			if (_guideBox.glowing) {
				_guideBox.blink();
				return;
			}
			
			var i: int = _mv.currentFrame;
			var p: HostSite = HostSite(_sites[i]);

			if (p) {
		//		trace("STOP: frame=" + i);
				_ctrl.stop();
				_currentSite = p;
				_currentCell = null;
				emitShowGuider();
			} else {
		//		trace("_lastFrame", _lastFrame, "currentFrame", i);
				if (i == _lastFrame) {
					stop();
					return;
				}
			}

			_lastFrame = i;
		}
		
		public function emitShowGuider(): void
		{
			dispatchEvent(new Event("SHOW_GUIDER"));
		}
		
		private function closeGuide(): void
		{
			_guideBox.hide();
			_currentCell = null;
		}
		
		public function showGuider(e: Event = null): void
		{
			_guideBox.hide();
			_currentCell = locateNextCell();
			if (_currentCell) {
		//		trace("GUIDE: cell_" + _currentCell.ID);
				_guideBox.show(_currentCell);
			} else {
		//		trace("PLAY ...");
				_ctrl.play();
			}
		}
		
		private function locateNextCell(): HostCell
		{
			if (!_currentSite) return null;
			
			var found: Boolean = false;
			for each (var cell: HostCell in _currentSite.cells) {
				if (found || !_currentCell) return cell;
				if (cell == _currentCell) found = true;
			}
			
			return null;
		}
	}
}
