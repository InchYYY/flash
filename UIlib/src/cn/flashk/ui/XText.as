package cn.flashk.ui
{
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 *  TextField 辅助
	 * @author flashk
	 * 
	 */
	public class XText
	{
		public function XText()
		{
		}
		
		/**
		 * 检查一个 TextField 中的字符串是否超出长度，如果超出，截断文本并在后面追加...省略号，并使用Tooltip提示全部文本
		 * @param text TextField对象
		 * @param isReplace 是否替换
		 * @param isShowTip 是否使用tip提示
		 * @param addEndText 省略号的内容，默认为 "..."
		 * @return  文本长度是否超出
		 * 
		 */
		public static function checkTextMax(text:TextField,isReplace:Boolean=true,isShowTip:Boolean=true,addEndText:String="..."):Boolean
		{
			var isOut:Boolean = false;
			var str:String = text.text;
			if(text.textWidth > text.width-2)
			{
				isOut = true;
			}
			var rect:Rectangle;
			if(isOut && isReplace)
			{
				for(var i:int=0;i<text.text.length;i++)
				{
					rect = text.getCharBoundaries(i);
					if(rect.x+rect.width > text.width)
					{
						text.text = text.text.slice(0,i-1)+addEndText;
						
						break;
					}
				}
			}
			if(isShowTip)
			{
				if(isOut)
				{
					Xtip.registerTip(text,str);
				}else
				{
					Xtip.clearTip(text);
				}
			}
			return isOut;
		}
	}
}