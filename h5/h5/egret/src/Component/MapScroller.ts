class MapScroller extends eui.Group {
    
    private map: mo.TMap;
    private formulas: any;
    private border: any;
    private scrollCallback: Function;
    private touchScrollH: world.TouchScroll;
    private touchScrollV: world.TouchScroll;
    private scrollThreshold = 5;

    public constructor() {
        super();
        this.touchScrollH = new world.TouchScroll(this.horizontalUpdateHandler, this.horizontalEndHandler, this);
        this.touchScrollV = new world.TouchScroll(this.verticalUpdateHandler, this.verticalEndHanlder, this);
        this.touchScrollH.$bounces = false;
        this.touchScrollV.$bounces = false;
        this.touchScrollH.$scrollFactor = 0.3;
        this.touchScrollV.$scrollFactor = 0.3;
    }

    private horizontalUpdateHandler(scrollPos: number): void {
        let [x, y] = this.getCameraRange(scrollPos, this.map.y);
        this.updateMapPosition(x, y);
    }

    private horizontalEndHandler(): void {
    }

    private verticalUpdateHandler(scrollPos: number): void {
        let [x, y] = this.getCameraRange(this.map.x, scrollPos);
        this.updateMapPosition(x, y);
    }

    private verticalEndHanlder(): void {
    }

    // 设置地图世界坐标，限定地图边界范围
    public setPosWithCheckRange(x: number, y: number) {
        let border = this.getCameraRange(x, y);
        this.updateMapPosition(border[0], border[1]);
    }

    // todo@ 带动画
    public setPosWithAnimat(x: number, y: number, time: number, endFunc?: Function) {
        let centPos = [x - this.width / 2, y - this.height / 2]
        let border = this.getCameraRange(centPos[0], centPos[1]);
        this.moveToMapPosition(border[0], border[1], time, endFunc);
    }

    // cx, cy 在地图边界范围内居中屏幕
    public setCell2Center(cx: number, cy: number) {
        let wpos = this.map.cell2world(cx, cy);
        let centPos = [wpos[0] - this.width / 2, wpos[1] - this.height / 2]
        let border = this.getCameraRange(centPos[0], centPos[1]);
        this.updateMapPosition(border[0], border[1]);
    }

    public getCenterWPos(x: number, y: number): number[] {
        return [x - this.width / 2, y - this.height / 2];
    }

    public registScrollCallback(c: Function): void {
        this.scrollCallback = c;
    }

    public setViewSize(sz: mo.Size): void {
        this.width = sz.width;
        this.height = sz.height;

        this.map.setViewSize(sz);
        this.map.update();
        this.subMaps.map(map => map.setViewSize(sz));
        this.subMaps.map(map => map.update());

        this.formulas = this.getLineFormulas(this.map, config.MAP_BORDER_OFFSET);
        this.border = this.getBorderCorner(this.formulas, this);
    }

    // 获取地图对象
    public getMap(): mo.TMap {
        return this.map;
    }

    public dispose(): void {
        this.map.dispose();
        this.map = null;
        this.subMaps.map(map => map.dispose());
        this.subMaps = [];
    }

    // 创建地图
    public buildMap(file: any, subMapData: any, parent: any): void {
        let scene = parent;
        let view = this;
        
        // view.scrollEnabled = true;
        view.width = scene.width;
        view.height = scene.height;
        view.x = scene.width / 2;
        view.y = scene.height / 2;
        view.anchorOffsetX = view.width / 2;
        view.anchorOffsetY = view.height / 2;
    
        scene.addChild(view);

        let mapData = Singleton(mo.Data, file);
        let map = new mo.TMap(mapData, {width : view.width, height : view.height});
        let node = map.getNode() as eui.Group;
        view.addChild(node);
        this.map = map;

        let sctrl = new eui.Group();
        node.addChild(sctrl);
        sctrl.name = "MapTouchController";

        // 扩大触摸区域
        sctrl.width = node.width * 3;
        sctrl.height = node.height * 3;
        sctrl.anchorOffsetX = sctrl.width / 2;
        sctrl.anchorOffsetY = sctrl.height / 2;

        this.buildSubMap(subMapData, view);
        let wpos = map.cell2world(0, 0);
        this.updateMapPosition(wpos[0], wpos[1]);

        let touchStartX: number = 0;
        let touchStartY: number = 0;
        let hasMoved = false;
        //手指按到屏幕，触发 startMove 方法
        sctrl.touchEnabled = true;

        sctrl.addEventListener(egret.TouchEvent.TOUCH_BEGIN, startMove, this);
        //手指离开屏幕，触发 stopMove 方法
        sctrl.addEventListener(egret.TouchEvent.TOUCH_END, stopMove, this);
        // map.registTouchEvent();
        function startMove(e: egret.TouchEvent): void{
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

        function stopMove(e: egret.TouchEvent): void {
            //手指离开屏幕，移除手指移动的监听
            sctrl.removeEventListener(egret.TouchEvent.TOUCH_MOVE, onMove, this);
            if (!hasMoved) {
                map.touchTap(e);
            }
            this.touchScrollH.finish(this.map.x, 0);
            this.touchScrollV.finish(this.map.y, 0);
        }

        function onMove(e: egret.TouchEvent): void {
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
    }

    private getLineInsertPoint(f1, f2) {
        let x = (f1.b - f2.b) / (f2.k - f1.k);
        let y = f2.k * x + f2.b;
        return [x, y];
    }

    private getBorderCorner(formulas, view: eui.Group) {
        let x1 = Math.abs(view.width / 2);
        let y1 = Math.abs(x1 * formulas.lt.k);
        let w = {x : x1, y : y1};

        let y2 = Math.abs(view.height / 2);
        let x2 = Math.abs(y2 / formulas.rb.k);
        let h = {x : x2, y : y2};

        let ret = [];

        let x, y;
        [x, y] = this.getLineInsertPoint(formulas.lt, formulas.rt);
        ret[0] = [x - w.x, y + w.y];
      
        [x, y] = this.getLineInsertPoint(formulas.lt, formulas.lb);
        ret[1] = [x + h.x, y - h.y];

        [x, y] = this.getLineInsertPoint(formulas.lb, formulas.rb);
        ret[2] = [x - w.x, y - w.y - view.height];

        [x, y] = this.getLineInsertPoint(formulas.rt, formulas.rb);
        ret[3] = [x - h.x - view.width, y - h.y ];
        return ret;
    }

    // offset， 偏移格子
    private getLineFormulas(map: mo.TMap, offset: number = 2) {
        let ret = {lt : null, rt : null, lb : null, rb : null};

        let [cols, rows] = [map.getInfo().cols-1, map.getInfo().rows-1]
        let pt0 = map.cell2world(0, 0);
        let pt1 = map.cell2world(0, rows);
        let pt2 = map.cell2world(cols, 0);
        let pt3 = map.cell2world(cols, rows);

        let pto0 = map.cell2world(-offset, 0);
        let pto1 = map.cell2world(0, -offset);
        let pto2 = map.cell2world(0, rows + offset);
        let pto3 = map.cell2world(cols + offset, 0);

        let lineSet = {
            lt : [pt0, pt1, pto0],  // y > x
            rt : [pt0, pt2, pto1],  // y > x
            lb : [pt1, pt3, pto2],  // y < x
            rb : [pt2, pt3, pto3],  // y < x
        }

        for (let key in lineSet) {
            let [p0, p1, po] = lineSet[key];
            let k = (p0[1] - p1[1]) / (p0[0] - p1[0]);
            let b = po[1] - k * (po[0]);
            ret[key] = {k : k, b : b};
        }

        return ret;
    }

    private getCameraRange(x: number, y: number): any {
        let view = this;
        let formulas = this.formulas;
        let border = this.border;

        let [x1, y1] = [x, y];    // 计算屏幕左上角坐标
        let t1 = (x1 * formulas.lt.k + formulas.lt.b); // 根据直线公式计算y

        let [x2, y2] = [x + view.width, y]; // 计算屏幕右上角坐标
        let t2 = (x2 * formulas.rt.k + formulas.rt.b);

        let [x3, y3] = [x, y + view.height];  // 计算屏幕左下角坐标
        let t3 = (x3 * formulas.lb.k + formulas.lb.b);

        let [x4, y4] = [x + view.width, y + view.height]; // 计算屏幕右下角坐标
        let t4 = (x4 * formulas.rb.k + formulas.rb.b);
        
        // 范围内： 左上，右上，左下，右下
        let [islt, isrt, islb, isrb] = [(y1 > t1), (y2 > t2), (y3 < t3), (y4 < t4)];

        // 边界内
        if (islt && isrt && islb && isrb) {
            return [x, y];
        }

        if (!islt && !isrt) {
            return border[0];
        }
        if(!islb && !isrb) {
            return border[2];
        }

        if (!islt) { // && lb
            let [x3, y3] = [x, t1 + view.height];  // 计算屏幕左下角坐标
            let t3 = (x3 * formulas.lb.k + formulas.lb.b);
            if (y3 < t3) { y = t1; } else { [x, y] = border[1] };
        }
        else if(!isrt) { // && rb
            let [x4, y4] = [x + view.width, t2 + view.height]; // 计算屏幕右下角坐标
            let t4 = (x4 * formulas.rb.k + formulas.rb.b);
            if (y4 < t4) { y = t2; } else { [x, y] = border[3] };
        }
        else if(!islb) { // && lt
            let [x1, y1] = [x, t3 - view.height];    // 计算屏幕左上角坐标
            let t1 = (x1 * formulas.lt.k + formulas.lt.b);
            if (y1 > t1) { y = y1; } else { [x, y] = border[1] };
        }
        else if(!isrb) { // && rt
            let [x2, y2] = [x + view.width, t4 - view.height]; // 计算屏幕右上角坐标
            let t2 = (x2 * formulas.rt.k + formulas.rt.b);
            if (y2 > t2) { y = y2; } else { [x, y] = border[3] };
        }
        
        return [x, y];
    }

    // Sub Map
    private subMaps: Array<mo.TMap> = [];

    private buildSubMap(fileDatas: any, view): void {
        for (let file of fileDatas) {
            let mapData = new mo.Data(file);
            let map = new mo.TMap(mapData, {width : view.width, height : view.height});
            let node = map.getNode() as eui.Group;
            view.addChildAt(node, 0);
            this.subMaps.push(map);
        }
    }

    private updateMapPosition(x: number, y: number): void {
        this.map.setPos(x, y);
        this.subMaps.map(map => map.setPos(x, y));
        if (!this.scrollCallback) { return; }
        this.scrollCallback(x, y);
    }

    private moveToMapPosition(x: number, y: number, time: number, endFunc: Function): void {
        egret.Tween.removeTweens(this.map);
        egret.Tween.get(this.map).wait(0).to({x, y}, time).call(()=> {
            if(endFunc) { endFunc(); }
            if (!this.scrollCallback) { return; }
            this.scrollCallback(x, y);
        });

        this.subMaps.map(map =>{
            egret.Tween.removeTweens(map);
            egret.Tween.get(map).wait(0).to({x, y}, time)
        });
    }



}
