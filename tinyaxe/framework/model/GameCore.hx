package tinyaxe.framework.model;
import tinyaxe.animation.EnterFrameManager;
import tinyaxe.framework.control.InitFrameWorkCommand;
import tinyaxe.framework.notification.NotificationDefine;
import tinyaxe.manager.TestManager;
import tinyaxe.resource.ResourceManager;
import tinyaxe.resource.XmlConfigManager;
import tinyaxe.ui.enums.PopUpNameEnum;
import tinyaxe.ui.InitUI;
import tinyaxe.ui.popup.PopUpManager;
import tinyaxe.utility.TimeKeeper;
import org.puremvc.haxe.patterns.facade.Facade;

/**
 * @time 2015/3/6 17:39:13
 * @author Hoothin
 */
class GameCore{

	static var gameCore:GameCore;
	public function new() {
		
	}

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public static function getInstance():GameCore {
		if (gameCore == null)
			gameCore = new GameCore();
		return gameCore;
	}
	
	public function init():Void {
		InitUI.init();
		TestManager.getInstance().init();
		TimeKeeper.openListener();
		EnterFrameManager.getInstance().init();
		ResourceManager.getInstance().init();
		XmlConfigManager.getInstance().initXmlConfigSetting();
		Facade.getInstance().registerCommand(NotificationDefine.INIT_FRAMEWORK, InitFrameWorkCommand);
		Facade.getInstance().sendNotification(NotificationDefine.INIT_FRAMEWORK);
		Facade.getInstance().sendNotification(NotificationDefine.MISSION_COMPLETE);
		this.initWindow();
	}
	
	private function initWindow():Void {
		var windowNameMap = PopUpManager.windowNameMap;
		windowNameMap = new Map();
		//windowNameMap.set(PopUpNameEnum.MAIN_WINDOW, MainWindow);
	}
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