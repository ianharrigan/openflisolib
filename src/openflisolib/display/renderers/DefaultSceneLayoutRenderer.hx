package openflisolib.display.renderers;

import haxe.Timer;
import openflisolib.core.IIsoContainer;
import openflisolib.core.IIsoDisplayObject;
import openflisolib.core.IsoContainer;
import openflisolib.core.IsoDisplayObject;
import openflisolib.display.scene.IIsoScene;

class DefaultSceneLayoutRenderer implements ISceneLayoutRenderer {
	// It's faster to make class variables & a method, rather than to do a local function closure
	private var depth:Int;
	private var visited:Map<IsoDisplayObject, Bool>;
	private var scene:IIsoScene;
	private var dependency:Map<IsoDisplayObject, Array<IsoDisplayObject>>;
	
	public function new() {
		visited = new Map<IsoDisplayObject, Bool>();
	}
	
	public function renderScene (scene:IIsoScene):Void {
		this.scene = scene;
		var startTime:Float = Timer.stamp();
		
		dependency = new Map < IsoDisplayObject, Array<IsoDisplayObject> > ();
		var children:Array<IIsoContainer> = scene.displayListChildren;
		
		var max:Int = children.length;
		var i:Int;
		// TODO: verify loop
		//for (var i:uint = 0; i < max; ++i)
		for (i in 0...max) {
			var behind:Array<IsoDisplayObject> = [];
			
			var objA:IsoDisplayObject = cast(children[i], IsoDisplayObject);
			
			var rightA:Float = objA.x + objA.width;
			var frontA:Float = objA.y + objA.length;
			var topA:Float = objA.z + objA.height;
			
			var j:Int;
			// TODO: verify loop
			//for (var j:uint = 0; j < max; ++j) {
			for (j in 0...max) {
				var objB:IsoDisplayObject = cast(children[j], IsoDisplayObject);
				if (collisionDetectionFunc != null)
					collisionDetectionFunc(objA, objB);
					
				if ((objB.x < rightA) &&
					(objB.y < frontA) &&
					(objB.z < topA) &&
					(i != j)) {
					behind.push(objB);
				}
			}
			
			dependency[objA] = behind;
		}

		// TODO - set the invalidated children first, then do a rescan to make sure everything else is where it needs to be, too?  probably need to order the invalidated children sets from low to high index
		// Set the childrens' depth, using dependency ordering
		depth = 0;
		for (temp in children) {
			var obj:IsoDisplayObject = cast(temp, IsoDisplayObject);
			if (true != visited.get(obj)) {
				place(obj);
			}
		}
		
		visited = new Map<IsoDisplayObject, Bool>();
	}
	
	private function place(obj:IsoDisplayObject):Void {
		visited.set(obj, true);
		
		var inner:IsoDisplayObject;
		for (inner in dependency[obj]) {
			if (true != visited.get(inner)) {
				place(inner);
			}
			
			if (depth != obj.depth) {
				scene.setChildIndex(obj, depth);
			}
		}
		
		++depth;
	}
	
	/////////////////////////////////////////////////////////////////
	//	COLLISION DETECTION
	/////////////////////////////////////////////////////////////////
	private var collisionDetectionFunc:Dynamic->Dynamic->Int = null;	
	public var collisionDetection(get, set):Dynamic->Dynamic->Int;
	private function get_collisionDetection():Dynamic->Dynamic->Int {
		return collisionDetectionFunc;
	}
	private function set_collisionDetection(value:Dynamic->Dynamic->Int):Dynamic->Dynamic->Int {
		collisionDetectionFunc = value;
		return value;
	}
}