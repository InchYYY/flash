package nl.util
{
	public class Obj
	{
		/*********************************************************************************************************************
		 * 复制对象：从 <b>src</b>（源）=> <b>dest</b>（目标）
		 */
		public static function copy(src: Object, dest: Object): void
		{
			if (!src || !dest) throw new Error("src or dest is null");
			
			for (var i: String in src) {	// 用 "for" 枚举属性（注意：不能用 "for each"）
				dest[i] = src[i];			// i=属性名, p[i]=属性值
			}
		}
		
		public static function toString(obj: Object): String
		{
			if (!obj) throw new Error("obj is null");
			
			var ret: String = "\n";
			for (var i: String in obj) {
				var s: String = " * " + i + ": " + obj[i] + "\n";
				ret += s;
			}
			
			return ret;
		}
	}
}