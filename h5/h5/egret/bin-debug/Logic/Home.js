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
    var Home = (function (_super) {
        __extends(Home, _super);
        function Home() {
            var _this = _super.call(this) || this;
            LogicMgr.get(logic.Login).on(logic.Login.EVT.START, _this.Event("onLogic"));
            return _this;
        }
        Home.prototype.onLogic = function (param1, param2) {
            console.log("onLogic Home", param1, param2);
        };
        return Home;
    }(Logic));
    logic.Home = Home;
    __reflect(Home.prototype, "logic.Home");
})(logic || (logic = {}));
//# sourceMappingURL=Home.js.map