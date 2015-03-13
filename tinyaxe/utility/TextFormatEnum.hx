package tinyaxe.utility;
import openfl.text.TextFormat;
import openfl.text.Font;

/**
 * @author Hoothin
 */
class TextFormatEnum {
	public static var normalUnitTextFormat:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 13, 0xffffff, false, false, false);
	public static var goodlUITextFormat:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 13, 0x00ff00, false, false, false);
	public static var badUITextFormat:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 13, 0xff0000, false, false, false);
	public static var dialogTextFormat:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0x000000, false, false, false);
	public static var smallUITextFormat:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 10, 0xffffff, false, false, false);
	public static var miniUITextFormat:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 8, 0xffffff, false, false, false);
	public static var bigUITextFormat:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 15, 0xffffff, true, false, false);
	public static var errorUITextFormat:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 18, 0xff0000, true, false, false);
	public static var xiaohuangzi11:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 11, 0xeed7b5, false, false, false);
	public static var fanye:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xffffff, false, false, false);
	public static var xiaolvse:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0x45d252, false, false, false);
	public static var huangzi14:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 14, 0xfbdb92, false, false, false);
	public static var xiaohuangzi14:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 14, 0xd0b77a, false, false, false);
	public static var xiaohongzi12:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xfc4141, false, false, false);
	public static var hongshuzi12:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xd0ca8b, false, false, false);
	public static var xiaolanzi12:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0x199cbd, false, false, false);
	public static var lianghuangzi12:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xfbdb92, false, false, false);
	public static var lianghuangzi212:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xffdd22, false, false, false);
	public static var huangzi112:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xefba49, false, false, false);
	public static var huangzi115:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 15, 0xefba49, true, false, false);
	public static var xiaohuangzi15:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 15, 0xb7a782, false, false, false);
	public static var xiaolanzi15:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 15, 0x199cbd, false, false, false);
	public static var lianghuangzi15:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 15, 0xffdd22, false, false, false);
	public static var huisezi14:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 14, 0x4d4d4d, false, false, false);
	public static var huangzi12:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xd0b77a, false, false, false);
	public static var textFormat1:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xa530e9, false, false, false);
	public static var textFormat2:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xb7a782, false, false, false);
	public static var textFormat3:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0x4b4842, false, false, false);
	public static var textFormat4:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 15, 0x4b4842, false, false, false);
	public static var textFormat5:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 15, 0xd0ca8b, false, false, false);
	public static var textFormat7:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xff8c00, false, false, false);
	public static var textFormat8:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xc643fd, false, false, false);
	public static var textFormat9:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0x0095fe, false, false, false);
	public static var textFormat10:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xfff5a6, false, false, false);
	public static var textFormat11:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0x45ff20, false, false, false);
	public static var textFormat12:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xcc3737, false, false, false);
	public static var textFormat13:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xffe59f, false, false, false);
	public static var textFormat14:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xe65977, false, false, false);
	public static var textFormat15:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xa5a5a5, false, false, false);
	public static var textFormat16:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xfef5ce, false, false, false);
	public static var textFormat17:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xfeb832, false, false, false);
	public static var textFormat18:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xe323ae, false, false, false);
	public static var textFormat19:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0x00ff00, false, false, false);
	public static var textFormat20:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xe55f06, false, false, false);
	public static var textFormat21:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xff0800, false, false, false);
	public static var textFormat22:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0x00a9ff, false, false, false);
	public static var textFormat23:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xf1e2bf, false, false, false);
	public static var textFormat6:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0xff5400, false, false, false);
	public static var textFormat24:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 12, 0x00ccff, false, false, false);
	public static var xiaolvse15:TextFormat = new TextFormat(#if android new Font("/system/fonts/DroidSansFallback.ttf").fontName #elseif windows "assets/res/jzy.ttf" #else null #end, 15, 0x45d252, false, false, false);
}