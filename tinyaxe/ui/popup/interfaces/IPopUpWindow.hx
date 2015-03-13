package tinyaxe.ui.popup.interfaces;
import org.puremvc.haxe.patterns.mediator.Mediator;
import tinyaxe.resource.xml.WindowConfigXml.WindowConfigXmlVO;

/**
 * @time 2015/3/13 11:06:15
 * @author Hoothin
 */

interface IPopUpWindow {
  function init():Void;
  function getWidth():Float;
  function getHeight():Float;
  function openWindow():Void;
  function initWindow(?data:Dynamic):Void;
  function closeWindow(?closeStraight:Bool = false):Void;
  function destroyWindow():Void;
  function setMaskBG(value:Bool):Void;
  function setWindowEnabled(enabled:Bool):Void;
  var isOpening(get_isOpening, null):Bool;
  var isClosing(get_isClosing, null):Bool;
  var isInit(get_isInit, null):Bool;
  var windowConfigXmlVO(get_windowConfigXmlVO, null):WindowConfigXmlVO;
  var windowMediator(get_windowMediator, null):Mediator;
  var windowName(get_windowName, null):String;
  var isOpen(get_isOpen, null):Bool;
  var x(get, set):Float;
  var y(get, set):Float;
}