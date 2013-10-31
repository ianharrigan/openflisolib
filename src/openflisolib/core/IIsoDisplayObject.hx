package openflisolib.core;

import flash.display.DisplayObject;
import flash.geom.Rectangle;
import openflisolib.bounds.IBounds;
import openflisolib.data.RenderData;

interface IIsoDisplayObject extends IIsoContainer {
	function getRenderData ():RenderData;
	var renderAsOrphan(get, set):Bool;
	var isoBounds(get, null):IBounds;
	var screenBounds(get, null):Rectangle;
	function getBounds (targetCoordinateSpace:DisplayObject):Rectangle;
	var inverseOriginX(get, null):Float;
	var inverseOriginY(get, null):Float;
	function moveTo (x:Float, y:Float, z:Float):Void;
	function moveBy (x:Float, y:Float, z:Float):Void;
	var isAnimated(get, set):Bool;
	var x(get, set):Float;
	var y(get, set):Float;
	var z(get, set):Float;
	var screenX(get, null):Float;
	var screenY(get, null):Float;
	var distance(get, set):Float;
	function setSize (width:Float, length:Float, height:Float):Void;
	var width(get, set):Float;
	var length(get, set):Float;
	var height(get, set):Float;
	function invalidatePosition ():Void;
	function invalidateSize ():Void;
	function clone ():Dynamic;
}