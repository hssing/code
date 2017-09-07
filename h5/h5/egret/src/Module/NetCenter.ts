const INTERVAL: number = 100;      // 心跳
const OUTTIME: number = 1000;      // 检查时间间隔
const WAITTIME: number = 1000 * 5; // 超时断开重连
const NET_HEART = "NET_HEART";
const NET_WAITING = "NET_WAITING";

class NetCenter extends Logic {

    // socket event
    public static EVT = utils.Enum(
    [
        "CONN",
        "ERROR",
        "BUSY",
        "CLOSE",
    ]);


    //////////////////////////////////////////////
    // socket

    //////////////////////////////////////////////////////////////////////////
    //
    //	                                             |<--------------|
    //    disconnect--------->connecting---------->ready--------->waiting
    //	      |<-------------------|                 |               |
    //	      |<-------------------------------------|               |
    //	      |<-----------------------------------------------------|
    //
    //////////////////////////////////////////////////////////////////////////

    
    private sock: egret.WebSocket;
    private host: string = "";
    private port: number = 8000;
    private sendQueue: any = [];
    private order: number = 0;
    private state: string = "disconnect";

    private waitTime: number = 0;
    private isBusy: boolean = false;

    //连接服务器
    public connectServer(h?: string, p?: number): void {
        [this.host, this.port] = [h || this.host, p || this.port];
        this.doClose();
        this.doConnect();
    }

    public diconnectServer(): void {
        this.doClose();
    }

    public sendMessage(mainId: number, buff: ArrayBuffer): void {
        this.sendQueue.push({mainId : mainId, buff : buff});

        if (this.isState("disconnect")){
            return this.doConnect();
        }
    }

    private doClose() {
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
    }

    private doReConnect() {
        this.doClose();
        this.doConnect();
    }

    private doConnect() {
        if (this.host === "") { return; }

        this.sock = new egret.WebSocket();
        this.sock.type = "webSocketTypeBinary";
        this.sock.addEventListener(egret.ProgressEvent.SOCKET_DATA, this.onReceiveMessage, this);
        this.sock.addEventListener(egret.Event.CONNECT, this.onSocketOpen, this);
        this.sock.addEventListener(egret.Event.CLOSE, this.onSocketClose, this);
        this.sock.addEventListener(egret.IOErrorEvent.IO_ERROR, this.onSocketError, this);

        this.sock.connect(this.host, this.port);
        this.isBusy = false;
        this.toState("connecting");
    }

    private startTimer(): void {
        Singleton(Timer).repeat(INTERVAL, this.Event(NET_HEART, this.onHeartBeat));
        Singleton(Timer).repeat(OUTTIME, this.Event(NET_WAITING, this.onWaiting));
    }

    private sendNext() {
        if (this.sendQueue.length === 0) {
            return;
        }
        if (!this.isState("ready")) {
            return;
        }

        this.order++;
        let q = this.sendQueue.shift(); // quene[0];
        // console.log("doSendMessage");
        this.doSendMessage(q.mainId, q.buff);
    }

    private onSocketClose(): void {
        console.log("onSocketClose");
        this.toState("disconnect");

        this.fireEvent(NetCenter.EVT.CLOSE);
    }

    private onSocketError(): void {
        console.log("onSocketError");
        this.doClose();
        this.fireEvent(NetCenter.EVT.ERROR);
    }

    //连接成功返回
    private onSocketOpen(): void {
        console.log("onSocketOpen");
        this.startTimer();
        this.toState("ready");
        this.fireEvent(NetCenter.EVT.CONN);
        this.sendNext();
    }

    private onHeartBeat(): void {
        // console.log("onHeartBeat");
        this.sendNext();
    }

    private onWaiting(delta: number): void {
        // console.log("onWaiting");
        if (!this.isState("waiting")){
            this.waitTime = 0;
            return;
        }
        this.waitTime += OUTTIME;
        if (this.waitTime > WAITTIME) {
            return this.doReConnect();
        }
    }

    //消息返回  
    private onReceiveMessage(): void {
        // console.log("onReceiveMessage");
        this.doReceiveMessage();
        this.sendNext();
    }

    private doReceiveMessage(): void {
        this.toState("ready");
        let arr: egret.ByteArray = new egret.ByteArray();
        this.sock.readBytes(arr);
        let mainId = arr.readShort();
        let data: egret.ByteArray = new egret.ByteArray();
        arr.readBytes(data);
        
        let msgCls = NetMgr.getMsgCls(mainId);
        if (!msgCls) {
            throw new Error(`Net Receiver Error: ${mainId}`);
        }

        NetMgr.get(msgCls).onRecv(mainId, data.buffer);
    }

    //向服务端发送消息
    private doSendMessage(mainId: number, buff: ArrayBuffer): void {
        this.toState("waiting");
        let sendMsg: egret.ByteArray = new egret.ByteArray();
        sendMsg.writeShort(mainId);
        sendMsg.writeBytes(new egret.ByteArray(buff));
        this.sock.writeBytes(sendMsg);
    }

    private updateBusyState() {
        let busy = false;
        if (this.isState("connecting")) {
            busy = true;
        }else if (this.isState("waiting")) {
            busy = true; // (sendQueue.length !== 0);
        }

        if (this.isBusy === busy) {
            return;
        }

        this.isBusy = busy;
        this.fireEvent(NetCenter.EVT.BUSY, this.isBusy);
    }

    private toState(s: string): void {
        this.state = s;
        this.updateBusyState();
    }

    private isState(s: string): boolean {
        return this.state === s;
    }
}



