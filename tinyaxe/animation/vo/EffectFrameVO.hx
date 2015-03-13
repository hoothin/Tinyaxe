package tinyaxe.animation.vo;
import tinyaxe.resource.xml.ImageConfigXmlVO;
import openfl.geom.Point;
import openfl.display.BitmapData;

/**
 * ...
 * @author Hoothin
 */
class EffectFrameVO {
	private var _offsetPoint:Point;
	private var _bitmapData:BitmapData;
	
	public var initX(get, null):Int;
	public var initY(get, null):Int;
	public var initW(get, null):Int;
	public var initH(get, null):Int;
	
	public function new() {
		
	}
	
	public function initEffectConfig(effectConfigVO:ImageConfigXmlVO):Void {
		this._offsetPoint = new Point(effectConfigVO.offsetX, effectConfigVO.offsetY);
	}
	
	public function initBitmapData(bitmapData:BitmapData):Void {
		this._bitmapData = bitmapData;
	}
	
	public function setBitmapDataInfo(initX:Int, initY:Int, initW:Int, initH:Int):Void {
		this.initX = initX;
		this.initY = initY;
		this.initW = initW;
		this.initH = initH;
	}
	
	function get_bitmapData():BitmapData {
		return _bitmapData;
	}
	
	public var bitmapData(get_bitmapData, null):BitmapData;
	
	function get_offsetPoint():Point {
		return _offsetPoint;
	}
	
	public var offsetPoint(get_offsetPoint, null):Point;
	
	function get_initX():Int {
		return initX;
	}
	
	function get_initY():Int {
		return initY;
	}
	
	function get_initW():Int {
		return initW;
	}
	
	function get_initH():Int {
		return initH;
	}
}