var Prompt;
(function (Prompt) {
    function popTip(str) {
        var tipName = "tipsEffect";
        var effect = UIMgr.getLayer("effect");
        var tip = new egret.TextField();
        try {
            tip.textFlow = new egret.HtmlTextParser().parser(str);
        }
        catch (error) {
            tip.text = str;
        }
        var tips = effect.getChildByName(tipName);
        if (!effect.getChildByName(tipName)) {
            tips = new egret.DisplayObjectContainer();
            effect.addChild(tips);
            tips.name = tipName;
        }
        var _loop_1 = function (i) {
            var t = tips.getChildAt(i);
            egret.Tween.get(t, { onChange: function () { return t.y -= 1; } }).wait(300);
        };
        for (var i = 0; i < tips.numChildren; i++) {
            _loop_1(i);
        }
        tip.anchorOffsetX = tip.width / 2;
        tip.anchorOffsetY = tip.height / 2;
        tip.x = effect.width / 2;
        tip.y = effect.height / 2;
        tips.addChild(tip);
        egret.Tween.get(tip)
            .to({ scaleX: 1.2, scaleY: 1.2 }, 200)
            .to({ scaleX: 1, scaleY: 1 }, 100)
            .call(function () {
            egret.Tween.get(tip, { onChange: function () { return tip.y -= 1; } })
                .to({ alpha: 0 }, 1500);
        })
            .wait(1500)
            .call(function () {
            tips.removeChild(tip);
        });
    }
    Prompt.popTip = popTip;
})(Prompt || (Prompt = {}));
//# sourceMappingURL=Prompt.js.map