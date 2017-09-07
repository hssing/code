namespace world {

    interface IView {
        build(): egret.DisplayObjectContainer;
        refresh(): void;
    }

    export class ViewBase implements IView {

        protected data: any;
        protected view: any;
        protected root: egret.DisplayObjectContainer;
        protected manager: Manager;
        protected worldMap: mo.TMap;
        protected cellSize: {width, height};

        public constructor(mgr: Manager, root: egret.DisplayObjectContainer, data: any) {
            this.manager = mgr;
            this.data = data;
            this.root = root;
            this.worldMap = mgr.getWorldMap();
            let info = this.worldMap.getInfo();
            this.cellSize = {width : info.cw, height : info.ch, };

            this.view = this.build();
            
            this.root.addChild(this.view);
            this.refresh();
        }

        public dispose() {
            this.destroy();
        }

        protected createView(imgPath): egret.DisplayObjectContainer {
            let view = new egret.DisplayObjectContainer();
            this.centerView(view);

            let bd: egret.Texture = RES.getRes(imgPath);
            let img = new eui.Image(bd);
            view.addChild(img);
            img.touchEnabled = false;
            img.width = bd.bitmapData.width;
            img.height = bd.bitmapData.height;
            this.alignLeftBottom(img);
            return view;
        }

        protected centerView(view: egret.DisplayObjectContainer) {
            [view.width, view.height] = [this.cellSize.width, this.cellSize.height];
            view.anchorOffsetX = view.width / 2;
            view.anchorOffsetY = view.height / 2;
        }

        protected alignLeftBottom(child: egret.DisplayObject): void {
            let parent = child.parent;
            child.y += parent.height - child.height;
        }

        public refresh(): void {
            let wpos = this.worldMap.cell2world(this.data.x, this.data.y);
            [this.view.x, this.view.y] = [wpos[0], wpos[1]];
        }

        public build(): egret.DisplayObjectContainer {
            return null;
        }

        public destroy() {
            this.root.removeChild(this.view);
            this.view = null;
        }

        public setData(data) {
            this.data = data;
        }

        public getData() {
            return this.data;
        }

        public getView() {
            return this.view;
        }
    }

}