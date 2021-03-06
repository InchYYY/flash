﻿package nl.bron
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class brPicCell extends brCell
	{
		private var _mskIndex: int;
		private var _msk: DisplayObject;
		private var ed:* = brContainer.ED;
		private var mv:* = brContainer.MV;
		
		public function brPicCell()
	    {
			super();
			_mskIndex = parent.getChildIndex(this) - 1;
			_msk = parent.getChildAt(_mskIndex);
			setMask(_hostCell.isMaskHidden);
			if(_hostCell.filtersName) _hostCell.filtersName = _hostCell.filtersName;
	    }
		
		public function setMask(act: Boolean): void
		{
			if (act) {
				addMask();
			}
		}
		
		public static function updateState(hc: HostCell): void
		{
			doUpdateState(hc.actor, hc.param, hc.parent);
		}

		private static function doUpdateState(actor: DisplayObject, param: Object, parent: DisplayObjectContainer): void
		{
			if (!actor) return;
			actor.x = param.x;
			actor.y = param.y;
			actor.scaleX = actor.scaleY = param.zoom;
			actor.rotation = param.rotation;
			if (parent && !(parent is brContainer)) {
				parent.filters = undefined;
				if (parent.parent && !(parent.parent is brContainer)) {
					parent.parent.filters = undefined;
				}
			}
		}

		override public function hitTestPoint(x: Number, y: Number, shapeFlag: Boolean = false): Boolean
		{
			return parent.getChildAt(parent.getChildIndex(this) - 1).hitTestPoint(x, y, shapeFlag);
		}
		
		public function rotatePoint(degrees : Number, pnt : Point = null) : void
		{
			if (pnt == null) { pnt = new Point(0, 0); }
			else { pnt = globalToLocal(pnt); }
			var p1 : Point = getRotatedPoint(new Point(param.x, param.y), pnt, degrees);
			param.x = param.x + pnt.x - p1.x;
			param.y = param.y + pnt.y - p1.y;
			param.rotation += degrees;
			doUpdateState(actor, param, this.parent);
		}

		public function zoomPoint(scale : Number, pnt : Point = null) : void
		{
			if (pnt == null) { pnt = new Point(0, 0); }
			else { pnt = globalToLocal(pnt); }
			param.x = param.x - (pnt.x - param.x) * (scale - 1);
			param.y = param.y - (pnt.y - param.y) * (scale - 1);
			param.zoom = param.zoom * scale;
			doUpdateState(actor, param, this.parent);
		}

		public function movePoint(pnt : Point) : void
		{
			var p : Point = globalToLocal(pnt);
			var po : Point = globalToLocal(new Point(0, 0));
			param.x = param.x + p.x - po.x;
			param.y = param.y + p.y - po.y;
			doUpdateState(actor, param, this.parent);
		}

		private function getRotatedPoint(po : Point, p : Point, degress : Number) : Point
		{
			p = new Point(p.x - po.x, p.y - po.y);
			var r : Number = degress / 180 * Math.PI;
			var x : Number = Math.cos(r) * p.x - Math.sin(r) * p.y;
			var y : Number = Math.cos(r) * p.y + Math.sin(r) * p.x;
			return new Point(x + po.x, y + po.y);
		}
		
		public function addMask():void
		{
			
			var la:int = parent.getChildIndex(this);//获取当前Cell所在的图层
			
			var m : DisplayObject= parent.getChildAt( la - 1 );//获取cell的遮罩
			var p : DisplayObjectContainer = parent;//获取cell的父级
			var rc: Rectangle = m.getBounds(parent);
			
			if(ed){
				var p1:Point = new Point(0, 0);//MV左上 的点
				var p2:Point = new Point(ed.brDsgnWidth, ed.brDsgnHeight);//MV右下 的点			
				
				//计算当前遮庶大小与MV屏幕大小对应;
				var mw : int = parent.globalToLocal(p2).x - parent.globalToLocal(p1).x ;//全局转局部
				var mh : int = parent.globalToLocal(p2).y - parent.globalToLocal(p1).y ;//全局转局部
				
				var maskPic:Shape = new Shape();
				maskPic.graphics.beginFill(0xFF0000, 0);
				maskPic.graphics.drawRect(0, 0, mw, mh);
				maskPic.graphics.endFill();
				p.removeChildAt(la-1);//删除当前遮罩
				p.addChildAt(maskPic, la-1);
				_msk = maskPic;
				
				//坐标转换;
				var mp:Point = mv.localToGlobal(p1)
				maskPic.x = parent.globalToLocal(mp).x;
				maskPic.y = parent.globalToLocal(mp).y;				
			}else{
				p.removeChildAt(la-1);//删除当前遮罩
				p.addChildAt(new Shape(), la-1);
			}
		}

		/**
		 * 设置图片刚好放在遮罩层下
		 */
		public function fitMask(): void
		{	
			if (!actor) return;
			var scale: Number = 1;
			var rc: Rectangle = cellMask.getBounds(parent);
			actor.scaleX = actor.scaleY = 1;
			actor.rotation = 0;
			
			if (param.maskHidden) {
				if (rc.width / actor.width < rc.height / actor.height) {
					scale = rc.width / actor.width;
				} else {
					scale = rc.height / actor.height;
				}
			}else{
				if (rc.width / actor.width > rc.height / actor.height) {
					scale = rc.width / actor.width;
				} else {
					scale = rc.height / actor.height;
				}
			}
			
			param.zoom = scale;
			param.rotation = 0;
			
			param.x = rc.x - (actor.width * scale - rc.width) / 2 - x;
			param.y = rc.y - (actor.height * scale - rc.height) / 2 - y;
			
			doUpdateState(actor, param, this.parent);
		}
		
		/**
		 * 获取图片上方遮罩层
		 */
		public function get cellMask(): DisplayObject
		{
			var s:* = parent.getChildAt(parent.getChildIndex(this) - 1);
			return parent.getChildAt(parent.getChildIndex(this) - 1);
		}
		
		
		override public function copyEditParam(dest: Object, src: Object): void
		{
			dest.hidden = src.hidden;
			dest.x = src.x;
			dest.y = src.y;
			dest.zoom = src.zoom;
			dest.rotation = src.rotation;
			dest.url = src.url;
		}
	}
}
