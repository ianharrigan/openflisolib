package openflisolib.bounds;

import openflisolib.core.IIsoDisplayObject;
import openflisolib.display.scene.IIsoScene;
import openflisolib.geom.Pt;

class SceneBounds implements IBounds {
	private var _target:IIsoScene;
	private var excludeAnimated:Bool = false;
	
	public function new(target:IIsoScene) {
		this._target = target;
		calculateBounds();					
	}
	
	public var volume(get, null):Float;
	private function get_volume():Float {
		return width * length * height;
	}
	
	public var width(get, null):Float;
	private function get_width():Float {
		return _right - _left;
	}
	
	public var length(get, null):Float;
	private function get_length():Float {
		return _front - _back;
	}
	
	public var height(get, null):Float;
	private function get_height():Float {
		return _top - _bottom;
	}
	
	private var _left:Float;
	public var left(get, null):Float;
	private function get_left():Float {
		return _left;
	}
	
	private var _right:Float;
	public var right(get, null):Float;
	private function get_right():Float {
		return _right;
	}
	
	private var _back:Float;
	public var back(get, null):Float;
	public function get_back ():Float {
		return _back;
	}
	
	private var _front:Float;
	public var front(get, null):Float;
	public function get_front ():Float {
		return _front;
	}
	
	private var _bottom:Float;
	public var bottom(get, null):Float;
	public function get_bottom ():Float {
		return _bottom;
	}
	
	private var _top:Float;
	public var top(get, null):Float;
	public function get_top ():Float {
		return _top;
	}
	
	public var centerPt(get, null):Pt;
	public function get_centerPt ():Pt {
		var pt:Pt = new Pt();
		pt.x = (_right - _left) / 2;
		pt.y = (_front - _back) / 2;
		pt.z = (_top - _bottom) / 2;
		
		return pt;
	}
	
	public function getPts ():Array<Pt> {
		var a:Array<Pt> = [];
		
		a.push(new Pt(_left, _back, _bottom));
		a.push(new Pt(_right, _back, _bottom));
		a.push(new Pt(_right, _front, _bottom));
		a.push(new Pt(_left, _front, _bottom));
		
		a.push(new Pt(_left, _back, _top));
		a.push(new Pt(_right, _back, _top));
		a.push(new Pt(_right, _front, _top));
		a.push(new Pt(_left, _front, _top));
		
		return a;
	}
	
	public function intersects (bounds:IBounds):Bool {
		return false;
	}
	
	public function containsPt (target:Pt):Bool {
		if ((_left <= target.x && target.x <= _right) &&
			(_back <= target.y && target.y <= _front) &&
			(_bottom <= target.z && target.z <= _top))
		{
			return true;
		}
		
		else
			return false;
	}
	
	public var excludeAnimatedChildren(get, set):Bool;
	private function get_excludeAnimatedChildren():Bool {
		return excludeAnimated;
	}
	private function set_excludeAnimatedChildren(value:Bool):Bool {
		excludeAnimated = value;
		calculateBounds();
		return value;
	}
	
	private function calculateBounds ():Void {
		var child:IIsoDisplayObject;
		for (temp in _target.displayListChildren) {
			child = cast(temp, IIsoDisplayObject);
			if (excludeAnimated && child.isAnimated)
				continue;
				
			if (Math.isNaN(_left) || child.isoBounds.left < _left)
				_left = child.isoBounds.left;
			
			if (Math.isNaN(_right) || child.isoBounds.right > _right)
				_right = child.isoBounds.right;
			
			if (Math.isNaN(_back) || child.isoBounds.back < _back)
				_back = child.isoBounds.back;
			
			if (Math.isNaN(_front) || child.isoBounds.front > _front)
				_front = child.isoBounds.front;
				
			if (Math.isNaN(_bottom) || child.isoBounds.bottom < _bottom)
				_bottom = child.isoBounds.bottom;
				
			if (Math.isNaN(_top) || child.isoBounds.top > _top)
				_top = child.isoBounds.top;
		}
		
		if (Math.isNaN(_left))
			_left = 0;
			
		if (Math.isNaN(_right))
			_right = 0;
		
		if (Math.isNaN(_back))
			_back = 0;
		
		if (Math.isNaN(_front))
			_front = 0;
		
		if (Math.isNaN(_bottom))
			_bottom = 0;
			
		if (Math.isNaN(_top))
			_top = 0;
	}
}