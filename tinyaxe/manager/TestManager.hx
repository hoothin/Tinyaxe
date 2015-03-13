package tinyaxe.manager ;
import tinyaxe.scene.Scene;
import tinyaxe.utility.I18n;
import tinyaxe.utility.ShortCutsKey;
import tinyaxe.utility.TextFilterEnum;
import tinyaxe.utility.TextFormatEnum;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;

/**
 * @time 2014/12/22 17:46:11
 * @author Hoothin
 */
class TestManager {

	static var testManager:TestManager;
	var testText:TextField = new TextField();
	public function new() {
		testText.defaultTextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 50, 0xff0000, true, false, false);
		testText.text = I18n.str("go_on");
		testText.filters = [TextFilterEnum.baisemiaobian];
		testText.autoSize = TextFieldAutoSize.LEFT;
		testText.selectable = false;
		testText.x = 310;
		testText.y = 200;
		testText.addEventListener(MouseEvent.CLICK, goOnHandler);
	}
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public static function getInstance():TestManager {
		if (testManager == null) {
			testManager = new TestManager();
		}
		return testManager;
	}
	
	public function init():Void {
		trace(11);
		this.initScene();
		this.initControl();
		trace(22);
	}
	
	public function endGame() {
		testText.visible = true;
		Lib.current.addChild(testText);
	}
	
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	private function initScene():Void {
		Scene.getInstance().init();
	}
	
	private function initControl():Void {
		OrbitControl.getInstance().addToStage(0, 0, playerMove);
	}
	
	private function playerMove(moveX:Float, moveY:Float):Void {
		var modulus:Float = 5 / Math.sqrt(moveX * moveX + moveY * moveY);
		Scene.getInstance().move(moveX * modulus, moveY * modulus);
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function goOnHandler(e:Event):Void {
		if (testText.visible) {
			testText.visible = false;
			Scene.getInstance().goOn();
		}
	}
	/*-----------------------------------------------------------------------------------------
	Get/Set
	-------------------------------------------------------------------------------------------*/
	
}