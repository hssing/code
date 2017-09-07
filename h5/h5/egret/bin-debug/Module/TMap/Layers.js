var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var mo;
(function (mo) {
    var NAME_CLS = {
        ground: mo.TileLayer,
        background: mo.Background,
    };
    var Layers = (function () {
        function Layers(map, camera, data) {
            this.map = map;
            this.dynamicCells = new mo.DynamicCells(map);
            this.layers = [];
            var layerIdx = 0;
            for (var _i = 0, _a = (data.layers || []); _i < _a.length; _i++) {
                var name_1 = _a[_i];
                var obj = this.createLayer(camera, name_1, layerIdx++, data);
                this.layers.push(obj);
            }
        }
        Layers.prototype.dispose = function () {
            for (var _i = 0, _a = this.layers; _i < _a.length; _i++) {
                var layer = _a[_i];
                layer.dispose();
            }
        };
        Layers.prototype.viewportChanged = function (x, y) {
            this.dynamicCells.update(x, y);
            if (!this.dynamicCells.isNeedUpdate()) {
                return;
            }
            var info = {
                cells: this.dynamicCells.getCells(),
                keys: this.dynamicCells.getCellsKey(),
            };
            this.updateLayer(x, y, info);
            this.map.callUpdateCallbackByDefault(this.dynamicCells.getCells());
        };
        Layers.prototype.updateLayer = function (x, y, info) {
            var _this = this;
            var files = this.dynamicCells.getCellFiles();
            // 短时间内刷新，移除之前的刷新请求
            this.map.canelNextFrame();
            var update = function () { return _this.update(x, y, info); };
            this.map.getData().loadAllDataFiles(files, update);
        };
        Layers.prototype.update = function (x, y, info) {
            var _this = this;
            var updateNextFrame = function () {
                for (var _i = 0, _a = _this.layers; _i < _a.length; _i++) {
                    var layer = _a[_i];
                    layer.viewportChanged(x, y, info);
                }
            };
            // 短时间内刷新，移除之前的刷新请求
            this.map.callNextFrame(updateNextFrame, this);
        };
        Layers.prototype.getLayerNames = function () {
            var ret = [];
            for (var _i = 0, _a = this.layers; _i < _a.length; _i++) {
                var layer = _a[_i];
                ret.push(layer.getName());
            }
            return ret;
        };
        Layers.prototype.createLayer = function (camera, name, layerIdx, data) {
            var cls = NAME_CLS[name] || mo.TileLayer;
            if (cls === undefined || cls === null) {
                return undefined;
            }
            return new cls(this.map, name, layerIdx, camera, data, this.dynamicCells);
        };
        return Layers;
    }());
    mo.Layers = Layers;
    __reflect(Layers.prototype, "mo.Layers");
})(mo || (mo = {}));
//# sourceMappingURL=Layers.js.map