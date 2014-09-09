package nl.themotionstudio.utils 
{
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Wouter Tengeler
	 */
	public class ObjectCloner
	{
		
		public function ObjectCloner() 
		{
			
		}
		
		/**
		 * method to clone a display object
		 * @param DisplayObject p_oObject
		 * @return DisplayObject
		 */
		public static function cloneDisplayObject(p_oObject:DisplayObject):DisplayObject {
			var oObject:* = null;
			try {
				var className:String = getQualifiedClassName( p_oObject );
				var objectClass:Class = getDefinitionByName( className ) as Class;
				oObject = new objectClass();
				trace('ObjectCloner::cloneDisplayObject - clone ' + getQualifiedClassName(oObject));
				
			} catch (e:Error) {
				trace('ObjectCloner::cloneDisplayObject - clone failed');
			}
			return oObject;
		}
		
	}

}