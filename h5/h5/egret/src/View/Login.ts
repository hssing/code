namespace ui {

    export class Login extends UIBase {

        private account: eui.EditableText;
        private serverName: eui.Label;
        private group: eui.Group;
        private btnServer: eui.Button;
        
        

        private static CUSTOM = {
            skinName : "resource/ui/LoginUISkin.exml",
            binding : {
                ["btnLogin"] : { event : egret.TouchEvent.TOUCH_TAP, method : "onBtnLogin", },
                ["btnServer"] : { event : egret.TouchEvent.TOUCH_TAP, method : "onBtnServer", },
            },
        }

        public constructor() {
            super(Login.CUSTOM);
        }


        protected onEnter() {
            super.onEnter();
            LogicMgr.get(logic.Login).on(logic.Login.EVT.REGISTER_ROLE, this.Event("onRegisterRole"));
            LogicMgr.get(logic.Login).on(logic.Login.EVT.ENTER_GAME, this.Event("onEnterGame"));
            LogicMgr.get(logic.Login).on(logic.Login.EVT.REFESH_SERVERINFO, this.Event("refeshServerInfo"));
            this.refeshServerInfo()
        }

        private refeshServerInfo() {
            let serverInfo = LogicMgr.get(logic.Login).getCurServerInfo();
            if(serverInfo) {
                this.serverName.text = serverInfo.name;
            }
        }

        protected onEnterGame() {
            this.removeFromParent();
            this.account = null;
            this.group = null;
            UIMgr.open(ui.GameLoadingUI);
        }


        protected onRegisterRole() {
            this.removeFromParent();
            this.account = null;
            this.group = null;
            UIMgr.open(ui.CreateRole);
        }

        private onBtnLogin(e?: egret.TouchEvent) {
            if(this.account.text.length == 0 || this.account.text == "") {
                alert("账号不能为空");
                return;
            }

            this.doLogin();
        }

        private  doLogin() {
            let serverInfo = LogicMgr.get(logic.Login).getCurServerInfo();
            console.log("serverInfo ip = " + serverInfo.ip);
            console.log("serverInfo port = " + serverInfo.port);
            Singleton(NetCenter).connectServer(serverInfo.ip, serverInfo.port);

            let data = {aid : this.account.text};
            let playerInfo:logic.Player = <logic.Player>LogicMgr.get(logic.Player)
            playerInfo.setUid(this.account.text);
            NetMgr.get(msg.Login).send("m_login_auth_tos", data);
        }

        protected onBtnServer() {
            UIMgr.open(ServerList);
        }

    }
    
}