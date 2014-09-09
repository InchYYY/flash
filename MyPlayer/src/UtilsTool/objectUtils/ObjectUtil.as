package  UtilsTool.objectUtils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * as3对象操作工具类集合
	 * @author xuechong  <br/>
	 * version v20121029.0.1  <br/>
	 * date 2012.10.29  <br/>
	 * QQ群 238680860  <br/>
	 * <br/>
	 * getChildrenArr     获取可视对象的所有孩子集合
	 * getDeth            获取可视对象相对于父容器的层次索引
	 * removeAllChildren  移除目标可视容器对象中所有的子对象
	 * deepObjectToString amf数据输出格式化
	 * baseClone          深度克隆对象
	 * isString           是否为字符串类型
	 * isNumber           是否为数值型类型
	 * isBoolean          是否为Boolean类型
	 * isFunction         是否为函数类型
	 */	
	public class ObjectUtil
	{
		public function ObjectUtil()
		{
			
		}
		
		/**
		 * 获取可视对象的所有孩子集合
		 * @param container 目标可视对象
		 * @return 可视对象的所有孩子集合
		 */		
		public static function getChildrenArr(container:DisplayObjectContainer):Array
		{
			var result:Array = new Array();
			for(var i:int = 0; i < container.numChildren; i++)
			{
				result.push(container.getChildAt(i));
			}
			return result;
		}
		
		/**
		 * 获取可视对象相对于父容器的层次索引
		 * @param dis 目标可视对象
		 * */
		public static function getDeth(dis:DisplayObject):int
		{
			if(dis.parent)
			{
				return dis.parent.getChildIndex(dis);
			}
			else
			{
			    return -1;
			}
		}
		
		/**
		 * 移除目标可视容器对象中所有的子对象
		 * @param container 目标可视容器对象 
		 * @param recursion 是否递归，移除子孙最底层所有子对象，默认为false
		 * @return void 
		 */		
		public static function removeAllChildren(container:DisplayObjectContainer, recursion:Boolean=false):void
		{
			if(container)
			{
				while(container.numChildren > 0)
				{
					var p:DisplayObjectContainer = container.removeChildAt(0) as DisplayObjectContainer;
					if(recursion && p)
					{
						removeAllChildren(p);
					}
				}
			}
		}
		
		/**
		 * amf数据输出格式化
		 * @return
		 */
		static public function deepObjectToString(obj:*, level:int = 0, output:String = ""):*
		{
			var tabs:String = "";
			for(var i:int = 0; i < level; i++)
			{
				tabs += "\t";
			}
			for(var child:* in obj)
			{
				output += tabs + "["+ child + "] => " + obj[child];
				var childOutput:String = deepObjectToString(obj[child], level + 1);
				if(childOutput != "")
				{
					output += " {\n"+ childOutput + tabs + "}";
				}
				output += "\n";
			}
			if(level > 20)
			{
				return "";
			}
			return output;  
		}
		
		/**
		 * 深度克隆对象
		 */
		public static function baseClone(source:*):*
		{
			var typeName:String = getQualifiedClassName(source);
			var packageName:String = typeName.split("::")[1];
			var cls:Class = Class(getDefinitionByName(typeName));
			registerClassAlias(packageName, cls);
			var ba:ByteArray = new ByteArray();
			ba.writeObject(source);
			ba.position = 0;
			return ba.readObject();
		}
		
		/**
		 * 是否为字符串类型
		 */
		public static function isString(value:*):Boolean
		{
			return (typeof(value) == "string" || value is String);
		}
		
		/**
		 * 是否为数值型类型
		 */
		public static function isNumber(value:*):Boolean
		{
			return (typeof(value) == "number" || value is Number);
		}
		
		/**
		 * 是否为Boolean类型
		 */
		public static function isBoolean(value:*):Boolean
		{
			return (typeof(value) == "boolean" || value is Boolean);
		}
		
		/**
		 * 是否为函数类型
		 */
		public static function isFunction(value:*):Boolean
		{
			return (typeof(value) == "function" || value is Function);
		}
		
	}
}