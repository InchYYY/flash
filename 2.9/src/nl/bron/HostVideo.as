﻿package nl.bron
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import nl.funnymessages.clipcontainer.ClipContainer;
	import nl.util.Net;
	import nl.util.Str;
	import nl.util.json.JSON;

	/**
	 * 保存对模版(可编辑视频模版)的描述
	 */
	public class HostVideo
	{
		public var hostUrl: String;	// 主机url，如： "http://localhost:81/"
		public var mvPath: String;		// 视频文件路径，如： "Upload/System/Movie/Movies/3.swf"
		public var userID: int;
		public var movieID: int;
		public var frameID: int;
		public var userMovieID: int;
		public var dubUrl: String;// = "http://cn.fans-me.com/Upload/System/Movie/Audio/20131204104942_Q5tBvU.mp3";
		public var coverImage: String;
		public var userMovieName: String;
		public var userDub: Object = {};
		
		public var userMovieIdEb64: int;		// （旧视频用）
		public var playUrl: String;				// （旧视频用）
		public var backUrl: String;				// （旧视频用）
		public var heads_old: String;			// （旧视频用）

		public var brVer: Number  = 1.0;		// 版本号
		public var brType: String = "";			// 类型
		public var brMode: String = "";			// 模式
		/**
		 * 设计宽度
		 */
		public var brDsgnWidth: int = 640;	
		public var brDsgnHeight: int = 360;		// 设计高度
		public var brPlayWidth: int = 640;		// 播放宽度
		public var brPlayHeight: int = 360;		// 播放高度
		public var brDocWidth: int = 640;		// 文档宽度（开始状态时舞台宽度）
		public var brDocHeight: int = 360;		// 文档高度

		private var _general: Object;
		private var _parmText: Array;
		private var _parmPict: Array;
		private var _parmHead: Array;
		private var _parmMov:Array;
		private var _isInited: Boolean;
		private var _mainClip: MovieClip = null;	// 主视频剪辑（容器）

		public function get mainClip(): MovieClip { return _mainClip; }
		public function get clip_old(): ClipContainer { return _mainClip as ClipContainer; }
		public function get container(): brContainer { return _mainClip as brContainer; }
		public function get frameCount(): int { return (_mainClip == null) ? 0 : _mainClip.totalFrames; }
		public function get currentFrame(): int { return (_mainClip == null) ? 0 : _mainClip.currentFrame; }
		public function get general(): Object { return _general; }
		public function get isOld(): Boolean { return clip_old != null; }
		
		public function HostVideo()
		{
		}
		
		public function init(p: Object, host: String) : void
		{
			hostUrl = host;			// url: http://localhost:81/
			mvPath = p.mv;			// mv: Upload/System/Movie/Movies/3.swf
			userID = p.userID;
			movieID = p.movieID;
			frameID = p.frameID;
			userMovieID = p.userMovieID;
			userMovieIdEb64 = p.userMovieIdEb64;
			backUrl = p.backUrl;
			heads_old = p.heads;	// heads: 我的头像;Upload/User/2/634929955545257935.png;[[112,294,112,329],[201,294,155,294],[201,352,201,329],[112,352,157,368]]|;Upload/System/Movie/Heads/h1.png;|;Upload/System/Movie/Heads/h2.png;|;Upload/System/Movie/Heads/h3.png;|;Upload/System/Movie/Heads/h4.png;
			playUrl = host + p.playUrl;
			dubUrl = p.dub?(host + p.dub):"";
			coverImage = p.coverImage;
			userMovieName = p.userMovieName;
			_general = p.general?p.general:{};
			
			if(p.userDub && p.userDub.Path){ 
				if(p.userDub.Path.search("/null") != -1){
					userDub.Path = {};
				}else{
					userDub.Path = p.userDub.Path;
				}
			}else{
				userDub = {};
			}
			

			_parmText = p.textCells as Array;
			_parmPict = p.pictCells as Array;
			_parmHead = p.headCells as Array;
			_parmMov = p.movCells as Array;
		}

		public function parse(mc: MovieClip): Boolean
		{
			if (!mc) return false;

			// 读新版本视频
			if (mc["getBronInfo"])
			{
				var bi: Object = mc.getBronInfo();
				if (bi) {
					brVer = Str.toNumber(bi.ver);
					brType = bi.type;
					brMode = bi.mode;
					brDsgnWidth  = bi.d_W;
					brDsgnHeight = bi.d_H;
					brPlayWidth  = bi.p_W;
					brPlayHeight = bi.p_H;
					brDocWidth   = bi.f_W;
					brDocHeight  = bi.f_H;
					_mainClip = bi.mc;
				}
				return (container != null);
			}

			// 读旧版本及换头视频文件
			if (mc["ver"]) brVer = Str.toNumber(mc.ver);
			if (mc["getClipContainer"]) _mainClip = mc.getClipContainer();
			if (!_mainClip) return false;

			if (brVer > 1) {
				if (_mainClip.x != 0 || _mainClip.y != 0) {
					brMode = "淘宝6秒主图视频";
					brDsgnWidth  = 310;
					brDsgnHeight = 310;
					brPlayWidth  = 310;
					brPlayHeight = 310;
					brDocWidth   = 640;
					brDocHeight  = 360;
				} else {
					brMode = "默认DIY视频";
				}
			}

			return true;
		}
		
		public function parseSites(mc: MovieClip): Boolean
		{
			if (!mc || !container) {
				throw new Error("MovieClip container is null");
			}
			
			var ok: Boolean = false;
			var func: * = mc["getParam"];
			if (typeof(func) == "function") {
				var p: Object = func();
				if (p) {
					var sites: Array = p["sites"] as Array;
					if (sites) {
						HostSite.createAllSites(container, sites);
						ok = true;
					}
					var shared: Array = p["shared"] as Array;
					if (shared) {
						HostSite.setupSharedCells(container, shared);
					}
				}
			}
			return ok;
		}

		/**
		 * 应用（替换）用户参数（用户替换图片，改变文字，变换位置、尺寸等）<br>
		 * <b>注意</b>：必须调用一次本函数才会显示 cell 资源（文字、图片）
		 */
		public function applyParam(): void
		{
			if (!container) {
				throw new Error("MovieClip container is null");
			}

			container.forEachCell(function (cell: HostCell): void {
				if (cell) {
					var arr: Array = null;
					var parm: Object = null;
					switch (cell.type) {
						case HostCell.TYPE_TEXT: arr = _parmText;  break;
						case HostCell.TYPE_PICT: arr = _parmPict;  break;
						case HostCell.TYPE_HEAD: arr = _parmHead;  break;
						case HostCell.TYPE_MOV:  arr = _parmMov; break;
					}
					for each (var p: Object in arr) {
						if (p && p.ID == cell.ID) { parm = p;  break; }
					}
					cell.updateParam(parm);
				}
			});
		}

		public function applyOld(mv: ClipContainer): void
		{
			for each (var p: Object in _parmHead)
			{
				Net.getBitmap(hostUrl + p.url, function (b: Bitmap): void {
					mv.setHead(p.ID, b, nl.util.json.JSON.decode(p.mouth));
				});
			}
		}
	}
}
