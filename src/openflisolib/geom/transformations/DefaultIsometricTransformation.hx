package openflisolib.geom.transformations;
import openflisolib.geom.Pt;

class DefaultIsometricTransformation implements IAxonometricTransformation {
	private var radians:Float;
	private var ratio:Float = 2;
	
	private var bAxonometricAxesProjection:Bool;
	private var bMaintainZAxisRatio:Bool;
	
	private var axialProjection:Float;
	
	public function new(projectValuesToAxonometricAxes:Bool = false, maintainZAxisRatio:Bool = false) {
		bAxonometricAxesProjection = projectValuesToAxonometricAxes;
		bMaintainZAxisRatio = maintainZAxisRatio;
		axialProjection = Math.cos(Math.atan(0.5));
	}
	
	public function screenToSpace (screenPt:Pt):Pt {
		var z:Float = screenPt.z;
		var y:Float = screenPt.y - screenPt.x / ratio + screenPt.z;
		var x:Float = screenPt.x / ratio + screenPt.y + screenPt.z;
		
		if (!bAxonometricAxesProjection && bMaintainZAxisRatio)
			z = z * axialProjection;
		
		if (bAxonometricAxesProjection)
		{
			x = x / axialProjection;
			y = y / axialProjection;
		}
		
		return new Pt(x, y, z);
	}
	
	public function spaceToScreen (spacePt:Pt):Pt {
		if (!bAxonometricAxesProjection && bMaintainZAxisRatio)
			spacePt.z = spacePt.z / axialProjection;
		
		if (bAxonometricAxesProjection)
		{
			spacePt.x = spacePt.x * axialProjection;
			spacePt.y = spacePt.y * axialProjection;
		}
		
		var z:Float = spacePt.z;
		var y:Float = (spacePt.x + spacePt.y) / ratio - spacePt.z;
		var x:Float = spacePt.x - spacePt.y;
		
		return new Pt(x, y, z);
	}
}