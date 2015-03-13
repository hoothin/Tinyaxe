package tinyaxe.ui.custom;

import openfl.display.BitmapData;
import openfl.events.MouseEvent;
import openfl.text.TextFormat;
import ru.stablex.ui.skins.Skin;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.VBox;

/**
 * @time 2014/5/5 15:28:29
 * @author Hoothin
 */
class Tree extends VBox {

	public var hideBtnIco(default, set):BitmapData;
	public var showBtnIco(default, set):BitmapData;
	public var treeData:Array<Dynamic>;
	public var openBtn:Button;
	public var treeBox:VBox;
	public var treeNodeFormat:TextFormat;
	public var treeSkin(default, set):Skin;
	public var treeHoverSkin(default, set):Skin;
	public var treeClickSkin(default, set):Skin;
	var callBackFun:String->Button->Void;
	var btnMap:Map<Button, String>;
	public function new() {
		super();
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public function onCreate():Void {
		openBtn = UIBuilder.create(Button, {
			w     : this.w,
			h     : 20,
			align : 'left,middle'
		});
		openBtn.addEventListener(MouseEvent.CLICK, clickHandler);
		addChild(openBtn);
		treeBox = UIBuilder.create(VBox);
		addChild(treeBox);
	}
	
	/**
	 * ["主线",[["沧州城", [["沧州城楼", "lou"], ["沧州大门","men"]]], ["青州城门","qing"]]]
	 * @param	data
	 * @param	callBackFun
	 */
	public function setData(data:Array<Dynamic>, callBackFun:String->Button->Void):Void {
		this.btnMap = new Map();
		this.treeBox.freeChildren();
		this.openBtn.skin = this.treeSkin;
		this.openBtn.skinHovered = this.treeHoverSkin;
		this.openBtn.skinPressed = this.treeClickSkin;
		this.openBtn.refresh();
		this.openBtn.text = data[0];
		this.treeData = data[1];
		this.callBackFun = callBackFun;
		
		if (treeData != null) {
			for (node in treeData) {
				if (Std.is(node[1], String)) {
					var childBtn:Button = UIBuilder.create(Button, {
						text  : node[0],
						w     : this.w,
						h     : 20,
						align : 'left,middle',
						format: treeNodeFormat,
						paddingLeft : this.openBtn.paddingLeft + 10
					});
					childBtn.skin = this.treeSkin;
					childBtn.skinHovered = this.treeHoverSkin;
					childBtn.skinPressed = this.treeClickSkin;
					childBtn.refresh();
					btnMap.set(childBtn, node[1]);
					childBtn.addEventListener(MouseEvent.CLICK, clickBtnHandler);
					this.treeBox.addChild(childBtn);
				}else {
					var childTree:Tree = UIBuilder.create(Tree, {
						hideBtnIco     : this.hideBtnIco,
						showBtnIco     : this.showBtnIco,
						w			   : this.w
					});
					childTree.refreshOpenBtnState();
					childTree.treeSkin = this.treeSkin;
					childTree.treeHoverSkin = this.treeHoverSkin;
					childTree.treeClickSkin = this.treeClickSkin;
					childTree.treeNodeFormat = this.treeNodeFormat;
					childTree.openBtn.format = this.openBtn.format;
					childTree.openBtn.refresh();
					childTree.openBtn.paddingLeft = this.openBtn.paddingLeft + 10;
					childTree.setData(node, callBackFun);
					this.treeBox.addChild(childTree);
				}
			}
		}
		this.refresh();
	}
	
	public function refreshOpenBtnState():Void {
		if (this.treeBox.visible) {
			if (hideBtnIco != null) {
				openBtn.ico.bitmapData = hideBtnIco;
				openBtn.ico.refresh();
			}
		}else {
			if (showBtnIco != null) {
				openBtn.ico.bitmapData = showBtnIco;
				openBtn.ico.refresh();
			}
		}
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function clickHandler(e:MouseEvent):Void {
		this.treeBox.visible = !this.treeBox.visible;
		this.refreshOpenBtnState();
		this.refresh();
	}
	
	private function clickBtnHandler(e:MouseEvent):Void {
		if (callBackFun != null) {
			callBackFun(btnMap[cast(e.currentTarget,Button)], e.currentTarget);
		}
	}
	
	function set_showBtnIco(value:BitmapData):BitmapData {
		if (!this.treeBox.visible && value != null) {
			openBtn.ico.bitmapData = value;
			openBtn.ico.refresh();
		}
		for (index in 0...treeBox.numChildren) {
			var child = treeBox.getChildAt(index);
			if (Std.is(child, Tree)) {
				cast(child, Tree).showBtnIco = value;
			}
		}
		return showBtnIco = value;
	}
	
	function set_hideBtnIco(value:BitmapData):BitmapData {
		if (this.treeBox.visible && value != null) {
			openBtn.ico.bitmapData = value;
			openBtn.ico.refresh();
		}
		for (index in 0...treeBox.numChildren) {
			var child = treeBox.getChildAt(index);
			if (Std.is(child, Tree)) {
				cast(child, Tree).hideBtnIco = value;
			}
		}
		return hideBtnIco = value;
	}
	
	function set_treeSkin(value:Skin):Skin {
		if (value != null) {
			this.openBtn.skin = value;
			this.openBtn.refresh();
			for (index in 0...treeBox.numChildren) {
				var child = treeBox.getChildAt(index);
				if (Std.is(child, Button)) {
					cast(child, Button).skin = value;
				}
			}
		}
		return treeSkin = value;
	}
	
	function set_treeClickSkin(value:Skin):Skin {
		if (value != null) {
			this.openBtn.skinPressed = value;
			this.openBtn.refresh();
			for (index in 0...treeBox.numChildren) {
				var child = treeBox.getChildAt(index);
				if (Std.is(child, Button)) {
					cast(child, Button).skinPressed = value;
				}
			}
		}
		return treeClickSkin = value;
	}
	
	function set_treeHoverSkin(value:Skin):Skin {
		if (value != null) {
			this.openBtn.skinHovered = value;
			this.openBtn.refresh();
			for (index in 0...treeBox.numChildren) {
				var child = treeBox.getChildAt(index);
				if (Std.is(child, Button)) {
					cast(child, Button).skinHovered = value;
				}
			}
		}
		return treeHoverSkin = value;
	}
}