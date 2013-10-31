package eDpLib.events;

import flash.events.Event;
import flash.events.IEventDispatcher;

class ProxyEvent extends Event {
	public var proxy:IEventDispatcher;
	public var proxyTarget:IEventDispatcher;
	
	//////////// TODO: doesnt work!
	#if (flash || html5)
	private function get_target():Dynamic {
		//trace(" in proxy event!");
		return proxy;
	}
	#else
	private override function get_target():Dynamic {
		//trace(" in proxy event!");
		return proxy;
	}
	#end
	
	public var targetEvent:Event;
	
	public function new(proxy:IEventDispatcher, targetEvt:Event) {
		super(targetEvt.type, targetEvt.bubbles, targetEvt.cancelable);

		this.proxy = proxy;
		this.proxyTarget = null;
		if (Std.is(proxy, IEventDispatcherProxy)) {
			this.proxyTarget = cast(proxy, IEventDispatcherProxy).proxyTarget;
		}
		this.targetEvent = targetEvt;
	}
	
	override public function clone():Event {
		return new ProxyEvent(proxy, targetEvent);
	}
}