package tinyaxe.animation.vo;
import tinyaxe.animation.frame.FrameSprite;
import tinyaxe.utility.Debug;
import openfl.display.Bitmap;
import com.resource.xml.EffectConfigXmlVO;
import tinyaxe.resource.XmlConfigManager;
import tinyaxe.animation.AnimationTemplateManager;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Hoothin
 */
class EffectVO extends FrameSprite {
	public var playAndRemove(get, null):Bool;
	public var effectConfigVO(get_effectConfigVO, null):EffectConfigXmlVO;
	private var _templateBitmap:Bitmap;
	private var _effectConfigVO:EffectConfigXmlVO;
	private var _effectTemplateVO:EffectTemplateVO;
	private var _currentEffectIndex:Int;
	private var _currentPlayIndex:Int;
	private var callBackFunction:Void->Void;
	private var offsetBase:Int = 256;
	public function new() {
		super();
		this._currentEffectIndex = 0;
		this._currentPlayIndex = 0;
		this.playAndRemove = false;
		this._templateBitmap = new Bitmap();	
		this.addChild(this._templateBitmap);
	}
	
	public function initEffect(effectId:String, ?playAndRemove:Bool = false, ?randomStart:Bool = false, ?callBackFunction:Void->Void = null):Void {
		this.playAndRemove = playAndRemove;
		this.callBackFunction = callBackFunction;
		this._effectConfigVO = XmlConfigManager.getInstance().getEffectVOById(effectId);
		if (this._effectConfigVO == null) {
			Debug.trace(effectId + " is not in effect xml!", Debug.ERROR);
			return;
		}
		AnimationTemplateManager.getInstance().initEffectTemplate(this._effectConfigVO.id, initEffectComplete);
		if (randomStart == true) {
			this._currentEffectIndex = Math.floor(Math.random() * this._effectConfigVO.totalFrame);
		}
	}
	
	override public function enterFrameProcess():Void {
		super.enterFrameProcess();
		if (this._effectConfigVO != null && this._effectTemplateVO != null) {
			this._currentPlayIndex ++;
			if (this._currentPlayIndex >= this._effectConfigVO.frameRate) {
				this._currentEffectIndex ++;
				this._currentPlayIndex = 0;
				if (this._currentEffectIndex >= this._effectConfigVO.totalFrame) {
					if (this.playAndRemove) {
						this._currentEffectIndex = 0;
						this.removeFromStage();
						if (callBackFunction != null) {
							this.callBackFunction();
						}
					}else {
						this._currentEffectIndex = 0;
					}
				}
				var effectFrameVO:EffectFrameVO = this._effectTemplateVO.getEffectFrameByIndex(this._currentEffectIndex);
				if (effectFrameVO == null) {
					this.removeFromStage();
					return;
				}
				this._templateBitmap.scrollRect = new Rectangle(effectFrameVO.initX, effectFrameVO.initY, effectFrameVO.initW, effectFrameVO.initH);
				this._templateBitmap.x = effectFrameVO.offsetPoint.x - offsetBase;
				this._templateBitmap.y = effectFrameVO.offsetPoint.y - offsetBase;
			}
		}
	}
	
	public function destroy():Void {
		super.removeFromStage();
		if (_effectTemplateVO == null) return;
		if (AnimationTemplateManager.getInstance().removeEffectTemplate(this.effectConfigVO.id)) {
			this._effectTemplateVO.disposeBmd();
		}
	}
	
	public function resetEffect():Void {
		this._currentEffectIndex = 0;
		this._currentPlayIndex = 0;
	}
	
	private function initEffectComplete():Void {
		this._effectTemplateVO = AnimationTemplateManager.getInstance().getEffectTemplate(this._effectConfigVO.id);
		var effectFrameVO:EffectFrameVO = this._effectTemplateVO.getEffectFrameByIndex(this._currentEffectIndex);
		if (effectFrameVO == null) {
			effectFrameVO = this._effectTemplateVO.getEffectFrameByIndex(0);
		}
		this._templateBitmap.bitmapData = effectFrameVO.bitmapData;
		this._templateBitmap.scrollRect = new Rectangle(effectFrameVO.initX, effectFrameVO.initY, effectFrameVO.initW, effectFrameVO.initH);
		this._templateBitmap.x = effectFrameVO.offsetPoint.x - offsetBase;
		this._templateBitmap.y = effectFrameVO.offsetPoint.y - offsetBase;
	}
	
	function get_effectConfigVO():EffectConfigXmlVO {
		return _effectConfigVO;
	}
	
	function get_playAndRemove():Bool {
		return playAndRemove;
	}
}