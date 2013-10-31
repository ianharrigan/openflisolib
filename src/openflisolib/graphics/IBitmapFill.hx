package openflisolib.graphics;
import flash.geom.Matrix;

interface IBitmapFill extends IFill {
	var matrix(get, set):Matrix;
	var repeat(get, set):Bool;
}