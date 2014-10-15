package tool
{

	/**
	 * @全局信息和变量
	 * @author inch
	 */
	public class API
	{
		private static var _ins:API


		public static function instance():API
		{
			if (_ins == null)
			{
				_ins=new API();
			}
			return _ins as API;
		}

		public function get thisWidth():Number
		{
			return 640;
		}

		public function get thisHight():Number
		{
			return 320;
		}
		/** 
		 * @param arr  打乱数组里面所有元素 返回一个新数组
		 * @return 
		 * 
		 */
		public function disorder(arr:Array):Array
		{
			var len:uint=arr.length;
			var cache:*;
			var ti:uint;
			for (var i:uint=0; i < len; i++)
			{
				ti=int(Math.random() * len);
				cache=arr[i];
				arr[i]=arr[ti];
				arr[ti]=cache;
			}
			while (--i >= 0)
			{
				ti=int(Math.random() * len);
				cache=arr[i];
				arr[i]=arr[ti];
				arr[ti]=cache;
			} 
			return arr; 
		}
	}
}
