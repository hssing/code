namespace ui {

    export class Guide extends eui.Group {

        private guideGroup: eui.Group;


        public constructor() {
			super();
            this.percentWidth = 100;
			this.percentHeight = 100;
            this.$setTouchEnabled(false);
        }
        
		public createGuide(id: number) {
			let data = RES.getRes("GuideMotherConfig_json");			
			let isBottom = data[id].isBottom;
			let layer = data[id].layer;
			let ui = null;
			if(layer === "Home") {
				ui = UIMgr.getHome();
			}else if(layer === "World") {
				ui = UIMgr.getWorld();
			}else {
				let pannel = UIMgr.getLayer("panel");
				ui = pannel.getChildAt(pannel.numChildren - 1);
			}

			let btn: eui.Button = ui[data[id].btn];
			this.createGuidePanel(btn, isBottom);
		}

        public createGuidePanel(btn: eui.Button, isBottom: boolean) {

            let point: egret.Point = btn.localToGlobal(0, 0);
            let x = point.x;
            let y = point.y;
            let width = btn.width;
            let height = btn.height;

            this.guideGroup = new eui.Group();
            this.guideGroup.percentWidth = 100;
            this.guideGroup.percentHeight = 100;
            this.guideGroup.$setX(0);
            this.guideGroup.$setY(0);
            this.guideGroup.$setTouchEnabled(false);
            this.addChild(this.guideGroup);

            this.createMask(x, y, width, height, isBottom);

            let fingerGroup: eui.Group = new eui.Group();
            fingerGroup.percentWidth = 100;
            fingerGroup.height = 200;
            this.guideGroup.addChild(fingerGroup);
            if(isBottom) {
                fingerGroup.bottom = 0;
                fingerGroup.anchorOffsetY = 200;
                fingerGroup.$setY(this.stage.$stageHeight);
            } else {
                fingerGroup.anchorOffsetY = 0;
                fingerGroup.$setY(0);
            }
            fingerGroup.$setX(0);
            fingerGroup.$setTouchEnabled(false);

            let localPoint = fingerGroup.globalToLocal(x + width / 2, y + height / 2)
            let finger: eui.Image = new eui.Image("finger1_png");
            finger.$setX(localPoint.x + 10 * Math.cos(Math.PI / 4));
            finger.$setY(localPoint.y + 10 * Math.sin(Math.PI / 4));
            let tw = egret.Tween.get(finger, { loop:true } );
            tw.to( {x:localPoint.x, y:localPoint.y}, 500)
            .to({x:localPoint.x + 10 * Math.cos(Math.PI / 4), y:localPoint.y + 10 * Math.sin(Math.PI / 4)}, 500);
            fingerGroup.addChild(finger);

            let shape: eui.Rect = new eui.Rect(width, height, 0x020202);
            let shapeLocalPoint = fingerGroup.globalToLocal(x , y)
            fingerGroup.addChild(shape);
            shape.fillAlpha = 0;
            shape.$setX(shapeLocalPoint.x);
            shape.$setY(shapeLocalPoint.y);
            shape.addEventListener(egret.TouchEvent.TOUCH_BEGIN, (e: egret.TouchEvent) =>{
                btn.dispatchEvent(e);
            }, this);
            shape.addEventListener(egret.TouchEvent.TOUCH_TAP, (e: egret.TouchEvent) => {
				btn.dispatchEvent(e);
				this.addEventListener(egret.Event.RENDER, this.render, this);
				
            }, this);
        } 

		protected render(){
			this.removeEventListener(egret.Event.RENDER, this.render, this);
			this.finishedGuide();
		}

        private createMask(x: number, y: number, width: number, height: number, isBottom: boolean) {

            let leftMask: eui.Rect = new eui.Rect(x, this.stage.$stageHeight, 0x020202);
            this.guideGroup.addChild(leftMask);
            leftMask.fillAlpha = 0.5;
            leftMask.$setX(0);
            leftMask.$setY(0);
            leftMask.percentHeight = 100;

            let topMask: eui.Rect = new eui.Rect(width, y, 0x020202);
            this.guideGroup.addChild(topMask);
            topMask.fillAlpha = 0.5;
            topMask.$setX(x);
            topMask.$setY(0);
            if(isBottom) {
                topMask.top = 0; 
                topMask.bottom = this.stage.$stageHeight - y;
            }

            let rightMask: eui.Rect = new eui.Rect(this.stage.$stageWidth - width - x, this.stage.$stageHeight, 0x020202);
            this.guideGroup.addChild(rightMask);
            rightMask.fillAlpha = 0.5;
            rightMask.$setX(x + width);
            rightMask.$setY(0);
            rightMask.percentHeight = 100;
            
            let bottomMask: eui.Rect = new eui.Rect(width, this.stage.$stageHeight - height - y, 0x020202);
            this.guideGroup.addChild(bottomMask);
            bottomMask.fillAlpha = 0.5;
            bottomMask.$setX(x);
            bottomMask.$setY(y + height);
            bottomMask.bottom = 0;
            if(!isBottom) {
                 bottomMask.top = y + height;
            }

        }

        private finishedGuide() {
            if(this.guideGroup) {
                this.guideGroup.parent.removeChild(this.guideGroup);
                this.guideGroup = null;
				LogicMgr.get(logic.Guide).finishAction();
            }
        }
    }

}