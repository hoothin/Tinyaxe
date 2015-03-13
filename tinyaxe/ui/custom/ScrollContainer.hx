package tinyaxe.ui.custom;

import tinyaxe.utility.GameFilterEnum;
import openfl.events.Event;
import openfl.events.MouseEvent;
import ru.stablex.ui.skins.Skin;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.Scroll;
import ru.stablex.ui.widgets.Widget;

/**
 * @time 2013/12/3 17:16:14
 * @author Hoothin
 */
class ScrollContainer extends Scroll{
	
	public var vBarNormalSkin(null, set_vBarNormalSkin):Skin;
	public var hBarNormalSkin(null, set_hBarNormalSkin):Skin;

	public var speed:Int = 10;
	public var upBtn:Button;
	public var downBtn:Button;
	public var leftBtn:Button;
	public var rightBtn:Button;
	public var vBarCenter:Widget;
	public var hBarCenter:Widget;
	public var vBarClickSkin:Skin;
	public var vBarHoverSkin:Skin;
	public var hBarClickSkin:Skin;
	public var hBarHoverSkin:Skin;
	public var sideFace:String = "right";
	public var autoScroll:Bool = true;
	public var alwayScroll:Bool = false;
	private var _vBarNormalSkin:Skin;
	private var _hBarNormalSkin:Skin;
	private var autoWhenBottom:Bool = true;
	public function new() {
		super();
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public function onCreate():Void {
		upBtn = UIBuilder.create(Button, {
			top  : 0,
			right : 0,
			w    : 10,
			h    : 10
		});
		upBtn.removeChild(upBtn.label);
		downBtn = UIBuilder.create(Button, {
			bottom  : 0,
			right : 0,
			w    : 10,
			h    : 10
		});
		downBtn.removeChild(downBtn.label);
		leftBtn = UIBuilder.create(Button, {
			bottom  : 0,
			left : 0,
			w    : 10,
			h    : 10
		});
		leftBtn.removeChild(leftBtn.label);
		rightBtn = UIBuilder.create(Button, {
			bottom  : 0,
			right : 0,
			w    : 10,
			h    : 10
		});
		rightBtn.removeChild(rightBtn.label);
		vBarCenter = UIBuilder.create(Widget, {
			w			  : 9,
			h			  : 11,
			mouseEnabled  : false,
			mouseChildren : false,
			visible       : false
		});
		hBarCenter = UIBuilder.create(Widget, {
			w			  : 11,
			h			  : 9,
			mouseEnabled  : false,
			mouseChildren : false,
			visible       : false
		});
		this.vBar.slider.addChild(vBarCenter);
		this.hBar.slider.addChild(hBarCenter);
		upBtn.visible = false;
		downBtn.visible = false;
		leftBtn.visible = false;
		rightBtn.visible = false;
		this.vBar.w = 15;
		this.hBar.h = 15;
		upBtn.addEventListener(MouseEvent.CLICK, clickHandler);
		downBtn.addEventListener(MouseEvent.CLICK, clickHandler);
		leftBtn.addEventListener(MouseEvent.CLICK, clickHandler);
		rightBtn.addEventListener(MouseEvent.CLICK, clickHandler);
		this.vBar.slider.addEventListener(MouseEvent.MOUSE_DOWN, vBarMouseHandler);
		this.vBar.slider.addEventListener(MouseEvent.MOUSE_UP, vBarMouseHandler);
		this.vBar.slider.addEventListener(MouseEvent.MOUSE_OVER, vBarMouseHandler);
		this.vBar.slider.addEventListener(MouseEvent.MOUSE_OUT, vBarMouseHandler);
		this.hBar.slider.addEventListener(MouseEvent.MOUSE_DOWN, hBarMouseHandler);
		this.hBar.slider.addEventListener(MouseEvent.MOUSE_UP, hBarMouseHandler);
		this.hBar.slider.addEventListener(MouseEvent.MOUSE_OVER, hBarMouseHandler);
		this.hBar.slider.addEventListener(MouseEvent.MOUSE_OUT, hBarMouseHandler);
		super.onCreate();
		switch(sideFace) {
			case "right":
				this.vBar.right = 0;
				this.upBtn.right = 0;
				this.downBtn.right = 0;
			case "left":
				this.vBar.left = 0;
				this.upBtn.left = 0;
				this.downBtn.left = 0;
		}
	}
	
	override public function refresh () : Void {
		this.addChildAt(this.upBtn, 1);
		this.addChildAt(this.downBtn, 1);
		this.addChildAt(this.leftBtn, 1);
		this.addChildAt(this.rightBtn, 1);
		super.refresh();
		if ( this.vBar != null ) {
			var k : Float = this.vBar.h / this.box.h;
			if ( k >= 1 ) {
				this.vBar.visible = false;
				upBtn.visible = false;
				downBtn.visible = false;
				rightBtn.right = 0;
			}else {
				this.vBar.visible = true;
				upBtn.visible = true;
				downBtn.visible = true;
				rightBtn.right = 10;
			}
			if (this.h > 30) {
				this.vBar.scaleY = (this.vBar.h - 30) / this.vBar.h;
				this.vBar.top = 15;
				this.vBarCenter.scaleY = 1 / this.vBar.scaleY;
			}
			if ((autoWhenBottom && autoScroll) || alwayScroll) {
				//if (this.vBar.value != this.vBar.min)
				this.vBar.value = this.vBar.min;
			}
			this.vBar.slider.h = this.vBar.slider.h < 20?20:this.vBar.slider.h;
			this.vBar.refresh();
			this.vBarCenter.x = (this.vBar.slider.w - this.vBarCenter.w) / 2;
			this.vBarCenter.y = (this.vBar.slider.h - this.vBarCenter.h) / 2;
		}
		if ( this.hBar != null ) {
			var k : Float = this.hBar.w / this.box.w;
			if ( k >= 1 ) {
				this.hBar.visible = false;
				leftBtn.visible = false;
				rightBtn.visible = false;
			}else {
				this.hBar.visible = true;
				leftBtn.visible = true;
				rightBtn.visible = true;
			}
			if (this.w > 30) {
				this.hBar.w = this.w - 30;
				this.hBar.left = 15;
			}
			if ((autoWhenBottom && autoScroll) || alwayScroll) {
				//if (this.hBar.value != this.hBar.min)
				this.hBar.value = this.hBar.min;
			}
			this.hBar.slider.w = this.hBar.slider.w < 20?20:this.hBar.slider.w;
			this.hBar.refresh();
			this.hBarCenter.x = (this.hBar.slider.w - this.hBarCenter.w) / 2;
			this.hBarCenter.y = (this.hBar.slider.h - this.hBarCenter.h) / 2;
		}
		switch(sideFace) {
			case "right":
				this.box.left = 0;
			case "left":
				this.box.left = 10;
		}
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	override private function set_scrollX (x:Float) : Float {
		super.set_scrollX(x);
		if (x >= 0) {
			leftBtn.mouseEnabled = false;
			//leftBtn.filters = [GameFilterEnum.grayColorMatrixFilter];
		}else {
			leftBtn.mouseEnabled = true;
			leftBtn.filters = [];
		}
		if (x <= this._width - this.box._width) {
			rightBtn.mouseEnabled = false;
			//rightBtn.filters = [GameFilterEnum.grayColorMatrixFilter];
		}else {
			rightBtn.mouseEnabled = true;
			rightBtn.filters = [];
		}
		return x;
	}
	
	override private function set_scrollY (y:Float) : Float {
		super.set_scrollY(y);
		if (y >= 0) {
			upBtn.mouseEnabled = false;
			//upBtn.filters = [GameFilterEnum.grayColorMatrixFilter];
		}else {
			upBtn.mouseEnabled = true;
			upBtn.filters = [];
		}
		if (y <= this._height - this.box._height) {
			if (downBtn.mouseEnabled != false)
			this.dispatchEvent(new Event("scorllOver"));
			downBtn.mouseEnabled = false;
			//downBtn.filters = [GameFilterEnum.grayColorMatrixFilter];
		}else {
			downBtn.mouseEnabled = true;
			downBtn.filters = [];
		}
		if (y <= this.height - this.box.height) {
			autoWhenBottom = true;
		}else {
			autoWhenBottom = false;
		}
		return y;
	}

	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function clickHandler(e:MouseEvent):Void {
		if (e.currentTarget == upBtn) {
			this.scrollY += speed;
		}else if(e.currentTarget == downBtn) {
			this.scrollY -= speed;
		}else if(e.currentTarget == leftBtn) {
			this.scrollX += speed;
		}else {
			this.scrollX -= speed;
		}
		e.stopPropagation();
	}
	
	private function hBarMouseHandler(e:MouseEvent):Void {
		switch(e.type) {
			case MouseEvent.MOUSE_DOWN:
				if (hBarClickSkin != null) {
					this.hBar.slider.skin = hBarClickSkin;
					this.hBar.slider.refresh();
				}
			case MouseEvent.MOUSE_UP:
				if (_hBarNormalSkin != null) {
					this.hBar.slider.skin = _hBarNormalSkin;
					this.hBar.slider.refresh();
				}
			case MouseEvent.MOUSE_OVER:
				if (hBarHoverSkin != null) {
					this.hBar.slider.skin = hBarHoverSkin;
					this.hBar.slider.refresh();
				}
			case MouseEvent.MOUSE_OUT:
				if (_hBarNormalSkin != null) {
					this.hBar.slider.skin = _hBarNormalSkin;
					this.hBar.slider.refresh();
				}
		}
	}
	
	private function vBarMouseHandler(e:MouseEvent):Void {
		switch(e.type) {
			case MouseEvent.MOUSE_DOWN:
				if (vBarClickSkin != null) {
					this.vBar.slider.skin = vBarClickSkin;
					this.vBar.slider.refresh();
				}
			case MouseEvent.MOUSE_UP:
				if (_vBarNormalSkin != null) {
					this.vBar.slider.skin = _vBarNormalSkin;
					this.vBar.slider.refresh();
				}
			case MouseEvent.MOUSE_OVER:
				if (vBarHoverSkin != null) {
					this.vBar.slider.skin = vBarHoverSkin;
					this.vBar.slider.refresh();
				}
			case MouseEvent.MOUSE_OUT:
				if (_vBarNormalSkin != null) {
					this.vBar.slider.skin = _vBarNormalSkin;
					this.vBar.slider.refresh();
				}
		}
	}
	
	private function set_vBarNormalSkin(value:Skin):Skin {
		this.vBar.slider.skin = value;
		this.vBar.slider.refresh();
		return _vBarNormalSkin = value;
	}
	
	private function set_hBarNormalSkin(value:Skin):Skin {
		this.hBar.slider.skin = value;
		this.hBar.slider.refresh();
		return _hBarNormalSkin = value;
	}
}