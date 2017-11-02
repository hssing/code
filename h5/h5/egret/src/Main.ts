//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2014-present, Egret Technology.
//  All rights reserved.
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the Egret nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY EGRET AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
//  OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL EGRET AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
//  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;LOSS OF USE, DATA,
//  OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
//  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//////////////////////////////////////////////////////////////////////////////////////

class Main extends eui.UILayer {
    /**
     * 加载进度界面
     * loading process interface
     */

    protected createChildren(): void {
        super.createChildren();

        // RES.processor.map("proto", ProtoAnalyzer);
        //注入自定义的素材解析器
        let assetAdapter = new AssetAdapter();
        egret.registerImplementation("eui.IAssetAdapter",assetAdapter);
        egret.registerImplementation("eui.IThemeAdapter",new ThemeAdapter());

        RES.registerAnalyzer("jzip", RES.JszipAnalyzer);

        this.loadRes();
        NetMgr.init();
    }

    private loadTheme() {
        var theme = new eui.Theme("resource/default.thm.json", this.stage);
        return new Promise((resolve, reject)=> {
            theme.addEventListener(eui.UIEvent.COMPLETE, resolve, this);
        });
    }

    private async loadRes() {
        await ResExt.loadConfig("resource/default.res.json");
        await this.loadTheme();
        await ResExt.loadGroup("loading");

        this.startGame();
    }

    private gameUpdate() {
        Singleton(Timer).process();
    }

    private startGame() {
        if (!DEBUG) { console.log = ()=>{}; };
        
        this.addEventListener(egret.Event.ENTER_FRAME,this.gameUpdate, this);

        UIMgr.setup(this);
        UIMgr.open(ui.ResLoadingUI, "load");
        UIMgr.open(ui.NetTip, "mask");
        UIMgr.open(ui.LoginLoadingUI);
        // UIMgr.open(ui.GameLoadingUI);
    }
}
