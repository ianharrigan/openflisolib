package openflisolib.geom.transformations;
import openflisolib.geom.Pt;

class DimetricTransformation implements IAxonometricTransformation {
	public function new() {
		
	}

	public function screenToSpace (screenPt:Pt):Pt {
		return null;
	}
	
	public function spaceToScreen (spacePt:Pt):Pt {
		var z:Float = spacePt.z;
		var y:Float = spacePt.y / 4 - spacePt.z;
		var x:Float = spacePt.x - spacePt.y / 2;
		
		return new Pt(x, y, z);
	}
}