

namespace world {

    export class PhalanxMgr extends ArmyMgr {

        public updataFight(data) {
            if (!data) { return; }
            this.parseReport(data);
        }

        protected buildArmy(info: any): any {
            return new Phalanx(this.manager, this.root, info);
        }

        protected parseReport(data: any) {
            let id = data.attacker_id;
            let dstPos ;
            data.attack_info_list.forEach((defData) => {
                // console.log("defData.defender_id === " + defData.defender_type);
                if (defData.defender_type === 4) { //建築
                    this.manager.getBuildMgr().playDefend(defData,data.skill_id);
                    if (this.views[id]) {
                        let [_x, _y] = this.manager.getWorldMap().cell2world(defData.defender_x, defData.defender_y);
                        this.views[id].setDirByTowPoints(_x, _y)
                        dstPos = {x:_x,y:_y};
                    }
                }else if(defData.defender_type === 2) { // 敵人
                    let view = this.views[defData.defender_id];
                    if (view) {
                        view.playDefend(defData,data.skill_id);
                    }        
                }
            })

            if (this.views[id]) {
                this.views[id].playAttack(data ,dstPos);
            }

        }
    }
}

