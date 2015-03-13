package tinyaxe.utility;
import openfl.external.ExternalInterface;
import openfl.Lib;

/**
 * @time 2013/9/29 15:26:59
 * @author Hoothin
 */
class Debug {
	public static var WARNING:String = "Warning";
	public static var ERROR:String = "Error";
	public static var NORMAL:String = "Normal";
	
	public static var inner(get, null):Bool;
	private static var init:Bool;
	public static function trace(log:Dynamic, type:String = "Normal", isPrivate:Bool = true):Void { 
		#if debug
		trace(type + ":" + Std.string(log));
		#end
		if (ExternalInterface.available) {
			if (!isPrivate || inner) {
				switch(type) {
					case "Warning":
						ExternalInterface.call('console.warn', "%c" + Std.string(log), "color:yellow"); 
					case "Error":
						ExternalInterface.call('console.error', "%c" + Std.string(log), "color:red"); 
					case "Normal":
						ExternalInterface.call('console.log', log); 
				}
			}
		}
	}
	
	static function get_inner():Bool {
		if (!init) {
			#if debug
			inner = true;
			#else
			inner = (ExternalInterface.available && ExternalInterface.call("window.location.host.toString") == "192.168.10.114:8080");
			#end
			init = true;
		}
		return inner;
	}
}