package tinyaxe.utility;
import openfl.events.TimerEvent;
import openfl.Lib;
import openfl.utils.Timer;

/**
 * @time 2013/12/24 15:04:15
 * @author Hoothin
 */
class TimeKeeper{
	static var registedTimerArr:Array<Array<Dynamic>> = [];
	
	static var _isOpen:Bool = false;
	
	static var time:Timer = new Timer(1);
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	static public function addTimerEventListener(callBackFun:Dynamic, delay:Float = 1000, ?argsArr:Array<Dynamic> = null):Void {
		for (value in registedTimerArr) {
			if (delay != 0 && value[0] == callBackFun) {
				value[1] = delay;
				value[2] = Date.now().getTime();
				value[3] = argsArr;
				return;
			}
		}
		registedTimerArr.push([callBackFun, delay, Date.now().getTime(), argsArr]);
	}
	
	static public function removeTimerEventListener(callBackFun:Dynamic):Void {
		for (value in registedTimerArr) {
			if (value[0] == callBackFun) {
				registedTimerArr.remove(value);
				return;
			}
		}
	}
	
	public static function openListener():Void {
		if (!_isOpen) {
			time.addEventListener(TimerEvent.TIMER, timerHandler);
			time.start();
			_isOpen = true;
		}
	}
	
	public static function closeListener():Void {
		if (_isOpen) {
			time.removeEventListener(TimerEvent.TIMER, timerHandler);
			time.stop();
			_isOpen = false;
		}
	}
	
	public static function getTimeString(t : Float):String {
		var timeObj:Dynamic = DateTools.parse(t);
		var hours:String = timeObj.hours < 10?"0" + timeObj.hours:timeObj.hours;
		var minutes:String = timeObj.minutes < 10?"0" + timeObj.minutes:timeObj.minutes;
		var seconds:String = timeObj.seconds < 10?"0" + timeObj.seconds:timeObj.seconds;
		return(hours + ":" + minutes + ":" + seconds);
	}
	
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	static private function timerHandler(e:TimerEvent):Void {
		for (value in registedTimerArr.copy()) {
			if (value[2] <= Date.now().getTime() - value[1]) {
				var argsArr:Array<Dynamic> = value[3];
				if (argsArr == null) {
					argsArr = [Date.now().getTime() - value[2]];
				}
				Reflect.callMethod (value[0], value[0], argsArr);
				value[2] = Date.now().getTime();
				if (value[1] == 0) {
					registedTimerArr.remove(value);
					break;
				}
			}
		}
	}
}