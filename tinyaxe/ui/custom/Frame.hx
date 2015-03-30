package tinyaxe.ui.custom;

import openfl.display.Bitmap;
import openfl.display.BlendMode;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.Widget;

/**
 * @time 2013/10/18 11:40:04
 * @author Hoothin
 */
class Frame extends Widget {
	@:isVar public var showTitle(get, set):Bool;
	public var closeAble(get_closeAble, set_closeAble):Bool;
	public var titleText(get_titleText, set_titleText):String;
	private var _titleText:String;
	private var _closeAble:Bool;
	
	public var title:Text;
	public var closeBtn:Button;
	public var titleBgBar:Widget;
	public var titleBmp:Bitmap;
	public function new() {
		super();
		_titleText = "";
		titleBgBar = UIBuilder.create(Widget, {
			top     : -28,
			w       : 474,
			mouseChildren:false,
			mouseEnabled :false
		});
		title = UIBuilder.create(Text, {
			top   : 35,
			text  : 'window',
			h     : 22,
			align : 'center,top'
		});
		closeBtn = UIBuilder.create(Button, {
			left : 10,
			top   : 10,
			w     : 16,
			h     : 14
		});
		this.titleBmp = new Bitmap();
		this.titleBmp.y = 25;
		this.title.mouseChildren = this.title.mouseEnabled = false;
		this.addChild(titleBgBar);
		this.titleBgBar.addChild(title);
		this.titleBgBar.addChild(titleBmp);
		addChild(closeBtn);
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public function onCreate():Void {
		this.titleBgBar.left = Std.int((this.w - 474) / 2);
		this.title.x = Std.int((this.titleBgBar.w - title.w) / 2);
		super.onCreate();
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	function get_closeAble():Bool {
		return _closeAble;
	}
	
	function set_closeAble(value:Bool):Bool {
		if (value) {
			addChild(closeBtn);
		}else {
			if (this.contains(closeBtn))
			removeChild(closeBtn);
		}
		return _closeAble = value;
	}
	
	function get_titleText():String {
		return _titleText;
	}
	
	function set_titleText(value:String):String {
		title.text = value;
		title.x = (this.titleBgBar.w - title.w) / 2;
		return _titleText = value;
	}
	
	function get_showTitle():Bool {
		return showTitle;
	}
	
	function set_showTitle(value:Bool):Bool {
		this.title.visible = this.titleBmp.visible = value;
		return showTitle = value;
	}
}