package tinyaxe.resource.vo;
import tinyaxe.resource.res.ResData;

/**
 * ...
 * @author Hoothin
 */
class LoadTask {
	public static inline var TASK_IMG:String = "TASK_IMG";
	public static inline var TASK_XML:String = "TASK_XML";
	public static inline var TASK_BINARY:String = "TASK_BINARY";
	
	public var taskType(get_taskType, null):String;
	public var taskUrl(get_taskUrl, null):Array<String>;
	public var originalUrl(get_originalUrl, null):Array<String>;
	public var coreType(get_coreType, null):Int;
	public var failedTime(get_failedTime, null):Int;
	public var loadingState(get_loadingState, null):Int;
	public var callBackFunction(get_callBackFunction, null):Array<Dynamic> -> Int -> Void;
	public var currentProcessUrl(get_currentProcessUrl, null):String;
	public var taskUID(get_taskUID, null):Int;
	public var dataList(get_dataList, null):Array<ResData>;
	
	private var _taskType:String;
	private var _taskUrl:Array<String>;
	private var _originalUrl:Array<String>;
	private var _coreType:Int;
	private var _failedTime:Int;
	private var _loadingState:Int;
	private var _urlIndex:Int;
	private var _callBackFunction:Array<Dynamic>->Int->Void;	
	private var _currentProcessUrl:String;
	private var _taskUID:Int;
	private var _dataList:Array<ResData>;
	public function new(originalUrl:Array<String>) {
		_coreType = -1;
		_failedTime = 0;
		_loadingState = 0;
		_urlIndex = -1;
		_taskUID = 0;
		_currentProcessUrl = "";
		_dataList = [];
		_originalUrl = originalUrl;
	}
	
	public function initLoadTask(taskUrl:Array<String>, taskType:String, callBackFunction:Dynamic->Int->Void, taskUID:Int, ?coreType:Int = 0):Void {
		this._taskUrl = taskUrl;
		this._taskType = taskType;
		this._callBackFunction = callBackFunction;
		this._coreType = coreType;
		this._taskUID = taskUID;
	}
	
	public function getCurrentUrl():String {
		if (this._taskUrl.length > this._urlIndex) {
			this._currentProcessUrl = this._taskUrl[this._urlIndex];
			if (_currentProcessUrl == null) return null;
			var urlIndex:Int = this._currentProcessUrl.lastIndexOf("/");
			this._currentProcessUrl = this._currentProcessUrl.substring(0, urlIndex) + "/" + StringTools.urlEncode(this._currentProcessUrl.substring(urlIndex + 1));
			return this._currentProcessUrl;
		}else {
			this._currentProcessUrl = "";
			return null;
		}
	}
	
	public function gotoNextUrl(?fail:Bool = false):Void {
		this._failedTime = 0;
		if (fail) {
			this._originalUrl.remove(this._currentProcessUrl);
		}
		this._urlIndex ++;
	}
	
	public function failed():Void {
		this._failedTime++;
	}
	
	public function pushDataList(resData:ResData) {
		this._dataList.push(resData);
	}
	
	public function changeState(state:Int):Void {
		this._loadingState = state;
	}
	
	function get_taskType():String {
		return _taskType;
	}
	
	function get_taskUrl():Array<String> {
		return _taskUrl;
	}
	
	function get_originalUrl():Array<String> {
		return _originalUrl;
	}
	
	function get_coreType():Int {
		return _coreType;
	}
	
	function get_failedTime():Int {
		return _failedTime;
	}
	
	function get_loadingState():Int {
		return _loadingState;
	}
	
	function get_callBackFunction():Array<Dynamic> -> Int -> Void {
		return _callBackFunction;
	}
	
	function get_currentProcessUrl():String {
		return _currentProcessUrl;
	}
	
	function get_taskUID():Int {
		return _taskUID;
	}
	
	function get_dataList():Array<ResData> {
		return _dataList;
	}
}