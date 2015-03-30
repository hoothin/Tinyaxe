package tinyaxe.resource;

import tinyaxe.resource.enums.ResTypeEnum;
import tinyaxe.resource.event.ResLoadingEvent;
import tinyaxe.resource.xml.BaseXmlVO;
import tinyaxe.resource.xml.ConfigSettingXmlVO;
import tinyaxe.utility.Debug;
import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author Hoothin
 */
class XmlConfigManager extends EventDispatcher {
	public static var logXmlString:Bool = false;
	
	private static var _xmlConfigManager:XmlConfigManager;
	private static inline var XML_URL:String = "assets/xml/";
	
	private var xmlString:Array<String>;
	private var configSettingXmlList:Map<String, ConfigSettingXmlVO>;
	private var initedXmlVOList:Array<BaseXmlVO>;
	private var preLoadConfigSettingList:Array<String>;
	private var curPriority:Int;
	private var maxPriority:Int = 1;
	public function new() {
		super();
		this.curPriority = -1;
		this.xmlString = [];
		this.configSettingXmlList = new Map();
		this.initedXmlVOList = new Array();
	}
	
	public static function getInstance():XmlConfigManager {
		if (_xmlConfigManager == null) {
			_xmlConfigManager = new XmlConfigManager();
		}
		return _xmlConfigManager;
	}
	
	public function pushString(value:String):Void {
		if (this.xmlString.indexOf(value) == -1) {
			this.xmlString.push(value);
		}
	}
	
	public function initXmlConfigSetting():Void {
		ResourceManager.prepareRes([XML_URL + "ConfigSettingXml.xml"], ResTypeEnum.ResTypeXml, configSettingComplete);
	}
	
	public static function getXmlVO<T>(xmlClass:Class<T>):T {
		for (xmlVO in getInstance().initedXmlVOList) {
			if (Std.is(xmlVO, xmlClass)) {
				return cast xmlVO;
			}
		}
		return null;
	}
	
	private function configSettingComplete():Void {
		var configSettingXml:Xml = ResourceManager.getXmlData(XML_URL + "ConfigSettingXml.xml");
		if (configSettingXml == null) return;
		for (configSetting in configSettingXml.elements()) {
			var newConfigSettingVO:ConfigSettingXmlVO = new ConfigSettingXmlVO();
			newConfigSettingVO.initByXml(configSetting);
			this.configSettingXmlList.set(newConfigSettingVO.id, newConfigSettingVO);
		}
		this.startLoadConfigSetting();
	}
	
	private function startLoadConfigSetting():Void {
		curPriority++;
		if (curPriority > maxPriority) {
			this.dispatchEvent(new ResLoadingEvent(ResLoadingEvent.PRELOAD_CONFIG_COMPLETE));
			this.logStringHandler();
			return;
		}
		this.preLoadConfigSettingList = new Array<String>();
		for (configSetting in this.configSettingXmlList) {
			if (configSetting.priority == curPriority) {
				preLoadConfigSettingList.push(configSetting.id);
			}
		}
		var resourceUrlList:Array<String> = preLoadConfigSettingList.map(function(a) { return XML_URL + a + ".xml"; } );
		ResourceManager.prepareRes(resourceUrlList, ResTypeEnum.ResTypeXml, preConfigSettingComplete);
	}
	
	private function enterFrameHandler(e:Event):Void {
		Lib.current.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		if (preLoadConfigSettingList.length <= 0) {
			this.dispatchEvent(new ResLoadingEvent(ResLoadingEvent.SOME_COMPLETE, curPriority));
			this.startLoadConfigSetting();
			return;
		}
		var curConfigSetting:ConfigSettingXmlVO = this.configSettingXmlList.get(preLoadConfigSettingList.shift());
		var configXml:Xml = ResourceManager.getXmlData(XML_URL + curConfigSetting.id + ".xml");
		if (configXml == null) return;
		var className:String = curConfigSetting.className;
		if (className == null) {
			className = curConfigSetting.id;
		}
		var cl:Class<Dynamic> = Type.resolveClass("tinyaxe.resource.xml." + className);
		if (cl == null) {
			cl = Type.resolveClass("com.resource.xml." + className);
			if (cl == null) {
				Debug.trace("Xml Class com.resource.xml." + className + " didn't used!");
			}
		}
		if (cl != null) {
			var curXmlVO:BaseXmlVO = Type.createInstance(cl, []);
			if (curXmlVO == null) {
				Debug.trace(curConfigSetting.id + ".xml pairs none valid Class!");
			}else {
				curXmlVO.initByXml(configXml);
				initedXmlVOList.push(curXmlVO);
			}
		}
		Lib.current.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function preConfigSettingComplete():Void {
		Lib.current.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function logStringHandler():Void {
		if (logXmlString) {
			Lib.trace(xmlString.join("\n"));
		}
	}
}