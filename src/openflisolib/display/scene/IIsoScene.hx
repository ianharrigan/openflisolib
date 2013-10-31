package openflisolib.display.scene;

import flash.display.DisplayObjectContainer;
import openflisolib.bounds.IBounds;
import openflisolib.core.IIsoContainer;

interface IIsoScene extends IIsoContainer {
	var isoBounds(get, null):IBounds;
	var invalidatedChildren(get, null):Array<Dynamic>;
	var hostContainer(get, set):DisplayObjectContainer;
}