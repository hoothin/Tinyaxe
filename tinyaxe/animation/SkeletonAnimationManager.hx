package tinyaxe.animation;
import openfl.Assets;
import spinehaxe.animation.AnimationStateData;
import spinehaxe.atlas.Atlas;
import spinehaxe.attachments.AtlasAttachmentLoader;
import spinehaxe.platform.openfl.BitmapDataTextureLoader;
import spinehaxe.SkeletonData;
import spinehaxe.SkeletonJson;

/**
 * @time 2014/12/29 14:34:03
 * @author Hoothin
 */
class SkeletonAnimationManager{

	static var skeletonAnimationManager:SkeletonAnimationManager;
	var atlasMap:Map<String, Atlas>;
	var jsonMap:Map<String, SkeletonJson>;
	var jsonStrMap:Map<String, String>;
	public function new() {
		atlasMap = new Map();
		jsonMap = new Map();
		jsonStrMap = new Map();
	}

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public static function getInstance():SkeletonAnimationManager {
		if (skeletonAnimationManager == null) {
			skeletonAnimationManager = new SkeletonAnimationManager();
		}
		return skeletonAnimationManager;
	}
	
	public function getStateData(name:String):AnimationStateData {
		var atlas = atlasMap.get(name);
		if (atlas == null) {
			atlas = new Atlas(Assets.getText("assets/skeleton/" + name + ".atlas"), new BitmapDataTextureLoader("assets/skeleton/"));
			this.atlasMap.set(name, atlas);
		}
		var json = jsonMap.get(name);
		if (json == null) {
			json = new SkeletonJson(new AtlasAttachmentLoader(atlas));
			this.jsonMap.set(name, json);
		}
		var jsonStr = jsonStrMap.get(name);
		if (jsonStr == null) {
			jsonStr = Assets.getText("assets/skeleton/" + name + ".json");
			this.jsonStrMap.set(name, jsonStr);
		}
		var skeletonData:SkeletonData = json.readSkeletonData(jsonStr, name);
		var stateData:AnimationStateData = new AnimationStateData(skeletonData);
		for (aniX in skeletonData.animations) {
			var aniXName:String = aniX.name;
			for (aniY in skeletonData.animations) {
				var aniYName:String = aniY.name;
				stateData.setMixByName(aniXName, aniYName, 0.2);
			}
		}
		return stateData;
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