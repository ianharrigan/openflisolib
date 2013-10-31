package openflisolib.geom.transformations;

import openflisolib.geom.Pt;

interface IAxonometricTransformation {
	function screenToSpace (screenPt:Pt):Pt;
	function spaceToScreen (spacePt:Pt):Pt;
}