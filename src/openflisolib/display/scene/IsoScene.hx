package openflisolib.display.scene;

import flash.display.DisplayObjectContainer;
import flash.errors.Error;
import mx.core.ClassFactory;
import mx.core.IFactory;
import openflisolib.bounds.IBounds;
import openflisolib.core.IIsoDisplayObject;
import openflisolib.core.IsoContainer;
import openflisolib.data.INode;
import openflisolib.display.renderers.DefaultSceneLayoutRenderer;
import openflisolib.display.renderers.ISceneLayoutRenderer;
import openflisolib.display.renderers.ISceneRenderer;
import openflisolib.events.IsoEvent;

class IsoScene extends IsoContainer implements IIsoScene {
	private var layoutObject:Dynamic;
	public function new() {
		super();
		
		invalidatedChildrenArray = [];
		styleRendererFactories = new Array<IFactory>();
		layoutObject = new ClassFactory(DefaultSceneLayoutRenderer);
	}
	
	///////////////////////////////////////////////////////////////////////////////
	//	BOUNDS
	///////////////////////////////////////////////////////////////////////////////
	private var _isoBounds:IBounds;
	public var isoBounds(get, null):IBounds;
	private function get_isoBounds():IBounds {
		return _isoBounds;
	}
	
	private var host:DisplayObjectContainer;
	public var hostContainer(get, set):DisplayObjectContainer;
	private function get_hostContainer():DisplayObjectContainer {
		return host;
	}
	private function set_hostContainer(value:DisplayObjectContainer):DisplayObjectContainer {
		if (value != null && host != value) {
			if (host != null && host.contains(container)) {
				host.removeChild(container);
				ownerObject = null;
			} else if (hasParent) {
				parent.removeChild(this);
			}
			
			host = value;
			if (host != null)  {
				host.addChild(container);
				ownerObject = host;
				parentNode = null;
			}
		}
		return value;
	}
	
	///////////////////////////////////////////////////////////////////////////////
	//	INVALIDATE CHILDREN
	///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * @private
	 * 
	 * Array of invalidated children.  Each child dispatches an IsoEvent.INVALIDATION event which notifies 
	 * the scene that that particular child is invalidated and subsequentally the scene is also invalidated.
	 */
	private var invalidatedChildrenArray:Array<Dynamic>;
	public var invalidatedChildren(get, null):Array<Dynamic>;
	private function get_invalidatedChildren():Array<Dynamic> {
		return invalidatedChildrenArray;
	}
	
	///////////////////////////////////////////////////////////////////////////////
	//	OVERRIDES
	///////////////////////////////////////////////////////////////////////////////
	override public function addChildAt (child:INode, index:Int):Void {
		if (Std.is(child, IIsoDisplayObject)) {
			super.addChildAt(child, index);
			child.addEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
			
			bIsInvalidated = true; //since the child most likely had fired an invalidation event prior to being added, manually invalidate the scene
		} else {
			throw new Error ("parameter child is not of type IIsoDisplayObject");
		}
	}
	
	override public function setChildIndex (child:INode, index:Int):Void {
		super.setChildIndex(child, index);
		bIsInvalidated = true;
	}
	
	override public function removeChildByID (id:String):INode {
		var child:INode = super.removeChildByID(id);
		if (child != null) {
			child.removeEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
			bIsInvalidated = true;
		}
		
		return child;
	}
	
	override public function removeAllChildren ():Void {
		var child:INode;
		for (child in children) {
			child.removeEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
		}
		super.removeAllChildren();
		bIsInvalidated = true;
	}
	
	private function child_invalidateHandler (evt:IsoEvent):Void {
		var child:Dynamic = evt.target;
		if (Lambda.indexOf(invalidatedChildrenArray, child) == -1)
			invalidatedChildrenArray.push(child);
		
		bIsInvalidated = true;
	}
	
	///////////////////////////////////////////////////////////////////////////////
	//	LAYOUT RENDERER
	///////////////////////////////////////////////////////////////////////////////
	public var layoutEnabled:Bool = true;
	
	private var bLayoutIsFactory:Bool = true;//flag telling us whether we decided to persist an ISceneLayoutRenderer or using a Factory each time.
	
	/**
	 * The object used to layout a scene's children.  This value can be either an IFactory or ISceneLayoutRenderer.
	 * If the value is an IFactory, then a renderer is created and discarded on each render pass.  
	 * If the value is an ISceneLayoutRenderer, then a renderer is created and stored.
	 * This option infrequently rendered scenes to free up memeory by releasing the factory instance.
	 * If this IsoScene is expected be invalidated frequently, then persisting an instance in memory might provide better performance.
	 */
	public var layoutRenderer(get, set):Dynamic;
	private function get_layoutRenderer():Dynamic {
		return layoutObject;
	}
	private function set_layoutRenderer(value:Dynamic):Dynamic {
		if (value == null) {
			layoutObject = new ClassFactory(DefaultSceneLayoutRenderer);
			
			bLayoutIsFactory = true;
			bIsInvalidated = true;
		}
		
		if (value != null && layoutObject != value) {
			if (Std.is(value, IFactory)) {
				bLayoutIsFactory = true;
			} else if (Std.is(value, ISceneLayoutRenderer)) {
				bLayoutIsFactory = false;
			} else {
				throw new Error("value for layoutRenderer is not of type IFactory or ISceneLayoutRenderer");
			}
			
			layoutObject = value;				
			bIsInvalidated = true;
		}
		return value;
	}
	
	///////////////////////////////////////////////////////////////////////////////
	//	STYLE RENDERERS
	///////////////////////////////////////////////////////////////////////////////
	public var stylingEnabled:Bool = true;
	
	private var styleRendererFactories:Array<IFactory>;
	
	public var styleRenderers(get, set):Array<IFactory>;
	private function get_styleRenderers():Array<IFactory> {
		var temp:Array<IFactory> = [];
		var factory:IFactory;
		for (factory in styleRendererFactories) {
			temp.push(factory);
		}
		return temp;
	}
	private function set_styleRenderers(value:Array<IFactory>):Array<IFactory> {
		if (value != null) {
			styleRendererFactories = new Array<IFactory>();
			for (f in value) {
				styleRendererFactories.push(f);
			}
		} else {
			styleRendererFactories = null;
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////////
	//	INVALIDATION
	///////////////////////////////////////////////////////////////////////////////
	public function invalidateScene ():Void {
		bIsInvalidated = true;
	}
	
	///////////////////////////////////////////////////////////////////////////////
	//	RENDER
	///////////////////////////////////////////////////////////////////////////////
	override private function renderLogic (recursive:Bool = true):Void {
		super.renderLogic(recursive); //push individual changes thru, then sort based on new visible content of each child
		
		if (bIsInvalidated) {
			if (layoutEnabled) {
				var sceneLayoutRenderer:ISceneLayoutRenderer;
				if (bLayoutIsFactory) {
					sceneLayoutRenderer = cast(layoutObject, IFactory).newInstance();	
				} else {
					sceneLayoutRenderer = cast(layoutObject, ISceneLayoutRenderer);
				}
				
				if (sceneLayoutRenderer != null)
					sceneLayoutRenderer.renderScene(this);
			}
			
			//fix for bug #20 - http://code.google.com/p/as3isolib/issues/detail?id=20
			var sceneRenderer:ISceneRenderer;
			var factory:IFactory;
			if (stylingEnabled && styleRendererFactories.length > 0) {
				mainContainer.graphics.clear();
				
				for (factory in styleRendererFactories) {
					sceneRenderer = factory.newInstance();
					if (sceneRenderer != null) {
						sceneRenderer.renderScene(this);
					}
				}
			}
		}
	}
	
	override private function postRenderLogic ():Void {
		invalidatedChildrenArray = [];
		super.postRenderLogic();
		//should we still call sceneRendered()?
		sceneRendered();
	}
	
	/**
	 * This function has been deprecated.  Please refer to postRenderLogic.
	 */
	private function sceneRendered ():Void {
	}
}