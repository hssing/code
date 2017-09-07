var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var mo;
(function (mo) {
    var DynamicCells = (function () {
        function DynamicCells(map) {
            this.map = map;
            this.cells = {};
            this.keyCache = [];
            this.cellFiles = {};
            this.isUpdate = false;
            this.pos = { x: Infinity, y: Infinity };
        }
        DynamicCells.prototype.isNeedUpdate = function () {
            return this.isUpdate;
        };
        DynamicCells.prototype.update = function (x, y) {
            var size = this.map.getViewSize();
            var cx = this.pos.x;
            var cy = this.pos.y;
            if (Math.abs(x - cx) < size.width * 0.5 && Math.abs(y - cy) < size.height * 0.5) {
                this.isUpdate = false;
                this.keyCache = [];
                this.cellFiles = {};
                return;
            }
            this.isUpdate = true;
            _a = [x, y], this.pos.x = _a[0], this.pos.y = _a[1];
            this.cells = this.updateCells(x, y);
            var _a;
        };
        DynamicCells.prototype.getCells = function () {
            return this.cells;
        };
        DynamicCells.prototype.getCellsKey = function () {
            return this.keyCache;
        };
        DynamicCells.prototype.getCellFiles = function () {
            return this.cellFiles;
        };
        DynamicCells.prototype.updateCells = function (x, y) {
            var viewSize = this.map.getViewSize();
            var wx1 = x - viewSize.width * 0.5;
            var wy1 = y - viewSize.height * 0.5;
            var wx2 = x + viewSize.width * 1.5;
            var wy2 = y + viewSize.height * 1.5;
            var _a = this.map.world2cell(wx1, wy1), cxlt = _a[0], cylt = _a[1];
            var _b = this.map.world2cell(wx2, wy2), cxrb = _b[0], cyrb = _b[1];
            var _c = this.map.world2cell(wx2, wy1), cxrt = _c[0], cyrt = _c[1];
            var _d = this.map.world2cell(wx1, wy2), cxlb = _d[0], cylb = _d[1];
            var info = this.map.getInfo();
            var minX = Math.max(0, Math.min(cxlt, cxrb, cxrt, cxlb));
            var maxX = Math.min(info.rows - 1, Math.max(cxlt, cxrb, cxrt, cxlb));
            var minY = Math.max(0, Math.min(cylt, cyrb, cyrt, cylb));
            var maxY = Math.min(info.cols - 1, Math.max(cylt, cyrb, cyrt, cylb));
            this.keyCache = [];
            var cells = {};
            for (var i = minX; i <= maxX; i++) {
                for (var j = minY; j <= maxY; j++) {
                    var index = this.map.cell2index(i, j);
                    cells[index] = index;
                    this.keyCache.push(index);
                    var idx = this.map.getData().getResSubIdxByIndex(index);
                    if (!this.cellFiles[idx]) {
                        this.cellFiles[idx] = idx;
                    }
                }
            }
            return cells;
        };
        return DynamicCells;
    }());
    mo.DynamicCells = DynamicCells;
    __reflect(DynamicCells.prototype, "mo.DynamicCells");
})(mo || (mo = {}));
//# sourceMappingURL=DynamicCells.js.map