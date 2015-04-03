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
class SkeletonAnimationManager {

	static var skeletonAnimationManager:SkeletonAnimationManager;
	var skeletonDataMap:Map<String, SkeletonData>;
	public function new() {
		skeletonDataMap = new Map();
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
		var skeletonData:SkeletonData = skeletonDataMap.get(name);
		if (skeletonData == null) {
			var atlas = new Atlas(Assets.getText("assets/skeleton/" + name + ".atlas"), new BitmapDataTextureLoader("assets/skeleton/"));
			var json = new SkeletonJson(new AtlasAttachmentLoader(atlas));
			skeletonData = json.readSkeletonData(Assets.getText("assets/skeleton/" + name + ".json"), name);
			this.skeletonDataMap.set(name, skeletonData);
		}
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