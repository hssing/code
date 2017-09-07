var utils;
(function (utils) {
    function Enum(e) {
        var ret = {};
        var i = 0;
        for (var _i = 0, e_1 = e; _i < e_1.length; _i++) {
            var v = e_1[_i];
            ret[v] = i++;
        }
        return ret;
    }
    utils.Enum = Enum;
    function convert2Object(arr, func) {
        var ret = {};
        for (var _i = 0, arr_1 = arr; _i < arr_1.length; _i++) {
            var v = arr_1[_i];
            var key = func(v);
            ret[key] = v;
        }
        return ret;
    }
    utils.convert2Object = convert2Object;
    function intersectObject(n, o) {
        var ret = {};
        for (var k1 in n) {
            if (o[k1]) {
                ret[k1] = n[k1];
            }
        }
        return ret;
    }
    utils.intersectObject = intersectObject;
    function mergeObject(n, o) {
        for (var k in n) {
            o[k] = n[k];
        }
        return o;
    }
    utils.mergeObject = mergeObject;
    // for async
    function afterAsync(t) {
        var timer = new egret.Timer(t, 1);
        return new Promise(function (resolve, reject) {
            timer.addEventListener(egret.TimerEvent.TIMER_COMPLETE, function () { return resolve(timer); }, timer);
            timer.start();
        });
    }
    utils.afterAsync = afterAsync;
    function after(t, c, thisObject) {
        var timer = new egret.Timer(t, 1);
        timer.addEventListener(egret.TimerEvent.TIMER_COMPLETE, c, thisObject);
        timer.start();
        return timer;
    }
    utils.after = after;
    function repeat(t, c, thisObject) {
        var timer = new egret.Timer(t);
        timer.addEventListener(egret.TimerEvent.TIMER, c, thisObject);
        timer.start();
        return timer;
    }
    utils.repeat = repeat;
})(utils || (utils = {}));
//# sourceMappingURL=Misc.js.map