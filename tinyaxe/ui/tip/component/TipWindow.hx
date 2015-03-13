package tinyaxe.ui.tip.component;

import tinyaxe.ui.component.BaseComponent;
import tinyaxe.ui.enums.UISkinNameEnum;
import tinyaxe.ui.manager.UISkinManager;
import tinyaxe.ui.tip.interfaces.ITipComponent;
import tinyaxe.ui.tip.vo.TipInfoData;
import motion.Actuate;
import motion.easing.Linear;
import openfl.display.Sprite;
import openfl.text.TextField;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Widget;

/**
 * ...
 * @author Hoothin
 */
class TipWindow extends Sprite {
	private var _tipData:TipInfoData;
	private var _boardWidget:Widget;
	private var _delaytime:Int;
	private var _tipComponent:BaseComponent;
	public function new(tipData:TipInfoData) {
		super();
		this._tipData = tipData;
		this._boardWidget = UIBuilder.create(Widget, {
			h:25,
			w:25
		});
		UISkinManager.getInstance().initSkinTemplate(["grayBg"], function(){
			UISkinManager.getInstance().setSkinByName(this._boardWidget, "grayBg");
		});
		this.addChild(this._boardWidget);
		this.initTip();
		this.mouseChildren = false;
		this.mouseEnabled = false;
	}
	
	public function startShow():Void {
		this.alpha = 0;
		this.showTipWindow();
	}
	
	public function cleanTip():Void {
		cast(this._tipComponent, ITipComponent).cleanTip();
	}
	
	public function updateTip(tipData:TipInfoData):Void {
		cast(this._tipComponent, ITipComponent).updateTip(tipData);
	}
	
	public function getWidth():Float {
		return this._boardWidget.w;
	}
	
	public function getHeight():Float {
		return this._boardWidget.h;
	}
	
	private function showTipWindow():Void {
		Actuate.tween(this, 0.2, { alpha:1 }, true).ease(Linear.easeNone);
	}
	
	private function initTip():Void {
		this._tipComponent = this._tipData.tipComponent;
		cast(this._tipComponent, ITipComponent).initTipInfo(this._tipData);
		this._boardWidget.w = this._tipComponent.getWidth();
		this._boardWidget.h = this._tipComponent.getHeight();
		this._boardWidget.applySkin();
		this.addChild(this._tipComponent);
	}
}