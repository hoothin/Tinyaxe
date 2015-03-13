package tinyaxe.ui.manager;
import ASParticleSystem;
import tinyaxe.resource.enums.ResTypeEnum;
import tinyaxe.resource.ResourceManager;
import NSDictionary;
import openfl.display.BitmapData;
import openfl.errors.Error;
import openfl.utils.ByteArray;

/**
 * @time 2014/7/1 17:36:03
 * @author Hoothin
 */
class ASParticleManager {

	static var _asParticleManager:ASParticleManager;
	public function new() {
		
	}
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	static public function getInstance():ASParticleManager {
		if (_asParticleManager == null) {
			_asParticleManager = new ASParticleManager();
		}
		return _asParticleManager;
	}
	
	public function initParticle(particleName:String, callBackHandler:ASParticleSystem->Void):Void {
		ResourceManager.prepareRes(["assets/particles/" + particleName + ".plist"], ResTypeEnum.ResTypeBinaryData, function() {
			var plistByte:ByteArray = ResourceManager.getBinaryData("assets/particles/" + particleName + ".plist");
			var plistContent:String = plistByte.readUTFBytes(plistByte.length);
			var dict:NSDictionary = NSDictionary.dictionaryWithContentsOfFile("", plistContent);
			var pngName:String = Std.string(dict.valueForKey("textureFileName"));
			ResourceManager.prepareRes(["assets/particles/" + pngName], ResTypeEnum.ResTypeImage, function() {
				var pngContent:BitmapData = ResourceManager.getImgBitmapData("assets/particles/" + pngName);
				try {
					pngContent.width;
				} catch (e:Error) {
					initParticle(particleName, callBackHandler);
					return;
				}
				var particleSystem:ASParticleSystem = ASParticleSystem.particleWithFile("", "", plistContent, pngContent);
				particleSystem.mouseChildren = particleSystem.mouseEnabled = false;
				callBackHandler(particleSystem);
			});
		});
		
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/

	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
}