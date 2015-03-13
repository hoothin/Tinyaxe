package tinyaxe.ui.manager;
import motion.Actuate;
import motion.easing.IEasing;
import motion.easing.Linear;
import openfl.display.DisplayObject;
import openfl.geom.Point;

/**
 * @time 2014/9/16 15:02:32
 * @author Hoothin
 */
class EffectRoadManager{

	static var _instance:EffectRoadManager;
	public function new() {
		
	}
	
	static public function getInstance():EffectRoadManager {
		if (_instance == null) {
			_instance = new EffectRoadManager();
		}
		return _instance;
	}

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	/**
	 Tween effect by a given straight road on the stage
	 * @param	effectVO 特效实例
	 * @param	endPoint 运动结束点
	 * @param	initRotation 初始角度right=0
	 * @param	useTime 花费时间
	 * @param	startOffect 开始时间
	 * @param	callbackFun
	 * @param	argsArr
	 * @param	tweenType 特效类型
	 * @return	旋转角度
	 */
	public function tweenEffect(effectVO:DisplayObject, endPoint:Point, initRotation:Int = 0, ?useTime:Float = 1, ?startOffect:Float = 0, ?callbackFun:Dynamic, ?argsArr:Array<Dynamic> = null, ?tweenType:IEasing = null):Float {
		var angle:Float = 180 * Math.atan2(effectVO.y - endPoint.y, effectVO.x - endPoint.x) / Math.PI;
		effectVO.rotation =  angle - initRotation;
		if (tweenType == null) {
			tweenType = Linear.easeNone;
		}
		Actuate.timer(startOffect).onComplete(function() {
			Actuate.tween(effectVO, useTime, { x:endPoint.x, y:endPoint.y } ).ease(tweenType).onComplete(function() {
				if (callbackFun != null)
				Reflect.callMethod(callbackFun, callbackFun, argsArr);
			});
		});
		return effectVO.rotation;
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/

	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
}