namespace world {

    export class ArmyMgr {

        private manager: Manager;
        private root: any;
        private views: any;
        private data: any;
        private amryViews:any;

        private timer: egret.Timer
        public constructor(mgr: Manager, root) {
            this.manager = mgr;
            this.root = root;

            this.views = {};  //方阵 views ？
            this.amryViews = {}; //部队列表
            this.data = {};

            /*** 本示例关键代码段开始 ***/
            this.timer = new egret.Timer(1000, 0);

            this.timer.addEventListener(egret.TimerEvent.TIMER, this.resetChildIndex, this);       
            this.timer.start();            
        }

        public dispose() {
        }

        public recycle(data: any): void {
            // for (let k in this.views) { 
            //     if (!data[k]) {
            //         this.removeArmy(k);
            //     }
            // }
            for (let k in this.amryViews) { 
                if (!data[k]) {
                    this.removeArmy(k);
                }
            }            
        }

        public updatePath(info: any): void {
            if (this.amryViews[info.army_id] ) {
                if (info.status === 1) {
                    info.status = 0;
                    this.amryViews[info.army_id].updatePath(info);
                }
                // this.views[info.army_id].refresh();
            }            
        }

        // public updateArmyData(data: any): void {
        //     // console.log("armyId ==== " + data.armyId);
        //     for (let k in data){
        //         this.amryViews[data.armyId] = new ArmyView(data[k],this.manager,this.root);
        //         this.amryViews[data.armyId].mergeViews(this.views);
        //     }
        // }

        public updateData(data: any): void {
            // for (let k in data) {
            //     this.updateArmy(k, data[k]);
            // }

            for (let k in data) {
                if (this.amryViews[k]) {
                    this.amryViews[k].setData(data[k]);
                    this.amryViews[k].refresh();
                }else {
                    
                    this.amryViews[k] = new ArmyView(data[k],this.manager,this.root);
                    this.amryViews[k].mergeViews(this.views);
                }
            }

            this.recycle(data);
        }

        private updateArmy(k: string, info: any): void {
            //oldCreate 
            if (this.views[k]) {
                this.views[k].setData(info);
                this.views[k].refresh();
                // console.log("刷新......... == " + k);
            }else {
                this.views[k] = this.buildArmy(info);
                // console.log("创建......... == " + k);
            }   

            //new create
            // if (this.amryViews[k]) {
            //     // this.amryViews[k].setData(info);
            //     // this.amryViews[k].refresh();
            // }else {
            //     //new create
            //     this.amryViews[k] = new ArmyView(info,this.manager,this.root);
            //     this.amryViews[k].mergeViews(this.views);
            // }   

        }

        private buildArmy(info: any): Army {
            return new Army(this.manager, this.root, info);
        }

        private removeArmy(armyId: number|string): void {
            // this.views[armyId].dispose();
            // delete this.views[armyId];
            this.amryViews[armyId].dispose();
            let views = this.amryViews[armyId].getRoleViews();
            for (let k in views ) {
                 delete this.views[k];            
            }

            delete this.amryViews[armyId];    
                    
        }

        //TODO 待优化
        private resetChildIndex() {
            let views = this.getViews();
            
            let viewsArr = [];
            let i = 0;
            for ( let k in views) {
             
                // console.log(  k + "== k == " +   this.manager.getArmyMgr().getRoot().getChildIndex( views[k]));
                // (views[k] as RoleView).vo.getY;
                viewsArr[i] =  views[k];
                i++;
            } 

            let len = viewsArr.length;
            // console.log("len === " + len);
            for (let i = 0; i < len; i++)  
            {  
                for (let j = i + 1; j < len; j++)  
                {  
                    if (viewsArr[i].vo.getY() > viewsArr[j].vo.getY())  
                    {  
                    
                        this.swap(viewsArr,i,j);
                    }  
                }  
            }  

            for (let i = 0; i < len; i++) {
                 viewsArr[i].parent.setChildIndex( viewsArr[i],i);
            }
        }

        public swap(array, first, second) {
            var tmp = array[second];
            array[second] = array[first];
            array[first] = tmp;
            // return array; 
        }


        public getViews() : PlayerView{
            return this.views;
        }

        public getRoot() :any {
            return this.root;
        }

        public getArmyViews() :any {
            return this.amryViews;
        }
    }
}

