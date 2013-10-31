package openflisolib.core;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import openflisolib.bounds.IBounds;
import openflisolib.data.RenderData;
import openflisolib.events.IsoEvent;
import openflisolib.geom.IsoMath;
import openflisolib.geom.Pt;

class IsoDisplayObject extends IsoContainer implements IIsoDisplayObject {
	private var cachedRenderData:RenderData;
	
	public function new(descriptor:Dynamic = null) {
		super();
		
		if ( descriptor != null)
			createObjectFromDescriptor( descriptor );
	}
	
	private function createObjectFromDescriptor( descriptor:Dynamic ):Void {
		var prop:String;
		for (prop in Reflect.fields(descriptor)) {
			if (Reflect.hasField(this, prop)) {
				Reflect.setField(this, prop, Reflect.field(descriptor, prop));
			}
		}
	}
	
	public function getRenderData():RenderData {
		var r:Rectangle = mainContainer.getBounds( mainContainer );
		if ( isInvalidated || cachedRenderData == null) {
			var flag:Bool = bRenderAsOrphan; //set to allow for rendering regardless of hierarchy
			bRenderAsOrphan = true;

			render( true );
			
			var bd:BitmapData = new BitmapData( Std.int(r.width + 1), Std.int(r.height + 1), true, 0x000000 );
			bd.draw( mainContainer, new Matrix( 1, 0, 0, 1, -r.left, -r.top ) );
			
			var renderData:RenderData = new RenderData();
			renderData.x = mainContainer.x + r.left;
			renderData.y = mainContainer.y + r.top;
			renderData.bitmapData = bd;
			
			cachedRenderData = renderData;
			bRenderAsOrphan = flag; //set back to original
		} else {
			cachedRenderData.x = mainContainer.x + r.left;
			cachedRenderData.y = mainContainer.y + r.top;
		}
		
		return cachedRenderData;
	}
	
	private var _isAnimated:Bool = false;
	public var isAnimated(get, set):Bool;
	private function get_isAnimated():Bool {
		return _isAnimated;
	}
	private function set_isAnimated(value:Bool):Bool {
		_isAnimated = value;
		//mainContainer.cacheAsBitmap = value;
		return value;
	}
	
	private var isoBoundsObject:IBounds;
	public var isoBounds(get, null):IBounds;
	private function get_isoBounds():IBounds {
		return isoBoundsObject;
	}
	
	public var screenBounds(get, null):Rectangle;
	private function get_screenBounds():Rectangle {
		var screenBounds:Rectangle = mainContainer.getBounds( mainContainer );
		screenBounds.x += mainContainer.x;
		screenBounds.y += mainContainer.y;
		
		return screenBounds;
	}
	
	public function getBounds( targetCoordinateSpace:DisplayObject ):Rectangle {
		var rect:Rectangle = screenBounds;
		
		var pt:Point = new Point( rect.x, rect.y );
		pt = cast( parent, IIsoContainer ).container.localToGlobal( pt );
		pt = targetCoordinateSpace.globalToLocal( pt );
		
		rect.x = pt.x;
		rect.y = pt.y;
		
		return rect;
	}
	
	public var inverseOriginX(get, null):Float;
	private function get_inverseOriginX():Float {
		return IsoMath.isoToScreen( new Pt( x + width, y + length, z ) ).x;
	}
	
	public var inverseOriginY(get, null):Float;
	private function get_inverseOriginY():Float {
		return IsoMath.isoToScreen( new Pt( x + width, y + length, z ) ).y;
	}
	
	public function moveTo( x:Float, y:Float, z:Float ):Void {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public function moveBy( x:Float, y:Float, z:Float ):Void {
		this.x += x;
		this.y += y;
		this.z += z;
	}
	
	/**
	 * Flag indicating if positional and dimensional values are rounded to the nearest whole number or not.
	 */
	public var usePreciseValues:Bool = false;
	
	
	////////////////////////////////////////////////////////////////////////
	//	X
	////////////////////////////////////////////////////////////////////////
	var isoX:Float = 0;
	private var oldX:Float;
	
	public var x(get, set):Float;
	private function get_x():Float {
		return isoX;
	}
	private function set_x(value:Float):Float {
		if ( !usePreciseValues ) 
			value = Math.round( value );
		if ( isoX != value ) {
			oldX = isoX;
			
			isoX = value;
			invalidatePosition();
			
			if ( autoUpdate )
				render();
		}
		return value;
	}
	
	public var screenX(get, null):Float;
	private function get_screenX():Float {
		return IsoMath.isoToScreen( new Pt( x, y, z ) ).x;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	Y
	////////////////////////////////////////////////////////////////////////
	var isoY:Float = 0;
	private var oldY:Float;
	
	public var y(get, set):Float;
	private function get_y():Float {
		return isoY;
	}
	private function set_y(value:Float):Float {
		if ( !usePreciseValues )
			value = Math.round( value );
		if ( isoY != value ) {
			oldY = isoY;
			
			isoY = value;
			invalidatePosition();
			
			if ( autoUpdate )
				render();
		}
		return value;
	}
	
	public var screenY(get, null):Float;
	private function get_screenY():Float {
		return IsoMath.isoToScreen( new Pt( x, y, z ) ).y;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	Z
	////////////////////////////////////////////////////////////////////////
	var isoZ:Float = 0;
	private var oldZ:Float;
	
	public var z(get, set):Float;
	private function get_z():Float {
		return isoZ;
	}
	private function set_z(value:Float):Float {
		if ( !usePreciseValues )
			value = Math.round( value );
		if ( isoZ != value ) {
			oldZ = isoZ;
			
			isoZ = value;
			invalidatePosition();
			
			if ( autoUpdate )
				render();
		}
		return value;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	DIST
	////////////////////////////////////////////////////////////////////////
	private var dist:Float;
	public var distance(get, set):Float;
	private function get_distance():Float {
		return dist;
	}
	private function set_distance(value:Float):Float {
		dist = value;
		return value;
	}
	
	/////////////////////////////////////////////////////////
	//	GEOMETRY
	/////////////////////////////////////////////////////////
	public function setSize( width:Float, length:Float, height:Float ):Void {
		this.width = width;
		this.length = length;
		this.height = height;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	WIDTH
	////////////////////////////////////////////////////////////////////////
	var isoWidth:Float = 0;
	private var oldWidth:Float;
	
	public var width(get, set):Float;
	private function get_width():Float {
		return isoWidth;
	}
	private function set_width(value:Float):Float {
		if ( !usePreciseValues )
			value = Math.round( value );
		if ( isoWidth != value ) {
			oldWidth = isoWidth;
			
			isoWidth = value;
			invalidateSize();
			
			if ( autoUpdate )
				render();
		}
		return value;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	LENGTH
	////////////////////////////////////////////////////////////////////////
	var isoLength:Float = 0;
	private var oldLength:Float;
	
	public var length(get, set):Float;
	private function get_length():Float {
		return isoLength;
	}
	private function set_length(value:Float):Float {
		if ( !usePreciseValues )
			value = Math.round( value );
		if ( isoLength != value ) {
			oldLength = isoLength;
			
			isoLength = value;
			invalidateSize();
			
			if ( autoUpdate )
				render();
		}
		return value;
	}
	
	////////////////////////////////////////////////////////////////////////
	//	HEIGHT
	////////////////////////////////////////////////////////////////////////
	var isoHeight:Float = 0;
	private var oldHeight:Float;
	
	public var height(get, set):Float;
	private function get_height():Float {
		return isoHeight;
	}
	private function set_height(value:Float):Float {
		if ( !usePreciseValues )
			value = Math.round( value );
		if ( isoHeight != value ) {
			oldHeight = isoHeight;
			
			isoHeight = value;
			invalidateSize();
			
			if ( autoUpdate )
				render();
		}
		return value;
	}
	
	/////////////////////////////////////////////////////////
	//	RENDER AS ORPHAN
	/////////////////////////////////////////////////////////
	private var bRenderAsOrphan:Bool = false;
	public var renderAsOrphan(get, set):Bool;
	private function get_renderAsOrphan():Bool {
		return bRenderAsOrphan;
	}
	private function set_renderAsOrphan(value:Bool):Bool {
		bRenderAsOrphan = value;
		return value;
	}
	
	/////////////////////////////////////////////////////////
	//	RENDERING
	/////////////////////////////////////////////////////////
	public var autoUpdate:Bool = false;
	
	override private function renderLogic( recursive:Bool = true ):Void {
		if ( !hasParent && !renderAsOrphan )
			return;
		
		if ( bPositionInvalidated )	{
			validatePosition();
			bPositionInvalidated = false;
		}
		
		if ( bSizeInvalidated )	{
			validateSize();
			bSizeInvalidated = false;
		}
		
		//set the flag back for the next time we invalidate the object
		bInvalidateEventDispatched = false;
		
		super.renderLogic( recursive );
	}
	
	////////////////////////////////////////////////////////////////////////
	//	INCLUDE LAYOUT
	////////////////////////////////////////////////////////////////////////
	/* override public function set includeInLayout (value:Boolean):void
	   {
	   super.includeInLayout = value;
	   if (includeInLayoutChanged)
	   {
	   if (!bInvalidateEventDispatched)
	   {
	   dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
	   bInvalidateEventDispatched = true;
	   }
	   }
	 } */
	 
	/////////////////////////////////////////////////////////
	//	VALIDATION
	/////////////////////////////////////////////////////////
	private function validatePosition():Void {
		var pt:Pt = new Pt( x, y, z );
		IsoMath.isoToScreen( pt );
		
		mainContainer.x = pt.x;
		mainContainer.y = pt.y;
		
		var evt:IsoEvent = new IsoEvent( IsoEvent.MOVE, true );
		evt.propName = "position";
		evt.oldValue = { x:oldX, y:oldY, z:oldZ };
		evt.newValue = { x:isoX, y:isoY, z:isoZ };
		
		dispatchEvent( evt );
	}
	
	private function validateSize():Void {
		var evt:IsoEvent = new IsoEvent( IsoEvent.RESIZE, true );
		evt.propName = "size";
		evt.oldValue = { width:oldWidth, length:oldLength, height:oldHeight };
		evt.newValue = { width:isoWidth, length:isoLength, height:isoHeight };
		
		dispatchEvent( evt );
	}
	
	/////////////////////////////////////////////////////////
	//	INVALIDATION
	/////////////////////////////////////////////////////////
	var bInvalidateEventDispatched:Bool = false;
	var bPositionInvalidated:Bool = false;
	var bSizeInvalidated:Bool = false;
	
	public function invalidatePosition():Void {
		bPositionInvalidated = true;
		
		if ( !bInvalidateEventDispatched )
		{
			dispatchEvent( new IsoEvent( IsoEvent.INVALIDATE ) );
			bInvalidateEventDispatched = true;
		}
	}
	
	public function invalidateSize():Void {
		bSizeInvalidated = true;
		
		if ( !bInvalidateEventDispatched )	{
			dispatchEvent( new IsoEvent( IsoEvent.INVALIDATE ) );
			bInvalidateEventDispatched = true;
		}
	}
	
	override public function get_isInvalidated():Bool {
		return ( bPositionInvalidated || bSizeInvalidated );
	}
	
	override private function createChildren():Void {
		super.createChildren();
		
		mainContainer.cacheAsBitmap = _isAnimated;
	}
	
	/////////////////////////////////////////////////////////
	//	CLONE
	/////////////////////////////////////////////////////////
	// TODO: not sure the best way of doing this
	public function clone():Dynamic {
		var cloneClass:Class<Dynamic> = Type.getClass(this);
		var cloneInstance:IIsoDisplayObject = cast(Type.createInstance(cloneClass, []), IIsoDisplayObject);
		cloneInstance.setSize( isoWidth, isoLength, isoHeight );
		return cloneInstance;
		/* ORIGINAL AS2 CODE
		var CloneClass:Class = getDefinitionByName( getQualifiedClassName( this ) ) as Class;
		
		var cloneInstance:IIsoDisplayObject = new CloneClass();
		cloneInstance.setSize( isoWidth, isoLength, isoHeight );
		
		return cloneInstance;
		*/
		
		return null;
	}
}