package nt.components
{
	import flash.events.MouseEvent;
	import spark.components.Button;

	public class BrRadioButton extends Button
	{
		private var _checked: Boolean = false;
		private var self: BrRadioButton;
		private var bar: BrRadioButtonBar;

		public function BrRadioButton()
		{
			self = this;
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function setButtonBar(bar: BrRadioButtonBar): void
		{
			self.bar = bar;
		}

		public function set checked(value: Boolean): void
		{
			_checked = value;
		//	if (_checked) this.skin.setCurrentState("down");
		//	else this.skin.setCurrentState("up");
		//	updateState();
		}

		public function get checked(): Boolean
		{
			return _checked;
		}

		private function onMouseDown(e: MouseEvent): void
		{
			if (_checked) return;

			_checked = true;
			updateState();
		}

		private function updateState(): void
		{
			if (bar != null) bar.setCurrentButton(self);
		}
	}
}
