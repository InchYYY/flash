package cn.flashk.utils
{
	public class VectorSortOn
	{
		public function VectorSortOn()
		{
		}
		
		public static function sortOn(sortVct:*,newVct:*,fieldName:Object, options:Object = null):*
		{
			var arr:Array = [];
			var len:int = sortVct.length;
			for(var i:int=0;i<len;i++){
				arr[i] = sortVct[i];
			}
			arr.sortOn(fieldName,options);
			for( i=0;i<len;i++){
				newVct[i] = arr[i];
			}
			return newVct;
		}
	}
}