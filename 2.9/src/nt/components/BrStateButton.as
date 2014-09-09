package nt.components
{
	import flash.events.MouseEvent;
	import spark.components.Button;

	public class BrStateButton extends Button
	{
		public var onStateChanged: Function;	// public function onStateChanged(bt: StateButton): void {}

		private var _state: int = 0;
		private var _stateCount: int = 2;
		private var self: BrStateButton;

		public function BrStateButton()
		{
			self = this;
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		public function setStateCount(value: int): void
		{
			_stateCount = (value < 2) ? 2 : value;
			if (_state >= _stateCount) {
				_state = 0;
				updateState();
			}
		}

		public function setStateCallback(f: Function): void
		{
			onStateChanged = f;
			if (_state != 0) updateState();
		}

		public function set state(value: int): void
		{
			if (value < 0 || value >= _stateCount) return;

			_state = value;
			updateState();
		}

		public function get state(): int
		{
			return _state;
		}

		private function onMouseDown(e: MouseEvent): void
		{
			_state++;
			if (_state >= _stateCount) {
				_state = 0;
			}
			updateState();
		}

		private function updateState(): void
		{
			if (onStateChanged != null) {
				onStateChanged(self);
			}
		}
	}
}
