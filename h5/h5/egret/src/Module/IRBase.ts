class IRBase extends UIBase implements eui.IItemRenderer {

    protected addSizeListener() {
        // do nothhing
    }

    protected enableTouch() {
        // eui.ItemRenderer
        this.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this["onTouchBegin"], this);
    }

    // eui.IItemRenderer
    data: any;
    selected: boolean;
    itemIndex: number;
}

eui.sys.mixin(IRBase, eui.ItemRenderer);