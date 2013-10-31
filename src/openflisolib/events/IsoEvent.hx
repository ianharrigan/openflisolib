package openflisolib.events;

import flash.events.Event;

class IsoEvent extends Event {
	/**
	 * The IsoEvent.INVALIDATE constant defines the value of the type property of the event object for an iso event.
	 */
	static public inline var INVALIDATE:String = "as3isolib_invalidate";
	
	/**
	 * The IsoEvent.RENDER constant defines the value of the type property of the event object for an iso event.
	 */
	static public inline var RENDER:String = "as3isolib_render";
	
	/**
	 * The IsoEvent.RENDER_COMPLETE constant defines the value of the type property of the event object for an iso event.
	 */
	static public inline var RENDER_COMPLETE:String = "as3isolib_renderComplete";
	
	/**
	 * The IsoEvent.MOVE constant defines the value of the type property of the event object for an iso event.
	 */
	static public inline var MOVE:String = "as3isolib_move";
	
	/**
	 * The IsoEvent.RESIZE constant defines the value of the type property of the event object for an iso event.
	 */
	static public inline var RESIZE:String = "as3isolib_resize";
	
	/**
	 * The IsoEvent.CHILD_ADDED constant defines the value of the type property of the event object for an iso event.
	 */
	static public inline var CHILD_ADDED:String = "as3isolib_childAdded";
	
	/**
	 * The IsoEvent.CHILD_REMOVED constant defines the value of the type property of the event object for an iso event.
	 */
	static public inline var CHILD_REMOVED:String = "as3isolib_childRemoved";

	/**
	 * Specifies the property name of the property values assigned in oldValue and newValue.
	 */
	public var propName:String;
	
	/**
	 * Specifies the previous value assigned to the property specified in propName.
	 */
	public var oldValue:Dynamic;
	
	/**
	 * Specifies the new value assigned to the property specified in propName.
	 */
	public var newValue:Dynamic;
	
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false) {
		super(type, bubbles, cancelable);
	}
	
	override public function clone ():Event
	{
		var evt:IsoEvent = new IsoEvent(type, bubbles, cancelable);
		evt.propName = propName;
		evt.oldValue = oldValue;
		evt.newValue = newValue;
		
		return evt;
	}
}