package tinyaxe.resource.xml;
import tinyaxe.resource.XmlConfigManager;

/**
 * ...
 * @author Hoothin
 */
class BaseXmlVO {
	public var id(get_id, null):String;
	
	private var _id:String;
	public function new() {
		
	}
	
	public function initByXml(xmlData:Xml):Void {
		if (XmlConfigManager.logXmlString)
		anylize(xmlData);
	}
	
	function anylize(data:Xml):Void {
		XmlConfigManager.getInstance().pushString(data.nodeName);
		for (node in data.attributes()) {
			XmlConfigManager.getInstance().pushString(node);
		}
		for (child in data.elements()) {
			anylize(child);
		}
	}
	
	function get_id():String {
		return _id;
	}
}