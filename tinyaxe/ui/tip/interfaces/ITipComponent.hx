package tinyaxe.ui.tip.interfaces;
import tinyaxe.ui.tip.vo.TipInfoData;

/**
 * @time 2015/3/11 10:39:16
 * @author Hoothin
 */

interface ITipComponent {
  function initTipInfo(tipData:TipInfoData):Void;
  function updateTip(tipData:TipInfoData):Void;
  function cleanTip():Void;
}