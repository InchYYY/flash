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
	}
}
