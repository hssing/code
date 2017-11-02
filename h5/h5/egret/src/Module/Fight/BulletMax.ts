namespace Fight {

    // usage: Fight.Bullet.create("bullet_png").lineTo({x:0, y:0}, {x:100, y:100});

    export class BulletMax extends Bullet{

        public static create(effectPath: string, parent?: egret.DisplayObjectContainer,cb?): Bullet {
            let objs: Bullet[] = Bullet.pool[effectPath] || [];
            if (objs.length > 0) {
                return objs.pop();
            }
            let o = new BulletMax(effectPath,cb);
            if (parent) {
                parent.addChild(o.getView());
            }
            return o;
        }    

        public addToChild(path,_cb?) {
            let cb = (display)=>{
                this.view = new egret.DisplayObjectContainer();
                this.view.addChild(display);
                this.display = display;
                _cb(this);

            }
            this.build(path,cb);
        }

        protected build(effectPath: string,cb): any {
            // console.log("effectPath ==== " + effectPath);
            Actor.createMC(effectPath,"action",cb); 
            // action.gotoAndPlay(1,-1);
            // let action = new Animation(effectPath);
            // action.play(ACTION_NAME.IDLE,ACTION_DIR.UP)
            // return action;
        }
    }
}