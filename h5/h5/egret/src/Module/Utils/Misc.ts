namespace utils {

    export function Enum(e: string[]): any {
        let ret = {}
        let i = 0;
        for (let v of e) {
            ret[v] = i++;
        }
        return ret;
    }

    export function convert2Object(arr: any[], func: Function): any {
        let ret = {};
        for (let v of arr) {
            let key = func(v);
            ret[key] = v;
        }
        return ret;
    }

    export function intersectObject(n: any, o: any): any {
        let ret = {};
        for (let k1 in n) {
            if (o[k1]) {
                ret[k1] = n[k1];   
            }
        }
        return ret;
    }

    export function mergeObject(n: any, o: any): any {
        for (let k in n) {
            o[k] = n[k];
        }
        return o;
    }

    // for async
    export function afterAsync(t: number): any {
        let timer: egret.Timer = new egret.Timer(t, 1);
        return new Promise((resolve, reject) => {
            timer.addEventListener(egret.TimerEvent.TIMER_COMPLETE, ()=>resolve(timer), timer);
            timer.start();
        });
    }

    export function after(t: number, c: Function, thisObject?: any): egret.Timer {
        let timer: egret.Timer = new egret.Timer(t, 1);
        timer.addEventListener(egret.TimerEvent.TIMER_COMPLETE, c, thisObject);
        timer.start();
        return timer;
    }

    export function repeat(t: number, c: Function, thisObject?: any): egret.Timer {
        let timer: egret.Timer = new egret.Timer(t);
        timer.addEventListener(egret.TimerEvent.TIMER, c, thisObject);
        timer.start();
        return timer;
    }
}