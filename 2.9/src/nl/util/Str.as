package nl.util
{
	public class Str
	{
		public function Str()
		{
		}
		
		public static function toNumber(str: String): Number
		{
			if (!str) return 0.0;
			
			var num: Number = Number(str);
			return isNaN(num) ? 0.0 : num;
		}
		
		public static function toInt(str: String): int
		{
			if (!str) return 0;
			
			var num: Number = parseInt(str, 10);
			return isNaN(num) ? 0 : num;
		}
	}
}