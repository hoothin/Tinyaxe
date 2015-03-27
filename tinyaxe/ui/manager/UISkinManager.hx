package tinyaxe.ui.manager;

import tinyaxe.resource.enums.ResTypeEnum;
import tinyaxe.resource.ResourceManager;
import tinyaxe.resource.xml.SkinConfigXml;
import tinyaxe.resource.xml.SkinConfigXml.SkinConfigXmlVO;
import tinyaxe.resource.xml.TextureAtlasXmlVO;
import tinyaxe.resource.XmlConfigManager;
import tinyaxe.ui.manager.skin.InitSkinTask;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import ru.stablex.ui.skins.Img;
import ru.stablex.ui.skins.Skin;
import ru.stablex.ui.skins.Slice3;
import ru.stablex.ui.skins.Slice9;
import ru.stablex.ui.skins.Tile;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.Widget;

/**
 * ...
 * @author Hoothin
 */
class UISkinManager {
	private static var _uiSkinManager:UISkinManager;
	public static function getInstance():UISkinManager {
		if (_uiSkinManager == null) {
			_uiSkinManager = new UISkinManager();
		}
		
		return _uiSkinManager;
	}
	
	private var _skinMap:Map<String, Skin>;
	private var _skinPackageNameList:Array<String>;
	
	private var _skinTaskList:Array<InitSkinTask>;
	private var _currentSkinTask:InitSkinTask;
	
	private var _skinUrlList:Array<String>;
	private var _xmlUrlList:Array<String>;
	private var _textureAtlasMap:Map<String, TextureAtlasXmlVO>;
	
	public function new() {
		this._skinMap = new Map<String, Skin>();
		this._skinTaskList = new Array<InitSkinTask>();
		
		this._skinPackageNameList = new Array<String>();
		this._currentSkinTask = null;
		this._textureAtlasMap = new Map();
	}
	
	public function initSkinTemplate(skinNameList:Array<String>, ?callBackFunc:Void->Void = null):Int {
		var filterSkinNameList:Array<String> = this.filterSkinName(skinNameList);
		if (filterSkinNameList.length >= 0) {
			var newSkinTask:InitSkinTask = new InitSkinTask();
			for (skinName in filterSkinNameList) {
				newSkinTask.addSkinName(skinName);
			}
			if (callBackFunc != null) {
				newSkinTask.setCallBackFunc(callBackFunc);
			}
			this._skinTaskList.push(newSkinTask);
			this.beginSkinTask();
		}
		return skinNameList.length;
	}
	
	private function beginSkinTask():Void {
		if (this._currentSkinTask == null && this._skinTaskList.length == 0) {
			return;
		}
		if (this._currentSkinTask == null) {
			this._currentSkinTask = this._skinTaskList.shift();
			this._skinUrlList = new Array<String>();
			this._xmlUrlList = new Array<String>();
			for (skinName in this._currentSkinTask.skinNameList) {
				var skinXmlVO:SkinConfigXmlVO = XmlConfigManager.getXmlVO(SkinConfigXml).getVO(skinName);
				var hasUrl:Bool = false;
				var skinSrc:String = "piecePool/" + skinName;
				if (skinXmlVO != null && skinXmlVO.skinSrc != "") {
					skinSrc = skinXmlVO.skinSrc;
				}
				for (urlName in this._skinUrlList) {
					if (urlName == "assets/ui/" + skinSrc + ".png") {
						hasUrl = true;
						break;
					}
				}
				if (hasUrl == false) {
					this._skinUrlList.push("assets/ui/" + skinSrc + ".png");
					if (skinXmlVO != null && skinXmlVO.skinSrc != "") {
						this._xmlUrlList.push("assets/xml/texture/" + skinSrc + ".xml");
					}
				}
			}
			ResourceManager.prepareRes(this._skinUrlList, ResTypeEnum.ResTypeImage, skinPrepareComplete, true);
		}
	}
	
	private function skinPrepareComplete():Void {
		ResourceManager.prepareRes(this._xmlUrlList, ResTypeEnum.ResTypeXml, texturePrepareComplete);
	}
	
	private function texturePrepareComplete():Void {
		for (skinName in this._currentSkinTask.skinNameList) {
			var skinXmlVO:SkinConfigXmlVO = XmlConfigManager.getXmlVO(SkinConfigXml).getVO(skinName);
			var skinSrc:String = "piecePool/" + skinName;
			if (skinXmlVO != null && skinXmlVO.skinSrc != "") {
				skinSrc = skinXmlVO.skinSrc;
			}
			var skinBitmapData:BitmapData = ResourceManager.getImgBitmapData("assets/ui/" + skinSrc + ".png");
			if (skinBitmapData == null) continue;
			if (skinXmlVO == null) {
				var imgSkin:Img = new Img();
				imgSkin.bitmapData = skinBitmapData;
				this._skinMap.set(skinName, imgSkin);
				continue;
			}
			var finalBitmapData:BitmapData = skinBitmapData;
			if (skinXmlVO != null && skinXmlVO.skinSrc != "") {
				var skinXml:Xml = ResourceManager.getXmlData("assets/xml/texture/" + skinSrc + ".xml");
				var textureVO:TextureAtlasXmlVO = _textureAtlasMap.get(skinSrc);
				if (textureVO == null) {
					textureVO = new TextureAtlasXmlVO();
					textureVO.initByXml(skinXml);
					_textureAtlasMap.set(skinSrc, textureVO);
				}
				for (sprite in textureVO.spriteList) {
					if (sprite.id == (skinXmlVO.skinName + ".png")) {
						finalBitmapData = new BitmapData(sprite.w, sprite.h);
						finalBitmapData.lock();
						finalBitmapData.copyPixels(skinBitmapData, new Rectangle(sprite.x, sprite.y, sprite.w, sprite.h), new Point());
						finalBitmapData.unlock();
					}
				}
			}
			
			if (skinXmlVO.slice9List.length == 4) {
				var slice9Skin:Slice9 = new Slice9();
				slice9Skin.smooth = skinXmlVO.smooth;
				slice9Skin.slice = skinXmlVO.slice9List;
				slice9Skin.bitmapData = finalBitmapData;
				this._skinMap.set(skinXmlVO.skinName, slice9Skin);
			}else if (skinXmlVO.slice9List.length == 2) {
				var sliceSkin:Slice3 = new Slice3();
				sliceSkin.smooth = skinXmlVO.smooth;
				sliceSkin.stretch = false;
				sliceSkin.slice = skinXmlVO.slice9List;
				sliceSkin.bitmapData = finalBitmapData;
				this._skinMap.set(skinXmlVO.skinName, sliceSkin);
			}else {
				if (skinXmlVO.tileList.length > 0) {
					var tileSkin:Tile = new Tile();
					tileSkin.corners = skinXmlVO.tileList;
					tileSkin.bitmapData = finalBitmapData;
					this._skinMap.set(skinXmlVO.skinName, tileSkin);
				}else {
					var imgSkin:Img = new Img();
					imgSkin.bitmapData = finalBitmapData;
					this._skinMap.set(skinXmlVO.skinName, imgSkin);
				}
			}
		}
		if (this._currentSkinTask.callbackFunc != null) {
			this._currentSkinTask.callbackFunc();
		}
		this._currentSkinTask = null;
		this.beginSkinTask();
	}
	
	private function filterSkinName(skinNameList:Array<String>):Array<String> {
		var filterSkinNameList:Array<String> = new Array<String>();
		for (skinName in skinNameList) {
			var hasName:Bool = this._skinMap.exists(skinName);
			if (!hasName) {
				for (skinTask in this._skinTaskList) {
					for (taskSkinName in skinTask.skinNameList) {
						if (taskSkinName == skinName) {
							hasName = true;
							break;
						}
					}
				}
			}
			if (hasName == false) {
				filterSkinNameList.push(skinName);
			}
		}
		return filterSkinNameList;
	}
	
	public function getSkinByName(skinName:String):Skin {
		return this._skinMap[skinName];
	}
	
	public function setSkinByName(skinWidget:Widget, skinName:String, ?skinField:String = "skin"):Void {
		if (this._skinMap[skinName] != null) {
			Reflect.setField(skinWidget, skinField, this._skinMap[skinName]);
			if (Std.is(skinWidget, Button)) {
				var btn:Button = cast(skinWidget, Button);
				btn.label.selectable = btn.label.mouseEnabled = false;
			}
			skinWidget.applyLayout();
			skinWidget.applySkin();
		}
	}
}