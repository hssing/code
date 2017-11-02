// TypeScript file

namespace utils {
    /**
     * //直角边求角度
     * sideA 对边
     * sideC 斜边
     */
    export function MahtSin(sideA: number ,sideC: number): number {
        //atan 是求反正切  asin求反正弦
        //atan 和 atan2 区别：
        //1：参数的填写方式不同；
        //2：atan2 的优点在于 如果 x2-x1等于0 依然可以计算，但是atan函数就会导致程序出错；
        //3：已经过滤掉 sideC == 0 的情况

        return 180/Math.PI * Math.asin(sideA / sideC);
    }

    export function GetCurrentTime(flag) {
        var currentTime = "";
        var myDate = new Date();
        var year = myDate.getFullYear();
        var month = parseInt(myDate.getMonth().toString()) + 1; //month是从0开始计数的，因此要 + 1
        if (month < 10) {
            month = parseInt("0" + month.toString());
        }
        var date = myDate.getDate();
        if (date < 10) {
            date = parseInt("0" + date.toString());
        }
        var hour = myDate.getHours();
        if (hour < 10) {
            hour = parseInt("0" + hour.toString());
        }
        var minute = myDate.getMinutes();
        if (minute < 10) {
            minute = parseInt("0" + minute.toString());
        }
        var second = myDate.getSeconds();
        if (second < 10) {
            second = parseInt("0" + second.toString());
        }

        var milliseconds = myDate.getMilliseconds();
        if (milliseconds < 10) {
            milliseconds = parseInt("0" + milliseconds.toString());
        }

        if(flag == "0")
        {
            currentTime = year.toString() + month.toString() + date.toString() + hour.toString() + minute.toString() + second.toString(); //返回时间的数字组合
        }
        else if(flag == "1")
        {
            currentTime = year.toString() + "/" + month.toString() + "/" + date.toString() + " " + hour.toString() + ":" + minute.toString() + ":" + second.toString()+ ":" + milliseconds.toString(); //以时间格式返回
        }
        return currentTime;
    }
}