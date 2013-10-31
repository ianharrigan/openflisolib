package openflisolib.test.main;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import openflisolib.display.scene.IsoScene;

class Main extends Sprite  {
	var inited:Bool;

	function resize(e) {
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() {
		if (inited) return;
		inited = true;
		
		var scene:IsoScene = new IsoScene();
		scene.hostContainer = this;

		// add stuff
		new Test1(scene);
		
		scene.render();
	}

	public function new() {
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) {
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() {
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
