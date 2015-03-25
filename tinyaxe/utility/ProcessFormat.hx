package tinyaxe.utility;
import haxe.macro.Expr.Constant;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.ExprDef;

/**
 * @time 2015/3/25 10:25:56
 * @author Hoothin
 */
class ProcessFormat{
	macro public static function build():Array<Field> {        
        var pos = haxe.macro.Context.currentPos();
		var resultFields:Array<Field> = [];
        var fields = haxe.macro.Context.getBuildFields();
		for (field in fields) {
			switch(field.kind) {
				case FieldType.FVar(t, e):
					if (t.getParameters()[0].name == "TextFormat") {
						switch (e.expr) {
							case ExprDef.ENew(tp, params):
								switch (params[0].expr) {
									case ExprDef.EConst(c):
										switch(c) {
											case Constant.CIdent(s):
												#if android
												params[0] = macro new Font('/system/fonts/DroidSansFallback.ttf').fontName;
												#elseif windows
												params[0].expr = ExprDef.EConst(Constant.CString("assets/res/jzy.ttf"));
												#else
												#end
												var resultField:Field = {
													name : field.name, 
													doc : field.doc, 
													meta : field.meta, 
													access : field.access, 
													kind : FieldType.FVar(t, {
														expr:ExprDef.ENew(tp, params),
														pos:e.pos
													}), 
													pos : field.pos 
												};
												resultFields.push(resultField);
											case _:
												resultFields.push(field);
										}
									case _:
										resultFields.push(field);
								}
							case _:
								resultFields.push(field);
						}
					}
				case _:
					resultFields.push(field);
			}
		}
        return resultFields;
    }

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Get/Set
	-------------------------------------------------------------------------------------------*/
	
}