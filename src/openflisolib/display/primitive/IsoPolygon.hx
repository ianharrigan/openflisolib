package openflisolib.display.primitive;
import flash.display.Graphics;
import openflisolib.error.RenderStyleType;
import openflisolib.geom.Pt;
import openflisolib.graphics.IFill;
import openflisolib.graphics.IStroke;

class IsoPolygon extends IsoPrimitive {
	public function new(descriptor:Dynamic = null) {
		super(descriptor);
		geometryPts = [];
	}
	
	override private function validateGeometry ():Bool {
		return pts.length > 2;
	}
	
	override private function drawGeometry ():Void {
		var g:Graphics = mainContainer.graphics;
		g.clear();
		g.moveTo(pts[0].x, pts[0].y);
		
		var fill:IFill = cast(fills[0], IFill);
		if (fill != null && styleType != RenderStyleType.WIREFRAME)
			fill.begin(g);
		
		var stroke:IStroke = strokes.length >= 1 ? cast(strokes[0], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (stroke != null)
			stroke.apply(g);
		
		var i:Int = 1;
		var l:Int = pts.length;
		while (i < l)
		{
			g.lineTo(pts[i].x, pts[i].y);
			i++;
		}
			
		g.lineTo(pts[0].x, pts[0].y);
		
		if (fill != null)
			fill.end(g);
	}
	
	private var geometryPts:Array<Pt>;
	public var pts(get, set):Array<Pt>;
	private function get_pts():Array<Pt> {
		return geometryPts;
	}
	private function set_pts(value:Array<Pt>):Array<Pt> {
		if (geometryPts != value) {
			geometryPts = value;
			invalidateSize();
			
			if (autoUpdate)
				render();
		}
		return value;
	}
}