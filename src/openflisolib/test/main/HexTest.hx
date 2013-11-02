package openflisolib.test.main;

import openflisolib.display.primitive.IsoHexBox;
import openflisolib.display.scene.IsoScene;
import openflisolib.graphics.SolidColorFill;

class HexTest {
	public function new(scene:IsoScene) {
		var hbox:IsoHexBox = new IsoHexBox();
		hbox.moveTo(200, 0, -100);
		//hbox.setSize(80, 80, 80);
		hbox.fill = new SolidColorFill(0xFFFFFF, 1);
		scene.addChild(hbox);
		
		var hbox:IsoHexBox = new IsoHexBox();
		hbox.moveTo(225, 0, -100);
		//hbox.setSize(80, 80, 80);
		hbox.fill = new SolidColorFill(0xFF0000, 1);
		scene.addChild(hbox);
	}
}