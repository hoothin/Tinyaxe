package tinyaxe.animation.vo;
import tinyaxe.resource.enums.ResTypeEnum;
import tinyaxe.resource.ResourceManager;
import tinyaxe.resource.xml.ImageConfigXmlVO;
import tinyaxe.resource.xml.TextureAtlasSpriteXmlVO;
import tinyaxe.resource.xml.TextureAtlasXmlVO;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author Hoothin
 */
class EffectTemplateVO {
	public var isInitComplete(get_isInitComplete, null):Bool;
	private var _effectName:String;
	private var _effectList:Array<EffectFrameVO>;
	private var _initCompleteFuncList:Array < Void->Void > ;
	private var _isInitComplete:Bool;
	private var curSource:String;
	private var isCopying:Bool;
	private var rawBitmapData:BitmapData;
	public function new() {
		_effectList = new Array<EffectFrameVO>();
		_initCompleteFuncList = new Array < Void->Void >();
		_isInitComplete = false;
		copyPixelMap = new Map();
		curSource = "";
		isCopying = false;
	}
	
	public function initEffectTemplate(effectId:String, ?initCompleteFunc:Void->Void = null):Void {
		if (initCompleteFunc != null) {
			_initCompleteFuncList.push(initCompleteFunc);
		}
		this._effectName = effectId;
		var configXmlList:Array<String> = new Array<String>();
		configXmlList.push("assets/effect/" + this._effectName + ".xml");
		configXmlList.push("assets/xml/texture/" + this._effectName + ".xml");
		ResourceManager.prepareRes(configXmlList, ResTypeEnum.ResTypeXml, effectPrepareComplete);
	}
	
	public function getEffectFrameByIndex(index:Int):EffectFrameVO {
		return this._effectList[index];
	}
	
	public function disposeBmd():Void {
		curSource = "";
		copyPixelMap = new Map();
		if (this.rawBitmapData != null)
		this.rawBitmapData.dispose();
		this.rawBitmapData = null;
	}
	
	public function addInitFunc(initCompleteFunc:Void->Void = null):Void {
		if (initCompleteFunc != null) {
			_initCompleteFuncList.push(initCompleteFunc);
		}		
	}
	
	private function effectPrepareComplete():Void {
		var effectResList:Array<String> = new Array<String>();
		effectResList.push("assets/effect/" + this._effectName + ".png");
		ResourceManager.prepareRes(effectResList, ResTypeEnum.ResTypeImage, preparePngResComplete);
	}
	
	private function preparePngResComplete():Void {
		Lib.current.addEventListener(Event.ENTER_FRAME, preEffectComplete);
	}
	
	private function preEffectComplete(e:Event):Void {
		Lib.current.removeEventListener(Event.ENTER_FRAME, preEffectComplete);
		var effectXmlData:Xml = ResourceManager.getXmlData("assets/xml/texture/" + this._effectName + ".xml");
		var newTextureVO:TextureAtlasXmlVO = new TextureAtlasXmlVO();
		newTextureVO.initByXml(effectXmlData);
		var sourceUrl:String = "assets/effect/" + this._effectName + ".png";
		rawBitmapData = ResourceManager.getImgBitmapData(sourceUrl);
		if (rawBitmapData == null) return;
		var effectXmlData:Xml = ResourceManager.getXmlData("assets/effect/" + this._effectName + ".xml");
		for (bitmapConfig in effectXmlData.elements()) {
			var newImageConfigVO:ImageConfigXmlVO = new ImageConfigXmlVO();
			newImageConfigVO.initByXml(bitmapConfig);
			var newImageIdArr:Array<String> = newImageConfigVO.id.split(".");
			var lengthStr:String = newImageIdArr[0].substr(newImageIdArr[0].length - 4);
			var currentTextureSprite:TextureAtlasSpriteXmlVO = newTextureVO.spriteList.get(newImageConfigVO.id);
			var newEffectFrameVO:EffectFrameVO = new EffectFrameVO();
			newEffectFrameVO.initEffectConfig(newImageConfigVO);
			newEffectFrameVO.initBitmapData(rawBitmapData);
			newEffectFrameVO.setBitmapDataInfo(currentTextureSprite.x, currentTextureSprite.y, currentTextureSprite.w, currentTextureSprite.h);
			this._effectList[Std.parseInt(lengthStr) - 1] = newEffectFrameVO;
		}
		this._isInitComplete = true;
		for (initCompFunc in this._initCompleteFuncList) {
			initCompFunc();
		}
		this._initCompleteFuncList = new Array < Void->Void >();
	}
	
	function get_isInitComplete():Bool {
		return _isInitComplete;
	}
}