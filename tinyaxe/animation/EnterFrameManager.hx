package tinyaxe.animation;
import tinyaxe.animation.frame.FrameSprite;
import tinyaxe.utility.TimeKeeper;
import openfl.Lib;
import openfl.events.Event;

/**
 * ...
 * @author Hoothin
 */
class EnterFrameManager {
	
	private var _currentRegisterId:Int;
	private var _enterFrameSpriteList:Array<FrameSprite>;
	private static var _enterFrameManager:EnterFrameManager;
	private var isInit:Bool;
	public static function getInstance():EnterFrameManager {
		if (_enterFrameManager == null) {
			_enterFrameManager = new EnterFrameManager();
		}
		
		return _enterFrameManager;
	}
	
	public function new() {
		this._enterFrameSpriteList = new Array<FrameSprite>();
		this._currentRegisterId = 0;
		this.isInit = false;
	}
	
	public function init():Void {
		if (isInit) return;
		this.isInit = true;
		Lib.current.addEventListener(Event.ENTER_FRAME, enterFrameProcess);
	}
	
	public function stop():Void {
		if (!isInit) return;
		this.isInit = false;
		Lib.current.removeEventListener(Event.ENTER_FRAME, enterFrameProcess);
	}
	
	public function registerSprite(frameSprite:FrameSprite):Void {
		for (sprite in this._enterFrameSpriteList) {
			if (frameSprite == sprite) {
				return;
			}
		}
		if (this._enterFrameSpriteList.indexOf(frameSprite) != -1) {
			return;
		}
		frameSprite.setRegisterId(this.getRegisterId());
		this._enterFrameSpriteList.push(frameSprite);
	}
	
	public function unRegisterSprite(frameSprite:FrameSprite):Void {
		this._enterFrameSpriteList.remove(frameSprite);
	}
	
	private function getRegisterId():Int {
		return this._currentRegisterId ++;
	}
	
	private function enterFrameProcess(event:Event):Void {
		for (frameSprite in this._enterFrameSpriteList) {
			if (frameSprite != null && frameSprite.isFrameProc) {
				frameSprite.enterFrameProcess();
			}
		}
	}
}