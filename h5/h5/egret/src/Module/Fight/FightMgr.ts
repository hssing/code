namespace Fight {
    export class FightMgr {
        private roleViews:any = {} ;//所有可见战斗集合
        private startArmyViews:ArmyView; //发起部队
        private targetArmyViews:ArmyView; //被攻击部队
        private timer: egret.Timer

        private fightData:any ; //战报
        private fightIndex = 0;

        //开始战斗 
        public startFinght() {
            this.timer = new egret.Timer(600, 0);
            this.timer.addEventListener(egret.TimerEvent.TIMER, this.excuteFight, this);       
            this.timer.start();            
        }

        public excuteFight() {
            // let a = [];
            // a.length
            console.log(this.fightData.length);
            if (this.fightIndex >= this.fightData.length - 1){
                console.log(" 战斗完毕 == ");
                this.timer.stop();
                Prompt.popTip("模拟战报战斗结束");
            }else{
                let curFightData = this.fightData[this.fightIndex];
                let roleView:RoleView =  this.roleViews[curFightData.attacker_id];
                roleView.atttack(curFightData.attack_info_list);
                console.log(" key == " + curFightData.attacker_id);
                this.fightIndex++;
            }

        }



        //布阵士兵到达位置回调
        public embattleCallBack(roleView:RoleView,dir:number) {
            console.log(" 布阵士兵到达位置回调 == " + roleView.getAcDirIndex());
            roleView.setAcDirIndex(dir);
            console.log(roleView.getVO().getId() +"= 布阵士兵到达位置回调22 == " + roleView.getAcDirIndex());
            roleView.playAction();
        }

        //行走到目的地。回调布阵（看成进入战斗状态）
        public goToTargetCallBack() {
            let startMainView:RoleView = this.startArmyViews.getMainViews();
            let startMainVO:PlayerVO = startMainView.getVO();
            let startMainDir:number = startMainView.getAcDirIndex();
            console.log("我是行走结束回调....开始布阵 = " + startMainDir );

            //8个方向
            switch(startMainDir) {
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
                    let curRoleView = startMainView;
                    let nextRoleView = this.startArmyViews.getNextRoleView(curRoleView);
                    
                    let index = -1;
                    let [cellX,cellY] = startMainView.getVO().getCellXY();
                    //TODO 待优化
                    while(nextRoleView){
                        let curCellX = cellX + index;
                        let curCellY = cellY + index;

                        index = 1;
                        curRoleView = nextRoleView;
                        curRoleView.disFrontRoleView(); //取消跟随
                        
                        curRoleView._moveOnePath(curCellX,curCellY,(curView)=>{
                                                                        this.embattleCallBack(curView,startMainDir);
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
            let targetSelectView = this.targetArmyViews.getSelectView();
            
            let targetSelectViewDir = 0;
            if (startMainDir >= 4){
                targetSelectViewDir = startMainDir - 4;
            }else {
                targetSelectViewDir = startMainDir + 4;
            }
            targetSelectView.disFrontRoleView();
            targetSelectView.setAcDirIndex(targetSelectViewDir);
            targetSelectView.playAction();


            let targetOtherViews = this.targetArmyViews.getOtherRoleView(targetSelectView);
            
            let [cellX,cellY] = targetSelectView.getVO().getCellXY();
            let index = -1;
            for(let k in targetOtherViews){
                let curCellX = cellX + index;
                let curCellY = cellY + index;

                index = 1;
                let curRoleView = targetOtherViews[k];
                curRoleView.disFrontRoleView(); //取消跟随
                
                curRoleView._moveOnePath(curCellX,curCellY,(curView)=>{
                                                                this.embattleCallBack(curView,targetSelectViewDir);
                                                                });
            }

            //--------------------
            //TODO  这种攻击目标 
            //--------------------
            // startMainView.setAttackView(targetSelectView);
            // targetSelectView.setAttackView(startMainView);


            let fightTest = new FightTest();
            this.fightData = fightTest.calculateFightData(this.startArmyViews,this.targetArmyViews);    

            // console.log(this.fightData.lenght);
            egret.setTimeout(function () {              
                this.startFinght();
            },this,3000);    
        }



        //追踪到目的地。
        public goToTarget(startArmyViews: ArmyView,targetArmyViews: ArmyView) {
            this.startArmyViews  = startArmyViews;
            this.targetArmyViews = targetArmyViews;

            utils.mergeObject( this.startArmyViews.getRoleViews(),this.roleViews);
            utils.mergeObject( this.targetArmyViews.getRoleViews(),this.roleViews);

            let nearView = this.findNearCell(startArmyViews,targetArmyViews);
            let startView = startArmyViews.getMainViews();
            let [targetCellX,targetCellY] = this.findRoundNearCell(startView,nearView);

            startView._moveOnePath(targetCellX,targetCellY,()=>this.goToTargetCallBack());
        }

        //查找最近附近格子
        public findRoundNearCell(startView: RoleView,targetView: RoleView) {
            let [srcCellX,srcCellY] = startView.vo.getCellXY(); //源坐标点
            let [cellX,cellY] = targetView.vo.getCellXY();
            //改点周围8个点全判断。暂时这样。可以优化
            //TODO 需优化
            let min_x = cellX - 1;
            let max_x = cellX + 1;
            let min_y = cellY - 1;            
            let max_y = cellY + 1;

            let finalX,finalY;
            let temp_dis = undefined;
            for (let i = min_x ; i <= max_x ; i++) {
                for (let j = min_y ; j <= max_y ; j++) {
                    if (temp_dis !== undefined) {
                        let new_dis = this.disTowPoint(srcCellX,srcCellY,i,j);
                        if (new_dis < temp_dis){
                            temp_dis = new_dis;
                            finalX = i;
                            finalY = j;
                        }
                        
                    }else {
                        temp_dis = this.disTowPoint(srcCellX,srcCellY,i,j);
                        finalX = i;
                        finalY = j;
                    }
                }
            }

            return [finalX,finalY];
        }   

        //查找目标方阵最近方阵
        public findNearCell(startViews: ArmyView,targetViews: ArmyView) :RoleView {
            let startMainView: RoleView = startViews.getMainViews();
            let nearView;
            let roleViews = targetViews.getRoleViews();
            for (let key in roleViews) {
                let curView = roleViews[key];
                if (nearView) {
                    let lastDis = this.disTowView(startMainView,nearView);
                    let nowDis = this.disTowView(startMainView,curView);
                    if (nowDis < lastDis) {
                        nearView = curView;
                    }
                }else{
                    nearView = curView;
                }
            }
            targetViews.setSelectView(nearView); //目标最近方阵
            return nearView;
        }

        //算两个方阵直线距离
        public disTowView(thisView: RoleView,otherView: RoleView): number{
            let dis = this.disTowPoint(thisView.vo.getX(),thisView.vo.getY(),otherView.vo.getX(),otherView.vo.getY());
            return dis;
        }

        //两点直线距离
        public disTowPoint(x1,y1,x2,y2){
            let disX = Math.abs(x1 - x2);
            let disY = Math.abs(y1 - y2);
            let dis = Math.sqrt(disX * disX + disY * disY);
            return dis;            
        }

        //加入战斗 
        public addWar(addId: any) {

        }

        //退出战斗
        public outWar() {

        }

    }
}