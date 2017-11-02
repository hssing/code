namespace ui {

    export class Location extends UIBase {

        private static CUSTOM = {
            closeBg : { alpha : 0, },
            skinName : "resource/ui/LocationUISkin.exml",
            binding : {
                ["btnOK"] : { method : "onBtnOK", },
            },
        }

        public constructor() {
            super(Location.CUSTOM);
        }

        protected onEnter() {
            super.onEnter();
            let cpos = LogicMgr.get(logic.City).getMainCityPos();
            this.lbX.text = cpos.x;
            this.lbY.text = cpos.y;
        }

        protected onBtnOK() {
            let x = parseInt(this.lbX.text);
            let y = parseInt(this.lbY.text);
            if (typeof(x) === "number" &&  typeof(y) === "number") {
                LogicMgr.get(logic.World).gotoLocation({x, y});
            }else {
                Prompt.popTip("无效的坐标！");
            }
            this.removeFromParent();
        }

        private lbX: eui.Label;
        private lbY: eui.Label;
    }

}