// TypeScript file
/**
 *部队
 */

class ArmyView {

    //data {} 
    private data:any ;//= {"armyId":1,"infos":{"0":{},"1":{},"2":{}}} ; //部队数据
    private mainRole:RoleView; //主方阵。队头带队走的

    private army_id ; //部队id
    private roleViews  = {};  // key -- view
    protected manager: world.Manager;
    protected root:any;

    private selectView ;   // 该部队被选中的方阵
    
    private countIndex = 0;  //
    //自动行走频率
    private autoMoveHz = 650 ;//自动行走频率

    private statue = 0 ; //部队状态。。 0- 普通   1-战斗 2-逃跑 3-死亡
  
    public constructor(data?:any,manager?: world.Manager,root?:any) {
        this.data = data;
        this.manager = manager;
        this.root = root
        this.createArmy();
        this.refresh();
    }

    //创建部队。一个部队有多个方阵
    public createArmy() {
        // let soldiers = [this.data.forward_phalanx]//,this.data.center_phalanx,this.data.back_phalanx]; //[{soldiers_id: 1, hp: 100, max_hp: 100},{soldiers_id: 2, hp: 100, max_hp: 100},{soldiers_id: 3, hp: 100, max_hp: 100}]//this.data.soldiers;
        let soldiers = [{soldiers_id: 1, hp: 100, max_hp: 100},{soldiers_id: 2, hp: 100, max_hp: 100},{soldiers_id: 3, hp: 100, max_hp: 100}]//this.data.soldiers;

        this.army_id = this.data.army_id;
        var backRole = undefined;
        
        let temp_i = 0
        for (let v of soldiers) {
             temp_i++;
             let role: RoleView = new RoleView(this.root);
             
             let armyID = this.army_id + '' + (v.soldiers_id + temp_i);
             this.roleViews[armyID] = role;
             this.root.addChild( role);
             let wpos =  this.manager.getWorldMap().cell2world( this.data.cur_point.x,this.data.cur_point.y);
 

             let vo: PlayerVO = new PlayerVO();
             vo.setXY(wpos[0], wpos[1]);
            //  role.vo.setId(this.army_id);
             vo.setCellXY(this.data.cur_point.x, this.data.cur_point.y);
              
             let vo_temp: PlayerVO = new PlayerVO(); 
             vo.setId(parseInt(armyID));
             role.updateVO(vo,vo_temp);

            

             if( !this.mainRole ) {
                 this.mainRole = role;
             }
             //重设跟随关系
             if ( backRole) {
                 role.setFrontRoleView( backRole);
             }  
             backRole = role ;             
        }

        //test automove
        // this.root.stage.addEventListener(egret.Event.ENTER_FRAME,this.frameExecute,this);  
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
            UIMgr.getWorld().onActorMove(data01);                
        }
    }

    public setData(data) {
        this.data = data;
    }

    public refresh(){
            if (this.data.status === 1) {
                this.data.status = 0;
                this.mainRole.updatePath(this.data);
            }        
    }
 
    public updatePath(data) { 
        this.mainRole.updatePath(data);
    }

    public mergeViews(o:any) {
        utils.mergeObject(this.roleViews,o);
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
    }
}