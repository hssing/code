var LogicMgr;
(function (LogicMgr) {
    var singleton = new Map();
    function get(cls) {
        if (singleton.has(cls)) {
            return singleton.get(cls);
        }
        var ins = new cls();
        singleton.set(cls, ins);
        return ins;
    }
    LogicMgr.get = get;
    function disposeAll() {
        var iterator = this.singleton.values()[Symbol.iterator](), step;
        while (!(step = iterator.next()).done) {
            step.value.dispose();
        }
    }
    LogicMgr.disposeAll = disposeAll;
})(LogicMgr || (LogicMgr = {}));
//# sourceMappingURL=LogicMgr.js.map