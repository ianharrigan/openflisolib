package eDpLib.events;

import flash.events.IEventDispatcher;

interface IEventDispatcherProxy extends IEventDispatcher {
	var proxy(get, set):IEventDispatcher;
	var proxyTarget(get, set):IEventDispatcher;
}