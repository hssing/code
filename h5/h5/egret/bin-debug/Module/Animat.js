var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var ui;
(function (ui) {
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
    var Animat = (function (_super) {
        __extends(Animat, _super);
        function Animat() {
            return _super !== null && _super.apply(this, arguments) || this;
        }
        Animat.play = function (skinName, name, parent, remove, frame) {
            if (remove === void 0) { remove = true; }
            if (frame === void 0) { frame = 0; }
            var ret = Animat.create(skinName);
            ret.then(function (ani) { parent.addChild(ani); return ani; });
            return ret.then(function (ani) { return ani.play(name, remove, frame); });
        };
        Animat.create = function (skinName) {
            var _this = this;
            var ret = new Animat();
            return new Promise(function (resolve, reject) {
                ret.once(eui.UIEvent.COMPLETE, function () { return resolve(ret); }, _this);
                ret.skinName = skinName;
            });
        };
        Animat.prototype.play = function (name, remove, frame) {
            var _this = this;
            if (remove === void 0) { remove = true; }
            if (frame === void 0) { frame = 0; }
            this.verticalCenter = 0;
            this.horizontalCenter = 0;
            var tween = this[name];
            tween.play(frame);
            return new Promise(function (resolve, reject) {
                tween.once("complete", function () {
                    if (remove && _this.parent) {
                        _this.parent.removeChild(_this);
                    }
                    resolve();
                }, _this);
            });
        };
        Animat.prototype.playLoop = function (name, frame) {
            var _this = this;
            if (frame === void 0) { frame = 0; }
            this.verticalCenter = 0;
            this.horizontalCenter = 0;
            var tween = this[name];
            tween.play(frame);
            if (tween.hasEventListener("complete")) {
                return;
            }
            tween.addEventListener("complete", function () { return _this.playLoop(name, frame); }, this);
        };
        Animat.prototype.hasAnimation = function (name) {
            var tween = this[name];
            if (!(tween instanceof egret.tween.TweenGroup)) {
                return false;
            }
            return true;
        };
        return Animat;
    }(eui.Component));
    ui.Animat = Animat;
    __reflect(Animat.prototype, "ui.Animat");
    // usage: UI 动画扩展
    /*
        playAnimation: (name: string, frame?: number)=>void;
        utils.Mixins(Login, [ui.AnimatImpl]);
    */
    var AnimatImpl = (function () {
        function AnimatImpl() {
        }
        AnimatImpl.prototype.hasAnimation = function (name) {
            var tween = this[name];
            if (!(tween instanceof egret.tween.TweenGroup)) {
                return false;
            }
            return true;
        };
        AnimatImpl.prototype.playAnimationLoop = function (name, frame) {
            var _this = this;
            if (frame === void 0) { frame = 0; }
            var tween = this[name];
            if (!(tween instanceof egret.tween.TweenGroup)) {
                throw new Error("Animation " + name + " is not a TweenGroup");
            }
            tween.play(frame);
            if (tween.hasEventListener("complete")) {
                return;
            }
            this["_tweenCache_"] = this["_tweenCache_"] || {};
            this["_tweenCache_"][name] = function () {
                _this.playAnimationLoop(name, frame);
            };
            tween.addEventListener("complete", this["_tweenCache_"][name], this);
        };
        AnimatImpl.prototype.stopAnimationLoop = function (name, reset) {
            if (reset === void 0) { reset = true; }
            var tween = this[name];
            if (!(tween instanceof egret.tween.TweenGroup)) {
                throw new Error("Animation " + name + " is not a TweenGroup");
            }
            if (reset) {
                tween.play(0);
            }
            tween.stop();
            this["_tweenCache_"] = this["_tweenCache_"] || {};
            tween.removeEventListener("complete", this["_tweenCache_"][name], this);
        };
        AnimatImpl.prototype.playAnimation = function (name, frame) {
            if (frame === void 0) { frame = 0; }
            var tween = this[name];
            if (!(tween instanceof egret.tween.TweenGroup)) {
                throw new Error("Animation " + name + " is not a TweenGroup");
            }
            if (!tween.hasEventListener("complete") && this["onTweenGroupComplete"]) {
                tween.addEventListener("complete", this["onTweenGroupComplete"], this);
            }
            if (!tween.hasEventListener("itemComplete") && this["onTweenItemComplete"]) {
                tween.addEventListener("itemComplete", this["onTweenItemComplete"], this);
            }
            tween.play(frame);
        };
        return AnimatImpl;
    }());
    ui.AnimatImpl = AnimatImpl;
    __reflect(AnimatImpl.prototype, "ui.AnimatImpl");
})(ui || (ui = {}));
//# sourceMappingURL=Animat.js.map