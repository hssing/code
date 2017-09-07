var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var mo;
(function (mo) {
    var Data = (function () {
        function Data(file) {
            this.data = RES.getRes(file);
            this.info = this.getInfo();
            this.cellDatas = {};
            this.loadingList = {};
            this.coordinate = new mo.Coordinate(this.info);
            this.loadTilesets();
            this.loadLayers();
        }
        Data.prototype.getResult = function () {
            return {
                info: this.info,
                layers: this.layers,
                tilesets: this.tilesets,
                bgInfo: { url: "resource/assets/Map/zwsy.png", size: { w: 256, h: 256 }, },
            };
        };
        Data.prototype.getInfo = function () {
            var offset = {
                x: this.data.tilewidth / 2 * ((this.data.width + 1) % 2),
                y: 0,
            };
            var info = {
                offset: offset,
                rows: this.data.height,
                cols: this.data.width,
                ox: offset.x + this.data.tilewidth * this.data.width / 2,
                oy: offset.y + this.data.tileheight / 2,
                cw: this.data.tilewidth,
                ch: this.data.tileheight,
                w: this.data.width * this.data.tilewidth,
                h: this.data.height * this.data.tileheight,
            };
            return info;
        };
        Data.prototype.getTile = function (tileset, index, x, y, origin) {
            var tileoffset = tileset.tileoffset || {};
            var offsetX = tileoffset.x || 0;
            var offsetY = tileoffset.y || 0;
            var spacing = tileset.spacing || 0;
            var rect = {
                x: origin.x + (tileset.tilewidth + tileset.spacing) * x,
                y: origin.y + (tileset.tileheight + tileset.spacing) * y,
                width: tileset.tilewidth,
                height: tileset.tileheight,
            };
            var tile = {
                image: tileset.image,
                rect: rect,
                offsetX: offsetX,
                offsetY: offsetY,
            };
            return tile;
        };
        Data.prototype.loadTilesets = function () {
            var tilesets = { offsets: {}, tiles: {}, };
            for (var _i = 0, _a = this.data.tilesets; _i < _a.length; _i++) {
                var tileset = _a[_i];
                var _b = [tileset.imagewidth, tileset.imageheight], imagewidth = _b[0], imageheight = _b[1];
                // if (tileset.tiles) { //出现了这种结构，临时提取出来处理
                //     tileset.image = tileset.tiles[0].image;
                //     imagewidth = tileset.tiles[0].imagewidth;
                //     imagewidth = tileset.tiles[0].imageheight;
                // }
                var origin = { x: 0, y: 0 };
                if (tileset.margin) {
                    _c = [imagewidth - tileset.margin * 2, imageheight - tileset.margin * 2], imagewidth = _c[0], imageheight = _c[1];
                    origin.x += tileset.margin;
                    origin.y += tileset.margin;
                }
                var cols = tileset.columns || 1;
                var rows = Math.ceil(tileset.tilecount / cols);
                for (var i = 0; i < rows; i++) {
                    for (var j = 0; j < cols; j++) {
                        var index = cols * i + j;
                        if (index >= tileset.tilecount) {
                            continue;
                        }
                        var id = tileset.firstgid + index;
                        tilesets.tiles[id] = this.getTile(tileset, index, j, i, origin);
                    }
                }
            }
            this.tilesets = tilesets;
            var _c;
        };
        Data.prototype.getResSubIdxByIndex = function (index) {
            // let i = Math.floor(index / this.data.clipRange);
            var _a = this.coordinate.index2cell(index), x = _a[0], y = _a[1];
            var x1 = Math.floor(x / this.data.clipRange);
            var y1 = Math.floor(y / this.data.clipRange);
            var cols = Math.ceil(this.data.width / this.data.clipRange);
            var i = this.coordinate.cell2index(x1, y1, cols);
            i = Math.min(this.data.subFiles.length - 1, i);
            i = Math.max(0, i);
            return i;
        };
        Data.prototype.getResFullPath = function (file) {
            return "" + config.MAP_CONFIG + file;
        };
        Data.prototype.getResFullPathBySubIdx = function (idx) {
            var f = this.data.subFiles[idx];
            if (f === "") {
                return null;
            }
            return this.getResFullPath(f);
        };
        Data.prototype.setCellDataBySubIdx = function (idx, value) {
            this.cellDatas[idx] = value;
        };
        Data.prototype.getCellDataBySubIdx = function (idx) {
            return this.cellDatas[idx];
        };
        Data.prototype.getCellDataByIndex = function (index) {
            var idx = this.getResSubIdxByIndex(index);
            return this.getCellDataBySubIdx(idx);
        };
        Data.prototype.loadAllDataFiles = function (files, update) {
            var _this = this;
            var keys = Object.keys(files);
            var promises = keys.map(function (idx) {
                return _this.loadDataFile(parseInt(idx));
            });
            Promise.all(promises).then(update, update); // 资源请求出错也进行刷新（有可能是部分出错）
        };
        // 重复资源只加载一次
        Data.prototype.loadDataFile = function (idx) {
            var _this = this;
            return new Promise(function (resolve) {
                var dt = _this.cellDatas[idx];
                if (dt) {
                    return resolve(dt);
                }
                var loaded = function (data) {
                    _this.setCellDataBySubIdx(idx, data);
                    resolve(data);
                };
                _this.loadingList[idx] = _this.loadingList[idx] || [];
                var isLoading = _this.loadingList[idx].length > 0;
                _this.loadingList[idx].push(loaded);
                if (isLoading) {
                    return;
                }
                var file = _this.getResFullPathBySubIdx(idx);
                RES.getResByUrl(file, function (data) {
                    for (var _i = 0, _a = _this.loadingList[idx]; _i < _a.length; _i++) {
                        var func = _a[_i];
                        func(data);
                    }
                    _this.loadingList[idx] = [];
                }, _this, "json");
            });
        };
        Data.prototype.getCellTileByName = function (cpos, layerName) {
            var index = this.coordinate.cell2index(cpos.x, cpos.y);
            var idx = this.layers.indexOf(layerName);
            if (idx < 0) {
                return undefined;
            }
            return this.getCellTile(index, idx);
        };
        Data.prototype.getCellTile = function (index, layerIdx) {
            var cellsData = this.getCellDataByIndex(index);
            if (!cellsData || !cellsData[layerIdx]) {
                return undefined;
            }
            var tileId = cellsData[layerIdx][index];
            if (!tileId || tileId === 0) {
                return undefined;
            }
            return this.tilesets.tiles[tileId];
        };
        Data.prototype.loadLayers = function () {
            this.layers = [];
            // this.layers.push("background");
            for (var _i = 0, _a = this.data.layers; _i < _a.length; _i++) {
                var layer = _a[_i];
                var name_1 = layer["name"];
                this.layers.push(name_1);
            }
        };
        // 阻挡数据单独分离出一个文件
        Data.prototype.isBlocked = function (index, name) {
            // for (let layer of this.data.layers) {
            //     if (name === layer["name"]) {
            //         return !!layer.data[index];
            //     }
            // }
            return false;
        };
        return Data;
    }());
    mo.Data = Data;
    __reflect(Data.prototype, "mo.Data");
})(mo || (mo = {}));
//# sourceMappingURL=Data.js.map