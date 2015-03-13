package tinyaxe.ui.popup;

import tinyaxe.framework.notification.NotificationDefine;
import tinyaxe.layer.LayerManager;
import tinyaxe.ui.custom.Frame;
import tinyaxe.resource.enums.ResTypeEnum;
import tinyaxe.resource.ResourceManager;
import tinyaxe.resource.xml.WindowConfigXml;
import tinyaxe.resource.xml.WindowConfigXml.WindowConfigXmlVO;
import tinyaxe.resource.XmlConfigManager;
import tinyaxe.ui.custom.Frame;
import tinyaxe.ui.enums.UISkinNameEnum;
import tinyaxe.ui.manager.UISkinManager;
import tinyaxe.ui.popup.interfaces.IPopUpWindow;
import tinyaxe.utility.DepthUtil;
import tinyaxe.utility.GameFilterEnum;
import tinyaxe.utility.SoundManager;
import tinyaxe.utility.TextFormatEnum;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.Lib;
import motion.Actuate;
import motion.easing.Linear;
import org.puremvc.haxe.patterns.facade.Facade;
import org.puremvc.haxe.patterns.mediator.Mediator;

/**
 * ...
 * @author Hoothin
 */
class BasePopUpWindow extends Sprite implements IPopUpWindow{
	private var _uiFrame:Frame;
	private var _skinResList:Array<String>;
	private var _windowName:String;
	private var _isOpen:Bool;
	private var _isInit:Bool;
	private var _isDrag:Bool;
	private var isShowMaskBG:Bool = false;
	private var maskBG:Sprite;
	private var _isOpening:Bool;
	private var _isClosing:Bool;
	private var _laterClose:Bool;
	private var _windowConfigXmlVO:WindowConfigXmlVO;
	private var _showLoading:Bool = true;
	private var _mediatorClass:Class<Mediator>;
	private var _windowMediator:Mediator;
	public function new() {
		super();
		this._skinResList = [
			UISkinNameEnum.CLOSE_BTN_NORMAL,
			UISkinNameEnum.CLOSE_BTN_CLICK,
			UISkinNameEnum.WINDOW_BG,
			UISkinNameEnum.TITLE_BG
		];
		this.maskBG = LayerManager.getInstance().uiMask;
		this._isOpen = false;
		this._isInit = false;
		this._isDrag = false;
		this._isOpening = false;
		this._isClosing = false;
		this._laterClose = false;
	}
	
	public function init():Void {
		this.initSkinRes();
		this._windowConfigXmlVO = XmlConfigManager.getXmlVO(WindowConfigXml).getVO(this._windowName);
		if (this._uiFrame != null) {
			this._uiFrame.addEventListener(MouseEvent.MOUSE_DOWN, startDragWindow);
			this._uiFrame.addEventListener(MouseEvent.MOUSE_UP, stopDragWindow);
			this._uiFrame.title.format = TextFormatEnum.normalUnitTextFormat;
			this._uiFrame.title.refresh();
			this._uiFrame.title.label.filters = [GameFilterEnum.wordGlowFilter];
			this._uiFrame.closeBtn.addEventListener(MouseEvent.CLICK, closeBtnClick);
			ResourceManager.prepareRes(["assets/textBmp/" + this._windowName + ".png"], ResTypeEnum.ResTypeImage, titleBmpPrepareComplete, true);
		}
		if (_showLoading && !_isInit) {
			this.beforeOpen();
			this.visible = false;
		}
	}
	
	private function beforeOpen():Void {
		
	}
	
	private function initSkinRes():Void {
		UISkinManager.getInstance().initSkinTemplate(this._skinResList, skinLoadComplete);
	}
	
	private function skinLoadComplete():Void {
		//this._isInit = true;
		UISkinManager.getInstance().setSkinByName(this._uiFrame.closeBtn, UISkinNameEnum.CLOSE_BTN_NORMAL);
		UISkinManager.getInstance().setSkinByName(this._uiFrame.closeBtn, UISkinNameEnum.CLOSE_BTN_CLICK, "skinPressed");
		UISkinManager.getInstance().setSkinByName(this._uiFrame.closeBtn, UISkinNameEnum.CLOSE_BTN_CLICK, "skinHovered");
		UISkinManager.getInstance().setSkinByName(this._uiFrame, UISkinNameEnum.WINDOW_BG);
		UISkinManager.getInstance().setSkinByName(this._uiFrame.titleBgBar, UISkinNameEnum.TITLE_BG);
	}
	
	public function initWindow(?data:Dynamic):Void {
		
	}
	
	public function openWindow():Void {
		if (this._isOpening == false && this._isClosing == false) {
			this._isOpening = true;
			if (_isInit)
			this.visible = true;
			this.x = Std.int((Lib.current.stage.stageWidth - this._uiFrame.w) / 2);
			this.y = Std.int((Lib.current.stage.stageHeight - this._uiFrame.h) / 2);
			if (isShowMaskBG == true) {
				this.maskBG.visible = true;
				LayerManager.getInstance().addChildObj(maskBG, LayerManager.UI_LAYER);
			}
			this.alpha = 0.1;
			Actuate.tween(this, 0.2, { alpha:1 }, true).ease(Linear.easeNone).onComplete(finalOpenWindow).autoVisible(false);
			SoundManager.getInstance().playSound("click");
		}
	}
	
	private function finalOpenWindow():Void {
		this._isOpening = false;
		this._isOpen = true;
		this.alpha = 1;
		if (this._laterClose == true) {
			this.closeWindow();
			this._laterClose = false;
		}
	}
	
	public function closeWindow(?closeStraight:Bool = false):Void {
		if (closeStraight) {
			finalCloseWindow();
		}else if (this._isOpening == false && this._isClosing == false) {
			this._isClosing = true;
			if (this.visible == false) {
				finalCloseWindow();
			}else {
				Actuate.tween(this, 0.2, { alpha:0.1 }, true).ease(Linear.easeNone).onComplete(finalCloseWindow);
			}
		}else {
			this._laterClose = true;
		}
	}
	
	private function finalCloseWindow():Void {
		this._isClosing = false;
		this._isOpening == false;
		this._isOpen = false;
		this.visible = false;
		
		if (_windowMediator != null) {
			Facade.getInstance().removeMediator(_windowMediator.getMediatorName());
			_windowMediator = null;
		}
		this.maskBG.visible = false;
		this.afterClose();
		Facade.getInstance().sendNotification(NotificationDefine.FINAL_CLOSE_WINDOW, null, this.windowName);
	}
	
	private function afterClose():Void {
		
	}
	
	public function destroyWindow():Void {
		this._uiFrame.free();
		this._isOpen = false;
	}
	
	public function getWidth():Float {
		return this._uiFrame.w;
	}
	
	public function getHeight():Float {
		return this._uiFrame.h;
	}
	
	public function setMaskBG(value:Bool):Void {
		this.isShowMaskBG = value;
	}
	
	private function startDragWindow(event:MouseEvent):Void {
		if (mouseX > 0 && mouseX < event.target.width && mouseY > 0 && mouseY < 30)
		this.startDrag();
		DepthUtil.bringToTop(this);
	}
	
	private function stopDragWindow(event:MouseEvent):Void {
		this.stopDrag();
		this.x = Std.int(this.x);
		this.y = Std.int(this.y);
	}
	
	public function setWindowEnabled(enabled:Bool):Void {
		this.mouseEnabled = enabled;
		this.mouseChildren = enabled;
		if (enabled) {
			this.filters = [];
		}else {
			this.filters = [GameFilterEnum.duskColorMatrixFilter];
		}
	}
	
	private function titleBmpPrepareComplete():Void {
		this._isInit = true;
		var imgBitmapData:BitmapData = ResourceManager.getImgBitmapData("assets/textBmp/" + this._windowName + ".png");
		if (imgBitmapData != null) {
			this._uiFrame.titleBmp.bitmapData = imgBitmapData;
			this._uiFrame.titleBmp.x = (this._uiFrame.titleBgBar.w - this._uiFrame.titleBmp.width) / 2;
			this._uiFrame.title.visible = false;
		}else {
			
		}
		if (_showLoading) {
			//LoadingUIManager.getInstance().hideLoadingUI();
			this.visible = true;
		}
	}
	
	private function closeBtnClick(event:MouseEvent):Void {
		//Facade.getInstance().sendNotification(NotificationDefine.CLOSE_WINDOW, false, this.windowName);
	}
	
	function get_windowName():String {
		return _windowName;
	}
	
	public var windowName(get_windowName, null):String;
	
	function get_isOpen():Bool {
		return _isOpen;
	}
	
	public var isOpen(get_isOpen, null):Bool;
	
	function get_isOpening():Bool {
		return _isOpening;
	}
	
	public var isOpening(get_isOpening, null):Bool;
	
	function get_isClosing():Bool {
		return _isClosing;
	}
	
	public var isClosing(get_isClosing, null):Bool;
	
	function get_isInit():Bool {
		return _isInit;
	}
	
	public var isInit(get_isInit, null):Bool;
	
	function get_windowConfigXmlVO():WindowConfigXmlVO {
		return _windowConfigXmlVO;
	}
	
	public var windowConfigXmlVO(get_windowConfigXmlVO, null):WindowConfigXmlVO;
	
	function get_windowMediator():Mediator {
		if (_windowMediator == null) {
			if (_mediatorClass != null) {
				_windowMediator = Type.createInstance(_mediatorClass, [Reflect.getProperty(_mediatorClass, "NAME"), this]);
			}
		}
		return _windowMediator;
	}
	
	public var windowMediator(get_windowMediator, null):Mediator;
}