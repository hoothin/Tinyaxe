package tinyaxe.utility;
import motion.Actuate;
import motion.easing.Linear;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.net.URLRequest;

/**
 * @time 2014/9/3 15:33:40
 * @author Hoothin
 */
class SoundManager {

	static var _soundManager:SoundManager;
	private var _soundChannel:SoundChannel;
	public var isMute(get, null):Bool;
	public function new() {
		if (OpenflCookie.getCookie("ChickrenKnife", "isMute") != null) {
			this.isMute = OpenflCookie.getCookie("ChickrenKnife", "isMute") == "1";
		}else {
			this.isMute = false;
		}
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	static public function getInstance():SoundManager {
		if (_soundManager == null) {
			_soundManager = new SoundManager();
		}
		return _soundManager;
	}
	
	public function playMusic(name:String, ?times:Int = 9999):Void {
		var _sound = new Sound();
		if (this._soundChannel != null) {
			this._soundChannel.stop();
		}
		if (name == "") {
			return;
		}
		_sound.load(new URLRequest("assets/sound/" + name + ".mp3"));
		this._soundChannel = _sound.play(0, times);
		if (_soundChannel == null) return;
		
		var soundTransform = this._soundChannel.soundTransform;
		soundTransform.volume = 0;
		this._soundChannel.soundTransform = soundTransform;
		if (!isMute) {
			Actuate.tween(soundTransform, 1, { volume:1 } ).ease(Linear.easeNone).onUpdate(refreshSoundTransform, [soundTransform]);
		}
	}
	
	public function playSound(name:String):Void {
		if (!isMute) {
			var _sound = new Sound();
			_sound.load(new URLRequest("assets/sound/" + name + ".mp3"));
			_sound.play();
		}
	}
	
	public function switchVolume():Bool {
		if (_soundChannel.soundTransform.volume == 0) {
			var soundTransform = this._soundChannel.soundTransform;
			Actuate.tween(soundTransform, 1, { volume:1 } ).ease(Linear.easeNone).onUpdate(refreshSoundTransform, [soundTransform]);
			this._soundChannel.soundTransform = soundTransform;
			this.isMute = false;
		}else {
			var soundTransform = this._soundChannel.soundTransform;
			Actuate.tween(soundTransform, 1, { volume:0 } ).ease(Linear.easeNone).onUpdate(refreshSoundTransform, [soundTransform]);
			this._soundChannel.soundTransform = soundTransform;
			this.isMute = true;
		}
		OpenflCookie.setCookie("ChickrenKnife", "isMute", isMute?"1":"0");
		return isMute;
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	private function refreshSoundTransform(soundTransform:SoundTransform):Void {
		this._soundChannel.soundTransform = soundTransform;
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	function get_isMute():Bool {
		return isMute;
	}
}