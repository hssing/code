class PageView extends eui.Group {
	
	private data: eui.ArrayCollection;
	private curPage: number;
	private itemRenderer: any;

	private orientation: PageViewOrientation;

	private prePoint: egret.Point;
	private startPoint: egret.Point;
	private items: Array<any>;
	private maskObj: eui.Rect;
	private isMoveing: boolean;
	private isDoAmn: boolean;
	private itemSkinName: string;

	public constructor() {
		super();
	
		this.data = new eui.ArrayCollection();
		this.curPage = 0;

		
		this.startPoint = new egret.Point(0, 0);
		this.prePoint = new egret.Point(0, 0);
		
		this.isMoveing = false;
		this.isDoAmn = false;

		this.items = new Array<any>();
		
		this.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onTouchBegin, this);
		this.addEventListener(egret.TouchEvent.TOUCH_MOVE, this.onTouchMove, this);
		this.addEventListener(egret.TouchEvent.TOUCH_END, this.onTouchEnd, this);
	}

	protected createChildren() {
		super.createChildren();

		this.maskObj = new eui.Rect(this.width, this.height);
		this.maskObj.x = 0;
		this.maskObj.y = 0;
		this.addChild(this.maskObj);
		this.mask = this.maskObj;

	}

	public setTouchEnabled(enable: boolean) {
		this.touchEnabled = false;
		if(enable === false) {
			this.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onTouchBegin, this);
			this.removeEventListener(egret.TouchEvent.TOUCH_MOVE, this.onTouchMove, this);
			this.removeEventListener(egret.TouchEvent.TOUCH_END, this.onTouchEnd, this);
		}

		if(enable === true) {
			this.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onTouchBegin, this);
			this.addEventListener(egret.TouchEvent.TOUCH_MOVE, this.onTouchMove, this);
			this.addEventListener(egret.TouchEvent.TOUCH_END, this.onTouchEnd, this);
		}
	}

	public setData(data: eui.ArrayCollection) {
		this.data = data;
		this.crateItems();
		this.refeshItemData();
	}

	private refeshItemData() {
		let listData: eui.ArrayCollection = new eui.ArrayCollection();
		let itemData = this.data.getItemAt(this.curPage -1);
		if(itemData && this.items[0]) {
			this.items[0].data = itemData;
			this.items[0].visible = true;
			if(this.items[0].onRefreshData) {
				this.items[0].onRefreshData();
			}
		} else {
			this.items[0].visible = false;
		}

		let itemData1 = this.data.getItemAt(this.curPage);
		if(itemData1 && this.items[1]) {
			this.items[1].data = itemData1;
			this.items[1].visible = true;
			if(this.items[1].onRefreshData){
				this.items[1].onRefreshData();
			}
		} else {
			this.items[1].visible = false;
		}

		let itemData2 = this.data.getItemAt(this.curPage + 1);
		if(itemData2 && this.items[2]) {
			this.items[2].data = itemData2;
			this.items[2].visible = true;
			if(this.items[2].onRefreshData) {
				this.items[2].onRefreshData();
			}
		} else {
			this.items[2].visible = false;
		}
	} 

	public getCurPageDataById(id) {
		if(this.data){
			return this.data.getItemAt(id);
		}
		return undefined;
	}

	public getItemAt(id: number) {
		if(id === this.curPage) {
			return this.items[1];
		}

		if(id === (this.curPage -1 ) && id > 0 ) {
			return this.items[id - 1];
		} 

		if(id === this.curPage + 1 && id < this.data.length -1) {
			return this.items[id + 1];
		}
	}

	public getCurPageId() {
		return this.curPage;
	}

	public setCurPageId(pageId: number) {
		if(pageId >= this.data.length) {
			return;
		}

		this.curPage = pageId;
	}

	private crateItems(){
		if(this.items.length === 3) {
			return
		}
		
		if(this.itemRenderer) {
			this.items.push(<IRBase> (new this.itemRenderer()));   	
			this.items.push(<IRBase> (new this.itemRenderer()));
			this.items.push(<IRBase> (new this.itemRenderer()));
		} else {
			this.items.push(new eui.ItemRenderer());
			this.items.push(new eui.ItemRenderer());
			this.items.push(new eui.ItemRenderer());
		}

		if(this.itemSkinName) {
			this.items[0].skinName = this.itemSkinName;
			this.items[1].skinName = this.itemSkinName;
			this.items[2].skinName = this.itemSkinName;
		}
		
        this.items[0].x = -this.width;
		this.items[0].visible = false;
		this.addChild(this.items[0]);

        this.items[1].x = 0;		
		this.addChild(this.items[1]);

        this.items[2].x = this.width;
        this.addChild(this.items[2]);
	}

	public setPageItem(itemRender: any) {
		this.itemRenderer = itemRender;
	}

	public setItemSkinName(skinName: string) {
		this.itemSkinName = skinName;
	}

	private onTouchBegin(e: egret.TouchEvent) {
		if(this.isMoveing) {
			return;
		}
		this.isMoveing = true;
		this.prePoint.x = e.stageX;
		this.prePoint.y = e.stageY;
		this.startPoint.x = e.stageX;
		this.startPoint.y = e.stageY;
	}

	private onTouchMove(e: egret.TouchEvent) {
		this.items[0].x += e.stageX - this.prePoint.x;
		this.items[1].x += e.stageX - this.prePoint.x;
		this.items[2].x += e.stageX - this.prePoint.x;
		
		this.prePoint.x = e.stageX;
		this.prePoint.y = e.stageY;
	}

	private onTouchEnd(e: egret.TouchEvent) {
		let distance = e.stageX - this.startPoint.x;
		if(Math.abs(distance) < this.width / 3 ) {
			this.isMoveing = false;
			this.backOrigin();
			return;
 		} 

		if(distance >= this.width / 3){
			if(this.curPage === 0) {
				this.backOrigin();
				return;
			}
			this.forwardPage();
		 }

		 if(distance <= -this.width / 3) {
			 if(this.curPage === (this.data.length -1)) {
				 this.backOrigin();
				 return;
			 }
			 this.nextPage();
		 }

	}

	private backOrigin() {
		this.items[0].x = -this.width
		this.items[1].x = 0;
		this.items[2].x = this.width;
		this.isMoveing = false;
	}

	public forwardPage() {
		if(this.curPage === 0) {
			return;
		}

		if(this.isDoAmn) {
			return;
		}

		this.isDoAmn = true;
		let twItem0 = egret.Tween.get( this.items[0] );
		twItem0.to( {x : 0}, 200 )
		let twItem1 = egret.Tween.get( this.items[1] );
		twItem1.to( {x : this.width}, 200 )
		let twItem2 = egret.Tween.get( this.items[2] );
		twItem2.to( {x : (2 * this.width)}, 200 ).call(() => {
			let item = this.items[2];
			item.x = - this.width;
			this.items.pop();
			this.items.splice(0, 0, item);
			this.refeshItemData();
			this.isMoveing = false;
			this.isDoAmn = false;
		});

		this.curPage -= 1;
	}

	public nextPage() {
		if(this.curPage >= (this.data.length - 1)) {
			return;
		}

		if(this.isDoAmn) {
			return;
		}

		this.isDoAmn = true;
		let twItem2 = egret.Tween.get( this.items[2] );
		twItem2.to( {x: 0}, 200 );
		let twItem1 = egret.Tween.get( this.items[1] );
		twItem1.to( {x: - this.width}, 200 )
		let twItem0 = egret.Tween.get( this.items[0] );
		twItem0.to( {x: - (2 * this.width)}, 200 ).call(() => {
			let item = this.items[0];
			item.x = this.width;
			this.items.shift();
			this.items.push(item);
			this.refeshItemData();
			this.isMoveing = false;
			this.isDoAmn = false;
		});

		this.curPage += 1;
	}

}

enum PageViewOrientation {
	 VERTICAL = 0,
	 HORIZONTAL = 1,
}