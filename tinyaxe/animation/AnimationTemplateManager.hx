package tinyaxe.animation;
import tinyaxe.animation.task.TemplateInitTask;
import com.animation.vo.AnimationTemplateVO;
import tinyaxe.animation.vo.EffectTemplateVO;

/**
 * ...
 * @author Hoothin
 */
class AnimationTemplateManager {
	private static var _animationTemplateManager:AnimationTemplateManager;
	public static function getInstance():AnimationTemplateManager {
		if (_animationTemplateManager == null) {
			_animationTemplateManager = new AnimationTemplateManager();
		}
		return _animationTemplateManager;
	}
	
	private var _effectTemplateList:Map<String, EffectTemplateVO>;
	private var _templateTaskList:Array<TemplateInitTask>;
	private var _currentTemplateTask:TemplateInitTask;
	
	public function new() {
		this._effectTemplateList = new Map<String, EffectTemplateVO>();
		this._templateTaskList = new Array<TemplateInitTask>();
	}
	
	public function initTemplateList(animationIdList:Array<String>, ?initCompleteFunc:Void->Void = null):Int {
		var templateIdList:Array<String> = new Array<String>();
		for (templateId in animationIdList) {
			if (this._effectTemplateList.exists(templateId) == false) {
				templateIdList.push(templateId);
			}
		}
		
		if (templateIdList.length > 0) {
			var templateTask:TemplateInitTask = new TemplateInitTask(templateIdList, initCompleteFunc, true);
			this._templateTaskList.push(templateTask);
			this.startInitTemplate();
		}else {
			if (initCompleteFunc != null) {
				initCompleteFunc();
			}
		}
		
		return animationIdList.length * 2;
	}
	
	private function startInitTemplate():Void {
		if (this._currentTemplateTask == null) {
			if (this._templateTaskList.length > 0) {
				this._currentTemplateTask = this._templateTaskList.shift();
			}
		}
		
		if (this._currentTemplateTask != null) {
			this.initEffectTemplate(this._currentTemplateTask.getTemplateId(), startInitTemplate);
			if (this._currentTemplateTask != null && this._currentTemplateTask.isFinished) {
				var callBackFunc:Void->Void = this._currentTemplateTask.initCompleteFunc;
				this._currentTemplateTask = null;
				
				if (callBackFunc != null) {
					callBackFunc();
				}
			}
		}
	}
	
	public function initEffectTemplate(effectId:String, ?initCompleteFunc:Void->Void = null):Void {
		if (effectId == null) return;
		if (this._effectTemplateList.exists(effectId) == true) {
			var getTemplate:EffectTemplateVO = this._effectTemplateList.get(effectId);
			if (getTemplate.isInitComplete == true) {
				initCompleteFunc();
			}else {
				getTemplate.addInitFunc(initCompleteFunc);
			}
		}else {
			var effectTemplate:EffectTemplateVO = new EffectTemplateVO();
			effectTemplate.initEffectTemplate(effectId, initCompleteFunc);
			
			this._effectTemplateList.set(effectId, effectTemplate);
		}
	}
	
	public function getEffectTemplate(effectId:String):EffectTemplateVO {
		if (this._effectTemplateList.exists(effectId) == true) {
			return this._effectTemplateList.get(effectId);
		}
		return null;
	}
	
	public function removeEffectTemplate(effectId:String):Bool {
		return this._effectTemplateList.remove(effectId);
	}
}