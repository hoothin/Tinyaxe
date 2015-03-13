package tinyaxe.framework.control;
import tinyaxe.framework.model.GameCore;
import tinyaxe.framework.view.*;
import org.puremvc.haxe.interfaces.INotification;
import org.puremvc.haxe.patterns.command.SimpleCommand;

/**
 * ...
 * @author Hoothin
 */
class InitViewCommand extends SimpleCommand {

	public function new() {
		super();
	}
	
	override public function execute( notification:INotification ): Void {
		super.execute(notification);
		this.facade.registerMediator(new GameCoreMediator(GameCore.getInstance()));
	}
}