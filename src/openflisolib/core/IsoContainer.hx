package openflisolib.core;

import eDpLib.events.ProxyEvent;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.errors.Error;
import flash.events.Event;
import openflisolib.events.IsoEvent;
import openflisolib.data.INode;
import openflisolib.data.Node;

class IsoContainer extends Node implements IIsoContainer {
	public function new() {
		super();
		displayListChildrenArray = new Array<IIsoContainer>();
		addEventListener( IsoEvent.CHILD_ADDED, child_changeHandler );
		addEventListener( IsoEvent.CHILD_REMOVED, child_changeHandler );
		
		createChildren();
		
		proxyTarget = mainContainer;
	}
	
	private var mainContainer:Sprite;
	
	public var container(get, null):Sprite;
	private function get_container():Sprite {
		return mainContainer;
	}
	
	public var depth(get, null):Int;
	private function get_depth():Int {
		if (mainContainer.parent != null) {
			return mainContainer.parent.getChildIndex( mainContainer );
		} else {
			return -1;
		}
	}
	
	
	private var bIncludeInLayout:Bool = true;
	private var includeInLayoutChanged:Bool = false;
	
	public var includeInLayout(get, set):Bool;
	private function get_includeInLayout():Bool {
		return bIncludeInLayout;
	}
	private function set_includeInLayout(value:Bool):Bool {
		if (includeInLayout != value) {
			bIncludeInLayout = value;
			includeInLayoutChanged = true;
		}
		return value;
	}
	
	private var displayListChildrenArray:Array<IIsoContainer>;
	public var displayListChildren(get, null):Array<IIsoContainer>;
	private function get_displayListChildren():Array<IIsoContainer> {
		var temp:Array<IIsoContainer> = [];
		var child:IIsoContainer;
		for (child in displayListChildrenArray) {
			temp.push(child);
		}
		return temp;
	}
	
	override public function addChildAt(child:INode, index:Int):Void {
		if (Std.is(child, IIsoContainer)) {
			super.addChildAt(child, index);
			if (cast(child, IIsoContainer).includeInLayout) {
				displayListChildrenArray.push( cast(child, IIsoContainer) );
				if ( index > mainContainer.numChildren ) {
					index = mainContainer.numChildren;
				}
				
				//referencing explicit removal of child RTE - http://life.neophi.com/danielr/2007/06/rangeerror_error_2006_the_supp.html
				var p:DisplayObjectContainer = cast(child, IIsoContainer).container.parent;
				if ( p != null && p != mainContainer ) {
					p.removeChild( cast(child, IIsoContainer).container );
				}
				
				mainContainer.addChildAt( cast(child, IIsoContainer).container, index );
			}
		} else {
			throw new Error("parameter child does not implement IContainer.");
		}
	}
	
	override public function setChildIndex(child:INode, index:Int):Void {
		if (!Std.is(child, IIsoContainer)) {
			throw new Error( "parameter child does not implement IContainer." );
		} else if (!child.hasParent || child.parent != this) {
			throw new Error( "parameter child is not found within node structure." );
		} else {
			super.setChildIndex( child, index );
			mainContainer.setChildIndex( cast(child, IIsoContainer).container, index );
		}
	}
	
	override public function removeChildByID( id:String ):INode {
		var child:IIsoContainer = cast( super.removeChildByID( id ), IIsoContainer);
		if ( child != null && child.includeInLayout ) {
			var i:Int = Lambda.indexOf(displayListChildrenArray, child );
			if ( i > -1 )
				displayListChildrenArray.splice( i, 1 );
			mainContainer.removeChild( cast(child, IIsoContainer).container );
		}
		
		return child;
	}
	
	override public function removeAllChildren():Void {
		var child:INode;
		for ( child in children ) {
			if ( cast(child, IIsoContainer).includeInLayout ) {
				mainContainer.removeChild( cast(child, IIsoContainer).container );
			}
		}
		
		displayListChildrenArray = new Array<IIsoContainer>();
		
		super.removeAllChildren();
	}
	
	private function createChildren():Void {
		mainContainer = new Sprite();
		attachMainContainerEventListeners();
	}
	
	private function attachMainContainerEventListeners():Void {
		if ( mainContainer != null ) {
			mainContainer.addEventListener( Event.ADDED, mainContainer_addedHandler, false, 0, true );
			mainContainer.addEventListener( Event.ADDED_TO_STAGE, mainContainer_addedToStageHandler, false, 0, true );
			mainContainer.addEventListener( Event.REMOVED, mainContainer_removedHandler, false, 0, true );
			mainContainer.addEventListener( Event.REMOVED_FROM_STAGE, mainContainer_removedFromStageHandler, false, 0, true );
		}
	}
	
	///////////////////////////////////////////////////////////////////////
	//	DISPLAY LIST & STAGE LOGIC
	///////////////////////////////////////////////////////////////////////
	private var bAddedToDisplayList:Bool;
	private var bAddedToStage:Bool;
	
	public var isAddedToDisplay(get, null):Bool;
	private function get_isAddedToDisplay():Bool {
		return bAddedToDisplayList;
	}
	
	public var isAddedToStage(get, null):Bool;
	private function get_isAddedToStage():Bool {
		return bAddedToStage;
	}
	
	private function mainContainer_addedHandler( evt:Event ):Void {
		bAddedToDisplayList = true;
	}
	
	private function mainContainer_addedToStageHandler( evt:Event ):Void {
		bAddedToStage = true;
	}
	
	private function mainContainer_removedHandler( evt:Event ):Void {
		bAddedToDisplayList = false;
	}
	
	private function mainContainer_removedFromStageHandler( evt:Event ):Void {
		bAddedToStage = false;
	}
	
	private var bIsInvalidated:Bool;
	public var isInvalidated(get, null):Bool;
	private function get_isInvalidated():Bool {
		return bIsInvalidated;
	}
	
	public function render( recursive:Bool = true ):Void {
		preRenderLogic();
		renderLogic( recursive );
		postRenderLogic();
	}
	
	/**
	 * Performs any logic prior to executing actual rendering logic on the IIsoContainer.
	 */
	private function preRenderLogic():Void {
		dispatchEvent( new IsoEvent( IsoEvent.RENDER ));
	}
	
	/**
	 * Performs actual rendering logic on the IIsoContainer.
	 *
	 * @param recursive Flag indicating if child objects render upon validation.  Default value is <code>true</code>.
	 */
	private function renderLogic( recursive:Bool = true ):Void {
		if ( includeInLayoutChanged && parentNode != null ) {
			var p:IIsoContainer = cast( parentNode, IIsoContainer );
			var i:Int = Lambda.indexOf(displayListChildren, this );
			
			if ( bIncludeInLayout ) {
				if ( i == -1 )
					p.displayListChildren.push( this );
			} else if (!bIncludeInLayout) {
				if ( i >= 0 )
					p.displayListChildren.splice( i, 1 );
			}
			
			mainContainer.visible = bIncludeInLayout; //rather than removing or adding to display list, we leave it be and just leave it to the flash player to maintain
			
			includeInLayoutChanged = false;
		}
		
		if ( recursive ) {
			var child:IIsoContainer;
			for ( child in children )
				renderChild( cast(child, IIsoContainer) );
		}
	}
	
	private function postRenderLogic():Void {
		dispatchEvent( new IsoEvent( IsoEvent.RENDER_COMPLETE ));
	}
	
	private function renderChild( child:IIsoContainer ):Void {
		child.render( true );
	}
	
	private function child_changeHandler( evt:Event ):Void {
		bIsInvalidated = true;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	EVENT DISPATCHER PROXY
	////////////////////////////////////////////////////////////////////////
	override public function dispatchEvent( event:Event ):Bool {
		//so we can make use of the bubbling events via the display list
		if ( event.bubbles ) {
			return proxyTarget.dispatchEvent( new ProxyEvent( this, event ));
		} else {
			return super.dispatchEvent( event );
		}
	}
}