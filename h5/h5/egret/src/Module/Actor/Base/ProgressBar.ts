class ProgressBar extends egret.Sprite {
    public background:egret.Bitmap;
    public bar:egret.Bitmap;
    public barMask:egret.Rectangle;
    /**
     * 反向进度条
     * */
    public reverse = false;
    public constructor( ) {
        super();
        let _bg:string = 'xuetiao_back_png';
        let _bar:string = 'xuetiao01_png';
        this.background = new egret.Bitmap(RES.getRes(_bg));
        this.bar = new egret.Bitmap(RES.getRes(_bar));
        this.addChild(this.background);
        this.addChild(this.bar);
        this.bar.x = (this.background.width - this.bar.width) / 2;
        this.bar.y = (this.background.height - this.bar.height) / 2;
        this.barMask = new egret.Rectangle(0, 0, this.bar.width, this.bar.height);
        this.bar.mask = this.barMask;
    }
    public setProgress(_p) {
        this.barMask = new egret.Rectangle(0, 0, (this.reverse ? (1 - _p) : _p) *       this.bar.width, this.bar.height);
        this.bar.mask = this.barMask;
    }
}