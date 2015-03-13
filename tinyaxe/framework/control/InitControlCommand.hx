package tinyaxe.framework.control;

import org.puremvc.haxe.interfaces.INotification;
import org.puremvc.haxe.patterns.command.SimpleCommand;
import tinyaxe.framework.notification.NotificationDefine;

/**
 * ...
 * @author Hoothin
 */
class InitControlCommand extends SimpleCommand {

	public function new() {
		super();
	}
	
	override public function execute( notification:INotification ): Void {
		super.execute(notification);
		//this.facade.registerCommand(NotificationDefine.SEND_SOCKET_MSG, SendSocketMsgCommand);
	}
}