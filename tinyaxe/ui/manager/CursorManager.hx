package tinyaxe.ui.manager;
import tinyaxe.animation.frame.FrameSprite;
import tinyaxe.layer.LayerManager;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;

/**
 * @time 2013/12/2 11:37:04
 * @author Hoothin
 */
class CursorManager{

	private static var _cursorManager:CursorManager;
	var cursor:DisplayObject;
	var cursorMap:Map<DisplayObject,DisplayObject>;
	var isAnimation:Bool;
	public function new() {
		cursorMap = new Map();
		isAnimation = false;
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public static function getInstance():CursorManager {
		if (_cursorManager == null) {
			_cursorManager = new CursorManager();
		}
		return _cursorManager;
	}
	
	public function setCursor(target:DisplayObject, cursor:DisplayObject):Void {
		this.cursorMap.set(target, cursor);
		target.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
		target.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
		target.addEventListener(MouseEvent.MOUSE_MOVE, onMoveHandler);
		if (Std.is(target, FrameSprite)) {
			isAnimation = true;
		}else {
			isAnimation = false;
		}
	}
	
	public function clearCursor(target:DisplayObject):Void {
		target.removeEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
		target.removeEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
		target.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveHandler);
		this.cursorMap.remove(target);
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function onMoveHandler(e:MouseEvent):Void {
		cursor = cursorMap.get(cast(e.currentTarget, DisplayObject));
		cursor.x = e.stageX; cursor.y = e.stageY; 
		if (!isAnimation) {
			e.updateAfterEvent();
		}
	}
	
	private function onRollOutHandler(e:MouseEvent):Void {
		cursor = cursorMap.get(cast(e.currentTarget, DisplayObject));
		if (cursor.parent != null)
			cursor.parent.removeChild(cursor);
		Mouse.show();
	}
	
	private function onRollOverHandler(e:MouseEvent):Void {
		Mouse.hide();
		cursor = cursorMap.get(cast(e.currentTarget, DisplayObject));
		cursor.x = e.stageX; cursor.y = e.stageY; 
		LayerManager.getInstance().addChildObj(cursor, LayerManager.CURSOR_LAYER);
	}
}