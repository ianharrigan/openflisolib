package openflisolib.test.main;

import flash.display.BitmapData;
import flash.geom.Matrix;
import openfl.Assets;
import openflisolib.display.primitive.IsoBox;
import openflisolib.display.primitive.IsoRectangle;
import openflisolib.display.scene.IsoScene;
import openflisolib.enums.IsoOrientation;
import openflisolib.graphics.BitmapFill;
import openflisolib.graphics.SolidColorFill;
import openflisolib.graphics.Stroke;

class PyramidTest {
	private var layers:Int = 13;
	private var brickSize:Int = 20;
	private var bitmapFill:BitmapData;
	private var brickCount:Int = 0;
	private var useBitmapFill:Bool = false;
	
	public function new(scene:IsoScene) {
		if (useBitmapFill == true) {
			var bmpData:BitmapData = Assets.getBitmapData("img/stone-tile-2.jpg");
			var m:Matrix = new Matrix();
			m.scale(bmpData.width / brickSize , bmpData.height / brickSize);
			bitmapFill = new BitmapData(brickSize, brickSize);
			bitmapFill.draw(bmpData, m, null, null, null, false);
		}
		
		
		for (z in 0...layers) {
			for (x in 0...(layers - z)) {
				for (y in 0...(layers - z)) {
					scene.addChild(createBox(x + (z * .5), y + (z * .5), z));
				}
			}
		}
		
		var floor:IsoRectangle = new IsoRectangle();
		floor.setSize(340, 340, 0);
		floor.moveTo(300, -100 , -49);
		if (useBitmapFill) {
			floor.fill = new BitmapFill(Assets.getBitmapData("img/grass_tile.png"), IsoOrientation.XY);
		} else {
			floor.fill = new SolidColorFill(0x006600, 1);
		}
		scene.addChild(floor);
		
		
		trace("" + brickCount + " bricks created");
	}
	
	private function createBox(x:Float, y:Float, z:Float):IsoBox {
		var xoffset:Int = 350;
		var yoffset:Int = -50;
		var zoffset:Int = -50;
		var box:IsoBox = new IsoBox();
		box.setSize(brickSize, brickSize, brickSize);
		//box.stroke = new Stroke(.1, 0xFFCA95);
		box.stroke = new Stroke(.1, 0x333333);

		if (useBitmapFill == true) {
			box.fills = [
				new BitmapFill(bitmapFill, IsoOrientation.XY),
				new BitmapFill(bitmapFill, IsoOrientation.YZ),
				new BitmapFill(bitmapFill, IsoOrientation.XZ),
				new SolidColorFill(0, 1),
				new SolidColorFill(0, 1),
				new SolidColorFill(0, 1)
			];	
		} else {
			box.fills = [
				new SolidColorFill(0xE1D9D0, 1),
				new SolidColorFill(0xE4DCD3, 1),
				new SolidColorFill(0xFFFFFF, 1),
				new SolidColorFill(0, 1),
				new SolidColorFill(0, 1),
				new SolidColorFill(0, 1)
			];
		}
		
		box.moveTo(xoffset + (x * brickSize), yoffset + (y * brickSize), zoffset + (z * brickSize));
		brickCount++;
		return box;
	}
}