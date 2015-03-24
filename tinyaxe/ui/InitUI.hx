package tinyaxe.ui;
import haxe.macro.Context;
import haxe.macro.Expr;
import ru.stablex.ui.UIBuilder;

/**
 * ...
 * @author Hoothin
 */
class InitUI {
	static var isInit:Bool = false;
	macro static public function init () : Expr {
		if (isInit) return macro null;
		isInit = true;
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
	
	macro static public function times (n:Int, e:Expr) : Expr {
		#if macro
		var n_expr = Context.makeExpr(n, Context.currentPos());
		return macro for (i in 0...$n_expr) { $e; };
		#end
	}
}