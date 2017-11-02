namespace DBRecord {

    // 根据ID取出记录
    export function fetchId(name: string, id: any): any {
        let cfg = RES.getRes(name);
        return cfg ? cfg[id] : undefined;
    }

    // 根据ID取出字段的值
    export function fetchKey(name: string, id: any, key: string): any {
        let r = fetchId(name, id);
        return r ? r[key] : undefined;
    }

    // 取出所有满足 level=3 && grade=2 的记录
    // let infoArr = DBRecord.fetchKvs('BuildConfig_json', {level : 3, grade : 2})
    export function fetchKvs(name: string, kvs: Object): any[] {
        let ret = [];
        let cfg = RES.getRes(name);
        if (!cfg) { return ret; }

        let ids = Object.keys(cfg);
        for (let id of ids) {
            let ok = true;
            for (let k in kvs) {
                ok = ok && (cfg[id][k] === kvs[k]);
            }
            if (ok) {
                ret.push(cfg[id]);
            }
        }
        return ret;
    }

    // 取出所有记录
    export function fetchAll(name: string): any[] {
        let ret = [];
        let cfg = RES.getRes(name);
        if (!cfg) { return ret; }

        let ids = Object.keys(cfg);
        for (let id of ids) {
            ret.push(cfg[id]);
        }
        return ret;
    }

    // 本地化转换
    export function text(id: number): string {
        let s = fetchId("TextConfig_json", id);
        return s ? s[config.LANGUAGE] : `${id}`;
    }
}

// 本地化转换
const LTEXT = DBRecord.text;