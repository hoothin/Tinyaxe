package tinyaxe.utility;
using unifill.Unifill;

/**
 * @time 2015/4/10 17:00:03
 * @author Hoothin
 */
class Encrypt {
	/**
	 * 加密数字与字母
	 * @param	value
	 * @return
	 */
	public static function encrypt(value:String):String {
		var resultArr:Array<Int> = [];
		var code:Int = Std.int(1000 * Math.random());
		var offset:Int = code;
		resultArr.push(code);
		for (i in 0...value.uLength()) {
			code = value.uCharCodeAt(i);
			if (code > 125) {
				resultArr.push(code);
			}else {
				resultArr.push(code + offset);
			}
			
			offset += code;
		}
		return resultArr.join(".");
	}
	
	/**
	 * 解密数字与字母
	 * @param	value
	 * @return
	 */
	public static function decrypt(value:String):String {
		var result:String = "";
		var code:Int;
		var offset:Int = 0;
		var code:Int = 0;
		for (i in value.split(".")) {
			code = Std.parseInt(i);
			if (code > 125 + offset) {
				
			}else {
				code -= offset;
			}
			result += String.fromCharCode(code);
			offset += code;
		}
		return result.substr(1);
	}
}