package tinyaxe.ui.custom;

import flash.events.Event;
import tinyaxe.utility.TimeKeeper;
import openfl.display.BlendMode;
import openfl.display.Shape;
import openfl.events.MouseEvent;
import ru.stablex.ui.events.WidgetEvent;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Progress;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.Widget;

/**
 * @time 2013/10/18 11:15:02
 * @author Hoothin
 */
class ProgressBar extends Progress{
	
	public var progressName(get_progressName, set_progressName):String;
	public var progressTop(get_progressTop, null):Widget;
	
	public var progressText:Text;
	public var labelStyle:Int = 0;
	public var rollShow:Bool = true;
	public var minWidth:Float = 12;
	
	private var _progressTop:Widget;
	private var _progressName:String = "";
	private var maskShape:Shape;
	public function new() {
		super();
		_progressTop = UIBuilder.create(Widget, {
			widthPt : 100,
			heightPt: 100,
			mouseEnabled: false,
			mouseChildren: false,
			blendMode:BlendMode.MULTIPLY
		});
		this.addChild(_progressTop);
		
		progressText = UIBuilder.create(Text, {
			align : 'middle,center',
			visible: false,
			mouseChildren: false,
			mouseEnabled: false,
			label : {
				selectable : false
			}
		});
		this.addChild(progressText);
		this.mouseChildren = false;
	}
	
	override public function onCreate():Void {
		super.onCreate();
		if (maskShape == null) {
			maskShape = new Shape();
		}
		this.maskShape.graphics.clear();
		this.maskShape.graphics.beginFill(0xff0000, 0);
		this.maskShape.graphics.drawRect(0, 0, this.w, this.h);
		this.maskShape.graphics.endFill();
		this.maskShape.x = 0;
		this.maskShape.y = 0;
		this.bar.addChild(maskShape);
		this.bar.mask = maskShape;
		this.progressText.w = this.w;
		this.progressText.h = this.h;
		this.addEventListener(MouseEvent.ROLL_OUT, rollHandler);
		this.addEventListener(MouseEvent.ROLL_OVER, rollHandler);
		this.progressText.visible = !rollShow;
		if (labelStyle == 0) {
			this.progressText.text = _progressName;
		}else if (labelStyle == 1) {
			this.progressText.text = (_progressName == ""?"":(_progressName + ":")) + Std.int(this._value) + "/" + this.max;
		}else {
			var percent:Int = Std.int(this.bar.widthPt);
			this.progressText.text = percent + "%";
		}
		this.bar.addEventListener(WidgetEvent.RESIZE, barResizeHandler);
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/	
	private function recoverVisible(value:Float):Void {
		TimeKeeper.removeTimerEventListener(recoverVisible);
		this.progressText.visible = false;
	}
	
	override function set_value(v:Float):Float {
		//super.set_value(v);
        this._value = v;
        if( this.created ){
            this.dispatchEvent(new WidgetEvent(WidgetEvent.CHANGE));
        }
		
		if (this.smoothChange) {
			this.bar.mask = null;
		}else {
			this.bar.mask = maskShape;
		}
		var barWidthPt:Float = (max <= 0 || value <= 0 ? 0 : value / max);
		if (barWidthPt * this._width < minWidth && barWidthPt > 0) {
			this._setBarWidth(minWidth, this.bar.wparent.w);
		}else if (barWidthPt > 1) {
			this._setBarWidth(this.max, this.max);
		}else {
			this._setBarWidth(v, this.max);
		}
		if (this.maskShape != null)
		this.maskShape.width = this.bar.w;
		this.progressText.visible = true;
		if (labelStyle == 0) {
			
		}else if (labelStyle == 1) {
			this.progressText.text = (_progressName == ""?"":(_progressName + ":")) + Std.int(this._value) + "/" + this.max;
		}else {
			var percent:Int = Std.int(this._value / this.max * 100);
			this.progressText.text = (_progressName == ""?"":(_progressName + ":")) +  percent + "%";
		}
		if (rollShow) {
			TimeKeeper.addTimerEventListener(recoverVisible, 2000);
		}
		
		return v;
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function rollHandler(e:MouseEvent):Void {
		if(labelStyle != 0 && rollShow)
		this.progressText.visible = e.type == MouseEvent.ROLL_OVER;
	}
	
	private function barResizeHandler(e:Event):Void {
		this.bar.applySkin();
	}
	
	function get_progressName():String {
		return _progressName;
	}
	
	function set_progressName(value:String):String {
		if (labelStyle == 0) {
			this.progressText.text = value;
		}else if (labelStyle == 1) {
			this.progressText.text = (value == ""?"":(value + ":")) + Std.int(this._value) + "/" + this.max;
		}else {
			var percent:Int = Std.int(this.bar.widthPt);
			this.progressText.text = (value == ""?"":(value + ":")) +  percent + "%";
		}
		return _progressName = value;
	}
	
	function get_progressTop():Widget{
		return _progressTop;
	}
}