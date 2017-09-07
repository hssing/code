namespace Prompt {

    export function popTip(str: string) {
        let tipName = "tipsEffect";
        let effect = UIMgr.getLayer("effect");

        let tip = new egret.TextField();
        try {
            tip.textFlow = new egret.HtmlTextParser().parser(str);
        } catch (error) {
            tip.text = str;
        }

        let tips = effect.getChildByName(tipName) as egret.DisplayObjectContainer;
        if (!effect.getChildByName(tipName)) {
            tips = new egret.DisplayObjectContainer();
            effect.addChild(tips);
            tips.name = tipName;
        }

        for (let i = 0; i < tips.numChildren; i++) {
            let t = tips.getChildAt(i);
            egret.Tween.get(t, {onChange : ()=>t.y -= 1}).wait(300);
        }
        
        tip.anchorOffsetX = tip.width / 2;
        tip.anchorOffsetY = tip.height / 2;

        tip.x = effect.width / 2;
        tip.y = effect.height / 2;

        tips.addChild(tip);
        egret.Tween.get(tip)
            .to({scaleX : 1.2, scaleY : 1.2}, 200)
            .to({scaleX : 1, scaleY : 1}, 100)
            .call(() => {
                egret.Tween.get(tip, {onChange : ()=>tip.y -= 1})
                .to({alpha : 0}, 1500);
            })
            .wait(1500)
            .call(() => {
                tips.removeChild(tip);
            });
    }
}