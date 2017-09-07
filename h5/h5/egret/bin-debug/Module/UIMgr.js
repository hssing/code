var UIMgr;
(function (UIMgr) {
    var root;
    var layers;
    function setup(root) {
        _init(root);
    }
    UIMgr.setup = setup;
    function getHome() {
        var layer = getLayer("home");
        return layer.getChildAt(0);
    }
    UIMgr.getHome = getHome;
    function getWorld() {
        var layer = getLayer("scene");
        return layer.getChildAt(0);
    }
    UIMgr.getWorld = getWorld;
    function getGuide() {
        var layer = getLayer("guide");
        return layer.getChildAt(0);
    }
    UIMgr.getGuide = getGuide;
    function getLayer(name) {
        return layers[name];
    }
    UIMgr.getLayer = getLayer;
    function open(viewCls, layerName) {
        if (layerName === void 0) { layerName = "panel"; }
        var data = [];
        for (var _i = 2; _i < arguments.length; _i++) {
            data[_i - 2] = arguments[_i];
        }
        var layer = getLayer(layerName);
        var view = new (viewCls.bind.apply(viewCls, [void 0].concat(data)))();
        layer.addChild(view);
        return view;
    }
    UIMgr.open = open;
    function openOnce(viewCls, layerName) {
        if (layerName === void 0) { layerName = "panel"; }
        var data = [];
        for (var _i = 2; _i < arguments.length; _i++) {
            data[_i - 2] = arguments[_i];
        }
        var layer = getLayer(layerName);
        for (var i = 0; i < layer.numChildren; i++) {
            var child = layer.getChildAt(i);
            if (child instanceof viewCls) {
                return;
            }
        }
        open.apply(void 0, [viewCls, layerName].concat(data));
    }
    UIMgr.openOnce = openOnce;
    function close(view) {
        if (view.parent) {
            view.removeFromParent();
        }
    }
    UIMgr.close = close;
    function closeAll(viewCls, layerName) {
        if (layerName === void 0) { layerName = "panel"; }
        var layer = getLayer(layerName);
        var removed = [];
        for (var i = 0; i < layer.numChildren; i++) {
            var child = layer.getChildAt(i);
            if (child instanceof viewCls) {
                removed.push(child);
            }
        }
        for (var _i = 0, removed_1 = removed; _i < removed_1.length; _i++) {
            var child = removed_1[_i];
            child.removeFromParent();
        }
    }
    UIMgr.closeAll = closeAll;
    function fireUIEvent(name, data) {
        var views = [];
        for (var k in layers) {
            var l = layers[k];
            for (var i = l.numChildren - 1; i >= 0; i--) {
                var view = l.getChildAt(i);
                views.push(view);
            }
        }
        views.forEach(function (view) {
            var event = new egret.Event(name, false, true, data);
            view.dispatchEvent(event);
        });
    }
    UIMgr.fireUIEvent = fireUIEvent;
    function _init(r) {
        layers =
            {
                scene: new eui.UILayer(),
                home: new eui.UILayer(),
                panel: new eui.UILayer(),
                effect: new eui.UILayer(),
                guide: new eui.UILayer(),
                mask: new eui.UILayer(),
                load: new eui.UILayer(),
            };
        root = r;
        for (var key in layers) {
            var layer = layers[key];
            layer.touchThrough = true;
            root.addChild(layer);
            _a = [root.width, root.height], layer.width = _a[0], layer.height = _a[1];
        }
        root.touchThrough = true;
        var _a;
    }
})(UIMgr || (UIMgr = {}));
//# sourceMappingURL=UIMgr.js.map