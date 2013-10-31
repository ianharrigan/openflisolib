package openflisolib.core;

class EventListenerDescriptor {
	public var type:String;
	public var listener:Dynamic->Void;
	public var useCapture:Bool;
	public var priority:Int;
	public var useWeakReference:Bool;
}