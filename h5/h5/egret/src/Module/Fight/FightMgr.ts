namespace Fight {

    let g_Fight_index = 0;
    //打击类型 
    export enum HIT_Type {
        TARGET = 1, //打目标
        GRID   = 2, //打格子
    }

    //攻击距离类型
    export enum ATTACK_TPYE {
        NEAR  = 1, //近战
        FAR   = 2, //远战
    }

    //子弹飞行类型 
    export enum BULLET_FLY_TYPE {
        STRAIGHT = 1, //直线
        CURVE    = 2, //曲线
    }

    export class FightMgr {

        private static fightMgrIns ;
        public static getFightMgrIns() {
            if (!FightMgr.fightMgrIns) {
                FightMgr.fightMgrIns =  new FightMgr();
            }
            return FightMgr.fightMgrIns;
        }


        //开始战斗 
        public playAttack(data: any,views?:RoleView,manager?: world.Manager, _dstPos?:any) {
            let atkInfo = data.attack_info_list;
            // this.stop();
            let [_x, _y] = manager.getWorldMap().cell2world(atkInfo[0].defender_x, atkInfo[0].defender_y);

            let _id = atkInfo[0].defender_id;
            let defenderView = manager.getPhalanxMgr().getViews()[atkInfo[0].defender_id];
            
            // let curView = defenderView.getRoleViews() ;
            //TODO
            let dstPos = { x : 0, y : 0};
            if (_dstPos) {
                dstPos = _dstPos;
            }else {
                if (defenderView) {
                    let dfView = defenderView.getMainViews();
                    dstPos.x = dfView.x;
                    dstPos.y = dfView.y;

                    views.setDirByTowPoints(dfView.x,dfView.y,views.x,views.y);
                }
            }

            let cfg = RES.getRes("SkillConfig_json");
            let info = cfg[data.skill_id];
            if (info && info.attack_type == ATTACK_TPYE.FAR){ //如果是远战
                g_Fight_index++;
                Singleton(Timer).after(10, world.g_world_view.Event("aaa" + g_Fight_index, 
                ()=>{
                    for (let i = 0 ; i < views.actions.length ; i++) {
                        let _action = views.actions[i];
                        this.createBullet(data.skill_id, atkInfo ,dstPos,_action,views.vo.getModelId(),views,manager);
                    }
                }));



            }
            views.setAcNameIndex(ACTION_NAME.ATTACK);
            views.playAction();    

            for (let i = 0 ; i < views.actions.length ; i++) {
                let action = views.actions[i];

                if (action.hasEventListener(egret.Event.LOOP_COMPLETE)){
                    // console.log("存在事件...");
                }else{
                    // console.log("不存在事件...");
                    action.addEventListener(egret.Event.LOOP_COMPLETE,(e)=>{ 
                        //寻找被击打目标。执行掉血
                        // this.setAcNameIndex(0);
                        views.setAcNameIndex(ACTION_NAME.IDLE);
                        action.movieClipData = views.mcDataFactory.generateMovieClipData(views.acName[views.getAcNameIndex()] + "_" + views.acDir[views.getAcDirIndex()]);
                        action.gotoAndPlay(1,-1);
                        action.removeEventListener(egret.Event.LOOP_COMPLETE);
                    } , this);
                }
            }            

        }

        public playDefend(defInfo: any,view:RoleView,manager:any,skill_id?:any): void {
            defInfo.damage_info_list.forEach((v)=>{
                let defender_hp = v.defender_hp;
                let damage = v.damage;
                view.hurtAndRefresh(damage);
                view.vo.setCurHp(defender_hp);

                let [_x, _y] = manager.getWorldMap().cell2world(defInfo.defender_x, defInfo.defender_y);

                var text:egret.TextField = new egret.TextField();
                text.text = "-" + damage;
                text.textColor = 0xff0000;
                view.addChild(text);

                egret.Tween.get(text)
                        .to({x : 0, y : 0}, 0)
                        .to({x : 0, y : -100}, 1000)
                        .call(()=> text.parent.removeChild(text));

                
                let cfg = RES.getRes("SkillConfig_json");
                let info = cfg[skill_id];
                if (info.hit_effect_res !== ""){

                    Actor.playOneAndRemove(info.hit_effect_res,"action",view);
                    // let action = new Animation(info.hit_effect_res);
                    // action.play(ACTION_NAME.IDLE,ACTION_DIR.UP,true);
                    // action.x += view.anchorOffsetX;
                    // action.y += view.anchorOffsetY;                
                    // view.addChild(action);                   
                }
            })            
        }   

        public createBullet(skillId, atkInfo: any,dstPos:any,action:any,attack_type:any,view:RoleView,manager:any): void {
            let cfg = RES.getRes("SkillConfig_json");
            let info = cfg[skillId];
            // if (!info) { return; }

            // if (info.bullet_fly_type === BULLET_FLY_TYPE.LINE) {
                let daa = atkInfo.p_attack_info;
                let srcPos = { x : view.x +action.x - view.anchorOffsetX , y : view.y +action.y - view.anchorOffsetY};
                // let dstPos = { x : atkInfo[0].defender_x, y : atkInfo[0].defender_y, };
                // [dstPos.x, dstPos.y] = this.manager.getWorldMap().cell2world(dstPos.x, dstPos.y);
                // let b = Fight.Bullet.create("bullet_png");
                if (info.bullet_fly_type == BULLET_FLY_TYPE.STRAIGHT  ){
                    // let b = Fight.Bullet.create("bullet_png");
                    // manager.getWorldMap().getNode().addChild(b.getView());
                    // b.lineTo(srcPos, dstPos); 
                    let bullet_res = info.bullet_res;

                    let cb = (b)=>{
                        manager.getWorldMap().getNode().addChild(b.getView());
                        b.curveTo(srcPos, dstPos,100,0);  
                    }
                    
                     Fight.BulletMax.create(bullet_res,undefined,cb);
                    // if(b.getView()){
                    //     manager.getWorldMap().getNode().addChild(b.getView());
                    //     b.curveTo(srcPos, dstPos,100,0);                              
                    // }else{
                    //     Prompt.popTip("子弹还没生成");
                    // }
               
                }else if (info.bullet_fly_type == BULLET_FLY_TYPE.CURVE){
                    let bullet_res = info.bullet_res;

                    let cb = (b)=>{
                        manager.getWorldMap().getNode().addChild(b.getView());
                        b.curveTo(srcPos, dstPos,200,60); 
                    }

                    Fight.BulletMax.create(bullet_res,undefined,cb);
                    // if(b.getView()){
                    //     manager.getWorldMap().getNode().addChild(b.getView());
                    //     b.curveTo(srcPos, dstPos,200,60); 
                    // }else{
                    //     Prompt.popTip("子弹还没生成");
                    // }
                }
            // }
        }        
    }
}