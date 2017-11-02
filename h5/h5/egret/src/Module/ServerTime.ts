namespace ServerTime {

    type TimeSt = {day, hour, min, sec};

    let diffTime = 0;

    // msecond: 服务器时间戳，单位毫秒
    export function setTime(msecond: number): void {
        diffTime = msecond - egret.getTimer();
    }

    //返回当前服务器时间, 单位毫秒
    export function getTime(): number {
        return egret.getTimer() + diffTime;
    }

    //获取时差, 单位秒
    export function getDiffTime(second): number {
        return Math.floor(second - getTime()/1000);
    }

    export function formatTime(t: TimeSt, split: string = ":"): string {
        let strArray = [];
        t.day > 0 && strArray.push(t.day >= 10 ? t.day : `0${t.day}`);
        strArray.push(t.hour >= 10 ? t.hour : `0${t.hour}`);
        strArray.push(t.min >= 10 ? t.min : `0${t.min}`);
        strArray.push(t.sec >= 10 ? t.sec : `0${t.sec}`);
        return strArray.join(split);
    }

    // 秒转换成时间格式（天，时，分，秒）
    export function secToDay(second: number): TimeSt {
        if (!second) {
            return { day : 0, hour : 0, min : 0, sec : 0, };
        }

        let ret = {
            day  : Math.floor(second / (24 * 60 * 60)),
            hour : Math.floor(second % (24 * 60 * 60) / (60 * 60)),
            min  : Math.floor(second % (60 * 60) / 60),
            sec  : second % 60,
        };

        return ret;
    }

}