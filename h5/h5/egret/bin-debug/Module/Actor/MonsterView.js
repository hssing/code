// TypeScript file
var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
/**
 *
 *怪物类
 *
 */
var MonsterView = (function (_super) {
    __extends(MonsterView, _super);
    function MonsterView() {
        var _this = _super.call(this) || this;
        MonsterView.instance = _this;
        return _this;
    }
    MonsterView.getMonster = function () {
        if (!MonsterView.instance) {
            MonsterView.instance = new MonsterView();
        }
        return MonsterView.instance;
    };
    MonsterView.prototype.createChildren = function () {
        // super.createChildren();
        this.autoMove();
    };
    //怪物ai 随意动
    MonsterView.prototype.autoMove = function () {
        var vo = RoleView.getRoleView().vo;
        // this.moveToPos(vo.getX()+200,vo.getY() + 500);
    };
    return MonsterView;
}(PlayerView));
__reflect(MonsterView.prototype, "MonsterView");
//# sourceMappingURL=MonsterView.js.map