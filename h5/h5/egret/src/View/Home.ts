namespace ui {

    export class Home extends UIBase {

        private headChat1: eui.Image;
        private headChat2: eui.Image;
        private chatText1: egret.TextField;
        private chatText2: egret.TextField;
        private chatGroup: eui.Group;

        private static CUSTOM = {
            skinName : "resource/ui/HomeUISkin.exml",
            binding : {
                ["btnTroops"] : { method : "onBtnTroops", },
                ["btnSoilder"] : { method : "onBtnSoilder", },
                ["btnGoods"] : { method : "onBtnGoods", },
                ["btnTask"] : { method : "onBtnTask", },
                ["btnRecruit"]: { method : "onBtnRecruit"} ,
                ["btnShop"]: {method: "onBtnShop"},
                ["btnActivity"]: {method: "onBtnActivity"},
            },
        }

        public constructor() {
            super(Home.CUSTOM);

            this.addEventListener(egret.Event.RENDER, this.render, this);
        }

        protected render() {
            this.removeEventListener(egret.Event.RENDER, this.render, this);
            this.chatText1 = new egret.TextField();
            this.chatText2 = new egret.TextField();
            
            let x = this.headChat1.x;
            let headChat1Y = this.headChat1.y;
            let headChat2Y = this.headChat2.y;
            let width = 25;

            this.chatText1.x = x + width;
            this.chatText1.y = headChat1Y;

            this.chatText2.x = x + width;
            this.chatText2.y = headChat2Y;

            this.chatGroup.addChild(this.chatText1);
            this.chatGroup.addChild(this.chatText2);
            this.createChatText();
        }

        protected onEnter() {
            super.onEnter();
        }

        private onBtnHome(e: egret.TouchEvent) {
            let label = new eui.Label();
            console.log("onBtnHome");
            Prompt.popTip("This is a tip -- " + Math.random());
            //UIMgr.getGuide().createGuide(2);
        }

        private onBtnBag(e: egret.TouchEvent) {
            console.log("onBtnBag");
        }

        private onBtnHero(e: egret.TouchEvent) {
            console.log("onBtnHero");
        }

        private createChatText() {
            this.chatText1.textFlow = <Array<egret.ITextElement>>[
                {text: "(硬汉部队) ", style: {"size": 18, "textColor": 0xa180bc}}, 
                {text: "皇菜菜 ", style: {"size": 18, "textColor": 0xc89170}},
                {text: "：通关之路又进一步", style: {"size": 18, "textColor": 0xbbb6ae}},
            ];

            this.chatText2.textFlow = <Array<egret.ITextElement>>[
                {text: "(硬汉部队) ", style: {"size": 18, "textColor": 0xa180bc}}, 
                {text: "皇菜菜 ", style: {"size": 18, "textColor": 0xc89170}},
                {text: "：通关之路又进一步", style: {"size": 18, "textColor": 0xbbb6ae}},
            ];
        }

        protected onBtnTroops() {
            Prompt.popTip("功能开发中");
            UIMgr.open(CampMain);
        }

        protected onBtnSoilder() {
             Prompt.popTip("功能开发中");
        }

        protected onBtnGoods() {
            Prompt.popTip("功能开发中");
        }

        protected onBtnTask() {
            Prompt.popTip("功能开发中");
        }

        protected onBtnRecruit() {
            Prompt.popTip("功能开发中");
        }

        protected onBtnShop() {
            Prompt.popTip("功能开发中");
        }

        protected onBtnActivity() {
            Prompt.popTip("功能开发中a");
            let armyInfo = LogicMgr.get(logic.Build).getAllArmyInfo();
             for(let i = 0; i < armyInfo.length; i ++) {
                 let build_id = LogicMgr.get(logic.Build).getBuildIdByArmyId(armyInfo[i].army_id);
                 let army_id = armyInfo[i].army_id;
                 let pos = 1;
                 let soldier_type = 1;
                //item.armyName = armyInfo[i].army_id;
                 let data = {build_id:build_id, army_id:army_id, pos:pos, soldier_type:soldier_type};
                 NetMgr.get(msg.Army).send("m_army_set_soldier_tos", data);
             }
        }

    }

}