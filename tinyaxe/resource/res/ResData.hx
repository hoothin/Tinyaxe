package tinyaxe.resource.res;
import tinyaxe.resource.enums.ResTypeEnum;

/**
 * ...
 * @author Hoothin
 */
class ResData {
	
	public var resData(get_resData, null):Dynamic;
	public var resUrl(get_resUrl, null):String;
	public var resType(get_resType, null):ResTypeEnum;
	//资源数据
	private var _resData:Dynamic;
	//资源原始路径
	private var _resUrl:String;
	
	private var _resType:ResTypeEnum;
	
	public function new(resData:Dynamic, resUrl:String, resType:ResTypeEnum) {
		this._resData = resData;
		this._resUrl = resUrl;
		this._resType = resType;
	}
	
	function get_resData():Dynamic {
		return _resData;
	}
	
	function get_resUrl():String {
		return _resUrl;
	}
	
	function get_resType():ResTypeEnum {
		return _resType;
	}
}