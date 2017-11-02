namespace utils {

    // 颜色置灰
    export function setGray(sprite: egret.DisplayObject): void {
        let colorMatrix = [
            0.3,0.6,0,0,0,
            0.3,0.6,0,0,0,
            0.3,0.6,0,0,0,
            0.0,0.0,0,1,0,
        ];
        let colorFlilter = new egret.ColorMatrixFilter(colorMatrix);
        sprite.filters = [colorFlilter];
    }

    // 颜色还原
    export function resetColor(sprite: egret.DisplayObject): void {
        let colorMatrix = [
            1,0,0,0,0,
            0,1,0,0,0,
            0,0,1,0,0,
            0,0,0,1,0,
        ];
        let colorFlilter = new egret.ColorMatrixFilter(colorMatrix);
        sprite.filters = [colorFlilter];
    }

    // 替换颜色
    export function setColor(sprite: egret.DisplayObject, c: {r?: number, g?: number, b?: number, a?: number}): void {
        let colorMatrix = [
            0,0,0,0,c.r||0,
            0,0,0,0,c.g||0,
            0,0,0,0,c.b||0,
            0,0,0,1,c.a||0,
        ];
        let colorFlilter = new egret.ColorMatrixFilter(colorMatrix);
        sprite.filters = [colorFlilter];
    }

    // 颜色变暗
    export function setColorR(sprite: egret.DisplayObject, c: {rr?: number, gr?: number, br?: number}): void {
        let colorMatrix = [
            c.rr,0,0,0,0,
            0,c.gr,0,0,0,
            0,0,c.br,0,0,
            0,0,0,1,0,
        ];
        let colorFlilter = new egret.ColorMatrixFilter(colorMatrix);
        sprite.filters = [colorFlilter];
    }
}