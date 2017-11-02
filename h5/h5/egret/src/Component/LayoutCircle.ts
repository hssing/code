namespace uilayout {

    let UIComponentClass = "eui.UIComponent";

    /**自定义的环形布局类*/
    export class RingLayout extends eui.LayoutBase {

        // 起始角度
        private radian: number;
        public constructor(angle: number = 30) {
            super();
            this.radian = angle * Math.PI / 180;
        }

        /**
         * 计算target的尺寸
         * 因为环形布局，依赖容器尺寸来定义半径，所以需要容器显式的设置width和height,在这种情况下measure方法将失去作用
         * 所以在这个例子里面，不需要重写measure方法
         * 如果您的自定义布局需要根据内部子项计算尺寸，请重写这个方法
         **/
        public measure(): void{
            super.measure();
        }

        /**
         * 重写显示列表更新
         */
        public updateDisplayList(unscaledWidth: number, unscaledHeight: number): void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if (this.target === null) { return;}

            let centerX: number = unscaledWidth / 2; // 获得容器中心的X坐标
            let centerY: number = unscaledHeight / 2; // 获得容器中心的Y坐标
            
            let count: number = this.target.numElements;
            let maxX: number = 0;
            let maxY: number = 0;

            let [offset, radius] = [this.radian, centerY];
            let startRadian = Math.floor(count / 2) * offset - ((count+1) % 2) * offset / 2;
            for (let i: number = 0; i < count; i++) {
                let layoutElement: eui.UIComponent = <eui.UIComponent>(this.target.getElementAt(i));
                if (!egret.is(layoutElement, UIComponentClass) || !layoutElement.includeInLayout) {
                    continue;
                }

                let angle: number = startRadian - i * offset;
                let childX: number = centerX + radius * Math.cos(angle); // 获得圆周点的X坐标
                let childY: number = centerY - radius * Math.sin(angle); // 获得圆周点的Y坐标

                let x = childX - layoutElement.width / 2;
                let y = childY - layoutElement.height / 2;
                layoutElement.setLayoutBoundsPosition(x, y);
                maxX = Math.max(maxX, childX);
                maxY = Math.max(maxY, childY);
            }
            this.target.setContentSize(maxX, maxY);
        }
    }
}