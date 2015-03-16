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
	public static var SHOW_WIDTH:Int = 0;
	public static var SHOW_HEIGHT:Int = 0;
	public var fpsClock(get, null):FPS;
	public var uiMask(get, null):Sprite;
	public var rootLayer(get, null):Sprite;
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
		SHOW_WIDTH = SHOW_WIDTH == 0?Lib.current.stage.stageWidth:SHOW_WIDTH;
		SHOW_HEIGHT = SHOW_HEIGHT == 0?Lib.current.stage.stageHeight:SHOW_HEIGHT;
		this.rootLayer = new Sprite();
		this.mainSceneLayer = new Sprite();
		this.screenEffectLayer = new Sprite();
		this.uiLayer = new UILayer();
		this.alertLayer = new Sprite();
		this.loadingLayer = new Sprite();
		this.cursorLayer = new Sprite();
		this.tipLayer = new Sprite();
		
		Lib.current.addChild(this.rootLayer);
		this.rootLayer.addChild(this.mainSceneLayer);
		this.rootLayer.addChild(this.screenEffectLayer);
		this.rootLayer.addChild(this.uiLayer);
		this.rootLayer.addChild(this.alertLayer);
		this.rootLayer.addChild(this.loadingLayer);
		this.rootLayer.addChild(this.cursorLayer);
		this.rootLayer.addChild(this.tipLayer);
		
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
			targetIndex = this.rootLayer.getChildIndex(tipLayer) + 1;
		}else {
			var targetLayer:DisplayObjectContainer = layerMap[layerName];
			if (targetLayer != null)
				targetIndex = this.rootLayer.getChildIndex(targetLayer);
		}
		if (this.rootLayer.numChildren < targetIndex) {
			this.rootLayer.addChild(layer);
		}
		this.rootLayer.addChildAt(layer, targetIndex);
		this.layerMap[layerName] = layer;
	}
	
	public function addChildObj(child:DisplayObject, containerName:String):Void {
		var targetLayer:DisplayObjectContainer = layerMap[containerName];
		targetLayer.addChild(child);
	}
	
	function get_rootLayer():Sprite {
		return rootLayer;
	}
	
	function get_uiMask():Sprite {
		return this.uiLayer.maskBG;
	}
	
	function get_fpsClock():FPS {
		return fpsClock;
	}
}