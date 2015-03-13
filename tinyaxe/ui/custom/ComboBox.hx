package tinyaxe.ui.custom;

import tinyaxe.ui.custom.event.ComboBoxEvent;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextFormat;
import ru.stablex.ui.skins.Skin;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.InputText;
import ru.stablex.ui.widgets.VBox;
import ru.stablex.ui.widgets.Widget;

/**
 * @time 2013/12/3 18:06:21
 * @author Hoothin
 */
class ComboBox extends Widget{

	public var dataProvider:Array<Dynamic>;
	public var labelField:String = "label";
	public var direction:String = "down";
	public var canInput:Bool = true;
	public var dropDownAutoFit:Bool = false;
	
	var _dropDownFormat:TextFormat;
	var _dropDownFilters:Array<openfl.filters.BitmapFilter>;
	var _dropDownNormalSkin:Skin;
	var _dropDownClickSkin:Skin;
	var _dropDownHoverSkin:Skin;
	public var inputText:InputText;
	public var dropDownBtn:Button;
	public var dropDownBox:ScrollContainer;
	public var dropDownBoxCon:Widget;
	var itemBox:VBox;
	var itemMap:Map<Button,Dynamic>;
	
	public var selectedItem:Dynamic;
	
	public function new() {
		super();
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public function onCreate():Void {
		super.onCreate();
		this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
		var defaultText:String = "";
		if (dataProvider != null) {
			defaultText = Reflect.field(dataProvider[0], labelField);
		}
		if (canInput) {
			inputText = UIBuilder.create(InputText, {
				w  : this.w,
				h  : 20
			});
			this.inputText.addEventListener(Event.CHANGE, enterWordHandler);
			this.inputText.text = defaultText;
			this.addChild(inputText);
			dropDownBtn = UIBuilder.create(Button, {
				y  : 4,
				right  : 1,
				w  : 20,
				h  : 20
			});
		}else {
			dropDownBtn = UIBuilder.create(Button, {
				y  : 0,
				left  : 0,
				w  : this.w,
				h  : this.h,
				text : defaultText
			});
		}
		dropDownBtn.addEventListener(MouseEvent.CLICK, clickDropDownHandler);
		addChild(dropDownBtn);
		itemBox = UIBuilder.create(VBox, {
			top  : 0,
			left : 0
		});
		itemMap = new Map<Button,Dynamic>();
		var selected:Bool = false;
		if (dataProvider != null)
		for (data in dataProvider) {
			var itemButton:Button = UIBuilder.create(Button, {
				text  : Reflect.field(data, labelField),
				w     : this.w,
				h     : this.h
			});
			itemButton.addEventListener(MouseEvent.CLICK, clickItemHandler);
			itemBox.addChild(itemButton);
			itemMap.set(itemButton, data);
		}
		dropDownBox = UIBuilder.create(ScrollContainer, {
			left : 0,
			h	 : dropDownAutoFit?itemBox.h:100,
			w	 : this.w,
			sideFace : "none",
			children: [itemBox]
		});
		dropDownBoxCon = UIBuilder.create(Widget, {
			h	 : dropDownAutoFit?itemBox.h:100,
			w	 : this.w,
			visible : false,
			children: [dropDownBox]
		});
		switch(direction) {
			case "down":
				dropDownBoxCon.top = this.h;
			case "up":
				dropDownBoxCon.bottom = this.h;
		}
		this.addChild(dropDownBoxCon);
		if (dataProvider != null)
		selectedItem = dataProvider[0];
	}
	
	public function addItem(itemData:Dynamic, index:Int = 0):Void {
		var itemButton:Button = UIBuilder.create(Button, {
			text  : Reflect.field(itemData, labelField),
			w     : this.w,
			h     : this.h
		});
		if (_dropDownFormat != null) {
			itemButton.format = _dropDownFormat;
			itemButton.refresh();
		}
		if (_dropDownFilters != null) {
			itemButton.label.filters = _dropDownFilters;
		}
		if (_dropDownNormalSkin != null) {
			itemButton.skin = _dropDownNormalSkin;
		}
		if (_dropDownClickSkin != null) {
			itemButton.skinPressed = _dropDownClickSkin;
		}
		if (_dropDownHoverSkin != null) {
			itemButton.skinHovered = _dropDownHoverSkin;
		}
		itemButton.refresh();
		itemButton.addEventListener(MouseEvent.CLICK, clickItemHandler);
		itemBox.addChildAt(itemButton, index);
		itemMap.set(itemButton, itemData);
		this.refresh();
	}
	
	public function removeItem(index:Int):Void {
		var itemButton:Button = cast(itemBox.getChildAt(index), Button);
		itemButton.removeEventListener(MouseEvent.CLICK, clickItemHandler);
		itemBox.removeChild(itemButton);
		itemMap.remove(itemButton);
		this.refresh();
	}
	
	public function cleanItem():Void {
		for (itemBtn in itemMap.keys()) {
			itemBtn.removeEventListener(MouseEvent.CLICK, clickItemHandler);
			itemBox.removeChild(itemBtn);
		}
		itemMap = new Map();
	}
	
	public function getItemData(index:Int):Dynamic {
		var itemButton:Button = cast(itemBox.getChildAt(index), Button);
		return itemMap.get(itemButton);
	}
	
	public function selectItem(prop:String, value:Dynamic):Void {
		for (data in dataProvider) {
			if (Reflect.field(data, prop) == value) {
				this.selectedItem = data;
				if (canInput) {
					this.inputText.text = Reflect.field(selectedItem, labelField);
				}else {
					this.dropDownBtn.text = Reflect.field(selectedItem, labelField);
				}
			}
		}
	}
	
	override public function refresh():Void {
		if (this.dropDownBox.vBar.visible) {
			for (btn in itemMap.keys()) {
				btn.w = this.w - this.dropDownBox.vBar.w;
			}
		}else {
			for (btn in itemMap.keys()) {
				btn.w = this.w;
			}
		}
		super.refresh();
		this.dropDownBoxCon.h = dropDownAutoFit?itemBox.h:100;
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function clickItemHandler(e:MouseEvent):Void {
		dropDownBoxCon.visible = false;
		this.selectedItem = itemMap.get(cast(e.currentTarget, Button));
		if (canInput) {
			this.inputText.text = Reflect.field(selectedItem, labelField);
		}else {
			this.dropDownBtn.text = Reflect.field(selectedItem, labelField);
		}
		dispatchEvent(new ComboBoxEvent(ComboBoxEvent.SELECT_ITEM, this.selectedItem));
	}
	
	private function clickDropDownHandler(e:MouseEvent):Void {
		dropDownBoxCon.visible = true;
	}
	
	private function enterWordHandler(e:Event):Void {
		dispatchEvent(new ComboBoxEvent(ComboBoxEvent.ENTER_WORD, this.inputText.text));
	}
	
	private function onRollOutHandler(e:MouseEvent):Void {
		dropDownBoxCon.visible = false;
	}
	
	private function set_dropDownFormat(value:TextFormat):TextFormat {
		for (item in itemMap.keys()) {
			item.format = value;
			item.refresh();
		}
		return _dropDownFormat = value;
	}
	
	public var dropDownFormat(null, set_dropDownFormat):TextFormat;
	
	private function set_dropDownFilters(value:Array<openfl.filters.BitmapFilter>):Array<openfl.filters.BitmapFilter> {
		for (item in itemMap.keys()) {
			item.label.filters = value;
		}
		return _dropDownFilters = value;
	}
	
	public var dropDownFilters(null, set_dropDownFilters):Array<openfl.filters.BitmapFilter>;
	
	private function set_dropDownNormalSkin(value:Skin):Skin {
		for (item in itemMap.keys()) {
			item.skin = value;
			item.refresh();
		}
		return _dropDownNormalSkin = value;
	}
	
	public var dropDownNormalSkin(null, set_dropDownNormalSkin):Skin;
	
	private function set_dropDownClickSkin(value:Skin):Skin {
		for (item in itemMap.keys()) {
			item.skinPressed = value;
			item.refresh();
		}
		return _dropDownClickSkin = value;
	}
	
	public var dropDownClickSkin(null, set_dropDownClickSkin):Skin;
	
	private function set_dropDownHoverSkin(value:Skin):Skin {
		for (item in itemMap.keys()) {
			item.skinHovered = value;
			item.refresh();
		}
		return _dropDownHoverSkin = value;
	}
	
	public var dropDownHoverSkin(null, set_dropDownHoverSkin):Skin;
}