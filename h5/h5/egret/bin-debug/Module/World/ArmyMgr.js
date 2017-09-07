var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var world;
(function (world) {
    var ArmyMgr = (function () {
        function ArmyMgr(mgr, root) {
            this.manager = mgr;
            this.root = root;
            this.views = {}; //方阵 views ？
            this.amryViews = {}; //部队列表
            this.data = {};
            /*** 本示例关键代码段开始 ***/
            this.timer = new egret.Timer(1000, 0);
            this.timer.addEventListener(egret.TimerEvent.TIMER, this.resetChildIndex, this);
            this.timer.start();
        }
        ArmyMgr.prototype.dispose = function () {
        };
        ArmyMgr.prototype.recycle = function (data) {
            // for (let k in this.views) { 
            //     if (!data[k]) {
            //         this.removeArmy(k);
            //     }
            // }
            for (var k in this.amryViews) {
                if (!data[k]) {
                    this.removeArmy(k);
                }
            }
        };
        ArmyMgr.prototype.updatePath = function (info) {
            if (this.amryViews[info.army_id]) {
                if (info.status === 1) {
                    info.status = 0;
                    this.amryViews[info.army_id].updatePath(info);
                }
            }
        };
        // public updateArmyData(data: any): void {
        //     // console.log("armyId ==== " + data.armyId);
        //     for (let k in data){
        //         this.amryViews[data.armyId] = new ArmyView(data[k],this.manager,this.root);
        //         this.amryViews[data.armyId].mergeViews(this.views);
        //     }
        // }
        ArmyMgr.prototype.updateData = function (data) {
            // for (let k in data) {
            //     this.updateArmy(k, data[k]);
            // }
            for (var k in data) {
                if (this.amryViews[k]) {
                    this.amryViews[k].setData(data[k]);
                    this.amryViews[k].refresh();
                }
                else {
                    this.amryViews[k] = new ArmyView(data[k], this.manager, this.root);
                    this.amryViews[k].mergeViews(this.views);
                }
            }
            this.recycle(data);
        };
        ArmyMgr.prototype.updateArmy = function (k, info) {
            //oldCreate 
            if (this.views[k]) {
                this.views[k].setData(info);
                this.views[k].refresh();
            }
            else {
                this.views[k] = this.buildArmy(info);
            }
            //new create
            // if (this.amryViews[k]) {
            //     // this.amryViews[k].setData(info);
            //     // this.amryViews[k].refresh();
            // }else {
            //     //new create
            //     this.amryViews[k] = new ArmyView(info,this.manager,this.root);
            //     this.amryViews[k].mergeViews(this.views);
            // }   
        };
        ArmyMgr.prototype.buildArmy = function (info) {
            return new world.Army(this.manager, this.root, info);
        };
        ArmyMgr.prototype.removeArmy = function (armyId) {
            // this.views[armyId].dispose();
            // delete this.views[armyId];
            this.amryViews[armyId].dispose();
            var views = this.amryViews[armyId].getRoleViews();
            for (var k in views) {
                delete this.views[k];
            }
            delete this.amryViews[armyId];
        };
        //TODO 待优化
        ArmyMgr.prototype.resetChildIndex = function () {
            var views = this.getViews();
            var viewsArr = [];
            var i = 0;
            for (var k in views) {
                // console.log(  k + "== k == " +   this.manager.getArmyMgr().getRoot().getChildIndex( views[k]));
                // (views[k] as RoleView).vo.getY;
                viewsArr[i] = views[k];
                i++;
            }
            var len = viewsArr.length;
            // console.log("len === " + len);
            for (var i_1 = 0; i_1 < len; i_1++) {
                for (var j = i_1 + 1; j < len; j++) {
                    if (viewsArr[i_1].vo.getY() > viewsArr[j].vo.getY()) {
                        this.swap(viewsArr, i_1, j);
                    }
                }
            }
            for (var i_2 = 0; i_2 < len; i_2++) {
                viewsArr[i_2].parent.setChildIndex(viewsArr[i_2], i_2);
            }
        };
        ArmyMgr.prototype.swap = function (array, first, second) {
            var tmp = array[second];
            array[second] = array[first];
            array[first] = tmp;
            // return array; 
        };
        ArmyMgr.prototype.getViews = function () {
            return this.views;
        };
        ArmyMgr.prototype.getRoot = function () {
            return this.root;
        };
        ArmyMgr.prototype.getArmyViews = function () {
            return this.amryViews;
        };
        return ArmyMgr;
    }());
    world.ArmyMgr = ArmyMgr;
    __reflect(ArmyMgr.prototype, "world.ArmyMgr");
})(world || (world = {}));
//# sourceMappingURL=ArmyMgr.js.map