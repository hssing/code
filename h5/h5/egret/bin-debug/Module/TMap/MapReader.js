var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var mo;
(function (mo) {
    var MapReader = (function () {
        function MapReader(file) {
            this.data = {};
            this.length = 0;
            this.data = file;
        }
        MapReader.prototype.load = function (hitPos, length) {
            this.hitPos = hitPos;
            this.length = length;
        };
        MapReader.prototype.getData = function (key) {
            return this.data[key];
        };
        return MapReader;
    }());
    mo.MapReader = MapReader;
    __reflect(MapReader.prototype, "mo.MapReader");
})(mo || (mo = {}));
//# sourceMappingURL=MapReader.js.map