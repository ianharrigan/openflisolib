package eDpLib.events;

import flash.events.Event;

class ListenerHash {
	public var listeners:Array<Dynamic -> Void>;
	public function new() {
		listeners = new Array<Dynamic -> Void>();
	}
	
	public function addListener(listener:Dynamic -> Void):Void {
		if (contains(listener)) {
			listeners.push(listener);
		}
	}
	
	public function removeListener(listener:Dynamic -> Void):Void {
		if (contains(listener)) {
			var i:Int = 0;
			var m:Int = listeners.length;
			
			while (i < m) {
				if (listener == listeners[i]) {
					break;
				}
				listeners.splice(i, 1);
			}
		}
	}
	
	public function contains(listener:Dynamic -> Void):Bool {
		return (Lambda.indexOf(listeners, listener) != -1);
	}
}