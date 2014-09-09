package cn.flashk.ui
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 
	 * 分页显示辅助管理器，管理分页数据和前一页、后一页按钮的点击、禁止和页码显示
	 */ 
	public class PageManager
	{
		/**
		 * 页码显示的格式 {$1}将被当前页数替换，{$2}将被总共页数替换
		 */ 
		private var _viewTextCode:String = "第{$1}页/共{$2}页";
		private var _nextButton:SimpleButton;
		private var _prevButton:SimpleButton;
		private var _viewTextField:TextField;
		private var _pageCount:uint;
		private var _list:Array;
		private var _updateFunction:Function;
		private var _nowPage:uint;
		private var _maxPage:uint;
		private var _itemDefineName:String;
		private var _itemInitFunction:Function;
		private var _listBox:Sprite;
		
		public function PageManager()
		{
		}
		
		public function get maxPage():uint
		{
			return _maxPage;
		}
		
		public function get nowPage():uint
		{
			return _nowPage;
		}

		public function get viewTextCode():String
		{
			return _viewTextCode;
		}

		public function set viewTextCode(value:String):void
		{
			_viewTextCode = value;
		}
		
		public function get allData():Array{
			return _list;
		}
		
		/**
		 * 
		 * @param nextButton
		 * @param prevButton
		 * @param viewTextField 
		 * 
		 */
		public function initView(nextButton:SimpleButton,prevButton:SimpleButton,viewTextField:TextField):void
		{
			_nextButton = nextButton;
			_prevButton = prevButton;
			_viewTextField = viewTextField;
			UI.setEnable(_nextButton,false);
			UI.setEnable(_prevButton,false);
			_nextButton.addEventListener(MouseEvent.CLICK,onNextClick);
			_prevButton.addEventListener(MouseEvent.CLICK,onPrevClick);
			
			var str:String = _viewTextCode.replace("{$1}",0);
			str = str.replace("{$2}",0);
			_viewTextField.text = str;
		}
		
		/**
		 * 
		 * @param list
		 * @param pageCount
		 * @param updateFunction 刷新列表的处理函数，当用户翻页和初始化数据时将调用此函数，并传递当前的页数(uint 唯一参数)例如：function viewTeamListPageAt(page:uint)
		 * 
		 */
		public function initData(list:Array,pageCount:uint,updateFunction:Function=null):void
		{
			_list = list;
			_pageCount = pageCount;
			_updateFunction = updateFunction;
			if(_updateFunction == null)
			{
				_updateFunction = viewTeamListPageAt;
			}
			_maxPage = int((_list.length-1)/_pageCount)+1;
			if(_list.length == 0)
			{
				_maxPage = 0;
			}
			UI.setEnable(_prevButton,true);
			if(_maxPage > 1)
			{
				UI.setEnable(_nextButton,false);
			}else
			{
				UI.setEnable(_nextButton,true);
			}
			viewAt(1);
		}
		
		/**
		 * 
		 * @param listContainer 列表的容器
		 * @param defineName 列表显示Item的库链接名
		 * @param initFunction 列表数据处理的函数，将接受3个参数：item显示对象的新实例Sprite、数据Object、索引位置（从0开始）uint
		 * 
		 */
		public function setListItemDefineAndFunction(listContainer:Sprite,defineName:String,initFunction:Function):void
		{
			_itemDefineName = defineName;
			_itemInitFunction = initFunction;
			_listBox = listContainer;
		}
		
		public function getListAtPage(index:uint):Array
		{
			var arr:Array = [];
			index = index -1;
			var max:uint = (index+1)*_pageCount;
			if(max > _list.length)
			{
				max = _list.length;
			}
			for(var i:int=index*_pageCount;i<max;i++)
			{
				arr.push(_list[i]);
			}
			return arr;
		}
		
		/**
		 * 
		 * @param pageIndex 从1开始计数
		 * 
		 */
		public function viewAt(pageIndex:uint):void
		{
			_nowPage = pageIndex;
			if(_maxPage == 0){
				_nowPage = 0;
			}
			var str:String = _viewTextCode.replace("{$1}",_nowPage);
			str = str.replace("{$2}",_maxPage);
			_viewTextField.text = str;
			if(_maxPage > 0)
			{
				_updateFunction(pageIndex);
			}else
			{
				Xdis.clearChildrens(_listBox);
			}
		}
		private function viewTeamListPageAt(page:uint):void
		{
			var item:Sprite;
			var da:Object;
			var classRef:Class = getDefinitionByName(_itemDefineName) as Class;
			Xdis.clearChildrens(_listBox);
			var arr:Array = getListAtPage(page);
			for(var i:uint=0;i<arr.length;i++)
			{
				da = arr[i];
				item = new classRef() as Sprite;
				_listBox.addChild(item);
				if(_itemInitFunction != null)
				{
					_itemInitFunction(item,da,i);
				}
			}
			if(item != null)
			{
				Xdis.sortChilds(_listBox,item.height);
			}
		}
		private function onNextClick(event:MouseEvent):void
		{
			_nowPage++;
			if(_nowPage >= _maxPage)
			{
				_nowPage = _maxPage;
				UI.setEnable(_nextButton,true);
			}
			if(_nowPage >1 )
			{
				UI.setEnable(_prevButton,false);
			}
			viewAt(_nowPage);
		}
		
		private function onPrevClick(event:MouseEvent):void
		{
			_nowPage --;
			if(_nowPage <= 1)
			{
				_nowPage = 1;
				UI.setEnable(_prevButton,true);
			}
			if(_nowPage < _maxPage)
			{
				UI.setEnable(_nextButton,false);
			}
			viewAt(_nowPage);
		}
	}
}