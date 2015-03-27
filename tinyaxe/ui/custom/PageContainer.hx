package tinyaxe.ui.custom;

import tinyaxe.ui.custom.event.PageEvent;
import tinyaxe.ui.layouts.SimpleBox;
import openfl.display.DisplayObject;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Widget;

/**
 * @time 2013/12/19 12:22:36
 * @author Hoothin
 */
class PageContainer extends Widget{

	public var numberPerPage:Int = 5;
	public var pageCount:PageCount;
	
	public var lockWidth:Int = 100;
	public var lockHeight:Int = 0;
	
	public var cellVerticalPadding: Float = 0;
	public var cellHorizontalPadding: Float = 0;
	
	public var center:Bool = true;
	private var allChildList:Array<DisplayObject>;
	private var showChildList:Array<DisplayObject>;
	private var curPage:Int = 1;
	private var childBox:Widget;
	public function new() {
		super();
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public function onCreate():Void {
		this.allChildList = new Array();
		this.showChildList = new Array();
		childBox = UIBuilder.create(Widget);
		if (this.childBox.layout == null) {
			var simpleBox:SimpleBox = new SimpleBox();
			simpleBox.lockWidth = lockWidth;
			simpleBox.lockHeight = lockHeight;
			simpleBox.cellVerticalPadding = cellVerticalPadding;
			simpleBox.cellHorizontalPadding = cellHorizontalPadding;
			this.childBox.layout = simpleBox;
		}
		super.addChild(childBox);
		pageCount = UIBuilder.create(PageCount, {
			bottom: 5,
			w     : 60,
			h     : 15,
			x     : (this.w - 60) / 2
		});
		pageCount.addEventListener(PageEvent.PAGE_CHANGE, pageChanegeHandler);
		super.addChild(pageCount);
	}
	
	override public function addChild(child:DisplayObject) : DisplayObject {
		allChildList.push(child);
		refreshChild();
		return child;
	}
	
	override public function refresh():Void {
		super.refresh();
		this.childBox.refresh();
		if (center) this.childBox.x = (this.w - this.childBox.w) / 2;
	}
	
	override public function removeChild(child:DisplayObject):DisplayObject {
		allChildList.remove(child);
		if (childBox.contains(child))
		return this.childBox.removeChild(child);
		else return null;
	}
	
	public function clearChildren():Array<DisplayObject> {
		var childArr:Array<DisplayObject> = [];
		for (childItem in allChildList) {
			if (childItem.parent != null) {
				childItem.parent.removeChild(childItem);
			}
			childArr.push(childItem);
		}
		this.allChildList = [];
		this.showChildList = [];
		return childArr;
	}
	
	public function setPage(page:Int):Void {
		if (curPage == page) return;
		curPage = page;
		pageCount.setPage(page);
		refreshChild();
		this.childBox.refresh();
	}
	public function getCurrPage():Int
	{
		return curPage;
	}
	
	public function selectChild(curChild:DisplayObject):Void {
		var childIndex:Int = allChildList.indexOf(curChild);
		if (childIndex != -1) {
			setPage(Std.int(childIndex / numberPerPage) + 1);
		}
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	private function refreshChild():Void {
		for (showChild in showChildList) {
			if(showChild.parent != null)
			showChild.parent.removeChild(showChild);
		}
		this.showChildList = new Array();
		var beginIndex:Int = (curPage - 1) * numberPerPage;
		var endIndex:Int;
		if (beginIndex + numberPerPage < allChildList.length) {
			endIndex = beginIndex + numberPerPage;
		}else {
			endIndex = allChildList.length;
		}
		var waitingList:Array<DisplayObject> = allChildList.slice(beginIndex, endIndex);
		for (waiting in waitingList) {
			this.childBox.addChild(waiting);
			this.showChildList.push(waiting);
		}
		if (allChildList.length % numberPerPage == 0) {
			pageCount.setMax(Std.int(allChildList.length / numberPerPage));
		}else {
			pageCount.setMax(Std.int(allChildList.length / numberPerPage) + 1);
		}
	}
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function pageChanegeHandler(e:PageEvent):Void {
		if (curPage == pageCount.getPage()) return;
		curPage = pageCount.getPage();
		refreshChild();
		this.childBox.refresh();
		dispatchEvent(e);
	}
}