namespace world {

    export class ArmyView extends ViewBase {

        public constructor(mgr: Manager, root: egret.DisplayObjectContainer, data: any) {
            super(mgr, root, data);
        }

        public build(): egret.DisplayObjectContainer {
            this.createArmy();
            return null; // this.mainRole;
        }

        public refresh(): void {
            this.refresh2();
        }

        public hitTestPoint(x: number, y: number): boolean {
            for (let i = 0; i < this.root.numChildren; i++) {
                let child: egret.DisplayObject = this.root.getChildAt(i);
                if (child.hitTestPoint(x, y)) {
                    return true;
                }
            }
            return false;
        }

        //data {} 
        private mainRole:RoleView; //主方阵。队头带队走的

        private army_id ; //部队id
        private roleViews;  // key -- view
        protected manager: world.Manager;
        protected root:any;

        private selectView ;   // 该部队被选中的方阵
        
        private countIndex = 0;  //
        //自动行走频率
        private autoMoveHz = 650 ;//自动行走频率

        private statue = 0 ; //部队状态。。 0- 普通   1-战斗 2-逃跑 3-死亡

        //创建部队。一个部队有多个方阵
        public createArmy() {
           
            let soldiers = [this.data.forward_phalanx,this.data.center_phalanx,this.data.back_phalanx]; //[{soldiers_id: 1, hp: 100, max_hp: 100},{soldiers_id: 2, hp: 100, max_hp: 100},{soldiers_id: 3, hp: 100, max_hp: 100}]//this.data.soldiers;

            this.army_id = this.data.army_id;
            var backRole = undefined;

            this.roleViews = {};
            this.countIndex = 0;
            this.autoMoveHz = 650;
            this.statue = 0;
            
            let cfg = RES.getRes("SoldierConfig_json");


            let phalanxPos  = this.manager.getArmyMgr().getPhalanxPoints()[this.army_id]

            let temp_i = 0

            let role_id  = this.data.ower_info.role_id
            let roleId = LogicMgr.get(logic.Player).getRoleId();
            for (let v of soldiers) {
                if (!v || v.soldiers_id == 0) continue;
                temp_i++;
                let data = this.data ;

                let c_soldier = cfg[v.soldiers_id];
                let vo: PlayerVO = new PlayerVO();
                let armyID = this.army_id ;
                vo.setId(parseInt(armyID));
                vo.setUnitCount(c_soldier.quantity);
                vo.setScale(c_soldier.scale);
                vo.setCurHp(v.hp);
                vo.setMaxHp(v.max_hp);
                vo.setIsOwner(role_id === roleId);
                let role: RoleView = new RoleView(this.root,this.manager,v.soldiers_id,vo,this);

                this.roleViews[armyID + temp_i] = role;
                this.root.addChild( role);

                //如果是方阵集合为部队
                if (phalanxPos && phalanxPos.length > (temp_i - 1)){
                    let [_x,_y] = phalanxPos[temp_i - 1];
                    vo.setXY(_x, _y);
                    let [wx,wy] =  this.manager.getWorldMap().world2cell(_x, _y);
                    vo.setCellXY(wx,wy);
                }else {
                    let wpos =  this.manager.getWorldMap().cell2world( this.data.cur_point.x + (temp_i - 1),this.data.cur_point.y);
                    vo.setXY(wpos[0], wpos[1]);
                    vo.setCellXY(this.data.cur_point.x, this.data.cur_point.y);
                }
                
                role.updateVO(vo);
                if( !this.mainRole ) {
                    this.mainRole = role;
                }
                //重设跟随关系
                if ( backRole) {
                    role.setFrontRoleView( backRole);
                }  
                //模拟路径  从第二个开始
                if( temp_i > 1) {
                    let moveSpeed = 2.0

                    let moveDisX = (role.x - backRole.x);
                    let moveDisY = (role.y -backRole.y );

                    //斜边长
                    let  xiexianDis = Math.sqrt(moveDisX *moveDisX + moveDisY*moveDisY);
                    let dir =(role.calculateDir(moveDisX,moveDisY,xiexianDis));
                    let moveSpeedX = moveDisX / xiexianDis * moveSpeed;
                    let moveSpeedY = moveDisY / xiexianDis * moveSpeed;

                    let count = Math.floor(xiexianDis / moveSpeed);
                    let _dir =  role.setDirByTowPoints(backRole.x,backRole.y,role.x,role.y);
                    for (let i = 0 ; i < count ; i++) {
                        backRole.recordMovePath(role.x - moveSpeedX * (i + 1),role.y - moveSpeedY * (i + 1),_dir);
                    }
                } 
                backRole = role ;             
                
            }

            if (phalanxPos){
                delete  this.manager.getArmyMgr().getPhalanxPoints()[this.army_id]
            }
        }
        
        private frameExecute() {
            // console.log(" frameExecute  ===== " + this.data.armyId);
            this.countIndex++;
            if(this.countIndex % this.autoMoveHz === 0) {
                let  rX = Math.floor(Math.random() * 10)
                let  rY = Math.floor(Math.random() * 10)
                let key = '0';
                for (let k in this.roleViews) {
                    key = k;
                    break;
                }
                let data01 = {role_id:key,move_path:[{x : rX,y : rY}],}
                // UIMgr.getWorld().onActorMove(data01);                
            }
        }

        public setData(data) {
            this.data = data;
        }

        public refresh2(){
            // if (this.data.status === 1) {
            //     this.data.status = 0;
                this.mainRole.updatePath(this.data);
            // }        
        }
    
        public updatePath(data) { 
            this.mainRole.updatePath(data);
        }

        public mergeViews(o:any) {
            return utils.mergeObject(this.roleViews,o);
        }

        

        //获取主方阵
        public getMainViews() {
            let keys = new Array();
            for (let key in this.roleViews){
                keys.push(key);
            }        

            return this.roleViews[keys[0]];
        }

        public getRoleViews() {
            return this.roleViews;
        }

        //拿到当前role的下一个role
        public getNextRoleView(roleView) {
            let keys = new Array();
            for (let key in this.roleViews){
                keys.push(key);
            }        
            for (let i = 0 ; i < keys.length ; i++){
                if (i < keys.length - 1 && roleView === this.roleViews[keys[i]]) {
                    return  this.roleViews[keys[i + 1]]
                }
            }

            return undefined;
        }
        
        public getData() {
                return this.data;
            }
        //获得出roleView 的其他View
        public getOtherRoleView(roleView) {
            let rViews = {};
            for (let key in this.roleViews){
                if (this.roleViews[key] !== roleView){
                    rViews[key] = this.roleViews[key];
                }
            }    
            return rViews;
        }

        public atttack(attack_info_list) {
            this.getMainViews().atttack(attack_info_list);
        }

        public setSelectView(rView:RoleView) {
            this.selectView = rView;
        }

        public getSelectView(): RoleView {
            return this.selectView
        }

        public dispose() {
            for (let k in this.roleViews) {
                this.roleViews[k].dispose();
            }
            super.dispose();
        }
    }
}