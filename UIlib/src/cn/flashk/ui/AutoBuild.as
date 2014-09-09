package cn.flashk.ui
{
	import flash.display.Sprite;
	
	import cn.flashk.controls.support.UIComponent;

	/**
	 * UI自动构建（和FlashCS配合） 
	 * @author flashk
	 * 
	 */
	public class AutoBuild
	{
		public function AutoBuild()
		{
		}
		
		public function buildAll(target:Sprite):void
		{
			UI.autoBuild(target);
		}
		
		public function buildOne(targetName:String,parentSprite:Sprite,uiComponent:UIComponent,
								   isReSize:Boolean=true,
								   isUseSameName:Boolean=true,
								   isUseSameXY:Boolean=true,
								   isAutoRemove:Boolean=true):void
		{
			UI.buildOne(targetName,parentSprite,uiComponent,isReSize,isUseSameName,isUseSameXY,isAutoRemove);
		}
	}
}