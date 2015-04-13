package tinyaxe.utility;
import openfl.net.SharedObject;

/**
 * @time 2013/10/29 9:14:37
 * @author Hoothin
 */
class OpenflCookie {
	public static var cookieName:String = "";
	public static function getCookie(cookieKey:String, ?_cookieName:String):String {
		if (_cookieName != null) cookieName = _cookieName;
		var _cookie = SharedObject.getLocal(cookieName);
		if (Reflect.hasField(_cookie.data, cookieKey)) {
			return Reflect.getProperty(_cookie.data, cookieKey);
		}
		return null;
	}
	
	public static function setCookie(cookieKey:String, cookieValue:String, ?_cookieName:String):Void {
		if (_cookieName != null) cookieName = _cookieName;
		var _cookie = SharedObject.getLocal(cookieName);
		Reflect.setProperty(_cookie.data, cookieKey, cookieValue);
		_cookie.flush();
	} 
	
	public static function clear(?_cookieName:String):Void {
		if (_cookieName != null) cookieName = _cookieName;
		var _cookie = SharedObject.getLocal(cookieName);
		_cookie.clear();
	}

}