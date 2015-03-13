package tinyaxe.ui.custom;

import tinyaxe.ui.custom.event.PageEvent;
import openfl.events.MouseEvent;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.Widget;

/**
 * @time 2013/10/18 10:14:45
 * @author Hoothin
 */
class PageCount extends Widget{

	public var leftBtn:Button;
	public var rightBtn:Button;
	public var numTextFiled:Text;
	private var curPage:Int;
	private var maxPage:Int;
	
	public function new() {
		super();
		mouseEnabled = false;
		curPage = 1;
		maxPage = 1;
		this.w = 60;
		this.h = 15;
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public function onCreate():Void {
		numTextFiled = UIBuilder.create(Text, {
			text  : '1/1',
			w     : 35,
			x     : 13,
			h     : this.h,
			align : 'center,middle'
		});
		numTextFiled.label.selectable = false;
		addChild(numTextFiled);
		leftBtn = UIBuilder.create(Button, {
			left  : 0,
			top   : 2,
			w     : 12,
			h     : this.h
		});
		addChild(leftBtn);
		rightBtn = UIBuilder.create(Button, {
			right : 0,
			top   : 2,
			w     : 12,
			h     : this.h
		});
		addChild(rightBtn);
		
		leftBtn.addEventListener(MouseEvent.CLICK, onLeftBtnHandler);
		rightBtn.addEventListener(MouseEvent.CLICK, onRightBtnHandler);
	}
	
	public function getPage():Int {
		return curPage;
	}
	
	public function setPage(val:Int, ?dispatch:Bool = false):Void {
		curPage = val;
		this.numTextFiled.text = Std.string(curPage) + "/" + Std.string(maxPage);
		if (dispatch) {
			dispatchEvent(new PageEvent(PageEvent.PAGE_CHANGE, curPage));
		}
	}
	
	public function getMax():Int {
		return maxPage;
	}
	
	public function setMax(val:Int):Void {
		maxPage = val;
		this.numTextFiled.text = Std.string(curPage) + "/" + Std.string(maxPage);
		if (curPage > maxPage) {
			setPage(maxPage);
			dispatchEvent(new PageEvent(PageEvent.PAGE_CHANGE, curPage));
		}
	}
	
	public function setText(val:String):Void {
		this.numTextFiled.text = val;
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
	private function onLeftBtnHandler(evt:MouseEvent):Void {
		if (curPage < 2) return;
		setPage(curPage - 1);
		dispatchEvent(new PageEvent(PageEvent.PAGE_CHANGE, curPage));
	}
	
	private function onRightBtnHandler(evt:MouseEvent):Void {
		if (curPage > maxPage - 1) return;
		setPage(curPage + 1);
		dispatchEvent(new PageEvent(PageEvent.PAGE_CHANGE, curPage));
	}
	
}