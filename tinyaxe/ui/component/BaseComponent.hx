package tinyaxe.ui.component;

import tinyaxe.ui.manager.UISkinManager;
import openfl.display.Sprite;
import openfl.events.Event;
import ru.stablex.ui.widgets.Widget;

/**
 * @time 2013/10/11 13:27:36
 * @author Hoothin
 */
class BaseComponent extends Sprite {
	public var uiComponent(get_uiComponent, null):Widget;
	
	private var _uiComponent:Widget;
	private var _skinResList:Array<String>;

	public function new() {
		super();
		
		this.addEventListener(Event.ADDED_TO_STAGE, addToStage);
		this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
	}
	
	public function init():Void {
		this.initSkinRes();
	}
	
	public function getWidth():Float {
		return this._uiComponent.w;
	}
	
	public function getHeight():Float {
		return this._uiComponent.h;
	}
	
	private function initSkinRes():Void {
		UISkinManager.getInstance().initSkinTemplate(this._skinResList, skinLoadComplete);
	}
	
	private function skinLoadComplete():Void {
		
	}
	
	private function addToStage(event:Event):Void {
		this.onAdd();
	}
	
	private function removeFromStage(event:Event):Void {
		this.onRemove();
	}
	
	private function onAdd():Void {
		
	}
	
	private function onRemove():Void {
		
	}
	
	function get_uiComponent():Widget {
		return _uiComponent;
	}
}