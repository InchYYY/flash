package
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import spark.components.Group;
	

	public class EncodeToMp4
	{
		private var _player: Group;
		private var _mv: MovieClip;
		private var _startFrame: int;
		private var _currentFrame: int = 0;
		private var _totalFrames: int;
		private var _SimulateTimeLine:Boolean;
		private var _videoW: int;
		private var _videoH: int;
		private var _times: int = 50;
		private var _exit: Boolean = false;
		private var encodeProc: NativeProcess;
		private var _saveImagDoing: Boolean = false;
		private var _lastFrame: int = 0;
		private var encodeTempPath: String = "d:\\Temp\\";
		private var fileFtp: String = "";
		private var hostUrl: String = "";
		private var dubUrl: String = "";
		private var userMovieID: int = 3;
		
		public function EncodeToMp4(mv: MovieClip, videoW:int = 0, videoH:int = 0, startFrame:int = 0, totalFrames:int = 0, SimulateTimeLine:Boolean = false)
		{
			_mv = mv;
			
			if(videoW == 0) _videoW = mv.width;
				else _videoW = videoW;
			
			if(videoH == 0)_videoH = mv.height;
				else _videoH = videoH;
			
			if(totalFrames == 0) totalFrames = mv.totalFrames;
				else _totalFrames = totalFrames;
			
			_startFrame = startFrame;
			
			_SimulateTimeLine = SimulateTimeLine;//如果当前
			
			encodeMovie();
		}
		
		private function encodeMovie(): void
		{
			_mv.addEventListener(Event.EXIT_FRAME, onExitFrame);
			getDub();
		}

		private function onExitFrame(e: Event): void
		{
			if(_exit)return;
			
			var currentFrame:int = _SimulateTimeLine?_currentFrame:_mv.currentFrame;
			if(currentFrame < _startFrame){
				if(_SimulateTimeLine)_currentFrame++;
				return;
			}
			
			_saveImagDoing = true;
			var fn: String = saveImage(currentFrame - _startFrame);
			execute("app:/ImageJpeg.exe", function (a: Vector.<String>): void { a.push(fn); });
			if (currentFrame < _totalFrames) {
				_mv.play();
			} else {
				_mv.stop();
				encode();
				_exit = true;
			}
			_saveImagDoing = false;
			
			if(_SimulateTimeLine)_currentFrame++;
		}
		
		private function getDub(): void
		{
			if (dubUrl == "") {
				return;
			}
			var pth: String = encodeTempPath + userMovieID + "\\";
			var fn: String = pth + "dub.bat";
			var cmd: String = "\"" + File.applicationDirectory.nativePath + "\\wget\" -c " + dubUrl + " -O \"" + pth + "\\dub.mp3\"";
			saveFileS(fn, cmd);
			bat(fn);
		}
		
		private function saveImage(frameid: int): String
		{
			var bd : BitmapData = new BitmapData(_videoW, _videoH, true, 0);
			bd.draw(_mv);
			var data: ByteArray = bd.getPixels(bd.rect);
			var fn: String = encodeTempPath + userMovieID + "\\" + frameid + "-" + _videoW + "-" + _videoH + ".bin";
			saveFileB(fn, data);
			return fn;
		}
		
		private function encode(): void
		{
			var pth: String = encodeTempPath + userMovieID;
			var dubPrm: String = dubUrl == "" ? "" : " -i " + encodeTempPath + userMovieID + "\\dub.mp3";
			var isSquare: Boolean = _videoW == _videoH;
			var ffmpeg0: String = " -vcodec libx264 -b:v " + (isSquare ? 1024000 : 2500000) + " -b:a 128000";
			var ffmpeg1: String = " -vcodec libx264 -b:v " + (isSquare ? 634000 : 1024000) + " -b:a 128000";
			var ffmpeg2: String = " -vcodec libx264 -b:v " + (isSquare ? 256000 : 256000) + " -b:a 128000";
			var size0: String = " -s " + _videoW + "x" + _videoH;
			var size1: String = " -s " + (isSquare ? 480 : 640) + "x" + (isSquare ? 480 : 360);
			var size2: String = " -s " + (isSquare ? 240 : 320) + "x" + (isSquare ? 240 : 180);
			var ftime: String = " -t " + (200 - 1) / 25 + " ";
			var cmd0: String = "\"" + File.applicationDirectory.nativePath + "\\ffmpeg.exe\" -y -i " + pth + "\\%%d.jpg" + dubPrm + ffmpeg0 + size0 + ftime + pth + "_0.mp4\r\n";
			var cmd1: String = "\"" + File.applicationDirectory.nativePath + "\\ffmpeg.exe\" -y -i " + pth + "\\%%d.jpg" + dubPrm + ffmpeg1 + size1 + ftime + pth + "_1.mp4\r\n";
			var cmd2: String = "\"" + File.applicationDirectory.nativePath + "\\ffmpeg.exe\" -y -i " + pth + "\\%%d.jpg" + dubPrm + ffmpeg2 + size2 + ftime + pth + "_2.mp4\r\n";
			cmd2 += "\"" + File.applicationDirectory.nativePath + "\\wput.exe\" -u " + fileFtp + userMovieID + "_0.mp4 " + pth + "_0.mp4\r\n";
			cmd2 += "\"" + File.applicationDirectory.nativePath + "\\wput.exe\" -u " + fileFtp + userMovieID + "_1.mp4 " + pth + "_1.mp4\r\n";
			cmd2 += "\"" + File.applicationDirectory.nativePath + "\\wput.exe\" -u " + fileFtp + userMovieID + "_2.mp4 " + pth + "_2.mp4\r\n";
			cmd2 += "\"" + File.applicationDirectory.nativePath + "\\wget.exe\" -c " + hostUrl + "/App/EndDownLoadTask/" + userMovieID + " -O \"" + pth + "\\msg.txt\"\r\n";
			//cmd2 += "del " + pth + "_0.mp4\r\n";
			//cmd2 += "del " + pth + "_1.mp4\r\n";
			//cmd2 += "del " + pth + "_2.mp4\r\n";
			cmd2 += "rd " + pth + " /q/s\r\n";
			var sbat0: String = pth + "\\encode.bat";
			var sbat1: String = pth + "\\encode1.bat";
			var sbat2: String = pth + "\\encode2.bat";
			saveFileS(sbat0, cmd0 + cmd1 + cmd2);
			encodeProc = bat(sbat0);
		}
		
		private function saveFileS(fnm: String, content: String): void
		{
			saveFile(fnm, function (f: FileStream): void { f.writeMultiByte(content, "utf-8"); });
		}
		
		private function saveFileB(fnm: String, d: ByteArray): void
		{
			saveFile(fnm, function (f: FileStream): void { f.writeBytes(d, 0, d.length); });
		}
		
		private function saveFile(fnm: String, fn: Function): void
		{
			var file: File = File.applicationStorageDirectory.resolvePath(fnm);
			var fileStream: FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fn(fileStream);
			fileStream.close();
		}
		
		private function bat(fnm: String): NativeProcess
		{
			return execute("app:/command.exe", function (a: Vector.<String>): void {
				a.push("/c");
				a.push(fnm);
			});
		}
		
		private function execute(fnm: String, fn: Function = null): NativeProcess
		{
			var file: File = new File().resolvePath(fnm);
			var nativeProcessStartupInfo: NativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = file;
			var args: Vector.<String> = new Vector.<String>();
			if (fn != null) {
				fn(args);
			}
			nativeProcessStartupInfo.arguments = args;
			var process: NativeProcess = new NativeProcess();
			process.start(nativeProcessStartupInfo);
			return process;
		}

		public function trim(char: String): String
		{
			if (char == null) return null;
			return rtrim(ltrim(char));
		}
		
		private function ltrim(char: String): String
		{
			if (char == null) return null;
			var pattern : RegExp = /^\s*/;
			return char.replace(pattern, "");
		}
		
		private function rtrim(char: String): String
		{
			if (char == null) return null;
			var pattern : RegExp = /\s*$/;
			return char.replace(pattern, "");
		}		
	}
}
