var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var mo;
(function (mo) {
    var Tile = (function () {
        function Tile(viewSize, tileSize, node, creator) {
            this.viewSize = viewSize;
            this.tileSize = tileSize;
            var tiles = this.createTiles(creator);
            this.offset = tiles.offset;
            this.node = tiles.node;
            // 优化drawcall
            this.node.cacheAsBitmap = true;
            node.addChild(this.node);
        }
        Tile.prototype.getNode = function () {
            return this.node;
        };
        Tile.prototype.update = function (x, y) {
            x = this.offset.x + x;
            y = this.offset.y + y;
            var _a = [this.node.x, this.node.y], cx = _a[0], cy = _a[1];
            if (Math.abs(cx - x) < this.tileSize.w && Math.abs(cy - y) < this.tileSize.h) {
                return;
            }
            var ox = (cx - x) % this.tileSize.w;
            var oy = (cy - y) % this.tileSize.h;
            _b = [x + ox, y + oy], this.node.x = _b[0], this.node.y = _b[1];
            var _b;
        };
        Tile.prototype.createTiles = function (creator) {
            var offset = {
                x: this.viewSize.width / 2,
                y: this.viewSize.height / 2,
            };
            var cw = Math.ceil(this.viewSize.width / this.tileSize.w) + 3;
            var ch = Math.ceil(this.viewSize.height / this.tileSize.h) + 3;
            var ox = -Math.ceil(this.tileSize.w * cw / 2);
            var oy = -Math.ceil(this.tileSize.h * ch / 2);
            var node = new eui.Group();
            for (var i = 0; i < cw; i++) {
                for (var j = 0; j < ch; j++) {
                    var tile = creator();
                    var x = ox + this.tileSize.w * (i);
                    var y = oy + this.tileSize.h * (j);
                    _a = [x, y], tile.x = _a[0], tile.y = _a[1];
                    node.addChild(tile);
                }
            }
            return { offset: offset, node: node, };
            var _a;
        };
        return Tile;
    }());
    mo.Tile = Tile;
    __reflect(Tile.prototype, "mo.Tile");
})(mo || (mo = {}));
//# sourceMappingURL=Tile.js.map