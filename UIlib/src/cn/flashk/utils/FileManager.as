package cn.flashk.utils
{
	import flash.filesystem.File;

	public class FileManager
	{
		private static var _applicationDirectory:File;
		private static var _applicationDirectoryURL:String;

		public static function get applicationDirectoryURL():String
		{
			if(_applicationDirectoryURL == null){
				_applicationDirectoryURL = applicationDirectory.url;
			}
			return _applicationDirectoryURL;
		}

		public static function get applicationDirectory():File
		{
			if(_applicationDirectory == null) _applicationDirectory = File.applicationDirectory;
			return _applicationDirectory;
		}
		
		public static function getAppFile(path:String):File
		{
			if(_applicationDirectoryURL == null){
				_applicationDirectoryURL = applicationDirectory.url;
			}
//			trace("getAppFile:",_applicationDirectoryURL+path);
			return new File(_applicationDirectoryURL+path);
		}

	}
}