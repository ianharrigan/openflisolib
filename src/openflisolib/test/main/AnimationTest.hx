package openflisolib.test.main;

import eDpLib.events.ProxyEvent;
import flash.events.MouseEvent;
import motion.Actuate;
import motion.actuators.GenericActuator.IGenericActuator;
import openflisolib.display.primitive.IsoBox;
import openflisolib.display.primitive.IsoRectangle;
import openflisolib.display.scene.IsoGrid;
import openflisolib.display.scene.IsoScene;
import openflisolib.geom.IsoMath;
import openflisolib.geom.Pt;
import openflisolib.graphics.SolidColorFill;

class AnimationTest {
	private var _scene:IsoScene;
	private var _box:IsoBox;
	
	public function new(scene:IsoScene) {
		_scene = scene;
		
		var floor:IsoGrid = new IsoGrid();
		floor.setGridSize(340, 340, 0);
		floor.moveTo(200, -200, -100);
		//floor.fill = new SolidColorFill(0x006600, 1);
		scene.addChild(floor);
		
		_box = new IsoBox();
		_box.moveTo(200, 0, -100);
		scene.addEventListener(MouseEvent.CLICK, onClick);
		scene.addChild(_box);
	}
	
	private function onClick(event:ProxyEvent):Void {
		var mouseEvent:MouseEvent = cast(event.targetEvent, MouseEvent);
		var pt:Pt = new Pt(mouseEvent.stageX, mouseEvent.stageY);
		IsoMath.screenToIso(pt);

		Actuate.tween(_box, .5, { x: pt.x, y: pt.y, z: pt.z } ).onUpdate(function() {
			_scene.render();
		});
	}
	
}