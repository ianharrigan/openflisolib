package openflisolib.bounds;
import openflisolib.core.IIsoDisplayObject;
import openflisolib.geom.Pt;

class PrimitiveBounds implements IBounds {
	private var _target:IIsoDisplayObject;
	
	public function new(target:IIsoDisplayObject) {
		this._target = target;
	}
	
	public var volume(get, null):Float;
	private function get_volume():Float {
		return _target.width * _target.length * _target.height;
	}
	
	public var width(get, null):Float;
	private function get_width():Float {
		return _target.width;
	}
	
	public var length(get, null):Float;
	private function get_length():Float {
		return _target.length;
	}
	
	public var height(get, null):Float;
	private function get_height():Float {
		return _target.height;
	}
	
	public var left(get, null):Float;
	private function get_left():Float {
		return _target.x;
	}
	
	public var right(get, null):Float;
	private function get_right():Float {
		return _target.x + _target.width;
	}
	
	public var back(get, null):Float;
	public function get_back ():Float {
		return _target.y;
	}
	
	public var front(get, null):Float;
	public function get_front ():Float {
		return _target.y + _target.length;
	}
	
	public var bottom(get, null):Float;
	public function get_bottom ():Float {
		return _target.z;
	}
	
	public var top(get, null):Float;
	public function get_top ():Float {
		return _target.z + _target.height;
	}
	
	public var centerPt(get, null):Pt;
	public function get_centerPt ():Pt {
		var pt:Pt = new Pt();
		pt.x = _target.x + _target.width / 2;
		pt.y = _target.y + _target.length / 2;
		pt.z = _target.z + _target.height / 2;
		
		return pt;
	}
	
	public function getPts ():Array<Pt> {
		var a:Array<Pt> = [];
		
		a.push(new Pt(left, back, bottom));
		a.push(new Pt(right, back, bottom));
		a.push(new Pt(right, front, bottom));
		a.push(new Pt(left, front, bottom));
		
		a.push(new Pt(left, back, top));
		a.push(new Pt(right, back, top));
		a.push(new Pt(right, front, top));
		a.push(new Pt(left, front, top));
		
		return a;
	}
	
	public function intersects (bounds:IBounds):Bool {
		if (Math.abs(centerPt.x - bounds.centerPt.x) <= _target.width / 2 + bounds.width / 2 &&
			Math.abs(centerPt.y - bounds.centerPt.y) <= _target.length / 2 + bounds.length / 2 &&
			Math.abs(centerPt.z - bounds.centerPt.z) <= _target.height / 2 + bounds.height / 2)
			
			return true;
		
		else
			return false;
	}
	
	public function containsPt (target:Pt):Bool {
		if ((left <= target.x && target.x <= right) &&
			(back <= target.y && target.y <= front) &&
			(bottom <= target.z && target.z <= top))
		{
			return true;
		}
		
		else
			return false;
	}
}