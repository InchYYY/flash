package cn.flashk.controls.support
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import cn.flashk.controls.managers.UISet;
	
	/**
	 * <p>Scale9GridBitmap 用来创建位图的九宫格缩放。（因为flash本身的九宫格缩放并不支持位图，只支持矢量）</p>
	 * 
	 * 要使用位图的九宫格，请先传递原始的图像到sourceBitmapData属性，scale9GridBitmap.sourceBitmapData = bitmapData实例
	 * 然后直接设置width和height属性。（此时scaleX和scaleY始终为1，set width和set height函数已经被重写）。
	 * 虽然你仍然可以设置scale横向缩放和竖向缩放，不过不建议使用设置scaleX和scaleY属性缩放。要使用scaleX而又要开启九宫格，请使用 b.width = b.width 乘以 b.scaleX这样的语法。
	 */ 

	public class Scale9GridBitmap extends Bitmap
	{
		/**
		 * 九宫格左边竖线与0坐标的距离
		 */ 
		public var leftLineSpace:uint = 8;
		/**
		 * 九宫格右边竖线与图像最右像素的距离
		 */ 
		public var rightLineSpace:uint = 8;
		/**
		 * 九宫格上面横线与0坐标的距离
		 */ 
		public var topLineSpace:uint = 6;
		/**
		 * 九宫格下面横线与图像最下像素的距离
		 */ 
		public var bottomLineSpace:uint = 6;
		/**
		 * 控制再拉伸九宫格位图时是否对中间的部分开启平滑处理，默认关闭，开启将获得更好的渐变效果，设置为 true 的情况下绘制位图要比在设置为 false 的情况下执行相同操作更为缓慢，请注意此参数与smoothing属性的区别，smoothing是指控制在整个位图缩放时是否进行平滑处理。
		 * smoothing在这里只影响小数坐标时是否平滑处理，因为Scale9GridBitmap的在重设宽高时scaleX和scaleY始终为1（set width和set height函数已经被重写，但你仍然可以自己设置scaleX，此时smoothing会有效果）
		 * 
		 * <p>修改scaleSmoothing只会在下一次更改宽高时生效，并不会立即刷新图像，如果需要立即刷新，请调用update函数</p>
		 * 
		 * @see #update()
		 */ 
		public var scaleSmoothing:Boolean = false;
		
		protected var sourceBD:BitmapData;
		protected var _mwidth:uint=0;
		protected var _mheight:uint=0;
		protected var bd:BitmapData;
		
		public function Scale9GridBitmap()
		{
			scaleSmoothing = UISet.sourceSkinBitmapSmoothing;
		}
		
		/**
		 * 设置Scale9GridBitmap的原始未缩放的源数据，可以与其他 Bitmap 共用一个 Bitmapdata。因为Scale9GridBitmap在重设宽高需要重新计算bitmapdata数据，需要以此属性的数据做参考，Scale9GridBitmap并不会修改此属性中的像素数据。只会修改自身bitmapdata属性的数据。
		 */ 
		public function set sourceBitmapData(value:BitmapData):void{
			sourceBD = value;
			this.bitmapData = sourceBD;
			this.smoothing = scaleSmoothing;
			if(_mheight==0){
				_mheight = sourceBD.height;
			}
			if(_mwidth == 0){
				_mwidth = sourceBD.width;
			}
		}
		
		public function useSourceSize():void{
			this.bitmapData = sourceBD;
			this.smoothing = scaleSmoothing;
			_mheight = sourceBD.height;
			_mwidth = sourceBD.width;
		}
		
		/**
		 * 更改Scale9GridBitmap的宽度，修改此值将重新计算Scale9GridBitmap的bitmapData数据，如果height值与源图像相同，只修改width将采用3分法加速
		 * 
		 * @see #scaleGrid3()
		 * @see #update()
		 */ 
		override public function set width(value:Number):void{
			if(uint(value) == _mwidth) return;
			_mwidth = uint(value);
			if(sourceBD == null) return;
			if(_mwidth == sourceBD.width && _mheight == sourceBD.height){
				this.bitmapData = sourceBD;
				this.smoothing = scaleSmoothing;
				return;
			}
			if(_mheight == sourceBD.height){
				scaleGrid3();
			}else{
				scaleGrid9();
			}
		}
		
		/**
		 * 更改Scale9GridBitmap的高度，修改此值将重新计算Scale9GridBitmap的bitmapData数据，如果width值与源图像相同，只修改height将采用3分法加速
		 * 
		 * @see #scaleGrid3V()
		 * @see #update()
		 */ 
		override public function set height(value:Number):void{
			if(uint(value) == _mheight) return;
			_mheight = uint(value);
			if(_mwidth == sourceBD.width && _mheight == sourceBD.height){
				this.bitmapData = sourceBD;
				this.smoothing = scaleSmoothing;
				return;
			}
			if(_mwidth == sourceBD.width){
				scaleGrid3V();
			}else{
				scaleGrid9();
			}
		}
		
		public function setSize(newWidth:uint,newHeight:uint,speedCheck:Boolean=false):void
		{
			_mwidth = newWidth;
			_mheight = newHeight;
			if(speedCheck == true){
				update();
			}else{
				scaleGrid9();
			}
		}
		
		
		/**
		 * 立即重新计算图像，如果sourceBitmapData的数据有更新，调用此方法立即刷新Scale9GridBitmap与sourceBitmapData同步，请注意Scale9GridBitmap的bitmapData始终与sourceBitmapData是两份不同的数据和对象
		 */ 
		public function update():void{
			if(sourceBD){
				var sw:int = sourceBD.width;
				var sh:int = sourceBD.height;
				if(_mwidth == sw && _mheight == sh){
					this.bitmapData = sourceBD;
					this.smoothing = scaleSmoothing;
					return;
				}else	if( _mwidth == sw){
					scaleGrid3V();
				}else if(_mheight == sh){
					scaleGrid3();
				}else{
					scaleGrid9();
				}
			}
		}
		
		/**
		 * 横向3分格启用加速
		 */ 
		protected function scaleGrid3():void{
			if(bd != null){
				bd.dispose();
			}
			bd = new BitmapData(_mwidth,_mheight,true,0);
			bd.copyPixels( sourceBD,new Rectangle(0,0,leftLineSpace,_mheight),new Point(0,0) );
			var tmpBD:BitmapData;
			tmpBD = new BitmapData(sourceBD.width-leftLineSpace-rightLineSpace,sourceBD.height,true,0);
			tmpBD.copyPixels(sourceBD,new Rectangle(leftLineSpace,0,tmpBD.width,tmpBD.height),new Point(0,0) );
			var mat:Matrix = new Matrix();
			var sca:Number = (_mwidth-leftLineSpace-rightLineSpace)/(sourceBD.width-leftLineSpace-rightLineSpace);
			mat.scale(sca,1);
			mat.tx = leftLineSpace;
			bd.draw(tmpBD,mat,null,null,new Rectangle(leftLineSpace,0,_mwidth-leftLineSpace-rightLineSpace,_mheight),scaleSmoothing );
			bd.copyPixels( sourceBD,new Rectangle(sourceBD.width-rightLineSpace,0,rightLineSpace,_mheight),new Point(_mwidth-rightLineSpace,0) );
			this.bitmapData = bd;
			this.smoothing = scaleSmoothing;
			tmpBD.dispose();
		}
		
		/**
		 * 竖向3分格启用加速
		 */ 
		protected function scaleGrid3V():void{
			if(bd != null){
				bd.dispose();
			}
			bd = new BitmapData(_mwidth,_mheight,true,0);
			bd.copyPixels( sourceBD,new Rectangle(0,0,_mwidth,_mheight),new Point(0,0) );
			var tmpBD:BitmapData;
			tmpBD = new BitmapData(sourceBD.width,sourceBD.height-topLineSpace-bottomLineSpace,true,0);
			tmpBD.copyPixels(sourceBD,new Rectangle(0,topLineSpace,tmpBD.width,tmpBD.height),new Point(0,0) );
			var mat:Matrix = new Matrix();
			var sca:Number = (_mheight-topLineSpace-bottomLineSpace)/(sourceBD.height-topLineSpace-bottomLineSpace);
			mat.scale(1,sca);
			mat.ty = topLineSpace;
			bd.draw(tmpBD,mat,null,null,new Rectangle(0,topLineSpace,_mwidth,_mheight-topLineSpace-bottomLineSpace),scaleSmoothing );
			bd.copyPixels( sourceBD,new Rectangle(0,sourceBD.height-bottomLineSpace,_mwidth,bottomLineSpace),new Point(0,_mheight-bottomLineSpace) );
			this.bitmapData = bd;
			this.smoothing = scaleSmoothing;
			tmpBD.dispose();
		}
		
		protected function scaleGrid9():void{
			if(bd != null){
				bd.dispose();
			}
			var tmpBD:BitmapData;
			bd = new BitmapData(_mwidth,_mheight,true,0);
			var scaX:Number=(_mwidth-leftLineSpace-rightLineSpace)/(sourceBD.width-leftLineSpace-rightLineSpace);
			var scaY:Number = (_mheight-topLineSpace-bottomLineSpace)/(sourceBD.height-topLineSpace-bottomLineSpace);
			var mat:Matrix;
			tmpBD = new BitmapData(sourceBD.width-leftLineSpace-rightLineSpace,topLineSpace,true,0);
			tmpBD.copyPixels(sourceBD,new Rectangle(leftLineSpace,0,tmpBD.width,tmpBD.height),new Point(0,0) );
			mat= new Matrix();
			mat.scale(scaX,1);
			mat.tx = leftLineSpace;
			bd.draw(tmpBD,mat,null,null,new Rectangle(leftLineSpace,0,_mwidth-leftLineSpace-rightLineSpace,topLineSpace),scaleSmoothing );
			if(bottomLineSpace == topLineSpace){
				tmpBD.fillRect(new Rectangle(0,0,tmpBD.width,tmpBD.height),0);
			}else{
				tmpBD.dispose();
				tmpBD = new BitmapData(sourceBD.width-leftLineSpace-rightLineSpace,bottomLineSpace,true,0);
			}
			tmpBD.copyPixels(sourceBD,new Rectangle(leftLineSpace,sourceBD.height-bottomLineSpace,tmpBD.width,tmpBD.height),new Point(0,0) );
			mat.ty = _mheight-bottomLineSpace;
			bd.draw(tmpBD,mat,null,null,new Rectangle(leftLineSpace,_mheight-bottomLineSpace,_mwidth-leftLineSpace-rightLineSpace,bottomLineSpace),scaleSmoothing );
			mat= new Matrix();
			mat.scale(1,scaY);
			tmpBD.dispose();
			tmpBD = new BitmapData(leftLineSpace,sourceBD.height-topLineSpace-bottomLineSpace,true,0);
			tmpBD.copyPixels(sourceBD,new Rectangle(0,topLineSpace,tmpBD.width,tmpBD.height),new Point(0,0) );
			mat.ty = topLineSpace;
			bd.draw(tmpBD,mat,null,null,new Rectangle(0,topLineSpace,leftLineSpace,_mheight-topLineSpace-bottomLineSpace),scaleSmoothing );
			if(rightLineSpace == leftLineSpace){
				tmpBD.fillRect(new Rectangle(0,0,tmpBD.width,tmpBD.height),0);
			}else{
				tmpBD.dispose();
				tmpBD = new BitmapData(rightLineSpace,sourceBD.height-topLineSpace-bottomLineSpace,true,0);
			}
			tmpBD.copyPixels(sourceBD,new Rectangle(sourceBD.width-rightLineSpace,topLineSpace,tmpBD.width,tmpBD.height),new Point(0,0) );
			mat.tx = _mwidth-rightLineSpace;
			bd.draw(tmpBD,mat,null,null,new Rectangle(_mwidth-rightLineSpace,topLineSpace,rightLineSpace,_mheight-topLineSpace-bottomLineSpace),scaleSmoothing );
			mat = new Matrix();
			mat.scale(scaX,scaY);
			tmpBD.dispose();
			tmpBD = new BitmapData(sourceBD.width-leftLineSpace-rightLineSpace,sourceBD.height-topLineSpace-bottomLineSpace,true,0);
			tmpBD.copyPixels(sourceBD,new Rectangle(leftLineSpace,topLineSpace,tmpBD.width,tmpBD.height),new Point(0,0) );
			mat.tx = leftLineSpace;
			mat.ty = topLineSpace;
			bd.draw(tmpBD,mat,null,null,new Rectangle(leftLineSpace,topLineSpace,_mwidth-leftLineSpace-rightLineSpace,_mheight-topLineSpace-bottomLineSpace),scaleSmoothing );
			tmpBD.dispose();
			bd.copyPixels(sourceBD,new Rectangle(0,0,leftLineSpace,topLineSpace),new Point(0,0) );
			bd.copyPixels(sourceBD,new Rectangle(0,sourceBD.height-bottomLineSpace,leftLineSpace,bottomLineSpace),new Point(0,_mheight-bottomLineSpace) );
			bd.copyPixels(sourceBD,new Rectangle(sourceBD.width-rightLineSpace,0,rightLineSpace,topLineSpace),new Point(_mwidth-rightLineSpace,0) );
			bd.copyPixels(sourceBD,new Rectangle(sourceBD.width-rightLineSpace,sourceBD.height-bottomLineSpace,rightLineSpace,bottomLineSpace),new Point(_mwidth-rightLineSpace,_mheight-bottomLineSpace) );
			this.bitmapData = bd;
			this.smoothing = scaleSmoothing;
		}
		
	}
}