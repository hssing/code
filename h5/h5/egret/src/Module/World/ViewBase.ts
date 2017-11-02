namespace world {

    interface IView {
        build(): egret.DisplayObjectContainer;
        refresh(): void;
        setBloodVisible(visible: boolean, delay: number): void;
    }

    export class ViewBase implements IView {

        protected data: any;
        protected view: any;
        protected root: egret.DisplayObjectContainer;
        protected imgBuild: eui.Image;
        protected manager: Manager;
        protected worldMap: mo.TMap;
        protected cellSize: {width, height};
        protected dataMonitor: {condition: string[], process, thisObject}[];

        public constructor(mgr: Manager, root: egret.DisplayObjectContainer, data: any) {
            this.manager = mgr;
            this.data = data;
            this.root = root;
            this.dataMonitor = [];
            this.worldMap = mgr.getWorldMap();
            let info = this.worldMap.getInfo();
            this.cellSize = {width : info.cw, height : info.ch, };

            this.view = this.build();
            if (this.view) {
                this.root.addChild(this.view);
            }
            this.refresh();
        }

        public dispose() {
            this.destroy();
        }

        protected createView(imgPath): egret.DisplayObjectContainer {
            let view = new egret.DisplayObjectContainer();
            this.centerView(view);
            
            this.imgBuild = new eui.Image();
            view.addChild(this.imgBuild);
            this.imgBuild.touchEnabled = false;
            this.updateFacade(imgPath);
            
            return view;
        }

        protected updateFacade(imgPath): void {
            let bd: egret.Texture = RES.getRes(imgPath);
            this.imgBuild.source = bd;
            this.imgBuild.width = bd.bitmapData.width;
            this.imgBuild.height = bd.bitmapData.height;
            this.alignLeftBottom(this.imgBuild);
        }

        protected centerView(view: egret.DisplayObjectContainer) {
            [view.width, view.height] = [this.cellSize.width, this.cellSize.height];
            view.anchorOffsetX = view.width / 2;
            view.anchorOffsetY = view.height / 2;
        }

        protected alignLeftBottom(child: egret.DisplayObject): void {
            let parent = child.parent;
            child.y = parent.height - child.height;
        }

        public refresh(): void {
            let wpos = this.worldMap.cell2world(this.data.x, this.data.y);
            [this.view.x, this.view.y] = [wpos[0], wpos[1]];
        }

        public build(): egret.DisplayObjectContainer {
            return null;
        }

        public setBloodVisible(visible: boolean, delay: number): void {
        }

        public destroy(): void {
            if (this.view && this.view.parent) {
                this.view.parent.removeChild(this.view);
                this.view = null;
            }
        }

        protected monitor(condition: string[], process: Function, thisObject: Object): void {
            this.dataMonitor.push(
                {
                    condition: condition,
                    process : process,
                    thisObject : thisObject,
                }
            );
        }

        protected processMonitor(oldData, newData): void {
            this.dataMonitor.forEach(v => {
                let dirty = false;
                for (let c of v.condition) {
                    dirty = dirty || (oldData[c] !== newData[c]);
                }
                if (dirty) {
                    v.process.call(v.thisObject, newData);
                }
            })
        }

        public setData(data: any) {
            let oldData = this.data;
            this.data = data;
            this.processMonitor(oldData, data);
        }

        public getData(): any {
            return this.data;
        }

        public hitTestPoint(x: number, y: number): boolean {
            return this.root.hitTestPoint(x, y);
        }

        public getView() {
            return this.view;
        }
    }

}