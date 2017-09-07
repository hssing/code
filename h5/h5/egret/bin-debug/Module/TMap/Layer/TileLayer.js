var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var mo;
(function (mo) {
    var TileLayer = (function (_super) {
        __extends(TileLayer, _super);
        function TileLayer(map, name, layerIdx, camera, data, dynamicCells) {
            var _this = _super.call(this, map, name, layerIdx, data) || this;
            var self = _this;
            _this.dynamicCells = dynamicCells;
            _this.pool = {};
            _this.strategy = new mo.Dynamic(map, _this.node, _this.dynamicCells, function (index) {
                var tile = _this.dataSource.getCellTile(index, _this.layerIdx);
                if (tile === undefined) {
                    return undefined;
                }
                var key = _this.getTileKey(tile);
                if (_this.pool[key] && _this.pool[key].length > 0) {
                    return _this.pool[key].pop();
                }
                var sp = _this.getSprite(tile, key, index, self.data.info);
                sp.y += self.data.info.ch - sp.height;
                var gp = new eui.Group();
                gp.addChild(sp);
                gp.width = self.data.info.cw;
                gp.height = self.data.info.ch;
                gp.anchorOffsetX = gp.width / 2;
                gp.anchorOffsetY = gp.height / 2;
                gp.name = key;
                return gp;
            }, function (node, index) {
                var key = node.name;
                _this.pool[key] = _this.pool[key] || [];
                _this.pool[key].push(node);
            });
            return _this;
        }
        TileLayer.prototype.dispose = function () {
            _super.prototype.dispose.call(this);
        };
        TileLayer.prototype.getTileKey = function (tile) {
            var rect = tile.rect;
            return tile.image + ":" + rect.x + "-" + rect.y;
        };
        TileLayer.prototype.getSprite = function (tile, key, index, info) {
            var url = tile.image.replace(".", "_");
            var bitmapData = RES.getRes(url);
            //let bitmapData = RES.getRes(`resource/assets/Map/${tile.image}`);
            var bm = new egret.Bitmap(bitmapData);
            var spriteSheet = new egret.SpriteSheet(bm.texture);
            //创建一个新的 Texture 对象
            var rect = tile.rect;
            var tx = spriteSheet.getTexture(key);
            if (!tx) {
                tx = spriteSheet.createTexture(key, rect.x, rect.y, rect.width, rect.height);
            }
            var sp = new eui.Image(tx);
            _a = [tile.offsetX, tile.offsetY], sp.x = _a[0], sp.y = _a[1];
            _b = [rect.width, rect.height], sp.width = _b[0], sp.height = _b[1];
            return sp;
            var _a, _b;
        };
        TileLayer.prototype.viewportChanged = function (x, y, info) {
            this.strategy.update(x, y, info);
            if (!this.dynamicCells.isNeedUpdate()) {
                return;
            }
            this.map.callUpdateCallback(this.dynamicCells.getCells(), this.getName());
        };
        TileLayer.prototype.getCellNode = function (cx, cy) {
            return this.strategy.getCellNode(cx, cy);
        };
        return TileLayer;
    }(mo.Layer));
    mo.TileLayer = TileLayer;
    __reflect(TileLayer.prototype, "mo.TileLayer");
})(mo || (mo = {}));
//# sourceMappingURL=TileLayer.js.map