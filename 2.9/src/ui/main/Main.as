package ui.main
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.utils.getQualifiedClassName;

	import mx.controls.Alert;
	import mx.utils.StringUtil;

	import nl.bron.Filters;
	import nl.bron.HostVideo;
	import nl.bron.brSndCell;
	import nl.comm.JPGEncoder;
	import nl.comm.changeHeadFx;
	import nl.util.Net;

	import nt.components.MovieCtrl;
	import nt.components.VoiceCtrl;

	import ui.guider.Guider;

	public class Main extends changeHeadFx
	{
		public static var playerW:int=640;
		public static var playerH:int=360;

		private var uploading:Boolean=false;
		private var mvCfg:HostVideo=new HostVideo();
		private var snd:brSndCell=new brSndCell();
		private var skn:MainSkin;
		private var app:FxPlayer;
		private var mv2:MovieClip;
		private var mvCtrl:MovieCtrl;
		private var loading:BrLoading;
		private var updataClick:Boolean=false;
		private var voiceCtrl:VoiceCtrl;
		private var guider:Guider=null;

		public function Main()
		{
			trace("class", getQualifiedClassName(this));
			super();
			this.width=playerW;
			this.height=playerH;
			setStyle("skinClass", MainSkin);
		}

		public function setApp(a:FxPlayer):void
		{
			app=a;
		}

		override public function getPrmUrl():String
		{
			return "Main/App/GetCell/";
		}

		override public function loadMv(r:Object=null):void
		{
			var s:String;
			var p:Array;
			if (r == null)
			{
				trace("System Error!");
				return;
			}
			mvCfg.init(r, sUrl);
			if (mvCfg.heads_old != "")
			{
				var i:int=1;
				for each (s in r.heads.split("|"))
				{
					p=(s.split(";"));
					var u:String=trim(p[1]);
					if (u == "default")
					{
						continue;
					}
					setHead(i, sUrl + u, p[2], p[0]);
					i++;
				}
			}
			skn=skin as MainSkin;
			loading=skn.loading;
			lmv=lm.Add(sUrl + mvCfg.mvPath, this, 0);
			lmv.addEventListener("MLOAD_LOADED", act);
			lmv.addEventListener("MLOAD_LOADING", function():void
			{
				loading.msg.text=int(lmv.scale.process) + "%";
			});
			loading.visible=true;
		}

		private function loadPic(s:String, fn:Function):void
		{
			var p:Array=s.split("|");
			p[1]=sUrl + p[1];
			lm.Add(p[1], this, 0).addEventListener("MLOAD_LOADED", function(e:Event):void
			{
				fn(e.target.img, p);
			});
		}

		private function act(e:Event):void
		{
			loading.visible=false;
			loading.msg.visible=false;
			skn.pltip.visible=true;

			var ok:Boolean=mvCfg.parse(lmv.mc);
			if (!ok)
			{
				Alert.show("视频剖析错误： 无法取得剪辑容器");
				return;
			}

			ok=mvCfg.parseSites(lmv.mc);
			if (!ok)
			{
				// 将无法使用“剧情引导”
			}

			mv2=mvCfg.mainClip;
			mv=mvCfg.container;
			if (mv)
			{
				mvCfg.applyParam();
			}
			else
			{
				mvOld=mvCfg.clip_old;
				mvCfg.applyOld(mvOld);
			}

			skn.player.addChildAt(mv2, 0);

			mv2.x=(playerW - mvCfg.brPlayWidth) / 2;
			mv2.y=(playerH - mvCfg.brPlayHeight) / 2;
			mv2.scaleX=mv2.scaleY=(mvCfg.brPlayWidth / mvCfg.brDsgnWidth);

			mvCtrl=new MovieCtrl(mv2, skn.ctrlPanel.slMovic, skn.ctrlPanel.btMovic);
			mvCtrl.onEnd=onPlayEnd;
			mvCtrl.onStart=onPlayStart;
			voiceCtrl=new VoiceCtrl(skn.ctrlPanel.slVoice, skn.ctrlPanel.btVoice);

			skn.plPlay.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				mvCtrl.start();
			});
			skn.plEdit.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				ExternalInterface.call("LoadDiyHead");
			});
			skn.plHead.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				ExternalInterface.call("LoadDiyHead");
			});
			skn.plGuide.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				if (ok)
				{
					if (!guider)
					{
						guider=new Guider(skn.playerGrp, mvCtrl, mvCfg);
					}
					skn.pltip.visible=false;
					guider.start();
				}
				else
				{
					Alert.show("无法使用剧情引导：未取得视频编辑参数");
				}
			});

			//判断新旧视频显示相应按钮
			if (mv)
			{
				skn.plEdit.visible=true;
				skn.plHead.visible=false;
			}
			else
			{
				skn.plEdit.visible=false;
				skn.plHead.visible=true;
			}

			if (mvCfg.userID > 0)
			{
				skn.ctrlPanel.btCamera.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
				{
					skn.ctrlPanel.topBar.visible=false;
					UploadPhoto();
				});
			}
			else
			{

			}
			mv2.gotoAndStop(mvCfg.frameID);
			initMusic();

			//滤镜初始化
			if (mvCfg.general && mvCfg.general.filter)
			{
				Filters.setFilter(mv2, mvCfg.general.filter);
			}

			mv2.addEventListener(Event.ENTER_FRAME, function():void
			{
				skn.ctrlPanel.showTime(mv2.currentFrame - 1, mv2.totalFrames - 1);
			});
		}

		private function initMusic():void
		{

			if (mvCfg.userDub && mvCfg.userDub.Path)
			{
				snd.setSound(mv, mvCfg.userDub.Path);
			}
			else if (mvCfg.dubUrl)
			{
				snd.setSound(mv, mvCfg.dubUrl);
			}

			if (mvCfg.general)
			{
				if (mvCfg.general.music == "off")
				{
					voiceCtrl.off();
				}
				else
				{
					voiceCtrl.on();
				}
			}
		}

		private function UploadPhoto():void
		{
			if (uploading || mvCfg.userID <= 0)
			{
				return;
			}
			uploading=true;
			Net.postData(StringUtil.substitute("/Main/App/UploadFile/{0}.jpg", new Date().time), new JPGEncoder(60).encode(getImag(mv2)), function(d:Object):void
			{
				uploading=false;
				skn.ctrlPanel.topBar.visible=true;
				Alert.show("画面截取成功，已保存到“我的相册”。");
			});
		}

		private function onPlayStart():void
		{
			skn.pltip.visible=false;
			//skn.ctrlPanel.topBar.visible = false;
		}

		private function onPlayEnd():void
		{
			skn.pltip.visible=true;
			mv2.gotoAndStop(mvCfg.frameID);
			trace("Main.onPlayEnd()");
			if (!updataClick)
			{
				Net.getXml("/Main/Movie/UpdataClick/" + mvCfg.userMovieID); // 记录此视频：增加一个点击
				updataClick=true;
			}
		}

	}
}
