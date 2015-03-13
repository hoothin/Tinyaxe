package tinyaxe.resource.xml ;

import tinyaxe.resource.xml.BaseXmlVO;

/**
 * ...
 * @author Hoothin
 */
class TextureAtlasSpriteXmlVO extends BaseXmlVO {
	public var h(get_h, null):Int;
	public var w(get_w, null):Int;
	public var y(get_y, null):Int;
	public var x(get_x, null):Int;
	public var r(get_r, null):Bool;
	
	private var _x:Int;
	private var _y:Int;
	private var _w:Int;
	private var _h:Int;
	private var _r:Bool;
	public function new() {
		super();
	}
	
	override public function initByXml(xmlData:Xml):Void {
		super.initByXml(xmlData);
		this._id = xmlData.get("n");
		this._x = Std.parseInt(xmlData.get("x"));
		this._y = Std.parseInt(xmlData.get("y"));
		this._w = Std.parseInt(xmlData.get("w"));
		this._h = Std.parseInt(xmlData.get("h"));
		this._r = (xmlData.get("r") == "y");
	} 
	
	function get_x():Int {
		return _x;
	}
	
	function get_y():Int {
		return _y;
	}
	
	function get_w():Int {
		return _w;
	}
	
	function get_h():Int {
		return _h;
	}
	
	function get_r():Bool {
		return _r;
	}
}