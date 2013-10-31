package openflisolib.geom.transformations;
import openflisolib.geom.Pt;

class IsometricTransformation implements IAxonometricTransformation {
	private var cosTheta:Float;
	private var sinTheta:Float;
	
	public function new() {
		cosTheta = Math.cos(30 * Math.PI / 180);
		sinTheta = Math.sin(30 * Math.PI / 180);
	}
	
	//TODO jwopitz: Figure out the proper conversion - http://www.compuphase.com/axometr.htm
	
	public function screenToSpace (screenPt:Pt):Pt {
		var z:Float = screenPt.z;
		var y:Float = screenPt.y - screenPt.x / (2 * cosTheta) + screenPt.z;
		var x:Float = screenPt.x / (2 * cosTheta) + screenPt.y + screenPt.z;
		
		/* if (bAxonometricAxesProjection)
		{
			x = x / axialProjection;
			y = y / axialProjection;
		} */
		
		return new Pt(x, y, z);
	}
	
	public function spaceToScreen (spacePt:Pt):Pt {
		/* if (bAxonometricAxesProjection)
		{
			spacePt.x = spacePt.x * axialProjection;
			spacePt.y = spacePt.y * axialProjection;
		} */		
		
		var z:Float = spacePt.z;
		var y:Float = (spacePt.x + spacePt.y) * sinTheta - spacePt.z;
		var x:Float = (spacePt.x - spacePt.y) * cosTheta;
		
		return new Pt(x, y, z);
	}
}