package openflisolib.data;

import eDpLib.events.EventDispatcherProxy;
import flash.errors.Error;
import openflisolib.events.IsoEvent;

class Node extends EventDispatcherProxy implements INode {
	public function new() {
		super();
		UID = _IDCount++;
		childrenArray = new Array<INode>();
	}
	
	
	static private var _IDCount:Int = 0;
	
	public var UID:Int;
	
	private var setID:String;
	
	public var id(get, set):String;
	private function get_id():String {
		return ( setID == null || setID == "" ) ? "node" + UID : setID;
	}
	
	private function set_id(value:String):String {
		setID = value;
		return value;
	}
	
	////////////////////////////////////////////////
	//	NAME
	////////////////////////////////////////////////
	private var _name:String;
	public var name(get, set):String;
	private function get_name():String {
		return _name;	
	}
	private function set_name(value:String):String {
		_name = value;
		return _name;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	DATA
	////////////////////////////////////////////////////////////////////////
	private var _data:Dynamic;
	public var data(get, set):Dynamic;
	private function get_data():Dynamic {
		return _data;	
	}
	private function set_data(value:Dynamic):Dynamic {
		_data = value;
		return _name;
	}
	
	//////////////////////////////////////////////////////////////////
	//	OWNER
	//////////////////////////////////////////////////////////////////
	private var ownerObject:Dynamic;
	public var owner(get, null):Dynamic;
	private function get_owner():Dynamic {
		return ownerObject != null ? ownerObject : parentNode;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	PARENT
	////////////////////////////////////////////////////////////////////////
	public var hasParent(get, null):Bool;
	private function get_hasParent():Bool {
		return parentNode != null ? true : false;
	}
	
	private var parentNode:INode;
	public var parent(get, null):INode;
	private function get_parent():INode {
		return parentNode;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	ROOT NODE
	////////////////////////////////////////////////////////////////////////
	public function getRootNode():INode {
		var p:INode = this;
		while ( p.hasParent )
			p = p.parent;
		
		return p;
	}
	
	public function getDescendantNodes( includeBranches:Bool = false ):Array<INode> {
		var descendants:Array<INode> = new Array<INode>();
		var child:INode;
		for ( child in childrenArray ) {
			if ( child.children.length > 0 ) {
				descendants = descendants.concat( child.getDescendantNodes( includeBranches ));
				if ( includeBranches )
					descendants.push( child );
				
			} else {
				descendants.push( child );
			}
		}
		
		return descendants;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	CHILD METHODS
	////////////////////////////////////////////////////////////////////////
	public function contains( value:INode ):Bool {
		if ( value.hasParent ) {
			return value.parent == this;
		} else {
			var child:INode;
			for ( child in childrenArray ) {
				if ( child == value ) {
					return true;
				}
			}
			return false;
		}
	}
	
	private var childrenArray:Array<INode>;
	
	public var children(get, null):Array<INode>;
	private function get_children():Array<INode> {
		return childrenArray;
	}
	
	public var numChildren(get, null):Int;
	private function get_numChildren():Int {
		return childrenArray.length;
	}
	
	public function addChild( child:INode ):Void {
		addChildAt( child, numChildren );
	}
	
	public function addChildAt( child:INode, index:Int ):Void {
		if ( getChildByID( child.id ) != null) {
			return;
		}
		
		if ( child.hasParent ) {
			var parent:INode = child.parent;
			parent.removeChildByID( child.id );
		}
		
		cast( child, Node ).parentNode = this;
		childrenArray.insert( index, child );
		var evt:IsoEvent = new IsoEvent( IsoEvent.CHILD_ADDED );
		evt.newValue = child;

		dispatchEvent( evt );
	}
	
	public function getChildAt( index:Int ):INode {
		if ( index >= numChildren ) {
			throw new Error( "" );
		} else {
			return cast( childrenArray[ index ], Node );
		}
	}
	
	public function getChildIndex( child:INode ):Int {
		var i:Int = 0;
		while ( i < numChildren ) {
			if ( child == childrenArray[ i ])
				return i;
			i++;
		}
		return -1;
	}
	
	public function setChildIndex( child:INode, index:Int ):Void {
		var i:Int = getChildIndex( child );
		if ( i == index ) {
			return;
		}
		
		if ( i > -1 ) {
			childrenArray.splice( i, 1 ); //remove it form the array
			var c:INode;
			var notRemoved:Bool = false;
			
			for ( c in childrenArray ) {
				if ( c == child ) {
					notRemoved = true;
				}
			}
			
			if ( notRemoved ) {
				throw new Error( "" );
				return;
			}
			
			if ( index >= numChildren )
				childrenArray.push( child );
			else
				childrenArray.insert( index, child );
			
		} else {
			throw new Error( "" );
		}
	}
	
	public function removeChild( child:INode ):INode {
		return removeChildByID( child.id );
	}
	
	public function removeChildAt( index:Int ):INode {
		var child:INode;
		
		if ( index >= numChildren )
			return null;
		else
			child = cast( childrenArray[ index ], INode);
		return removeChildByID( child.id );
	}
	
	public function removeChildByID( id:String ):INode {
		var child:INode = getChildByID( id );
		if ( child != null) {
			cast( child , Node).parentNode = null;
			var i:Int;
			
			for ( i in 0...childrenArray.length) {
				if ( child == childrenArray[ i ]) {
					childrenArray.splice( i, 1 );
					break;
				}
			}
			
			var evt:IsoEvent = new IsoEvent( IsoEvent.CHILD_REMOVED );
			evt.newValue = child;
			
			dispatchEvent( evt );
		}
		
		return child;
	}
	
	public function removeAllChildren():Void {
		var child:INode;
		for ( child in childrenArray ) {
			cast( child , Node).parentNode = null;
		}
		
		childrenArray = new Array<INode>();
	}
	
	public function getChildByID( id:String ):INode {
		var childID:String;
		var child:INode;
		
		for ( child in childrenArray ) {
			childID = child.id;
			if ( childID == id ) {
				return child;
			}
		}
		
		return null;
	}
}