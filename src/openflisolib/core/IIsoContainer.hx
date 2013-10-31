package openflisolib.core;

import flash.display.Sprite;
import openflisolib.data.INode;

interface IIsoContainer extends INode extends IInvalidation {
	var includeInLayout (get, set):Bool;
	var displayListChildren (get, null):Array<IIsoContainer>;
	var depth (get, null):Int;
	var container (get, null):Sprite;
	function render (recursive:Bool = true):Void;
}
