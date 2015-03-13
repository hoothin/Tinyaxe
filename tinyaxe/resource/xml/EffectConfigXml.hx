package tinyaxe.resource.xml;

/**
 * ...
 * @author Hoothin
 */
class EffectConfigXml extends BaseXmlVO {
	private var _effectConfigXmlList:Map<String, EffectConfigXmlVO>;
	public function new() {
		super();
	}
	
	override public function initByXml(xmlData:Xml):Void {
		super.initByXml(xmlData);
		_effectConfigXmlList = new Map();
		for (effectConfig in xmlData.elements()) {
			var effectConfigVO:EffectConfigXmlVO = new EffectConfigXmlVO();
			effectConfigVO.initByXml(effectConfig);
			this._effectConfigXmlList.set(effectConfigVO.id, effectConfigVO);
		}
	}
	
	public function getVO(effectId:String):EffectConfigXmlVO {
		return this._effectConfigXmlList.get(effectId);
	}
}

class EffectConfigXmlVO extends BaseXmlVO {
	public var height(get_height, null):Float;
	public var width(get_width, null):Float;
	public var totalFrame(get_totalFrame, null):Int;
	public var frameRate(get_frameRate, null):Int;
	public var effectType(get_effectType, null):String;
	private var _effectType:String;
	private var _totalFrame:Int;
	private var _frameRate:Int;
	private var _width:Float;
	private var _height:Float;
	public function new() {
		super();
	}
	
	override public function initByXml(xmlData:Xml):Void {
		super.initByXml(xmlData);
		this._id = xmlData.get("id");
		this._effectType = xmlData.get("effectType");
		this._totalFrame = Std.parseInt(xmlData.get("totalFrame"));
		this._frameRate = Std.parseInt(xmlData.get("frameRate"));
		this._width = Std.parseFloat(xmlData.get("width"));
		this._height = Std.parseFloat(xmlData.get("height"));
	}
	
	function get_effectType():String {
		return _effectType;
	}
	
	function get_totalFrame():Int {
		return _totalFrame;
	}
	
	function get_frameRate():Int {
		return _frameRate;
	}
	
	function get_width():Float {
		return _width;
	}
	
	function get_height():Float {
		return _height;
	}
}