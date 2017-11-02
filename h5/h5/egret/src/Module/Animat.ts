namespace ui {
    
    // usage:  async 动画同步
    /*    
        private async runAni() {
            console.log("start ani");
            // usage 1
            await ui.Animat.play("resource/ui/AnimationUISkin.exml", "start", this);

            // usage 2
            let ani = await ui.Animat.create("resource/ui/AnimationUISkin.exml") as ui.Animat;
            this.addChild(ani);
            ani["btnClose"].scaleX = 0.2;
            await ani.play("start");

            console.log("start timer");
            await Timer.afterAsync(2000);
            console.log("finish");
        }
    */

    export class Animat extends eui.Component {

        public static play(skinName: string, name: string, parent: any, remove: boolean = true, frame: number = 0): any {
            let ret = Animat.create(skinName);
            ret.then((ani: Animat) => {parent.addChild(ani); return ani;});
            return ret.then((ani: Animat) => ani.play(name, remove, frame));
        }

        public static create(skinName: string): any {
            let ret = new Animat();
            return new Promise((resolve, reject) => {
                    ret.once(eui.UIEvent.COMPLETE, ()=>resolve(ret), this);
                    ret.skinName = skinName;
            });
        }

        public play(name: string, remove: boolean = true, frame: number = 0): any {
            this.verticalCenter = 0;
            this.horizontalCenter = 0;
            
            let tween = this[name] as egret.tween.TweenGroup;
            tween.play(frame);
            return new Promise((resolve, reject) => {
                tween.once("complete", () => {
                    if (remove && this.parent) {
                        this.parent.removeChild(this);
                    }
                    resolve();
                }, this);
            });
        }

        public playLoop(name: string, frame: number = 0): any {
            this.verticalCenter = 0;
            this.horizontalCenter = 0;

            let tween = this[name] as egret.tween.TweenGroup;
            tween.play(frame);
            if (tween.hasEventListener("complete")) { return; }
            tween.addEventListener("complete", () => this.playLoop(name, frame), this);
        }

        private hasAnimation(name: string) {
            let tween = this[name] as egret.tween.TweenGroup;
            if (!(tween instanceof egret.tween.TweenGroup)){
                return false;
            }
            return true;
        }
    }

    // usage: UI 动画扩展
    /*
        playAnimation: (name: string, frame?: number)=>void;
        eui.sys.mixin(Login, ui.AnimatImpl);
    */

    export class AnimatImpl {

        private hasAnimation(name: string) {
            let tween = this[name] as egret.tween.TweenGroup;
            if (!(tween instanceof egret.tween.TweenGroup)){
                return false;
            }
            return true;
        }

        private playAnimationLoop(name: string, frame: number = 0): void {
            let tween = this[name] as egret.tween.TweenGroup;
            if (!(tween instanceof egret.tween.TweenGroup)){
                throw new Error(`Animation ${name} is not a TweenGroup`);
            }

            tween.play(frame);
            if (tween.hasEventListener("complete")) { return; }
            this["_tweenCache_"] = this["_tweenCache_"] || {};
            this["_tweenCache_"][name] = () => {
                this.playAnimationLoop(name, frame);
            };
            tween.addEventListener("complete", this["_tweenCache_"][name], this);
        }

        private stopAnimationLoop(name: string, reset: boolean = true): void {
            let tween = this[name] as egret.tween.TweenGroup;
            if (!(tween instanceof egret.tween.TweenGroup)){
                throw new Error(`Animation ${name} is not a TweenGroup`);
            }

            if (reset) { tween.play(0); }
            tween.stop();
            this["_tweenCache_"] = this["_tweenCache_"] || {};
            tween.removeEventListener("complete", this["_tweenCache_"][name], this);
        }

        private playAnimation(name: string, frame: number = 0): void {
            let tween = this[name] as egret.tween.TweenGroup;
            if (!(tween instanceof egret.tween.TweenGroup)){
                throw new Error(`Animation ${name} is not a TweenGroup`);
            }

            if (!tween.hasEventListener("complete") && this["onTweenGroupComplete"]) {
                tween.addEventListener("complete", this["onTweenGroupComplete"], this);
            }
            if (!tween.hasEventListener("itemComplete") && this["onTweenItemComplete"]) {
                tween.addEventListener("itemComplete", this["onTweenItemComplete"], this);
            }
            
            tween.play(frame);
        }
    }
}