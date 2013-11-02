package openflisolib.display.scene;

import flash.display.Graphics;
import openflisolib.display.primitive.IsoPrimitive;
import openflisolib.enums.IsoOrientation;
import openflisolib.geom.IsoMath;
import openflisolib.geom.Pt;
import openflisolib.graphics.IFill;
import openflisolib.graphics.IStroke;
import openflisolib.graphics.SolidColorFill;
import openflisolib.graphics.Stroke;
import openflisolib.utils.IsoDrawingUtil;

class IsoOrigin extends IsoPrimitive {
	/**
	 * The length of each axis (not including the arrows).
	 */
	public var axisLength:Float = 100;
	
	/**
	 * The arrow length for each arrow found on each axis.
	 */
	public var arrowLength:Float = 20;
	
	/**
	 * The arrow width for each arrow found on each axis. 
	 * This is the total width of the arrow at the base.
	 */
	public var arrowWidth:Float = 3;
	
	public function new(descriptor:Dynamic = null) {
		super(descriptor);
		
		if (descriptor == null || Reflect.hasField(descriptor, "strokes") == false) {
			strokes = [
				new Stroke(0, 0xFF0000, 0.75),
				new Stroke(0, 0x00FF00, 0.75),
				new Stroke(0, 0x0000FF, 0.75)
			];
		}
		
		if (descriptor == null || Reflect.hasField(descriptor, "fills") == false) {
			fills =	[
				new SolidColorFill(0xFF0000, 0.75),
				new SolidColorFill(0x00FF00, 0.75),
				new SolidColorFill(0x0000FF, 0.75)
			];
		}
	}

	override private function drawGeometry ():Void {
		var pt0:Pt = IsoMath.isoToScreen(new Pt(-1 * axisLength, 0, 0));
		var ptM:Pt;
		var pt1:Pt = IsoMath.isoToScreen(new Pt(axisLength, 0, 0));
		
		var g:Graphics = mainContainer.graphics;
		g.clear();
		
		//draw x-axis
		var stroke:IStroke = cast(strokes[0], IStroke);
		var fill:IFill = cast(fills[0], IFill);
		
		stroke.apply(g);
		g.moveTo(pt0.x, pt0.y);
		g.lineTo(pt1.x, pt1.y);
		
		g.lineStyle(0, 0, 0);
		g.moveTo(pt0.x, pt0.y);
		fill.begin(g);
		IsoDrawingUtil.drawIsoArrow(g, new Pt(-1 * axisLength, 0), 180, arrowLength, arrowWidth);
		fill.end(g);
		
		g.moveTo(pt1.x, pt1.y);
		fill.begin(g);
		IsoDrawingUtil.drawIsoArrow(g, new Pt(axisLength, 0), 0, arrowLength, arrowWidth);
		fill.end(g);
		
		//draw y-axis
		stroke = cast(strokes[1], IStroke);
		fill = cast(fills[1], IFill);
		
		pt0 = IsoMath.isoToScreen(new Pt(0, -1 * axisLength, 0));
		pt1 = IsoMath.isoToScreen(new Pt(0, axisLength, 0));
		
		stroke.apply(g);
		g.moveTo(pt0.x, pt0.y);
		g.lineTo(pt1.x, pt1.y);
		
		g.lineStyle(0, 0, 0);
		g.moveTo(pt0.x, pt0.y);
		fill.begin(g);
		IsoDrawingUtil.drawIsoArrow(g, new Pt(0, -1 * axisLength), 270, arrowLength, arrowWidth);
		fill.end(g);
		
		g.moveTo(pt1.x, pt1.y);
		fill.begin(g);
		IsoDrawingUtil.drawIsoArrow(g, new Pt(0, axisLength), 90, arrowLength, arrowWidth);
		fill.end(g);
		
		//draw z-axis
		stroke = cast(strokes[2], IStroke);
		fill = cast(fills[2], IFill);
		
		pt0 = IsoMath.isoToScreen(new Pt(0, 0, -1 * axisLength));
		pt1 = IsoMath.isoToScreen(new Pt(0, 0, axisLength));
		
		stroke.apply(g);
		g.moveTo(pt0.x, pt0.y);
		g.lineTo(pt1.x, pt1.y);

		g.lineStyle(0, 0, 0);
		g.moveTo(pt0.x, pt0.y);
		fill.begin(g);
		IsoDrawingUtil.drawIsoArrow(g, new Pt(0, 0, axisLength), 90, arrowLength, arrowWidth, IsoOrientation.XZ);
		fill.end(g);
		
		g.moveTo(pt1.x, pt1.y);
		fill.begin(g);
		IsoDrawingUtil.drawIsoArrow(g, new Pt(0, 0, -1 * axisLength), 270, arrowLength, arrowWidth, IsoOrientation.YZ);
		fill.end(g);
	}
	
	override public function set_width (value:Float):Float {
		super.width = 0;
		return value;
	}
	
	override public function set_length (value:Float):Float {
		super.length = 0;
		return value;
	}
	
	override public function set_height (value:Float):Float {
		super.height = 0;
		return value;
	}
}