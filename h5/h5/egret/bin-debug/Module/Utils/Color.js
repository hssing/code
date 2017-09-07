var utils;
(function (utils) {
    // 颜色置灰
    function setGray(sprite) {
        var colorMatrix = [
            0.3, 0.6, 0, 0, 0,
            0.3, 0.6, 0, 0, 0,
            0.3, 0.6, 0, 0, 0,
            0.0, 0.0, 0, 1, 0,
        ];
        var colorFlilter = new egret.ColorMatrixFilter(colorMatrix);
        sprite.filters = [colorFlilter];
    }
    utils.setGray = setGray;
    // 颜色还原
    function resetColor(sprite) {
        var colorMatrix = [
            1, 0, 0, 0, 0,
            0, 1, 0, 0, 0,
            0, 0, 1, 0, 0,
            0, 0, 0, 1, 0,
        ];
        var colorFlilter = new egret.ColorMatrixFilter(colorMatrix);
        sprite.filters = [colorFlilter];
    }
    utils.resetColor = resetColor;
    // 替换颜色
    function setColor(sprite, c) {
        var colorMatrix = [
            0, 0, 0, 0, c.r || 0,
            0, 0, 0, 0, c.g || 0,
            0, 0, 0, 0, c.b || 0,
            0, 0, 0, 1, c.a || 0,
        ];
        var colorFlilter = new egret.ColorMatrixFilter(colorMatrix);
        sprite.filters = [colorFlilter];
    }
    utils.setColor = setColor;
    // 颜色变暗
    function setColorR(sprite, c) {
        var colorMatrix = [
            c.rr, 0, 0, 0, 0,
            0, c.gr, 0, 0, 0,
            0, 0, c.br, 0, 0,
            0, 0, 0, 1, 0,
        ];
        var colorFlilter = new egret.ColorMatrixFilter(colorMatrix);
        sprite.filters = [colorFlilter];
    }
    utils.setColorR = setColorR;
})(utils || (utils = {}));
//# sourceMappingURL=Color.js.map