namespace world {

    export class UnitMgr {

        private manager: Manager;
        private worldMap: mo.TMap;
        private root: eui.Group;
        private views: any;
        private data: any;

        public constructor(mgr: Manager, root) {
            this.manager = mgr;
            this.root = root;
            this.worldMap = this.manager.getWorldMap();

            this.views = {};
            this.data = {};
        }

        public dispose() {
            for (let index in this.views) {
                this.views[index].dispose();
            }
        }

        public recycle(data: any): void {
            for (let k in this.views) {
                if (!data[k]) {
                    this.removeUnit(k);
                }
            }
        }

        public checkHasBuildUnit(info: any): boolean {
            let org = info.org;
            for (let k in this.views) {
                let unit = this.views[k];
                let data = unit.getData();
                let check = org ? (org.x === data.org.x && org.y === data.org.y)
                            : (info.x === data.x && info.y === data.y);
                if (check) {
                    return true;
                }
            }
            return false;
        }

        public updateData(data: any): void {
            this.recycle(data);
            for (let k in data) {
                this.updateUnit(k, data[k]);
            }
        }

        private updateUnit(k: string, info: any): void {
            if (this.views[k]) {
                this.views[k].setData(info);
                this.views[k].refresh();
                return;
            }

            if (info && !this.checkHasBuildUnit(info)) {
                this.buildUnit(k, info);
            }
        }

        public buildUnit(k: string, info: any): void {
            let nameCls = {
                [-3]: Ornament,
                [-2]: Block,
                [-1]: City,
                [1] : Castle,
                [2] : Camp,
                [3] : Acacdemy,
                [4] : Arsenal,
            }

            let cls = nameCls[info.type] || Castle;
            if (!cls) { return; }

            this.views[k] = new cls(this.manager, this.root, info);
        }

        // 建筑格子坐标cx, cy, visible: 是否显示； delay: 延时字段隐藏，单位毫秒
        public setBloodVisible(cx: number, cy: number, visible: boolean, delay?: number): void {
            let index = this.worldMap.cell2index(cx, cy);
            if (!this.views[index]) { return; }
            this.views[index].setBloodVisible(visible, delay);
        }

        private removeUnit(k: number|string): void {
            this.views[k].dispose();
            delete this.views[k];
        }

        public playDefend (defInfo,skill_id) {
              let x = defInfo.defender_x;
              let y = defInfo.defender_y;


              this.setBloodVisible(x,y,true,2000);
              let pos = this.manager.getListener().makePos(x,y);
              let view = this.views[pos];
              if (view) {
                defInfo.damage_info_list.forEach((v)=>{
                        let defender_hp = v.defender_hp;
                        let damage = v.damage;
                      
                        let [_x, _y] = this.manager.getWorldMap().cell2world(defInfo.defender_x, defInfo.defender_y);

                        var text:egret.TextField = new egret.TextField();
                        text.text = "-" + damage;
                        text.textColor = 0xff0000;
                        [text.x,text.y] =  [_x, _y] ;
                        this.root.addChild(text);

                        egret.Tween.get(text)
                                .to({x : _x, y : _y}, 0)
                                .to({x : _x, y : _y -100}, 1000)
                                .call(()=> text.parent.removeChild(text));

                        
                        let cfg = RES.getRes("SkillConfig_json");
                        let info = cfg[skill_id];
                        if (info.hit_effect_res !== ""){
                            // let action = new Animation(info.hit_effect_res);
                            // action.play(ACTION_NAME.IDLE,ACTION_DIR.UP,true);
                            // action.x = _x;
                            // action.y = _y;
                            // action.x += view.anchorOffsetX;
                            // action.y += view.anchorOffsetY;                
                            // this.root.addChild(action);  
                            Actor.playOneAndRemove(info.hit_effect_res,"action", this.root,_x,_y);                 
                        }
                })            
            }   
        }
    }

}