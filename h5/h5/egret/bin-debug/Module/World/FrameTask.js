var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var world;
(function (world) {
    var FrameTask = (function () {
        function FrameTask(mgr, root) {
            this.tasks = [];
            this.count = 3;
            this.isStart = false;
            this.manager = mgr;
            this.root = root;
        }
        FrameTask.prototype.dispose = function () {
            this.clear();
        };
        FrameTask.prototype.push = function (func, target, param) {
            this.tasks.push({ target: target, func: func, param: param });
            if (!this.isStart) {
                this.start();
            }
        };
        FrameTask.prototype.clear = function () {
            this.tasks = [];
        };
        FrameTask.prototype.update = function () {
            var i = 0;
            for (var _i = 0, _a = this.tasks; _i < _a.length; _i++) {
                var t = _a[_i];
                if ((++i) > this.count) {
                    return;
                }
                t.func.call(t.target, t.param);
            }
            this.stop();
        };
        FrameTask.prototype.start = function () {
            this.root.addEventListener(egret.Event.ENTER_FRAME, this.update, this);
            this.isStart = true;
        };
        FrameTask.prototype.stop = function () {
            this.root.removeEventListener(egret.Event.ENTER_FRAME, this.update, this);
            this.isStart = false;
        };
        return FrameTask;
    }());
    world.FrameTask = FrameTask;
    __reflect(FrameTask.prototype, "world.FrameTask");
})(world || (world = {}));
//# sourceMappingURL=FrameTask.js.map