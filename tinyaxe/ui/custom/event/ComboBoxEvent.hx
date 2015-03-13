package tinyaxe.ui.custom.event;
import openfl.events.Event;

/**
 * @time 2013/12/5 10:38:32
 * @author Hoothin
 */
class ComboBoxEvent extends Event{

	public static inline var SELECT_ITEM:String = "SELECT_ITEM";
	public static inline var ENTER_WORD:String = "ENTER_WORD";
	
	var value:Dynamic;
	public function new(type:String, value:Dynamic) {
		super(type, false, false);
		this.value = value;
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public function getValue():Dynamic {
		return this.value;
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
}