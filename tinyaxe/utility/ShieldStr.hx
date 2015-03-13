package tinyaxe.utility;
import tinyaxe.resource.enums.ResTypeEnum;
import tinyaxe.resource.ResourceManager;
import openfl.utils.ByteArray;
/**
 * @time 2013/12/17 10:27:43
 * @author Hoothin
 */
class ShieldStr{

	private var shieldMap:Map<Int, SNode>;
	
	private var source:String = "*********************************";
	
	private static var instance:ShieldStr;
	
	public function new() {
		shieldMap = new Map();
		this.unCompress('♍');
		ResourceManager.prepareRes(["assets/res/data_filter.txt"], ResTypeEnum.ResTypeBinaryData, resPrepareComplete);
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public function unCompress(str:String):Void {
		var arr:Array<String> = str.split(",");
		var code:Int;
		var pNode:SNode, node:SNode;
		while (arr.length != 0) {
			str = arr.shift();
			pNode = null;
			for (i in 0...str.length) {
				code = str.charCodeAt(i);
				if (i == 0) { 
					if (shieldMap.get(code) != null) {
						node = shieldMap.get(code);
					} else {
						node = new SNode(code);
						shieldMap.set(code, node);
					}
				} else { 
					if (pNode.childDic.get(code) != null) {
						node = pNode.childDic.get(code);
					} else {
						node = new SNode(code);
						pNode.childDic.set(code, node);
					}
				}
				if (i == str.length - 1) {
					node.canEnd = true;
					break;
				}
				pNode = node;
			}
		}
	}
	
	public function checkStr(string:String):String {
		var code:Int;
		var position:Int = 0, length:Int = 0;
		var node:SNode = null, pNode:SNode = null;
		var findHead:Bool = false;
		var i:Int = 0;
		while (i < string.length) {
			code = string.charCodeAt(i);
			if (code == 32) {
				i++;
				continue;
			}
			if (findHead) {
				node = checkNode(pNode, code);
				if (node != null) {
					if (node.canEnd)
						length = i - position + 1;
					pNode = node;
				} else {
					if (length != 0) { 
						string = replace(string, position, length);
					}
					i -= 1;
					findHead = false;
					length = 0;
					pNode = null;
				}
			} else {
				node = shieldMap.get(code);
				if (node != null) {
					findHead = true;
					position = i;
					if (node.canEnd)
						++length;
					pNode = node;
				} else {
					i++;
					continue;
				}
			}
			i++;
		}
		if (length != 0) {
			string = replace(string, position, length);
		}
		return string;
	}
	
	public function hasShieldStr(string:String):Bool {
		var code:Int;
		var position:Int = 0, length:Int = 0;
		var node:SNode = null, pNode:SNode = null;
		var findHead:Bool = false;
		var i:Int = 0;
		while (i < string.length) {
			code = string.charCodeAt(i);
			if (code == 32) {
				i++;
				continue;
			}
			if (findHead) {
				node = checkNode(pNode, code);
				if (node != null) {
					if (node.canEnd)
						length = i - position + 1;
					pNode = node;
				} else {
					if (length != 0) {
						return true;
					}
					i -= 1;
					findHead = false;
					length = 0;
					pNode = null;
				}
			} else {
				node = shieldMap.get(code);
				if (node != null) {
					findHead = true;
					position = i;
					if (node.canEnd)
						++length;
					pNode = node;
				} else {
					i++;
					continue;
				}
			}
			i++;
		}
		if (length != 0) {
			return true;
		}
		return false;
	}
	
	public static function getInstance():ShieldStr {
		if (instance == null) {
			instance = new ShieldStr();
		}
		return instance;
	}
	
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	private function checkNode(node:SNode, childCode:Int):SNode {
		return node.childDic.get(childCode);
	}
	
	private function replace(string:String, position:Int, length:Int):String {
		var str:String = '';
		str += string.substr(0, position);
		str += source.substr(0, length);
		str += string.substr(position + length, string.length);
		return str;
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function resPrepareComplete():Void {
		var shieldData:ByteArray = ResourceManager.getBinaryData("assets/res/data_filter.txt");
		shieldData.position = 0;
		this.unCompress(shieldData.readUTFBytes(shieldData.length));
	}
}

private class SNode {
	
	public var canEnd:Bool;
	
	public var childDic:Map<Int, SNode>;
	
	public var code(get_code, null):Int;
	
	private var _code:Int;
	
	public function new(code:Int) {
		_code = code;
		childDic = new Map();
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public function get_code():Int{
		return _code;
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
}