var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var ui;
(function (ui) {
    var TIMER_BUSY = "NETTIP.BUSY";
    var NetTip = (function (_super) {
        __extends(NetTip, _super);
        function NetTip() {
            return _super.call(this, NetTip.CUSTOM) || this;
        }
        NetTip.prototype.onEnter = function () {
            _super.prototype.onEnter.call(this);
            Singleton(NetCenter).on(NetCenter.EVT.ERROR, this.Event("onError"));
            Singleton(NetCenter).on(NetCenter.EVT.BUSY, this.Event("onBusy"));
            Singleton(NetCenter).on(NetCenter.EVT.CONN, this.Event("onConn"));
            Singleton(NetCenter).on(NetCenter.EVT.CLOSE, this.Event("onDisconn"));
            this.toState("gpIdle");
        };
        NetTip.prototype.playAni = function () {
            this.toState("gpBusy");
            this.playAnimationLoop("busy");
        };
        NetTip.prototype.onBusy = function (result) {
            if (!result) {
                return this.onIdle();
            }
            Singleton(Timer).cancel(this, TIMER_BUSY);
            Singleton(Timer).after(500, this.Event(TIMER_BUSY, this.playAni));
        };
        NetTip.prototype.onIdle = function () {
            this.toState("gpIdle");
            Singleton(Timer).cancel(this, TIMER_BUSY);
            this.stopAnimationLoop("busy");
        };
        NetTip.prototype.onConn = function () {
            this.onIdle();
        };
        NetTip.prototype.onDisconn = function () {
            this.toState("gpDisconn");
            Singleton(Timer).cancel(this, TIMER_BUSY);
            this.stopAnimationLoop("busy");
        };
        NetTip.prototype.onError = function () {
            this.toState("gpRelogin");
            Singleton(Timer).cancel(this, TIMER_BUSY);
            this.stopAnimationLoop("busy");
        };
        NetTip.prototype.onBtnReconn = function () {
            Singleton(NetCenter).connectServer();
            console.log("onBtnReconn");
        };
        NetTip.prototype.onBtnRelogin = function () {
            UIMgr.openOnce(ui.Login);
            this.toState("gpIdle");
        };
        NetTip.prototype.toState = function (s) {
            var _this = this;
            var states = ["gpBusy", "gpDisconn", "gpIdle", "gpRelogin"];
            states.map(function (value) { return _this[value].visible = false; });
            this[s].visible = true;
        };
        return NetTip;
    }(UIBase));
    NetTip.CUSTOM = {
        skinName: "resource/ui/NetTipUISkin.exml",
        binding: (_a = {},
            _a["btnReconn"] = { method: "onBtnReconn", },
            _a["btnRelogin"] = { method: "onBtnRelogin", },
            _a),
    };
    ui.NetTip = NetTip;
    __reflect(NetTip.prototype, "ui.NetTip");
    eui.sys.mixin(NetTip, ui.AnimatImpl);
    var _a;
})(ui || (ui = {}));
//# sourceMappingURL=NetTip.js.map