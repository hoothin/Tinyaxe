package tinyaxe.animation.vo;

import tinyaxe.animation.frame.FrameSprite;
import spinehaxe.animation.AnimationState;
import spinehaxe.animation.AnimationStateData;
import spinehaxe.platform.openfl.SkeletonAnimation;
import spinehaxe.Skeleton;

/**
 * @time 2014/12/29 11:50:37
 * @author Hoothin
 */
class SkeletonAnimationVO extends FrameSprite {

	static var animationPool:Array<SkeletonAnimationVO> = [];
    public var skeleton(get, null):Skeleton;
	public var renderer(get, null):SkeletonAnimation;
    var state:AnimationState;
    var lastTime:Float = 0.0;
	var stateData:AnimationStateData;
	var curMotionName:String;
	public function new() {
		super();
		this.mouseChildren = false;
		//this.graphics.beginFill(0xffffff);
		//this.graphics.drawRect( -5, -20, 10, 20);
		//this.graphics.endFill();
	}

	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	override public function register():Void {
		super.register();
		lastTime = haxe.Timer.stamp();
	}
	
	public static function getNew(name:String, defaultMotion:String):SkeletonAnimationVO {
		if (animationPool.length > 0) {
			for (animation in animationPool) {
				if (animation.skeleton.data.name == name) {
					animationPool.remove(animation);
					animation.renderer.start();
					animation.changeAction(defaultMotion);
					return animation;
				}
			}
		}
		var skeletonAnimationVO:SkeletonAnimationVO = new SkeletonAnimationVO();
		skeletonAnimationVO.initAnimation(name, defaultMotion);
		return skeletonAnimationVO;
	}
	
	override public function enterFrameProcess():Void {
		super.enterFrameProcess();
		if (state == null) return;
		var delta = (haxe.Timer.stamp() - lastTime);
        lastTime = haxe.Timer.stamp();
        state.update(delta);
        state.apply(skeleton);
        skeleton.updateWorldTransform();
		renderer.visible = true;
	}
	
	override public function stop():Void {
		super.stop();
		if (this.renderer != null)
			this.renderer.stop();
	}
	
	override public function start():Void {
		super.start();
		if (this.renderer != null)
			this.renderer.start();
	}
	
	public function changeAction(name:String, ?loop:Bool = true):Void {
		if (curMotionName == name || this.skeleton == null) return;
		this.curMotionName = name;
		this.skeleton.setToSetupPose();
		this.state.setAnimationByName(0, name, loop);
	}
	
	/**
	 * 设置俩动作间切换的缓冲时间
	 * @param	fromName
	 * @param	toName
	 * @param	duration
	 */
	public function setMixByName(fromName:String, toName:String, duration:Float):Void {
		stateData.setMixByName(fromName, toName, duration);
	}
	
	public function getCurMotion():String {
		return this.curMotionName;
	}
	
	public function destroy():Void {
		this.removeFromStage();
		if (renderer != null) {
			renderer.destroy();
			if (animationPool.indexOf(this) == -1) {
				animationPool.push(this);
			}
		}
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	private function initAnimation(name:String, defaultMotion:String):Void {
		//return;
		stateData = SkeletonAnimationManager.getInstance().getStateData(name);
		state = new AnimationState(stateData);
		curMotionName = defaultMotion;
		state.setAnimationByName(0, defaultMotion, true);
		if (renderer != null) {
			if (renderer.parent != null) {
				renderer.parent.removeChild(renderer);
			}
		}
		renderer = new SkeletonAnimation(stateData.skeletonData, null, true);
		skeleton = renderer.skeleton;
		skeleton.updateWorldTransform();
		addChild(renderer);
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Get/Set
	-------------------------------------------------------------------------------------------*/
	function get_skeleton():Skeleton {
		return skeleton;
	}
	
	function get_renderer():SkeletonAnimation {
		return renderer;
	}
}