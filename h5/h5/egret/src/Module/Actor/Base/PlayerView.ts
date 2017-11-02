// TypeScript file

/**
 *
 * 人物类
 *
 */
enum BULLET_FLY_TYPE {
    LINE = 2,
}


enum FIGHT_TYPE {
    TYPE_1 = 1,
    TYPE_2 = 2,
    TYPE_3 = 3,
    TYPE_4 = 4,
}


enum ACTION_NAME {
    IDLE = 0,
    RUN = 1,
    ATTACK = 2 
}

enum ACTION_DIR {
    UP = 0,
    UP_45 = 1,
    RIGHT = 2,
    DOWN_45 = 3,
    DOWN = 4,
    DOWN_45_REVERSE = 5,
    RIGHT_REVERSE = 6,
    UP_45_REVERSE = 7
}


class PlayerView extends  egret.DisplayObjectContainer {
    public vo:PlayerVO ;// = new PlayerVO();
    public vo_temp:PlayerVO = new PlayerVO();
    protected _mcData:any;
    protected _mcTexture:egret.Texture;
    protected role:egret.MovieClip;
    protected role2:egret.MovieClip;
    public mcDataFactory;
    public is8Dir = true; //测试8 个方向  false-12方向  true-8方向

    public acName:string[] = ["idle","run","attack"];

    //6个方向
    public acDir:string[] = ["up","up_45","right",
                                 "down_45","down","down_45",
                                 "right","up_45",];

    protected acNameIndex:number = 0; //当前动作
    protected acDirIndex:number = 0;  //当前方向
    protected timeOnEnterFrame = 0;   //最后角色移动动画结束时间  
    protected needChangeAction = false; //是否需要切换动画

    protected moveSpeed:number = 0.25; //移动速度
    protected moveTimeOneCell:number = 2000; //毫秒
    protected useTimeFixation:number = 0;
    protected moveSpeedX:number = 0;
    protected moveSpeedY:number = 0;
    protected moveDisX:number = 0 ; //x y轴移动距离
    protected moveDisY:number = 0 ;
    protected targetX:number = 0; //目标点坐标
    protected targetY:number = 0;
    protected nameText:egret.TextField ; //
    protected towPointDis:number; //行走两点距离
    protected towPointCellNum:number; //行走两点间格子数
    protected xiexianDis:number; //斜边长
    protected speedUp:number = 10; //加速
    //
    public actions:any[] = []; //动画单位数组
    protected shadows:any[] = []; //脚底阴影
    
    //服务返回行走路径
    protected moveIndex:number = 0; 
    protected move_path:any[] = [];
    protected move_info:any ;
    protected cur_point:any ;
    
    //行军跟随 
    public points: Mpoint[];
    protected queueFollowMaxFrameLength: number = 70; //队列跟随最大帧数     
    protected saveAllFollowFrame: number = 170 ; //跟随最大帧
    protected frontRole: RoleView ;// 跟随前面的对象

    //战斗
    protected progressBar:ProgressBar; //血条
    // protected attackView:RoleView; //攻击对象

    public static static_index:number = 0; //临时

    //data服务器返回数据
    public data:any ; 

    // private timer: egret.Timer
    private shape:egret.Shape;
    private root:any;
    private manager: world.Manager;

    protected info:any;  //构建地图数据

    private  fightMgr:Fight.FightMgr; 
    private playerId:number ; //角色id

    private uiInstance:any;
    public constructor(root?:any,manager?: world.Manager,modelId?:any,vo?:any,uiInstance?:any) {
        super();
        this.width = mo.TMap.getMainData().getResult().info.cw;
        this.height = mo.TMap.getMainData().getResult().info.ch;
        this.anchorOffsetX = this.width / 2;
        this.anchorOffsetY = this.height / 2;
        this.vo = vo;
        this.vo.setModelId(modelId);
        this.uiInstance = uiInstance;
        this.init();
        this.root = root;
        this.manager = manager;
        PlayerView.static_index++;
        this.points = [];

        this.fightMgr = Fight.FightMgr.getFightMgrIns();


        this.shape =  new egret.Shape();
        this.root.addChild(this.shape);
    }

    // protected isChange = false;
    public playAttack(data: any , dstPos:any): void {
        //如果是移动状态 。则暂时不切换到战斗 
                this.fightMgr.playAttack(data,this,this.manager,dstPos); 
        // }else {
        //     console.log(this.vo.getId() + " == ///is ACTION_NAME.RUN");
        // }
        // let cfg = RES.getRes("SkillConfig_json");
        // let info = cfg[data.skill_id];
        
        // g_PlayerView_index++;
        // console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>> = " + g_PlayerView_index);
        // Singleton(Timer).after(info.delay?info.delay:100, world.g_world_view.Event("aaa" + g_PlayerView_index, ()=>{this.onDelayAttack(data,dstPos)}));
    }

    private onDelayAttack(data: any , dstPos:any): void {
         this.fightMgr.playAttack(data,this,this.manager,dstPos);
    }  

    public playDefend(defInfo: any,skill_id?:any): void {
        this.fightMgr.playDefend(defInfo,this,this.manager,skill_id)
    }

    //初始化 角色数据
    public updateVO(vo: any,temp_vo?:any) { 
         [ this.x ,this.y ] =  this.vo.getXY();
    }


    public getVO() {
        return this.vo;
    }

    public getVO_temp() {
        return this.vo_temp;
    }

    //如果需要切换方向与当前方向一直。则不需要操作
    public setAcDirIndex(acDirIndex: number) {
        if (this.acDirIndex !== acDirIndex){
             this.needChangeAction = true;
             this.acDirIndex = acDirIndex;
        }
    }

     //如果需要切换动作与当前方向一直。则不需要操作
    public setAcNameIndex(acNameIndex: number) {
        if (this.acNameIndex !== acNameIndex){
             this.needChangeAction = true;
             this.acNameIndex = acNameIndex;
        }
    }

    public getAcDirIndex() {
        return this.acDirIndex;
    }

    public getAcNameIndex() {
        return this.acNameIndex;
    }

    public setMoveSpeed(moveSpeed : number) {
        this.moveSpeed = moveSpeed;
    }

    public getMoveSpeed() {
        return this.moveSpeed;
    }

    public init(): void {
        this.createPlayer();
    }

    public createPlayer(): void {
        this.initMovieClip();
    }

    public initMovieClip(): void {
        let unitCount = this.vo.getUnitCount(); 
        this.acDirIndex = Math.floor((Math.random() * 10) % 7);

        let tx: egret.Texture = RES.getRes("sole_shadow_png");
        //构建小地图, N维方阵， 偏移 ox, oy，用于微调部队位置
        let coordinate = UIMgr.getWorld().getMap().createCoordinate(Math.sqrt(unitCount), 0, 0); 
        this.info = coordinate.getInfo();


        let cfg = RES.getRes("SoldierConfig_json");
        let animationName = cfg[this.vo.getModelId()].animation
        // console.log("animationName === " + animationName);

        let cbFunc = (mcDataFactory) => {
            this.mcDataFactory = mcDataFactory;

            let actionCount =  Math.ceil(this.vo.getPecentHp() * unitCount);
            let roleLayer = new egret.DisplayObjectContainer();
            for( let i = 0 ; i < actionCount ; i++ ) {
                let [x,y] = coordinate.index2cell(i);
                let [x1,y1] = coordinate.cell2world(x,y);                
                let bm = new egret.Bitmap(tx);
                this.addChild(bm);
                bm.anchorOffsetX = tx.bitmapData.width / 2;
                bm.anchorOffsetY = tx.bitmapData.height / 2;
                [bm.x, bm.y] = [x1, y1];
                this.shadows.push(bm);
                
                var action = new egret.MovieClip(this.mcDataFactory.generateMovieClipData(this.acName[this.acNameIndex] + "_" + this.acDir[this.acDirIndex])); //run_l_d_d
                action.gotoAndPlay(1,-1);     

                action.scaleX = this.vo.getScale();
                action.scaleY = this.vo.getScale();
                this.actions.push(action);

                action.x = x1 ;
                action.y = y1 ;

                roleLayer.addChild(action);
            }
            this.addChild(roleLayer);

        }

        Actor.createDataFactory(animationName,cbFunc);//("role_" + this.vo.getModelId());

        // let actionCount =  Math.ceil(this.vo.getPecentHp() * unitCount);

        
        // let roleLayer = new egret.DisplayObjectContainer();
        // for( let i = 0 ; i < actionCount ; i++ ) {
        //     let [x,y] = coordinate.index2cell(i);
        //     let [x1,y1] = coordinate.cell2world(x,y);                
        //     let bm = new egret.Bitmap(tx);
        //     this.addChild(bm);
        //     bm.anchorOffsetX = tx.bitmapData.width / 2;
        //     bm.anchorOffsetY = tx.bitmapData.height / 2;
        //     [bm.x, bm.y] = [x1, y1];
        //     this.shadows.push(bm);
            
        //     var action = new egret.MovieClip(this.mcDataFactory.generateMovieClipData(this.acName[this.acNameIndex] + "_" + this.acDir[this.acDirIndex])); //run_l_d_d
        //     action.gotoAndPlay(1,-1);     

        //     action.scaleX = this.vo.getScale();
        //     action.scaleY = this.vo.getScale();
        //     this.actions.push(action);

        //     action.x = x1 ;
        //     action.y = y1 ;

        //     roleLayer.addChild(action);
        // }
        // this.addChild(roleLayer);

        //血槽 
        this.progressBar = new ProgressBar(this.vo.getIsOwner()?0:1);
        this.progressBar.setProgress(this.vo.getPecentHp());
        let scale = 0.4;
        this.progressBar.scaleX = scale;
        this.progressBar.scaleY = scale;
        this.progressBar.anchorOffsetX = this.progressBar.width / 2;
        this.progressBar.x = this.width / 2;
        this.addChild(this.progressBar); 


        this.nameText  = new egret.TextField();
        this.nameText.text = "" + this.getVO().getId();
        this.nameText.textColor = 0xffffff;
        this.nameText.size = 20;
        this.nameText.anchorOffsetX = this.nameText.width /2 ;
        this.nameText.anchorOffsetY = this.nameText.height - 20;
        this.addChild(this.nameText);

    }

    //服务器返回人物移动
    public updatePath(info) {
        this.move_info = info;
        if (info.status === 1) {
            this.move_path = info.move_path;
            this.moveIndex = 0; //行走下标重置

            //如果有固定时间。则使用
            if (info.useTime) {
                this.useTimeFixation =info.useTime;
            }else {
                this.useTimeFixation = 0;
            }

            this._moveOnePath();
        }else if(info.status === 0){
            let [_x, _y] = this.manager.getWorldMap().cell2world(info.cur_point.x, info.cur_point.y);
            let x_dis = this.x - _x;
            let y_dis = this.y - _y; 
            let towPointDis = Math.sqrt(x_dis*x_dis + y_dis*y_dis);
            

            
            this.targetX = _x;
            this.targetY = _y;
            if ( towPointDis > 5){
                //模拟最后一站数据
                this.move_path = [{x:info.cur_point.x,y:info.cur_point.y,z:info.cur_point.z}];
                this.moveIndex = 0; //行走下标重置
                console.log(this.vo.getId() +" == 瞬间移动 距离 == "+  towPointDis);
                this._moveOnePath(true);
                // if (this.getAcNameIndex() === ACTION_NAME.RUN){
                //     this.setAcNameIndex(ACTION_NAME.IDLE);
                // }
                // this.playAction();
                // this.removeEventListener(egret.Event.ENTER_FRAME,this.bgMove,this);  
            } else {
                this.stop();
            }
        }   
    }

    public _moveOnePath(rightNow?:any) {
        let cellX = this.move_path[this.moveIndex].x;
        let cellY = this.move_path[this.moveIndex].y;

        let [targetX,targetY] = UIMgr.getWorld().getMap().cell2world(cellX,cellY);

        this.vo.setCellXY(cellX,cellY);
        if(targetX === this.x && targetY === this.y){
            return ;
        }
        this.removeEventListener(egret.Event.ENTER_FRAME,this.bgMove,this);  
        this.setAcNameIndex(ACTION_NAME.RUN);
        this.targetX = targetX;
        this.targetY = targetY;   

        let disX = Math.abs(this.targetX - this.x);
        let disY = Math.abs(this.targetY - this.y);
        this.towPointDis = Math.sqrt(disX * disX + disY * disY); //两点距离
        
        let [_curCellX,_curCellY] = UIMgr.getWorld().getMap().world2cell(this.x,this.y);

        //更改 服务器返回的点计算    
        let curCellX = this.move_info.cur_point.x; //this.move_info.cur_point.x;
        let curCellY = this.move_info.cur_point.y; //this.move_info.cur_point.y;

        let xCellNum = Math.abs(cellX - curCellX);
        let yCellNum = Math.abs(cellY - curCellY);
        this.towPointCellNum = xCellNum > yCellNum ? xCellNum : yCellNum ; 
        //此次有bug 排除格子刚好过界
        this.towPointCellNum =  this.towPointCellNum  === 0 ?1: this.towPointCellNum;    
        //格子算速度的被除数。所以这里添加加速处理
        this.towPointCellNum /= rightNow?this.speedUp:1;

        this.setDirByTowPoints(targetX,targetY,this.x,this.y);

        this.playAction();
      
        this.timeOnEnterFrame = egret.getTimer();
        this.addEventListener(egret.Event.ENTER_FRAME,this.bgMove,this);  

        this.moveIndex++;        
    }

    public calculateSpeed( useTime): number{
            let useTimeAll = (this.moveTimeOneCell * this.towPointCellNum); //格子总共使用时间
            if (this.useTimeFixation > 0 ){
                useTimeAll = this.useTimeFixation;
            }
            let speed = (this.towPointDis / useTimeAll) * useTime;
            return speed;
    }

    public bgMove(time:any): void {
        var now = egret.getTimer();  
        var pass = this.timeOnEnterFrame;  
        var useTime = now - pass;    
        //速度
        let moveSp =  this.calculateSpeed(useTime);
        this.setMoveSpeed(moveSp);
        this.moveSpeedX = this.moveDisX / this.xiexianDis * this.moveSpeed;
        this.moveSpeedY = this.moveDisY / this.xiexianDis * this.moveSpeed;
        this.moveUpdate();

        // console.log("//onEnterFrame: ", (1000 / useTime).toFixed(5));
        this.timeOnEnterFrame = egret.getTimer();  
    }

    /**
     * 移动坐标
     */
    public moveUpdate() {
        //如果是待机状态。它还行走。则切换为行走状态
        if (this.getAcNameIndex() === ACTION_NAME.IDLE) {
            this.setAcNameIndex(ACTION_NAME.RUN);
            this.playAction();
            console.log("切换为 走路状态 id=== "  + this.getVO().getId());
        }

        this.x +=this.moveSpeedX;
        this.y +=this.moveSpeedY;
        this.vo.setX(this.x);
        this.vo.setY(this.y);
        this.recordMovePath(this.x,this.y,this.acDirIndex);

        this.chectReach();
        
        // this.drawLine();
    }

    public drawLine() {
        // this.initGraphics(this.x,this.y,this.targetX,this.targetY);
        this.shape.graphics.clear(); 
        this.shape.graphics.lineStyle(2, 0x00ff00);
        this.shape.graphics.moveTo(this.x,this.y);
        //  this.shape.graphics.lineTo(this.targetX,this.targetY);
        for (let v of this.move_path) {
            let curPoint = v;
            let [curPointX,curPointY] = UIMgr.getWorld().getMap().cell2world(curPoint.x,curPoint.y);
            this.shape.graphics.lineTo(curPointX,curPointY);
        }
        let index = this.shape.parent.getChildIndex(this.shape);
        this.shape.parent.setChildIndex(this.shape,0);
        let index2 = this.shape.parent.getChildIndex(this.shape);
        this.shape.graphics.endFill();
    }

    /**
     * @param acNameIndex 动作
     * @param acDirIndex  方向
     * @param one  是否播放一次
     */
    public playAction(one?:boolean): void {
        if (!this.needChangeAction &&  !one )return;
        this.needChangeAction = false;
        let isScanleX:boolean;
        let acDirIndex = this.acDirIndex;
       
        isScanleX = (acDirIndex === ACTION_DIR.DOWN_45_REVERSE || acDirIndex === ACTION_DIR.RIGHT_REVERSE ||acDirIndex === ACTION_DIR.UP_45_REVERSE  )

        this._playAction(isScanleX,one);
    }

    public _playAction(isScanleX : boolean,one?:boolean) {
        if (this.mcDataFactory){
            for (let i = 0 ; i < this.actions.length ; i++) {
                let action = this.actions[i];
                if (isScanleX ){
                    action.scaleX = -Math.abs(action.scaleX);
                }else{
                    action.scaleX = Math.abs(action.scaleX);
                }
        
                // action.play (this.acNameIndex,this.acDirIndex);  
                //change by cyb 9-20
            //    console.log(" action name xxx=== "  + this.acName[this.acNameIndex] + "_" + this.acDir[this.acDirIndex]);

                action.movieClipData = this.mcDataFactory.generateMovieClipData(this.acName[this.acNameIndex] + "_" + this.acDir[this.acDirIndex]);
                action.gotoAndPlay(1,one?0:-1);        
            }
        }

 
    }
   
    public ReachToChangeAction() {
         
    }

    /**
     * 检测是否走到终点
     */
    public chectReach(): boolean {
        //test 8方向
        switch(this.acDirIndex){
            case ACTION_DIR.UP:
            case ACTION_DIR.UP_45:
            case ACTION_DIR.UP_45_REVERSE:
                if (  this.y <= this.targetY ){
                    if ( this.moveIndex >= this.move_path.length){
                         this.stop();
                    }
                    return true;
                }            
                break;
            case ACTION_DIR.DOWN_45:
            case ACTION_DIR.DOWN:
            case ACTION_DIR.DOWN_45_REVERSE:
                if (  this.y > this.targetY){
                    if ( this.moveIndex >= this.move_path.length){
                         this.stop();
                    }
                    return true;                    
                }              
                break;
            case ACTION_DIR.RIGHT:
                if (this.x >= this.targetX){
                    if ( this.moveIndex >= this.move_path.length){
                         this.stop();
                    }
                    return true;                    
                }                
                break; 
            case ACTION_DIR.RIGHT_REVERSE:
                if (this.x <= this.targetX){
                    if ( this.moveIndex >= this.move_path.length){
                         this.stop();
                    }
                    return true;                    
                }                
                break; 
        }             
        return false; 
    }
    
    /**
     *  跟随相关 
     */
    public setFrontRoleView(frontRole : RoleView) {
        this.frontRole = frontRole;
        this.addEventListener(egret.Event.ENTER_FRAME,this.followMove,this);  
    }

    public getFrontRoleView() : RoleView {
        return this.frontRole;
    }

    public disFrontRoleView() {
        this.frontRole = undefined;
        this.removeEventListener(egret.Event.ENTER_FRAME,this.followMove,this);  
    }

    public followMove() {
        let point:Mpoint = this.getRecordPrevious();
        
        if (point) {
            this.setAcNameIndex(ACTION_NAME.RUN);
            if(point.dir === undefined && this.frontRole){
                point.dir = this.getAcDirIndex();
            }
            this.moveUpdateFollow(point.x , point.y ,point.dir);
        }else{
            this.setAcNameIndex(0);
            this.playAction();
            //test  算伤害
        }

    }

    //记录行走路径
    public recordMovePath(x: number ,y: number,acDirIndex: number): void {
        let point:Mpoint = new Mpoint(x,y,acDirIndex);
        while (this.points.length >= this.saveAllFollowFrame) {
            this.points.splice(0, 1);
        }
        this.points.push(point);
    }

    //获取跟随者走过的路径
    public getRecordPrevious() : Mpoint{
        if ( this.getFrontRoleView().points.length < this.queueFollowMaxFrameLength ) {
            return undefined;
        }else {
            return this.getFrontRoleView().points.splice(0, 1)[0];
        }
    }

    /**
     * 跟随的行走
     * @param x 当前坐标 x ,y  
     */
    public moveUpdateFollow(x: number ,y: number, dir:number) {
        this.x = x;
        this.y = y;
        this.setAcDirIndex(dir);
        this.vo.setX(this.x);
        this.vo.setY(this.y);
        let [cellX,cellY] = UIMgr.getWorld().getMap().world2cell(this.x,this.y);
        this.vo.setCellXY(cellX,cellY);
        this.recordMovePath(this.x,this.y,this.acDirIndex);
        this.playAction();
    }


    //战斗掉血相关
    public hurtAndRefresh(hurt:number) {
        this.vo.setCurHp(this.vo.getCurHp() - hurt);
        this.progressBar.setProgress(this.vo.getPecentHp());

        var aa = false 
        while ( (this.actions.length - 1) * ( 100 /this.vo.getUnitCount()) / 100 >= this.vo.getPecentHp() ){
            let action = this.actions.splice(this.actions.length - 1 ,1)[0] ;
            action.parent.removeChild(action);

            let shadow = this.shadows.splice(this.shadows.length - 1 ,1)[0] ;
            shadow.parent.removeChild(shadow);
        }

        if(this.actions.length <= 0) {
            this.dispose();
        }
    }

    public setDirByTowPoints(x1,y1,x2,y2) {
        this.moveDisX = x1 - x2;
        this.moveDisY = y1 - y2;
        //斜边长
        this.xiexianDis = Math.sqrt(this.moveDisX*this.moveDisX + this.moveDisY*this.moveDisY);
        if (this.xiexianDis === 0   )return ;  //如果距离为0 则不需要改变角度

        let dir = this.calculateDir(this.moveDisX,this.moveDisY,this.xiexianDis);
        this.setAcDirIndex(dir);        
    }

    //计算人物角度
    public calculateDir(moveDisX: number,moveDisY: number,xiexianDis: number): number {
        let angelTotal = 0 ; // 区块矫正 角度

        if(moveDisX >= 0 ){ //右半部分
            if(moveDisY >= 0){ //右下部分
                let angle = utils.MahtSin(moveDisY ,xiexianDis);
                angelTotal = angle + 90;
            }else{ //右上部分
                let angle = utils.MahtSin(moveDisY ,xiexianDis);
                angelTotal = angle + 90;
            }
        }else{ //左半部分
            if(moveDisY > 0){ //左下部分 
                let angle = utils.MahtSin(moveDisX ,xiexianDis);
                angelTotal = Math.abs(angle) + 180;
            }else{ //左上部分
                let angle = utils.MahtSin(moveDisX ,xiexianDis);
                angelTotal = 360 + angle;
            }
        }

        angelTotal = (angelTotal + 22.5)%361;
        let dirIndex = Math.floor((angelTotal)/ ( 45));
        if (dirIndex > 7) {
            console.log(" !!!!!!!!!!!!!!!!!!!!!!!!!!! 这里出现越界了。 = " + angelTotal);
            console.log(" !!!!!!!!!!!!!!!!!!!!!!!!!!! 这里出现越界了。 = " + dirIndex);
            dirIndex = 7 ;
        }
        return dirIndex;
    }

    public stop() {
        //change by  cyb 
         this.x = this.targetX;
         this.y = this.targetY;  
        //  console.log("this.x === " + this.x);      
        //  console.log("this.y === " + this.y);      

        if (this.getAcNameIndex() === ACTION_NAME.RUN){
             this.setAcNameIndex(ACTION_NAME.IDLE);
        }
         this.playAction();
         this.removeEventListener(egret.Event.ENTER_FRAME,this.bgMove,this);  
    }

    public dispose() { 
         this.removeEventListener(egret.Event.ENTER_FRAME,this.followMove,this);  
         this.removeEventListener(egret.Event.ENTER_FRAME,this.bgMove,this);  
         if(this.shape.parent){
             this.shape.parent.removeChild(this.shape);
         }
        
         if ( this.parent){
             this.parent.removeChild(this);
         }
    }
}

class Mpoint {
    public x;
    public y;
    public dir;

    public constructor(x: number,y: number,dir: number) {
        this.x = x;
        this.y = y;
        this.dir = dir;
    }
}