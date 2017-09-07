var SeverTime;
(function (SeverTime) {
    var diffTime = 0;
    // msecond: 服务器时间戳，单位毫秒
    function setTime(msecond) {
        diffTime = egret.getTimer() - msecond;
    }
    SeverTime.setTime = setTime;
    //返回当前服务器时间, 单位毫秒
    function getTime() {
        return egret.getTimer() + diffTime;
    }
    SeverTime.getTime = getTime;
    // 秒转换成时间格式（天，时，分，秒）
    function secToDay(second) {
        if (!second) {
            return { day: 0, hour: 0, min: 0, sec: 0, };
        }
        var ret = {
            day: Math.floor(second / (24 * 60 * 60)),
            hour: Math.floor(second % (24 * 60 * 60) / (60 * 60)),
            min: Math.floor(second % (60 * 60) / 60),
            sec: second % 60,
        };
        return ret;
    }
    SeverTime.secToDay = secToDay;
})(SeverTime || (SeverTime = {}));
//# sourceMappingURL=ServerTime.js.map