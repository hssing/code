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
    var CreateRole = (function (_super) {
        __extends(CreateRole, _super);
        function CreateRole() {
            return _super.call(this, CreateRole.CUSTOM) || this;
        }
        CreateRole.prototype.onEnter = function () {
            _super.prototype.onEnter.call(this);
            LogicMgr.get(logic.Login).on(logic.Login.EVT.ENTER_GAME, this.Event("onEnterGame"));
        };
        CreateRole.prototype.onEnterGame = function () {
            this.removeFromParent();
            this.btnCreateRole = null;
            this.radioBtnBoy = null;
            this.radiobtnGirl = null;
            this.roleName = null;
            UIMgr.open(ui.GameLoadingUI, "load");
        };
        CreateRole.prototype.onBtnCreateRole = function () {
            if (this.roleName.text.length === 0 || this.roleName.text === "") {
                alert("账号不能为空");
                return;
            }
            var gender;
            if (this.radioBtnBoy.selected) {
                gender = Gender.Boy;
            }
            else {
                gender = Gender.Girl;
            }
            var i = 1; //Math.round(Math.random() * 4);
            var data = { sex: gender, nick: this.roleName.text, camp: i };
            NetMgr.get(msg.Login).send("m_login_create_role_tos", data);
        };
        return CreateRole;
    }(UIBase));
    CreateRole.CUSTOM = {
        skinName: "resource/ui/CreateRoleUISkin.exml",
        binding: (_a = {},
            _a["btnCreateRole"] = { event: egret.TouchEvent.TOUCH_TAP, method: "onBtnCreateRole", },
            _a),
    };
    ui.CreateRole = CreateRole;
    __reflect(CreateRole.prototype, "ui.CreateRole");
    var Gender;
    (function (Gender) {
        Gender[Gender["Boy"] = 1] = "Boy";
        Gender[Gender["Girl"] = 2] = "Girl";
    })(Gender || (Gender = {}));
    ;
    var _a;
})(ui || (ui = {}));
//# sourceMappingURL=CreateRole.js.map