package tinyaxe.ui.custom;

import openfl.text.TextFormat;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.Widget;

/**
 * @time 2013/10/18 11:03:51
 * @author Hoothin
 */
class KeyValuePanel extends Widget{

	public var keyText:Text;
	public var valueText:Text;
	
	public var panelKey(get_panelKey, set_panelKey):String;
	private var _panelKey:String;
	
	public var panelValue(get_panelValue, set_panelValue):String;
	private var _panelValue:String;
	
	public var format(null, set_format):TextFormat;
	
	public var textFilters(null, set_textFilters):Array<openfl.filters.BitmapFilter>;
	
	private var _format:TextFormat;
	private var _textFilters:Array<openfl.filters.BitmapFilter>;
	
	public function new() {
		super();
		
		keyText = UIBuilder.create(Text, {
			mouseChildren:false,
			align : 'middle,center'
		});
		valueText = UIBuilder.create(Text, {
			mouseChildren:false,
			align : 'middle,center',
			x     : 60
		});
		keyText.label.selectable = false;
		valueText.label.selectable = false;
		this.addChild(keyText);
		this.addChild(valueText);
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public function onCreate():Void {
		
	}
	
	override public function refresh():Void {
		if (this.h == 0) {
			this.h = keyText.h;
		}
		super.refresh();
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	function get_panelKey():String {
		return _panelKey;
	}
	
	function set_panelKey(value:String):String {
		this.keyText.text = value + "： ";
		return _panelKey = value;
	}
	
	function get_panelValue():String {
		return _panelValue;
	}
	
	function set_panelValue(value:String):String {
		this.valueText.text = value;
		return _panelValue = value;
	}
	
	private function set_textFilters(value:Array<openfl.filters.BitmapFilter>):Array<openfl.filters.BitmapFilter> {
		this.keyText.label.filters = value;
		this.valueText.label.filters = value;
		return _textFilters = value;
	}
	
	private function set_format(value:TextFormat):TextFormat {
		this.keyText.format = value;
		this.keyText.refresh();
		this.valueText.format = value;
		this.valueText.refresh();
		return _format = value;
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/

}