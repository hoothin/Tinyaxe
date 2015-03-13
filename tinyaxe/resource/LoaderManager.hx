package tinyaxe.resource;
import tinyaxe.resource.enums.ResTypeEnum;
import tinyaxe.resource.event.ResLoadingEvent;
import tinyaxe.resource.res.ResData;
import tinyaxe.resource.vo.LoadTask;
import tinyaxe.utility.Debug;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.zip.Entry;
import haxe.zip.Reader;
import openfl.display.BitmapData;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;
import openfl.system.SecurityDomain;
import openfl.utils.ByteArray;

/**
 * ...
 * @author Hoothin
 */
class LoaderManager extends EventDispatcher {
	public var LOAD_PATH:String = "";
	private var compressRes:Bool = false;
	private var CONFIG_PATH:String = "xml";
	
	public static inline var URL_LOAD_COMPLETE:String = "URL_LOAD_COMPLETE";
	public static inline var TASK_LOAD_COMPLETE:String = "TASK_LOAD_COMPLETE";
	public static inline var TOTAL_LOAD_COMPLETE:String = "TOTAL_LOAD_COMPLETE";
	
	public var completedTask(get, null):Array<LoadTask>;
	private var coreLoaderList:Array<URLLoader>;
	private var commonLoaderList:Array<URLLoader>;
	private var taskMap:Map<URLLoader, LoadTask>;
	private var coreTaskList:Array<LoadTask>;
	private var commonTaskList:Array<LoadTask>;
	private var taskUniqueId:Int;
	private var loaderMaxNum:Int;
	private var coreMaxNum:Int = 3;
	private var context:LoaderContext;
	private static var _loaderManager:LoaderManager;
	public static function getInstance():LoaderManager {
		if (_loaderManager == null) {
			_loaderManager = new LoaderManager();
		}
		return _loaderManager;
	}

	public function new() {
		super();
		this.coreTaskList = new Array<LoadTask>();
		this.commonTaskList = new Array<LoadTask>();
		this.completedTask = new Array<LoadTask>();
		this.taskUniqueId = 0;
		this.taskMap = new Map();
		this.context = new LoaderContext();
		this.context.securityDomain = SecurityDomain.currentDomain;
		#if debug
		#else
		if (Debug.inner) {
			LOAD_PATH = "";
		}
		#end
	}
	
	public function initLoader(commonLoaderNum:Int):Void {
		this.commonLoaderList = new Array<URLLoader>();
		this.coreLoaderList = new Array<URLLoader>();
		this.loaderMaxNum = commonLoaderNum;
		for (i in 0...this.loaderMaxNum) {
			var newCommonUrlLoader:URLLoader = new URLLoader();
			newCommonUrlLoader.addEventListener(Event.COMPLETE, commonLoadComplete);
			newCommonUrlLoader.addEventListener(IOErrorEvent.IO_ERROR, commonIoErrorHandler);
			newCommonUrlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, commonSecurityErrorHandler);
			this.commonLoaderList.push(newCommonUrlLoader);
			this.taskMap.set(newCommonUrlLoader, null);
		}
		
		for (i in 0...this.coreMaxNum) {
			var newCoreUrlLoader:URLLoader = new URLLoader();
			newCoreUrlLoader.addEventListener(Event.COMPLETE, coreLoadComplete);
			newCoreUrlLoader.addEventListener(IOErrorEvent.IO_ERROR, coreIoErrorHandler);
			newCoreUrlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, coreSecurityErrorHandler);
			this.coreLoaderList.push(newCoreUrlLoader);
			this.taskMap.set(newCoreUrlLoader, null);
		}
	}
	
	/**
	 * Load image
	 * @param	imgUrl
	 * @param	callBackFunction
	 * @param	isCoreData
	 * @param	coreType 0代表普通资源，1代表场景资源，2代表战斗资源，3代表其他需要步进加载的零碎
	 * @return
	 */
	public function startLoadImg(imgUrl:Array<String>, callBackFunction:Array<ResData>->Int->Void, ?isCoreData:Bool = false, ?coreType:Int = 0):Int {
		var newTask:LoadTask = new LoadTask(imgUrl);
		newTask.initLoadTask(filterLoadList(imgUrl), LoadTask.TASK_IMG, callBackFunction, this.getTaskId(), coreType);
		if (isCoreData == true) {
			this.coreTaskList.push(newTask);
			this.startCoreTask();
		}else {
			this.commonTaskList.push(newTask);
			for (thisLoader in commonLoaderList) {
				if (this.taskMap.get(thisLoader) == null) {
					this.startCommonTask(thisLoader);
					break;
				}
			}
		}
		return newTask.taskUID;
	}
	
	public function startLoadXml(xmlUrl:Array<String>, callBackFunction:Array<ResData>->Int->Void, ?isCoreData:Bool = false, ?coreType:Int = 0):Int {
		var newTask:LoadTask = new LoadTask(xmlUrl);
		newTask.initLoadTask(filterLoadList(xmlUrl), LoadTask.TASK_XML, callBackFunction, this.getTaskId(), coreType);
		if (isCoreData == true) {
			this.coreTaskList.push(newTask);
			this.startCoreTask();
		}else {
			this.commonTaskList.push(newTask);
			for (thisLoader in commonLoaderList) {
				if (this.taskMap.get(thisLoader) == null) {
					this.startCommonTask(thisLoader);
					break;
				}
			}
		}
		return newTask.taskUID;
	}
	
	public function startLoadBinaryData(dataUrl:Array<String>, callBackFunction:Array<ResData>->Int->Void, ?isCoreData:Bool = false, ?coreType:Int = 0):Int {
		var newTask:LoadTask = new LoadTask(dataUrl);
		newTask.initLoadTask(filterLoadList(dataUrl), LoadTask.TASK_BINARY, callBackFunction, this.getTaskId(), coreType);
		if (isCoreData == true) {
			this.coreTaskList.push(newTask);
			this.startCoreTask();
		}else {
			this.commonTaskList.push(newTask);
			for (thisLoader in commonLoaderList) {
				if (this.taskMap.get(thisLoader) == null) {
					this.startCommonTask(thisLoader);
					break;
				}
			}
		}
		return newTask.taskUID;
	}
	
	public function getTotalUrlNum(?taskUID:Int = -1):Int {
		var totalNum:Int = 0;
		
		if (taskUID >= 0) {
			for (taskVO in this.commonTaskList) {
				if (taskVO.taskUID == taskUID) {
					return taskVO.taskUrl.length;
				}
			}
			
			for (taskVO in this.coreTaskList) {
				if (taskVO.taskUID == taskUID) {
					return taskVO.taskUrl.length;
				}
			}
			
			for (taskVO in this.taskMap) {
				if (taskVO != null && taskVO.taskUID == taskUID) {
					return taskVO.taskUrl.length;
				}
			}
		}else {
			
			for (taskVO in this.commonTaskList) {
				totalNum += taskVO.taskUrl.length;
			}
			
			for (taskVO in this.coreTaskList) {
				totalNum += taskVO.taskUrl.length;
			}
			
			for (taskVO in this.taskMap) {
				if (taskVO != null)
				totalNum += taskVO.taskUrl.length;
			}
		}
		return totalNum;
	}
	
	private function beginCommonTask(curLoader:URLLoader, ?isSuccess:Bool = true):Void {
		var commonTask:LoadTask = this.taskMap.get(curLoader);
		if (commonTask != null) {
			if (isSuccess) {
				commonTask.gotoNextUrl();
			}else {
				commonTask.failed();
				if (commonTask.failedTime >= 3) {
					commonTask.gotoNextUrl();
				}
			}
			var currentUrl:String = commonTask.getCurrentUrl();
			if (currentUrl == null) {
				this.completedTask.push(commonTask);
				commonTask.callBackFunction(commonTask.dataList, commonTask.taskUID);
				commonTask = null;
				this.dispatchEvent(new Event(TASK_LOAD_COMPLETE));
				this.startCommonTask(curLoader);
			}else {
				commonTask.changeState(1);
				var urlRequest:URLRequest = new URLRequest(LOAD_PATH + currentUrl);
				switch(commonTask.taskType) {
					case LoadTask.TASK_IMG:
						var splitIndex:Int = currentUrl.lastIndexOf(".");
						currentUrl = currentUrl.substring(0, splitIndex) + ".hda";
						urlRequest = new URLRequest(LOAD_PATH + currentUrl);
						curLoader.dataFormat = URLLoaderDataFormat.BINARY;
					case LoadTask.TASK_XML:
						var curDir:String = currentUrl.substring(0, currentUrl.lastIndexOf("/"));
						if (compressRes && curDir == "assets/xml") {
							curLoader.dataFormat = URLLoaderDataFormat.BINARY;
							currentUrl = curDir + "/" + CONFIG_PATH + ".zip";
							urlRequest = new URLRequest(LOAD_PATH + currentUrl);
						}else {
							curLoader.dataFormat = URLLoaderDataFormat.TEXT;
						}
					case LoadTask.TASK_BINARY:
						curLoader.dataFormat = URLLoaderDataFormat.BINARY;
				}
				try{
					curLoader.load(urlRequest);
				}catch (e:Error) {
					trace(e.toString());
					this.commonLoadFail(curLoader);
				}
			}
		}
	}
	
	private function startCommonTask(curLoader:URLLoader):Void {
		if (commonTaskList.length > 0) {
			var curTask:LoadTask = this.commonTaskList.shift();
			this.taskMap.set(curLoader, curTask);
			this.beginCommonTask(curLoader);	
		}else {
			this.taskMap.set(curLoader, null);
			this.dispatchEvent(new Event(TOTAL_LOAD_COMPLETE));
		}
	}
	
	private function beginCoreTask(curLoader:URLLoader, ?isSuccess:Bool = true):Void {
		var curTask:LoadTask = this.taskMap.get(curLoader);
		if (curTask != null) {
			if (isSuccess) {
				curTask.gotoNextUrl();
			}else {
				curTask.failed();
				if (curTask.failedTime >= 3) {
					curTask.gotoNextUrl();
				}
			}
			var currentUrl:String = curTask.getCurrentUrl();
			if (currentUrl == null) {
				this.completedTask.push(curTask);
				taskMap.set(curLoader, null);
				curTask.callBackFunction(curTask.dataList, curTask.taskUID);
				curTask = null;
				this.dispatchEvent(new Event(TASK_LOAD_COMPLETE));
				this.startCoreTask();
			}else {
				curTask.changeState(1);
				var urlRequest:URLRequest = new URLRequest(LOAD_PATH + currentUrl);
				switch(curTask.taskType) {
					case LoadTask.TASK_IMG:
						var splitIndex:Int = currentUrl.lastIndexOf(".");
						currentUrl = currentUrl.substring(0, splitIndex) + ".hda";
						urlRequest = new URLRequest(LOAD_PATH + currentUrl);
						curLoader.dataFormat = URLLoaderDataFormat.BINARY;
					case LoadTask.TASK_XML:
						var curDir:String = currentUrl.substring(0, currentUrl.lastIndexOf("/"));
						if (compressRes && curDir == "assets/xml") {
							curLoader.dataFormat = URLLoaderDataFormat.BINARY;
							currentUrl = curDir + "/" + CONFIG_PATH + ".zip";
							urlRequest = new URLRequest(LOAD_PATH + currentUrl);
						}else {
							curLoader.dataFormat = URLLoaderDataFormat.TEXT;
						}
					case LoadTask.TASK_BINARY:
						curLoader.dataFormat = URLLoaderDataFormat.BINARY;
				}
				try{//android下不存在直接throw error了啊泥煤！!
					curLoader.load(urlRequest);
				}catch (e:Error) {
					trace(e.toString());
					this.coreLoadFail(curLoader);
				}
			}
		}
	}
	
	private function startCoreTask():Void {
		for (loader in coreLoaderList) {
			var task:LoadTask = taskMap.get(loader);
			if (task == null) {
				var coreType:Int = this.coreLoaderList.indexOf(loader);
				for (coreTask in this.coreTaskList) {
					if (coreTask.coreType == coreType) {
						task = coreTask;
						coreTaskList.remove(coreTask);
						break;
					}
				}
				if (task != null) {
					taskMap.set(loader, task);
					this.beginCoreTask(loader);	
				}
			}
		}
	}
	
	private function coreLoadComplete(e:Event):Void {
		var curLoader:URLLoader = e.currentTarget;
		var coreTask:LoadTask = taskMap.get(curLoader);
		var resData:ResData = null;
		var currentUrl:String = coreTask.getCurrentUrl();
		var urlArr:Array<String> = currentUrl.split("/");
		this.dispatchEvent(new ResLoadingEvent(ResLoadingEvent.URL_LOAD_COMPLETE, coreTask.taskUID));
		switch(coreTask.taskType) {
			case LoadTask.TASK_IMG:
				var bmd:BitmapData = null;
				var byteTemp:ByteArray = curLoader.data;
				if (byteTemp != null) {
					var slideSwf:format.SWF = new format.SWF(byteTemp);					
					slideSwf.addEventListener(Event.COMPLETE, function(e) {
						byteTemp.clear();
						var name:String = urlArr.pop();
						name = name.substring(0, name.lastIndexOf("."));
						bmd = slideSwf.getBitmapData(name);
						resData =  new ResData(bmd, coreTask.currentProcessUrl, ResTypeEnum.ResTypeImage);
						coreTask.pushDataList(resData);
						this.beginCoreTask(curLoader);
					});
				}
			case LoadTask.TASK_XML:
				var curDir:String = currentUrl.substring(0, currentUrl.lastIndexOf("/"));
				if (compressRes && curDir == "assets/xml") {
					var xmlData:ByteArray = curLoader.data;
					xmlData.uncompress();
					var bytesInput = new BytesInput(getByte(xmlData));
					var r = new Reader(bytesInput);
					var entries:List<Entry> = r.read();
					for (entry in entries) {
						var bytes:Bytes = entry.data;
						var string = bytes.toString();
						var splitIndex:Int = currentUrl.lastIndexOf("/");
						currentUrl = currentUrl.substring(0, splitIndex + 1) + entry.fileName;
						resData = new ResData(Xml.parse(string).firstElement(), currentUrl, ResTypeEnum.ResTypeXml);
						coreTask.pushDataList(resData);
					}
				}else if (curLoader.data != null) {
					resData = new ResData(Xml.parse(cast(curLoader.data, String)).firstElement(), coreTask.currentProcessUrl, ResTypeEnum.ResTypeXml);
					coreTask.pushDataList(resData);
				}
				this.beginCoreTask(curLoader);
			case LoadTask.TASK_BINARY:
				resData = new ResData(cast(curLoader.data, ByteArray), coreTask.currentProcessUrl, ResTypeEnum.ResTypeBinaryData);
				coreTask.pushDataList(resData);
				this.beginCoreTask(curLoader);
		}
	}
	
	private function commonLoadComplete(e:Event):Void {
		var curLoader:URLLoader = e.currentTarget;
		var commonTask:LoadTask = taskMap.get(curLoader);
		var resData:ResData = null;
		var currentUrl:String = commonTask.getCurrentUrl();
		var urlArr:Array<String> = currentUrl.split("/");
		this.dispatchEvent(new ResLoadingEvent(ResLoadingEvent.URL_LOAD_COMPLETE, commonTask.taskUID));
		switch(commonTask.taskType) {
			case LoadTask.TASK_IMG:
				var bmd:BitmapData = null;
				var byteTemp:ByteArray = curLoader.data;
				if (byteTemp != null) {
					var slideSwf:format.SWF = new format.SWF(byteTemp);
					slideSwf.addEventListener(Event.COMPLETE, function(e) {
						byteTemp.clear();
						var name:String = urlArr.pop();
						name = name.substring(0, name.lastIndexOf("."));
						bmd = slideSwf.getBitmapData(name);
						resData =  new ResData(bmd, commonTask.currentProcessUrl, ResTypeEnum.ResTypeImage);
						commonTask.pushDataList(resData);
						this.beginCommonTask(curLoader);
					});
				}
			case LoadTask.TASK_XML:
				var curDir:String = currentUrl.substring(0, currentUrl.lastIndexOf("/"));
				if (compressRes && curDir == "assets/xml") {
					var xmlData:ByteArray = curLoader.data;
					xmlData.uncompress();
					var bytesInput = new BytesInput(getByte(xmlData));
					var r = new Reader(bytesInput);
					var entries:List<Entry> = r.read();
					for (entry in entries) {
						var bytes:Bytes = entry.data;
						var string = bytes.toString();
						var splitIndex:Int = currentUrl.lastIndexOf("/");
						currentUrl = currentUrl.substring(0, splitIndex + 1) + entry.fileName;
						resData = new ResData(Xml.parse(string).firstElement(), currentUrl, ResTypeEnum.ResTypeXml);
						commonTask.pushDataList(resData);
					}
				}else if (curLoader.data != null) {
					resData = new ResData(Xml.parse(cast(curLoader.data, String)).firstElement(), commonTask.currentProcessUrl, ResTypeEnum.ResTypeXml);
					commonTask.pushDataList(resData);
				}
				this.beginCommonTask(curLoader);
			case LoadTask.TASK_BINARY:
				resData = new ResData(cast(curLoader.data, ByteArray), commonTask.currentProcessUrl, ResTypeEnum.ResTypeBinaryData);
				commonTask.pushDataList(resData);
				this.beginCommonTask(curLoader);
		}
	}
	
	private function coreSecurityErrorHandler(e:SecurityErrorEvent):Void {
		var curLoader:URLLoader = e.currentTarget;
		this.coreLoadFail(curLoader);
	}
	
	private function coreIoErrorHandler(e:IOErrorEvent):Void {
		var curLoader:URLLoader = e.currentTarget;
		this.coreLoadFail(curLoader);
	}
	
	private function coreLoadFail(curLoader:URLLoader):Void {
		var curTask:LoadTask = this.taskMap.get(curLoader);
		if (curTask != null) {
			this.beginCoreTask(curLoader, false);
		}
	}
	
	private function commonSecurityErrorHandler(e:SecurityErrorEvent):Void {
		var curLoader:URLLoader = e.currentTarget;
		this.commonLoadFail(curLoader);
	}
	
	private function commonIoErrorHandler(e:IOErrorEvent):Void {
		var curLoader:URLLoader = e.currentTarget;
		this.commonLoadFail(curLoader);
	}
	
	private function commonLoadFail(curLoader:URLLoader):Void {
		var commonTask:LoadTask = this.taskMap.get(curLoader);
		if (commonTask != null) {
			this.beginCommonTask(curLoader, false);
		}
	}
	
	private function filterLoadList(loadList:Array<String>):Array<String> {
		var filterList:Array<String> = new Array<String>();
		for (loadUrl in loadList) {
			var hasUrl:Bool = false;
			
			if (!hasUrl) {
				for (loadTask in this.coreTaskList) {
					for (currentUrl in loadTask.taskUrl) {
						if (currentUrl == loadUrl) {
							hasUrl = true;
							break;
						}
					}
					
					if (hasUrl) {
						break;
					}
				}
			}
			
			if (!hasUrl) {
				for (loadTask in this.commonTaskList) {
					for (currentUrl in loadTask.taskUrl) {
						if (currentUrl == loadUrl) {
							hasUrl = true;
							break;
						}
					}
					if (hasUrl) {
						break;
					}
				}
			}
			
			if (!hasUrl) {
				for (thisTask in this.taskMap) {
					if (thisTask != null) {
						for (coreUrl in thisTask.taskUrl) {
							if (coreUrl == loadUrl) {
								hasUrl = true;
								break;
							}
						}
					}
					if (hasUrl) {
						break;
					}
				}
			}
			
			if (hasUrl == false) {
				filterList.push(loadUrl);
			}
		}
		
		return filterList;
	}
	
	private function getTaskId():Int {
		return this.taskUniqueId ++;
	}
	
	private function getByte(byteArray: ByteArray):Bytes {
		return #if flash Bytes.ofData(byteArray) #else cast(byteArray) #end;
	}
	
	function get_completedTask():Array<LoadTask> {
		return completedTask;
	}
}