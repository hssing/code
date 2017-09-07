var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var Fight;
(function (Fight) {
    var FightMgr = (function () {
        function FightMgr() {
            this.roleViews = {}; //所有可见战斗集合
            this.fightIndex = 0;
        }
        //开始战斗 
        FightMgr.prototype.startFinght = function () {
            this.timer = new egret.Timer(600, 0);
            this.timer.addEventListener(egret.TimerEvent.TIMER, this.excuteFight, this);
            this.timer.start();
        };
        FightMgr.prototype.excuteFight = function () {
            // let a = [];
            // a.length
            console.log(this.fightData.length);
            if (this.fightIndex >= this.fightData.length - 1) {
                console.log(" 战斗完毕 == ");
                this.timer.stop();
                Prompt.popTip("模拟战报战斗结束");
            }
            else {
                var curFightData = this.fightData[this.fightIndex];
                var roleView = this.roleViews[curFightData.attacker_id];
                roleView.atttack(curFightData.attack_info_list);
                console.log(" key == " + curFightData.attacker_id);
                this.fightIndex++;
            }
        };
        //布阵士兵到达位置回调
        FightMgr.prototype.embattleCallBack = function (roleView, dir) {
            console.log(" 布阵士兵到达位置回调 == " + roleView.getAcDirIndex());
            roleView.setAcDirIndex(dir);
            console.log(roleView.getVO().getId() + "= 布阵士兵到达位置回调22 == " + roleView.getAcDirIndex());
            roleView.playAction();
        };
        //行走到目的地。回调布阵（看成进入战斗状态）
        FightMgr.prototype.goToTargetCallBack = function () {
            var _this = this;
            var startMainView = this.startArmyViews.getMainViews();
            var startMainVO = startMainView.getVO();
            var startMainDir = startMainView.getAcDirIndex();
            console.log("我是行走结束回调....开始布阵 = " + startMainDir);
            //8个方向
            switch (startMainDir) {
                //上下
                case 0:
                case 4:
                    break;
                case 1:
                case 5:
                    break;
                //左右
                case 2:
                case 6:
                    var curRoleView = startMainView;
                    var nextRoleView = this.startArmyViews.getNextRoleView(curRoleView);
                    var index_1 = -1;
                    var _a = startMainView.getVO().getCellXY(), cellX_1 = _a[0], cellY_1 = _a[1];
                    //TODO 待优化
                    while (nextRoleView) {
                        var curCellX = cellX_1 + index_1;
                        var curCellY = cellY_1 + index_1;
                        index_1 = 1;
                        curRoleView = nextRoleView;
                        curRoleView.disFrontRoleView(); //取消跟随
                        curRoleView._moveOnePath(curCellX, curCellY, function (curView) {
                            _this.embattleCallBack(curView, startMainDir);
                        });
                        nextRoleView = this.startArmyViews.getNextRoleView(curRoleView);
                    }
                    break;
                case 3:
                case 7:
                    break;
            }
            //------------------------------------
            //设置被攻击者  TODO 待优化
            //------------------------------------
            var targetSelectView = this.targetArmyViews.getSelectView();
            var targetSelectViewDir = 0;
            if (startMainDir >= 4) {
                targetSelectViewDir = startMainDir - 4;
            }
            else {
                targetSelectViewDir = startMainDir + 4;
            }
            targetSelectView.disFrontRoleView();
            targetSelectView.setAcDirIndex(targetSelectViewDir);
            targetSelectView.playAction();
            var targetOtherViews = this.targetArmyViews.getOtherRoleView(targetSelectView);
            var _b = targetSelectView.getVO().getCellXY(), cellX = _b[0], cellY = _b[1];
            var index = -1;
            for (var k in targetOtherViews) {
                var curCellX = cellX + index;
                var curCellY = cellY + index;
                index = 1;
                var curRoleView = targetOtherViews[k];
                curRoleView.disFrontRoleView(); //取消跟随
                curRoleView._moveOnePath(curCellX, curCellY, function (curView) {
                    _this.embattleCallBack(curView, targetSelectViewDir);
                });
            }
            //--------------------
            //TODO  这种攻击目标 
            //--------------------
            // startMainView.setAttackView(targetSelectView);
            // targetSelectView.setAttackView(startMainView);
            var fightTest = new Fight.FightTest();
            this.fightData = fightTest.calculateFightData(this.startArmyViews, this.targetArmyViews);
            // console.log(this.fightData.lenght);
            egret.setTimeout(function () {
                this.startFinght();
            }, this, 3000);
        };
        //追踪到目的地。
        FightMgr.prototype.goToTarget = function (startArmyViews, targetArmyViews) {
            var _this = this;
            this.startArmyViews = startArmyViews;
            this.targetArmyViews = targetArmyViews;
            utils.mergeObject(this.startArmyViews.getRoleViews(), this.roleViews);
            utils.mergeObject(this.targetArmyViews.getRoleViews(), this.roleViews);
            var nearView = this.findNearCell(startArmyViews, targetArmyViews);
            var startView = startArmyViews.getMainViews();
            var _a = this.findRoundNearCell(startView, nearView), targetCellX = _a[0], targetCellY = _a[1];
            startView._moveOnePath(targetCellX, targetCellY, function () { return _this.goToTargetCallBack(); });
        };
        //查找最近附近格子
        FightMgr.prototype.findRoundNearCell = function (startView, targetView) {
            var _a = startView.vo.getCellXY(), srcCellX = _a[0], srcCellY = _a[1]; //源坐标点
            var _b = targetView.vo.getCellXY(), cellX = _b[0], cellY = _b[1];
            //改点周围8个点全判断。暂时这样。可以优化
            //TODO 需优化
            var min_x = cellX - 1;
            var max_x = cellX + 1;
            var min_y = cellY - 1;
            var max_y = cellY + 1;
            var finalX, finalY;
            var temp_dis = undefined;
            for (var i = min_x; i <= max_x; i++) {
                for (var j = min_y; j <= max_y; j++) {
                    if (temp_dis !== undefined) {
                        var new_dis = this.disTowPoint(srcCellX, srcCellY, i, j);
                        if (new_dis < temp_dis) {
                            temp_dis = new_dis;
                            finalX = i;
                            finalY = j;
                        }
                    }
                    else {
                        temp_dis = this.disTowPoint(srcCellX, srcCellY, i, j);
                        finalX = i;
                        finalY = j;
                    }
                }
            }
            return [finalX, finalY];
        };
        //查找目标方阵最近方阵
        FightMgr.prototype.findNearCell = function (startViews, targetViews) {
            var startMainView = startViews.getMainViews();
            var nearView;
            var roleViews = targetViews.getRoleViews();
            for (var key in roleViews) {
                var curView = roleViews[key];
                if (nearView) {
                    var lastDis = this.disTowView(startMainView, nearView);
                    var nowDis = this.disTowView(startMainView, curView);
                    if (nowDis < lastDis) {
                        nearView = curView;
                    }
                }
                else {
                    nearView = curView;
                }
            }
            targetViews.setSelectView(nearView); //目标最近方阵
            return nearView;
        };
        //算两个方阵直线距离
        FightMgr.prototype.disTowView = function (thisView, otherView) {
            var dis = this.disTowPoint(thisView.vo.getX(), thisView.vo.getY(), otherView.vo.getX(), otherView.vo.getY());
            return dis;
        };
        //两点直线距离
        FightMgr.prototype.disTowPoint = function (x1, y1, x2, y2) {
            var disX = Math.abs(x1 - x2);
            var disY = Math.abs(y1 - y2);
            var dis = Math.sqrt(disX * disX + disY * disY);
            return dis;
        };
        //加入战斗 
        FightMgr.prototype.addWar = function (addId) {
        };
        //退出战斗
        FightMgr.prototype.outWar = function () {
        };
        return FightMgr;
    }());
    Fight.FightMgr = FightMgr;
    __reflect(FightMgr.prototype, "Fight.FightMgr");
})(Fight || (Fight = {}));
//# sourceMappingURL=FightMgr.js.map