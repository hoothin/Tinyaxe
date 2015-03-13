package tinyaxe.ui.layouts;

import tinyaxe.ui.component.BaseComponent;
import openfl.display.DisplayObject;
import ru.stablex.ui.layouts.Layout;
import ru.stablex.ui.widgets.Widget;

/**
 * @time 2013/12/4 15:05:19
 * @author Hoothin
 */
class SimpleBox extends Layout{
    //Setter for padding left, right, top, bottom.
    public var padding (never,set_padding) : Float;
    //padding left
    public var paddingLeft   : Float = 0;
    //padding right
    public var paddingRight  : Float = 0;
    //padding top
    public var paddingTop    : Float = 0;
    //padding bottom
    public var paddingBottom : Float = 0;
	//Distance between children
    public var cellVerticalPadding   : Float = 0;
    public var cellHorizontalPadding   : Float = 0;
	
	public var autoFit:Bool = true;
	
	public var lockWidth	:Int = 0;
	public var lockHeight	:Int = 0;
	
	public var turnover		:Bool = false;
	
    /**
    * Position children of provided widget according to layout logic
    *
    */
    override public function arrangeChildren(holder:Widget) : Void {
		if (lockHeight == 0 && lockWidth == 0) return;
		
        var child : DisplayObject;
		var lastX : Float = this.paddingLeft;
		var lastY : Float = this.paddingTop;
		var cellW : Float = 0;
		var cellH : Float = 0;
		var childW: Float = 0;
		var childH: Float = 0;
		
		if (turnover) {
			lastX = lockWidth - this.paddingRight;
			lastY = lockHeight - this.paddingBottom;
		}
		
		if (lockWidth != 0) {
			holder.w = lockWidth;
			
			for (i in 0...holder.numChildren) {
				if (turnover) {
					child = holder.getChildAt(holder.numChildren - 1 - i);
				}else {
					child = holder.getChildAt(i);
				}
				
				if ( !child.visible ) continue;
				
				if (Std.is(child, Widget)) {
					childH = cast(child, Widget).h;
					childW = cast(child, Widget).w;
				}else if(Std.is(child, BaseComponent)){
					childH = cast(child, BaseComponent).getHeight();
					childW = cast(child, BaseComponent).getWidth();
				}else {
					childH = child.height;
					childW = child.width;
				}
				
				if (turnover) {
					if (lastX - cellHorizontalPadding - childW < paddingLeft) {
						lastY += (cellVerticalPadding + cellH);
						lastX = lockWidth - this.paddingRight;
					}
					lastX -= (cellHorizontalPadding + childW);
					child.x = lastX;
					child.y = lastY;
				}else {
					if (lastX + cellHorizontalPadding + childW > lockWidth - paddingRight) {
						lastY += (cellVerticalPadding + cellH);
						lastX = this.paddingLeft;
						cellH = 0;
					}
					child.x = lastX;
					child.y = lastY;
					lastX += (cellHorizontalPadding + childW);
				}
				cellH   = childH > cellH?childH:cellH;
			}
			if (holder.height != 0 && autoFit)
			holder.h = lastY + cellH + paddingBottom;
		}else {
			holder.h = lockHeight;
			for(i in 0...holder.numChildren){
				child = holder.getChildAt(i);
				if (Std.is(child, Widget)) {
					childH = cast(child, Widget).h;
					childW = cast(child, Widget).w;
				}else if(Std.is(child, BaseComponent)){
					childH = cast(child, BaseComponent).getHeight();
					childW = cast(child, BaseComponent).getWidth();
				}else {
					childH = child.height;
					childW = child.width;
				}
				
				if (lastY + cellVerticalPadding + childH > lockHeight - paddingBottom) {
					lastX += (cellHorizontalPadding + cellW);
					lastY = this.paddingTop;
					cellW = 0;
				}
				child.x = lastX;
				child.y = lastY;
				lastY += (cellVerticalPadding + childH);
				cellW   = childW > cellW?childW:cellW;
			}
			if (holder.width != 0 && autoFit)
			holder.w = lastX + cellW + paddingRight;
		}
    }

    /**
    * Setter `padding`.
    *
    */
    @:noCompletion private function set_padding (padding:Float) : Float {
        return this.paddingLeft = this.paddingRight = this.paddingTop = this.paddingBottom = padding;
    }
	
}