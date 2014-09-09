package nt.misc
{
	import flash.display.DisplayObject;

	import mx.core.IFlexDisplayObject;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.events.EffectEvent;
	import mx.managers.PopUpManager;

	import spark.components.Group;
	import spark.core.SpriteVisualElement;
	import spark.effects.AnimateFilter;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.filters.BlurFilter;
	import spark.filters.GlowFilter;

	public class Gui
	{
		/*********************************************************************************************************************
		 * 将 flash 对象放入 Flex 对象容器之中
		 */
		public static function addToContainer(flashObj:DisplayObject, container:IVisualElementContainer=null):IVisualElementContainer
		{
			if (!container)
				container=new Group;
			var sprite:SpriteVisualElement=new SpriteVisualElement();
			sprite.addChild(flashObj);
			container.addElement(sprite);
			return container;
		}

		public static function addToContainer_blur(flashObj:DisplayObject, container:IVisualElementContainer=null):UIComponent
		{
			var p:UIComponent=addToContainer(flashObj, container) as UIComponent;
			p.setStyle("modalTransparencyColor", 0);
			p.setStyle("modalTransparencyBlur", 15);
			return p;
		}

		/*********************************************************************************************************************
		 *
		 */
		public static function showBlur(control:IFlexDisplayObject, parent:DisplayObject, modal:Boolean=true):void
		{
			var glowFilter:GlowFilter=new GlowFilter(0x3ccafd, 1, 25, 25);
			var _showEffect:AnimateFilter=new AnimateFilter(control, glowFilter);
			PopUpManager.addPopUp(control, parent, modal);
			PopUpManager.centerPopUp(control);
			_showEffect.play();
		}

		/*********************************************************************************************************************
		 *
		 */
		public static function hideBlur(control:IFlexDisplayObject, fn:Function=null):void
		{
			var blurFilter:BlurFilter=new BlurFilter();
			var _hideEffect:AnimateFilter=new AnimateFilter(control, blurFilter);
			_hideEffect.target=control;
			var si1:SimpleMotionPath=new SimpleMotionPath('blurX', '0', '50');
			var si2:SimpleMotionPath=new SimpleMotionPath('blurY', '0', '50');
			_hideEffect.motionPaths=Vector.<MotionPath>([si1, si2]);
			_hideEffect.addEventListener(EffectEvent.EFFECT_END, function effectEnd(e:EffectEvent):void
			{
				PopUpManager.removePopUp(control);
				if (fn != null)
				{
					fn();
				}
			});
			_hideEffect.play();
		}
	}
}
