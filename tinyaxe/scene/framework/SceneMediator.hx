package tinyaxe.scene.framework;

import tinyaxe.framework.notification.NotificationDefine;
import org.puremvc.haxe.interfaces.INotification;
import org.puremvc.haxe.patterns.mediator.Mediator;
import tinyaxe.scene.Scene;

/**
 * @time 2015/3/10 15:45:06
 * @author Hoothin
 */
class SceneMediator extends Mediator{

	public static var NAME:String = "SceneMediator";
	private var scene:Scene;
	public function new(viewComponent:Dynamic) {
		super(NAME, viewComponent);
		this.scene = cast(this.viewComponent, Scene);
	}

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public function onRegister():Void {
		super.onRegister();
	}
	
	override public function onRemove():Void {
		super.onRemove();
	}
	
	override public function listNotificationInterests(): Array<String>
	{
		return [
		NotificationDefine.CONTROL_END
		];
	}
	
	override public function handleNotification( notification:INotification ): Void {
		switch(notification.getName()) {
			case NotificationDefine.CONTROL_END:
				this.scene.stopAction();
		}
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