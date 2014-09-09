package  UtilsTool.arrayUtils
{
	/**
	 * as3数组操作工具类集合
	 * @author xuechong  <br/>
	 * version v20121029.0.1  <br/>
	 * date 2012.10.29  <br/>
	 * QQ群 238680860  <br/>
	 * <br/>
	 * removeValues  删除一个指定数组中的某个元素(全删除)  <br/>
	 * removeValue   删除一个指定数组中的某个元素(删除一个)  <br/>
	 * removeAllBehindIndex  删除指定索引之后的所有数组元素  <br/>
	 * updateDelArr  更新数组值,每个数组元素统一删除某字符串(如果存在)  <br/>
	 * createUniqueCopy  从原数组中拷贝一个无重复元素的新数组  <br/>
	 * copyArray  浅表克隆一个指定的数组  <br/>
	 * cloneArray  浅表克隆一个指定的数组  <br/>
	 * arraysAreEqual  判断2个目标数组是否相同  <br/>
	 * getRepeatArr  解析出数组中的重复元素(由c语言改编)  <br/>
	 * randomGetArr  随机获取指定数组的不重复元素  <br/>
	 * randomSortArr  随机排序指定数组的元素  <br/>
	 * setSize  设置目标数组的长度  <br/>
	 * */
	public class ArrayUtil
	{
		/**
		 * 删除一个指定数组中的某个元素(全删除)
		 * @param arr 指定的目标数组
		 * @param value 要删除的元素
		 * @return void
		 * */
		public static function removeValues(arr:Array, value:Object):void
		{
			var n:uint = arr.length;
			for(var i:Number = n; i >= 0; i--)
			{
				if(arr[i] === value)
				{
					arr.splice(i, 1);
				}
			}
		}
		
		/**
		 * 删除一个指定数组中的某个元素(删除一个)
		 * @param arr 指定的目标数组
		 * @param value 要删除的元素
		 * @return Boolean 删除成功返回true，删除失败返回false
		 * */
		public static function removeValue(arr:Array, value:Object):Boolean
		{
			if(arr.indexOf(value) != -1)
			{
				arr.splice(arr.indexOf(value), 1);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 删除指定索引之后的所有数组元素
		 * @param arr 指定的目标数组
		 * @param index 指定的索引
		 * @return void 
		 * */
		public static function removeAllBehindIndex(arr:Array, index:int):void
		{
			if(index > 0)
			{
				var n:int = arr.length;
				for(var i:int = index + 1; i < n; i++)
				{
					arr.pop();
				}
			}
			else
			{
				arr.splice(0, arr.length);
			}
		}
		
		/**
		 * 更新数组值,每个数组元素统一删除某字符串(如果存在)
		 * @param $arr 源数组对象
		 * @param ...arr 不定个数参数
		 * @reutrn (Array) 新数组对象
		 * */
		public static function updateDelArr($arr:Array, ...arg):Array
		{
			var i:int = 0;
			for each(var s:String in $arr)
			{
				for each(var t:String in arg)
				{
					s = s.replace(new RegExp(t, "g"), "");
				}
				$arr[i] = s;
				i++;
			}
			return $arr;
		}
		
		/**
		 * 从原数组中拷贝一个无重复元素的新数组
		 * */
		public static function createUniqueCopy(arr:Array):Array
		{
			var newArr:Array = [];
			var n:Number = arr.length;
			var item:Object;
			for(var i:uint = 0; i < n; i++)
			{
				item = arr[i];
				if(newArr.indexOf(item) == -1)
				{
					newArr.push(item);
				}
			}
			return newArr;
		}
		
		/**
		 * 浅表克隆一个指定的数组
		 * */
		public static function copyArray(arr:Array):Array
		{	
			return arr.slice();
		}
		
		/**
		 * 浅表克隆一个指定的数组
		 * */
		public static function cloneArray(arr:Array):Array
		{
			return arr.concat();
		}
		
		/**
		 * 判断2个目标数组是否相同
		 * @param arr1 目标数组
		 * @param arr2 目标数组
		 * @return 若相等返回true,不相等返回false
		 * */
		public static function arraysAreEqual(arr1:Array, arr2:Array):Boolean
		{
			if(arr1.length != arr2.length)
			{
				return false;
			}
			else
			{
				var n:Number = arr1.length;
				for(var i:Number = 0; i < n; i++)
				{
					if(arr1[i] != arr2[i])
					{
						return false;
					}
				}
				return true;
			}
		}
		
		/**
		 * 解析出数组中的重复元素(由c语言改编)
		 * [1, 3, 5, 7, 1, 3, 8, "a", "b", "a", -1, -1]  -->  [1,3,a,-1]   [5,7,8,b]
		 * @param $r 源数组对象
		 * @return (Array) 返回一个对象 obj.repeat/obj.noRepeat
		 * */
		public static function getRepeatArr($r:Array):Object
		{
			var repeat:Array = [];    //记录重复的元素
			var noRepeat:Array = [];    //记录没有重复的元素
			var f:String = "";    //设定一个标识符(任意值)，要确保此值不和源数组中的任何元素相同
			var m:int = 0;
			var n:int = $r.length;
			var i:int = -1;
			for each(var a:* in $r)
			{
				i++;
				m = 1;
				if(a == f)
				{
					continue;
				}
				var j:int = i + 1;
				while(j < n)
				{
					if(a == $r[j])
					{
						m++;
						$r[j] = f;
					}
					j++;
				}
				if(m > 1)
				{
					repeat.push(a);
				}
				else if(m == 1)
				{
					noRepeat.push(a);
				}
			}
			var obj:Object = new Object();
			obj.repeat = repeat;
			obj.noRepeat = noRepeat;
			return obj;
		}
		
		/**
		 * 随机获取指定数组的不重复元素
		 * @param $arr 指定的目标数组
		 * @param num 返回的元素个数
		 * @return Array
		 * */
		public static function randomGetArr($arr:Array, num:int):Array
		{
			var copyArr:Array = [];    //创建一个原数组副本
			for each(var elements:Object in $arr)
			{
				copyArr.push(elements);
			}
			var array:Array = [];
			var i:int = 0;
			num = num <= copyArr.length ? num : copyArr.length;
			while(i < num)
			{
				var index:int = radomBetw(0, copyArr.length - 1);    //获取随机索引
				array.push(copyArr[index]);
				copyArr.splice(index, 1);
				i++;
			}
			return array;
		}
		
		/**
		 * 返回两个指定整型之间的随机数, 包含两边的数
		 * */
		private static function radomBetw(start:int, end:int):int
		{
			return int(Math.random() * (end - start + 1) + start);
		}
		
		/**
		 * 随机排序指定数组的元素
		 * */
		public static function randomSortArr($arr:Array):Array
		{
			var arr:Array = $arr.slice();
			var i:int = arr.length;
			var temp:Object;
			var a:int;
			var b:int;
			while(i > 0)
			{
				a = i - 1;
				b = Math.floor(Math.random() * i);
				//若不相等就互相换位
				if(a != b)
				{
					temp = arr[a];
					arr[a] = arr[b];
					arr[b] = temp;
				}
				i--;
			}
			return arr;
		}
		
		/**
		 * 设置目标数组的长度
		 * @param 目标数组
		 * @param 长度值
		 * @return void
		 */
		public static function setSize(arr:Array, size:int):void
		{
			if(size < 0)
			{
				size = 0;
			}
			else if(size != arr.length)
			{
				if(size > arr.length)
				{
					arr[size - 1] = undefined;
				}
				else
				{
					arr.splice(size);
				}
			}
		}
		
	}
}