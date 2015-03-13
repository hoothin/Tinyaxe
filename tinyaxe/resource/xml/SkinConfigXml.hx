package tinyaxe.resource.xml;

/**
 * @time 2015/1/19 15:49:22
 * @author Hoothin
 */
class SkinConfigXml extends BaseXmlVO{
	private var _skinConfigXmlList:Map<String, SkinConfigXmlVO>;
	public function new() {
		super();
	}

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public function initByXml(xmlData:Xml):Void {
		super.initByXml(xmlData);
		_skinConfigXmlList = new Map();
		for (skinConfig in xmlData.elements()) {
			var skinConfigVO:SkinConfigXmlVO = new SkinConfigXmlVO();
			skinConfigVO.initByXml(skinConfig);
			this._skinConfigXmlList.set(skinConfigVO.skinName, skinConfigVO);
		}
	}
	
	public function getVO(skinName:String):SkinConfigXmlVO {
		return this._skinConfigXmlList.get(skinName);
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
	
}

class SkinConfigXmlVO extends BaseXmlVO {
	private var _skinName:String;
	private var _skinSrc:String;
	private var _slice9List:Array<Float>;
	private var _tileList:Array<Float>;
	private var _smooth:Bool;
	public function new() {
		super();
	}
	
	override public function initByXml(xmlData:Xml):Void {
		super.initByXml(xmlData);
		
		this._skinName = xmlData.get("name");
		this._skinSrc = xmlData.get("src");
		this._smooth = xmlData.get("smooth") == "true";
		this._slice9List = new Array<Float>();
		this._tileList = [];
		var skinSlice:String = xmlData.get("slice9");
		if (skinSlice != null && skinSlice.length > 0) {
			var skinSliceList:Array<String> = skinSlice.split(",");
			for (sliceValue in skinSliceList) {
				this._slice9List.push(Std.parseFloat(sliceValue));
			}
		}
		
		var skinTile:String = xmlData.get("tile");
		if (skinTile != null && skinTile.length > 0) {
			var skinTileList:Array<String> = skinTile.split(",");
			for (tileValue in skinTileList) {
				this._tileList.push(Std.parseFloat(tileValue));
			}
		}
	}
	
	function get_skinName():String {
		return _skinName;
	}
	
	public var skinName(get_skinName, null):String;
	
	function get_skinSrc():String {
		return _skinSrc;
	}
	
	public var skinSrc(get_skinSrc, null):String;
	
	function get_slice9List():Array<Float> {
		return _slice9List;
	}
	
	public var slice9List(get_slice9List, null):Array<Float>;
	
	function get_tileList():Array<Float> {
		return _tileList;
	}
	
	public var tileList(get_tileList, null):Array<Float>;
	
	function get_smooth():Bool {
		return _smooth;
	}
	
	public var smooth(get_smooth, null):Bool;
}