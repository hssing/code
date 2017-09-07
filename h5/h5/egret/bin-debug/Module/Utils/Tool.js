// TypeScript file
var utils;
(function (utils) {
    /**
     * //直角边求角度
     * sideA 对边
     * sideC 斜边
     */
    function MahtSin(sideA, sideC) {
        //atan 是求反正切  asin求反正弦
        //atan 和 atan2 区别：
        //1：参数的填写方式不同；
        //2：atan2 的优点在于 如果 x2-x1等于0 依然可以计算，但是atan函数就会导致程序出错；
        //3：已经过滤掉 sideC == 0 的情况
        return 180 / Math.PI * Math.asin(sideA / sideC);
    }
    utils.MahtSin = MahtSin;
})(utils || (utils = {}));
//# sourceMappingURL=Tool.js.map