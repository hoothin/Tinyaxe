package tinyaxe.animation.frame;

import openfl.display.Sprite;
import tinyaxe.animation.EnterFrameManager;

/**
 * ...
 * @author Hoothin
 */
class FrameSprite extends Sprite {
	
	public var registerId(get_registerId, null):Int;
	public var isFrameProc(get_isFrameProc, null):Bool;
	
	private var _registerId:Int;
	private var _isFrameProc:Bool;
	public function new() {
		super();
		this._isFrameProc = false;
		this._registerId = -1;
	}
	
	public function enterFrameProcess():Void {
		
	}
	
	public function setRegisterId(regId:Int):Void {
		this._registerId = regId;
	}
	
	public function register():Void {
		EnterFrameManager.getInstance().registerSprite(this);
		this._isFrameProc = true;
	}
	
	public function unRegister():Void {
		EnterFrameManager.getInstance().unRegisterSprite(this);
		this._isFrameProc = false;
	}
	
	public function start():Void {
		this._isFrameProc = true;
	}
	
	public function stop():Void {
		this._isFrameProc = false;
	}
	
	public function removeFromStage():Void {
		this.unRegister();
		if (this.parent != null) {
			this.parent.removeChild(this);
		}
	}
	
	function get_registerId():Int {
		return _registerId;
	}
	
	function get_isFrameProc():Bool {
		return _isFrameProc;
	}
}