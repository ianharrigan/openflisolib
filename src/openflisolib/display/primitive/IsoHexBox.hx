package openflisolib.display.primitive;
import flash.display.Graphics;
import flash.geom.Matrix;
import openflisolib.enums.IsoOrientation;
import openflisolib.geom.IsoMath;
import openflisolib.geom.Pt;
import openflisolib.graphics.BitmapFill;
import openflisolib.graphics.IFill;
import openflisolib.graphics.IStroke;

class IsoHexBox extends IsoPrimitive {
	static private var sin60:Float = Math.sin(Math.PI / 3);
	static private var cos60:Float = Math.cos(Math.PI / 3);
	
	public function new(descriptor:Dynamic = null) {
		super(descriptor);
	}
	
	private var diameter:Float;
	override public function set_width (value:Float):Float {
		diameter = value;
		
		var sideLength:Float = value / 2;
		isoLength = 2 * sin60 * sideLength;
					
		super.width = value;
		return value;
	}
	
	override public function set_length (value:Float):Float {
		var sideLength:Float = value / 2 * sin60;
		isoWidth = diameter = 2 * sideLength;
		
		super.length = value;
		return value;
	}
	
	override private function drawGeometry ():Void {
		//calculate pts	
		var sideLength:Float = diameter / 2;
		
		var ptb0:Pt = new Pt(sideLength / 2, 0, 0);
		var ptb1:Pt = Pt.polar(ptb0, sideLength, 0);
		var ptb2:Pt = Pt.polar(ptb1, sideLength, Math.PI / 3);
		var ptb3:Pt = Pt.polar(ptb2, sideLength, 2 * Math.PI / 3);
		var ptb4:Pt = Pt.polar(ptb3, sideLength, Math.PI);
		var ptb5:Pt = Pt.polar(ptb4, sideLength, 4 * Math.PI / 3);
		
		var ptt0:Pt = new Pt(sideLength / 2, 0, height);
		var ptt1:Pt = Pt.polar(ptt0, sideLength, 0);
		var ptt2:Pt = Pt.polar(ptt1, sideLength, Math.PI / 3);
		var ptt3:Pt = Pt.polar(ptt2, sideLength, 2 * Math.PI / 3);
		var ptt4:Pt = Pt.polar(ptt3, sideLength, Math.PI);
		var ptt5:Pt = Pt.polar(ptt4, sideLength, 4 * Math.PI / 3);

		var pt:Pt;
		var pts:Array<Pt> = [ptb0, ptb1, ptb2, ptb3, ptb4, ptb5, ptt0, ptt1, ptt2, ptt3, ptt4, ptt5];
		for (pt in pts)
			IsoMath.isoToScreen(pt);
		
		//draw bottom hex face
		var g:Graphics = mainContainer.graphics;
		g.clear();
		
		var s:IStroke = strokes.length >= 8 ? cast(strokes[7], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (s != null)
			s.apply(g);

		var f:IFill = fills.length >= 8 ? cast(fills[7], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (f != null)
		{
			if (Std.is(f, BitmapFill))
				cast(f, BitmapFill).orientation = IsoOrientation.XY;
			
			f.begin(g);
		}
		
		g.moveTo(ptb0.x, ptb0.y);
		g.lineTo(ptb1.x, ptb1.y);
		g.lineTo(ptb2.x, ptb2.y);
		g.lineTo(ptb3.x, ptb3.y);
		g.lineTo(ptb4.x, ptb4.y);
		g.lineTo(ptb5.x, ptb5.y);
		g.lineTo(ptb0.x, ptb0.y);
		
		s = null;
		
		if (f != null)
			f.end(g);
		
		//draw side faces, orienting fills to face planes
		//face #4
		s = strokes.length >= 5 ? cast(strokes[4], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (s != null)
			s.apply(g);
		
		f = fills.length >= 5 ? cast(fills[4], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (f != null)
		{
			if (Std.is(f, BitmapFill))
			{
				var m:Matrix = new Matrix();
				m.b = Math.tan(Pt.theta(ptb4, ptb5));
				
				cast(f, BitmapFill).orientation = m;
			}
			
			f.begin(g);
		}
		
		g.moveTo(ptb4.x, ptb4.y);
		g.lineTo(ptb5.x, ptb5.y);
		g.lineTo(ptt5.x, ptt5.y);
		g.lineTo(ptt4.x, ptt4.y);
		g.lineTo(ptb4.x, ptb4.y);
		
		s = null;
		
		if (f != null)
			f.end(g);
		
		//face #5
		s = strokes.length >= 6 ? cast(strokes[5], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (s != null)
			s.apply(g);
		
		f = fills.length >= 6 ? cast(fills[5], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (f != null)
		{
			if (Std.is(f, BitmapFill))
			{
				var m:Matrix = new Matrix();
				m.b = Math.tan(Pt.theta(ptb5, ptb0));
				
				cast(f, BitmapFill).orientation = m;
			}
			
			f.begin(g);
		}
		
		g.moveTo(ptb0.x, ptb0.y);
		g.lineTo(ptb5.x, ptb5.y);
		g.lineTo(ptt5.x, ptt5.y);
		g.lineTo(ptt0.x, ptt0.y);
		g.lineTo(ptb0.x, ptb0.y);
		
		s = null;
		
		if (f != null)
			f.end(g);
		
		//face #6
		s = strokes.length >= 7 ? cast(strokes[6], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (s != null)
			s.apply(g);
		
		f = fills.length >= 7 ? cast(fills[6], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (f != null)
		{
			f.end(g);
			
			if (Std.is(f, BitmapFill))
				cast(f, BitmapFill).orientation = IsoOrientation.XZ;
			
			f.begin(g);
		}
		
		g.moveTo(ptb0.x, ptb0.y);
		g.lineTo(ptb1.x, ptb1.y);
		g.lineTo(ptt1.x, ptt1.y);
		g.lineTo(ptt0.x, ptt0.y);
		g.lineTo(ptb0.x, ptb0.y);
		
		s = null;
		
		if (f != null)
			f.end(g);
			
		//face #1
		s = strokes.length >= 2 ? cast(strokes[1], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (s != null)
			s.apply(g);
		
		f = fills.length >= 2 ? cast(fills[1], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (f != null)
		{				
			if (Std.is(f, BitmapFill))
			{
				var m:Matrix = new Matrix();
				m.b = Math.tan(Pt.theta(ptb2, ptb1));
				
				cast(f, BitmapFill).orientation = m;
			}
			
			f.begin(g);
		}
		
		g.moveTo(ptb1.x, ptb1.y);
		g.lineTo(ptb2.x, ptb2.y);
		g.lineTo(ptt2.x, ptt2.y);
		g.lineTo(ptt1.x, ptt1.y);
		g.lineTo(ptb1.x, ptb1.y);
		
		s = null;
		
		if (f != null)
			f.end(g);
			
		//face #2
		s = strokes.length >= 3 ? cast(strokes[2], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (s != null)
			s.apply(g);
		
		f = fills.length >= 3 ? cast(fills[2], IFill) : IsoPrimitive.DEFAULT_FILL;
		f = cast(fills[2], IFill);
		if (f != null)
		{
			if (Std.is(f, BitmapFill))
			{
				var m:Matrix = new Matrix();
				m.b = Math.tan(Pt.theta(ptb3, ptb2));
				
				cast(f, BitmapFill).orientation = m;
			}
			
			f.begin(g);
		}
		
		g.moveTo(ptb2.x, ptb2.y);
		g.lineTo(ptb3.x, ptb3.y);
		g.lineTo(ptt3.x, ptt3.y);
		g.lineTo(ptt2.x, ptt2.y);
		g.lineTo(ptb2.x, ptb2.y);
		
		s = null;
		
		if (f != null)
			f.end(g);
			
		//face #3
		s = strokes.length >= 4 ? cast(strokes[3], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (s != null)
			s.apply(g);
		
		f = fills.length >= 4 ? cast(fills[3], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (f != null)
		{
			if (Std.is(f, BitmapFill))
				cast(f, BitmapFill).orientation = IsoOrientation.XZ;
			
			f.begin(g);
		}
		
		g.moveTo(ptb3.x, ptb3.y);
		g.lineTo(ptb4.x, ptb4.y);
		g.lineTo(ptt4.x, ptt4.y);
		g.lineTo(ptt3.x, ptt3.y);
		g.lineTo(ptb3.x, ptb3.y);
		
		s = null;
		
		if (f != null)
			f.end(g);
		
		//top hex
		s = strokes.length >= 1 ? cast(strokes[0], IStroke) : IsoPrimitive.DEFAULT_STROKE;
		if (s != null)
			s.apply(g);
		
		f = fills.length >= 1 ? cast(fills[0], IFill) : IsoPrimitive.DEFAULT_FILL;
		if (f != null)
		{
			if (Std.is(f, BitmapFill))
				cast(f, BitmapFill).orientation = IsoOrientation.XY;
			
			f.begin(g);
		}

		g.moveTo(ptt0.x, ptt0.y);
		g.lineTo(ptt1.x, ptt1.y);
		g.lineTo(ptt2.x, ptt2.y);
		g.lineTo(ptt3.x, ptt3.y);
		g.lineTo(ptt4.x, ptt4.y);
		g.lineTo(ptt5.x, ptt5.y);
		g.lineTo(ptt0.x, ptt0.y);
		
		s = null;
		
		if (f != null)
			f.end(g);
	}
	
}