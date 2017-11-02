namespace ui {

    export class PlayerDetial extends UIBase {

        private static CUSTOM = {
            closeBg : {alpha: 0.5, disable: false},
            resGroup: ["playerdetail"],
            skinName : "resource/ui/PlayerDetailUISkin.exml",
            binding : {
                ["btnAlliance"] : { method : "onBtnAddAlliance", },
                ["btnBlacklist"] : { method : "onBtnAddBlackList", },
                ["btnFriend"] : { method : "onBtnAddFriend", },
                ["btnChat"] : { method : "onBtnChat", },
                ["btnClose"] : { method : "onClose", },
            },
        }

        protected playerName: eui.Label;
        protected playerLevel: eui.Label;
        protected allianceName: eui.Label;

        private data: any;

        public constructor(data) {
            super(PlayerDetial.CUSTOM);
            this.data = data;
        }

        protected onEnter(): void {
            super.onEnter();

            this.playerName.text = `${this.data.nick}`;
            this.playerLevel.text = `LV${this.data.lv}`;
            this.allianceName.text = String(this.data.camp);
        }

        private onBtnAddAlliance(): void {
            Prompt.popTip("功能开发中");
        }

        private onBtnAddBlackList(): void {
            Prompt.popTip("功能开发中");
        }

        private onBtnAddFriend(): void {
            Prompt.popTip("功能开发中");
        }

        private onBtnChat(): void {
            Prompt.popTip("功能开发中");
        }

    }

}