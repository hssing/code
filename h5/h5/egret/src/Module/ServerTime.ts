namespace SeverTime {

    let diffTime = 0;

    // msecond: 服务器时间戳，单位毫秒
    export function setTime(msecond: number): void {
        diffTime = egret.getTimer() - msecond;
    }

    //返回当前服务器时间, 单位毫秒
    export function getTime(): number {
        return egret.getTimer() + diffTime;
    }

    // 秒转换成时间格式（天，时，分，秒）
    export function secToDay(second: number): {day, hour, min, sec} {
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