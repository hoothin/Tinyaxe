package tinyaxe.ui.tip.component;

import tinyaxe.resource.enums.ResTypeEnum;
import tinyaxe.resource.ResourceManager;
import tinyaxe.ui.component.BaseComponent;
import tinyaxe.ui.tip.interfaces.ITipComponent;
import tinyaxe.ui.tip.vo.TextTipInfoData;
import tinyaxe.ui.tip.vo.TipInfoData;
import tinyaxe.utility.GameFilterEnum;
import openfl.display.Bitmap;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * @time 2015/3/11 10:41:10
 * @author Hoothin
 */
class TextTip extends BaseComponent implements ITipComponent{

	private var textTipData:TextTipInfoData;
	private var _titleText:TextField;
	private var _tipHeight:Float;
	private var componentWidth:Float;
	private var componentHeight:Float;
	
	private static inline var VERTICAL_GAP:Float = 5;
	private static inline var HORIZONAL_GAP:Float = 5;
	private static inline var TITLE_GAP:Float = 5;
	private static inline var WORD_GAP:Float = 2;
	public function new() {
		super();
		this._tipHeight = 0;
	}
	

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	/* INTERFACE com.ui.tip.interfaces.ITipComponent */
	public function initTipInfo(tipData:TipInfoData):Void {
		this.textTipData = cast(tipData, TextTipInfoData);
		
		var titleWidth:Float = 0;
		if (textTipData.title.length > 0) {
			if (textTipData.text.length > 0) {
				titleWidth = this.addTitle(textTipData.title, textTipData.titleSize, true, 0xffffff, textTipData.isHtml, textTipData.wrapWidth);
			}else {
				titleWidth = this.addTitle(textTipData.title, textTipData.titleSize, false, 0xffffff, textTipData.isHtml, textTipData.wrapWidth);
			}
		}
		if (textTipData.text.length > 0) {
			componentWidth = textTipData.wrapWidth;
			this.addText(textTipData.text, textTipData.textSize);
		}else {
			componentWidth = titleWidth + HORIZONAL_GAP * 2;
		}
		componentHeight = _tipHeight + VERTICAL_GAP;
		if (textTipData.title.length > 0) {
			this._titleText.x = componentWidth / 2 - this._titleText.width / 2;
		}
	}
	
	public function updateTip(tipData:TipInfoData):Void {
		
	}
	
	public function cleanTip():Void {
		this._titleText.text = "";
		this._tipHeight = 0;
	}
	
	override public function getWidth():Float {
		return componentWidth;
	}
	
	override public function getHeight():Float {
		return componentHeight;
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/	
	private function addTitle(titleTextStr:String, size:Int = 14, isBold:Bool = true, color:Int = 0xffffff, isHtml:Bool = false, wrapWidth:Int = 100):Float {
		this._titleText = new TextField();
		this._titleText.defaultTextFormat = new TextFormat("_sans", size, color, isBold);
		this._titleText.filters = [GameFilterEnum.wordGlowFilter];
		if (isHtml) {
			this._titleText.htmlText = titleTextStr;
		}else {
			this._titleText.text = titleTextStr;
		}
		this._titleText.autoSize = TextFieldAutoSize.LEFT;
		if (wrapWidth > 0 && wrapWidth < this._titleText.width) {
			this._titleText.multiline = true;
			this._titleText.wordWrap = true;
			this._titleText.width = wrapWidth - 2 * HORIZONAL_GAP;
		}
		this._titleText.y = this._tipHeight;
		this.addChild(this._titleText);
		this._tipHeight += this._titleText.textHeight + TITLE_GAP;
		return this._titleText.width;
	}
	
	private function addText(textContentStr:String, size:Int = 12, color:Int = 0xffffff):Void {
		var textContent:TextField = new TextField();
		textContent.defaultTextFormat = new TextFormat("_sans", size, color);
		textContent.filters = [GameFilterEnum.wordGlowFilter];
		textContent.width = componentWidth - 2 * HORIZONAL_GAP;
		textContent.multiline = true;
		textContent.wordWrap = true;
		//textContent.text = textContentStr;
		textContent.htmlText = textContentStr;
		var sepLine:Bitmap = new Bitmap();
		sepLine.x = 5;
		sepLine.y = this._tipHeight;
		this.addChild(sepLine);
		ResourceManager.prepareRes(["assets/tip/dottedLine.png"], ResTypeEnum.ResTypeImage, function() {
			sepLine.bitmapData = ResourceManager.getImgBitmapData("assets/tip/dottedLine.png");
			sepLine.width = textContent.width;
		});
		this._tipHeight += 5;
		textContent.x = HORIZONAL_GAP;
		textContent.y = this._tipHeight;
		this.addChild(textContent);
		this._tipHeight += textContent.textHeight + WORD_GAP;
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Get/Set
	-------------------------------------------------------------------------------------------*/
	
}