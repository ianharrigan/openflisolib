package openflisolib.display.scene;

import flash.display.Graphics;
import flash.errors.Error;
import openflisolib.display.primitive.IsoPrimitive;
import openflisolib.geom.IsoMath;
import openflisolib.geom.Pt;
import openflisolib.graphics.IStroke;
import openflisolib.graphics.Stroke;

class IsoGrid extends IsoPrimitive {
	private var gSize:Array<Int>;
	
	public function new(descriptor:Dynamic = null) {
		super(descriptor);
		gSize = [0, 0];
		if (descriptor == null) {
			showOrigin = true;
			gridlines = new Stroke(0, 0xCCCCCC, 0.5);
			
			cellSize = 25;
			setGridSize(5, 5);
		}
	}
	
	public var gridSize(get, null):Array<Int>;
	private function get_gridSize():Array<Int> {
		return gSize;
	}
	
	public function setGridSize (width:Int, length:Int, height:Int = 0):Void {
		if (gSize[0] != width || gSize[1] != length || gSize[2] != height) {
			gSize = [width, length, height];
			invalidateSize();
		}
	}
	
	private var cSize:Float;
	public var cellSize(get, set):Float;
	private function get_cellSize():Float {
		return cSize;
	}
	private function set_cellSize(value:Float):Float {
		if (value < 2)
			throw new Error("cellSize must be a positive value greater than 2");

		if (cSize != value) {
			cSize = value;
			invalidateSize();
		}
		return value;
	}
	
	////////////////////////////////////////////////////
	//	SHOW ORIGIN
	////////////////////////////////////////////////////
	private var _origin:IsoOrigin;
	private var bShowOrigin:Bool = false;
	private var showOriginChanged:Bool = false;
		
	public var origin(get, null):IsoOrigin;
	private function get_origin():IsoOrigin {
		if (_origin == null) {
			_origin = new IsoOrigin();
		}
		return _origin;
	}
	
	public var showOrigin(get, set):Bool;
	private function get_showOrigin():Bool {
		return bShowOrigin;
	}
	private function set_showOrigin(value:Bool):Bool {
		if (bShowOrigin != value) {
			bShowOrigin = value;
			showOriginChanged = true;
			
			invalidateSize();
		}
		return value;
	}
	
	////////////////////////////////////////////////////
	//	GRID STYLES
	////////////////////////////////////////////////////
	public var gridlines(get, set):IStroke;
	private function get_gridlines():IStroke {
		return strokes[0];
	}
	private function set_gridlines(value:IStroke):IStroke {
		strokes = [value];
		return value;
	}
	
	override private function renderLogic (recursive:Bool = true):Void {
		if (showOriginChanged) {
			if (showOrigin) {
				if (!contains(origin)) {
					addChildAt(origin, 0);
				}
			} else {
				if (contains(origin)) {
					removeChild(origin);
				}
			}
			
			showOriginChanged = false;
		}
		
		super.renderLogic(recursive);
	}
	
	override private function drawGeometry ():Void {
		var g:Graphics = mainContainer.graphics;
		g.clear();

		var stroke:IStroke = cast(strokes[0], IStroke);
		if (stroke != null)
			stroke.apply(g);
		
		var pt:Pt = new Pt();
		
		var i:Int = 0;
		var m:Int = gridSize[0];
		while (i <= m)
		{
			pt = IsoMath.isoToScreen(new Pt(cSize * i));
			g.moveTo(pt.x, pt.y);
			
			pt = IsoMath.isoToScreen(new Pt(cSize * i, cSize * gridSize[1]));
			g.lineTo(pt.x, pt.y);
			
			i++;
		}
		
		i = 0;
		m = gridSize[1];
		while (i <= m)
		{
			pt = IsoMath.isoToScreen(new Pt(0, cSize * i));
			g.moveTo(pt.x, pt.y);
			
			pt = IsoMath.isoToScreen(new Pt(cSize * gridSize[0], cSize * i));
			g.lineTo(pt.x, pt.y);
			
			i++;
		}
		
		//now add the invisible layer to receive mouse events
		pt = IsoMath.isoToScreen(new Pt(0, 0));
		g.moveTo(pt.x, pt.y);
		g.lineStyle(0, 0, 0);
		g.beginFill(0xFF0000, 0.0);
		
		pt = IsoMath.isoToScreen(new Pt(cSize * gridSize[0], 0));
		g.lineTo(pt.x, pt.y);
		
		pt = IsoMath.isoToScreen(new Pt(cSize * gridSize[0], cSize * gridSize[1]));
		g.lineTo(pt.x, pt.y);
		
		pt = IsoMath.isoToScreen(new Pt(0, cSize * gridSize[1]));
		g.lineTo(pt.x, pt.y);
		
		pt = IsoMath.isoToScreen(new Pt(0, 0));
		g.lineTo(pt.x, pt.y);
		g.endFill();
	}
}