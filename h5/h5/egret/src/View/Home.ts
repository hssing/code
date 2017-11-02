namespace ui {

    export class Home extends UIBase {

        private headChat1: eui.Image;
        private headChat2: eui.Image;
        private chatText1: egret.TextField;
        private chatText2: egret.TextField;
        private chatGroup: eui.Group;

        private btnClickArmy1: eui.Group;
        private btnClickArmy2: eui.Group;
        private btnClickArmy3: eui.Group;

        private lbCereals: eui.Label;
        private lbStone: eui.Label;
        private lbSteel: eui.Label;
        private lbSoil: eui.Label;
        private lbCoin: eui.Label;

        private prgCereals: eui.ProgressBar;
        private prgStone: eui.ProgressBar;
        private prgSteel: eui.ProgressBar;
        private prgSoil: eui.ProgressBar;

        private lbLevel: eui.Label;

        private static CUSTOM = {
            skinName : "resource/ui/HomeUISkin.exml",
            resGroup : ["home"],
            binding : {
                ["btnTroops"] : { method : "onBtnTroops", },
                ["btnSoilder"] : { method : "onBtnSoilder", },
                ["btnGoods"] : { method : "onBtnGoods", },
                ["btnTask"] : { method : "onBtnTask", },
                ["btnRecruit"]: { method : "onBtnRecruit", } ,
                ["btnShop"]: { method: "onBtnShop", },
                ["btnActivity"]: { method: "onBtnActivity", },
                ["btnMap"]: { method: "onBtnMap", },
                ["btnClickArmy1"]: {method: "onBtnClickArmy1", },
                ["btnClickArmy2"]: {method: "onBtnClickArmy2", },
                ["btnClickArmy3"]: {method: "onBtnClickArmy3", },
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

            LogicMgr.get(logic.Player).on(logic.Player.EVT.REFRESH_RES, this.Event("onRefreshRes"));
            LogicMgr.get(logic.Player).on(logic.Player.EVT.REFRESH_RES_CAPACITY, this.Event("onRefreshResCapacity"));
            LogicMgr.get(logic.Player).refreshRes();
            LogicMgr.get(logic.Player).refreshResCapacity();

            LogicMgr.get(logic.Home).on(logic.Home.EVT.REFRESH_ARMY_INFO, this.Event("onRefreshArmyInfo"));
            Singleton(Timer).repeat(2000, this.Event("UPDATE_ARMY_INFO", ()=>{
                LogicMgr.get(logic.Home).udpateArmyInfo();
            }));
            LogicMgr.get(logic.Home).udpateArmyInfo();

            this.btnClickArmy1.visible = false;
            this.btnClickArmy2.visible = false;
            this.btnClickArmy3.visible = false;

            this.lbLevel.text = `Lv${(LogicMgr.get(logic.Player).getRoleLevel())}`;
        }

        private onRefreshRes(data: logic.Res): void {
            this.lbCereals.text = utils.amount2KMGTP(data.cereals + data.cereals_base);
            this.lbStone.text = utils.amount2KMGTP(data.stone + data.stone_base);
            this.lbSoil.text = utils.amount2KMGTP(data.soil + data.soil_base);
            this.lbSteel.text = utils.amount2KMGTP(data.steel + data.steel_base);
            this.lbCoin.text = utils.amount2KMGTP(data.coin);
        }

        private onRefreshResCapacity(capacitys: logic.ResCapacity, res: logic.Res) {
            this.prgCereals.value = this.getPrgValue(res.cereals + res.cereals_base, capacitys.cereals);
            this.prgStone.value = this.getPrgValue(res.stone + res.stone_base, capacitys.stone);
            this.prgSteel.value = this.getPrgValue(res.steel + res.steel_base, capacitys.steel);
            this.prgSoil.value = this.getPrgValue(res.soil + res.soil_base, capacitys.soil);
        }

        private getPrgValue(count: number, capacity: number) {
            let result = count / capacity;
            if(result >= 1) {
                return 100;
            }

            return 100 * result;
        }

        private onRefreshArmyInfo(data): void {
            this.btnClickArmy1.visible = !!data[0];
            this.btnClickArmy2.visible = !!data[1];
            this.btnClickArmy3.visible = !!data[2];
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
            // UIMgr.open(CampMain);
            Prompt.popTip("功能开发中");
        }

        protected onBtnSoilder() {
            UIMgr.open(SoldierList);
        }

        protected onBtnGoods() {
            // Prompt.popTip("功能开发中");
            UIMgr.open(ui.BagMain);
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
            UIMgr.open(ui.BuildQueue);
        }

        protected onBtnMap() {
            UIMgr.open(ui.Location);
        }

        protected onBtnClickArmy1() {
            let data = LogicMgr.get(logic.Home).getArmyInfos();
            LogicMgr.get(logic.World).gotoLocation({x : data[0].x, y : data[0].y,});
        }

        protected onBtnClickArmy2() {
            let data = LogicMgr.get(logic.Home).getArmyInfos();
            LogicMgr.get(logic.World).gotoLocation({x : data[1].x, y : data[1].y,});
        }

        protected onBtnClickArmy3() {
            let data = LogicMgr.get(logic.Home).getArmyInfos();
            LogicMgr.get(logic.World).gotoLocation({x : data[2].x, y : data[2].y,});
        }

    }

}