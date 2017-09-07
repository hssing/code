namespace UIMgr {

    let root: eui.UILayer;
    let layers: any;

    export function setup(root: any): void {
        _init(root);
    }

    export function getHome(): any {
        let layer = getLayer("home") as eui.UILayer;
        return layer.getChildAt(0);
    }

    export function getWorld(): ui.World {
        let layer = getLayer("scene") as eui.UILayer;
        return layer.getChildAt(0) as ui.World;
    }

    export function getGuide(): ui.Guide {
        let layer = getLayer("guide") as eui.UILayer;
        return layer.getChildAt(0) as ui.Guide;
    }

    export function getLayer(name: string): eui.UILayer {
        return layers[name];
    }

    export function open(viewCls: any, layerName: string = "panel", ...data): any {
        let layer = getLayer(layerName);
        let view = new viewCls(...data);
        layer.addChild(view);
        return view;
    }

    export function openOnce(viewCls: any, layerName: string = "panel", ...data): any {
        let layer = getLayer(layerName) as eui.UILayer;
        for(let i = 0; i < layer.numChildren; i++) {
            let child = layer.getChildAt(i);
            if (child instanceof viewCls) {
                return;
            }
        }

        open(viewCls, layerName, ...data);
    }

    export function close(view: any): void {
        if (view.parent) {
            view.removeFromParent();
        }
    }

    export function closeAll(viewCls: any, layerName: string = "panel"): any {
        let layer = getLayer(layerName) as eui.UILayer;
        let removed = [];
        for(let i = 0; i < layer.numChildren; i++) {    
            let child = layer.getChildAt(i);
            if (child instanceof viewCls) {
                removed.push(child);
            }
        }
        for (let child of removed) {
            child.removeFromParent();
        }  
    }

    export function fireUIEvent(name: string, data?: any) {
        let views = [];
        for (let k in layers) {
            let l = layers[k] as eui.UILayer;
            for (let i = l.numChildren-1; i >= 0; i--) {
                let view = l.getChildAt(i);
                views.push(view);
            }
        }
        views.forEach(view => {
            let event = new egret.Event(name, false, true, data);
            view.dispatchEvent(event);
        })
    }

    function _init(r: any) {
        layers = 
        {
            scene : new eui.UILayer(),  // 场景层 如 战场、主城、副本战场之类的
            home : new eui.UILayer(),   // 主UI层 如 底部功能栏
            panel : new eui.UILayer(),  // 弹窗层 如 设置、背包、装备之类的
            effect : new eui.UILayer(), // 特效层 如 闪烁、飘字之类的
            guide : new eui.UILayer(),  // 新手引导层
            mask : new eui.UILayer(),   // 通讯遮罩层 和服务器通讯UI
            load : new eui.UILayer(),   // 加载遮罩层 场景切换的时候加载资源UI
        }

        root = r;
        for (let key in layers) {
            let layer = layers[key];
            layer.touchThrough = true;
            root.addChild(layer);
            [layer.width, layer.height] = [root.width, root.height];
        }
        root.touchThrough = true;
    }
}