package tinyaxe.utility;
import openfl.net.SharedObject;

/**
 * @time 2013/10/29 9:14:37
 * @author Hoothin
 */
class OpenflCookie {
	
	public static function getCookie(cookieName:String, cookieKey:String):String {
		var _cookie = SharedObject.getLocal(cookieName);
		if (Reflect.hasField(_cookie.data, cookieKey)) {
			return Reflect.getProperty(_cookie.data, cookieKey);
		}
		return null;
	}
	
	public static function setCookie(cookieName:String, cookieKey:String, cookieValue:String):Void {
		var _cookie = SharedObject.getLocal(cookieName);
		Reflect.setProperty(_cookie.data, cookieKey, cookieValue);
		_cookie.flush();
	} 

}