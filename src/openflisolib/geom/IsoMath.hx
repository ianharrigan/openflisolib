package openflisolib.geom;

import openflisolib.geom.transformations.DefaultIsometricTransformation;
import openflisolib.geom.transformations.IAxonometricTransformation;

class IsoMath {
	static private var transformationObj:IAxonometricTransformation = new DefaultIsometricTransformation();
	public static var transformationObject(get, set):IAxonometricTransformation;
	private static function get_transformationObject():IAxonometricTransformation {
		return transformationObj;
	}
	private static function set_transformationObject(value:IAxonometricTransformation):IAxonometricTransformation {
		if (value != null)
			transformationObj = value;
		else
			transformationObj = new DefaultIsometricTransformation();
		return value;
	}
	
	static public function screenToIso (screenPt:Pt, createNew:Bool = false):Pt {
		var isoPt:Pt = transformationObject.screenToSpace(screenPt);
		if (createNew) {
			return isoPt;
		} else {
			screenPt.x = isoPt.x;
			screenPt.y = isoPt.y;
			screenPt.z = isoPt.z;
			
			return screenPt;
		}
	}
	
	static public function isoToScreen (isoPt:Pt, createNew:Bool = false):Pt {
		var screenPt:Pt = transformationObject.spaceToScreen(isoPt);
		
		if (createNew) {
			return screenPt;
		} else {
			isoPt.x = screenPt.x;
			isoPt.y = screenPt.y;
			isoPt.z = screenPt.z;
			
			return isoPt;
		}
	}
}