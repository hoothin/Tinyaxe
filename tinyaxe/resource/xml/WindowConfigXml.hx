package tinyaxe.resource.xml;
import openfl.ui.Keyboard;

/**
 * @time 2015/1/20 14:54:41
 * @author Hoothin
 */
class WindowConfigXml extends BaseXmlVO {
	public var windowConfigXmlList(get_windowConfigXmlList, null):Map<String, WindowConfigXmlVO>;
	private var _windowConfigXmlList:Map<String, WindowConfigXmlVO>;
	public function new() {
		super();
	}

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public function initByXml(xmlData:Xml):Void {
		super.initByXml(xmlData);
		_windowConfigXmlList = new Map();
		for (windowConfig in xmlData.elements()) {
			var windowConfigVO:WindowConfigXmlVO = new WindowConfigXmlVO();
			windowConfigVO.initByXml(windowConfig);
			this._windowConfigXmlList.set(windowConfigVO.id, windowConfigVO);
		}
	}
	
	public function getVO(windowName:String):WindowConfigXmlVO {
		return this._windowConfigXmlList.get(windowName);
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Get/Set
	-------------------------------------------------------------------------------------------*/
	function get_windowConfigXmlList():Map<String, WindowConfigXmlVO> {
		return _windowConfigXmlList;
	}
}

class WindowConfigXmlVO extends BaseXmlVO {
	public var keyCode(get_keyCode, null):Int;
	public var parent(get_parent, null):String;
	public var keepWindowList(get_keepWindowList, null):Array<String>;
	public var left(get_left, null):String;
	public var right(get_right, null):String;
	private var _keepWindowList:Array<String>;
	
	private var _parent:String;
	private var _right:String;
	private var _left:String;
	private var _keyCode:Int;
	public function new() {
		super();
	}
	
	override public function initByXml(xmlData:Xml):Void {
		super.initByXml(xmlData);
		this._id = xmlData.get("name");
		if (xmlData.get("key") != null && xmlData.get("key").length > 0) {
			this._keyCode = Reflect.field(Keyboard, xmlData.get("key"));
		}else {
			this._keyCode = -1;
		}
		this._keepWindowList = new Array<String>();
		var keepStr:String = xmlData.get("keep");
		if (keepStr != null && keepStr.length > 0) {
			this._keepWindowList = keepStr.split(",");
		}
		this._parent = xmlData.get("parent");
		this._right = xmlData.get("right");
		this._left = xmlData.get("left");
	}
	
	function get_right():String {
		return _right;
	}
	
	function get_left():String {
		return _left;
	}
	
	function get_keepWindowList():Array<String> {
		return _keepWindowList;
	}
	
	function get_parent():String {
		return _parent;
	}
	
	function get_keyCode():Int {
		return _keyCode;
	}
}