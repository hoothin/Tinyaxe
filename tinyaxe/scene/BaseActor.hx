package tinyaxe.scene ;

import tinyaxe.animation.vo.SkeletonAnimationVO;
import tinyaxe.utility.TimeKeeper;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.geom.Point;
enum ActorType {
	ME;
	NPC;
	ENEMY;
}

/**
 * @time 2014/12/24 15:27:22
 * @author Hoothin
 */
class BaseActor extends Sprite{

	var target:DisplayObject;
	var type:ActorType;
	var avatar:SkeletonAnimationVO;
	var curAction:String;
	var shootDelay:Int = 500;
	var bulletRate:Int = 5;
	public function new(?type:ActorType) {
		super();
		if (type == null) {
			type = ActorType.ME;
		}
		this.type = type;
	}

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public function initAnimation(name:String, ?defaultMotion:String = "standby"):Void {
		curAction = defaultMotion;
		avatar = SkeletonAnimationVO.getNew(name, defaultMotion);
		avatar.register();
		this.addChild(avatar);
		TimeKeeper.addTimerEventListener(shootAction, shootDelay);
	}
	
	public function fire(target:DisplayObject):Void {
		if (this.target != target) {
			shootAction(0);
			this.target = target;
			processAnimation();
		}
	}
	
	public function changeAction(name:String, ?loop:Bool = true):Void {
		if (curAction == name) return;
		this.curAction = name;
		processAnimation(loop);
	}
	
	/**
	 * 更改方向
	 *     ↑5
	 *  ↖4  ↗6
	 * ←3    →7
	 *  ↙2  ↘8
	 *     ↓1
	 * @param	dir
	 */
	//public function changeDirection(dir:Int):Void {
		//if (curDir == dir) return;
		//this.curDir = dir;
		//processAnimation();
	//}
	
	public function changeFlip(flip:Bool):Void {
		if (avatar.skeleton == null || flip == avatar.skeleton.flipX) return;
		avatar.skeleton.flipX = flip;
		processAnimation();
	}
	
	public function processAnimation(?loop:Bool = true):Void {
		var realActionName:String = curAction;
		
		if (target != null && target.visible && avatar.skeleton != null) {
			var tempDir:String = "";
			
			var distanceX:Float = target.x - this.x;
			var distanceY:Float = target.y - this.y;
			
			var angle:Float = Math.atan2(distanceY, distanceX);
			var standardValue:Float = Math.PI / 8;
			if ( -7 * standardValue <= angle && angle < -5 * standardValue) {
				tempDir = avatar.skeleton.flipX?"45":"315";
			}else if ( -5 * standardValue <= angle && angle < -3 * standardValue) {
				tempDir = "00";
			}else if ( -3 * standardValue <= angle && angle < -standardValue) {
				tempDir = avatar.skeleton.flipX?"315":"45";
			}else if ( - standardValue <= angle && angle < standardValue) {
				tempDir = avatar.skeleton.flipX?"270":"90";
			}else if ( standardValue <= angle && angle < 3 * standardValue) {
				tempDir = avatar.skeleton.flipX?"225":"135";
			}else if ( 3 * standardValue <= angle && angle < 5 * standardValue) {
				tempDir = "180";
			}else if ( 5 * standardValue <= angle && angle < 7 * standardValue) {
				tempDir = avatar.skeleton.flipX?"135":"225";
			}else {
				tempDir = avatar.skeleton.flipX?"90":"270";
			}
			
			realActionName = curAction + "_" + "fire" + tempDir;
		}
		this.avatar.changeAction(realActionName, loop);
	}
	
	public function destroy() {
		this.avatar.destroy();
		if (this.parent != null) {
			this.parent.removeChild(this);
		}
		TimeKeeper.removeTimerEventListener(shootAction);
	}
	
	public function stop():Void {
		if (this.visible) {
			this.avatar.stop();
			this.visible = false;
			TimeKeeper.removeTimerEventListener(shootAction);
		}
	}
	
	public function start():Void {
		if (!this.visible) {
			this.avatar.start();
			this.visible = true;
			TimeKeeper.addTimerEventListener(shootAction, shootDelay);
		}
	}
	
	public function move(distanceX:Float, distanceY:Float):Void {
		var modulus:Float = 5 / Math.sqrt(distanceX * distanceX + distanceY * distanceY);
		distanceX *= modulus;
		distanceY *= modulus;
		this.changeFlip(distanceX < 0);
		this.changeAction("run");
		this.processAnimation();
		if (type == ActorType.NPC) return;
		this.x += distanceX;
		this.y += distanceY;
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	private function shootAction(value:Float):Void {
		if (target != null && target.visible) {
			var bulletType:String = (this.type == ActorType.ENEMY)?Bullet.ENEMY:Bullet.FRIEND;
			var distanceX:Float = target.x - this.x;
			var distanceY:Float = target.y - this.y;
			var modulus:Float = bulletRate / Math.sqrt(distanceX * distanceX + distanceY * distanceY);
			var bullet = Bullet.getNew(bulletType, new Point(modulus * distanceX, modulus * distanceY));
			bullet.x = this.x;
			bullet.y = this.y;
		}
		processAnimation();
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Get/Set
	-------------------------------------------------------------------------------------------*/
	
}