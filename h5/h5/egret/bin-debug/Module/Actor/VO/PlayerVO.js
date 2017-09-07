// TypeScript file
var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
/**WWW
 *
 * 角色数据基类
 *
 */
var PlayerVO = (function () {
    function PlayerVO() {
        this.modelId = 1002; // 
        this.cellX = 0; //格子坐标
        this.cellY = 0;
        this.curHp = 5000; //当前血量
        this.maxHp = 5000; //最大血量
        this.unitCount = 4; //一个玩家 动画单位数量
    }
    PlayerVO.prototype.setId = function (id) {
        this.id = id;
    };
    PlayerVO.prototype.getId = function () {
        return this.id;
    };
    PlayerVO.prototype.setModelId = function (modelId) {
        this.modelId = modelId;
    };
    PlayerVO.prototype.getModelId = function () {
        return this.modelId;
    };
    PlayerVO.prototype.setName = function (name) {
        this.name = name;
    };
    PlayerVO.prototype.getName = function () {
        return this.name;
    };
    PlayerVO.prototype.setX = function (x) {
        this.x = x;
    };
    PlayerVO.prototype.getX = function () {
        return this.x;
    };
    PlayerVO.prototype.setY = function (y) {
        this.y = y;
    };
    PlayerVO.prototype.getY = function () {
        return this.y;
    };
    PlayerVO.prototype.setXY = function (x, y) {
        this.x = x;
        this.y = y;
    };
    PlayerVO.prototype.getXY = function () {
        return [this.x, this.y];
    };
    PlayerVO.prototype.setCellX = function (cellX) {
        this.cellX = cellX;
    };
    PlayerVO.prototype.getCellX = function () {
        return this.cellX;
    };
    PlayerVO.prototype.setCellY = function (cellY) {
        this.cellY = cellY;
    };
    PlayerVO.prototype.getCellY = function () {
        return this.cellY;
    };
    PlayerVO.prototype.setCellXY = function (cellX, cellY) {
        this.cellX = cellX;
        this.cellY = cellY;
    };
    PlayerVO.prototype.getCellXY = function () {
        return [this.cellX, this.cellY];
    };
    PlayerVO.prototype.setMoveSpeed = function (moveSpeed) {
        this.moveSpeed = moveSpeed;
    };
    PlayerVO.prototype.getMoveSpeed = function () {
        return this.moveSpeed;
    };
    PlayerVO.prototype.setCurHp = function (curHp) {
        this.curHp = curHp < 0 ? 0 : curHp;
    };
    PlayerVO.prototype.getCurHp = function () {
        return this.curHp;
    };
    PlayerVO.prototype.setMaxHp = function (maxHp) {
    };
    PlayerVO.prototype.getMaxHp = function () {
        return this.maxHp;
    };
    PlayerVO.prototype.getPecentHp = function () {
        return this.curHp / this.maxHp;
    };
    PlayerVO.prototype.setUnitCount = function (unitCount) {
        this.unitCount = unitCount;
    };
    PlayerVO.prototype.getUnitCount = function () {
        return this.unitCount;
    };
    return PlayerVO;
}());
__reflect(PlayerVO.prototype, "PlayerVO");
//# sourceMappingURL=PlayerVO.js.map