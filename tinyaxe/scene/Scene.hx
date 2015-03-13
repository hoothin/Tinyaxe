package tinyaxe.scene ;

import tinyaxe.animation.EnterFrameManager;
import tinyaxe.animation.frame.FrameSprite;
import tinyaxe.manager.TestManager;
import tinyaxe.scene.BaseActor.ActorType;
import tinyaxe.utility.ShortCutsKey;
import tinyaxe.utility.TextFormatEnum;
import tinyaxe.utility.TimeKeeper;
import openfl.display.DisplayObjectContainer;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.filters.GlowFilter;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.tiled.TiledMap;
import openfl.ui.Keyboard;

/**
 * @time 2014/12/22 19:52:27
 * @author Hoothin
 */
class Scene extends FrameSprite {

	public var objContainer:DisplayObjectContainer;
	static var scene:Scene;
	static var SHOW_WIDTH:Int = 800;
	static var SHOW_HEIGHT:Int = 480;
	static var GAP:Int = 60;
	var bgContainer:Sprite;
	var me:BaseActor;
	var isMouseDown:Bool;
	var queueList:Array<BaseActor>;
	var enemyList:Array<BaseActor>;
	var bgShape:Shape;
	var tiledMap:TiledMap;
	var totalHeight:Int;
	var totalWidth:Int;
	var isInDrag:Bool;
	var scoreText:TextField;
	var score:Int;
	public function new() {
		super();
		this.bgContainer = new Sprite();
		this.me = new BaseActor(ActorType.ME);
		this.me.initAnimation("rifle_female");
		this.me.scaleX = this.me.scaleY = .3;
		this.isMouseDown = false;
		this.isInDrag = false;
		this.me.x = 400;
		this.me.y = 240;
		
		this.score = 0;
		this.scoreText = new TextField();
		this.scoreText.mouseEnabled = false;
		this.scoreText.autoSize = TextFieldAutoSize.LEFT;
		this.scoreText.defaultTextFormat = TextFormatEnum.bigUITextFormat;
		this.scoreText.text = "Score:0 \n"+Lib.current.stage.stageWidth+"\n"+Lib.current.stage.stageHeight;
		this.scoreText.x = Lib.current.stage.stageWidth - 80;
		this.scoreText.y = 10;
		
		this.queueList = [];
		this.enemyList = [];
		
		bgShape = new Shape();
		bgShape.graphics.beginFill(0x000000, 0);
		bgShape.graphics.drawRect(0, 0, SHOW_WIDTH, SHOW_HEIGHT);
		bgShape.graphics.endFill();
		this.addChild(bgShape);
		this.addChild(bgContainer);
		this.scrollRect = new Rectangle(0, 0, SHOW_WIDTH, SHOW_HEIGHT);
		this.width = Lib.current.stage.stageWidth;
		this.height = Lib.current.stage.stageHeight;
	}

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public static function getInstance():Scene {
		if (scene == null) {
			scene = new Scene();
		}
		return scene;
	}
	
	public function init():Void {
		TimeKeeper.addTimerEventListener(randomAddNpc, 3000);
		this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		Lib.current.addEventListener(MouseEvent.MOUSE_UP, mouseOnMeUpHandler);
		Lib.current.addEventListener(MouseEvent.MOUSE_MOVE, mouseOnMeMoveHandler);
		this.me.addEventListener(MouseEvent.MOUSE_DOWN, mouseOnMeDownHandler);
		this.register();
		Lib.current.addChild(this);
		this.tiledMap = TiledMap.fromAssets("assets/isometric_grass_and_water.tmx");
		this.bgContainer.addChild(tiledMap);
		objContainer = null;
		//没有边界的话
		tiledMap.x = tiledMap.totalWidth / 2;
		totalWidth = tiledMap.totalWidth;
		totalHeight = tiledMap.totalHeight;
		#if !flash
		for (i in 0...tiledMap.layers.length) {
			var layerName:String = tiledMap.layers[i].name;
			if (layerName == "Ground") {
				objContainer = cast(tiledMap.getChildAt(i));
			}else if (layerName == "") {
				
			}
		}
		#else
		objContainer = this.bgContainer;
		#end
		if (objContainer == null) objContainer = this.bgContainer;
		objContainer.addChild(me);
		this.queueList.push(me);
		for (i in 0...2) {
			var servitor:BaseActor = new BaseActor(ActorType.NPC);
			var preActor:BaseActor = this.queueList[this.queueList.length - 1];
			servitor.x = preActor.x + GAP;
			servitor.y = preActor.y;
			queueList.push(servitor);
			servitor.initAnimation("rifle_female");
			servitor.scaleX = servitor.scaleY = .3;
			objContainer.addChild(servitor);
		}
		
		Lib.current.addChild(scoreText);
	}
	
	public function getMe():Sprite {
		return me;
	}
	
	override public function enterFrameProcess():Void {
		super.enterFrameProcess();
		for (bullet in Bullet.bulletArr.copy()) {
			var realLoc:Point = new Point(bullet.x + bgContainer.x, bullet.y + bgContainer.y);
			if (realLoc.x < 0 || realLoc.x > Lib.current.stage.stageWidth || realLoc.y < 0 || realLoc.y > Lib.current.stage.stageHeight) {
				bullet.destroy();
			}
			if (bullet.type == Bullet.ENEMY) {
				for (actor in queueList.copy()) {
					if (bullet.hitTestObject(actor)) {
						if (actor == me) {
							EnterFrameManager.getInstance().stop();
							TimeKeeper.closeListener();
							for (bullet in Bullet.bulletArr.copy()) {
								bullet.destroy();
							}
							this.mouseEnabled = false;
							TestManager.getInstance().endGame();
							score = 0;
							scoreText.text = "Score:" + score;
							return;
						}
						bullet.destroy();
						actor.destroy();
						queueList.remove(actor);
					}
				}
			}else if (bullet.type == Bullet.FRIEND) {
				for (enemy in enemyList.copy()) {
					if (bullet.hitTestObject(enemy)) {
						bullet.destroy();
						enemy.destroy();
						enemyList.remove(enemy);
						score++;
						scoreText.text = "Score:" + score;
					}
				}
			}
		}
		if (isMouseDown) {
			var distanceX:Float = this.bgContainer.mouseX - me.x;
			var distanceY:Float = this.bgContainer.mouseY - me.y;
			var modulus:Float = 5 / Math.sqrt(distanceX * distanceX + distanceY * distanceY);
			distanceX *= modulus;
			distanceY *= modulus;
			move(distanceX, distanceY);
		}
		if (enemyList.length > 0) {
			for (actor in queueList) {
				var target:BaseActor = null;
				for (enemy in enemyList) {
					if (enemy.visible) {
						if (target == null) {
							target = enemy;
						}else {
							if (Point.distance(new Point(target.x, target.y), new Point(actor.x, actor.y)) > Point.distance(new Point(enemy.x, enemy.y), new Point(actor.x, actor.y))) {
								target = enemy;
							}
						}
					}
				}
				actor.fire(target);
			}
		}
		
		for (enemy in enemyList) {
			if (enemy.visible) {
				enemy.fire(me);
			}
		}
		var actorList:Array<BaseActor> = enemyList.concat(queueList);
		actorList.sort(function(a, b) return Reflect.compare(a.y, b.y));
		for (actor in actorList) {
			var realLoc:Point = new Point(actor.x + bgContainer.x, actor.y + bgContainer.y);
			if (realLoc.x < 0 || realLoc.x > Lib.current.stage.stageWidth || realLoc.y < 0 || realLoc.y > Lib.current.stage.stageHeight) {
				actor.stop();
			}else {
				actor.start();
			}
			objContainer.addChild(actor);
		}
		arrangeNpc();
	}
	
	public function goOn():Void {
		EnterFrameManager.getInstance().init();
		TimeKeeper.openListener();
		for (i in 0...2) {
			if (queueList.length > 2) break;
			var servitor:BaseActor = new BaseActor(ActorType.NPC);
			var preActor:BaseActor = this.queueList[this.queueList.length - 1];
			servitor.x = preActor.x + GAP;
			servitor.y = preActor.y;
			queueList.push(servitor);
			servitor.initAnimation("rifle_female");
			servitor.scaleX = servitor.scaleY = .3;
			objContainer.addChild(servitor);
		}
		this.mouseEnabled = true;
	}
	
	public function move(distanceX:Float, distanceY:Float) {
		for (actor in queueList) {
			actor.move(distanceX, distanceY);
		}
		bgMove(distanceX, distanceY);
	}
	
	public function stopAction():Void {
		for (actor in queueList) {
			actor.changeAction("standby");
		}
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	private function arrangeNpc():Void {
		for (i in 1...queueList.length) {
			var preActor:BaseActor = this.queueList[i - 1];
			var curActor:BaseActor = this.queueList[i];
			var distance:Float = Point.distance(new Point(curActor.x, curActor.y), new Point(preActor.x, preActor.y));
			if (distance > GAP) {
				var ratio:Float = GAP / distance;
				curActor.x = preActor.x - (ratio * (preActor.x - curActor.x));
				curActor.y = preActor.y - (ratio * (preActor.y - curActor.y));
			}
		}
	}
	
	private function bgMove(meMoveX:Float, meMoveY:Float):Void {
		var vx:Float = meMoveX;
		var vy:Float = meMoveY;
		var standardX:Float = this.me.x + this.bgContainer.x;
		var standardY = this.me.y + this.bgContainer.y;
		var stageWidth:Int = SHOW_WIDTH;
		var stageHeight:Int = SHOW_HEIGHT;
		
		if (standardX >= stageWidth / 2 && vx <= 0) {
			vx = 0;
		}else if (standardX <= stageWidth / 2 && vx >= 0) {
			vx = 0;
		}else if (!(standardX <= stageWidth / 2 && vx <= 0) && 
		!(standardX >= stageWidth / 2 && vx >= 0)) {
			vx = 0;
		}
		if (standardY >= stageHeight / 2 && vy <= 0) {
			vy = 0;
		}else if (standardY <= stageHeight / 2 && vy >= 0) {
			vy = 0;
		}else if (!(standardY <= stageHeight / 2 && vy <= 0) && 
		!(standardY >= stageHeight / 2 && vy >= 0)) {
			vy = 0;
		}
		
		if (bgContainer.x >= vx) {
			vx = 0;
		}else if (bgContainer.x <= -this.tiledMap.totalWidth + vx + SHOW_WIDTH) {
			vx = 0;
		}
		if (bgContainer.y >= vy) {
			vy = 0;
		}else if (bgContainer.y <= -this.tiledMap.totalHeight + vy + SHOW_HEIGHT) {
			vy = 0;
		}
		bgContainer.x -= Math.round(vx);
		bgContainer.y -= Math.round(vy);
	}
	
	private function randomAddNpc(value:Float):Void {
		var maxNum:Int = Std.int(2 + 3 * Math.random());
		for (i in 0...maxNum) {
			if (enemyList.length > 1) return;
			var sideType:Int = Std.int(Math.random() * 4);
			var localPosition:Point = new Point();
			switch(sideType) {
				case 0://上边
					localPosition = bgContainer.globalToLocal(new Point(Math.random() * Lib.current.stage.stageWidth, Math.random() * 20));
				case 1://下边
					localPosition = bgContainer.globalToLocal(new Point(Math.random() * Lib.current.stage.stageWidth, Lib.current.stage.stageHeight - Math.random() * 20));
				case 2://左边
					localPosition = bgContainer.globalToLocal(new Point(Math.random() * 20, Math.random() * Lib.current.stage.stageHeight));
				case 3://右边
					localPosition = bgContainer.globalToLocal(new Point(Lib.current.stage.stageWidth - Math.random() * 20, Math.random() * Lib.current.stage.stageHeight));
			}
			
			var enemy:BaseActor = new BaseActor(ActorType.ENEMY);
			enemy.initAnimation("rifle_female");
			enemy.scaleX = enemy.scaleY = .3;
			enemy.x = localPosition.x;
			enemy.y = localPosition.y;
			this.enemyList.push(enemy);
			objContainer.addChild(enemy);
		}
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function mouseUpHandler(e:MouseEvent):Void {
		this.isMouseDown = false;
		this.stopAction();
	}
	
	private function mouseDownHandler(e:MouseEvent):Void {
		this.isMouseDown = true;
	}
	
	private function mouseOnMeUpHandler(e:MouseEvent):Void {
		this.me.stopDrag();
		this.isInDrag = false;
		this.stopAction();
	}
	
	private function mouseOnMeDownHandler(e:MouseEvent):Void {
		this.me.startDrag();
		this.isInDrag = true;
		e.stopPropagation();
	}
	
	private function mouseOnMeMoveHandler(e:MouseEvent):Void {
		if (isInDrag) {
			for (actor in queueList) {
				actor.changeAction("run");
			}
		}
	}
	/*-----------------------------------------------------------------------------------------
	Get/Set
	-------------------------------------------------------------------------------------------*/
	
}