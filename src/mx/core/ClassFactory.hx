package mx.core;

class ClassFactory<T> implements IFactory {
	public var generator:Class<T>;
	public var properties:Dynamic = null;
	
	public function new(generator:Class<T> = null) {
		this.generator = generator;
	}
	
	public function newInstance():Dynamic {
		
		var instance:Dynamic = Type.createInstance(generator, []);
		if (properties != null) {
			for (f in Reflect.fields(properties)) {
				if (Reflect.hasField(instance, f)) {
					Reflect.setField(instance, f, 
					
					Reflect.field(properties, f));
				}
			}
		}
		
		return instance;
	}
	
}