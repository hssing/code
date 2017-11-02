class ResBase extends UIBase{

    private resComponent: eui.Component;

    protected onEnter() {
        super.onEnter();

        
        LogicMgr.get(logic.Player).on(logic.Player.EVT.REFRESH_RES, this.Event("onRefreshRes"));
        LogicMgr.get(logic.Player).on(logic.Player.EVT.REFRESH_RES_CAPACITY, this.Event("onRefreshResCapacity"));
        LogicMgr.get(logic.Player).refreshRes();
        LogicMgr.get(logic.Player).refreshResCapacity();

        if(this.resComponent["btnAddDiamonds"]) {
            this.resComponent["btnAddDiamonds"].addEventListener(egret.TouchEvent.TOUCH_TAP,this.onBtnAddDiamonds, this);
        }
    }

    private onRefreshRes(data: logic.Res): void {
        if(!this.resComponent) {
            return;
        }
        this.resComponent["lbCereals"].text = utils.amount2KMGTP(data.cereals + data.cereals_base); //粮食
        this.resComponent["lbStone"].text = utils.amount2KMGTP(data.stone + data.stone_base); //石头
        this.resComponent["lbSteel"].text = utils.amount2KMGTP(data.steel + data.steel_base); //钢铁
        this.resComponent["lbSoil"].text = utils.amount2KMGTP(data.soil + data.soil_base); //硅土
        this.resComponent["lbCoin"].text = utils.amount2KMGTP(data.coin);      //金币
        this.resComponent["lbIngot"].text = utils.amount2KMGTP(data.ingot);     //钻石
    }

    private onRefreshResCapacity(capacitys: logic.ResCapacity, res: logic.Res) {
        if(!this.resComponent) {
            return;
        }
        this.resComponent["prgCereals"].value = this.getPrgValue(res.cereals + res.cereals_base, capacitys.cereals);
        this.resComponent["prgStone"].value = this.getPrgValue(res.stone + res.stone_base, capacitys.stone);
        this.resComponent["prgSteel"].value = this.getPrgValue(res.steel + res.steel_base, capacitys.steel);
        this.resComponent["prgSoil"].value = this.getPrgValue(res.soil + res.soil_base, capacitys.soil);
    }

    private getPrgValue(count: number, capacity: number) {
        let result = count / capacity;
        if(result >= 1) {
            return 100;
        }

        return 100 * result;
    }

    private onBtnAddDiamonds(event:egret.TouchEvent):void {
            console.log("onBtnAddDiamonds");
    }
}