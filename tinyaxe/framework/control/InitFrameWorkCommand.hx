package tinyaxe.framework.control;

import org.puremvc.haxe.patterns.command.MacroCommand;

/**
 * ...
 * @author Hoothin
 */
class InitFrameWorkCommand extends MacroCommand {

	public function new() {
		super();
		this.addSubCommand(InitViewCommand);
		this.addSubCommand(InitControlCommand);
	}
}