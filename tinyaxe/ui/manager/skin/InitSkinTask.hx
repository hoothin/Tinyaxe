package tinyaxe.ui.manager.skin;

/**
 * ...
 * @author Hoothin
 */
class InitSkinTask {
	public var callbackFunc(get_callbackFunc, null):Void -> Void;
	public var skinNameList(get_skinNameList, null):Array<String>;
	
	private var _skinNameList:Array<String>;
	private var _callbackFunc:Void->Void;
	public function new() {
		this._skinNameList = new Array<String>();
	}
	
	public function addSkinName(skinName:String):Void {
		this._skinNameList.push(skinName);
	}
	
	public function setCallBackFunc(callBackFunc:Void->Void):Void {
		this._callbackFunc = callBackFunc;
	}
	
	function get_callbackFunc():Void -> Void {
		return _callbackFunc;
	}
	
	function get_skinNameList():Array<String> {
		return _skinNameList;
	}
}