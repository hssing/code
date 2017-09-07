var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var mo;
(function (mo) {
    var TMap = (function () {
        function TMap(mapData, viewSize) {
            this.dataSource = mapData;
            this.data = mapData.getResult();
            this.rootNode = new eui.Group();
            this.rootNode.width = this.data.info.w;
            this.rootNode.height = this.data.info.h;
            this.rootNode.addEventListener(egret.Event.ENTER_FRAME, this.update, this);
            this.coordinate = new mo.Coordinate(this.data.info);
            this.camera = new mo.Camera(this, viewSize);
            this.layers = new mo.Layers(this, this.camera, this.data);
        }
        TMap.prototype.dispose = function () {
            this.rootNode.removeEventListener(egret.Event.ENTER_FRAME, this.update, this);
            this.layers.dispose();
            this.camera.dispose();
            this.layers = null;
            this.camera = null;
            this.updateCallback = null;
            this.tapCallback = null;
        };
        TMap.prototype.world2cell = function (x, y) {
            return this.coordinate.world2cell(x, y);
        };
        TMap.prototype.cell2world = function (cx, cy) {
            return this.coordinate.cell2world(cx, cy);
        };
        TMap.prototype.cell2index = function (x, y) {
            return this.coordinate.cell2index(x, y);
        };
        TMap.prototype.index2cell = function (index) {
            return this.coordinate.index2cell(index);
        };
        Object.defineProperty(TMap.prototype, "x", {
            get: function () {
                return this.camera.x;
            },
            set: function (v) {
                this.camera.x = v;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(TMap.prototype, "y", {
            get: function () {
                return this.camera.y;
            },
            set: function (v) {
                this.camera.y = v;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(TMap.prototype, "width", {
            get: function () {
                return this.rootNode.width;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(TMap.prototype, "height", {
            get: function () {
                return this.rootNode.height;
            },
            enumerable: true,
            configurable: true
        });
        // data: {tilewidth, tileheight, width, height,} 格子宽高， 地图行列
        TMap.createCoordinate = function (data) {
            var offset = {
                x: data.tilewidth / 2 * ((data.width + 1) % 2),
                y: 0,
            };
            var info = {
                rows: data.height,
                cols: data.width,
                ox: offset.x + data.tilewidth * data.width / 2 + (data.ox || 0),
                oy: offset.y + data.tileheight / 2 + (data.oy || 0),
                cw: data.tilewidth,
                ch: data.tileheight,
                w: data.width * data.tilewidth,
                h: data.height * data.tileheight,
            };
            return new mo.Coordinate(info);
        };
        // data: {matrix, ox, oy} 格子相对当前地图百分比， 地图行列
        TMap.prototype.createCoordinate = function (matrix, ox, oy) {
            if (ox === void 0) { ox = 0; }
            if (oy === void 0) { oy = 0; }
            var data = {};
            matrix = Math.floor(matrix);
            data.tilewidth = this.data.info.cw / matrix;
            data.tileheight = this.data.info.ch / matrix;
            data.height = data.width = matrix;
            data.ox = ox;
            data.oy = oy;
            return TMap.createCoordinate(data);
        };
        TMap.prototype.getNode = function () {
            return this.rootNode;
        };
        TMap.prototype.setViewSize = function (sz) {
            this.camera.setViewSize(sz);
        };
        TMap.prototype.getViewSize = function () {
            return this.camera.getViewSize();
        };
        TMap.prototype.setPos = function (x, y) {
            this.camera.setPos(x, y);
        };
        TMap.prototype.getPos = function () {
            return this.camera.getPos();
        };
        TMap.prototype.getCenterCPos = function () {
            var wp = this.getCenterWPos();
            return this.world2cell(wp[0], wp[1]);
        };
        TMap.prototype.getCenterWPos = function () {
            var sz = this.camera.getViewSize();
            var wp = this.camera.getPos();
            wp = [wp[0] + sz.width / 2, wp[1] + sz.height / 2];
            return wp;
        };
        TMap.prototype.update = function () {
            if (this.camera.update()) {
                var _a = this.camera.getPos(), x = _a[0], y = _a[1];
                this.layers.viewportChanged(x, y);
            }
        };
        TMap.prototype.getInfo = function () {
            return this.data.info;
        };
        TMap.prototype.getData = function () {
            return this.dataSource;
        };
        // callback 使用 => 函数
        TMap.prototype.registTapCallback = function (c) {
            this.tapCallback = c;
        };
        // callback 使用 => 函数
        TMap.prototype.registUpdateCallback = function (c, layerName) {
            if (layerName === void 0) { layerName = "default"; }
            this.updateCallback = this.updateCallback || {};
            this.updateCallback[layerName] = c;
        };
        TMap.prototype.callUpdateCallback = function (cells, layerName) {
            if (!this.updateCallback || !this.updateCallback[layerName]) {
                return;
            }
            this.updateCallback[layerName](cells);
        };
        TMap.prototype.callUpdateCallbackByDefault = function (cells) {
            this.callUpdateCallback(cells, "default");
        };
        TMap.prototype.touchTap = function (event) {
            if (!this.tapCallback) {
                return;
            }
            var wpos = this.rootNode.globalToLocal(event.stageX, event.stageY);
            this.tapCallback(wpos);
        };
        TMap.getMainData = function () {
            return Singleton(mo.Data, config.MAP_URLS[0]);
        };
        TMap.prototype.callNextFrame = function (func, thisObject) {
            this.canelNextFrame();
            this.timer = utils.after(0, func, thisObject);
        };
        TMap.prototype.canelNextFrame = function () {
            if (!this.timer) {
                return;
            }
            this.timer.stop();
            this.timer = null;
        };
        return TMap;
    }());
    mo.TMap = TMap;
    __reflect(TMap.prototype, "mo.TMap");
})(mo || (mo = {}));
//# sourceMappingURL=TMap.js.map