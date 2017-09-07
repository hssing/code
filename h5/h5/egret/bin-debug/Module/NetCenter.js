var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var INTERVAL = 100; // 心跳
var OUTTIME = 1000; // 检查时间间隔
var WAITTIME = 1000 * 5; // 超时断开重连
var NET_HEART = "NET_HEART";
var NET_WAITING = "NET_WAITING";
var NetCenter = (function (_super) {
    __extends(NetCenter, _super);
    function NetCenter() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.host = "";
        _this.port = 8000;
        _this.sendQueue = [];
        _this.order = 0;
        _this.state = "disconnect";
        _this.waitTime = 0;
        _this.isBusy = false;
        return _this;
    }
    //连接服务器
    NetCenter.prototype.connectServer = function (h, p) {
        _a = [h || this.host, p || this.port], this.host = _a[0], this.port = _a[1];
        this.doClose();
        this.doConnect();
        var _a;
    };
    NetCenter.prototype.diconnectServer = function () {
        this.doClose();
    };
    NetCenter.prototype.sendMessage = function (mainId, buff) {
        this.sendQueue.push({ mainId: mainId, buff: buff });
        if (this.isState("disconnect")) {
            return this.doConnect();
        }
    };
    NetCenter.prototype.doClose = function () {
        console.log("doClose");
        if (this.sock) {
            this.sock.close();
            this.sock = null;
        }
        Singleton(Timer).cancel(this, NET_HEART);
        Singleton(Timer).cancel(this, NET_WAITING);
        this.sendQueue = [];
        this.waitTime = 0;
        this.order = 0;
    };
    NetCenter.prototype.doReConnect = function () {
        this.doClose();
        this.doConnect();
    };
    NetCenter.prototype.doConnect = function () {
        if (this.host === "") {
            return;
        }
        this.sock = new egret.WebSocket();
        this.sock.type = "webSocketTypeBinary";
        this.sock.addEventListener(egret.ProgressEvent.SOCKET_DATA, this.onReceiveMessage, this);
        this.sock.addEventListener(egret.Event.CONNECT, this.onSocketOpen, this);
        this.sock.addEventListener(egret.Event.CLOSE, this.onSocketClose, this);
        this.sock.addEventListener(egret.IOErrorEvent.IO_ERROR, this.onSocketError, this);
        this.sock.connect(this.host, this.port);
        this.isBusy = false;
        this.toState("connecting");
    };
    NetCenter.prototype.startTimer = function () {
        Singleton(Timer).repeat(INTERVAL, this.Event(NET_HEART, this.onHeartBeat));
        Singleton(Timer).repeat(OUTTIME, this.Event(NET_WAITING, this.onWaiting));
    };
    NetCenter.prototype.sendNext = function () {
        if (this.sendQueue.length === 0) {
            return;
        }
        if (!this.isState("ready")) {
            return;
        }
        this.order++;
        var q = this.sendQueue.shift(); // quene[0];
        // console.log("doSendMessage");
        this.doSendMessage(q.mainId, q.buff);
    };
    NetCenter.prototype.onSocketClose = function () {
        console.log("onSocketClose");
        this.toState("disconnect");
        this.fireEvent(NetCenter.EVT.CLOSE);
    };
    NetCenter.prototype.onSocketError = function () {
        console.log("onSocketError");
        this.doClose();
        this.fireEvent(NetCenter.EVT.ERROR);
    };
    //连接成功返回
    NetCenter.prototype.onSocketOpen = function () {
        console.log("onSocketOpen");
        this.startTimer();
        this.toState("ready");
        this.fireEvent(NetCenter.EVT.CONN);
        this.sendNext();
    };
    NetCenter.prototype.onHeartBeat = function () {
        // console.log("onHeartBeat");
        this.sendNext();
    };
    NetCenter.prototype.onWaiting = function (delta) {
        // console.log("onWaiting");
        if (!this.isState("waiting")) {
            this.waitTime = 0;
            return;
        }
        this.waitTime += OUTTIME;
        if (this.waitTime > WAITTIME) {
            return this.doReConnect();
        }
    };
    //消息返回  
    NetCenter.prototype.onReceiveMessage = function () {
        // console.log("onReceiveMessage");
        this.doReceiveMessage();
        this.sendNext();
    };
    NetCenter.prototype.doReceiveMessage = function () {
        this.toState("ready");
        var arr = new egret.ByteArray();
        this.sock.readBytes(arr);
        var mainId = arr.readShort();
        var data = new egret.ByteArray();
        arr.readBytes(data);
        var msgCls = NetMgr.getMsgCls(mainId);
        if (!msgCls) {
            throw new Error("Net Receiver Error: " + mainId);
        }
        NetMgr.get(msgCls).onRecv(mainId, data.buffer);
    };
    //向服务端发送消息
    NetCenter.prototype.doSendMessage = function (mainId, buff) {
        this.toState("waiting");
        var sendMsg = new egret.ByteArray();
        sendMsg.writeShort(mainId);
        sendMsg.writeBytes(new egret.ByteArray(buff));
        this.sock.writeBytes(sendMsg);
    };
    NetCenter.prototype.updateBusyState = function () {
        var busy = false;
        if (this.isState("connecting")) {
            busy = true;
        }
        else if (this.isState("waiting")) {
            busy = true; // (sendQueue.length !== 0);
        }
        if (this.isBusy === busy) {
            return;
        }
        this.isBusy = busy;
        this.fireEvent(NetCenter.EVT.BUSY, this.isBusy);
    };
    NetCenter.prototype.toState = function (s) {
        this.state = s;
        this.updateBusyState();
    };
    NetCenter.prototype.isState = function (s) {
        return this.state === s;
    };
    return NetCenter;
}(Logic));
// socket event
NetCenter.EVT = utils.Enum([
    "CONN",
    "ERROR",
    "BUSY",
    "CLOSE",
]);
__reflect(NetCenter.prototype, "NetCenter");
//# sourceMappingURL=NetCenter.js.map