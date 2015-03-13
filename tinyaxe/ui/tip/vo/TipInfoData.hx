package tinyaxe.ui.tip.vo;
import tinyaxe.ui.component.BaseComponent;

/**
 * ...
 * @author Hoothin
 */
class TipInfoData {
	
	public var delayTime(get_delayTime, null):Int;
	public var tipComponent(get_tipComponent, null):BaseComponent;
	
	
	private var _delayTime:Int;
	private var _tipComponent:BaseComponent;
	public function new() {
		
	}
	
	public function changeDelayTime(delayTime:Int):Void{
		this._delayTime = delayTime;
	}
	
	function get_delayTime():Int {
		return _delayTime;
	}
	
	function get_tipComponent():BaseComponent {
		return _tipComponent;
	}
}