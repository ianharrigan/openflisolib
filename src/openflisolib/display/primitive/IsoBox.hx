package openflisolib.display.primitive;

import flash.display.Graphics;
import flash.geom.Matrix;
import openflisolib.error.RenderStyleType;
import openflisolib.geom.IsoMath;
import openflisolib.geom.Pt;
import openflisolib.graphics.IBitmapFill;
import openflisolib.graphics.IFill;
import openflisolib.graphics.IStroke;

class IsoBox extends IsoPrimitive {
	public function new(descriptor:Dynamic = null) {
		super(descriptor);
	}
	
	/*
	 TODO: is this really needed??
	override private function set_stroke(value:IStroke):IStroke {
		strokes = [value, value, value, value, value, value];
		return value;
	}
	*/
	
	override private function validateGeometry ():Bool {
		return (width <= 0 && length <= 0 && height <= 0) ? false : true;
	}
	
	override private function drawGeometry ():Void {
		var g:Graphics = mainContainer.graphics;
		g.clear();
		
		//all pts are named in following order "x", "y", "z" via rfb = right, front, bottom
		var lbb:Pt = IsoMath.isoToScreen(new Pt(0, 0, 0));
		var rbb:Pt = IsoMath.isoToScreen(new Pt(width, 0, 0));
		var rfb:Pt = IsoMath.isoToScreen(new Pt(width, length, 0));
		var lfb:Pt = IsoMath.isoToScreen(new Pt(0, length, 0));
		
		var lbt:Pt = IsoMath.isoToScreen(new Pt(0, 0, height));
		var rbt:Pt = IsoMath.isoToScreen(new Pt(width, 0, height));
		var rft:Pt = IsoMath.isoToScreen(new Pt(width, length, height));
		var lft:Pt = IsoMath.isoToScreen(new Pt(0, length, height));

		//bottom face
		g.moveTo(lbb.x, lbb.y);
		var fill:IFill = fills.length >= 6 ? cast(fills[5], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (fill != null && styleType != RenderStyleType.WIREFRAME)
			fill.begin(g);
		
		var stroke:IStroke = strokes.length >= 6 ? cast(strokes[5], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (stroke != null)
			stroke.apply(g);
			
		g.lineTo(rbb.x, rbb.y);
		g.lineTo(rfb.x, rfb.y);
		g.lineTo(lfb.x, lfb.y);
		g.lineTo(lbb.x, lbb.y);
		
		if (fill != null)
			fill.end(g);
			
		//back-left face
		g.moveTo(lbb.x, lbb.y);
		fill = fills.length >= 5 ? cast(fills[4], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (fill != null && styleType != RenderStyleType.WIREFRAME)
			fill.begin(g);
		
		stroke = strokes.length >= 5 ? cast(strokes[4], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (stroke != null)
			stroke.apply(g);
			
		g.lineTo(lfb.x, lfb.y);
		g.lineTo(lft.x, lft.y);
		g.lineTo(lbt.x, lbt.y);
		g.lineTo(lbb.x, lbb.y);
		
		if (fill != null)
			fill.end(g);
			
		//back-right face
		g.moveTo(lbb.x, lbb.y);
		fill = fills.length >= 4 ? cast(fills[3], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (fill != null && styleType != RenderStyleType.WIREFRAME)
			fill.begin(g);
		
		stroke = strokes.length >= 4 ? cast(strokes[3], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (stroke != null)
			stroke.apply(g);
			
		g.lineTo(rbb.x, rbb.y);
		g.lineTo(rbt.x, rbt.y);
		g.lineTo(lbt.x, lbt.y);
		g.lineTo(lbb.x, lbb.y);
		
		if (fill != null)
			fill.end(g);

			//front-left face
		g.moveTo(lfb.x, lfb.y);
		fill = fills.length >= 3 ? cast(fills[2], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (fill != null && styleType != RenderStyleType.WIREFRAME)
		{
			if (Std.is(fill, IBitmapFill))
			{
				var m:Matrix = cast(fill, IBitmapFill).matrix != null ? cast(fill, IBitmapFill).matrix : new Matrix();
				m.tx += lfb.x;
				m.ty += lfb.y;
				
				if (!cast(fill, IBitmapFill).repeat)
				{
					//calculate how to stretch fill for face
					//this is not great OOP, sorry folks!
					
					
				}
				
				cast(fill, IBitmapFill).matrix = m;
			}
			
			fill.begin(g);
		}
		
		stroke = strokes.length >= 3 ? cast(strokes[2], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (stroke != null)
			stroke.apply(g);
			
		g.lineTo(lft.x, lft.y);
		g.lineTo(rft.x, rft.y);
		g.lineTo(rfb.x, rfb.y);
		g.lineTo(lfb.x, lfb.y);
		
		if (fill != null)
			fill.end(g);
			
		//front-right face
		g.moveTo(rbb.x, rbb.y);
		fill = fills.length >= 2 ? cast(fills[1], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (fill != null && styleType != RenderStyleType.WIREFRAME)
		{
			if (Std.is(fill, IBitmapFill))
			{
				var m:Matrix = cast(fill, IBitmapFill).matrix != null ? cast(fill, IBitmapFill).matrix : new Matrix();
				m.tx += lfb.x;
				m.ty += lfb.y;
				
				if (!cast(fill, IBitmapFill).repeat)
				{
					//calculate how to stretch fill for face
					//this is not great OOP, sorry folks!
					
					
				}
				
				cast(fill, IBitmapFill).matrix = m;
			}
			
			fill.begin(g);
		}
		
		stroke = strokes.length >= 2 ? cast(strokes[1], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (stroke != null)
			stroke.apply(g);
			
		g.lineTo(rfb.x, rfb.y);
		g.lineTo(rft.x, rft.y);
		g.lineTo(rbt.x, rbt.y);
		g.lineTo(rbb.x, rbb.y);
		
		if (fill != null)
			fill.end(g);
			
		//top face
		g.moveTo(lbt.x, lbt.y);
		fill = fills.length >= 1 ? cast(fills[0], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (fill != null && styleType != RenderStyleType.WIREFRAME)
		{
			if (Std.is(fill, IBitmapFill))
			{
				var m:Matrix = cast(fill, IBitmapFill).matrix != null ? cast(fill, IBitmapFill).matrix : new Matrix();
				m.tx += lbt.x;
				m.ty += lbt.y;
				
				if (!cast(fill, IBitmapFill).repeat)
				{
					
				}
				
				cast(fill, IBitmapFill).matrix = m;
			}
			
			fill.begin(g);
		}
		
		stroke = strokes.length >= 1 ? cast(strokes[0], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (stroke != null)
			stroke.apply(g);
			
		g.lineTo(rbt.x, rbt.y);
		g.lineTo(rft.x, rft.y);
		g.lineTo(lft.x, lft.y);
		g.lineTo(lbt.x, lbt.y);
		
		if (fill != null)
			fill.end(g);
	}
}