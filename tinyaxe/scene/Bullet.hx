package tinyaxe.scene;
import tinyaxe.animation.frame.FrameSprite;
import openfl.geom.Point;

/**
 * @time 2015/2/10 17:03:45
 * @author Hoothin
 */
class Bullet extends FrameSprite{

	static public var bulletArr:Array<Bullet> = [];
	static public var FRIEND:String = "FRIEND";
	static public var ENEMY:String = "ENEMY";
	static var bulletPool:Array<Bullet> = [];
	public var type:String;
	var offsetPoint:Point;
	public function new() {
		super();
	}

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public static function getNew(type:String, offsetPoint:Point):Bullet {
		var bullet:Bullet = null;
		if (bulletPool.length > 0) {
			bullet = bulletPool.shift();
		}else {
			bullet = new Bullet();
		}
		bullet.init(type, offsetPoint);
		if (bulletArr.indexOf(bullet) == -1) {
			bulletArr.push(bullet);
		}
		return bullet;
	}
	
	public function init(type:String, offsetPoint:Point):Void {
		this.type = type;
		this.graphics.clear();
		if (type == FRIEND) {
			this.graphics.beginFill(0x1E90FF);
		}else if (type == ENEMY) {
			this.graphics.beginFill(0xfE90FF);
		}
		this.graphics.drawCircle(0, 0, 5);
		this.graphics.endFill();
		this.offsetPoint = offsetPoint;
		this.register();
		Scene.getInstance().objContainer.addChild(this);
	}
	
	public function destroy():Void {
		this.unRegister();
		if (this.parent != null) {
			this.parent.removeChild(this);
		}
		bulletArr.remove(this);
		bulletPool.push(this);
	}
	
	override public function enterFrameProcess():Void {
		super.enterFrameProcess();
		this.x += offsetPoint.x;
		this.y += offsetPoint.y;
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Get/Set
	-------------------------------------------------------------------------------------------*/
	
}