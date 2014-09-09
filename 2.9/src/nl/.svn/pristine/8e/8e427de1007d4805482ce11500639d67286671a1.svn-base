package nl.themotionstudio.utils
{
	import flash.utils.getQualifiedClassName;
	
	import nl.themotionstudio.utils.*;
	
	public class Debug
	{
		protected static var aDebugClasses:Array = new Array();
		protected static var bDebugOn:Boolean = false;
		protected static var oOutput:DebugWindow = null;
		
		public static function setDebug(p_bDebug:Boolean):void
		{
			Debug.bDebugOn = p_bDebug;
		}
		
		public static function setOutput(p_oOutput:DebugWindow):void {
			Debug.oOutput = p_oOutput;
		}
		
		public static function addClass(p_sClass:String):void {
			if (Debug.aDebugClasses.indexOf(p_sClass) < 0) {
				Debug.aDebugClasses.push(p_sClass);
			}
			
		}
		
		public static function removeClass(p_sClass:String):void {
			var iIndex:int = Debug.aDebugClasses.indexOf(p_sClass);
			if ( iIndex >= 0) {
				Debug.aDebugClasses.splice(iIndex, 1);
			}
		}
		
		
		public static function traceObject(p_oObject:Object, p_sPrefix:String):void {
			if (bDebugOn) {
				trace(p_sPrefix + ' - ' + objectToString(p_oObject));
			}
		}
		
		public static function traceInfo(p_sClass:String, p_sMethod:String, p_sMessage:* = null, p_vVar:* = null):void {
			var bTrace:Boolean = false;
			if ((bDebugOn) && (Debug.aDebugClasses.indexOf(p_sClass) >= 0)) {
				bTrace = true;
			}
			
			if (bTrace) {
				var sMessage:String = p_sClass + '::' + p_sMethod;
				if ((null != p_sMessage) && (null != p_vVar)) {
					sMessage += varToString(' ' + p_sMessage, p_vVar);
				} else if((null != p_sMessage)) {
					sMessage += varToString(' ', p_sMessage);
				}
				trace(sMessage);
				if (null != Debug.oOutput) {
					// also use a debug window to send messages to
					Debug.oOutput.showMessage(sMessage);
				}
			}
		}
		
		public static function objectToString(p_oObject:Object, p_iLevel:uint = 0):String
		{
			var sResult:String = '';
			for (var sProperty:String in p_oObject) {
				sResult += Debug.indent(p_iLevel) + varToString(sProperty, p_oObject[sProperty], p_iLevel+1) + '\n';
			}
			return sResult;
		}

		public static function arrayToString(p_aArray:Array, p_iLevel:uint = 0):String
		{
			var sResult:String = '';
			var i:uint = 0;
			for each (var vVar:* in p_aArray) {
				sResult += Debug.indent(p_iLevel) + varToString('[' + i + ']', vVar, p_iLevel + 1) + '\n';
				i++;
			}
			return sResult;
		}
		
		private static function varToString(p_sName:String, p_vVar:* = null, p_iLevel:uint = 0):String
		{
			var sMessage : String = p_sName;
			// generate tabs
			if (null != p_vVar) {
				var sClass:String = getQualifiedClassName(p_vVar);
				switch (sClass) {
					case 'Object' : 
						sMessage += ' = ' + sClass + ':\n' + Debug.objectToString(p_vVar, p_iLevel + 1);
					break;
					case 'Array' : 
						sMessage += ' = ' + sClass + ':\n' + Debug.arrayToString(p_vVar, p_iLevel + 1);
					break;
					case 'String' :
						sMessage += ' = "' + p_vVar + '"';
					break;
					default : 
						sMessage += ' = ' + sClass + ': ' + p_vVar;
					break;
				}
				/*
				if (p_vVar is Object) {
					if (p_vVar is Array) {
						// try to print all elements
						sMessage += ' (Array): \n' + Debug.arrayToString(p_vVar, p_iLevel);
					} else if (p_vVar is String) {
						sMessage += ' (String): ' + p_vVar;
					} else if (p_vVar is Boolean) {
						sMessage += ' (Boolean): ' + p_vVar;
					} else if (p_vVar is Number) {
						sMessage += ' (Number): ' + p_vVar;
					} else {
						// try to print all properties
						sMessage += ' object: \n' + Debug.objectToString(p_vVar, p_iLevel);
					}
				} else {
					sMessage += ' - ' + p_vVar;
				}
				*/
			} else {
				sMessage += '';
			}
			return sMessage;
		}
		
		private static function indent(p_iLevel:uint):String
		{
			var sMessage:String = '';
			for (var i:uint = 0; i < p_iLevel; i++) {
				sMessage += '\t';
			}
			return sMessage;	
		}
		
	}
}