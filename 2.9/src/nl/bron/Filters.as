package nl.bron
{
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	
	public class Filters
	{
		public function Filters()
		{
			
		}
		
		/**
		 * 默认
		 */
		public static function get none():*
		{
			return null;
		}
		
		/**
		 * 光亮效果
		 */
		public static function get effectOfLight():ConvolutionFilter
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([5, 5, 5]);
			matrix = matrix.concat([5, 0, 5]);
			matrix = matrix.concat([5, 5, 5]);
			var convolution:ConvolutionFilter = new ConvolutionFilter();
			convolution.matrixX = 3;
			convolution.matrixY = 3;
			convolution.matrix = matrix;
			convolution.divisor = 30;
			return convolution;
		}
		
		/**
		 * 墨汁
		 */
		public static function get ink():ColorMatrixFilter
		{
			var _local_1:Number = (1 / 3);
			var _local_2:Number = (1 / 3);
			var _local_3:Number = (1 / 3);
			var m_sepia:ColorMatrixFilter = new ColorMatrixFilter([0.39300000667572, 0.768999993801117, 0.188999995589256, 0, 0, 0.349000006914139, 0.685999989509583, 0.167999997735023, 0, 0, 0.272000014781952, 0.533999979496002, 0.130999997258186, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
			return m_sepia;
		}
		
		/**
		 * 锐化
		 */
		public static function get sharpen():ConvolutionFilter
		{
			var MATRIX:Array = [0,-1,0,-1,5,-1,0,-1,0];
			var m_sharpen:ConvolutionFilter = new ConvolutionFilter(3,3,MATRIX);
			return m_sharpen;
		}
		
		/**
		 * 模糊
		 */
		public static function get fuzzy():BlurFilter
		{
			
			var m_blur:BlurFilter = new BlurFilter();
			return m_blur;
		}
		
		/**
		 * 黑白
		 */
		public static function get blackAndWhite():*
		{
			var red:Number = 1 / 3;
			var green:Number = 1 / 3;
			var blue:Number = 1 / 3;
			var m_bw:ColorMatrixFilter = new ColorMatrixFilter([red,green,blue,0,0,red,green,blue,0,0,red,green,blue,0,0,0,0,0,1,0]);
			return m_bw;
		}
		
		/**
		 * 背反效果
		 */
		public static function get antinomie():ConvolutionFilter
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([0, -1, 0]);
			matrix = matrix.concat([-1, 4, -1]);
			matrix = matrix.concat([0, -1, 0]);
			var convolution:ConvolutionFilter = new ConvolutionFilter();
			convolution.matrixX = 3;
			convolution.matrixY = 3;
			convolution.matrix = matrix;
			convolution.divisor = 1;
			return convolution;
		}
		
		/**
		 * 浮雕效果
		 */
		public static function get anaglyph():ConvolutionFilter
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([-2, -1, 0]);
			matrix = matrix.concat([-1, 1, 1]);
			matrix = matrix.concat([0, 1, 2]);
			var convolution:ConvolutionFilter = new ConvolutionFilter();
			convolution.matrixX = 3;
			convolution.matrixY = 3;
			convolution.matrix = matrix;
			convolution.divisor = 1;
			return convolution;
		}
		
		/**
		 * 卷积滤镜
		 */
		public static function get convolution():ConvolutionFilter
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([0, 1, 0]);
			matrix = matrix.concat([1, 1, 1]);
			matrix = matrix.concat([0, 1, 0]);
			var convolution:ConvolutionFilter = new ConvolutionFilter();
			convolution.matrixX = 3;
			convolution.matrixY = 3;
			convolution.matrix = matrix;
			convolution.divisor = 5;
			return convolution;
		}
		
		/**
		 * 颜色矩阵滤镜
		 */
		public static function get colorMatrix():ColorMatrixFilter
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([0.3086, 0.6094, 0.082, 0, 0]); // red
			matrix = matrix.concat([0.3086, 0.6094, 0.082, 0, 0]); // green
			matrix = matrix.concat([0.3086, 0.6094, 0.082, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			var gray:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			return gray;
		}
		
		/**
		 * 发光滤镜
		 */
		public static function get glow():GlowFilter
		{
			var glow:GlowFilter = new GlowFilter();
			glow.blurX = 20;
			glow.blurY = 20;
			glow.strength = 1.5;
			glow.quality = BitmapFilterQuality.MEDIUM;
			glow.color = 0x00ff00;
			glow.alpha = 1;
			glow.knockout = false;
			glow.inner = true;
			return glow;
		}
		
		/**
		 * 斜角滤镜
		 */
		public static function get bevel():BevelFilter
		{
			var bevel:BevelFilter = new BevelFilter();
			bevel.blurX = 15;
			bevel.blurY = 15;
			bevel.strength = 2;
			bevel.quality = BitmapFilterQuality.LOW;
			bevel.shadowColor = 0x000000;
			bevel.shadowAlpha = 1;
			bevel.highlightColor = 0xFFFFFF;
			bevel.highlightAlpha = 1;
			bevel.angle = 45;
			bevel.distance = 5;
			bevel.knockout = false;
			bevel.type = BitmapFilterType.INNER;
			return bevel;
		}
		
		/**
		 * 冷蓝
		 */
		public static function get coldBlue():Array
		{
			var cmFilter:ColorMatrixFilter = new ColorMatrixFilter([
				1.114229679107666,0.42619627714157104,-0.3904261291027069,0,-11.825000762939453,-0.01766873709857464,1.0313040018081665,
				0.13636471331119537,0,-11.825002670288086,0.38688573241233826,-0.1958605945110321,0.9589747786521912,0,-11.82500171661377,0,0,0,1,0
			]);
			var ctf:ColorTransform = new ColorTransform(0.890625);
			return [ctf, cmFilter];
		}
		
		/**
		 * 冷绿
		 */
		public static function get coldGreen():Array
		{
			var cmFilter:ColorMatrixFilter = new ColorMatrixFilter([
				0.7291078567504883,1.140134334564209,-0.8692421317100525,0,0,-0.017857180908322334,0.696910560131073,0.3209466338157654,
				0,0,0.8961606621742249,-0.26529088616371155,0.3691302537918091,0,0,0,0,0,1,0
			]);
			var ctf:ColorTransform = new ColorTransform(0.87109375,1,0.87890625);
			return [ctf, cmFilter];
		}
		
		/**
		 * 冷紫
		 */
		public static function get coldPurple():Array
		{
			var cmFilter:ColorMatrixFilter = new ColorMatrixFilter([
				0.7477823495864868,0.9668121933937073,-0.7145946025848389,0,0,0.007340385112911463,0.7222312688827515,0.27042829990386963,
				0,0,0.7637989521026611,-0.1963445246219635,0.4325455129146576,0,0,0,0,0,1,0
			]);
			var ctf:ColorTransform = new ColorTransform(0.9296875, 0.921875, 0.98046875);
			return [ctf, cmFilter];
		}
		
		/**
		 * 粉嫩
		 */
		public static function get pink():ColorMatrixFilter
		{
			var cmFilter:ColorMatrixFilter = new ColorMatrixFilter([
				1.8319177627563477,-0.7420663237571716,-0.09985140711069107,0,-5.305002212524414,-0.3757822513580322,1.4656336307525635,
				-0.09985140711069107,0,-5.305001735687256,-0.3757822513580322,-0.7420663237571716,2.1078484058380127,0,-5.305001258850098,
				0,0,0,1,0
			]);
			return cmFilter;
		}
		
		/**
		 * 复古
		 */
		public static function get vintage():ColorMatrixFilter
		{
			var cmFilter:ColorMatrixFilter = new ColorMatrixFilter([
				1.7449109554290771,-2.4273061752319336,1.5123952627182007,0,37.355003356933594,-0.3957555294036865,1.9030925035476685,
				-0.6773368716239929,0,37.355003356933594,-2.077383279800415,0.15842211246490479,2.7489609718322754,0,37.35499572753906,
				0,0,0,1,0
			]);
			return cmFilter;
		}
		
		/**
		 * 哥特
		 */
		public static function get gothic():ColorMatrixFilter
		{
			var cmFilter:ColorMatrixFilter = new ColorMatrixFilter([
				0.944672703742981,-1.2470033168792725,1.3023308515548706,0,9.000001907348633,0.011150207370519638,1.4419467449188232,
				-0.4530969262123108,0,9,-1.3369488716125488,0.8258801698684692,1.5110688209533691,0,9,0,0,0,1,0
			]);
			return cmFilter;
		}
		
		/**
		 * HDR
		 */
		public static function get hdr():ColorMatrixFilter
		{
			var cmFilter:ColorMatrixFilter = new ColorMatrixFilter([
				0.6188793182373047,-0.2961626648902893,0.6772833466529846,0,0,0.1635025292634964,1.0155203342437744,-0.1790228933095932,0,0,
				-0.4941067695617676,0.7149999737739563,0.7791067361831665,0,0,0,0,0,1,0
			]);
			return cmFilter;
		}
		
		/**
		 * 怀旧
		 */
		public static function get nostalgia():Array
		{
			var cmFilter:ColorMatrixFilter = new ColorMatrixFilter([
				1.841408133506775,-1.524963140487671,0.723555326461792,0,-3.58000111579895,-0.3362577557563782,1.7554322481155396,
				-0.37917453050613403,0,-3.580000877380371,-1.1831105947494507,-0.22281330823898315,2.4459240436553955,0,-3.5800013542175293,
				0,0,0,1,0
			]);
			var ctf:ColorTransform = new ColorTransform(0.94921875, 0.94921875, 0.6015625);
			return [ctf, cmFilter];
		}
		
		public static function setFilter(dis:*, filtersName:String):void
		{
			dis.transform.colorTransform = new ColorTransform();
			dis.filters = [];
			if(filtersName == "none" && dis is brCell){
				dis.filters = dis.hostCell.initFilters;
				return;
			}
			if(Filters[filtersName] is Array){
				for(var filter:String in Filters[filtersName]){
					if(Filters[filtersName][filter] is ColorTransform){
						dis.transform.colorTransform = Filters[filtersName][filter];
					}else{
						dis.filters = Filters[filtersName][filter]?[Filters[filtersName]][filter]:[]
					}
				}
			}else{
				dis.filters = Filters[filtersName]?[Filters[filtersName]]:[]
			}
		}
	}
	
}