namespace utils {

    export function Enum(e: string[]): any {
        let ret = {}
        let i = 0;
        for (let v of e) {
            ret[v] = i++;
        }
        return ret;
    }

    ///////////////////////////////////////////////////////
    // Object
    export function deepCopy(obj: any): any {
        let str = JSON.stringify(obj);
        let ret = JSON.parse(str);
        return ret;
    }

    export function copyObject(obj: Object): any {
        let ret = {};
        for(let i in obj) {
            if(obj.hasOwnProperty(i)) {
                ret[i] = obj[i];
            }
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

    ///////////////////////////////////////////////////////
    // Egret Timer
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

    // 格式化字符串: utils.format("this is a %s, num: %d, detial: %j", "item", 50, {id: 1001});
    export function format(f: string, ...args): string {
        let i = 0;
        let len = args.length;
        let str = String(f).replace(/%[sdj%]/g, (x: string) => {
            if (x === "%%") return "%";
            if (i >= len) return x;
            switch (x) {
                case "%s": return String(args[i++]);
                case "%d": return String(Number(args[i++]));
                case "%j":
                    try {
                        return JSON.stringify(args[i++]);
                    } catch (_) {
                        return "[Circular]";
                    }
                default:
                    return x;
                }
        });

        return str;
    }

    ///////////////////////////////////////////////////////
    // String
    export function amount2KMGTP(amount: number): string {
        let getNumberText = (num, exp) => {
            let str = String(num / Math.pow(10, exp));
            let numText = str.match(/^(\d+\.\d)/);
            return numText && numText[1] || str;
        }

        let amountStr = "";
        if (amount >= Math.pow(10, 15)) {
            amountStr = `${getNumberText(amount, 15)}P`;
        }
        else if (amount >= Math.pow(10, 12)) {
            amountStr = `${getNumberText(amount, 12)}T`;
        }
        else if (amount >= Math.pow(10, 9)) {
            amountStr = `${getNumberText(amount, 9)}G`;
        }
        else if (amount >= Math.pow(10, 6)) {
            amountStr = `${getNumberText(amount, 6)}M`;
        }
        else if (amount >= Math.pow(10, 3)) {
            amountStr = `${getNumberText(amount, 3)}K`;
        }
        else {
            amountStr = String(amount);
        }

        return amountStr;
    }

}