 namespace ResExt {
     
    export function loadConfig(name: string): Promise<any> {
        return new Promise((resolve, reject)=> {
            let completeFunc = (value)=> {
                RES.removeEventListener(RES.ResourceEvent.CONFIG_COMPLETE, completeFunc, this);
                resolve(value);
            }
            let errorFunc = (value)=> {
                RES.removeEventListener(RES.ResourceEvent.CONFIG_LOAD_ERROR, errorFunc, this);
                reject(value);
            }
            RES.addEventListener(RES.ResourceEvent.CONFIG_COMPLETE, completeFunc, this);
            RES.addEventListener(RES.ResourceEvent.CONFIG_LOAD_ERROR, errorFunc, this);
            RES.loadConfig(name, "resource/");
        });
    }

    export function loadGroup(name: string, priority = 0, progress?: (event: RES.ResourceEvent)=> void): Promise<any> {
        return new Promise((resolve, reject)=> {
            let completeFunc = (value)=> {
                RES.removeEventListener(RES.ResourceEvent.GROUP_COMPLETE, completeFunc, this);
                progress && RES.removeEventListener(RES.ResourceEvent.GROUP_PROGRESS, progress, this);
                resolve(value);
            }
            let errorFunc = (value)=> {
                RES.removeEventListener(RES.ResourceEvent.GROUP_LOAD_ERROR, errorFunc, this);
                progress && RES.removeEventListener(RES.ResourceEvent.GROUP_PROGRESS, progress, this);
                reject(value);
            }
            RES.addEventListener(RES.ResourceEvent.GROUP_COMPLETE, completeFunc, this);
            RES.addEventListener(RES.ResourceEvent.GROUP_LOAD_ERROR, errorFunc, this);
            progress && RES.addEventListener(RES.ResourceEvent.GROUP_PROGRESS, progress, this);
            RES.loadGroup(name, priority);
        });
    }
 }
    