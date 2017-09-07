namespace LogicMgr {

    let singleton: Map<any, any> = new Map();

    export function get<T extends Logic>(cls: new () => T): T {
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
            step.value.dispose()
        }
    }
}