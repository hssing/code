// TypeScript file

/**
 *
 * 人物类
 *
 */

class PlayerView extends  egret.DisplayObjectContainer {

    public vo:PlayerVO = new PlayerVO();
    public vo_temp:PlayerVO = new PlayerVO();
    protected _mcData:any;
    protected _mcTexture:egret.Texture;
    protected role:egret.MovieClip;
    protected role2:egret.MovieClip;
    protected mcDataFactory;
    public is8Dir = true; //测试8 个方向  false-12方向  true-8方向

    protected acName:string[] = ["idle","run","attack"];

    //6个方向
    protected acDir:string[] = ["up","up_45","right",
                                 "down_45","down","down_45",
                                 "right","up_45",];


    protected acNameIndex:number = 0; //当前动作
    protected acDirIndex:number = 0;  //当前方向
    protected timeOnEnterFrame = 0;   //最后角色移动动画结束时间  
    protected needChangeAction = false; //是否需要切换动画

    protected moveSpeed:number = 0.25; //移动速度
    protected moveTimeOneCell:number = 2000; //毫秒
    protected moveSpeedX:number = 0;
    protected moveSpeedY:number = 0;
    protected moveDisX:number = 0 ; //x y轴移动距离
    protected moveDisY:number = 0 ;
    protected targetX:number = 0; //目标点坐标
    protected targetY:number = 0;
    protected nameText:egret.TextField ; //
    protected towPointDis:number; //行走两点距离
    protected towPointCellNum:number; //行走两点间格子数

    protected actions:any[] = []; //动画单位数组

    //服务返回行走路径
    protected moveIndex:number = 0; 
    protected move_path:any[] = [];

    //行军跟随 
    protected points: Mpoint[] = [];
    protected queueFollowMaxFrameLength: number = 150; //队列跟随最大帧数     
    protected saveAllFollowFrame: number = 200 ; //跟随最大帧
    protected frontRole: RoleView ;// 跟随前面的对象

    //战斗
    protected progressBar:ProgressBar; //血条
    protected attackView:RoleView; //攻击对象

    public static static_index:number = 0; //临时

    //data服务器返回数据
    public data:any ; 

    //回调方法
    private goToTargetCallBack:Function = undefined;

    // private timer: egret.Timer
    private shape:egret.Shape;
    private root:any;

    protected info:any;  //构建地图数据
    public constructor(root?:any) {
        super();

        this.width = mo.TMap.getMainData().getResult().info.cw;
        this.height = mo.TMap.getMainData().getResult().info.ch;
        this.anchorOffsetX = this.width / 2;
        this.anchorOffsetY = this.height / 2;

        this.init();
        this.root = root;
        PlayerView.static_index++;


        this.shape =  new egret.Shape();
        this.root.addChild(this.shape);

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

    public atttack(attack_info_list) {
            // console.log(this.vo.getId() +" == 我是定时器......");
            
            //如果有攻击目标
            if (this.getAttackView()) {

                let damage_info_list = attack_info_list.damage_info_list
                let defender_hp = damage_info_list.defender_hp;
                let damage = damage_info_list.damage;

                for (let i = 0 ; i < this.actions.length ; i++) {
                    let action = this.actions[i];
                    
                    if (action.hasEventListener(egret.Event.LOOP_COMPLETE)){
                        console.log("存在事件...");
                    }else{
                        console.log("不存在事件...");
                        action.addEventListener(egret.Event.LOOP_COMPLETE,(e)=>{ 
                            //寻找被击打目标。执行掉血

                            this.setAcNameIndex(0);
                            action.movieClipData = this.mcDataFactory.generateMovieClipData(this.acName[this.acNameIndex] + "_" + this.acDir[this.acDirIndex]);
                            action.gotoAndPlay(1,-1);    
                        } , this);                    
                    }

                }
                
                let targetView = this.getAttackView();
                targetView.hurtAndRefresh(damage);
                targetView.vo.setCurHp(defender_hp);
                Prompt.popTip(targetView.getVO().getId() + "掉血" + damage);

                this.setAcNameIndex(2);
                this.playAction();  
            }
     }     


    //初始化 角色数据
    public updateVO(vo: any,temp_vo?:any) { 
        //  this.vo.setId(vo.role_id);

        //  this.vo.setXY(vo.x,vo.y);
         this.vo = vo;
         this.vo_temp = temp_vo;
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

    public setAttackView(attackView: RoleView) {
        this.attackView = attackView;
    }

    public getAttackView() : RoleView {
        return this.attackView;
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
        let self =this; 

        this._mcData = RES.getRes("role_" + this.vo.getModelId() + "_json");//JSON  
        this._mcTexture = RES.getRes("role_" + this.vo.getModelId() + "_png");//Texture         

        this.mcDataFactory = new egret.MovieClipDataFactory(this._mcData, this._mcTexture);

        let unitCount = this.vo.getUnitCount();
    
        this.acDirIndex = Math.floor((Math.random() * 10) % 7);
 
        //构建小地图, N维方阵， 偏移 ox, oy，用于微调部队位置
        let coordinate = UIMgr.getWorld().getMap().createCoordinate(Math.sqrt(unitCount), 0, 0); 
        this.info = coordinate.getInfo();
        for( let i = 0 ; i < unitCount ; i++ ) {
            var action = new egret.MovieClip(this.mcDataFactory.generateMovieClipData(this.acName[this.acNameIndex] + "_" + this.acDir[this.acDirIndex])); //run_l_d_d

            this.addChild(action);
            action.scaleX = 0.7;
            action.scaleY = 0.7;
            this.actions.push(action);

            let [x,y] = coordinate.index2cell(i);
            let [x1,y1] = coordinate.cell2world(x,y);            

            action.x = x1 ;
            action.y = y1 ;

            action.gotoAndPlay(1,-1);

            // action.addEventListener(egret.Event.LOOP_COMPLETE, e=>{ {
            //     console.log("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
            //     this.setAcNameIndex(0);
            //     // action.gotoAndPlay(1,-1);
            // }}, this);   
          

        // action.addEventListener(egret.Event.LOOP_COMPLETE, function (e:egret.Event):void {
            
        //     egret.log("play times:");
        // }, this);                     
        }

        //血槽 
        this.progressBar = new ProgressBar();
        this.progressBar.setProgress(this.vo.getPecentHp());
        let scale = 0.4;
        this.progressBar.scaleX = scale;
        this.progressBar.scaleY = scale;
        this.progressBar.anchorOffsetX = this.progressBar.width / 2;
        this.progressBar.x = this.width / 2;
        this.addChild(this.progressBar); 
    }
    
    //服务器返回人物移动
    public updatePath(data) {
        this.move_path = data.move_path;
        this.moveIndex = 0; //行走下标重置
        this.moveOnePath();
    }

    //路径分解
    public moveOnePath() {
        let cellX = this.move_path[this.moveIndex].x;
        let cellY = this.move_path[this.moveIndex].y;

        this._moveOnePath(cellX,cellY);
    }

    public _moveOnePath(cellX,cellY ,callBack?:Function) {
        this.goToTargetCallBack = callBack;

        let [targetX,targetY] = UIMgr.getWorld().getMap().cell2world(cellX,cellY);

        this.vo.setCellXY(cellX,cellY);
        if(targetX === this.x && targetY === this.y){
            return ;
        }
        this.stage.removeEventListener(egret.Event.ENTER_FRAME,this.bgMove,this);  
        // this.acNameIndex = 1;
        this.setAcNameIndex(1);
        this.targetX = targetX;
        this.targetY = targetY;   


        let disX = Math.abs(this.targetX - this.x);
        let disY = Math.abs(this.targetY - this.y);
        this.towPointDis = Math.sqrt(disX * disX + disY * disY); //两点距离
        
        let [curCellX,curCellY] = UIMgr.getWorld().getMap().world2cell(this.x,this.y);

        let xCellNum = Math.abs(cellX - curCellX);
        let yCellNum = Math.abs(cellY - curCellY);
        this.towPointCellNum = xCellNum > yCellNum ? xCellNum : yCellNum ; 
        
        this.moveDisX = targetX - this.x;
        this.moveDisY = targetY - this.y;
        //斜边长
        var  xiexianDis = Math.sqrt(this.moveDisX*this.moveDisX + this.moveDisY*this.moveDisY);

        this.moveSpeedX = this.moveDisX / xiexianDis * this.moveSpeed;
        this.moveSpeedY = this.moveDisY / xiexianDis * this.moveSpeed;

        // this.acDirIndex = this.calculateDir(this.moveDisX,this.moveDisY,xiexianDis);
        this.setAcDirIndex(this.calculateDir(this.moveDisX,this.moveDisY,xiexianDis));
        // egret.log(this.acDirIndex);
        this.playAction();
      
        this.timeOnEnterFrame = egret.getTimer();
        this.stage.addEventListener(egret.Event.ENTER_FRAME,this.bgMove,this);  

        this.moveIndex++;        
    }

    public calculateDis() {

    }

    public calculateSpeed( useTime): number{
            return this.towPointDis / (this.moveTimeOneCell * this.towPointCellNum) * useTime;
    }

    //计算人物角度
    public calculateDir(moveDisX: number,moveDisY: number,xiexianDis: number): number {
        let angelTotal = 0 ; // 区块矫正 角度

        if(moveDisX >= 0 ){ //右半部分
            if(moveDisY >= 0){ //右下部分
                let angle = utils.MahtSin(moveDisY ,xiexianDis);
                angelTotal = angle + 90;
            }else{ //右上部分
                // console.log('moveDisY == ' + moveDisY);
                let angle = utils.MahtSin(moveDisY ,xiexianDis);
                // console.log('angle == ' + angle);
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
        let dirIndex = Math.ceil((angelTotal)/ ( 45));
        return dirIndex - 1;
    }


    public bgMove(evt:egret.Event): void {
        var now = egret.getTimer();  
        var pass = this.timeOnEnterFrame;  
        var useTime = now - pass;    

        // if (this.towPointDis > 100){
        //     this.setMoveSpeed(0.5);
        // }else{
            //速度
            let moveSp = 1.1; //= this.calculateSpeed(useTime);
            this.setMoveSpeed(moveSp);
            // console.log("moveSp ======================= " + moveSp);
            //斜边长
            var  xiexianDis = Math.sqrt(this.moveDisX*this.moveDisX + this.moveDisY*this.moveDisY);

            this.moveSpeedX = this.moveDisX / xiexianDis * this.moveSpeed;
            this.moveSpeedY  = this.moveDisY / xiexianDis * this.moveSpeed;
        // }
       
        this.moveUpdate();
        this.timeOnEnterFrame = egret.getTimer();  
    }

    /**
     * 移动坐标
     */
    public moveUpdate() {
        this.x +=this.moveSpeedX;
        this.y +=this.moveSpeedY;
        this.vo.setX(this.x);
        this.vo.setY(this.y);
        this.recordMovePath(this.x,this.y,this.acDirIndex);

        this.chectReach(this.x,this.y,this.targetX,this.targetY);

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
        // if (!this.is8Dir){
        //     isScanleX = (acDirIndex === 3 || acDirIndex === 4 ||acDirIndex === 5 ||
        //     acDirIndex === 9 ||acDirIndex === 10 ||acDirIndex === 11 )
        // }else{
            isScanleX = (acDirIndex === 5 || acDirIndex === 6 ||acDirIndex === 7  )
        // }

        this._playAction(isScanleX,one);
    }

    public _playAction(isScanleX : boolean,one?:boolean) {
        for (let i = 0 ; i < this.actions.length ; i++) {
            let action = this.actions[i];
            if (isScanleX ){
                action.scaleX = -Math.abs(action.scaleX);
            }else{
                action.scaleX = Math.abs(action.scaleX);
            }
            action.movieClipData = this.mcDataFactory.generateMovieClipData(this.acName[this.acNameIndex] + "_" + this.acDir[this.acDirIndex]);
            action.gotoAndPlay(1,one?0:-1);        
        }
 
    }
   
    public ReachToChangeAction() {
        if(this.moveIndex >= this.move_path.length) {
            this.stage.removeEventListener(egret.Event.ENTER_FRAME,this.bgMove,this);  
            this.setAcNameIndex(0);
            // this.acNameIndex = 0;
            this.playAction();

            if (this.goToTargetCallBack !== undefined){
                this.goToTargetCallBack(this);
                this.goToTargetCallBack = undefined;
            }
            console.log("到达目的地...切换待机状态... ");
        }else{
             console.log("走完 等待服务器返回...... ");
            // this.moveOnePath();
        }
    
    }

    /**
     * 检测是否走到终点
     */
    public chectReach(playerX: number,playerY: number,targetX: number,targetY: number): boolean {
        //test 8方向和12方向
        switch(this.acDirIndex){
            case 0:
            case 1:
            case 7:
                if (  playerY <= targetY){
                    this.ReachToChangeAction();
                }            
                break;
            case 3:
            case 4:
            case 5:
                if (  playerY > targetY){
                    this.ReachToChangeAction();
                }              
                // if (playerX >= targetX && playerY >= targetY){
                // if (playerX >= targetX && playerY >= targetY){
                //     this.ReachToChangeAction();
                // }
                break;
            case 2:
                if (playerX >= targetX){
                    this.ReachToChangeAction();
                }                
                break; 
            case 6:
                if (playerX <= targetX){
                    this.ReachToChangeAction();
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
        this.stage.addEventListener(egret.Event.ENTER_FRAME,this.followMove,this);  
    }

    public getFrontRoleView() : RoleView {
        return this.frontRole;
    }

    public disFrontRoleView() {
        this.frontRole = undefined;
        this.stage.removeEventListener(egret.Event.ENTER_FRAME,this.followMove,this);  
    }

    public followMove() {
        let point:Mpoint = this.getRecordPrevious();
        
        if (point) {
            // this.acNameIndex = 1;
            this.setAcNameIndex(1);
            this.moveUpdateFollow(point.x , point.y ,point.dir);
        }else{
            this.setAcNameIndex(0);
        //    this.acNameIndex = 0;
            this.playAction();
            //test  算伤害
            // this.hurtAndRefresh(1);
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
        // this.x +=this.moveSpeedX;
        // this.y +=this.moveSpeedY;
        this.x = x;
        this.y = y;
        this.setAcDirIndex(dir);
        // this.acDirIndex = dir;
        this.vo.setX(this.x);
        this.vo.setY(this.y);

        let [cellX,cellY] = UIMgr.getWorld().getMap().world2cell(this.x,this.y);

        this.vo.setCellXY(cellX,cellY);
        
        this.recordMovePath(this.x,this.y,this.acDirIndex);
        
        // this.parent.setChildIndex( this,Math.ceil(this.y));

        this.playAction();
    }


    //战斗掉血相关
    public hurtAndRefresh(hurt:number) {
        this.vo.setCurHp(this.vo.getCurHp() - hurt);
        this.progressBar.setProgress(this.vo.getPecentHp());

        var aa = false 
        while ( (this.actions.length - 1) * ( 100 /this.vo.getUnitCount()) / 100 >= this.vo.getPecentHp() ){
            let action = this.actions.splice(this.actions.length - 1 ,1)[0] ;
            // action.parent
            action.parent.removeChild(action);
            console.log("倒下一个..... = " + this.actions.length);
        }

        if(this.actions.length <= 0) {
            console.log("该方阵死亡..........!!!" + typeof(this));

            //  console.log("here.......///////////////////////" );
            this.dispose();
        }
    }

    public dispose() { 
         this.stage.removeEventListener(egret.Event.ENTER_FRAME,this.followMove,this);  
         this.stage.removeEventListener(egret.Event.ENTER_FRAME,this.bgMove,this);  
         this.parent.removeChild(this);
        //  console.log(" ********************this.parent.removeChild(this); == ");
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