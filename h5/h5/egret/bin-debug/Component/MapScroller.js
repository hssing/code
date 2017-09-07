var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var MapScroller = (function (_super) {
    __extends(MapScroller, _super);
    function MapScroller() {
        var _this = _super.call(this) || this;
        _this.scrollThreshold = 5;
        // Sub Map
        _this.subMaps = [];
        _this.touchScrollH = new world.TouchScroll(_this.horizontalUpdateHandler, _this.horizontalEndHandler, _this);
        _this.touchScrollV = new world.TouchScroll(_this.verticalUpdateHandler, _this.verticalEndHanlder, _this);
        _this.touchScrollH.$bounces = false;
        _this.touchScrollV.$bounces = false;
        _this.touchScrollH.$scrollFactor = 0.3;
        _this.touchScrollV.$scrollFactor = 0.3;
        return _this;
    }
    MapScroller.prototype.horizontalUpdateHandler = function (scrollPos) {
        var _a = this.getCameraRange(scrollPos, this.map.y), x = _a[0], y = _a[1];
        this.updateMapPosition(x, y);
    };
    MapScroller.prototype.horizontalEndHandler = function () {
    };
    MapScroller.prototype.verticalUpdateHandler = function (scrollPos) {
        var _a = this.getCameraRange(this.map.x, scrollPos), x = _a[0], y = _a[1];
        this.updateMapPosition(x, y);
    };
    MapScroller.prototype.verticalEndHanlder = function () {
    };
    // 设置地图世界坐标，限定地图边界范围
    MapScroller.prototype.setPosWithCheckRange = function (x, y) {
        var border = this.getCameraRange(x, y);
        this.updateMapPosition(border[0], border[1]);
    };
    // todo@ 带动画
    MapScroller.prototype.setPosWithAnimat = function (x, y, time, endFunc) {
        var centPos = [x - this.width / 2, y - this.height / 2];
        var border = this.getCameraRange(centPos[0], centPos[1]);
        this.moveToMapPosition(border[0], border[1], time, endFunc);
    };
    // cx, cy 在地图边界范围内居中屏幕
    MapScroller.prototype.setCell2Center = function (cx, cy) {
        var wpos = this.map.cell2world(cx, cy);
        var centPos = [wpos[0] - this.width / 2, wpos[1] - this.height / 2];
        var border = this.getCameraRange(centPos[0], centPos[1]);
        this.updateMapPosition(border[0], border[1]);
    };
    MapScroller.prototype.getCenterWPos = function (x, y) {
        return [x - this.width / 2, y - this.height / 2];
    };
    MapScroller.prototype.registScrollCallback = function (c) {
        this.scrollCallback = c;
    };
    MapScroller.prototype.setViewSize = function (sz) {
        this.width = sz.width;
        this.height = sz.height;
        this.map.setViewSize(sz);
        this.map.update();
        this.subMaps.map(function (map) { return map.setViewSize(sz); });
        this.subMaps.map(function (map) { return map.update(); });
        this.formulas = this.getLineFormulas(this.map, config.MAP_BORDER_OFFSET);
        this.border = this.getBorderCorner(this.formulas, this);
    };
    // 获取地图对象
    MapScroller.prototype.getMap = function () {
        return this.map;
    };
    MapScroller.prototype.dispose = function () {
        this.map.dispose();
        this.map = null;
        this.subMaps.map(function (map) { return map.dispose(); });
        this.subMaps = [];
    };
    // 创建地图
    MapScroller.prototype.buildMap = function (file, subMapData, parent) {
        var scene = parent;
        var view = this;
        // view.scrollEnabled = true;
        view.width = scene.width;
        view.height = scene.height;
        view.x = scene.width / 2;
        view.y = scene.height / 2;
        view.anchorOffsetX = view.width / 2;
        view.anchorOffsetY = view.height / 2;
        scene.addChild(view);
        var mapData = Singleton(mo.Data, file);
        var map = new mo.TMap(mapData, { width: view.width, height: view.height });
        var node = map.getNode();
        view.addChild(node);
        this.map = map;
        var sctrl = new eui.Group();
        node.addChild(sctrl);
        sctrl.name = "MapTouchController";
        // 扩大触摸区域
        sctrl.width = node.width * 3;
        sctrl.height = node.height * 3;
        sctrl.anchorOffsetX = sctrl.width / 2;
        sctrl.anchorOffsetY = sctrl.height / 2;
        this.buildSubMap(subMapData, view);
        var wpos = map.cell2world(0, 0);
        this.updateMapPosition(wpos[0], wpos[1]);
        var touchStartX = 0;
        var touchStartY = 0;
        var hasMoved = false;
        //手指按到屏幕，触发 startMove 方法
        sctrl.touchEnabled = true;
        sctrl.addEventListener(egret.TouchEvent.TOUCH_BEGIN, startMove, this);
        //手指离开屏幕，触发 stopMove 方法
        sctrl.addEventListener(egret.TouchEvent.TOUCH_END, stopMove, this);
        // map.registTouchEvent();
        function startMove(e) {
            //计算手指和圆形的距离
            touchStartX = e.stageX; // - node.x;
            touchStartY = e.stageY; // - node.y;
            hasMoved = false;
            //手指在屏幕上移动，会触发 onMove 方法
            sctrl.addEventListener(egret.TouchEvent.TOUCH_MOVE, onMove, this);
            this.touchScrollH.stop();
            this.touchScrollV.stop();
            this.touchScrollH.start(e.stageX);
            this.touchScrollV.start(e.stageY);
        }
        function stopMove(e) {
            //手指离开屏幕，移除手指移动的监听
            sctrl.removeEventListener(egret.TouchEvent.TOUCH_MOVE, onMove, this);
            if (!hasMoved) {
                map.touchTap(e);
            }
            this.touchScrollH.finish(this.map.x, 0);
            this.touchScrollV.finish(this.map.y, 0);
        }
        function onMove(e) {
            // let [x, y] = [e.stageX - offsetX, e.stageY - offsetY];
            // [x, y] = this.getCameraRange(-x, -y);
            // this.updateMapPosition(x, y);
            if (Math.abs(touchStartX - e.stageX) > this.scrollThreshold
                || Math.abs(touchStartY - e.stageY) > this.scrollThreshold) {
                this.touchScrollH.update(e.stageX, 0, this.map.x);
                this.touchScrollV.update(e.stageY, 0, this.map.y);
                hasMoved = true;
                return;
            }
        }
    };
    MapScroller.prototype.getLineInsertPoint = function (f1, f2) {
        var x = (f1.b - f2.b) / (f2.k - f1.k);
        var y = f2.k * x + f2.b;
        return [x, y];
    };
    MapScroller.prototype.getBorderCorner = function (formulas, view) {
        var x1 = Math.abs(view.width / 2);
        var y1 = Math.abs(x1 * formulas.lt.k);
        var w = { x: x1, y: y1 };
        var y2 = Math.abs(view.height / 2);
        var x2 = Math.abs(y2 / formulas.rb.k);
        var h = { x: x2, y: y2 };
        var ret = [];
        var x, y;
        _a = this.getLineInsertPoint(formulas.lt, formulas.rt), x = _a[0], y = _a[1];
        ret[0] = [x - w.x, y + w.y];
        _b = this.getLineInsertPoint(formulas.lt, formulas.lb), x = _b[0], y = _b[1];
        ret[1] = [x + h.x, y - h.y];
        _c = this.getLineInsertPoint(formulas.lb, formulas.rb), x = _c[0], y = _c[1];
        ret[2] = [x - w.x, y - w.y - view.height];
        _d = this.getLineInsertPoint(formulas.rt, formulas.rb), x = _d[0], y = _d[1];
        ret[3] = [x - h.x - view.width, y - h.y];
        return ret;
        var _a, _b, _c, _d;
    };
    // offset， 偏移格子
    MapScroller.prototype.getLineFormulas = function (map, offset) {
        if (offset === void 0) { offset = 2; }
        var ret = { lt: null, rt: null, lb: null, rb: null };
        var _a = [map.getInfo().cols - 1, map.getInfo().rows - 1], cols = _a[0], rows = _a[1];
        var pt0 = map.cell2world(0, 0);
        var pt1 = map.cell2world(0, rows);
        var pt2 = map.cell2world(cols, 0);
        var pt3 = map.cell2world(cols, rows);
        var pto0 = map.cell2world(-offset, 0);
        var pto1 = map.cell2world(0, -offset);
        var pto2 = map.cell2world(0, rows + offset);
        var pto3 = map.cell2world(cols + offset, 0);
        var lineSet = {
            lt: [pt0, pt1, pto0],
            rt: [pt0, pt2, pto1],
            lb: [pt1, pt3, pto2],
            rb: [pt2, pt3, pto3],
        };
        for (var key in lineSet) {
            var _b = lineSet[key], p0 = _b[0], p1 = _b[1], po = _b[2];
            var k = (p0[1] - p1[1]) / (p0[0] - p1[0]);
            var b = po[1] - k * (po[0]);
            ret[key] = { k: k, b: b };
        }
        return ret;
    };
    MapScroller.prototype.getCameraRange = function (x, y) {
        var view = this;
        var formulas = this.formulas;
        var border = this.border;
        var _a = [x, y], x1 = _a[0], y1 = _a[1]; // 计算屏幕左上角坐标
        var t1 = (x1 * formulas.lt.k + formulas.lt.b); // 根据直线公式计算y
        var _b = [x + view.width, y], x2 = _b[0], y2 = _b[1]; // 计算屏幕右上角坐标
        var t2 = (x2 * formulas.rt.k + formulas.rt.b);
        var _c = [x, y + view.height], x3 = _c[0], y3 = _c[1]; // 计算屏幕左下角坐标
        var t3 = (x3 * formulas.lb.k + formulas.lb.b);
        var _d = [x + view.width, y + view.height], x4 = _d[0], y4 = _d[1]; // 计算屏幕右下角坐标
        var t4 = (x4 * formulas.rb.k + formulas.rb.b);
        // 范围内： 左上，右上，左下，右下
        var _e = [(y1 > t1), (y2 > t2), (y3 < t3), (y4 < t4)], islt = _e[0], isrt = _e[1], islb = _e[2], isrb = _e[3];
        // 边界内
        if (islt && isrt && islb && isrb) {
            return [x, y];
        }
        if (!islt && !isrt) {
            return border[0];
        }
        if (!islb && !isrb) {
            return border[2];
        }
        if (!islt) {
            var _f = [x, t1 + view.height], x3_1 = _f[0], y3_1 = _f[1]; // 计算屏幕左下角坐标
            var t3_1 = (x3_1 * formulas.lb.k + formulas.lb.b);
            if (y3_1 < t3_1) {
                y = t1;
            }
            else {
                _g = border[1], x = _g[0], y = _g[1];
            }
            ;
        }
        else if (!isrt) {
            var _h = [x + view.width, t2 + view.height], x4_1 = _h[0], y4_1 = _h[1]; // 计算屏幕右下角坐标
            var t4_1 = (x4_1 * formulas.rb.k + formulas.rb.b);
            if (y4_1 < t4_1) {
                y = t2;
            }
            else {
                _j = border[3], x = _j[0], y = _j[1];
            }
            ;
        }
        else if (!islb) {
            var _k = [x, t3 - view.height], x1_1 = _k[0], y1_1 = _k[1]; // 计算屏幕左上角坐标
            var t1_1 = (x1_1 * formulas.lt.k + formulas.lt.b);
            if (y1_1 > t1_1) {
                y = y1_1;
            }
            else {
                _l = border[1], x = _l[0], y = _l[1];
            }
            ;
        }
        else if (!isrb) {
            var _m = [x + view.width, t4 - view.height], x2_1 = _m[0], y2_1 = _m[1]; // 计算屏幕右上角坐标
            var t2_1 = (x2_1 * formulas.rt.k + formulas.rt.b);
            if (y2_1 > t2_1) {
                y = y2_1;
            }
            else {
                _o = border[3], x = _o[0], y = _o[1];
            }
            ;
        }
        return [x, y];
        var _g, _j, _l, _o;
    };
    MapScroller.prototype.buildSubMap = function (fileDatas, view) {
        for (var _i = 0, fileDatas_1 = fileDatas; _i < fileDatas_1.length; _i++) {
            var file = fileDatas_1[_i];
            var mapData = new mo.Data(file);
            var map = new mo.TMap(mapData, { width: view.width, height: view.height });
            var node = map.getNode();
            view.addChildAt(node, 0);
            this.subMaps.push(map);
        }
    };
    MapScroller.prototype.updateMapPosition = function (x, y) {
        this.map.setPos(x, y);
        this.subMaps.map(function (map) { return map.setPos(x, y); });
        if (!this.scrollCallback) {
            return;
        }
        this.scrollCallback(x, y);
    };
    MapScroller.prototype.moveToMapPosition = function (x, y, time, endFunc) {
        var _this = this;
        egret.Tween.removeTweens(this.map);
        egret.Tween.get(this.map).wait(0).to({ x: x, y: y }, time).call(function () {
            if (endFunc) {
                endFunc();
            }
            if (!_this.scrollCallback) {
                return;
            }
            _this.scrollCallback(x, y);
        });
        this.subMaps.map(function (map) {
            egret.Tween.removeTweens(map);
            egret.Tween.get(map).wait(0).to({ x: x, y: y }, time);
        });
    };
    return MapScroller;
}(eui.Group));
__reflect(MapScroller.prototype, "MapScroller");
//# sourceMappingURL=MapScroller.js.map