// TypeScript file
/**
 *方阵
 */

namespace world {

    export class Phalanx extends ViewBase {
    
        private mainRole:RoleView; //主方阵。队头带队走的

        private army_id ; //部队id
        private roleViews;  // key -- view
        protected manager: world.Manager;
        protected root:any;

        private selectView ;   // 该部队被选中的方阵
        
        private countIndex;  //
        //自动行走频率
        private autoMoveHz;//自动行走频率

        private statue; //部队状态。。 0- 普通   1-战斗 2-逃跑 3-死亡



        public build(): egret.DisplayObjectContainer {
            this.createArmy();
            return this.mainRole;
        }

        public refresh(): void {
            this.refresh2();
        }

        //创建方阵
        public createArmy() {

            this.roleViews = {};
            this.countIndex = 0;
            this.autoMoveHz = 650;
            this.statue = 0;
            let dada = this.data;

            let cfg = RES.getRes("SoldierConfig_json");

            let role_id  = this.data.ower_info.role_id
            let roleId = LogicMgr.get(logic.Player).getRoleId();    

            let vo: PlayerVO = new PlayerVO();
            let armyID = this.data.id;
            let c_soldier = cfg[this.data.soldier_type];
            vo.setUnitCount(c_soldier.quantity);
            vo.setScale(c_soldier.scale);
            vo.setId(parseInt(armyID));
            vo.setCurHp(this.data.hp);
            vo.setMaxHp(this.data.max_hp);
            vo.setIsOwner(role_id === roleId);
            let role: RoleView = new RoleView(this.root,this.manager,this.data.soldier_type,vo,this);
         
            this.roleViews[armyID] = role;
            this.root.addChild( role);
        
            let phalanxPos  = this.manager.getPhalanxMgr().getPhalanxPoints()[this.data.id]
            if (phalanxPos) {
                vo.setXY(phalanxPos[0],phalanxPos[1]);
            }else{
                let wpos =  this.manager.getWorldMap().cell2world( this.data.cur_point.x,this.data.cur_point.y);
                vo.setXY(wpos[0], wpos[1]);
            }

            vo.setCurHp( this.data.hp);
            vo.setMaxHp( this.data.max_hp);
            vo.setCellXY(this.data.cur_point.x, this.data.cur_point.y);
            
            role.updateVO(vo);

            if( !this.mainRole ) {
                this.mainRole = role;
            }
        }
        
        public playAttack(data: any ,dstPos:any): void {
            this.view.playAttack(data ,dstPos);
        }

        public playDefend(defInfo: any,skill_id?:any): void {
            this.view.playDefend(defInfo,skill_id);
        }

        public setDirByTowPoints(x1,y1) {
             this.view.setDirByTowPoints(x1,y1,this.view.x,this.view.y);
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

        public refresh2(){
            this.mainRole.updatePath(this.data);
        }
    
        public updatePath(data) { 
            this.mainRole.updatePath(data);
        }

        public mergeViews(o:any) {
            return utils.mergeObject(this.roleViews,o);
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