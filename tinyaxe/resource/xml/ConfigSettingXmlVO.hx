package tinyaxe.resource.xml;

/**
 * ...
 * @author Hoothin
 */
class ConfigSettingXmlVO extends BaseXmlVO {
	public var priority(get_priority, null):Int;
	public var className(get, null):String;
	private var _priority:Int;
	public function new() {
		super();
	}
	
	override public function initByXml(xmlData:Xml):Void {
		super.initByXml(xmlData);
		this._id = xmlData.get("id");
		this.className = xmlData.get("className");
		this._priority = Std.parseInt(xmlData.get("priority"));
	}
	
	function get_priority():Int {
		return _priority;
	}
	
	function get_className():String {
		return className;
	}
}