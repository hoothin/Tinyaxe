package tinyaxe.animation;

import tinyaxe.resource.ResourceManager;
import tinyaxe.resource.enums.ResTypeEnum;
import tinyaxe.resource.xml.TextureAtlasXmlVO;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.geom.Point;
import openfl.geom.Rectangle;
using unifill.Unifill;
/**
 * ...
 * @author Hoothin
 */
class FontFactory extends EventDispatcher {
	public static inline var COMPLETE:String = "FONT_FACTORY_INIT_COMPLETE";	
	public var FONT_WIDTH:Int = 25;
	public var FONT_HEIGHT:Int = 34;
	
	private var fontList:Map<String, BitmapData>;
	private var fontName:String;
	public function new() {
		super();
		this.fontList = new Map<String, BitmapData>();
	}
	
	public function initFactory(?fontName:String = "font", ?FONT_WIDTH:Int = 25, ?FONT_HEIGHT:Int = 34):Void {
		this.FONT_HEIGHT = FONT_HEIGHT;
		this.FONT_WIDTH = FONT_WIDTH;
		this.fontName = fontName;
		ResourceManager.prepareRes(["assets/res/" + fontName + ".png"], ResTypeEnum.ResTypeImage, loadFontComplete);
		ResourceManager.prepareRes(["assets/xml/texture/" + fontName + ".xml"], ResTypeEnum.ResTypeXml, loadFontComplete);
	}
	
	public function createBitmapData(value:String):BitmapData {
		var strLength:Int = value.uLength();
		var createdBitmapData:BitmapData = new BitmapData(strLength * FONT_WIDTH, FONT_HEIGHT, true, 0x00000000);
		createdBitmapData.fillRect(new Rectangle(0, 0, strLength * FONT_WIDTH, FONT_HEIGHT), 0x00000000);
		
		for (i in 0...strLength) {
			var curWord:String = value.uCharAt(i);
			var srcBitmapData:BitmapData = fontList[curWord];
			if (srcBitmapData != null)
			createdBitmapData.copyPixels(srcBitmapData, new Rectangle(0, 0, srcBitmapData.width, srcBitmapData.height), new Point(i * FONT_WIDTH, 0));
		}
		
		return createdBitmapData;
	}
	
	public function destroy():Void {
		for (font in fontList) {
			font.dispose();
		}
		fontList = new Map();
	}
	
	private function loadFontComplete():Void {
		var fontBitmapUrl:String = "assets/res/" + fontName + ".png";
		var fontBitmapData:BitmapData = ResourceManager.getImgBitmapData(fontBitmapUrl);
		var fontXml:Xml = ResourceManager.getXmlData("assets/xml/texture/" + fontName + ".xml");
		if (fontXml == null || fontBitmapData == null) return;
		var fontTextureVO:TextureAtlasXmlVO = new TextureAtlasXmlVO();
		fontTextureVO.initByXml(fontXml);
		for (spriteData in fontTextureVO.spriteList) {
			var numberBitmapData:BitmapData = new BitmapData(FONT_WIDTH, FONT_HEIGHT, true, 0x00000000);
			numberBitmapData.copyPixels(fontBitmapData, new Rectangle(spriteData.x, spriteData.y, spriteData.w, spriteData.h), new Point((FONT_WIDTH - spriteData.w)/2, (FONT_HEIGHT - spriteData.h)/2));
			var spriteName:String = spriteData.id.substring(0, spriteData.id.indexOf("."));
			this.fontList.set(spriteName, numberBitmapData);
		}
		ResourceManager.disposeBmd(fontBitmapUrl);
		this.dispatchEvent(new Event(COMPLETE));
	}
}