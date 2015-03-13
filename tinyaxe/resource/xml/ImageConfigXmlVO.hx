package tinyaxe.resource.xml;

/**
 * ...
 * @author Hoothin
 */
class ImageConfigXmlVO extends BaseXmlVO {
	public var offsetY(get_offsetY, null):Float;
	public var offsetX(get_offsetX, null):Float;
	
	private var _offsetX:Float;
	private var _offsetY:Float;
	public function new() {
		super();
	}
	
	override public function initByXml(xmlData:Xml):Void {
		super.initByXml(xmlData);
		this._id = xmlData.get("id");
		this._offsetX = Std.parseInt(xmlData.get("offsetX"));
		this._offsetY = Std.parseInt(xmlData.get("offsetY"));
	}

	function get_offsetX():Float {
		return _offsetX;
	}
	
	function get_offsetY():Float {
		return _offsetY;
	}
}