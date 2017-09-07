// Timer: 跟实际游戏运行时间相关
var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var Timer = (function () {
    function Timer() {
        this.events = [];
    }
    Timer.prototype.dispose = function () {
        console.assert(this.events.length === 0);
    };
    Timer.prototype.unbind = function (event, data) {
        for (var i = 0; i < this.events.length; i++) {
            if (this.events[i].event === event) {
                this.events.splice(i, 1);
                return;
            }
        }
    };
    Timer.prototype.cancel = function (target, name) {
        target.EventTracer().cancel(name);
    };
    Timer.prototype.process = function () {
        var clock = egret.getTimer();
        while (this.events[0] && (this.events[0].clock <= clock)) {
            var item = this.events[0];
            var delta = clock - item.lastClock;
            this.events.splice(0, 1);
            this.queue(item);
            if (item.times === 1) {
                item.event.unbind();
            }
            if (item.times !== 0) {
                item.times = item.times - 1;
            }
            item.event.fire(delta);
        }
    };
    Timer.prototype.after = function (time, event) {
        return this.repeat(time, event, 1);
    };
    Timer.prototype.repeat = function (interval, event, times) {
        if (times === void 0) { times = 0; }
        var item = {
            event: event,
            interval: interval,
            times: times,
            clock: 0,
            lastClock: 0,
        };
        event.bind(this);
        this.queue(item);
        return event;
    };
    Timer.prototype.queue = function (item) {
        item.lastClock = egret.getTimer();
        item.clock = item.lastClock + item.interval;
        var index = 0;
        for (var i = 0; i < this.events.length; i++) {
            if (this.events[i].clock > item.clock) {
                break;
            }
            index = i + 1;
        }
        this.events.splice(index, 0, item);
    };
    return Timer;
}());
__reflect(Timer.prototype, "Timer", ["events.EventHandle"]);
//# sourceMappingURL=Timer.js.map