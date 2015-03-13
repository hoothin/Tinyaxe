package tinyaxe.ui;
import haxe.macro.Context;
import haxe.macro.Expr;
import ru.stablex.ui.UIBuilder;

/**
 * ...
 * @author Hoothin
 */
class InitUI {
	macro static public function init () : Expr {
		#if macro
		UIBuilder.regClass('tinyaxe.ui.custom.Frame');
		UIBuilder.regClass('tinyaxe.ui.custom.KeyValuePanel');
		UIBuilder.regClass('tinyaxe.ui.custom.PageCount');
		UIBuilder.regClass('tinyaxe.ui.custom.PageContainer');
		UIBuilder.regClass('tinyaxe.ui.custom.ProgressBar');
		UIBuilder.regClass('tinyaxe.ui.custom.ScrollContainer');
		UIBuilder.regClass('tinyaxe.ui.custom.ComboBox');
		UIBuilder.regClass('tinyaxe.ui.custom.LinkText');
		UIBuilder.regClass('tinyaxe.ui.layouts.SimpleBox');
		UIBuilder.regClass('tinyaxe.ui.custom.Tree');
		#end
		return Context.parse("true", Context.currentPos());
	}	
}