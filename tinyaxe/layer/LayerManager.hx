package tinyaxe.layer;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import tinyaxe.utility.Debug;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author Hoothin
 */
class LayerManager {
	public static var MAIN_SCENE_LAYER:String = "mainSceneLayer";
	public static var SCREEN_EFFECT_LAYER:String = "screenEffectLayer";
	public static var UI_LAYER:String = "uiLayer";
	public static var ALERT_LAYER:String = "alertLayer";
	public static var LOADING_LAYER:String = "loadingLayer";
	public static var CURSOR_LAYER:String = "cursorLayer";
	public static var TIP_LAYER:String = "tipLayer";
	public var fpsClock(get, null):FPS;
	public var uiMask(get, null):Sprite;
	private static var layerManager:LayerManager;
	private var uiLayer:UILayer;
	private var alertLayer:Sprite;
	private var mainSceneLayer:Sprite;
	private var screenEffectLayer:Sprite;
	private var tipLayer:Sprite;
	private var cursorLayer:Sprite;
	private var loadingLayer:Sprite;
	private var layerMap:Map<String, DisplayObjectContainer>;
	public function new() {
		this.mainSceneLayer = new Sprite();
		this.screenEffectLayer = new Sprite();
		this.uiLayer = new UILayer();
		this.alertLayer = new Sprite();
		this.loadingLayer = new Sprite();
		this.cursorLayer = new Sprite();
		this.tipLayer = new Sprite();
		
		Lib.current.addChild(this.mainSceneLayer);
		Lib.current.addChild(this.screenEffectLayer);
		Lib.current.addChild(this.uiLayer);
		Lib.current.addChild(this.alertLayer);
		Lib.current.addChild(this.loadingLayer);
		Lib.current.addChild(this.cursorLayer);
		Lib.current.addChild(this.tipLayer);
		
		this.tipLayer.mouseEnabled = this.tipLayer.mouseChildren = false;
		this.cursorLayer.mouseEnabled = this.cursorLayer.mouseChildren = false;
		this.screenEffectLayer.mouseEnabled = this.screenEffectLayer.mouseChildren = false;
		this.loadingLayer.mouseEnabled = false;
		
		this.fpsClock = new FPS(10, 10, 0xffffff);
		this.fpsClock.mouseEnabled = false;
		if (Debug.inner) {
			Lib.current.addChild(fpsClock);
		}
		this.layerMap = new Map();
		this.layerMap[MAIN_SCENE_LAYER] = this.mainSceneLayer;
		this.layerMap[SCREEN_EFFECT_LAYER] = this.screenEffectLayer;
		this.layerMap[UI_LAYER] = this.uiLayer;
		this.layerMap[ALERT_LAYER] = this.alertLayer;
		this.layerMap[LOADING_LAYER] = this.loadingLayer;
		this.layerMap[CURSOR_LAYER] = this.cursorLayer;
		this.layerMap[TIP_LAYER] = this.tipLayer;
	}
	
	public static function getInstance():LayerManager {
		if (layerManager == null) {
			layerManager = new LayerManager();
		}
		return layerManager;
	}
	
	/**
	 * add new layer
	 * @param	layer
	 * @param	layerName
	 * @param	position layer index,if position == "" then the layer will add to top of all layer,else the layer will add under the target
	 */
	public function addChildLayer(layer:DisplayObjectContainer, layerName:String, ?position:String = ""):Void {
		var targetIndex:Int = 0;
		if (position == "") {
			targetIndex = Lib.current.getChildIndex(tipLayer) + 1;
		}else {
			var targetLayer:DisplayObjectContainer = layerMap[layerName];
			if (targetLayer != null)
				targetIndex = Lib.current.getChildIndex(targetLayer);
		}
		if (Lib.current.numChildren < targetIndex) {
			Lib.current.addChild(layer);
		}
		Lib.current.addChildAt(layer, targetIndex);
		this.layerMap[layerName] = layer;
	}
	
	public function addChildObj(child:DisplayObject, containerName:String):Void {
		var targetLayer:DisplayObjectContainer = layerMap[containerName];
		targetLayer.addChild(child);
	}
	
	function get_uiMask():Sprite {
		return this.uiLayer.maskBG;
	}
	
	function get_fpsClock():FPS {
		return fpsClock;
	}
}