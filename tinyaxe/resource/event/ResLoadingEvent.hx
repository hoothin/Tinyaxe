package tinyaxe.resource.event;

import openfl.events.Event;

/**
 * ...
 * @author Hoothin
 */
class ResLoadingEvent extends Event
{
	public static inline var PRELOAD_CONFIG_COMPLETE:String = "PRELOAD_CONFIG_COMPLETE";
	public static inline var LOADING_ERROR:String = "LOADING_ERROR";
	public static inline var SOME_COMPLETE:String = "SOME_COMPLETE";
	public static inline var URL_LOAD_COMPLETE:String = "URL_LOAD_COMPLETE";
	var _value:Dynamic;
	public function new(type:String, ?value:Dynamic = null) 
	{
		super(type, false, false);
		this._value = value;
	}
	
	function get_value():Dynamic {
		return _value;
	}
	
	public var value(get_value, null):Dynamic;
	
}