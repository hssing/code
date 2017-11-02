class Animation extends egret.DisplayObjectContainer {
    private aniBitmap:egret.Bitmap;
    private drawBitmap:egret.Bitmap;
    private barMask:egret.Rectangle;
    private frameRate = 12;
    private  dataInfo;
    private frameIndex = 0;
    private drawTexture: egret.RenderTexture;
    private spriteSheet:egret.SpriteSheet;

    private oldX = 0;
    private oldY = 0;

    private oldOffsetX = 0;
    private oldOffsetY = 0;    
    private timer: egret.Timer

    private anchorX:number = 0;
    private anchorY:number = 0;

    private actionFrames:any;  //帧信息保存这里。
    private static actionPool:Map<string,any> = new Map<string,any>();
    public acName:string[] = ["idle/","run/","attack/"];
    public acDir:string[] = ["/up/","/right_up/","/right/","/right_down/","/down/"];
    private cur_acNameIndex:number = 0;
    private cur_acDirIndex:number = 0;
    private cur_frames:any ;

    private playOnes:boolean; //是否播放一次则删除
    private aniName;

    public constructor(aniName) {
        super();
        this.aniName = aniName;

        this.drawBitmap = new egret.Bitmap();
        let _bar:string = aniName + '_png';
        this.aniBitmap = new egret.Bitmap(RES.getRes(_bar));
   
        // if (!Animation.dataInfo){
        //     console.log("初始化 === " + aniName);
            this.dataInfo = RES.getRes(aniName + '_json');
        // }else{
        //      console.log("不初始化 === " + aniName);
        // }
        

        let actionFrames = Animation.actionPool.get(aniName);
        if (actionFrames){
            this.actionFrames = actionFrames;
            // console.log("//////////// 直接拿缓存的..............");
        }else {
            
            let frames =  this.dataInfo['frames'];
            // console.log("frames.length == " + frames.length);
            for (let i = 0 ; i < frames.length ; i++) {
                let filename:string = frames[i].filename;
                //   console.log("filename == " +filename);
                for (let j = 0 ; j < this.acName.length ; j++) {
                    if (filename.indexOf(this.acName[j]) >= 0) {
                        for (let n = 0 ; n < this.acDir.length ; n++) {
                            if (filename.indexOf(this.acDir[n]) >= 0) {
                                if (!this.actionFrames) this.actionFrames = new Array<number>();
                                if (!this.actionFrames[j]) this.actionFrames[j] = new Array<number>();
                                if (!this.actionFrames[j][n]) this.actionFrames[j][n] = new Array<number>();
                                this.actionFrames[j][n][this.actionFrames[j][n].length] = i;
                                // console.log("j == i == " + i);
                            }
                        }
                    }
                }
            }
             Animation.actionPool.set(aniName,this.actionFrames);
        }


        this.drawTexture = new egret.RenderTexture();

        this.timer = new egret.Timer(1000/this.frameRate, 0);
        this.timer.addEventListener(egret.TimerEvent.TIMER, this.timerFunc, this);
        // this.timer.start();
    }

    public playNext () {
        if (!this.cur_frames)return ;

        if (this.playOnes){
            if (this.frameIndex >= this.cur_frames.length){
                this.stop();
                this.parent.removeChild(this);
            }
        }
        // console.log(this.aniName + " == this.cur_acDirIndex == " + this.cur_acDirIndex)
        // console.log(this.aniName + " == this.cur_acNameIndex == " + this.cur_acNameIndex)
        let frames =  this.dataInfo['frames'];
        let frameIndex = this.cur_frames[this.frameIndex % this.cur_frames.length];
        let curFrame =  frames[frameIndex].frame;

        // var renderTexture: egret.RenderTexture = new egret.RenderTexture();  
        // this.drawTexture.drawToTexture(this.aniBitmap,new egret.Rectangle(curFrame.x,curFrame.y,curFrame.w,curFrame.h));  //
        // this.drawBitmap.texture = this.drawTexture;

            if ( this.contains(this.drawBitmap)){
                this.removeChild(this.drawBitmap);
            }
            let bm = this.aniBitmap ;//new egret.Bitmap(bitmapData);
            // if (!this.spriteSheet){
                this.spriteSheet = new egret.SpriteSheet(bm.texture);
            // }
            //创建一个新的 Texture 对象
            // let rect = tile.rect;
            let key  = this.aniName  + "/" + this.cur_acNameIndex + "/"  + this.cur_acDirIndex + "/" +  (this.frameIndex % this.cur_frames.length);
            // console.log("key  ============ " +  key );
            let tx =  this.spriteSheet.getTexture(key);
            if (!tx) {
                tx =  this.spriteSheet.createTexture(key,curFrame.x,curFrame.y,curFrame.w,curFrame.h);
                this.drawBitmap = new egret.Bitmap(tx);
            }
            
            // this.drawBitmap = new egret.Bitmap(tx);


        // if ( this.contains(this.drawBitmap)){

        // }else{
            this.addChild(this.drawBitmap);
            this.drawBitmap.anchorOffsetX +=this.drawBitmap.$getContentBounds().width/2;
            this.drawBitmap.anchorOffsetY +=this.drawBitmap.$getContentBounds().height;
        // }

        //  console.log("this.timer ========== " );


        let source = frames[frameIndex].spriteSourceSize;
        if (this.anchorX ===  0 && this.anchorY === 0){
            this.anchorX = source.x;
            this.anchorY = source.y;
        }
        this.drawBitmap.x -=this.oldOffsetX ;
        this.drawBitmap.y -=this.oldOffsetY;
        this.drawBitmap.x += source.x - this.anchorX;
        this.drawBitmap.y += source.y - this.anchorY;
        this.oldOffsetX = source.x - this.anchorX;
        this.oldOffsetY = source.y - this.anchorY;

        this.frameIndex++;   
    }

    private timerFunc(event: egret.Event) {
        //  console.log("this.timer ========== " );
         this.playNext();
    }    


    /**
     * @param acName播放的 动作名字 
     * @param acDir 播放的 动作方向
     */
    public play (acName:number,acDir:number,playOnes?:boolean) {
        this.frameIndex = 0;
        this.cur_acNameIndex = acName;
        this.cur_acDirIndex = acDir;
        this.playOnes = playOnes

        if (this.cur_acDirIndex === ACTION_DIR.UP_45_REVERSE){
            this.cur_acDirIndex = ACTION_DIR.UP_45;
        }else if (this.cur_acDirIndex === ACTION_DIR.DOWN_45_REVERSE) {
            this.cur_acDirIndex = ACTION_DIR.DOWN_45;
        }else if (this.cur_acDirIndex === ACTION_DIR.RIGHT_REVERSE) {
            this.cur_acDirIndex = ACTION_DIR.RIGHT;
        }

        // console.log("this.cur_acNameIndex == " + this.cur_acNameIndex);
        // console.log(this.aniName + " == this.cur_acDirIndex == " + this.cur_acDirIndex)

        this.cur_frames = this.actionFrames[this.cur_acNameIndex][this.cur_acDirIndex];
        this.timer.start();
    }

    public stop () {
        this.timer.stop ();
    }


}