package cn.flashk.controls.interfaces
{
	import cn.flashk.controls.DoubleDeckTree;

	public interface ITreeRender extends IListRender
	{
		function set tree(value:DoubleDeckTree):void;
		function set trunkIndex(value:int):void;
		function get trunkIndex():int;
		function set open(valeu:Boolean):void;
		function get nodeIndex():uint;
	}
}