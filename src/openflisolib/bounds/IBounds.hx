package openflisolib.bounds;

import openflisolib.geom.Pt;

interface IBounds {
	var width(get, null):Float;
	var length(get, null):Float;
	var height(get, null):Float;
	var left(get, null):Float;
	var right(get, null):Float;
	var back(get, null):Float;
	var front(get, null):Float;
	var bottom(get, null):Float;
	var top(get, null):Float;
	var centerPt(get, null):Pt;
	function getPts():Array<Pt>;
	function intersects(bounds:IBounds):Bool;
	function containsPt(target:Pt):Bool;
}