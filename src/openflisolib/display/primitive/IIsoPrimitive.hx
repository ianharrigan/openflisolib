package openflisolib.display.primitive;

import openflisolib.core.IIsoDisplayObject;
import openflisolib.graphics.IFill;
import openflisolib.graphics.IStroke;

interface IIsoPrimitive extends IIsoDisplayObject {
	var styleType(get, set):String;
	var fill(get, set):IFill;
	var fills(get, set):Array<IFill>;
	var stroke(get, set):IStroke;
	var strokes(get, set):Array<IStroke>;
	function invalidateStyles ():Void;	
}