namespace NetMgr {

    let singleton: Map<any, any> = new Map();

    export function get<T extends NetMsg>(cls: new () => T): T {
        if (singleton.has(cls)) {
            return singleton.get(cls);
        }

        let ins = new cls();
        singleton.set(cls, ins);
        return ins;
    }

    export function disposeAll() {
        let iterator = this.singleton.values()[Symbol.iterator](), step;
        while(!(step = iterator.next()).done){
            step.value.dispose();
        }
    }

    let msgMap: Map<number, any> = new Map();

    export function getMsgCls(mainId): any {
        let modId = Math.floor(mainId / 100);
        return msgMap.get(modId);
    }

    export function init() {
        console.log("NetMgr init ..................");
        let msgNames = Object.getOwnPropertyNames(msg);
        for (let k of msgNames) {
            let ins = NetMgr.get(msg[k]);
            ins.init(Singleton(NetCenter));
            msgMap.set(ins.getModId(), msg[k]);
        }
    }

}

