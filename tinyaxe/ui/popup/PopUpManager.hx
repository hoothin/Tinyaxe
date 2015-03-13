package tinyaxe.ui.popup;

import tinyaxe.layer.LayerManager;
import tinyaxe.resource.xml.WindowConfigXml;
import tinyaxe.resource.XmlConfigManager;
import tinyaxe.ui.popup.BasePopUpWindow;
import tinyaxe.ui.popup.interfaces.IPopUpWindow;
import tinyaxe.utility.ShortCutsKey;
import motion.Actuate;
import openfl.events.Event;
import openfl.Lib;
import org.puremvc.haxe.patterns.facade.Facade;
import org.puremvc.haxe.patterns.mediator.Mediator;

/**
 * ...
 * @author Hoothin
 */
class PopUpManager {
	public static var windowNameMap:Map<String, Class<IPopUpWindow>>;
	private static var _popUpManager:PopUpManager;
	private var popUpWindowList:Map<String, IPopUpWindow>;
	public function new() {
		popUpWindowList = new Map<String, IPopUpWindow>();
		Lib.current.stage.addEventListener(Event.RESIZE, resizeHandler);
	}
	
	public static function getInstance():PopUpManager {
		if (_popUpManager == null) {
			_popUpManager = new PopUpManager();
		}
		return _popUpManager;
	}
	
	public function getWindow(name:String = ""):IPopUpWindow {
		if (this.popUpWindowList.exists(name)) return this.popUpWindowList[name];
		else return null;
	}
	
	public function registerWindowKey():Void {
		var windowConfigXmlList:Map<String, WindowConfigXmlVO> = XmlConfigManager.getXmlVO(WindowConfigXml).windowConfigXmlList;
		for ( windowConfigVO in windowConfigXmlList) {
			if (windowConfigVO.keyCode != -1) {
				ShortCutsKey.addKeyEventListener(windowConfigVO.keyCode, openWindowKeyHandler);
			}
		}
	}
	
	public function openWindow(windowName:String, ?data:Dynamic):IPopUpWindow {
		if (this.popUpWindowList.exists(windowName)) {
			
		}else {
			var newPopUpWindow:IPopUpWindow = Type.createInstance(windowNameMap[windowName], []);
			newPopUpWindow.init();
			if (newPopUpWindow != null) {
				this.popUpWindowList.set(newPopUpWindow.windowName, newPopUpWindow);
			}
		}
		
		var preOpenWindow:IPopUpWindow = this.popUpWindowList.get(windowName);
		
		if (preOpenWindow.isOpen) {
			this.closeWindow(preOpenWindow.windowName);
			return preOpenWindow;
		}
		
		preOpenWindow.x = Std.int((Lib.current.stage.stageWidth - preOpenWindow.getWidth()) / 2);
		preOpenWindow.y = Std.int((Lib.current.stage.stageHeight - preOpenWindow.getHeight()) / 2);
		
		preOpenWindow.openWindow();
		
		LayerManager.getInstance().addChildObj(cast preOpenWindow, LayerManager.UI_LAYER);
		if (data != null) {
			preOpenWindow.initWindow(data);
		}
		
		var newMediator:Mediator = preOpenWindow.windowMediator;
		if (newMediator != null) {
			Facade.getInstance().registerMediator(newMediator);
		}
		
		if (preOpenWindow.windowConfigXmlVO != null) {
			for (window in this.popUpWindowList.keys()) {
				if (preOpenWindow.windowConfigXmlVO.keepWindowList.indexOf(window) == -1 &&
				preOpenWindow.windowConfigXmlVO.parent != window &&
				preOpenWindow.windowConfigXmlVO.left != window &&
				preOpenWindow.windowConfigXmlVO.right != window) {
					if (this.popUpWindowList[window].isOpen) {
						this.closeWindow(window);
					}
				}
			}
			
			if (preOpenWindow.windowConfigXmlVO.left != null || preOpenWindow.windowConfigXmlVO.right != null) {
				var openList:Array<String> = [];
				var leftWindow:String = preOpenWindow.windowConfigXmlVO.left;
				if (leftWindow != null) {
					if (!this.popUpWindowList.exists(leftWindow) || (!this.popUpWindowList[leftWindow].isOpen && !this.popUpWindowList[leftWindow].isOpening)) {
						openWindow(leftWindow);
					}
					openList.push(leftWindow);
				}
				openList.push(windowName);
				var rightWindow:String = preOpenWindow.windowConfigXmlVO.right;
				if (rightWindow != null) {
					if (!this.popUpWindowList.exists(rightWindow) || (!this.popUpWindowList[rightWindow].isOpen && !this.popUpWindowList[rightWindow].isOpening)) {
						openWindow(rightWindow);
					}
					openList.push(rightWindow);
				}
				sortWindows(openList);
			}
			
			if (this.popUpWindowList.exists(preOpenWindow.windowConfigXmlVO.parent)) {
				if (this.popUpWindowList[preOpenWindow.windowConfigXmlVO.parent].isOpen) {
					this.popUpWindowList[preOpenWindow.windowConfigXmlVO.parent].setWindowEnabled(false);
				}
			}
		}else {
			for (window in this.popUpWindowList.keys()) {
				if (this.popUpWindowList[window].isOpen) {
					this.closeWindow(window);
				}
			}
		}
		
		return preOpenWindow;
	}
	
	public function closeAllWindow():Void {
		for (window in this.popUpWindowList.keys()) {
			if (this.popUpWindowList[window].isOpen) {
				this.closeWindow(window);
			}
		}
	}
	
	public function closeWindow(windowName:String, ?closeStraight:Bool = false):Void {
		if (this.popUpWindowList.exists(windowName)) {
			var curWindow:IPopUpWindow = this.popUpWindowList.get(windowName);
			curWindow.closeWindow(closeStraight);
			
			var remainWindows:Array<String> = [];
			if (curWindow.windowConfigXmlVO != null && (curWindow.windowConfigXmlVO.left != null || curWindow.windowConfigXmlVO.right != null)) {
				var leftWindow:String = curWindow.windowConfigXmlVO.left;
				if (leftWindow != null) {
					var lw:IPopUpWindow = this.popUpWindowList[leftWindow];
					if (lw != null && lw.isOpen) {
						remainWindows.push(leftWindow);
					}
				}
				var rightWindow:String = curWindow.windowConfigXmlVO.right;
				if (rightWindow != null) {
					var rw:IPopUpWindow = this.popUpWindowList[rightWindow];
					if (rw != null && rw.isOpen) {
						remainWindows.push(rightWindow);
					}
				}
				sortWindows(remainWindows);
			}else {
				for (window in popUpWindowList) {
					if (window.isOpen) {
						if (window.windowConfigXmlVO != null && (window.windowConfigXmlVO.left == windowName || window.windowConfigXmlVO.right == windowName)) {
							var leftWindow:String = window.windowConfigXmlVO.left;
							if (leftWindow != null && leftWindow != windowName) {
								var lw:IPopUpWindow = this.popUpWindowList[leftWindow];
								if (lw != null && lw.isOpen) {
									remainWindows.push(leftWindow);
								}
							}
							remainWindows.push(window.windowName);
							var rightWindow:String = window.windowConfigXmlVO.right;
							if (rightWindow != null && rightWindow != windowName) {
								var rw:IPopUpWindow = this.popUpWindowList[rightWindow];
								if (rw != null && rw.isOpen) {
									remainWindows.push(rightWindow);
								}
							}
							sortWindows(remainWindows);
							break;
						}
					}
				}
			}
		}
	}
	
	public function finalCloseWindow(windowName:String):Void {
		var closeWindow:IPopUpWindow = this.popUpWindowList[windowName];
		if (closeWindow.windowConfigXmlVO != null) {
			if (this.popUpWindowList.exists(closeWindow.windowConfigXmlVO.parent)) {
				this.popUpWindowList[closeWindow.windowConfigXmlVO.parent].setWindowEnabled(true);
			}
		}
	}
	
	private function openWindowKeyHandler(keyCode:Int):Void {
		var windowConfigXmlList:Map<String, WindowConfigXmlVO> = XmlConfigManager.getXmlVO(WindowConfigXml).windowConfigXmlList;
		for ( windowConfigVO in windowConfigXmlList) {
			if (windowConfigVO.keyCode == keyCode) {
				this.openWindow(windowConfigVO.id);
			}
		}
	}
	
	private function sortWindows(openList:Array<String>):Void {
		if (openList.length <= 0) return;
		var totalWidth:Int = 0;
		for (window in openList) {
			totalWidth += Std.int(this.popUpWindowList[window].getWidth());
		}
		var leftIndex:Int = Std.int((Lib.current.stage.stageWidth - totalWidth) / 2);
		for (window in openList) {
			var curWindow = this.popUpWindowList[window];
			Actuate.stop(curWindow, null, true, true);
			Actuate.tween(curWindow, 1, { x:leftIndex } );
			leftIndex += Std.int(curWindow.getWidth());
		}
	}
	
	private function resizeHandler(e:Event):Void {
		var windowList = [];
		var singleList = [];
		for (window in popUpWindowList) {
			if (window.isOpen) {
				window.y = Std.int((Lib.current.stage.stageHeight - window.getHeight()) / 2);
				if (window.windowConfigXmlVO != null && 
				(window.windowConfigXmlVO.left != null ||
				window.windowConfigXmlVO.right != null)) {
					windowList.push(window);
				}
				singleList.push(window.windowName);
			}
		}
		for (window in windowList) {
			var windows:Array<String> = [];
			var leftWindow:String = window.windowConfigXmlVO.left;
			if (leftWindow != null) {
				windows.push(leftWindow);
				singleList.remove(leftWindow);
			}
			windows.push(window.windowName);
			var rightWindow:String = window.windowConfigXmlVO.right;
			if (rightWindow != null) {
				windows.push(rightWindow);
				singleList.remove(rightWindow);
			}
			sortWindows(windows);
		}
		for (windowName in singleList) {
			var window = popUpWindowList[windowName];
			if (window == null) continue;
			window.x = Std.int((Lib.current.stage.stageWidth - window.getWidth()) / 2);
		}
	}
}