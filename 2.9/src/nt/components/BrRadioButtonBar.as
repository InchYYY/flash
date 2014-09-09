package nt.components
{
//	import flash.events.MouseEvent;
	import spark.components.Button;
	import spark.components.Group;
//	import spark.components.HGroup;
//	import spark.components.VGroup;
//	import spark.components.supportClasses.SkinnableComponent;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;
//	import spark.layouts.supportClasses.LayoutBase;

	public class BrRadioButtonBar extends Group
	{
		private var onStateChanged: Function;	// public function onStateChanged(bt: Button, down: Boolean): void {}
		private var onIndexChanged: Function;	// public function onIndexChanged(currentIndex: int, prevIndex: int): void {}
		private var self: BrRadioButtonBar;

		private var _buttonList: Array = [];
		private var _currentIndex: int = -1;
		private var _spacing: int = 8;
		private var _direction: String = "horizontal";
		private var _horizontalAlign: String = "center";
		private var _verticalAlign: String = "middle";

		public function BrRadioButtonBar()
		{
			self = this;
			super();
		}

		override protected function createChildren(): void
		{
			if (_direction == "horizontal") {
				var hbox: HorizontalLayout = new HorizontalLayout();
				hbox.horizontalAlign = _horizontalAlign;
				hbox.verticalAlign = _verticalAlign;
				hbox.gap = _spacing;
				self.layout = hbox;
			}
			else {
				var vbox: VerticalLayout = new VerticalLayout();
				vbox.horizontalAlign = _horizontalAlign;
				vbox.verticalAlign = _verticalAlign;
				vbox.gap = _spacing;
				self.layout = vbox;
			}
			createButtons();
		}

		private function createButtons(): void
		{
			var cnt: int = _buttonList.length;
			for (var i: int = 0; i < cnt; i++) {
			//	var s: String = _buttonList[i] as String;
				var bt: BrRadioButton = _buttonList[i] as BrRadioButton;
				//addButton(s);
				bt.setButtonBar(self);
				self.addElement(bt);
			}
		}

	/*	public function addButton(label: String): void
		{
			if (self.layout == null) return;

			var bt: Button = new Button;
			bt.label = label;
			addElement(bt);
		//	items.push(bt);
		//	if (_currentIndex < 0) _currentIndex = 0;
			handleButtonEvent(bt);
		}

		public function setButtonList(labels: String): void
		{
			var a: Array = labels.split(",");
			for (var i: int = 0; i < a.length; i++) {
				var s: String = a[i] as String;
				addButton(s);
			}
		}

		private function handleButtonEvent(button: Button): void
		{
			button.addEventListener(MouseEvent.MOUSE_DOWN, function (e: MouseEvent): void {
				setCurrentButton(button);
			});
		}*/

		public function setStateChangedCallback(f: Function): void
		{
			onStateChanged = f;
			//if (_currentIndex < 0 ) {
			//	currentIndex = 0;
			//}
		}
		
		public function setIndexChangedCallback(f: Function): void
		{
			onIndexChanged = f;
		}

		public function setCurrentButton(button: Button): void
		{
			var cnt: int = buttonCount;
			for (var i: int = 0; i < cnt; i++) {
				var btn: Button = _buttonList[i] as Button;
				if (btn == button) {
					currentIndex = i;
					return;
				}
			}
		}

		private function updateState(index: int, down: Boolean): void
		{
			var bt: BrRadioButton = _buttonList[index] as BrRadioButton;
			if (onStateChanged != null) {
				onStateChanged(bt as Button, down);
			}
			bt.checked = down;
		}

		//----------------------------------
		//  buttonList
		//----------------------------------

		public function get buttonList(): Array {
			return _buttonList;
		}

		public function set buttonList(value: Array): void {
			_buttonList = value;
		}

		//----------------------------------
		//  currentIndex
		//----------------------------------

		public function set currentIndex(value: int): void
		{
			if (value < 0 || value >= buttonCount) return;
			if (value == _currentIndex) return;

			var prevIndex: int = _currentIndex;
			if (prevIndex >= 0) {
				updateState(prevIndex, false);
			}

			_currentIndex = value;
			updateState(_currentIndex, true);
			
			if (onIndexChanged != null)
				onIndexChanged(_currentIndex, prevIndex);
		}

		public function get currentIndex(): int
		{
			return _currentIndex;
		}

		//----------------------------------
		//  buttonCount
		//----------------------------------

		public function get buttonCount(): int
		{
			return _buttonList.length;
		}

		//----------------------------------
		//  spacing
		//----------------------------------

		public function get spacing(): int {
			return _spacing;
		}

		public function set spacing(value: int): void {
			_spacing = value;
		}

		//----------------------------------
		//  horizontalAlign
		//----------------------------------

		[Inspectable(category="Common", enumeration="left,center,right", defaultValue="center")]

		public function get horizontalAlign(): String {
			return _horizontalAlign;
		}

		public function set horizontalAlign(value: String): void {
			_horizontalAlign = value;
		}

		//----------------------------------
		//  verticalAlign
		//----------------------------------

		[Inspectable(category="Common", enumeration="top,middle,bottom", defaultValue="middle")]

		public function get verticalAlign(): String {
			return _verticalAlign;
		}

		public function set verticalAlign(value: String): void {
			_verticalAlign = value;
		}

		//----------------------------------
		//  direction
		//----------------------------------

		[Inspectable(category="Common", enumeration="horizontal,vertical", defaultValue="horizontal")]

		public function get direction(): String {
			return _direction;
		}

		public function set direction(value: String): void {
			_direction = value;
		}
	}
}
