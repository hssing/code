namespace Fight {

    // usage: Fight.Bullet.create("bullet_png", this).lineTo({x:0, y:0}, {x:100, y:100});

    export class Bullet {

        public static pool = {};

        public static create(effectPath: string, parent?: egret.DisplayObjectContainer): Bullet {
            let objs: Bullet[] = Bullet.pool[effectPath] || [];
            if (objs.length > 0) {
                return objs.pop();
            }
            let o = new Bullet(effectPath);
            if (parent) {
                parent.addChild(o.getView());
            }
            return o;
        }

        public static putInPool(key, obj) {
            Bullet.pool[key] = Bullet.pool[key] || [];
            Bullet.pool[key].push(obj);
        }
        
        private effectPath: string;
        public view: egret.DisplayObjectContainer;
        public display: any;
        private lastPos: mo.WPoint;

        public constructor(path: string,cb?) {
            this.lastPos = {x : 0, y : 0};
            this.effectPath = path;
            this.addToChild(path,cb);
        }

        public addToChild(path,cb?) {
            this.display = this.build(path,undefined);
            this.view = new egret.DisplayObjectContainer();
            this.view.addChild(this.display);
        }

        protected build(effectPath: string,cb): any {
            return new eui.Image(effectPath);
        }

        public getView(): egret.DisplayObjectContainer {
            return this.view;
        }

        public removeFromParent(): void {
            if (this.view.parent) {
                this.view.parent.removeChild(this.view);
            }
            Bullet.putInPool(this.effectPath, this);
        }

        public lineTo(srcPos: mo.WPoint, dstPos: mo.WPoint, time = 200): egret.Tween {
            return egret.Tween.get(this.view)
                    .to({x : srcPos.x, y : srcPos.y}, 0)
                    .to({x : dstPos.x, y : dstPos.y}, time)
                    .call(() => this.removeFromParent());
        }

        // height: 抛物线高度
        public curveTo(srcPos: mo.WPoint, dstPos: mo.WPoint, time = 200, height = 50): any {
            console.log("抛物线/////////================");
            this.view.x = srcPos.x;
            this.view.y = srcPos.y;

            egret.Tween.get(this.view)
                    .to({x : dstPos.x, y : dstPos.y}, time)
                    .call(() => this.removeFromParent());
            
            let xb = dstPos.x - srcPos.x;
            let yb = dstPos.y - srcPos.y;

            let ya = -1;
            let xa = (xb !== 0) ? (- ya * yb / xb) : 0;

            let pb = new egret.Point(xb, yb);
            let len = 1; // 1 - Math.abs((0 * xb + -1 * yb) / pb.length);
            let pa = new egret.Point(xa, ya);
            pa.normalize(len * height);

            egret.Tween.get(this.display)
                    .to({x : pa.x, y : pa.y}, time / 2, egret.Ease.sineOut)
                    .to({x : 0, y : 0}, time / 2, egret.Ease.sineIn);

            egret.Tween.get(this.display, {onChange : ()=>{
                let pt = {x : this.display.x + this.view.x, y : this.display.y + this.view.y};
                // let pt = this.display.parent.localToGlobal(this.display.x, this.display.y);
                let x = pt.x - this.lastPos.x;
                let y = pt.y - this.lastPos.y;
                let angle = Math.atan2(y, x);
               
                angle = 180 * angle / Math.PI;
                this.display.rotation = angle;
                this.lastPos = {x : pt.x, y : pt.y};
                
            }}).wait(time);

            egret.Tween.get(this.view).to({visible : false}).wait(10).to({visible : true});
        }
    }
}