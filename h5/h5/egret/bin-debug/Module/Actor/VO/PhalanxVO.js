var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
/**
 *
 * 方阵数据类
 *
 */
var PhalanxVO = (function () {
    function PhalanxVO() {
        this.modelId = 1001; //
        this.curHp = 1000; //当前血量
        this.maxHp = 1000; //最大血量
        this.unitCount = 4; //一个玩家 动画单位数量
    }
    PhalanxVO.prototype.setId = function (id) {
        this.id = id;
    };
    PhalanxVO.prototype.getId = function () {
        return this.id;
    };
    PhalanxVO.prototype.setModelId = function (modelId) {
        this.modelId = modelId;
    };
    PhalanxVO.prototype.getModelId = function () {
        return this.modelId;
    };
    PhalanxVO.prototype.setName = function (name) {
        this.name = name;
    };
    PhalanxVO.prototype.getName = function () {
        return this.name;
    };
    PhalanxVO.prototype.setX = function (x) {
        this.x = x;
    };
    PhalanxVO.prototype.getX = function () {
        return this.x;
    };
    PhalanxVO.prototype.setY = function (y) {
        this.y = y;
    };
    PhalanxVO.prototype.getY = function () {
        return this.y;
    };
    PhalanxVO.prototype.setXY = function (x, y) {
        this.x = x;
        this.y = y;
    };
    PhalanxVO.prototype.getXY = function () {
        return [this.x, this.y];
    };
    PhalanxVO.prototype.setMoveSpeed = function (moveSpeed) {
        this.moveSpeed = moveSpeed;
    };
    PhalanxVO.prototype.getMoveSpeed = function () {
        return this.moveSpeed;
    };
    PhalanxVO.prototype.setCurHp = function (curHp) {
        this.curHp = curHp < 0 ? 0 : curHp;
    };
    PhalanxVO.prototype.getCurHp = function () {
        return this.curHp;
    };
    PhalanxVO.prototype.setMaxHp = function (maxHp) {
    };
    PhalanxVO.prototype.getMaxHp = function () {
        return this.maxHp;
    };
    PhalanxVO.prototype.getPecentHp = function () {
        return this.curHp / this.maxHp;
    };
    PhalanxVO.prototype.setUnitCount = function (unitCount) {
        this.unitCount = unitCount;
    };
    PhalanxVO.prototype.getUnitCount = function () {
        return this.unitCount;
    };
    return PhalanxVO;
}());
__reflect(PhalanxVO.prototype, "PhalanxVO");
//# sourceMappingURL=PhalanxVO.js.map