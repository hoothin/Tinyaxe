package tinyaxe.animation.task;

/**
 * ...
 * @author Hoothin
 */
class TemplateInitTask {
	public var isFinished(get_isFinished, null):Bool;
	public var initCompleteFunc(get_initCompleteFunc, null):Void -> Void;
	
	private var _templateIdList:Array<String>;
	private var _initCompleteFunc:Void->Void;
	private var _isFinished:Bool;
	public function new(templateIdList:Array<String>, ?initCompleteFunc:Void->Void = null) {
		this._templateIdList = templateIdList;
		this._initCompleteFunc = initCompleteFunc;
		this._isFinished = false;
	}
	
	public function getTemplateId():String {
		if (this._templateIdList.length > 0) {
			if (this._templateIdList.length == 1) {
				this._isFinished = true;
			}
			return this._templateIdList.shift();
		}else {
			return null;
		}
	}
	
	function get_isFinished():Bool {
		return _isFinished;
	}
	
	function get_initCompleteFunc():Void -> Void {
		return _initCompleteFunc;
	}
}