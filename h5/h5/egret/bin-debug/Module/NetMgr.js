var NetMgr;
(function (NetMgr) {
    var singleton = new Map();
    function get(cls) {
        if (singleton.has(cls)) {
            return singleton.get(cls);
        }
        var ins = new cls();
        singleton.set(cls, ins);
        return ins;
    }
    NetMgr.get = get;
    function disposeAll() {
        var iterator = this.singleton.values()[Symbol.iterator](), step;
        while (!(step = iterator.next()).done) {
            step.value.dispose();
        }
    }
    NetMgr.disposeAll = disposeAll;
    var msgMap = new Map();
    function getMsgCls(mainId) {
        var modId = Math.floor(mainId / 100);
        return msgMap.get(modId);
    }
    NetMgr.getMsgCls = getMsgCls;
    function init() {
        console.log("NetMgr init ..................");
        var msgNames = Object.getOwnPropertyNames(msg);
        for (var _i = 0, msgNames_1 = msgNames; _i < msgNames_1.length; _i++) {
            var k = msgNames_1[_i];
            var ins = NetMgr.get(msg[k]);
            ins.init(Singleton(NetCenter));
            msgMap.set(ins.getModId(), msg[k]);
        }
    }
    NetMgr.init = init;
})(NetMgr || (NetMgr = {}));
//# sourceMappingURL=NetMgr.js.map