///////////////////////////////////////////////////////////
//  OverlayImageLoader.as
//  Macromedia ActionScript Implementation of the Class OverlayImageLoader
//  Generated by Enterprise Architect
//  Created on:      18-okt-2010 13:03:59
//  Original author: Wouter Tengeler
///////////////////////////////////////////////////////////

package nl.funnymessages.overlay
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import nl.themotionstudio.events.CustomEvent;
	
	import nl.themotionstudio.utils.Debug;
	/**
	 * @author Wouter Tengeler
	 * @version 1.0
	 * @created 18-okt-2010 13:03:59
	 */
	public class OverlayImageLoader extends Loader
	{
		public static const LOAD_OK:String = 'loadOk';
		public static const LOAD_FAILED:String = 'loadFailed';
		public static const STATUS_INIT:int = 1;
		public static const STATUS_LOADING:int = 2;
		public static const STATUS_LOADED:int = 3;
		public static const STATUS_ERROR:int = 9;
		
		private var m_oInfo:Object;
		private var m_oImage:DisplayObject;
		private var m_iStatus:int;
	    /**
		 * 
		 * @param Object p_oInfo The information of the overlay to load
		 */
	    public function OverlayImageLoader(p_oInfo:Object): void
	    {
			Debug.addClass('OverlayImageLoader');
			Debug.traceInfo('OverlayImageLoader', 'constructor');
			super();
			m_oInfo = new Object();
			// clone the given info object
			for (var sProperty:String in p_oInfo) {
				m_oInfo[sProperty] = p_oInfo[sProperty];
			}
			m_oInfo.overlayObject = null;
			m_oImage = null;
			m_iStatus = STATUS_INIT;
	    }
		
		/**
		 * add own event handlers 
		 * @param	request
		 * @param	context
		 */
		override public function load(request:URLRequest, context:LoaderContext = null):void {
			contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			m_iStatus = STATUS_LOADING;
			super.load(request);
		}
		
		/**
		 * get the loaded image
		 */
		public function get image():DisplayObject {
			return m_oImage;
		}
		
		/**
		 * get the overlay information for the loaded image
		 */
		public function get info():Object {
			return m_oInfo;
		}
		
		public function get status():int {
			return m_iStatus;
		}
		
		private function onComplete(p_oEvent:Event):void {
			Debug.traceInfo('OverlayImageLoader', 'onComplete', 'key', m_oInfo.key);
			contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			// get the loaded image
			m_oImage = contentLoaderInfo.content;
			m_iStatus = STATUS_LOADED;
			dispatchEvent(new CustomEvent(LOAD_OK));
		}
		
		private function onIOError(p_oEvent:IOErrorEvent):void {
			Debug.traceInfo('OverlayImageLoader', 'onIOError', 'error', p_oEvent.text);
			contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			handleError(p_oEvent.text);
		}
		
		private function onProgress(p_oEvent:ProgressEvent):void {
			//Debug.traceInfo('OverlayImageLoader', 'onProgress', 'progress', Math.floor((p_oEvent.bytesLoaded / p_oEvent.bytesTotal) * 100));
		}

		/**
		 * handle errors
		 * default, an event is sent containg the error
		 */
		protected function handleError(p_sMessage:String):void {
			m_iStatus = STATUS_ERROR;
			var oData:Object = new Object();
			oData.message = p_sMessage;
			dispatchEvent(new CustomEvent(LOAD_FAILED,false, false, oData));
		}

	}
}