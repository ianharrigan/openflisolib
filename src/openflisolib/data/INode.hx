package openflisolib.data;

import eDpLib.events.IEventDispatcherProxy;

interface INode extends IEventDispatcherProxy {
	var id(get, set):String;
	var name(get, set):String;
	var data(get, set):Dynamic;
	var owner(get, null):Dynamic;
	var parent(get, null):INode;
	var hasParent(get, null):Bool;
	function getRootNode():INode;
	function getDescendantNodes( includeBranches:Bool = false ):Array<INode>;
	function contains( value:INode ):Bool;
	var children(get, null):Array<INode>;
	var numChildren(get, null):Int;
	function addChild(child:INode):Void;
	function addChildAt( child:INode, index:Int ):Void;
	function getChildIndex( child:INode ):Int;
	function getChildByID( id:String ):INode;
	function setChildIndex( child:INode, index:Int ):Void;
	function removeChild( child:INode ):INode;
	function removeChildAt( index:Int ):INode;
	function removeChildByID( id:String ):INode;
	function removeAllChildren():Void;
}