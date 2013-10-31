package openflisolib.graphics;
import flash.display.Graphics;
import flash.display.LineScaleMode;

class Stroke implements IStroke {
	/**
	 * The line weight, in pixels.
	 */
	public var weight:Float;
	
	/**
	 * The line color.
	 */
	public var color:Int;
	
	/**
	 * The transparency of the line.
	 */
	public var alpha:Float;
	
	/**
	 * Specifies whether to hint strokes to full pixels.
	 */
	public var usePixelHinting:Bool;
	
	/**
	 * Specifies how to scale a stroke.
	 */
	public var scaleMode:String;
	
	/**
	 * Specifies the type of caps at the end of lines.
	 */
	public var caps:String;
	
	/**
	 * Specifies the type of joint appearance used at angles.
	 */
	public var joints:String;
	
	/**
	 * Indicates the limit at which a miter is cut off.
	 */
	public var miterLimit:Float;
	
	public function new(weight:Float,
						color:Int,
						alpha:Float = 1,
						usePixelHinting:Bool = false,
						scaleMode:String = "normal",
						caps:String = null,
						joints:String = null,
						miterLimit:Float = 0) {
		this.weight = weight;
		this.color = color;
		this.alpha = alpha;
		
		this.usePixelHinting = usePixelHinting;
		
		this.scaleMode = scaleMode;
		this.caps = caps;
		this.joints = joints;
		this.miterLimit = miterLimit;
	}
	
	// TODO: need to change values to use calss instance values
	public function apply (target:Graphics):Void {
		target.lineStyle(weight, color, alpha, usePixelHinting, LineScaleMode.NORMAL, null, null, 0);
	}
}