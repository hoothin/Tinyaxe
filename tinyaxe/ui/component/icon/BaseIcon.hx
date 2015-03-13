package tinyaxe.ui.component.icon;

import motion.Actuate;
import motion.easing.Back;
import openfl.events.MouseEvent;
import openfl.geom.ColorTransform;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.Widget;
import tinyaxe.ui.component.BaseComponent;
import tinyaxe.ui.component.icon.event.IconEvent;
import tinyaxe.ui.enums.UISkinNameEnum;
import tinyaxe.ui.manager.NoticeIconManager;
import tinyaxe.ui.manager.UISkinManager;
import tinyaxe.utility.GameFilterEnum;
import tinyaxe.utility.TextFormatEnum;

/**
 * @time 2014/4/15 9:55:22
 * @author Hoothin
 */
class BaseIcon extends BaseComponent{

	var count:Int = 0;
	var msgArr:Array<Dynamic>;
	public function new() {
		super();
		this.msgArr = [];
		this._skinResList = 
		[UISkinNameEnum.COUNT_BG
		];
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public function init():Void {
		this._uiComponent = UIBuilder.buildFn("ui/icon/MsgIcon.xml")();
		this.addChild(this._uiComponent);
		this.buttonMode = true;
		this.addEventListener(MouseEvent.CLICK, clickIconHandler);
		this.getCountBg().visible = false;
		this.getCountText().format = TextFormatEnum.normalUnitTextFormat;
		this.getCountText().refresh();
		this.getCountText().label.filters = [GameFilterEnum.wordGlowFilter];
		super.init();
	}
	
	public function addMsg(msg:Dynamic):Void {
		if (this.count == 0) {
			NoticeIconManager.getInstance().addToBottom(this);
		}else {
			this.transform.colorTransform = new ColorTransform();
			Actuate.transform(this, .2).color(0xFFFFFF, 0.1).ease(Back.easeInOut).onComplete(blinkComplete);
		}
		if (isContainsMsg(msg)) return;
		msgArr.push(msg);
		this.count++;
		if (count > 1) {
			this.getCountBg().visible = true;
		}
		this.getCountText().text = Std.string(count);
	}
	
	public function getCountBg():Widget {
		return this._uiComponent.getChildAs("CountBg", Widget);
	}
	
	public function getCountText():Text {
		return this._uiComponent.getChildAs("CountText", Text);
	}
	
	public function getIconBg():Button {
		return this._uiComponent.getChildAs("IconBg", Button);
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	override private function skinLoadComplete():Void {
		super.skinLoadComplete();
		UISkinManager.getInstance().setSkinByName(this.getCountBg(), UISkinNameEnum.COUNT_BG);
	}
	
	private function isContainsMsg(msg:Dynamic):Bool {
		return false;
	}
	
	private function afterClick(msg:Dynamic):Void {
		
	}
	
	private function blinkComplete():Void {
		Actuate.transform(this, .2).color(0xFFFFFF, 0).ease(Back.easeOut);
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function clickIconHandler(e:MouseEvent):Void {
		this.count--;
		if (count <= 1) {
			if (count <= 0) {
				this.count = 0;
				NoticeIconManager.getInstance().removeFromBottom(this);
			}
			this.getCountBg().visible = false;
		}
		this.getCountText().text = Std.string(count);
		var msg:Dynamic = msgArr.shift();
		dispatchEvent(new IconEvent(IconEvent.CLICK_ICON, msg));
		this.afterClick(msg);
	}
}