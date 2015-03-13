package tinyaxe.utility;
import openfl.external.ExternalInterface;

/**
 * @time 2013/10/16 14:32:57
 * @author Hoothin
 */
class CookieUtil {
	public static function getCookie(cookieName:String):String {
		var r:String = "";
		var search:String = cookieName + "=";
		var js:String = "function get_cookie(){return document.cookie;}";
		var o:Dynamic = ExternalInterface.call(js);
		var cookieVariable:String = Std.string(o);
		if (cookieVariable.length > 0) {
			var offset:Int = cookieVariable.indexOf(search);
			if (offset != -1) {
				offset += search.length;
				var end:Int = cookieVariable.indexOf(";", offset);
				if (end == 1) {
					end = cookieVariable.length;
				}
				r = StringTools.urlDecode(cookieVariable.substring(offset, end));
			}
		}
		return r;
	}
	
	public static function setCookie(cookieName:String, cookieValue:String):Void {
		var js:String = "function sc(){";
		js += "var c = escape('" + cookieName + "') + '=' + escape('" + cookieValue + "') + '; path=/';";
		js += "document.cookie = c;";
		js += "}";
		ExternalInterface.call(js);
	}

}