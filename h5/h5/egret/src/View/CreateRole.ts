namespace ui {
	
	export class CreateRole extends UIBase {

		private btnCreateRole:eui.Button;
		private radioBtnBoy:eui.RadioButton;
		private radiobtnGirl:eui.RadioButton;
		private roleName:eui.EditableText;

		private static CUSTOM = {
            skinName : "resource/ui/CreateRoleUISkin.exml",
            binding : {
                ["btnCreateRole"] : { event : egret.TouchEvent.TOUCH_TAP, method : "onBtnCreateRole", },
            },
        }

		public constructor() {
			super(CreateRole.CUSTOM);
		}

		protected onEnter() {
			super.onEnter();
			LogicMgr.get(logic.Login).on(logic.Login.EVT.ENTER_GAME, this.Event("onEnterGame"));
		}

		protected onEnterGame() {
            this.removeFromParent();
            this.btnCreateRole = null;
            this.radioBtnBoy = null;
            this.radiobtnGirl = null;
			this.roleName = null;
            UIMgr.open(ui.GameLoadingUI, "load");
        }

		protected onBtnCreateRole() {
			if(this.roleName.text.length === 0 || this.roleName.text === "") { 
                alert("账号不能为空");
                return;
            }

			let gender:number;
			if(this.radioBtnBoy.selected) {
				gender = Gender.Boy;
			} else {
				gender = Gender.Girl;
			}

			let i = 1; //Math.round(Math.random() * 4);
	
			let data = {sex:gender, nick:this.roleName.text, camp:i};
			NetMgr.get(msg.Login).send("m_login_create_role_tos", data);
		}
	}
	
	enum Gender {
		Boy = 1,
		Girl
	};
}