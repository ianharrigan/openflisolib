package openflisolib.graphics;
import flash.display.Graphics;

class SolidColorFill implements IFill {
	static private var _IDCount:Int = 0;
	public var UID:Int;
	private var setID:String;
	public var color:Int;
	public var alpha:Float;
	
	public function new(color:Int, alpha:Float) {
		UID = _IDCount++;
		this.color = color;
		this.alpha = alpha;			
	}
	
	public var id(get, set):String;
	private function get_id():String {
		return (setID == null || setID == "")?
			"SolidColorFill" + UID : setID;
	}
	private function set_id(value:String):String {
		setID = value;
		return value;
	}
	
	public function begin (target:Graphics):Void {
		target.beginFill(color, alpha);
	}
	
	public function end (target:Graphics):Void {
		target.endFill();
	}
	
	public function clone ():IFill {
		return new SolidColorFill(color, alpha);
	}
}