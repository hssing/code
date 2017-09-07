// TypeScript file
/**
 *部队
 */
var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var ArmyView = (function () {
    function ArmyView(data, manager, root) {
        this.roleViews = {}; // key -- view
        this.countIndex = 0; //
        //自动行走频率
        this.autoMoveHz = 650; //自动行走频率
        this.statue = 0; //部队状态。。 0- 普通   1-战斗 2-逃跑 3-死亡
        this.data = data;
        this.manager = manager;
        this.root = root;
        this.createArmy();
        this.refresh();
    }
    //创建部队。一个部队有多个方阵
    ArmyView.prototype.createArmy = function () {
        // let soldiers = [this.data.forward_phalanx]//,this.data.center_phalanx,this.data.back_phalanx]; //[{soldiers_id: 1, hp: 100, max_hp: 100},{soldiers_id: 2, hp: 100, max_hp: 100},{soldiers_id: 3, hp: 100, max_hp: 100}]//this.data.soldiers;
        var soldiers = [{ soldiers_id: 1, hp: 100, max_hp: 100 }, { soldiers_id: 2, hp: 100, max_hp: 100 }, { soldiers_id: 3, hp: 100, max_hp: 100 }]; //this.data.soldiers;
        this.army_id = this.data.army_id;
        var backRole = undefined;
        var temp_i = 0;
        for (var _i = 0, soldiers_1 = soldiers; _i < soldiers_1.length; _i++) {
            var v = soldiers_1[_i];
            temp_i++;
            var role = new RoleView(this.root);
            var armyID = this.army_id + '' + (v.soldiers_id + temp_i);
            this.roleViews[armyID] = role;
            this.root.addChild(role);
            var wpos = this.manager.getWorldMap().cell2world(this.data.cur_point.x, this.data.cur_point.y);
            var vo = new PlayerVO();
            vo.setXY(wpos[0], wpos[1]);
            //  role.vo.setId(this.army_id);
            vo.setCellXY(this.data.cur_point.x, this.data.cur_point.y);
            var vo_temp = new PlayerVO();
            vo.setId(parseInt(armyID));
            role.updateVO(vo, vo_temp);
            if (!this.mainRole) {
                this.mainRole = role;
            }
            //重设跟随关系
            if (backRole) {
                role.setFrontRoleView(backRole);
            }
            backRole = role;
        }
        //test automove
        // this.root.stage.addEventListener(egret.Event.ENTER_FRAME,this.frameExecute,this);  
    };
    ArmyView.prototype.frameExecute = function () {
        // console.log(" frameExecute  ===== " + this.data.armyId);
        this.countIndex++;
        if (this.countIndex % this.autoMoveHz === 0) {
            var rX = Math.floor(Math.random() * 10);
            var rY = Math.floor(Math.random() * 10);
            var key = '0';
            for (var k in this.roleViews) {
                key = k;
                break;
            }
            var data01 = { role_id: key, move_path: [{ x: rX, y: rY }], };
            UIMgr.getWorld().onActorMove(data01);
        }
    };
    ArmyView.prototype.setData = function (data) {
        this.data = data;
    };
    ArmyView.prototype.refresh = function () {
        if (this.data.status === 1) {
            this.data.status = 0;
            this.mainRole.updatePath(this.data);
        }
    };
    ArmyView.prototype.updatePath = function (data) {
        this.mainRole.updatePath(data);
    };
    ArmyView.prototype.mergeViews = function (o) {
        utils.mergeObject(this.roleViews, o);
    };
    //获取主方阵
    ArmyView.prototype.getMainViews = function () {
        var keys = new Array();
        for (var key in this.roleViews) {
            keys.push(key);
        }
        return this.roleViews[keys[0]];
    };
    ArmyView.prototype.getRoleViews = function () {
        return this.roleViews;
    };
    //拿到当前role的下一个role
    ArmyView.prototype.getNextRoleView = function (roleView) {
        var keys = new Array();
        for (var key in this.roleViews) {
            keys.push(key);
        }
        for (var i = 0; i < keys.length; i++) {
            if (i < keys.length - 1 && roleView === this.roleViews[keys[i]]) {
                return this.roleViews[keys[i + 1]];
            }
        }
        return undefined;
    };
    //获得出roleView 的其他View
    ArmyView.prototype.getOtherRoleView = function (roleView) {
        var rViews = {};
        for (var key in this.roleViews) {
            if (this.roleViews[key] !== roleView) {
                rViews[key] = this.roleViews[key];
            }
        }
        return rViews;
    };
    ArmyView.prototype.setSelectView = function (rView) {
        this.selectView = rView;
    };
    ArmyView.prototype.getSelectView = function () {
        return this.selectView;
    };
    ArmyView.prototype.dispose = function () {
        for (var k in this.roleViews) {
            this.roleViews[k].dispose();
        }
    };
    return ArmyView;
}());
__reflect(ArmyView.prototype, "ArmyView");
//# sourceMappingURL=ArmyView.js.map