var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var mo;
(function (mo) {
    var Dynamic = (function () {
        function Dynamic(map, node, dynamicCells, creator, collector) {
            this.map = map;
            this.dynamicCells = dynamicCells;
            this.creator = creator;
            this.collector = collector;
            this.pos = { x: Infinity, y: Infinity, };
            this.cells = {};
            this.node = new eui.Group();
            this.node.width = node.width;
            this.node.height = node.height;
            node.addChild(this.node);
            //this.node.cacheAsBitmap = true;
        }
        Dynamic.prototype.getCellNode = function (cx, cy) {
            var index = this.map.cell2index(cx, cy);
            return this.cells[index];
        };
        Dynamic.prototype.update = function (x, y, info) {
            var indices = info.cells;
            this.updateTiles(info);
        };
        Dynamic.prototype.updateTiles = function (info) {
            var indices = info.cells;
            var cellsKeys = Object.keys(this.cells);
            for (var i = cellsKeys.length - 1; i >= 0; i--) {
                var index = cellsKeys[i];
                var node = this.cells[index];
                if (indices[index] === undefined) {
                    if (this.collector) {
                        this.collector(node, index);
                    }
                    this.node.removeChild(node);
                    delete this.cells[index];
                }
            }
            var indicesKeys = info.keys; // this.dynamicCells.getCellsKey();
            for (var i = indicesKeys.length - 1; i >= 0; i--) {
                var index = indices[indicesKeys[i]];
                if (index !== undefined && this.cells[index] === undefined) {
                    var node = this.creator(index);
                    if (!node) {
                        continue;
                    }
                    var pos = this.map.index2cell(parseInt(index));
                    var wpos = this.map.cell2world(pos[0], pos[1]);
                    node.x = wpos[0], node.y = wpos[1];
                    this.node.addChild(node);
                    this.cells[index] = node;
                }
            }
        };
        return Dynamic;
    }());
    mo.Dynamic = Dynamic;
    __reflect(Dynamic.prototype, "mo.Dynamic");
})(mo || (mo = {}));
//# sourceMappingURL=Dynamic.js.map