var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var mo;
(function (mo) {
    var Coordinate = (function () {
        function Coordinate(info) {
            this.info = info;
        }
        Coordinate.prototype.getInfo = function () {
            return this.info;
        };
        Coordinate.prototype.cell2world = function (cx, cy) {
            // cy = this.info.cols - cy;
            var x = this.info.ox + (cx - cy) * this.info.cw / 2;
            var y = this.info.oy + (cx + cy) * this.info.ch / 2;
            if (this.info.cols % 2 === 0) {
                x = x - this.info.cw / 2;
            }
            return [x, y];
        };
        Coordinate.prototype.world2cell = function (x, y) {
            if (this.info.cols % 2 === 0) {
                x = x + this.info.cw / 2;
            }
            x = x - this.info.ox;
            y = y - this.info.oy;
            var cx = Math.floor(y / this.info.ch + x / this.info.cw + 0.5);
            var cy = Math.floor(y / this.info.ch - x / this.info.cw + 0.5);
            // cy = this.info.cols - cy;
            return [cx, cy];
        };
        // begin from 0 ...
        Coordinate.prototype.index2cell = function (id, cols) {
            var x = id % (cols || this.info.cols);
            var y = Math.floor(id / this.info.cols);
            return [x, y];
        };
        // begin from 0 ...
        Coordinate.prototype.cell2index = function (cx, cy, cols) {
            return cy * (cols || this.info.cols) + cx;
        };
        return Coordinate;
    }());
    mo.Coordinate = Coordinate;
    __reflect(Coordinate.prototype, "mo.Coordinate");
})(mo || (mo = {}));
//# sourceMappingURL=Coordinate.js.map