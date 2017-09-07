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
 * 方阵
 *
 */
var RoleView = (function (_super) {
    __extends(RoleView, _super);
    function RoleView(root) {
        var _this = _super.call(this, root) || this;
        RoleView.instance = _this;
        _this.touchEnabled = false;
        _this.width = _this.info.w;
        _this.height = _this.info.h;
        _this.anchorOffsetX = _this.width / 2;
        _this.anchorOffsetY = _this.height / 2;
        return _this;
    }
    RoleView.getRoleView = function () {
        if (!RoleView.instance) {
            RoleView.instance = new RoleView();
        }
        return RoleView.instance;
    };
    return RoleView;
}(PlayerView));
__reflect(RoleView.prototype, "RoleView");
//# sourceMappingURL=RoleView.js.map