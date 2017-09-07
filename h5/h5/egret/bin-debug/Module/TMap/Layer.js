var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var mo;
(function (mo) {
    var Layer = (function () {
        function Layer(map, name, layerIdx, data) {
            this.map = map;
            this.name = name;
            this.layerIdx = layerIdx;
            this.data = data;
            this.dataSource = map.getData();
            var parent = map.getNode();
            this.node = new eui.Group();
            this.node.width = parent.width;
            this.node.height = parent.height;
            parent.addChild(this.node);
            this.node.name = this.name;
        }
        Layer.prototype.dispose = function () {
        };
        Layer.prototype.viewportChanged = function (x, y, info) {
        };
        Layer.prototype.getName = function () {
            return this.name;
        };
        return Layer;
    }());
    mo.Layer = Layer;
    __reflect(Layer.prototype, "mo.Layer");
})(mo || (mo = {}));
//# sourceMappingURL=Layer.js.map