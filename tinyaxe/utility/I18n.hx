package tinyaxe.utility;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end
/**
 * @time 2015/1/15 15:07:51
 * @author Hoothin
 */
class I18n {
	macro public static function str(langId:String):Expr {
		var result:String = "";
		var xml:Xml = null;
		try{
			xml = Xml.parse(sys.io.File.getContent("./language.xml"));
		}catch (e:Dynamic) {
			return Context.makeExpr("", Context.currentPos());
		}
		for (language in xml.firstElement().elements()) {
			if (language.nodeName == langId) {
				result = language.get("str");
				break;
			}
		}
		return Context.makeExpr(result, Context.currentPos());
	}
}