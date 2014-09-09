package nl.bron
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Mouth extends Sprite
	{
		private var m_oImage:Bitmap;			// current show mouth image
		private var m_aMouthImages:Object;		// contains an array of prerendered mouth images
		private var m_aMarkers:Array;
		
		public function Mouth()
		{
			m_oImage = null;
			m_aMouthImages = new Object;
			m_aMarkers = new Array();
		}
		
		public function createImage(p_oHeadImage:DisplayObject, p_aMarkers:Array) : void
		{
			var pntMouthLeft:Point = null;
			var pntMouthRight:Point = null;
			var pntMouthBottom:Point = null;
			var shpMarker:Shape;
			for each (var oMarker : Object in p_aMarkers)
			{
				if (undefined != oMarker.type)
				{
					switch (oMarker.type)
					{
						case brCell.MARKER_MOUTH_LEFT : 
							pntMouthLeft = new Point(oMarker.x, oMarker.y);
						break;
						case brCell.MARKER_MOUTH_RIGHT : 
							pntMouthRight = new Point(oMarker.x, oMarker.y);
						break;
						case brCell.MARKER_MOUTH_BOTTOM : 
							pntMouthBottom = new Point(oMarker.x, oMarker.y);
						break;
						default : 
							// ignore other markers
					}
				}
			}
			if ((null != pntMouthLeft) && (null != pntMouthRight) && (null != pntMouthBottom)) {
				m_aMarkers.push(createMarker(pntMouthLeft));
				m_aMarkers.push(createMarker(pntMouthRight));
				m_aMarkers.push(createMarker(pntMouthBottom));
				for each(shpMarker in m_aMarkers) {
					if (!contains(shpMarker)) {
						addChild(shpMarker);
					}
				}
				var pntTopLeft:Point = new Point(pntMouthLeft.x, Math.min(pntMouthLeft.y, pntMouthRight.y));
				var rctMouth:Rectangle = new Rectangle (0, 0, pntMouthRight.x - pntMouthLeft.x, pntMouthBottom.y - pntTopLeft.y);
				preRenderImages(p_oHeadImage, pntTopLeft, rctMouth);
				m_oImage = m_aMouthImages['closed'];
				addChild(m_oImage);
			}
			else { /*not all mouth markers available*/ }
		}
		
		public function say(p_sPhonem:String): void
		{
			if (null != m_oImage)
			{
				if (contains(m_oImage)) {
					removeChild(m_oImage);
				}
				m_oImage = null;
			}
			var sImageName:String = '';
			switch (p_sPhonem) {
				case 'a' :
					sImageName = 'half_open';
				break;
				case 'o' :
					sImageName = 'open';
				break;
				default :
					sImageName = 'closed';
			}
			if ((sImageName.length > 0) && (undefined != m_aMouthImages[sImageName]) && (null != m_aMouthImages[sImageName])) {
				m_oImage = m_aMouthImages[sImageName];
				addChild(m_oImage);
			}
			
		}
		
		private function preRenderImages(p_oHeadImage:DisplayObject, p_pntTopLeft:Point, p_rctMouth:Rectangle) : void
		{
			// closed
			var bmpdMouth:BitmapData = new BitmapData(p_rctMouth.width, p_rctMouth.height, true, 0xffffffff);
			var mtxTranslate:Matrix = new Matrix();
			var bmpMouth:Bitmap;
			mtxTranslate.translate( -p_pntTopLeft.x, -p_pntTopLeft.y);
			bmpdMouth.draw(p_oHeadImage, mtxTranslate, null, null, p_rctMouth, false);
			bmpMouth = new Bitmap(bmpdMouth);
			bmpMouth.x = p_pntTopLeft.x;
			bmpMouth.y = p_pntTopLeft.y;
			m_aMouthImages['closed'] = bmpMouth;
			// half open
			bmpdMouth = new BitmapData(p_rctMouth.width, p_rctMouth.height * 1.5, true, 0xffffffff);
			mtxTranslate = new Matrix();
			mtxTranslate.translate( -p_pntTopLeft.x, -p_pntTopLeft.y + (p_rctMouth.height * 0.5));
			bmpdMouth.draw(p_oHeadImage, mtxTranslate, null, null, p_rctMouth, false);
			bmpMouth = new Bitmap(bmpdMouth);
			bmpMouth.x = p_pntTopLeft.x;
			bmpMouth.y = p_pntTopLeft.y;
			m_aMouthImages['half_open'] = bmpMouth;
			// open
			bmpdMouth = new BitmapData(p_rctMouth.width, p_rctMouth.height * 2, true, 0xffffffff);
			mtxTranslate = new Matrix();
			mtxTranslate.translate( -p_pntTopLeft.x, -p_pntTopLeft.y + (p_rctMouth));
			bmpdMouth.draw(p_oHeadImage, mtxTranslate, null, null, p_rctMouth, false);
			bmpMouth = new Bitmap(bmpdMouth);
			bmpMouth.x = p_pntTopLeft.x;
			bmpMouth.y = p_pntTopLeft.y;
			m_aMouthImages['open'] = bmpMouth;
		}
		
		private function createMarker(p_pntMarker:Point) : Shape
		{
			var shpMarker:Shape = new Shape();
			shpMarker.graphics.lineStyle(2, 0xff0000);
			shpMarker.graphics.moveTo(p_pntMarker.x - 10, p_pntMarker.y);
			shpMarker.graphics.lineTo(p_pntMarker.x + 10, p_pntMarker.y);
			shpMarker.graphics.moveTo(p_pntMarker.x, p_pntMarker.y - 10);
			shpMarker.graphics.lineTo(p_pntMarker.x, p_pntMarker.y + 10);
			return shpMarker;
		}
	}
}