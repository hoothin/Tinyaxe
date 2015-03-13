package tinyaxe.utility;
import com.local.LocalManager;

/**
 * @time 2013/10/16 14:31:21
 * @author Hoothin
 */
class StringUtil{

	/**
	 * 根据项分割符与键值分割符取出键值对
	 * @param	targetString
	 * @param	partStrItem
	 * @param	partKV
	 * @return
	 */
	public static function stringToMap(targetString:String, partStrItem:String, partKV:String, ?from:Int, ?to:Int):Map<String,String>{
		var mapArr:Array<String> = new Array(); 
		if (from!=null && to!=null)
		mapArr = targetString.split(partStrItem).slice(from, to);
		else
		mapArr = targetString.split(partStrItem);
		var result:Map<String,String>=new Map();
		for (value in mapArr) {
			result.set(value.split(partKV)[0], value.split(partKV)[1]);
		}
		return result;
	}
	
	public static function arrayToMap(targetArr:Array<Dynamic>, partStr:String):Map<String,String>{
		var result:Map<String,String>=new Map();
		for (value in targetArr) {
			result.set(value.split(partStr)[0], value.split(partStr)[1]);
		}
		return result;
	}
	
	public static function getStringIndexArr(targetStr:String, fromStr:String, fromIndex:Int = 0):Array<Int> {
		var tempStr:String = fromStr.substr(fromIndex);
		var resultArr:Array<Int> = [];
		var index:Int = 0;
		while (tempStr.indexOf(targetStr) != -1) {
			index += tempStr.indexOf(targetStr);
			resultArr.push(index + fromIndex);
			index += targetStr.length;
			tempStr = tempStr.substr(tempStr.indexOf(targetStr) + targetStr.length);
		}
		return resultArr;
	}
	/**
	 * 从目标数组获得目标字符串所在项位置
	 * @param	targetArr
	 * @param	targetStr
	 * @return
	 */
	public static function getIndexFromArray(targetArr:Array<String>, targetStr:String):Int {
		for (i in 0...targetArr.length) {
			if (targetArr[i].indexOf(targetStr) != -1)
			return i;
		}
		return -1;
	}
	
	/**
	 * 截取开始标记与结束标记之间的字符串
	 * @param	targetString
	 * @param	startsWith
	 * @param	endsWith
	 * @return
	 */
	public static function getMiddleStr(targetString:String, startsWith:String, ?endsWith:String):String {
		var startSign:Int = targetString.indexOf(startsWith) + startsWith.length;
		if (endsWith != null){
			var endSign:Int = targetString.indexOf(endsWith,startSign);
			return targetString.substring(startSign, endSign);
		}else {
			return targetString.substring(startSign);
		}
	}
	
	/**
	 * 通过你妹的标记将始末targetString中间的内容按条取出存入数组
	 * @param	targetString
	 * @param	sign
	 * @return
	 */
	public static function getArrFromStrWithSign(targetString:String, startStr:String, endStr:String):Array<String> {
		var point:Int = 0;
		var startPoint:Int;
		var endPoint:Int;
		var result:Array<String> = new Array();
		while (targetString.indexOf(startStr) != -1 && targetString.indexOf(endStr) != -1) {
			startPoint = targetString.indexOf(startStr) + startStr.length;
			endPoint = targetString.indexOf(endStr);
			result.push(targetString.substring(startPoint, endPoint));
			targetString = targetString.substring(endPoint + endStr.length);
		}
		return result;
	}
	
	public static function getIntAccuracy(targetFloat:Float, decimalLength:Int):String {
		var targetArr:Array<String> = Std.string(targetFloat).split(".");
		var resultStr:String = targetArr[0] + "." + targetArr[1].substr(0, 2);
		return resultStr;
	}
	
	public static function getNumText(numberValue:Float):String {
		if (numberValue < 1000000) {
			return Std.string(numberValue);
		}else if (numberValue < 100000000) {
			return Std.int(numberValue / 10000) + LocalManager.getInstance().localizeLanguage("tenThousand");
		}else {
			return Std.int(numberValue / 100000000) + LocalManager.getInstance().localizeLanguage("hundredMillion");
		}
	}
}