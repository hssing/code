// TypeScript file

namespace Actor {
    
    export class McManger{
        public static pool = {};

        public static MC_CONFIG:string = "resource/dassets/Mc/";
        public static getMcData(key:string,cb) {
            if (!McManger.pool[key]) {
                let _mcData ; //= RES.getRes(key + "_json");//JSON  
                let _mcTexture ; // = RES.getRes(key + "_png");//Texture   

                RES.getResByUrl(McManger.MC_CONFIG +  key + ".json", (data) => {
                     _mcData = data;
                     RES.getResByUrl(McManger.MC_CONFIG +  key + ".png", (texture) => {
                        _mcTexture = texture;
                        let _mcDataFactory = new egret.MovieClipDataFactory(_mcData, _mcTexture);
                        McManger.pool[key] = _mcDataFactory;          
                        cb( McManger.pool[key]);              
                    }, this);
                }, this);

      
                // let _mcDataFactory = new egret.MovieClipDataFactory(_mcData, _mcTexture);
                // McManger.pool[key] = _mcDataFactory;
            }else{
                // egret.log("key = " + key);
                cb(McManger.pool[key]);
            }
            // return McManger.pool[key];
        }
    }

    export function createDataFactory(effectPath: string,cb) {
         McManger.getMcData(effectPath,cb);
    }

    // @param effectPath
    export function createMC(effectPath: string,actionName:string,cb) {
            let cbFunc = (_mcDataFactory)=>{
                var action = new egret.MovieClip(_mcDataFactory.generateMovieClipData(actionName)); //run_l_d_d
                action.gotoAndPlay(1,-1);
                cb(action);
            }
            McManger.getMcData(effectPath,cbFunc);
    }

    export function playOneAndRemove(effectPath: string,actionName:string,parent:any,x?:number,y?:number){
        let cb = (action)=> {
            action.x += parent.anchorOffsetX;
            action.y += parent.anchorOffsetY;
            if (x && y){
                action.x += x;
                action.y += y;
            }
            parent.addChild(action);
            action.addEventListener(egret.Event.LOOP_COMPLETE, (e:egret.Event)=>{
                                                                                    console.log("/////////action.parent.removeChild(action)")
                                                                                    action.parent.removeChild(action)
                                                                                }, this);
        }
        
        Actor.createMC(effectPath,actionName ,cb);

    }
}