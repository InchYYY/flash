package  UtilsTool.colorUtils
{
	/**
	 * as3颜色操作工具类集合
	 * @author xuechong  <br/>
	 * version v20121029.0.1  <br/>
	 * date 2012.10.29  <br/>
	 * QQ群 238680860  <br/>
	 * */
	public class ColorUtil
	{
		public function ColorUtil()
		{
			
		}
		
		/**
		 * 颜色提取
		 * */
		public static function getColor():void
		{
//			red = color24 >> 16;
//			green = color24 >> 8 & 0xFF;
//			blue = color24 & 0xFF;
//			alpha = color32 >> 24;
//			red = color32 >> 16 & 0xFF;
//			green = color32 >> 8 & 0xFF;
//			blue = color232 & 0xFF;
		}
		
		/**
		 * 按位计算得到颜色值
		 * */
		public static function getColorValues():void
		{
//			color24 = red << 16 | green << 8 | blue;
//			color32 = alpha << 24 | red << 16 | green << 8 | blue;
		}
		
		/**
		 * 颜色运算得到透明值
		 * */
		public static function getColorAlpha():void
		{
			var t:uint=0x77ff8877
			var s:uint=0xff000000
			var h:uint=t&s
			var m:uint=h>>>24
			trace(m)
		}
		
	}
}