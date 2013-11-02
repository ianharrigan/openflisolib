package eDpLib.events;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.IEventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

class EventDispatcherProxy implements IEventDispatcher implements IEventDispatcherProxy {
	////////////////////////////////////////////////////////////////////////
	//	PROXY TARGET
	////////////////////////////////////////////////////////////////////////
	private var _proxyTarget:IEventDispatcher;
	public var proxyTarget(get, set):IEventDispatcher;
	
	private function get_proxyTarget():IEventDispatcher {
		return _proxyTarget;
	}
	
	private function set_proxyTarget(value:IEventDispatcher):IEventDispatcher {
		if (_proxyTarget != value) {
			_proxyTarget = value;
			updateProxyListeners();
		}
		return value;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	PROXY
	////////////////////////////////////////////////////////////////////////
	private var _proxy:IEventDispatcher;
	public var proxy(get, set):IEventDispatcher;
	
	private function get_proxy():IEventDispatcher {
		return _proxy;
	}
	
	private function set_proxy(target:IEventDispatcher):IEventDispatcher {
		if (_proxy != target) {
			_proxy = target;
			eventDispatcher = new EventDispatcher(_proxy);
		}
		return target;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	CONSTRUCTOR
	////////////////////////////////////////////////////////////////////////
	public function new() {
		listenerHashTable = new Map < String, ListenerHash >();
		interceptedEventHash = new Map<String, String>();
		_proxyTargetListenerQueue = new Array<Dynamic>();
		proxy = this;
		interceptedEventTypes = generateEventTypes();
	}
	
	////////////////////////////////////////////////////////////////////////
	//	LISTENER HASH
	////////////////////////////////////////////////////////////////////////
	private var listenerHashTable:Map < String, ListenerHash > ;
	
	private function setListenerHashProperty(type:String, listener:Dynamic -> Void):Void {
		var hash:ListenerHash = listenerHashTable.get(type);
		if (hash == null) {
			hash = new ListenerHash();
			hash.addListener(listener);
			listenerHashTable.set(type, hash);
		} else {
			hash.addListener(listener);
		}
	}
	
	private function hasListenerHashProperty(type:String):Bool {
		var hash:ListenerHash = listenerHashTable.get(type);
		return (hash != null);
	}
	
	private function getListenersForEventType(type:String):Array <Dynamic -> Void> {
		var hash:ListenerHash = listenerHashTable.get(type);
		if (hash != null) {
			return hash.listeners;
		} else {
			return new Array < Dynamic -> Void > ();
		}
	}
	
	private function removeListenerHashProperty( type:String, listener:Dynamic -> Void ):Bool {
		var hash:ListenerHash = listenerHashTable.get(type);
		if (hash != null) {
			hash.removeListener(listener);
			return true;
		}
		return false;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	MISC. PROXY METHODS
	////////////////////////////////////////////////////////////////////////
	private var interceptedEventHash:Map<String, String>;
	public var interceptedEventTypes(get, set):Array<String>;
	
	public function get_interceptedEventTypes():Array<String> {
		var a:Array<String> = new Array<String>();
		var p:String;
		for (p in interceptedEventHash) {
			a.push(p);
		}
		
		return a;
	}
	
	public function set_interceptedEventTypes(value:Array<String>):Array<String> {
		var hash:Map<String, String> = new Map<String, String>();
		var type:String;
		for (type in value) {
			hash.set(type, type);
		}
		interceptedEventHash = hash;
		return value;
	}
	
	private function generateEventTypes():Array<String> {
		var evtTypes:Array<String> = [
				//REGULAR EVENTS
				Event.ADDED,
				Event.ADDED_TO_STAGE,
				Event.ENTER_FRAME,
				Event.REMOVED,
				Event.REMOVED_FROM_STAGE,
				Event.RENDER,
				Event.TAB_CHILDREN_CHANGE,
				Event.TAB_ENABLED_CHANGE,
				Event.TAB_INDEX_CHANGE,
				
				//FOCUS EVENTS
				FocusEvent.FOCUS_IN,
				FocusEvent.FOCUS_OUT,
				FocusEvent.KEY_FOCUS_CHANGE,
				FocusEvent.MOUSE_FOCUS_CHANGE,
				
				//MOUSE EVENTS
				MouseEvent.CLICK,
				MouseEvent.DOUBLE_CLICK,
				MouseEvent.MOUSE_DOWN,
				MouseEvent.MOUSE_MOVE,
				MouseEvent.MOUSE_OUT,
				MouseEvent.MOUSE_OVER,
				MouseEvent.MOUSE_UP,
				MouseEvent.MOUSE_WHEEL,
				MouseEvent.ROLL_OUT,
				MouseEvent.ROLL_OVER,
				
				//KEYBOARD EVENTS
				KeyboardEvent.KEY_DOWN,
				KeyboardEvent.KEY_UP
		];
		return evtTypes;
	}
	
	private function checkForInteceptedEventType( type:String ):Bool {
		return interceptedEventHash.get(type) != null;
	}
	
	private function eventDelegateFunction( evt:Event ):Void {
		evt.stopImmediatePropagation();
		
		var pEvt:ProxyEvent = new ProxyEvent( proxy, evt );
		pEvt.proxyTarget = proxyTarget;
		
		var func:Dynamic -> Void;
		var listeners:Array < Dynamic -> Void > ;
		
		if (hasListenerHashProperty(evt.type)) {
			listeners = getListenersForEventType(evt.type);
			for (func in listeners) {
				func(pEvt);
			}
		}
	}
	
	public var deleteQueueAfterUpdate:Bool = true;
	
	private function updateProxyListeners():Void {
		var queueItem:Dynamic;
		for (queueItem in _proxyTargetListenerQueue) {
			proxyTarget.addEventListener( queueItem.type, eventDelegateFunction, queueItem.useCapture, queueItem.priority, queueItem.useWeakReference );
		}
		
		if ( deleteQueueAfterUpdate ) {
			_proxyTargetListenerQueue = new Array<Dynamic>();
		}
	}
	
	////////////////////////////////////////////////////////////////////////
	//	EVENT DISPATCHER HOOKS
	////////////////////////////////////////////////////////////////////////
	private var _proxyTargetListenerQueue:Array<Dynamic>;

	private var eventDispatcher:EventDispatcher;
	
	public function hasEventListener( type:String ):Bool {
		if ( checkForInteceptedEventType( type )) {
			if ( proxyTarget != null) {
				return proxyTarget.hasEventListener( type );
			} else {
				return false;
			}
		} else {
			return eventDispatcher.hasEventListener( type );
		}
	}
	
	public function willTrigger( type:String ):Bool {
		if ( checkForInteceptedEventType( type )) {
			if ( proxyTarget != null) {
				return proxyTarget.willTrigger( type );
			} else {
				return false;
			}
		} else {
			return eventDispatcher.willTrigger( type );
		}
	}
	
	public function addEventListener( type:String, listener:Dynamic -> Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false ):Void {
		if ( checkForInteceptedEventType( type )) {
			setListenerHashProperty( type, listener );
			if ( proxyTarget != null) {
				proxyTarget.addEventListener( type, eventDelegateFunction, useCapture, priority, useWeakReference );
			} else {
				var queueItem:Dynamic = { type:type, useCapture:useCapture, priority:priority, useWeakReference:useWeakReference };
				_proxyTargetListenerQueue.push( queueItem );
			}
		} else {
			eventDispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
	}
	
	public function removeEventListener( type:String, listener:Dynamic -> Void, useCapture:Bool = false ):Void {
		if ( checkForInteceptedEventType( type )) {
			if ( hasListenerHashProperty( type )) {
				removeListenerHashProperty( type, listener );
				
				if ( proxyTarget == null) {
					var quequeItem:Dynamic;
					
					var i:Int;
					var l:Int = _proxyTargetListenerQueue.length;
					
					for (i in 0...l)
					{
						quequeItem = _proxyTargetListenerQueue[ i ];
						
						if ( quequeItem.type == type )
						{
							_proxyTargetListenerQueue.splice( i, 1 );
							return;
						}
					}
				}
			}
		} else {
			eventDispatcher.removeEventListener( type, listener, useCapture );
		}
	}
	
	public function dispatchEvent( event:Event ):Bool {
		if ( event.bubbles || checkForInteceptedEventType( event.type )) {
			return proxyTarget.dispatchEvent( new ProxyEvent( this, event ));
		} else {
			return eventDispatcher.dispatchEvent( event );
		}
	}
	
}