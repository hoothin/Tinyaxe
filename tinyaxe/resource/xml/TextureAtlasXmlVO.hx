package tinyaxe.resource.xml;
import tinyaxe.resource.xml.TextureAtlasSpriteXmlVO;

/**
 * ...
 * @author Hoothin
 */
class TextureAtlasXmlVO extends BaseXmlVO {
	public var spriteList(get_spriteList, null):Map<String, TextureAtlasSpriteXmlVO>;
	public var height(get_height, null):Int;
	public var width(get_width, null):Int;
	
	private var _width:Int;	
	private var _height:Int;
	private var _spriteList:Map<String, TextureAtlasSpriteXmlVO>;
	public function new() {
		super();
	}
	
	override public function initByXml(xmlData:Xml):Void {
		this._id = xmlData.get("imagePath");
		this._width = Std.parseInt(xmlData.get("width"));
		this._height = Std.parseInt(xmlData.get("height"));
		this._spriteList = new Map<String, TextureAtlasSpriteXmlVO>();
		for (sprite in xmlData.elements()) {
			var newSpriteVO:TextureAtlasSpriteXmlVO = new TextureAtlasSpriteXmlVO();
			newSpriteVO.initByXml(sprite);
			this._spriteList.set(newSpriteVO.id, newSpriteVO);
		}
	}
	
	function get_width():Int {
		return _width;
	}
	
	function get_height():Int {
		return _height;
	}
	
	function get_spriteList():Map<String, TextureAtlasSpriteXmlVO> {
		return _spriteList;
	}
}