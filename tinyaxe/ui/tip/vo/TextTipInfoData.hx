package tinyaxe.ui.tip.vo;
import tinyaxe.ui.tip.component.TextTip;

/**
 * ...
 * @author Hoothin
 */
class TextTipInfoData extends TipInfoData {
	public var isHtml(get_isHtml, null):Bool;
	public var textSize(get_textSize, null):Int;
	public var text(get_text, null):String;
	public var titleSize(get_titleSize, null):Int;
	public var title(get_title, null):String;
	public var wrapWidth(get_wrapWidth, null):Int;
	
	private var _title:String;
	private var _titleSize:Int;
	private var _text:String;
	private var _textSize:Int;
	private var _isHtml:Bool;
	private var _wrapWidth:Int;
	
	public function new(title:String, titleSize:Int = 14, text:String = "", textSize:Int = 12, isHtml:Bool = false, wrapWidth:Int = 200) {
		super();
		
		this._tipComponent = new TextTip();
		this._title = title;
		this._titleSize = titleSize;
		this._text = text;
		this._textSize = textSize;
		this._isHtml = isHtml;
		this._wrapWidth = wrapWidth;
	}
	
	function get_wrapWidth():Int {
		return _wrapWidth;
	}
	
	function get_title():String {
		return _title;
	}
	
	function get_titleSize():Int {
		return _titleSize;
	}
	
	function get_text():String {
		return _text;
	}
	
	function get_textSize():Int {
		return _textSize;
	}
	
	function get_isHtml():Bool {
		return _isHtml;
	}
}