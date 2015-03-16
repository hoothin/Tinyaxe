package tinyaxe.ui.manager;
import motion.Actuate;
import motion.easing.Linear;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import tinyaxe.layer.LayerManager;

/**
 * @time 2014/1/21 13:34:30
 * @author Hoothin
 */
class NoticeIconManager{

	static var _noticeIconManager:NoticeIconManager;
	var bottomContainer:Sprite;
	var bottomContentArr:Array<DisplayObject>;
	var horizontalPadding:Int = 5;
	var iconW:Int = 40;
	var iconH:Int = 40;
	public function new() {
		this.bottomContainer = new Sprite();
		this.bottomContentArr = new Array();
		//LayerManager.getInstance().menuLayer.addChild(bottomContainer);
		Lib.current.stage.addEventListener(Event.RESIZE, resizeStage);
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public static function getInstance():NoticeIconManager {
		if (_noticeIconManager == null) {
			_noticeIconManager = new NoticeIconManager();
		}
		return _noticeIconManager;
	}
	
	public function addToBottom(icon:DisplayObject):Void {
		if (this.bottomContainer.contains(icon)) return;
		this.bottomContainer.addChild(icon);
		this.bottomContentArr.push(icon);
		if (this.bottomContentArr.length == 1) {
			icon.alpha = 0;
			Actuate.tween(icon, 0.5, { alpha: 1 } ).ease(Linear.easeNone);
		}else if (this.bottomContentArr.length <= 5) {
			for (i in 0...bottomContentArr.length) {
				bottomContentArr[i].x = i * (iconW + horizontalPadding);
			}
			icon.alpha = 0;
			icon.x += 100;
			Actuate.tween(icon, 0.5, { alpha: 1, x:icon.x - 100 } ).ease(Linear.easeNone);
		}
		this.resizeStage();
	}
	
	public function removeFromBottom(icon:DisplayObject):Void {
		if (!this.bottomContainer.contains(icon)) return;
		var locY:Float = icon.y - 100;
		Actuate.tween(icon, 0.5, { alpha: 0, y:locY } ).ease(Linear.easeNone).onComplete(iconDisappeared, [icon]);
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	private function iconDisappeared(icon:DisplayObject):Void {
		icon.y = 0;
		this.bottomContainer.removeChild(icon);
		this.bottomContentArr.remove(icon);
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function resizeStage(e:Event = null):Void {
		this.bottomContainer.x = (LayerManager.SHOW_WIDTH - this.bottomContentArr.length*(iconW + horizontalPadding)) / 2;
		this.bottomContainer.y = LayerManager.SHOW_HEIGHT - 80 - this.iconH;
	}
}