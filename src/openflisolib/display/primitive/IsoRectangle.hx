package openflisolib.display.primitive;
import openflisolib.geom.IsoMath;
import openflisolib.geom.Pt;

class IsoRectangle extends IsoPolygon {
	public function new(descriptor:Dynamic = null) {
		super(descriptor);
		
		if (descriptor == null) {
			width = length = height = 0;
		}
	}
	
	override private function validateGeometry ():Bool {
		pts = [];
		pts.push(new Pt(0, 0, 0));
		
		if (width > 0 && length > 0 && height <= 0) {
			pts.push(new Pt(width, 0, 0));
			pts.push(new Pt(width, length, 0));
			pts.push(new Pt(0, length, 0));
		} else if (width > 0 && length <= 0 && height > 0) {
			pts.push(new Pt(width, 0, 0));
			pts.push(new Pt(width, 0, height));
			pts.push(new Pt(0, 0, height));
		} else if (width <= 0 && length > 0 && height > 0) {
			pts.push(new Pt(0, length, 0));
			pts.push(new Pt(0, length, height));
			pts.push(new Pt(0, 0, height));
		} else {
			return false;
		}
		
		var pt:Pt;
		for (pt in pts)
			IsoMath.isoToScreen(pt);
			
		return true;
	}
	
	override private function drawGeometry ():Void {
		super.drawGeometry();

		//clean up
		geometryPts = [];
	}
	
}