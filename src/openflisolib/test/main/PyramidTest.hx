package openflisolib.test.main;

import openflisolib.display.primitive.IsoBox;
import openflisolib.display.scene.IsoScene;
import openflisolib.graphics.SolidColorFill;
import openflisolib.graphics.Stroke;

class PyramidTest {
	private var layers:Int = 10;
	private var brickSize:Int = 20;
	
	public function new(scene:IsoScene) {
		for (z in 0...layers) {
			for (x in 0...(layers - z)) {
				for (y in 0...(layers - z)) {
					scene.addChild(createBox(x + (z * .5), y + (z * .5), z));
				}
			}
		}
	}
	
	private function createBox(x:Float, y:Float, z:Float):IsoBox {
		var xoffset:Int = 350;
		var yoffset:Int = -50;
		var zoffset:Int = -50;
		var box:IsoBox = new IsoBox();
		box.setSize(brickSize, brickSize, brickSize);
		box.stroke = new Stroke(1, 0x666666);
		box.fills = [
			new SolidColorFill(0xE1D9D0, 1),
			new SolidColorFill(0xE3DBD2, 1),
			new SolidColorFill(0xFFFFFF, 1),
			new SolidColorFill(0, 1),
			new SolidColorFill(0, 1),
			new SolidColorFill(0, 1)
		];	
		box.moveTo(xoffset + (x * brickSize), yoffset + (y * brickSize), zoffset + (z * brickSize));
		return box;
	}
}