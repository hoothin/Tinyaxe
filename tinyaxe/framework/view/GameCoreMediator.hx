package tinyaxe.framework.view;

import tinyaxe.framework.notification.NotificationDefine;
import org.puremvc.haxe.interfaces.INotification;
import org.puremvc.haxe.patterns.mediator.Mediator;

/**
 * ...
 * @author Hoothin
 */
class GameCoreMediator extends Mediator {
	public static inline var NAME:String = "GAMECORE_MEDIATOR";
	public function new(viewComponent:Dynamic) {
		super(NAME, viewComponent);
	}
	
	override public function listNotificationInterests(): Array<String> {
		return [
		NotificationDefine.MISSION_COMPLETE
		];
	}

	override public function handleNotification( notification:INotification ): Void {
		switch(notification.getName()) {
			case NotificationDefine.MISSION_COMPLETE:
				trace("here");
			default:
				
		}
	}

	override public function onRegister(): Void {
		
	}
	
	override public function onRemove(): Void {
		
	}
}