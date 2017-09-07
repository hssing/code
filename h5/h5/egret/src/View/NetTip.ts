namespace ui {

    const TIMER_BUSY = "NETTIP.BUSY";

    export class NetTip extends UIBase {

        private static CUSTOM = {
            skinName : "resource/ui/NetTipUISkin.exml",
            binding : {
                ["btnReconn"] : { method : "onBtnReconn", },
                ["btnRelogin"] : { method : "onBtnRelogin", },
            },
        }

        public constructor() {
            super(NetTip.CUSTOM);
        }

        protected onEnter() {
            super.onEnter();

            Singleton(NetCenter).on(NetCenter.EVT.ERROR, this.Event("onError"));
            Singleton(NetCenter).on(NetCenter.EVT.BUSY, this.Event("onBusy"));
            Singleton(NetCenter).on(NetCenter.EVT.CONN, this.Event("onConn"));
            Singleton(NetCenter).on(NetCenter.EVT.CLOSE, this.Event("onDisconn"));
            this.toState("gpIdle");
        }

        private playAni() {
            this.toState("gpBusy");
            this.playAnimationLoop("busy");
        }

        private onBusy(result: boolean) {
            if (!result) {
                return this.onIdle();
            }

            Singleton(Timer).cancel(this, TIMER_BUSY);
            Singleton(Timer).after(500, this.Event(TIMER_BUSY, this.playAni));
        }

        private onIdle() {
            this.toState("gpIdle");
            Singleton(Timer).cancel(this, TIMER_BUSY);
            this.stopAnimationLoop("busy");
        }

        private onConn() {
            this.onIdle();
        }

        private onDisconn() {
            this.toState("gpDisconn");
            Singleton(Timer).cancel(this, TIMER_BUSY);
            this.stopAnimationLoop("busy");
        }

        private onError() {
            this.toState("gpRelogin");
            Singleton(Timer).cancel(this, TIMER_BUSY);
            this.stopAnimationLoop("busy");
        }

        private onBtnReconn() {
            Singleton(NetCenter).connectServer();
            console.log("onBtnReconn");
        }

        private onBtnRelogin() {
            UIMgr.openOnce(ui.Login);
            this.toState("gpIdle");
        }

        private toState(s) {
            let states = ["gpBusy", "gpDisconn", "gpIdle", "gpRelogin"];
            states.map(value => this[value].visible = false);
            this[s].visible = true;
        }

        private gpBusy: eui.Group;
        private gpDisconn: eui.Group;
        private gpIdle: eui.Group;
        private gpRelogin: eui.Group;

        playAnimation: (name: string, frame?: number)=>void;
        playAnimationLoop: (name: string, frame?: number)=>void;
        stopAnimationLoop: (name: string)=>void;
    }

    eui.sys.mixin(NetTip, ui.AnimatImpl);
}