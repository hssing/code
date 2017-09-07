var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var NetMsg = (function (_super) {
    __extends(NetMsg, _super);
    function NetMsg() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.proto = "proto_proto";
        return _this;
    }
    NetMsg.prototype.init = function (manager) {
        this.netCenter = manager;
        this.nameIds = {};
        for (var k in this.subIds) {
            var name_1 = this.subIds[k];
            this.nameIds[name_1] = parseInt(k);
        }
    };
    NetMsg.prototype.on = function (name, event) {
        _super.prototype.on.call(this, name, event);
    };
    NetMsg.prototype.getModId = function () {
        return this.modId;
    };
    NetMsg.prototype.send = function (name, obj) {
        if (obj === void 0) { obj = {}; }
        console.log("+++++++ Send Msg: [" + this["__class__"] + " : " + name + "] +++++++", obj);
        var subId = this.nameIds[name];
        var buff = this.pack(subId, obj);
        var mainId = this.modId * 100 + subId;
        return this.netCenter.sendMessage(mainId, buff);
    };
    NetMsg.prototype.onRecv = function (mainId, data) {
        var subId = Math.floor(mainId % 100);
        var obj = this.unpack(subId, data);
        console.log("======= Recv Msg: [" + this["__class__"] + " : " + this.subIds[subId] + "] =======", obj);
        this.fireEvent(this.subIds[subId], obj);
    };
    NetMsg.prototype.pack = function (subId, obj) {
        var data = RES.getRes(this.proto);
        var root = protobuf.parse(data, { keepCase: true }).root;
        var parser = root.lookupType(this.subIds[subId]);
        var errMsg = parser.verify(obj);
        if (errMsg) {
            throw new Error(errMsg);
        }
        var message = parser.create(obj);
        var int8Arr = parser.encode(message).finish();
        var buff = int8Arr.buffer.slice(int8Arr.byteOffset, int8Arr.byteOffset + int8Arr.byteLength);
        return buff;
    };
    NetMsg.prototype.unpack = function (subId, buff) {
        var data = RES.getRes(this.proto);
        var root = protobuf.parse(data, { keepCase: true }).root;
        var parser = root.lookupType(this.subIds[subId]);
        return parser.decode(new Uint8Array(buff));
    };
    return NetMsg;
}(events.Base));
__reflect(NetMsg.prototype, "NetMsg");
//# sourceMappingURL=NetMsg.js.map