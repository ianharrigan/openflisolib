package openflisolib.error;

import flash.errors.Error;

class IsoError extends Error {
	public var info:String;
	public var data:Dynamic;
	public function new(message:String, info:String = "", data:Dynamic = null) {
		super(message);
		
		this.info = info;
		this.data = data;
	}
}