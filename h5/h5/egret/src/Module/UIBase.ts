class UIBase extends eui.Component {

    private custom: any;

    public constructor(custom) {
        super();
        
        this.custom = custom;
        this.includeInLayout = true;
        this.touchEnabled = false;
        this.addEventListener(eui.UIEvent.COMPLETE, this.createCompleteEvent, this);
        this.skinName = custom.skinName;
    }

    private createCompleteEvent(event: eui.UIEvent): void {
        this.removeEventListener(eui.UIEvent.COMPLETE , this.createCompleteEvent, this);
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onEnter, this);
        this.addEventListener(egret.Event.REMOVED_FROM_STAGE, this.onExit, this);
        this.bindControl();
    }

    public removeFromParent(): void {
        this.parent.removeChild(this);
    }

    public onClose(): void {
        this.removeFromParent();
    }

    protected onEnter(): void {
        this.initTracer();
        this.addSizeListener();
        this.buildCloseBg()
    }

    protected addSizeListener() {
        this.parent.addEventListener(egret.Event.RESIZE, this.onReSize, this);
        [this.width, this.height] = [this.parent.width, this.parent.height];
    }

    protected onExit(): void {
        this.parent.removeEventListener(egret.Event.RESIZE, this.onReSize, this);
        this.disposeTracer();
    }

    public onReSize(): void {
        [this.width, this.height] = [this.parent.width, this.parent.height];
    }

    public fireUIEvent(name: string, data?: any): void {
        UIMgr.fireUIEvent(name, data);
    }

    public bindUIEvent(name: string, method): void {
        this.addEventListener(name, method, this);
    }

    protected bindControl(): void {
        for (let name in (this.custom.binding || {})) {
            let proto = this.custom.binding[name];
            if (!this[proto.method]) {
                console.log(`### Not Found Method: ${proto.method} -- SkinName: ${this.custom.skinName}`)
                continue;
            }

            let nameArray = name.split(".");
            let controller = this;
            for (let v of nameArray) {
                if (!controller) break;
                controller = controller[v];
            }

            if (!controller) {
                console.log(`### Not Found Binding: ${name} -- SkinName: ${this.custom.skinName}`)
                continue;
            }

            let event = proto.event || egret.TouchEvent.TOUCH_TAP;
            controller.addEventListener(event, this[proto.method], this);
        }
    }

    private buildCloseBg() {
        if (!this.custom.closeBg) { return; }

        let bgGp = new eui.Group();
        bgGp.top = bgGp.bottom = bgGp.left = bgGp.right = 0;
        this.addChildAt(bgGp, 0);
        if (!this.custom.closeBg.disable) {
            bgGp.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onClose, this);
        }

        if (this.custom.closeBg.alpha === 0) { return; }

        let rect = new eui.Rect(bgGp.width, bgGp.height);
        rect.top = rect.bottom = rect.left = rect.right = 0;
        rect.alpha = this.custom.closeBg.alpha || 0.5;
        bgGp.addChild(rect);
    }

    // events.Tracer
    eventTracer: events.EventTracer ;
    initTracer: () => void;
    disposeTracer: () => void;
    Event: (name: string, callback?: any) => events.Event;
    EventTracer: () => events.EventTracer;
}

eui.sys.mixin(UIBase, events.Tracer);