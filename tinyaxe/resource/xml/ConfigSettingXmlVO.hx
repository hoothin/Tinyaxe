package tinyaxe.resource.xml;

/**
 * ...
 * @author Hoothin
 */
class ConfigSettingXmlVO extends BaseXmlVO {
	public var priority(get_priority, null):Int;
	
	private var _priority:Int;
	public function new() {
		super();
	}
	
	override public function initByXml(xmlData:Xml):Void {
		super.initByXml(xmlData);
		this._id = xmlData.get("id");
		this._priority = Std.parseInt(xmlData.get("priority"));
	}
	
	function get_priority():Int {
		return _priority;
	}
}