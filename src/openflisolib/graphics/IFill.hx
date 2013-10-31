package openflisolib.graphics;

import flash.display.Graphics;

interface IFill {
	function begin(target:Graphics):Void;
	function end(target:Graphics):Void;
	function clone():IFill;
}