package tinyaxe.ui.tip;
import tinyaxe.ui.tip.component.TipWindow;
import tinyaxe.ui.tip.vo.TipInfoData;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.utils.Timer;
import ru.stablex.ui.widgets.Tip;
import tinyaxe.layer.LayerManager;
import openfl.Lib;
import openfl.events.TimerEvent;

/**
 * ...
 * @author Hoothin
 */
class TipManager {
	private static var _tipManager:TipManager;
	private static inline var BOARD_GAP:Float = 5;
	
	private var _bindTipList:Map<DisplayObject, TipInfoData>;
	private var _currentDelayTarget:DisplayObject;
	private var _currentTipWindow:TipWindow;
	private var _delayTimer:Timer;

	public function new() {
		this._bindTipList = new Map<DisplayObject, TipInfoData>();
		this._delayTimer = new Timer(1000, 1);
		this._delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayComplete);
	}
	
	public static function getInstance():TipManager {
		if (_tipManager == null) {
			_tipManager = new TipManager();
		}
		
		return _tipManager;
	}
	
	public function bindTip(bindObject:DisplayObject, tipData:TipInfoData, ?delayTime:Int = 200):Void {
		if (this._bindTipList.exists(bindObject)) {
			this.unbindTip(bindObject);
		}
		tipData.changeDelayTime(delayTime);
		this._bindTipList.set(bindObject, tipData);
		bindObject.addEventListener(MouseEvent.ROLL_OVER, showTip);
		bindObject.addEventListener(MouseEvent.ROLL_OUT, hideTip);
		bindObject.addEventListener(MouseEvent.MOUSE_MOVE, moveTip);
	}
	
	public function unbindTip(bindObject:DisplayObject):Void {
		if (this._bindTipList.exists(bindObject)) {
			bindObject.removeEventListener(MouseEvent.ROLL_OVER, showTip);
			bindObject.removeEventListener(MouseEvent.ROLL_OUT, hideTip);
			bindObject.removeEventListener(MouseEvent.MOUSE_MOVE, moveTip);
			this._bindTipList.remove(bindObject);
		}
		this.hideTip(null);
	}
	
	public function updateTipData(bindObject:DisplayObject, tipData:TipInfoData):Void {
		if (this._bindTipList.exists(bindObject)) {
			tipData.changeDelayTime(this._bindTipList.get(bindObject).delayTime);
			this._bindTipList.set(bindObject, tipData);
		}
		if (this._currentDelayTarget == bindObject && this._currentTipWindow != null) {
			this._currentTipWindow.updateTip(tipData);
		}
	}
	
	private function showTip(event:MouseEvent):Void {
		var targetObject:DisplayObject = event.currentTarget;
		var targetTipData:TipInfoData = this._bindTipList.get(targetObject);
		if (targetTipData != null) {
			this._currentTipWindow = new TipWindow(targetTipData);
			this.reposTipWindow(event.stageX, event.stageY);
			if (targetTipData.delayTime > 0) {
				this._delayTimer.reset();
				this._delayTimer.delay = targetTipData.delayTime;
				this._delayTimer.start();
			}else {
				LayerManager.getInstance().addChildObj(this._currentTipWindow, LayerManager.TIP_LAYER);
				this._currentTipWindow.startShow();
			}
			this._currentDelayTarget = targetObject;
		}
	}
	
	private function delayComplete(event:TimerEvent):Void {
		if (this._currentDelayTarget != null && this._currentTipWindow != null) {
			LayerManager.getInstance().addChildObj(this._currentTipWindow, LayerManager.TIP_LAYER);
			this._currentTipWindow.startShow();
		}
	}
	
	private function hideTip(event:MouseEvent):Void {
		if (this._currentTipWindow != null) {
			if (this._currentTipWindow.parent != null) {
				this._currentTipWindow.parent.removeChild(this._currentTipWindow);
			}
			this._currentTipWindow.cleanTip();
			this._currentTipWindow = null;
			this._currentDelayTarget = null;
		}
		this._delayTimer.stop();
		this._delayTimer.reset();
	}
	
	private function moveTip(event:MouseEvent):Void {
		if (this._currentTipWindow != null) {
			this.reposTipWindow(event.stageX, event.stageY);
		}
	}
	
	private function reposTipWindow(stageX:Float, stageY:Float):Void {
		if (this._currentTipWindow != null) {
			var stageWidth:Float = LayerManager.SHOW_WIDTH;
			var stageHeight:Float = LayerManager.SHOW_HEIGHT;
			
			if (stageX < stageWidth / 2 && stageY < stageHeight / 2) {
				this._currentTipWindow.x = stageX + BOARD_GAP;
				this._currentTipWindow.y = stageY + BOARD_GAP;
			}else if (stageX >= stageWidth / 2 && stageY < stageHeight / 2) {
				this._currentTipWindow.x = stageX - BOARD_GAP - this._currentTipWindow.getWidth();
				this._currentTipWindow.y = stageY + BOARD_GAP;
			}else if (stageX < stageWidth / 2 && stageY >= stageHeight / 2) {
				this._currentTipWindow.x = stageX + BOARD_GAP;
				this._currentTipWindow.y = stageY - BOARD_GAP - this._currentTipWindow.getHeight();
			}else if (stageX >= stageWidth / 2 && stageY >= stageHeight / 2) {
				this._currentTipWindow.x = stageX - BOARD_GAP - this._currentTipWindow.getWidth();
				this._currentTipWindow.y = stageY - BOARD_GAP - this._currentTipWindow.getHeight();
			}
		}
	}
}