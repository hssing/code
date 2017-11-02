namespace world {

    export let g_world_view:any;
    export class ArmyMgr {

        protected manager: Manager;
        protected root: any;
        protected views: any;
        protected data: any;

        private phalanxPoints = {}; //方阵坐标保存  生成部队如果存在方阵信息，则首先使用

        protected timer: egret.Timer
        public constructor(mgr: Manager, root) {
            this.manager = mgr;
            this.root = root;

            this.views = {};
        }

        public dispose() {
        }

        protected recycle(data: any): void {
            for (let k in this.views) { 
                if (!data[k]) {
                    this.removeArmy(k);
                }
            }         
        }

        public updatePath(info: any, id: number): void {
            if (this.views[id] ) {
                this.views[id].updatePath(info);
            }            
        }

        public updateData(data: any,world?:any): void {
            g_world_view = world;
            for (let k in data) {
                this.updateArmy(k, data[k]);
            }

            this.recycle(data);
        }

        public hitTestPoint(x: number, y: number): any[] {
            let ret = [];
            for (let k in this.views) {
                if (this.views[k].hitTestPoint(x, y)) {
                    ret.push(k);
                }
            }
            return ret;
        }

        protected updateArmy(k: string, info: any): void {
            if (this.views[k]) {
                this.views[k].setData(info);
                // this.views[k].refresh();
            }else {
                this.views[k] = this.buildArmy(info);
            }
        }

        protected buildArmy(info: any): any {
            return new ArmyView(this.manager, this.root, info);
        }

        protected removeArmy(id: number|string): void {
            this.views[id].dispose();
            delete this.views[id];   
        }

        protected deleteArmyData(id) {
            let world = LogicMgr.get(logic.World) as logic.World;
            world.getArmayData()
        }

        //TODO 待优化
        protected resetChildIndex() {
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

        public getPhalanxPoints () {
            return this.phalanxPoints;
        }        

        public getArmyViews() :any {
            return this.views;
        }
    }
}

