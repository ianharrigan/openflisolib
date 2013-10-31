package openflisolib.display.primitive;

import flash.errors.Error;
import openflisolib.core.IsoDisplayObject;
import openflisolib.error.RenderStyleType;
import openflisolib.events.IsoEvent;
import openflisolib.graphics.IFill;
import openflisolib.graphics.IStroke;
import openflisolib.graphics.SolidColorFill;
import openflisolib.graphics.Stroke;

class IsoPrimitive extends IsoDisplayObject implements IIsoPrimitive {
	static public var DEFAULT_WIDTH:Float = 25;
	static public var DEFAULT_LENGTH:Float = 25;
	static public var DEFAULT_HEIGHT:Float = 25;
	
	public function new(descriptor:Dynamic = null) {
		super(descriptor);
		fillsArray = new Array<IFill>();
		edgesArray = new Array<IStroke>();
		if (descriptor == null) {
			width = DEFAULT_WIDTH;
			length = DEFAULT_LENGTH;
			height = DEFAULT_HEIGHT;
		}
	}

	private var renderStyle:String = RenderStyleType.SOLID;
	public var styleType(get, set):String;
	private function get_styleType():String {
		return renderStyle;
	}
	private function set_styleType(value:String):String {
		if (renderStyle != value) {
			renderStyle = value;
			invalidateStyles();
			
			if (autoUpdate)
				render();
		}
		return value;
	}
	
	//////////////////////////////
	//	MATERIALS
	//////////////////////////////
	//	PROFILE STROKE
	//////////////////////////////
	private var pStroke:IStroke;
	public var profileStroke(get, set):IStroke;
	private function get_profileStroke():IStroke {
		return pStroke;
	}
	private function set_profileStroke(value:IStroke):IStroke {
		if (pStroke != value)
		{
			pStroke = value;
			invalidateStyles();
			
			if (autoUpdate)
				render();
		}
		return value;

	}
	
	//////////////////////////////
	//	MAIN FILL
	//////////////////////////////
	public var fill(get, set):IFill;
	private function get_fill():IFill {
		return fills[0];
	}
	private function set_fill(value:IFill):IFill {
		fills = [value, value, value, value, value, value];
		return value;
	}
	
	//////////////////////////////
	//	FILLS
	//////////////////////////////
	static private var DEFAULT_FILL:IFill = new SolidColorFill(0xFFFFFF, 1);
	private var fillsArray:Array<IFill>;
	public var fills(get, set):Array<IFill>;
	private function get_fills():Array<IFill> {
		var temp:Array<IFill> = [];
		var f:IFill;
		for (f in fillsArray) {
			temp.push(f);
		}
		return temp;
	}
	private function set_fills(value:Array<IFill>):Array<IFill> {
		if (value != null) {
			fillsArray = new Array<IFill>();
			for (f in value) {
				fillsArray.push(f);
			}
		} else {
			fillsArray = new Array<IFill>();
		}
		
		invalidateStyles();
		
		if (autoUpdate)
			render();
		return value;
	}
	
	//////////////////////////////
	//	MAIN STROKE
	//////////////////////////////
	public var stroke(get, set):IStroke;
	private function get_stroke():IStroke {
		return strokes[0];
	}
	private function set_stroke(value:IStroke):IStroke {
		strokes = [value, value, value, value, value, value];
		return value;
	}
	
	//////////////////////////////
	//	STROKES
	//////////////////////////////
	static private var DEFAULT_STROKE:IStroke = new Stroke(0, 0x000000);
	private var edgesArray:Array<IStroke>;
	public var strokes(get, set):Array<IStroke>;
	private function get_strokes():Array<IStroke> {
		var temp:Array<IStroke> = [];
		var s:IStroke;
		for (s in edgesArray) {
			temp.push(s);
		}
		return temp;
	}
	private function set_strokes(value:Array<IStroke>):Array<IStroke> {
		if (value != null) {
			edgesArray = new Array<IStroke>();
			for (s in value) {
				edgesArray.push(s);
			}
		} else {
			edgesArray = new Array<IStroke>();
		}
		
		invalidateStyles();
		
		if (autoUpdate)
			render();
		return value;
	}
	
	/////////////////////////////////////////////////////////
	//	RENDER
	/////////////////////////////////////////////////////////
	override private function renderLogic (recursive:Bool = true):Void {
		if (!hasParent && !renderAsOrphan)
			return;
			
		//we do this before calling super.render() so as to only perform drawing logic for the size or style invalidation, not both.
		if (bSizeInvalidated || bSytlesInvalidated)
		{
			if (!validateGeometry())
				throw new Error("validation of geometry failed.");
			
			drawGeometry();
			validateSize();
			
			bSizeInvalidated = false;
			bSytlesInvalidated = false;
		}
		
		super.renderLogic(recursive);
	}
	
	/////////////////////////////////////////////////////////
	//	VALIDATION
	/////////////////////////////////////////////////////////
	/**
	 * For IIsoDisplayObject that make use of Flash's drawing API, validation of the geometry must occur before being rendered.
	 * 
	 * @return Boolean Flag indicating if the geometry is valid.
	 */
	private function validateGeometry ():Bool
	{
		//overridden by subclasses
		return true;	
	}
	
	/**
	 * @inheritDoc
	 */
	private function drawGeometry ():Void
	{
		//overridden by subclasses
	}
	
	////////////////////////////////////////////////////////////
	//	INVALIDATION
	////////////////////////////////////////////////////////////
	private var bSytlesInvalidated:Bool = false;
	
	public function invalidateStyles ():Void {
		bSytlesInvalidated = true;
		
		if (!bInvalidateEventDispatched)
		{
			dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
			bInvalidateEventDispatched = true;
		}
	}
	
	override public function get_isInvalidated ():Bool {
		return (bSizeInvalidated || bPositionInvalidated || bSytlesInvalidated);
	}
	
	////////////////////////////////////////////////////////////
	//	CLONE
	////////////////////////////////////////////////////////////
	// TODO: not sure the best way of doing this
	override public function clone ():Dynamic {
		var cloneInstance:IIsoPrimitive = cast(super.clone(), IIsoPrimitive);
		cloneInstance.fills = fills;
		cloneInstance.strokes = strokes;
		cloneInstance.styleType = styleType;
		
		return cloneInstance;
	}
}