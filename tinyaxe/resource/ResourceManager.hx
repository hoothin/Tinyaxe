package tinyaxe.resource;

import tinyaxe.resource.enums.ResTypeEnum;
import tinyaxe.resource.res.ResData;
import tinyaxe.resource.vo.LoadTask;
import tinyaxe.utility.TimeKeeper;
import motion.Actuate;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;
/**
 * ...
 * @author Hoothin
 */
class ResourceManager {
	private static var _resourceManager:ResourceManager;
	public static function getInstance():ResourceManager {
		if (_resourceManager == null) {
			_resourceManager = new ResourceManager();
		}
		return _resourceManager;
	}
	
	private var _loaderManager:LoaderManager;
	private var _imgResDataList:Map<String, BitmapData>;
	private var _xmlResDataList:Map<String, Xml>;
	private var _binaryDataList:Map<String, ByteArray>;
	private var _callBackFuncList:Map<Int, Void->Void>;
	private var copyFunction:Array < Void->Void > ;
	private var copyIndex:Int = 0;
	public function new() {
		this._imgResDataList = new Map<String, BitmapData>();
		this._xmlResDataList = new Map<String, Xml>();
		this._binaryDataList = new Map<String, ByteArray>();
		
		this._callBackFuncList = new Map<Int, Void->Void>();
		this.copyFunction = [];
	}
	
	public function init():Void {
		LoaderManager.getInstance().initLoader(10);
	}
	
	/**
	 * prepareRes
	 * @param	resourceUrlList
	 * @param	resourceType
	 * @param	callBackFunction
	 * @param	isCoreData true严格分开，互不影响，0是皮肤等专用，不应抢占；false共享loader
	 * @param	coreType 
	 * @return
	 */
	public static function prepareRes(resourceUrlList:Array<String>, resourceType:ResTypeEnum, ?callBackFunction:Void->Void = null, ?isCoreData:Bool = false, ?coreType:Int = 0):Int {
		return getInstance().prepareResHandler(resourceUrlList, resourceType, callBackFunction, isCoreData, coreType);
	}
	
	public static function getImgBitmapData(imgUrl:String):BitmapData {
		if (getInstance()._imgResDataList[imgUrl] != null) {
			return getInstance()._imgResDataList[imgUrl];
		}
		return null;
	}
	
	public static function getXmlData(xmlUrl:String):Xml {
		if (getInstance()._xmlResDataList[xmlUrl] != null) {
			return getInstance()._xmlResDataList[xmlUrl];
		}
		return null;
	}
	
	public static function getBinaryData(binaryDataUrl:String):ByteArray {
		if (getInstance()._binaryDataList[binaryDataUrl] != null) {
			var byteResult:ByteArray = getInstance()._binaryDataList[binaryDataUrl];
			byteResult.position = 0;
			return byteResult;
		}
		return null;
	}
	
	public static function disposeBmd(imgUrl:String):Void {
		var imgres:BitmapData = getInstance()._imgResDataList.get(imgUrl);
		if (imgres != null) {
			imgres.dispose();
		}
		getInstance()._imgResDataList.remove(imgUrl);
	}
	
	private function filterResourceUrlList(urlList:Array<String>, resourceType:ResTypeEnum):Array<String> {
		var filterUrlList:Array<String> = new Array<String>();
		var filterResList:Map<String, Dynamic> = null;
		switch(resourceType) {
			case ResTypeEnum.ResTypeImage:
				filterResList = this._imgResDataList;
			case ResTypeEnum.ResTypeXml:
				filterResList = this._xmlResDataList;
			case ResTypeEnum.ResTypeBinaryData:
				filterResList = this._binaryDataList;	
		}
		
		for (url in urlList) {
			if (filterResList.exists(url) == false) {
				filterUrlList.push(url);
			}else if (resourceType == ResTypeEnum.ResTypeImage) {
				try {
					filterResList[url].width; 
				}catch (e:Dynamic) {
					filterUrlList.push(url);
				}
			}
		}
		urlList = [];
		return filterUrlList;
	}
	
	private function prepareResHandler(resourceUrlList:Array<String>, resourceType:ResTypeEnum, callBackFunction:Void->Void, isCoreData:Bool, coreType:Int):Int {
		var filterUrlList:Array<String> = this.filterResourceUrlList(resourceUrlList, resourceType);
		var taskId:Int = -1;
		if (filterUrlList.length > 0) {
			switch(resourceType) {
				case ResTypeEnum.ResTypeImage:
					taskId = LoaderManager.getInstance().startLoadImg(filterUrlList, prepareResComplete, isCoreData, coreType);
				case ResTypeEnum.ResTypeXml:
					taskId = LoaderManager.getInstance().startLoadXml(filterUrlList, prepareResComplete, isCoreData, coreType);
				case ResTypeEnum.ResTypeBinaryData:
					taskId = LoaderManager.getInstance().startLoadBinaryData(filterUrlList, prepareResComplete, isCoreData, coreType);
			}
		}else {
			if (callBackFunction != null) {
				callBackFunction();
			}
		}
		
		if (taskId >= 0 && callBackFunction != null) {
			this._callBackFuncList[taskId] = callBackFunction;
		}
		return taskId;
	}
	
	private function prepareResComplete(imgList:Array<ResData>, taskId:Int):Void {
		for (resData in imgList) {
			//Lib.trace(resData.resUrl);
			switch(resData.resType) {
				case ResTypeEnum.ResTypeImage:
					this._imgResDataList.set(StringTools.urlDecode(resData.resUrl), resData.resData);
				case ResTypeEnum.ResTypeXml:
					this._xmlResDataList.set(StringTools.urlDecode(resData.resUrl), resData.resData);
				case ResTypeEnum.ResTypeBinaryData:
					this._binaryDataList.set(StringTools.urlDecode(resData.resUrl), resData.resData);
			}
		}
		var allComplete:Bool = true;
		for (task in LoaderManager.getInstance().completedTask) {
			allComplete = true;
			var filterResList:Map<String, Dynamic> = null;
			switch(task.taskType) {
				case LoadTask.TASK_IMG:
					filterResList = this._imgResDataList;
				case LoadTask.TASK_XML:
					filterResList = this._xmlResDataList;
				case LoadTask.TASK_BINARY:
					filterResList = this._binaryDataList;	
			}
			for (res in task.originalUrl) {
				if (filterResList.exists(res) == false) {
					allComplete = false;
					break;
				}else if (task.taskType == LoadTask.TASK_IMG) {
					try {
						filterResList[res].width; 
					}catch (e:Dynamic) {
						allComplete = false;
						break;
					}
				}
			}
			if (allComplete) {
				TimeKeeper.addTimerEventListener(resCompleteHandler, 0, [task.taskUID]);
				//resCompleteHandler(task.taskUID);
			}
		}
	}
	
	private function resCompleteHandler(taskId:Int):Void {
		var callBackFunc:Void->Void = this._callBackFuncList[taskId];
		this._callBackFuncList[taskId] = null;
		this._callBackFuncList.remove(taskId);
		if (callBackFunc != null) {
			callBackFunc();
		}
	}
}