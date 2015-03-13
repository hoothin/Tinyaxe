package tinyaxe.manager ;

import tinyaxe.animation.frame.FrameSprite;
import tinyaxe.framework.notification.NotificationDefine;
import openfl.display.Bitmap;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import openfl.Lib;
import openfl.ui.Multitouch;
import openfl.ui.MultitouchInputMode;
import org.puremvc.haxe.patterns.facade.Facade;

/**
 * @time 2014/12/22 17:54:39
 * @author Hoothin
 */
class OrbitControl extends FrameSprite{

	static var orbitControl:OrbitControl;
	static var CENTER_X:Int = 50;
	static var CENTER_Y:Int = 50;
	static var BALL_RADIUS:Int = 50;
	var controlBg:Bitmap;
	var orbitBall:Sprite;
	var orbitBallBmp:Bitmap;
	var callBackFun:Float->Float->Void;
	var controlID:Int;
	var touchPoint:Point;
	var multiTouchSupported:Bool;
	public function new() {
		super();
	}

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public static function getInstance():OrbitControl {
		if (orbitControl == null) {
			orbitControl = new OrbitControl();
			orbitControl.init();
		}
		return orbitControl;
	}
	
	public function addToStage(locX:Int, locY:Int, callBackFun:Float->Float->Void = null, container:DisplayObjectContainer = null):Void {
		this.stop();
		if (locX == 0) {
			this.x = 50;
		}else {
			this.x = locX;
		}
		if (locY == 0) {
			this.y = Lib.current.stage.stageHeight * 3 / 4 - 50;
		}else {
			this.y = locY;
		}
		this.callBackFun = callBackFun;
		if (container == null) {
			container = Lib.current;
		}
		container.addChild(this);
		this.width = this.height = Lib.current.stage.stageHeight / 4;
	}
	
	override public function enterFrameProcess():Void {
		super.enterFrameProcess();
		if (!multiTouchSupported) {
			touchPoint.x = this.mouseX;
			touchPoint.y = this.mouseY;
		}
		var distanceX:Float = this.touchPoint.x - CENTER_X;
		var distanceY:Float = this.touchPoint.y - CENTER_Y;
		if (Point.distance(new Point(CENTER_X, CENTER_Y), new Point(this.touchPoint.x, this.touchPoint.y)) > BALL_RADIUS) {
			var modulus:Float = BALL_RADIUS / Math.sqrt(distanceX * distanceX + distanceY * distanceY);
			distanceX *= modulus;
			distanceY *= modulus;
			this.orbitBall.x = distanceX + CENTER_X;
			this.orbitBall.y = distanceY + CENTER_Y;
		}else {
			this.orbitBall.x = this.touchPoint.x;
			this.orbitBall.y = this.touchPoint.y;
		}
		if (callBackFun != null) {
			callBackFun(distanceX, distanceY);
		}
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	private function init():Void {
		this.register();
		this.stop();
		this.controlBg = new Bitmap();
		this.orbitBall = new Sprite();
		this.orbitBall.mouseChildren = this.orbitBall.mouseEnabled = false;
		this.orbitBallBmp = new Bitmap();
		this.orbitBallBmp.x = -5;
		this.orbitBallBmp.y = -5;
		this.orbitBall.x = CENTER_X;
		this.orbitBall.y = CENTER_Y;
		this.addChild(controlBg);
		this.orbitBall.addChild(orbitBallBmp);
		this.addChild(orbitBall);
		
		this.touchPoint = new Point();
		this.multiTouchSupported = Multitouch.supportsTouchEvents;
		if (multiTouchSupported) {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			this.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		}else {
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		var bgShape:Shape = new Shape();
		bgShape.graphics.beginFill(0xffffff, .5);
		bgShape.graphics.drawCircle(CENTER_X, CENTER_X, BALL_RADIUS);
		bgShape.graphics.endFill();
		this.addChild(bgShape);
		var ballShape:Shape = new Shape();
		ballShape.graphics.beginFill(0xff0000, .9);
		ballShape.graphics.drawCircle(0, 0, 5);
		ballShape.graphics.endFill();
		this.orbitBall.addChild(ballShape);
		this.addChild(orbitBall);
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function mouseDownHandler(e:MouseEvent):Void {
		this.start();
	}
	
	private function onTouchBegin(e:TouchEvent):Void {
		this.controlID = e.touchPointID;
		this.touchPoint.x = e.stageX - this.x;
		this.touchPoint.y = e.stageY - this.y;
		this.start();
	}
	
	private function onTouchEnd(e:TouchEvent):Void {
		if (this.controlID != e.touchPointID) return;
		this.stop();
		this.orbitBall.x = CENTER_X;
		this.orbitBall.y = CENTER_Y;
		Facade.getInstance().sendNotification(NotificationDefine.CONTROL_END);
	}
	
	private function mouseUpHandler(e:MouseEvent):Void {
		this.stop();
		this.orbitBall.x = CENTER_X;
		this.orbitBall.y = CENTER_Y;
		Facade.getInstance().sendNotification(NotificationDefine.CONTROL_END);
	}
	
	private function onTouchMove(e:TouchEvent):Void {
		if (this.controlID != e.touchPointID) return;
		this.touchPoint.x = e.stageX - this.x;
		this.touchPoint.y = e.stageY - this.y;
	}
	/*-----------------------------------------------------------------------------------------
	Get/Set
	-------------------------------------------------------------------------------------------*/
	
}