package tinyaxe.ui.manager;
import tinyaxe.animation.frame.FrameSprite;
import tinyaxe.animation.vo.EffectVO;
import com.core.GameCore;
import tinyaxe.layer.LayerManager;
import tinyaxe.resource.enums.ResTypeEnum;
import tinyaxe.resource.ResourceManager;
import tinyaxe.utility.TimeKeeper;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.Lib;
import openfl.display.Tilesheet;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * @time 2014/4/2 11:04:07
 * @author Hoothin
 */
class ScreenObjectManager extends FrameSprite {

	static var _screenObjectManager:ScreenObjectManager;
	var effectType:Int;
	var stageHeight:Int;
	var effectName:String;
	var showObjArr:Array<Array<Dynamic>>;
	var displayObjectPool:Array<DisplayObject>;
	var objDensity:Int;
	var initNum:Int;
	var createTime:Int;
	var minRate:Int;
	var maxRate:Int;
	var isInit:Bool;
	var objBitmapData:BitmapData;
	var tilesheet:Tilesheet;
	public function new() {
		super();
		this.showObjArr = [];
		this.displayObjectPool = [];
		this.isInit = false;
		this.createTime = 200;
		this.effectType = 0;
		Lib.current.stage.addEventListener(Event.RESIZE, resizeHandler);
		this.mouseChildren = this.mouseEnabled = false;
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public static function getInstance():ScreenObjectManager {
		if (_screenObjectManager == null) {
			_screenObjectManager = new ScreenObjectManager();
		}
		return _screenObjectManager;
	}
	
	public function startScreenEffect(effectName:String, effectType:Int = 0, initNum:Int = 20, createTime:Int = 200, minRate:Int = 3, maxRate:Int = 8):Void {
		if (this.isInit) return;
		this.isInit = true;
		LayerManager.getInstance().addChildObj(this, LayerManager.SCREEN_EFFECT_LAYER);
		this.resizeHandler(null);
		this.effectType = effectType;
		this.effectName = effectName;
		this.initNum = initNum;
		this.createTime = createTime;
		this.minRate = minRate;
		this.maxRate = maxRate;
		switch(effectType) {
			case 0:
				ResourceManager.getInstance().prepareRes(["assets/res/" + effectName + ".png"], ResTypeEnum.ResTypeImage, resPrepareComplete);
			case 1:
				this.createObject(initNum, false);
				TimeKeeper.addTimerEventListener(createObjectHandler, createTime);
				this.register();
		}
	}
	
	public function clearScreenEffect():Void {
		this.isInit = false;
		if(this.parent != null)
		this.parent.removeChild(this);
		this.unRegister();
		TimeKeeper.removeTimerEventListener(createObjectHandler);
		this.displayObjectPool = [];
		for (showObj in showObjArr) {
			if (showObj[0].parent != null) {
				showObj[0].parent.removeChild(showObj[0]);
			}
		}
		this.showObjArr = [];
		this.createTime = 200;
		this.effectType = 0;
		if (this.objBitmapData != null) {
			this.objBitmapData.dispose();
		}
		this.objBitmapData = null;
	}
	
	override public function enterFrameProcess():Void {
		super.enterFrameProcess();
		var processArr:Array<Array<Dynamic>> = showObjArr.copy();
		for (showObj in processArr) {
			if (showObj[0].y < stageHeight) {
				showObj[0].y += showObj[3];
				if (showObj[1] < showObj[2]) {
					showObj[1] += .2;
					showObj[0].x += showObj[1];
				}else if (((showObj[1] - showObj[2]) > -.2 && (showObj[1] - showObj[2]) < 0) || ((showObj[1] - showObj[2]) < .2 && (showObj[1] - showObj[2]) > 0)) {
					showObj[2] = (showObj[2] > 0? -getRandom():getRandom());
				}else {
					showObj[1] -= .2;
					showObj[0].x += showObj[1];
				}
			}else {
				this.displayObjectPool.push(showObj[0]);
				//this.removeChild(showObj[0]);
				showObjArr.remove(showObj);
			}
		}
		
		if (tilesheet != null) {
			var drawList = [];
			graphics.clear();
			var TILE_FIELDS = 9;
			var particle;
			if(showObjArr != null)
			for (i in 0...showObjArr.length) {
				particle = cast(showObjArr[i][0], DisplayObject);
				var index = i * TILE_FIELDS;
				drawList[index] = particle.x;
				drawList[index + 1] = particle.y;
				drawList[index + 3] = particle.scaleX; //Scale
				drawList[index + 4] = particle.rotation; //Rotation
				drawList[index + 5] = 0;
				drawList[index + 6] = 0;
				drawList[index + 7] = 0;
				drawList[index + 8] = 1.0; //Alpha
			}
			tilesheet.drawTiles(graphics, drawList, true,
			Tilesheet.TILE_SCALE | Tilesheet.TILE_ROTATION | Tilesheet.TILE_ALPHA | Tilesheet.TILE_RGB);
		}
	}
	
	override public function start():Void {
		if (!isInit) return;
		super.start();
		TimeKeeper.addTimerEventListener(createObjectHandler, createTime);
	}
	
	override public function stop():Void {
		super.stop();
		TimeKeeper.removeTimerEventListener(createObjectHandler);
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	private function createObjectHandler(value:Float):Void {
		if (GameCore.getInstance().fps > 27) {
			createObject(objDensity);
		}
	}
	
	private function getRandom():Int {
		return Date.now().getSeconds() % 10;
	}
	
	private function createObject(number:Int, initLoc:Bool = true):Void {
		if (effectType == 0 && objBitmapData == null) return;
		for (i in 0...number) {
			if (effectType == 0) {
				var newObj:Bitmap;
				var randomSeed:Float = Math.random();
				if (displayObjectPool.length > 0) {
					newObj = cast(displayObjectPool.shift(), Bitmap);
				}else {
					newObj = new Bitmap();
					newObj.bitmapData = objBitmapData;
					if (randomSeed < .33) {
						newObj.scaleX = 1;
						newObj.scaleY = 1;
					}else if (randomSeed < .66) {
						newObj.scaleX = .75;
						newObj.scaleY = .75;
					}else {
						newObj.scaleX = .5;
						newObj.scaleY = .5;
					}
					newObj.rotation = randomSeed * 360;
				}
				if (initLoc) {
					newObj.y = 0;
				}else {
					newObj.y = randomSeed * LayerManager.SHOW_HEIGHT;
				}
				
				newObj.x = randomSeed * LayerManager.SHOW_WIDTH;
				this.showObjArr.push([newObj, 0, randomSeed * 20 - 10, minRate + randomSeed * (maxRate - minRate)]);
				//this.addChild(newObj);
			}else {
				var newObj:EffectVO;
				
			}
		}
	}
	
	private function resPrepareComplete():Void {
		this.objBitmapData = ResourceManager.getInstance().getImgBitmapData("assets/res/" + effectName + ".png");
		this.createObject(initNum, false);
		TimeKeeper.addTimerEventListener(createObjectHandler, createTime);
		this.register();
		
		this.tilesheet = new Tilesheet(objBitmapData);
		this.tilesheet.addTileRect(new Rectangle (0, 0, objBitmapData.width, objBitmapData.height), new Point(objBitmapData.width / 2, objBitmapData.height / 2));
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function resizeHandler(e:Event):Void {
		this.stageHeight = Std.int(Lib.current.stage.stageHeight / 4 * 3);
		this.objDensity = 1 + Std.int(Lib.current.stage.stageWidth / 1000);
	}
}