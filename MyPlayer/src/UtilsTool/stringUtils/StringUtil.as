package  UtilsTool.stringUtils
{
	
	
	/**
	 * as3字符串操作工具类集合
	 * @author xuechong  <br/>
	 * version v20121029.0.2  <br/>
	 * date 2011.09.23  <br/>
	 * QQ群 238680860  <br/>
	 * <br/><br/>
	 * 函数列表：
	 * <br/>
	 * reverseSort       字符串相反排列函数  <br/>
	 * replaceAll        全部替换指定的字符串（区分大小写）  <br/>
	 * replaceAll2       全部替换指定的字符串（区分大小写）  <br/>
	 * replaceAll3       全部替换指定的字符串（不区分大小写）  <br/>
	 * isEqual           当忽略大小写时字符串是否相等  <br/>
	 * isBlank           是否为空白，是否包括多个空白和换行空白等  <br/>
	 * strAmount         指定字符串在源字符串中出现的次数  <br/>
	 * trimLeft          去掉目标字符串左侧的所有空格  <br/>
	 * trimRight         去掉目标字符串右侧的所有空格  <br/>
	 * trimBoth          去掉指定字符串两边的所有空格  <br/>
	 * isTargetFirst     指定字符是否在原字符串的开头  <br/>
	 * isTargetEnd       指定字符是否在原字符串的结尾  <br/>
	 * isChinese         是否全部都是中文字符(中文形式的标点符号也是中文、但数字和-都不算中文)  <br/>
	 * hasChinese        是否含有中文字符(中文形式的标点符号也是中文、但数字和-都不算中文)  <br/>
	 * getChinese        提取中文字符组成纯中文字符串  <br/>
	 * enterStr          消除双换行符  <br/>
	 * isHttpUrl         是否为http形式的url地址格式  <br/>
	 * isEvenNum         是否为偶数  <br/>
	 * getBetween        获取两个字符串(两者都相对于总字符串唯一)之间的字符串  <br/>
	 * getBetween2       获取两个单字符之间的字符串  <br/>
	 * deleteAll         在一个字符串中删除所有指定的字符串  <br/>
	 * chineseAmount     有多少个中文字符  <br/>
	 * englishAmount     有多少个非中文字符  <br/>
	 * chinese2Py        中文字符串转换为拼音函数  <br/>
	 * bihe0Arr          字符串(a)(b)(c) --> 数组对象[a, b, c]  <br/>
	 * bihe2Arr          字符串abc(def)gh(hi) --> 数组对象[def, hi] (方法1)  <br/>
	 * bihe3Arr          字符串abc(def)gh(hi) --> 数组对象[def, hi] (方法2)  <br/>
	 * bihe4Arr          字符串a*bc.e<fg>{hij}tp<kmn> --> 数组对象[a*bc.e,<fg>,{hij},tp,<kmn>](方法1)  <br/>
	 * bihe5Arr          字符串a*bc.e<fg>{hij}tp<kmn> --> 数组对象[a*bc.e,<fg>,{hij},tp,<kmn>](方法2)  <br/>
	 * getGUID           生成全球唯一随机GUID字符串  <br/>
	 * replaceAt         替换指定序列的字符串
	 * */
	public class StringUtil
	{
		/**
		 * 字符串相反排列函数
		 * @param $str 原字符串
		 * @return (String) 返回相反的原字符串
		 * */
		public static function reverseSort($str:String):String
		{
			var s:String = "";
			var r:Array = $str.split("");
			var n:Number = r.length;
			for(var i:int = 0; i < n; i++)
			{
				s += r[n - i - 1];
			}
			return s;
		}
		
		/**
		 * 全部替换指定的字符串（区分大小写）。如要替换的字符串不在源字符串中则返回源字符串。
		 * @param $str 源总字符串
		 * @param $old 要替换的字符串
		 * @param $new 替换成的新字符串
		 * @return (String) 替换后的新字符串
		 * */
		public static function replaceAll($str:String, $old:String, $new:String):String
		{
			var str:String = "";
			var r:Array = $str.split($old);
			var n:int = r.length;
			var i:int = 0;
			for each(var s:String in r)
			{
				if(i < n - 1)
				{
					str += s + $new;
				}
				else
				{
					str += s;
				}
				i++;
			}
			return str;
		}
		
		/**
		 * 全部替换指定的字符串（区分大小写）。如要替换的字符串不在源字符串中则返回源字符串。
		 * @param $str 源总字符串
		 * @param $old 要替换的字符串
		 * @param $new 替换成的新字符串
		 * @return (String) 替换后的新字符串
		 * */
		public static function replaceAll2($str:String, $old:String, $new:String):String
		{
			return $str.replace(new RegExp($old, "g"), $new);
		}
		
		/**
		 * 全部替换指定的字符串（不区分大小写）。
		 * 如要替换的字符串不在源字符串中则返回源字符串。
		 * @param $str 源总字符串
		 * @param $old 要替换的字符串
		 * @param $new 替换成的新字符串
		 * @return (String) 替换后的新字符串
		 * */
		public static function replaceAll3($str:String, $old:String, $new:String):String
		{
			return $str.replace(new RegExp($old, "gi"), $new);
		}
		
		/**
		 * 当忽略大小写时字符串是否相等
		 * @param $str1 
		 * @param $str2 
		 * @return (Boolean) 如果相等返回true，否则返回false
		 * */
		public static function isEqual($str1:String, $str2:String):Boolean
		{
			if($str1.toLowerCase() == $str2.toLowerCase())
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 是否为空白，包括多个空白和换行空白等
		 * @param $str 源字符串
		 * @return (Boolean) 如源字符串含有空白则返回true，否则返回false
		 * */
		public static function isBlank($str:String):Boolean
		{
			switch($str)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
				default:
					return false;
			}
		}
		
		/**
		 * 指定字符串在源字符串中出现的次数
		 * @param $str 源字符串
		 * @param $target 目标字符串
		 * @return (int) 出现的次数
		 * */
		public static function strAmount($str:String, $target:String):int
		{
			return $str.split($target).length - 1;
		}
		
		/**
		 * 去掉目标字符串左侧的所有空格
		 */
		public static function trimLeft($str:String):String
		{
			var tempIndex:int = 0;
			var tempChar:String = "";
			var n:int = $str.length;
			for(var i:int = 0 ; i < n; i++)
			{
				tempChar = $str.charAt(i);
				if(tempChar != " ")
				{
					tempIndex = i;
					break;
				}
			}
			return $str.substr(tempIndex);
		}
		
		/**
		 * 去掉目标字符串右侧的所有空格
		 */
		public static function trimRight($str:String):String
		{
			var tempIndex:int = $str.length - 1;
			var tempChar:String = "";
			for(var i:int = $str.length - 1; i >= 0; i--)
			{
				tempChar = $str.charAt(i);
				if(tempChar != " ")
				{
					tempIndex = i;
					break;
				}
			}
			return $str.substring(0, tempIndex + 1);
		}
		
		/**
		 * 去掉指定字符串两边的所有空格
		 * @param $str 源字符串
		 * @return (String) 新字符串
		 * */
		public static function trimBoth($str:String):String
		{
			var r:Array = $str.split("");
			var arr:Array = [];
			var n:Number = r.length;
			var i:int = 0;
			for each(var s:String in r)
			{
				if(s == " ")
				{
					arr = r.slice(i + 1, n);
				}
				else
				{
					r = arr;
					break;
				}
				i++;
			}
			i = r.length - 1;
			for(i; i > -1; i--)
			{
				if(r[i] == " ")
				{
					arr = r.slice(0, i);
				}
				else
				{
					break;
				}
			}
			return arr.join("");
		}
		
		/**
		 * 指定字符是否在原字符串的开头
		 * @param $str 要指定的字符串
		 * @param $target 源字符串
		 * @return (Boolean) 指定字符串在开头返回true，否则返回false
		 * */
		public static function isTargetFirst($str:String, $target:String):Boolean
		{
			if($target == $str.split("")[0])
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 指定字符是否在原字符串的结尾
		 * @param $str 要指定的字符串
		 * @param $target 源字符串
		 * @return (Boolean) 指定字符串在结尾返回true，否则返回false
		 * */
		public static function isTargetEnd($str:String, $target:String):Boolean
		{
			var r:Array = $str.split("");
			if($target == r[r.length - 1])
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 是否全部都是中文字符(中文形式的标点符号也是中文、但数字和-都不算中文)
		 * @param $str 源字符串
		 * @return (Boolean) 如果源字符串全都是中文字符则返回true，否则返回false
		 * */
		public static function isChinese($str:String):Boolean
		{
			if($str != null)
			{
				//str = trim(str);    //消除两边空格 
				var re:RegExp = /^[\u0391-\uFFE5]+$/;
				var obj:Object = re.exec($str);
				if(obj != null)
				{
					return true;
				}
				else
				{
				    return false;
				}
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 是否含有中文字符(中文形式的标点符号也是中文、但数字和-都不算中文)
		 * @param $str 源字符串
		 * @return (Boolean) 如果源字符串含有中文字符则返回true，否则返回false
		 * */
		public static function hasChinese($str:String):Boolean
		{
			if($str != null)
			{
				//str = trim(str);    //消除两边空格 
				var re:RegExp = /[^\x00-\xff]/;
				var obj:Object = re.exec($str);
				if(obj != null)
				{
					return true;
				}
				else
				{
				    return false;
				}
			}
			else
			{
			    return false;
			}
		}
		
		/**
		 * 提取中中文字符组成纯中文字符串
		 * @param $str 源字符串
		 * @return (String) 提取后的纯中文字符串
		 * */
		public static function getChinese($str:String):String
		{
			var str:String = "";
			var re:RegExp = /[^\x00-\xff]/; 
			var r:Array = $str.split("");
			for each(var s:String in r)
			{
				var t:String = re.exec(s); 
				if(t != null)
				{
					str += t;
				}
			}
			return str;
		}
		
		/**
		 * 消除双换行符
		 * @param $str 源字符串
		 * @return (String) 新字符串
		 * */
		public static function enterStr(str:String):String
		{
			return str.replace(/\r\n/gm, "\n");
		}
		
		/**
		 * 是否为http形式的url地址格式
		 * @param $str 源字符串
		 * @return (Boolean) 
		 * */
		public static function isHttpUrl($str:String):Boolean
		{
			if($str != null && $str != "")
			{
				//str = trim(str);    //消除两边空格 
				$str = $str.toLowerCase();
				var re:RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\’:+!]*([^<>\"\"])*$/;
				var obj:Object = re.exec($str);
				if(obj != null)
				{
					return true;
				}
				else
				{
				    return false;
				}
			}
			else
			{
			    return false;
			}
		}
		
		/**
		 * 是否为偶数
		 * @param $n 源数字
		 * @return (Boolean) 偶数此函数返回true，奇数返回false
		 * */
		public static function isEvenNum($n:int):Boolean
		{
			if($n % 2 == 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 获取两个字符串(两者都相对于总字符串唯一)之间的字符串
		 * @param $str 源字符串
		 * @param $before 前面的指定字符串
		 * @param $after 后面的指定字符串
		 * @return (String) 之间的字符串
		 * */
		public static function getBetween($str:String, $before:String, $after:String):String
		{
			var s:String = "";
			if(($str.split($before).length - 1) == 1)
			{
				if(($str.split($after).length - 1) == 1)
				{
					s = ($str.split($before)[1]).split($after)[0];
				}
			}
			return s;
		}

		/**
		 * 获取两个单字符之间的字符串
		 * 如getBetween2("ABCABCABCABCABC", "A", 1, "C", 2);    //BCAB
		 * @param $str 源字符串
		 * @param $before 前面的指定字符串
		 * @param $beforeIndex 前面的指定字符串(如果含有相同字符的同字符间索引)
		 * @param $after 后面的指定字符串
		 * @param $afterIndex 后面的指定字符串(如果含有相同字符的同字符间索引)
		 * @return (String) 之间的字符串，如传来的参数不符合逻辑则返回""
		 * */
		public static function getBetween2($str:String, $before:String, $beforeIndex:int, $after:String, $afterIndex:int):String
		{
			var z:String = "";
			var b:int, a:int = 0;    //前字符串计数 后字符串计数
			var k:Boolean = false;
			var n:int = $str.length;
			var i:int = 0;
			var $:String = $str;
			var e:String = $before;
			var c:int = $beforeIndex;
			var f:String = $after;
			var d:int = $afterIndex;
			var s:String;
			while(i < n)
			{
				s = $.charAt(i);
				if(s == e)
				{
					if(b == c)
					{
						k = true;
					}
					b++;
				}
				if(s == f)
				{
					if(a == d)
					{
						k = false;
					}
					a++;
				}
				if(a > d)
				{
					k = false;
				}
				if(k)
				{
					z += s;
				}
				i++;
			}
			return z.replace($before, "");
		}
		
		/**
		 * 在一个字符串中删除所有指定的字符串
		 * @param $str 源字符串
		 * @param $target 指定要删除的字符串
		 * @return (String) 删除后得到的新字符串
		 * */
		public static function deleteAll($str:String, $target:String):String
		{
			return $target.replace(/^\s*|\s*$/g,"").split($str).join("");
		}
		
		/**
		 * 有多少个中文字符
		 * @param $str 源字符串
		 * @param (int) 中文字符的个数
		 * */
		public static function chineseAmount($str:String):int
		{
			var str:String = "";
			var re:RegExp = /[^\x00-\xff]/; 
			var r:Array = $str.split("");
			for each(var s:String in r)
			{
				var t:String = re.exec(s); 
				if(t != null)
				{
					str += t;
				}
			}
			return str.length;    //中文字符串
		}
		
		/**
		 * 有多少个非中文字符
		 * @param $str 源字符串
		 * @param (int) 中文字符的个数
		 * */
		public static function englishAmount($str:String):int
		{
			var str:String = "";
			var re:RegExp = /[^\x00-\xff]/; 
			var r:Array = $str.split("");
			for each(var s:String in r)
			{
				var t:String = re.exec(s); 
				if(t != null)
				{
					str += t;
				}
			}
			return $str.length - str.length;
		}
		
		/**
		 * 中文字符串转换为拼音函数
		 * @param $str 要转为拼音的中文字符串
		 * @return (String) 转换后的拼音字符串
		 * */
		public static function chinese2Py($str:String):String
		{
			return HanziToPinyin.toPinyin($str);
		}
		
		/**
		 * 纯单种闭合标识符分割字符串(非嵌套关系)  <br/>
		 * 字符串(a)(b)(c) --> 数组对象[a, b, c]  <br/>
		 * 调用方式：bihe0Arr("(a)(b)(c)", "(", ")", false);  <br/>
		 * @param $str 源字符串
		 * @param start 指定开始字符
		 * @param end 指定末尾字符
		 * @param tag 是否带着原标识符,true表示带(如[(a), (b), (c)])，false表示不带(如[a, b, c])
		 * @return (Array) 返回标准数组对象
		 * */
		public static function bihe0Arr($str:String, $start:String, $end:String, $tag:Boolean):Array
		{
			var arr:Array = [];
			var r:Array = $str.split($end);
			var n:int = r.length;
			var i:int = 0;
			if($tag)
			{
				while(i < n - 1)
				{
					arr[i] = $start + r[i].replace($start, "") + $end;
					i++;
				}
			}
			else
			{
				while(i < n - 1)
				{
					arr[i] = r[i].replace($start, "");
					i++;
				}
			}
			return arr;
		}
		
		/**
		 * 复杂单种闭合标识符分割字符串(非嵌套关系)(方法1)  <br/>
		 * 字符串abc(def)gh(hi) --> 数组对象[def, hi]  <br/>
		 * 调用方式：bihe2Arr("abc(def)gh(hi)", "(", ")", false);  <br/>
		 * @param $str 源字符串
		 * @param start 指定开始字符
		 * @param end 指定末尾字符
		 * @return (Array) 返回标准数组对象
		 * */
		public static function bihe2Arr($str:String, $start:String, $end:String, $tag:Boolean):Array
		{
			var arr:Array = [];
			var temp:String = $str;
			var r:Array = $str.split($end);
			var n:int = r.length;
			var i:int = 0;
			while(i < n - 1)
			{
				var a3:Array = r[i].split($start);
				var s3:String = $start + a3[a3.length - 1] + $end;
				var r3:Array = temp.split(s3);
				var t3:String = r3[0];
				if(t3 != "")
				{
					arr.push(t3);
				}
				arr.push(s3);
				temp = temp.replace(t3 + s3, "");
				i++;
			}
			var se:String = r[n - 1];
			if(se != "")
			{
				arr.push(se);
			}
			if(!$tag)
			{
				var j:int = 0;
				for each(var str:String in arr)
				{
					str = str.replace(new RegExp($start, "g"), "");
					str = str.replace(new RegExp($end, "g"), "");
					arr[j] = str;
					j++;
				}
			}
			return arr;
		}
		
		/**
		 * 复杂单种闭合标识符分割字符串(非嵌套关系)(方法2)  <br/>
		 * 字符串abc(def)gh(hi) --> 数组对象[def, hi]  <br/>
		 * 调用方式：bihe3Arr("abc(def)gh(hi)", "(", ")", false);  <br/>
		 * @param $str 源字符串
		 * @param start 指定开始字符
		 * @param end 指定末尾字符
		 * @param tag 是否带着原标识符,true表示带(如[(def), (hi)])，false表示不带(如[def, hi])
		 * @return 返回标准数组对象
		 * */
		public static function bihe3Arr($str:String, $start:String, $end:String, $tag:Boolean):Array
		{
			var arr:Array = [];
			var r:Array = $str.split($end);
			var n:int = r.length;
			var i:int = 0;
			if($tag)
			{
				while(i < n - 1)
				{
					var r2:Array = r[i].split($start);
					arr[i] = $start + r2[r2.length - 1] + $end;
					i++;
				}
			}
			else
			{
				while(i < n - 1)
				{
					var r3:Array = r[i].split($start);
					arr[i] = r3[r3.length - 1];
					i++;
				}
			}
			return arr;
		}
		
		/**
		 * 复杂多种闭合标识符分割字符串(非嵌套关系)(方法1)  <br/>
		 * 字符串a*bc.e<fg>{hij}tp<kmn>  -->  数组对象[a*bc.e,<fg>,{hij},tp,<kmn>]  <br/>
		 * 调用方式：bihe4Arr("a*bc.e<fg>{hij}tp<kmn>", {r1:['<', '>'], r2:['{', '}']}, true);  <br/>
		 * @param $str 源字符串
		 * @param $obj 闭合部分的标识符
		 * @param $tag true  a*bc.e,<fg>,{hij},tp,<kmn>， false a*bc.e,fg,hij,tp,kmn
		 * */
		public static function bihe4Arr($str:String, $obj:Object, $tag:Boolean):Array
		{
			var arr:Array = [];
			var arr2:Array = [];    //提取出来的闭合字符串
			var n:int = $str.length;
			var i:int = 0;
			var j:int = 1;
			var leftn:int = 0;
			var rightn:int = 0;
			/*提取arr2*/
			while(i < n)
			{
				var s:String = $str.charAt(i);
				for each(var r:Array in $obj)
				{
					if(s == r[0] || s == r[1])
					{
						if(j % 2 == 0)
						{
							rightn = i;
							arr2.push($str.substring(leftn, rightn + 1));
						}
						else
						{
							leftn = i;
						}
						j++;
					}
				}
				i++;
			}
			var temp:String = $str;
			for each(var s3:String in arr2)
			{
				var s4:String = temp.split(s3)[0];
				if(s4 != "")
				{
					arr.push(s4);
				}
				arr.push(s3);
				temp = temp.replace(s4 + s3, "");
			}
			if(temp != "")
			{
				arr.push(temp);
			}
			if(!$tag)
			{
				var k:int = 0;
				for each(var s5:String in arr)
				{
					for each(var r2:Array in $obj)
					{
						s5 = s5.replace(new RegExp(r2[0], "g"), "");
						s5 = s5.replace(new RegExp(r2[1], "g"), "");
					}
					arr[k] = s5;
					k++;
				}
			}
			return arr;
		}
		
		/**
		 * 复杂多种闭合标识符分割字符串(非嵌套关系)(方法2)  <br/>
		 * 字符串a*bc.e<fg>{hij}tp<kmn>  -->  数组对象[a*bc.e,<fg>,{hij},tp,<kmn>]  <br/>
		 * 调用方式：bihe5Arr("a*bc.e<fg>{hij}<kmn>", {r2:['{', '}']}, false);  <br/>
		 * @param $str 源字符串
		 * @param $obj 闭合部分的标识符
		 * @param $tag 是否显示原分割标识符
		 * */
		public static function bihe5Arr($str:String, $obj:Object, $tag:Boolean):Array
		{
			var arr:Array = [];
			var n:int = $str.length;
			var i:int = 0;
			var j:int = 1;
			var leftn:int = 0;
			var rightn:int = 0;
			if($tag)
			{
				while(i < n)
				{
					var s:String = $str.charAt(i);
					for each(var r:Array in $obj)
					{
						if(s == r[0] || s == r[1])
						{
							if(j % 2 == 0)
							{
								rightn = i;
								arr.push($str.substring(leftn, rightn + 1));
							}
							else
							{
								leftn = i;
							}
							j++;
						}
					}
					i++;
				}
			}
			else
			{
				while(i < n)
				{
					var t:String = $str.charAt(i);
					for each(var a:Array in $obj)
					{
						if(t == a[0] || t == a[1])
						{
							if(j % 2 == 0)
							{
								rightn = i;
								arr.push($str.substring(leftn + 1, rightn));
							}
							else
							{
								leftn = i;
							}
							j++;
						}
					}
					i++;
				}
			}
			return arr;
		}
		
		/**
		 * 生成全球唯一随机GUID字符串
		 * @return (String) 获得全球唯一随机GUID字符串
		 * */
		public static function getGUID():String
		{
			return GUID.getGUID();
		}

		/**
		 * 替换指定序列的字符串
		 * @param $index 指定要替换的字符串的序号
		 * @param $str 源字符串
		 * @param $old 要被替换的字符串
		 * @param $new 要替换的新字符串
		 * */
		public static function replaceAt($index:int, $str:String, $old:String, $new:String):String
		{
			if($str.indexOf($old) != -1)
			{
				var str:String = "";
				var arr:Array = $str.split($old);
				var n:int = arr.length;    //($index(max) = n - 1)
				if($index < n - 1)
				{
					var i:int = 0;
					var s:String;
					for each(s in arr)
					{
						if(i != $index)
						{
							if(i != n - 1)    //不是最后一项
							{
								str += s + $old;
							}
							else
							{
								if(s != "")    //老字符串是否在最后
								{
									str += s;
								}
							}
						}
						else
						{
							str += s + $new;
						}
						i++;
					}
					return str;
				}
				else
				{
					return $str;
				}
			}
			else
			{
				return $str;
			}
		}
		
	}
}