class NetMsg extends events.Base {

    public proto: string = "proto_proto";
    public modId: number;
    public subIds: any;
    private netCenter: NetCenter;
    private nameIds: any;
    private static root: any;

    public init(manager: NetCenter): void {
        this.netCenter = manager;

        this.nameIds = {};
        for (let k in this.subIds) {
            let name = this.subIds[k];
            this.nameIds[name] = parseInt(k);
        }
    }

    public on(name: string, event: events.Event): void {
        super.on(name, event);
    }

    public getModId(): number {
        return this.modId;
    }

    private getProtoRoot(): any {
        if (NetMsg.root) { return NetMsg.root; }
        let data = RES.getRes(this.proto);
        NetMsg.root = protobuf.parse(data, { keepCase : true }).root;
        return NetMsg.root;
    }

    public send(name: string, obj: Object = {}): any {
        console.log(`+++++++ Send Msg: [${this["__class__"]} : ${name}] +++++++`, obj);

        let subId = this.nameIds[name];
        let buff = this.pack(subId, obj);
        let mainId = this.modId * 100 + subId;
        return this.netCenter.sendMessage(mainId, buff);
    }

    public onRecv(mainId: number, data: any) {
        let subId = Math.floor(mainId % 100);
        let obj = this.unpack(subId, data);

        console.log(ServerTime.formatTime(ServerTime.secToDay(ServerTime.getTime())) + ` ========== Recv Msg: [${this["__class__"]} : ${this.subIds[subId]}] =======`, obj);
        
        if (obj.ret_code !== undefined && (obj.ret_code !== 1)) {
            let error = DBRecord.fetchId("ServerErrorCodeConfig_json", obj.ret_code);
            if (error && error.display !== 0) {
                Prompt.popTip(`ERROR CODE: ${obj.ret_code} - ${error[config.LANGUAGE]}`);
            }else {
                Prompt.popTip(`ERROR CODE: ${obj.ret_code}`);
            }
            if (error && error.handle === 0 ) {
                return;
            }
        }
        this.fireEvent(this.subIds[subId], obj);
    }

    public pack(subId: number, obj: Object): any {
        let root = this.getProtoRoot();
        var parser = root.lookupType(this.subIds[subId]);

        if (DEBUG) {
            let errMsg = parser.verify(obj);
            if (errMsg) {
                throw new Error(errMsg);
            }
        }

        var message = parser.create(obj);
        let int8Arr = parser.encode(message).finish();
        let buff = int8Arr.buffer.slice(int8Arr.byteOffset, int8Arr.byteOffset + int8Arr.byteLength);
        return buff;
    }

    public unpack(subId: number, buff: ArrayBuffer): any {
        let root = this.getProtoRoot();
        var parser = root.lookupType(this.subIds[subId]);
        return parser.decode(new Uint8Array(buff));
    }
}