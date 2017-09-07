var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var logic;
(function (logic) {
    var Player = (function (_super) {
        __extends(Player, _super);
        function Player() {
            return _super.call(this) || this;
        }
        Player.prototype.setUid = function (uid) {
            this.uid = uid;
        };
        Player.prototype.getUid = function () {
            return this.uid;
        };
        Player.prototype.setRoleId = function (roleId) {
            this.roleId = roleId;
        };
        Player.prototype.getRoleId = function () {
            return this.roleId;
        };
        Player.prototype.setRoleName = function (roleName) {
            this.roleName = roleName;
        };
        Player.prototype.getRoleName = function () {
            return this.roleName;
        };
        Player.prototype.setRoleLevel = function (roleLevel) {
            this.roleLevel = roleLevel;
        };
        Player.prototype.getRoleLevel = function () {
            return this.roleLevel;
        };
        Player.prototype.setRoleExp = function (roleExp) {
            this.roleExp = roleExp;
        };
        Player.prototype.getRoleExp = function () {
            return this.roleExp;
        };
        Player.prototype.setNextLevelExp = function (nextLevelExp) {
            this.nextLevelExp = nextLevelExp;
        };
        Player.prototype.getNextLevelExp = function () {
            return this.nextLevelExp;
        };
        Player.prototype.setSvrId = function (svrId) {
            this.svrId = svrId;
        };
        Player.prototype.getSvrId = function () {
            return this.svrId;
        };
        Player.prototype.setSvrName = function (svrName) {
            this.svrName = svrName;
        };
        Player.prototype.getSvrName = function () {
            return this.svrName;
        };
        Player.prototype.setCoin = function (coin) {
            this.coin = coin;
        };
        Player.prototype.getCoin = function () {
            return this.coin;
        };
        Player.prototype.setIngot = function (ingot) {
            this.ingot = ingot;
        };
        Player.prototype.getIngot = function () {
            return this.ingot;
        };
        Player.prototype.setVipLevel = function (vipLevel) {
            this.vipLevel = vipLevel;
        };
        Player.prototype.getVipLevel = function () {
            return this.vipLevel;
        };
        Player.prototype.setCamp = function (camp) {
            this.camp = camp;
        };
        Player.prototype.getCamp = function () {
            return this.camp;
        };
        return Player;
    }(Logic));
    logic.Player = Player;
    __reflect(Player.prototype, "logic.Player");
})(logic || (logic = {}));
//# sourceMappingURL=Player.js.map