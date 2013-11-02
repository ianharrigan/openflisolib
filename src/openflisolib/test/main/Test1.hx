package openflisolib.test.main;

import openflisolib.display.primitive.IsoBox;
import openflisolib.display.scene.IsoScene;
import openflisolib.graphics.SolidColorFill;
import openflisolib.graphics.Stroke;

class Test1 {
	public function new(scene:IsoScene) {
		// I
		scene.addChild(createBox(0,0,0));
		scene.addChild(createBox(0,0,1));
		scene.addChild(createBox(0,0,2));
		scene.addChild(createBox(0,0,3));
		scene.addChild(createBox(0, 0, 4));

		// S
		scene.addChild(createBox(3,0,0));
		scene.addChild(createBox(4,0,0));
		scene.addChild(createBox(5, 0, 0));

		scene.addChild(createBox(5,0,1));
		scene.addChild(createBox(5,0,2));
		scene.addChild(createBox(4,0,2));
		scene.addChild(createBox(3,0,2));

		scene.addChild(createBox(3,0,3));

		scene.addChild(createBox(3,0,4));
		scene.addChild(createBox(4,0,4));
		scene.addChild(createBox(5,0,4));

		// O
		scene.addChild(createBox(8,0,4));
		scene.addChild(createBox(9,0,4));
		scene.addChild(createBox(10,0,4));

		scene.addChild(createBox(8,0,3));
		scene.addChild(createBox(10,0,3));
		scene.addChild(createBox(8,0,2));
		scene.addChild(createBox(10,0,2));
		scene.addChild(createBox(8,0,1));
		scene.addChild(createBox(10,0,1));

		scene.addChild(createBox(8,0,0));
		scene.addChild(createBox(9,0,0));
		scene.addChild(createBox(10,0,0));
	}
	
	private function createBox(x:Int, y:Int, z:Int):IsoBox {
		var xoffset:Int = 200;
		var yoffset:Int = 0;
		var zoffset:Int = -100;
		var box:IsoBox = new IsoBox();

		box.stroke = new Stroke(1, 0x666666);
		box.fills = [
			new SolidColorFill(0xE1D9D0, 1),
			new SolidColorFill(0xE4DCD3, 1),
			new SolidColorFill(0xEAEAEA, 1),
			new SolidColorFill(0, 1),
			new SolidColorFill(0, 1),
			new SolidColorFill(0, 1)
		];	
		box.moveTo(xoffset + (x * 25), y * 25, zoffset + (z * 25));
		return box;
	}
}