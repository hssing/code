// TypeScript file
var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
/**
 *
 * 人物类
 *
 */
var PlayerView = (function (_super) {
    __extends(PlayerView, _super);
    function PlayerView(root) {
        var _this = _super.call(this) || this;
        _this.vo = new PlayerVO();
        _this.vo_temp = new PlayerVO();
        _this.is8Dir = true; //测试8 个方向  false-12方向  true-8方向
        _this.acName = ["idle", "run", "attack"];
        //6个方向
        _this.acDir = ["up", "up_45", "right",
            "down_45", "down", "down_45",
            "right", "up_45",];
        _this.acNameIndex = 0; //当前动作
        _this.acDirIndex = 0; //当前方向
        _this.timeOnEnterFrame = 0; //最后角色移动动画结束时间  
        _this.needChangeAction = false; //是否需要切换动画
        _this.moveSpeed = 0.25; //移动速度
        _this.moveTimeOneCell = 2000; //毫秒
        _this.moveSpeedX = 0;
        _this.moveSpeedY = 0;
        _this.moveDisX = 0; //x y轴移动距离
        _this.moveDisY = 0;
        _this.targetX = 0; //目标点坐标
        _this.targetY = 0;
        _this.actions = []; //动画单位数组
        //服务返回行走路径
        _this.moveIndex = 0;
        _this.move_path = [];
        //行军跟随 
        _this.points = [];
        _this.queueFollowMaxFrameLength = 150; //队列跟随最大帧数     
        _this.saveAllFollowFrame = 200; //跟随最大帧
        //回调方法
        _this.goToTargetCallBack = undefined;
        _this.width = mo.TMap.getMainData().getResult().info.cw;
        _this.height = mo.TMap.getMainData().getResult().info.ch;
        _this.anchorOffsetX = _this.width / 2;
        _this.anchorOffsetY = _this.height / 2;
        _this.init();
        _this.root = root;
        PlayerView.static_index++;
        _this.shape = new egret.Shape();
        _this.root.addChild(_this.shape);
        return _this;
        // this.timer = new egret.Timer(3000, 0);
        // this.timer.addEventListener(egret.TimerEvent.TIMER, this.timerFunc, this);       
        // this.timer.start();
    }
    // private timerFunc(event: egret.Event) {
    //     // console.log(this.vo.getId() +" == 我是定时器......");
    //     //如果有攻击目标
    //     if (this.getAttackView()) {
    //         for (let i = 0 ; i < this.actions.length ; i++) {
    //             let action = this.actions[i];
    //             if (action.hasEventListener(egret.Event.LOOP_COMPLETE)){
    //                 console.log("存在事件...");
    //             }else{
    //                 console.log("不存在事件...");
    //                 action.addEventListener(egret.Event.LOOP_COMPLETE,(e)=>{ 
    //                     //寻找被击打目标。执行掉血
    //                     this.setAcNameIndex(0);
    //                     action.movieClipData = this.mcDataFactory.generateMovieClipData(this.acName[this.acNameIndex] + "_" + this.acDir[this.acDirIndex]);
    //                     action.gotoAndPlay(1,-1);    
    //                 } , this);                    
    //             }
    //         }
    //        this.setAcNameIndex(2);
    //        this.playAction();  
    //     }
    // }     
    PlayerView.prototype.atttack = function (attack_info_list) {
        // console.log(this.vo.getId() +" == 我是定时器......");
        var _this = this;
        //如果有攻击目标
        if (this.getAttackView()) {
            var damage_info_list = attack_info_list.damage_info_list;
            var defender_hp = damage_info_list.defender_hp;
            var damage = damage_info_list.damage;
            var _loop_1 = function (i) {
                var action = this_1.actions[i];
                if (action.hasEventListener(egret.Event.LOOP_COMPLETE)) {
                    console.log("存在事件...");
                }
                else {
                    console.log("不存在事件...");
                    action.addEventListener(egret.Event.LOOP_COMPLETE, function (e) {
                        //寻找被击打目标。执行掉血
                        _this.setAcNameIndex(0);
                        action.movieClipData = _this.mcDataFactory.generateMovieClipData(_this.acName[_this.acNameIndex] + "_" + _this.acDir[_this.acDirIndex]);
                        action.gotoAndPlay(1, -1);
                    }, this_1);
                }
            };
            var this_1 = this;
            for (var i = 0; i < this.actions.length; i++) {
                _loop_1(i);
            }
            var targetView = this.getAttackView();
            targetView.hurtAndRefresh(damage);
            targetView.vo.setCurHp(defender_hp);
            Prompt.popTip(targetView.getVO().getId() + "掉血" + damage);
            this.setAcNameIndex(2);
            this.playAction();
        }
    };
    //初始化 角色数据
    PlayerView.prototype.updateVO = function (vo, temp_vo) {
        //  this.vo.setId(vo.role_id);
        //  this.vo.setXY(vo.x,vo.y);
        this.vo = vo;
        this.vo_temp = temp_vo;
        _a = this.vo.getXY(), this.x = _a[0], this.y = _a[1];
        var _a;
    };
    PlayerView.prototype.getVO = function () {
        return this.vo;
    };
    PlayerView.prototype.getVO_temp = function () {
        return this.vo_temp;
    };
    //如果需要切换方向与当前方向一直。则不需要操作
    PlayerView.prototype.setAcDirIndex = function (acDirIndex) {
        if (this.acDirIndex !== acDirIndex) {
            this.needChangeAction = true;
            this.acDirIndex = acDirIndex;
        }
    };
    //如果需要切换动作与当前方向一直。则不需要操作
    PlayerView.prototype.setAcNameIndex = function (acNameIndex) {
        if (this.acNameIndex !== acNameIndex) {
            this.needChangeAction = true;
            this.acNameIndex = acNameIndex;
        }
    };
    PlayerView.prototype.getAcDirIndex = function () {
        return this.acDirIndex;
    };
    PlayerView.prototype.getAcNameIndex = function () {
        return this.acNameIndex;
    };
    PlayerView.prototype.setAttackView = function (attackView) {
        this.attackView = attackView;
    };
    PlayerView.prototype.getAttackView = function () {
        return this.attackView;
    };
    PlayerView.prototype.setMoveSpeed = function (moveSpeed) {
        this.moveSpeed = moveSpeed;
    };
    PlayerView.prototype.getMoveSpeed = function () {
        return this.moveSpeed;
    };
    PlayerView.prototype.init = function () {
        this.createPlayer();
    };
    PlayerView.prototype.createPlayer = function () {
        this.initMovieClip();
    };
    PlayerView.prototype.initMovieClip = function () {
        var self = this;
        this._mcData = RES.getRes("role_" + this.vo.getModelId() + "_json"); //JSON  
        this._mcTexture = RES.getRes("role_" + this.vo.getModelId() + "_png"); //Texture         
        this.mcDataFactory = new egret.MovieClipDataFactory(this._mcData, this._mcTexture);
        var unitCount = this.vo.getUnitCount();
        this.acDirIndex = Math.floor((Math.random() * 10) % 7);
        //构建小地图, N维方阵， 偏移 ox, oy，用于微调部队位置
        var coordinate = UIMgr.getWorld().getMap().createCoordinate(Math.sqrt(unitCount), 0, 0);
        this.info = coordinate.getInfo();
        for (var i = 0; i < unitCount; i++) {
            var action = new egret.MovieClip(this.mcDataFactory.generateMovieClipData(this.acName[this.acNameIndex] + "_" + this.acDir[this.acDirIndex])); //run_l_d_d
            this.addChild(action);
            action.scaleX = 0.7;
            action.scaleY = 0.7;
            this.actions.push(action);
            var _a = coordinate.index2cell(i), x = _a[0], y = _a[1];
            var _b = coordinate.cell2world(x, y), x1 = _b[0], y1 = _b[1];
            action.x = x1;
            action.y = y1;
            action.gotoAndPlay(1, -1);
        }
        //血槽 
        this.progressBar = new ProgressBar();
        this.progressBar.setProgress(this.vo.getPecentHp());
        var scale = 0.4;
        this.progressBar.scaleX = scale;
        this.progressBar.scaleY = scale;
        this.progressBar.anchorOffsetX = this.progressBar.width / 2;
        this.progressBar.x = this.width / 2;
        this.addChild(this.progressBar);
    };
    //服务器返回人物移动
    PlayerView.prototype.updatePath = function (data) {
        this.move_path = data.move_path;
        this.moveIndex = 0; //行走下标重置
        this.moveOnePath();
    };
    //路径分解
    PlayerView.prototype.moveOnePath = function () {
        var cellX = this.move_path[this.moveIndex].x;
        var cellY = this.move_path[this.moveIndex].y;
        this._moveOnePath(cellX, cellY);
    };
    PlayerView.prototype._moveOnePath = function (cellX, cellY, callBack) {
        this.goToTargetCallBack = callBack;
        var _a = UIMgr.getWorld().getMap().cell2world(cellX, cellY), targetX = _a[0], targetY = _a[1];
        this.vo.setCellXY(cellX, cellY);
        if (targetX === this.x && targetY === this.y) {
            return;
        }
        this.stage.removeEventListener(egret.Event.ENTER_FRAME, this.bgMove, this);
        // this.acNameIndex = 1;
        this.setAcNameIndex(1);
        this.targetX = targetX;
        this.targetY = targetY;
        var disX = Math.abs(this.targetX - this.x);
        var disY = Math.abs(this.targetY - this.y);
        this.towPointDis = Math.sqrt(disX * disX + disY * disY); //两点距离
        var _b = UIMgr.getWorld().getMap().world2cell(this.x, this.y), curCellX = _b[0], curCellY = _b[1];
        var xCellNum = Math.abs(cellX - curCellX);
        var yCellNum = Math.abs(cellY - curCellY);
        this.towPointCellNum = xCellNum > yCellNum ? xCellNum : yCellNum;
        this.moveDisX = targetX - this.x;
        this.moveDisY = targetY - this.y;
        //斜边长
        var xiexianDis = Math.sqrt(this.moveDisX * this.moveDisX + this.moveDisY * this.moveDisY);
        this.moveSpeedX = this.moveDisX / xiexianDis * this.moveSpeed;
        this.moveSpeedY = this.moveDisY / xiexianDis * this.moveSpeed;
        // this.acDirIndex = this.calculateDir(this.moveDisX,this.moveDisY,xiexianDis);
        this.setAcDirIndex(this.calculateDir(this.moveDisX, this.moveDisY, xiexianDis));
        // egret.log(this.acDirIndex);
        this.playAction();
        this.timeOnEnterFrame = egret.getTimer();
        this.stage.addEventListener(egret.Event.ENTER_FRAME, this.bgMove, this);
        this.moveIndex++;
    };
    PlayerView.prototype.calculateDis = function () {
    };
    PlayerView.prototype.calculateSpeed = function (useTime) {
        return this.towPointDis / (this.moveTimeOneCell * this.towPointCellNum) * useTime;
    };
    //计算人物角度
    PlayerView.prototype.calculateDir = function (moveDisX, moveDisY, xiexianDis) {
        var angelTotal = 0; // 区块矫正 角度
        if (moveDisX >= 0) {
            if (moveDisY >= 0) {
                var angle = utils.MahtSin(moveDisY, xiexianDis);
                angelTotal = angle + 90;
            }
            else {
                // console.log('moveDisY == ' + moveDisY);
                var angle = utils.MahtSin(moveDisY, xiexianDis);
                // console.log('angle == ' + angle);
                angelTotal = angle + 90;
            }
        }
        else {
            if (moveDisY > 0) {
                var angle = utils.MahtSin(moveDisX, xiexianDis);
                angelTotal = Math.abs(angle) + 180;
            }
            else {
                var angle = utils.MahtSin(moveDisX, xiexianDis);
                angelTotal = 360 + angle;
            }
        }
        angelTotal = (angelTotal + 22.5) % 361;
        var dirIndex = Math.ceil((angelTotal) / (45));
        return dirIndex - 1;
    };
    PlayerView.prototype.bgMove = function (evt) {
        var now = egret.getTimer();
        var pass = this.timeOnEnterFrame;
        var useTime = now - pass;
        // if (this.towPointDis > 100){
        //     this.setMoveSpeed(0.5);
        // }else{
        //速度
        var moveSp = 1.1; //= this.calculateSpeed(useTime);
        this.setMoveSpeed(moveSp);
        // console.log("moveSp ======================= " + moveSp);
        //斜边长
        var xiexianDis = Math.sqrt(this.moveDisX * this.moveDisX + this.moveDisY * this.moveDisY);
        this.moveSpeedX = this.moveDisX / xiexianDis * this.moveSpeed;
        this.moveSpeedY = this.moveDisY / xiexianDis * this.moveSpeed;
        // }
        this.moveUpdate();
        this.timeOnEnterFrame = egret.getTimer();
    };
    /**
     * 移动坐标
     */
    PlayerView.prototype.moveUpdate = function () {
        this.x += this.moveSpeedX;
        this.y += this.moveSpeedY;
        this.vo.setX(this.x);
        this.vo.setY(this.y);
        this.recordMovePath(this.x, this.y, this.acDirIndex);
        this.chectReach(this.x, this.y, this.targetX, this.targetY);
        // this.drawLine();
    };
    PlayerView.prototype.drawLine = function () {
        // this.initGraphics(this.x,this.y,this.targetX,this.targetY);
        this.shape.graphics.clear();
        this.shape.graphics.lineStyle(2, 0x00ff00);
        this.shape.graphics.moveTo(this.x, this.y);
        //  this.shape.graphics.lineTo(this.targetX,this.targetY);
        for (var _i = 0, _a = this.move_path; _i < _a.length; _i++) {
            var v = _a[_i];
            var curPoint = v;
            var _b = UIMgr.getWorld().getMap().cell2world(curPoint.x, curPoint.y), curPointX = _b[0], curPointY = _b[1];
            this.shape.graphics.lineTo(curPointX, curPointY);
        }
        var index = this.shape.parent.getChildIndex(this.shape);
        this.shape.parent.setChildIndex(this.shape, 0);
        var index2 = this.shape.parent.getChildIndex(this.shape);
        this.shape.graphics.endFill();
    };
    /**
     * @param acNameIndex 动作
     * @param acDirIndex  方向
     * @param one  是否播放一次
     */
    PlayerView.prototype.playAction = function (one) {
        if (!this.needChangeAction && !one)
            return;
        this.needChangeAction = false;
        var isScanleX;
        var acDirIndex = this.acDirIndex;
        // if (!this.is8Dir){
        //     isScanleX = (acDirIndex === 3 || acDirIndex === 4 ||acDirIndex === 5 ||
        //     acDirIndex === 9 ||acDirIndex === 10 ||acDirIndex === 11 )
        // }else{
        isScanleX = (acDirIndex === 5 || acDirIndex === 6 || acDirIndex === 7);
        // }
        this._playAction(isScanleX, one);
    };
    PlayerView.prototype._playAction = function (isScanleX, one) {
        for (var i = 0; i < this.actions.length; i++) {
            var action = this.actions[i];
            if (isScanleX) {
                action.scaleX = -Math.abs(action.scaleX);
            }
            else {
                action.scaleX = Math.abs(action.scaleX);
            }
            action.movieClipData = this.mcDataFactory.generateMovieClipData(this.acName[this.acNameIndex] + "_" + this.acDir[this.acDirIndex]);
            action.gotoAndPlay(1, one ? 0 : -1);
        }
    };
    PlayerView.prototype.ReachToChangeAction = function () {
        if (this.moveIndex >= this.move_path.length) {
            this.stage.removeEventListener(egret.Event.ENTER_FRAME, this.bgMove, this);
            this.setAcNameIndex(0);
            // this.acNameIndex = 0;
            this.playAction();
            if (this.goToTargetCallBack !== undefined) {
                this.goToTargetCallBack(this);
                this.goToTargetCallBack = undefined;
            }
            console.log("到达目的地...切换待机状态... ");
        }
        else {
            console.log("走完 等待服务器返回...... ");
        }
    };
    /**
     * 检测是否走到终点
     */
    PlayerView.prototype.chectReach = function (playerX, playerY, targetX, targetY) {
        //test 8方向和12方向
        switch (this.acDirIndex) {
            case 0:
            case 1:
            case 7:
                if (playerY <= targetY) {
                    this.ReachToChangeAction();
                }
                break;
            case 3:
            case 4:
            case 5:
                if (playerY > targetY) {
                    this.ReachToChangeAction();
                }
                // if (playerX >= targetX && playerY >= targetY){
                // if (playerX >= targetX && playerY >= targetY){
                //     this.ReachToChangeAction();
                // }
                break;
            case 2:
                if (playerX >= targetX) {
                    this.ReachToChangeAction();
                }
                break;
            case 6:
                if (playerX <= targetX) {
                    this.ReachToChangeAction();
                }
                break;
        }
        return false;
    };
    /**
     *  跟随相关
     */
    PlayerView.prototype.setFrontRoleView = function (frontRole) {
        this.frontRole = frontRole;
        this.stage.addEventListener(egret.Event.ENTER_FRAME, this.followMove, this);
    };
    PlayerView.prototype.getFrontRoleView = function () {
        return this.frontRole;
    };
    PlayerView.prototype.disFrontRoleView = function () {
        this.frontRole = undefined;
        this.stage.removeEventListener(egret.Event.ENTER_FRAME, this.followMove, this);
    };
    PlayerView.prototype.followMove = function () {
        var point = this.getRecordPrevious();
        if (point) {
            // this.acNameIndex = 1;
            this.setAcNameIndex(1);
            this.moveUpdateFollow(point.x, point.y, point.dir);
        }
        else {
            this.setAcNameIndex(0);
            //    this.acNameIndex = 0;
            this.playAction();
        }
    };
    //记录行走路径
    PlayerView.prototype.recordMovePath = function (x, y, acDirIndex) {
        var point = new Mpoint(x, y, acDirIndex);
        while (this.points.length >= this.saveAllFollowFrame) {
            this.points.splice(0, 1);
        }
        this.points.push(point);
    };
    //获取跟随者走过的路径
    PlayerView.prototype.getRecordPrevious = function () {
        if (this.getFrontRoleView().points.length < this.queueFollowMaxFrameLength) {
            return undefined;
        }
        else {
            return this.getFrontRoleView().points.splice(0, 1)[0];
        }
    };
    /**
     * 跟随的行走
     * @param x 当前坐标 x ,y
     */
    PlayerView.prototype.moveUpdateFollow = function (x, y, dir) {
        // this.x +=this.moveSpeedX;
        // this.y +=this.moveSpeedY;
        this.x = x;
        this.y = y;
        this.setAcDirIndex(dir);
        // this.acDirIndex = dir;
        this.vo.setX(this.x);
        this.vo.setY(this.y);
        var _a = UIMgr.getWorld().getMap().world2cell(this.x, this.y), cellX = _a[0], cellY = _a[1];
        this.vo.setCellXY(cellX, cellY);
        this.recordMovePath(this.x, this.y, this.acDirIndex);
        // this.parent.setChildIndex( this,Math.ceil(this.y));
        this.playAction();
    };
    //战斗掉血相关
    PlayerView.prototype.hurtAndRefresh = function (hurt) {
        this.vo.setCurHp(this.vo.getCurHp() - hurt);
        this.progressBar.setProgress(this.vo.getPecentHp());
        var aa = false;
        while ((this.actions.length - 1) * (100 / this.vo.getUnitCount()) / 100 >= this.vo.getPecentHp()) {
            var action = this.actions.splice(this.actions.length - 1, 1)[0];
            // action.parent
            action.parent.removeChild(action);
            console.log("倒下一个..... = " + this.actions.length);
        }
        if (this.actions.length <= 0) {
            console.log("该方阵死亡..........!!!" + typeof (this));
            //  console.log("here.......///////////////////////" );
            this.dispose();
        }
    };
    PlayerView.prototype.dispose = function () {
        this.stage.removeEventListener(egret.Event.ENTER_FRAME, this.followMove, this);
        this.stage.removeEventListener(egret.Event.ENTER_FRAME, this.bgMove, this);
        this.parent.removeChild(this);
        //  console.log(" ********************this.parent.removeChild(this); == ");
    };
    return PlayerView;
}(egret.DisplayObjectContainer));
PlayerView.static_index = 0; //临时
__reflect(PlayerView.prototype, "PlayerView");
var Mpoint = (function () {
    function Mpoint(x, y, dir) {
        this.x = x;
        this.y = y;
        this.dir = dir;
    }
    return Mpoint;
}());
__reflect(Mpoint.prototype, "Mpoint");
//# sourceMappingURL=PlayerView.js.map