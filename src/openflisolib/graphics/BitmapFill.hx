package openflisolib.graphics;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.errors.Error;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import openflisolib.enums.IsoOrientation;
import openflisolib.utils.IsoDrawingUtil;

class BitmapFill implements IBitmapFill {
	private var bitmapData:BitmapData;
	private var sourceObject:Dynamic;

	/**
	 * Constructor
	 * 
	 * @param source The target that serves as the context for the fill. Any assignment to a BitmapData, DisplayObject, Class, and String (as a fully qualified class path) are valid.
	 * @param orientation The expect orientation of the fill.  Valid values relate to the IsoOrientation constants.
	 * @param matrix A user defined matrix for custom transformations.
	 * @param colorTransform Used to assign additional custom color transformations to the fill.
	 * @param repeat Flag indicating whether to repeat the fill.  If this is false, then the fill will be stretched.
	 * @param smooth Flag indicating whether to smooth the fill.
	 */

	public function new(source:Dynamic, orientation:Dynamic = null, matrix:Matrix = null, colorTransform:ColorTransform = null, repeat:Bool = true, smooth:Bool = false) {
		this.source = source;
		this.orientation = orientation;
		
		if (matrix != null)
			this.matrix = matrix;
		
		this.colorTransform = colorTransform;
		this.repeat = repeat;
		this.smooth = smooth;
	}
	
	public var source(get, set):Dynamic;
	private function get_source():Dynamic {
		return sourceObject;
	}
	private function set_source(value:Dynamic):Dynamic {
		sourceObject = value;
		
		if (bitmapData != null) {
			bitmapData.dispose();
			bitmapData = null;
		}
		
		var tempSprite:DisplayObject = null;
		if (Std.is(value, BitmapData)) {
			bitmapData = cast(value, BitmapData);
			return value;
		}
		
		// TODO: check this works
		if (Std.is(value, Class)) {
			var classInstance:Class<Dynamic> = cast(value, Class<Dynamic>);
			var superClass:Class<Dynamic> = Type.getSuperClass(classInstance);
			if (Std.is(superClass, BitmapData)) {
				bitmapData = Type.createInstance(classInstance, [1, 1]);
				return value;
			} else {
				tempSprite = Type.createInstance(classInstance, []);
			}
		} else if (Std.is(value, Bitmap)) {
			bitmapData = cast(value, Bitmap).bitmapData;
		} else if (Std.is(value, DisplayObject)) {
			tempSprite = cast(value, DisplayObject);
		} else if (Std.is(value, String)) {
			var classInstance:Class<Dynamic> = Type.resolveClass(cast(value, String));
			if (classInstance != null) {
				tempSprite = Type.createInstance(classInstance, []);
			}
		} else {
			return value;
		}
		
		if (bitmapData == null && tempSprite != null) {
			if (tempSprite.width > 0 && tempSprite.height > 0) {
				bitmapData = new BitmapData(Std.int(tempSprite.width), Std.int(tempSprite.height));
				bitmapData.draw(tempSprite, new Matrix(), cTransform);
			}
		}
		
		return value;
	}
	
	private var _orientationMatrix:Matrix;
	private var _orientation:Dynamic;
	public var orientation(get, set):Dynamic;
	private function get_orientation():Dynamic {
		return _orientation;
	}
	private function set_orientation(value:Dynamic):Dynamic {
		_orientation = value;
		if (value == null) {
			return value;
		}
		
		if (Std.is(value, String)) {
			var temp:String = cast(value, String);
			if (temp == IsoOrientation.XY || temp == IsoOrientation.XZ || temp == IsoOrientation.YZ) {
				_orientationMatrix = IsoDrawingUtil.getIsoMatrix(temp);
			} else {
				_orientationMatrix = null;
			}
		} else if (Std.is(value, Matrix)) {
			_orientationMatrix = cast(value, Matrix);
		} else {
			throw new Error("value is not of type String or Matrix");
		}
		
		return value;
	}
	
	private var cTransform:ColorTransform;
	public var colorTransform(get, set):ColorTransform;
	private function get_colorTransform():ColorTransform {
		return cTransform;
	}
	private function set_colorTransform(value:ColorTransform):ColorTransform {
		cTransform = value;
		if (bitmapData != null && cTransform != null) {
			bitmapData.colorTransform(bitmapData.rect, cTransform);
		}
		return cTransform;
	}
	
	private var matrixObject:Matrix;
	public var matrix(get, set):Matrix;
	private function get_matrix():Matrix {
		return matrixObject;
	}
	private function set_matrix(value:Matrix):Matrix {
		matrixObject = value;
		return value;
	}
	
	private var bRepeat:Bool;
	public var repeat(get, set):Bool;
	private function get_repeat():Bool {
		return bRepeat;
	}
	private function set_repeat(value:Bool):Bool {
		bRepeat = value;
		return value;
	}
	
	public var smooth:Bool;
	
	///////////////////////////////////////////////////////////
	//	IFILL
	///////////////////////////////////////////////////////////
	public function begin (target:Graphics):Void {
		var m:Matrix = new Matrix();
		if (_orientationMatrix != null)
			m.concat(_orientationMatrix);
			
		if (matrix != null)
			m.concat(matrix);
		
		target.beginBitmapFill(bitmapData, m, repeat, smooth);
	}
	
	public function end (target:Graphics):Void {
		target.endFill();
	}
	
	public function clone ():IFill {
		return new BitmapFill(source, orientation, matrix, colorTransform, repeat, smooth);
	}
}