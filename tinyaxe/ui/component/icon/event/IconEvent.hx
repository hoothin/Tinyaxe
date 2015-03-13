package tinyaxe.ui.component.icon.event;

import openfl.events.Event;

/**
 * @time 2014/4/12 17:35:41
 * @author Hoothin
 */
class IconEvent extends Event{

	public static inline var CLICK_ICON:String = "CLICK_ICON";
	var _value:Dynamic;
	public function new(type:String, value:Dynamic) {
		super(type, false, false);
		this._value = value;
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public function getValue():Dynamic {
		return this._value;
	}
	
	override public function clone():Event {
		return new IconEvent(type, _value);
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
}