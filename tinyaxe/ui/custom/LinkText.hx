package tinyaxe.ui.custom;

import tinyaxe.utility.GameFilterEnum;
import openfl.events.MouseEvent;
import openfl.text.TextFormat;
import ru.stablex.ui.widgets.Button;

/**
 * @time 2013/12/10 14:56:41
 * @author Hoothin
 */
class LinkText extends Button{

	public var hoverFormat:TextFormat;
	public var pressFormat:TextFormat;
	public var normalFilters:Array<openfl.filters.BitmapFilter>;
	public var hoverFilters:Array<openfl.filters.BitmapFilter>;
	public var pressFilters:Array<openfl.filters.BitmapFilter>;
	public var textFilter(default, set):Array<openfl.filters.BitmapFilter>;
	private var rememberHtml:String;
	public function new() {
		super();
		this.hoverFormat = new TextFormat(this.format.font, this.format.size, 0xfff440, this.format.bold, this.format.italic, true);
		this.pressFormat = new TextFormat(this.format.font, this.format.size, 0xefba49, this.format.bold, this.format.italic, true);
		this.normalFilters = this.hoverFilters = this.pressFilters = [GameFilterEnum.wordGlowFilter];
		this.align = "left,middle";
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public dynamic function onPress (e:MouseEvent) : Void {
		if (this.rememberHtml != null) {
			
		}else {
			this.label.defaultTextFormat = this.pressFormat;
			if ( this.label.text.length > 0 ) {
				this.label.setTextFormat(this.pressFormat);
			}
		}
		this.label.filters = this.pressFilters;
    }

    override public dynamic function onRelease (e:MouseEvent) : Void {
		if (this.rememberHtml != null) {
			
		}else {
			this.label.defaultTextFormat = this.format;
			if ( this.label.text.length > 0 ) {
				this.label.setTextFormat(this.format);
			}
		}
		this.label.filters = this.normalFilters;
    }

    override public dynamic function onHover (e:MouseEvent) : Void {
		if (this.rememberHtml != null) {
			
		}else {
			this.label.defaultTextFormat = this.hoverFormat;
			if ( this.label.text.length > 0 ) {
				this.label.setTextFormat(this.hoverFormat);
			}
		}
		this.label.filters = this.hoverFilters;
    }
	
	override public dynamic function onHout (e:MouseEvent) : Void {
		if (this.rememberHtml != null) {
			
		}else {
			this.label.defaultTextFormat = this.format;
			if ( this.label.text.length > 0 ) {
				this.label.setTextFormat(this.format);
			}
		}
		this.label.filters = this.normalFilters;
    }
	
	override public function refresh () : Void {
		super.refresh();
		if (this.rememberHtml != null) {
			this.label.htmlText = rememberHtml;
		}else {
			if (this.hoverFormat.color == 0xfff440) {
				this.hoverFormat = new TextFormat(this.format.font, this.format.size, 0xfff440, this.format.bold, this.format.italic, true);
			}
			if (this.pressFormat.color == 0xefba49) {
				this.pressFormat = new TextFormat(this.format.font, this.format.size, 0xefba49, this.format.bold, this.format.italic, true);
			}
		}
	}
	
	public function setHtmlText(htmlText:String):Void {
		this.rememberHtml = htmlText;
		this.refresh();
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	override private function set_text(txt:String):String {
		this.rememberHtml = null;
		return super.set_text(txt);
	}
	
	private function set_textFilter(value:Array<openfl.filters.BitmapFilter>):Array<openfl.filters.BitmapFilter> {
		this.normalFilters = this.hoverFilters = this.pressFilters = value;
		this.label.filters = value;
		return textFilter = value;
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
}