package tinyaxe.layer;

import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author Hoothin
 */
class UILayer extends Sprite {

	public var maskBG:Sprite;
	public function new() {
		super();
		this.maskBG = new Sprite();
		this.maskBG.graphics.beginFill(0x000000, 0.3);
		this.maskBG.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		this.maskBG.graphics.endFill();
		this.maskBG.visible = false;
		this.addChild(maskBG);
		Lib.current.stage.addEventListener(Event.RESIZE, resizeHandler);
	}
	
	private function resizeHandler(e:Event):Void {
		this.maskBG.width = Lib.current.stage.stageWidth;
		this.maskBG.height = Lib.current.stage.stageHeight;
	}
}