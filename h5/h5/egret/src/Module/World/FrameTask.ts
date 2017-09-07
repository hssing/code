namespace world {

    export class FrameTask {

        private manager: Manager;
        private root: eui.Group;
        private tasks = [];
        private count = 3;
        private isStart = false;

        public constructor(mgr: Manager, root: eui.Group) {
            this.manager = mgr;
            this.root = root;
        }

        public dispose() {
            this.clear();
        }

        public push(func: Function, target: Object, param: any): void {
            this.tasks.push({target : target, func : func, param : param});
            if (!this.isStart) {
                this.start();
            }
        }

        public clear(): void {
            this.tasks = [];
        }

        private update(): void {
            let i = 0;
            for (let t of this.tasks) {
                if ((++i) > this.count) {
                    return;
                }
                t.func.call(t.target, t.param);
            }
            this.stop();
        }

        private start(): void {
            this.root.addEventListener(egret.Event.ENTER_FRAME,this.update, this);
            this.isStart = true;
        }

        private stop(): void {
            this.root.removeEventListener(egret.Event.ENTER_FRAME,this.update, this);
            this.isStart = false;
        }
    }
}