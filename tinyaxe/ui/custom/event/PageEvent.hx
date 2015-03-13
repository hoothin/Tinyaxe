package tinyaxe.ui.custom.event;
import openfl.events.Event;

/**
 * @time 2013/10/18 10:53:27
 * @author Hoothin
 */
class PageEvent extends Event{

	public static inline var PAGE_CHANGE:String = "PAGE_CHANGE";
	var page:Int;
	public function new(type:String, page:Int) {
		super(type, false, false);
		this.page = page;
	}
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public function getPage():Int {
		return this.page;
	}
	
	override public function clone():Event {
		return new PageEvent(type, page);
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/

}