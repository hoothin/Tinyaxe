package tinyaxe.ui.popup;
import tinyaxe.layer.LayerManager;
import tinyaxe.ui.enums.UISkinNameEnum;
import tinyaxe.ui.manager.UISkinManager;
import tinyaxe.utility.GameFilterEnum;
import tinyaxe.utility.I18n;
import tinyaxe.utility.TextFilterEnum;
import tinyaxe.utility.TextFormatEnum;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Lib;
import motion.Actuate;
import motion.easing.Quad;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.HBox;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.VBox;
import ru.stablex.ui.widgets.Widget;

/**
 * @time 2013/12/3 15:08:59
 * @author Hoothin
 */
class AlertWindow extends BasePopUpWindow{

	public static inline var OK:Int = 1;
	public static inline var CANCEL:Int = 2;
	static var _alertWindow:AlertWindow;
	private var callBackFunction:Int->Void;
	private var alertAddBody:Widget;
	private var componentAdded:Bool;
	public function new() {
		super();
		this._skinResList = this._skinResList.concat( [
			UISkinNameEnum.BTN_CLICK,
			UISkinNameEnum.BTN_NORMAL
		]);
		this._windowName ="ALERT_WINDOW";
		this._showLoading = false;
		this.componentAdded = false;
		this._uiFrame = UIBuilder.buildFn('ui/Alert.xml')();
		this.addChild(this._uiFrame);
		this.getAlertText().format = TextFormatEnum.textFormat2;
		this.getAlertText().refresh();
		this.getAlertText().label.filters = [TextFilterEnum.hongse250000];
		this.getOkBtn().format = TextFormatEnum.xiaohuangzi14;
		this.getOkBtn().refresh();
		this.getOkBtn().label.filters = [TextFilterEnum.miaobian340000];
		this.getCancerBtn().format = TextFormatEnum.xiaohuangzi14;
		this.getCancerBtn().refresh();
		this.getCancerBtn().label.filters =[TextFilterEnum.miaobian340000];
		this.getOkBtn().addEventListener(MouseEvent.CLICK, onBtnClickHandler);
		this.getCancerBtn().addEventListener(MouseEvent.CLICK, onBtnClickHandler);
		this._uiFrame.closeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHandler);
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/	
	public static function getInstance():AlertWindow {
		if (_alertWindow == null) {
			_alertWindow = new AlertWindow();
		}
		
		return _alertWindow;
	}
	
	public function addComponent(component:Widget, index:Int):Void {
		if (alertAddBody != null || index < 1 || index > 3) return;
		alertAddBody = component;
		var box:VBox = this._uiFrame.getChildAs("BoxIndex" + index, VBox);
		box.addChild(component);
		box.refresh();
		this._uiFrame.refresh();
		this.componentAdded = true;
	}
	
	public function showAlert(msg:String, callBackFunction:Int->Void = null, okBtn:String = "", cancerBtn:String = "", title:String = "", showMask:Bool = true):Void {
		if (!componentAdded) {
			if (alertAddBody != null) {
				this.alertAddBody.parent.removeChild(alertAddBody);
				this.alertAddBody = null;
				this._uiFrame.refresh();
			}
		}
		this.componentAdded = false;
		this.alpha = 0.5;
		Actuate.tween(this, 0.1, { alpha:1 }, true).ease(Quad.easeIn);
		this.visible = false;
		if (!_isOpen) {
			this._isOpen = true;
			Lib.current.stage.addEventListener(Event.RESIZE, resizeHandler);
			if (this._uiFrame != null) {
				this._uiFrame.title.format = TextFormatEnum.normalUnitTextFormat;
				this._uiFrame.title.refresh();
				this._uiFrame.title.label.filters = [GameFilterEnum.wordGlowFilter];
				this._uiFrame.titleText = title == ""?I18n.str("ALERT_WINDOW"):title;
				this._uiFrame.closeBtn.addEventListener(MouseEvent.CLICK, closeBtnClick);
				this._windowName = title == ""?"ALERT_WINDOW":title;
				super.init();
			}else {
				this.initSkinRes();
			}
			LayerManager.getInstance().addChildObj(this.maskBG, LayerManager.ALERT_LAYER);
			LayerManager.getInstance().addChildObj(this, LayerManager.ALERT_LAYER);
		}
		this.maskBG.visible = showMask;
		this.setMaskBG(showMask);
		this.callBackFunction = callBackFunction;
		this.getAlertText().label.htmlText = msg;
		this.getAlertText().refresh();
		this.getAlertText().label.htmlText = msg;
		this.getAlertText().h = this.getAlertText().label.height + 15;
		if (msg == "") {
			this.getAlertText().visible = false;
		}else {
			this.getAlertText().visible = true;
		}
		this.getOkBtn().text = okBtn == ""?I18n.str("ok"):okBtn;
		this.getCancerBtn().text = cancerBtn;
		if (cancerBtn == "") {
			this.getCancerBtn().visible = false;
		}else {
			this.getCancerBtn().visible = true;
		}
		this.getBtnBox().refresh();
		this.getAlertBody().refresh();
		this._uiFrame.h = this.getAlertBody().h + 95;
		this.x = (Lib.current.stage.stageWidth - this._uiFrame.w) / 2;
		this.y = (Lib.current.stage.stageHeight - this._uiFrame.h) / 2;
	}
	
	public function getAlertText():Text {
		return this._uiFrame.getChildAs("AlertText", Text);
	}
	
	public function getOkBtn():Button {
		return this._uiFrame.getChildAs("OkBtn", Button);
	}
	
	public function getCancerBtn():Button {
		return this._uiFrame.getChildAs("CancerBtn", Button);
	}
	
	public function getBoxIndex1():VBox {
		return this._uiFrame.getChildAs("BoxIndex1", VBox);
	}
	
	public function getBoxIndex2():VBox {
		return this._uiFrame.getChildAs("BoxIndex2", VBox);
	}
	
	public function getBoxIndex3():VBox {
		return this._uiFrame.getChildAs("BoxIndex3", VBox);
	}
	
	public function getAlertBody():VBox {
		return this._uiFrame.getChildAs("AlertBody", VBox);
	}
	
	public function getBtnBox():HBox {
		return this._uiFrame.getChildAs("BtnBox", HBox);
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	override private function skinLoadComplete():Void {
		super.skinLoadComplete();
		this.visible = true;
		UISkinManager.getInstance().setSkinByName(this.getOkBtn(), UISkinNameEnum.BTN_NORMAL);
		UISkinManager.getInstance().setSkinByName(this.getOkBtn(), UISkinNameEnum.BTN_CLICK, "skinPressed");
		UISkinManager.getInstance().setSkinByName(this.getOkBtn(), UISkinNameEnum.BTN_CLICK, "skinHovered");
		UISkinManager.getInstance().setSkinByName(this.getCancerBtn(), UISkinNameEnum.BTN_NORMAL);
		UISkinManager.getInstance().setSkinByName(this.getCancerBtn(), UISkinNameEnum.BTN_CLICK, "skinPressed");
		UISkinManager.getInstance().setSkinByName(this.getCancerBtn(), UISkinNameEnum.BTN_CLICK, "skinHovered");
		//UISkinManager.getInstance().setSkinByName(this.getAlertText(), UISkinNameEnum.TEXT_BG);
		//UISkinManager.getInstance().setSkinByName(this.getAlertBody(), UISkinNameEnum.THIN_FRAME);
		UISkinManager.getInstance().setSkinByName(this._uiFrame.closeBtn, UISkinNameEnum.CLOSE_BTN_NORMAL);
		UISkinManager.getInstance().setSkinByName(this._uiFrame.closeBtn, UISkinNameEnum.CLOSE_BTN_CLICK, "skinPressed");
		UISkinManager.getInstance().setSkinByName(this._uiFrame.closeBtn, UISkinNameEnum.CLOSE_BTN_CLICK, "skinHovered");
		UISkinManager.getInstance().setSkinByName(this._uiFrame, UISkinNameEnum.WINDOW_BG);
		UISkinManager.getInstance().setSkinByName(this._uiFrame.titleBgBar, UISkinNameEnum.TITLE_BG);
	}
	
	private function onBtnClickHandler(e:MouseEvent):Void {
		this._isClosing = false;
		this._isOpen = false;
		this.visible = false;
		Lib.current.stage.removeEventListener(Event.RESIZE, resizeHandler);
		this.maskBG.visible = false;
		if (alertAddBody != null) {
			this.alertAddBody.parent.removeChild(alertAddBody);
			this.alertAddBody = null;
			this._uiFrame.refresh();
		}
		if (callBackFunction != null) {
			if(e.currentTarget == this.getOkBtn()) {
				callBackFunction(AlertWindow.OK);
			}else {
				callBackFunction(AlertWindow.CANCEL);
			}
		}
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function resizeHandler(e:Event):Void {
		this.x = Std.int((Lib.current.stage.stageWidth - this._uiFrame.w) / 2);
		this.y = Std.int((Lib.current.stage.stageHeight - this._uiFrame.h) / 2);
	}
}