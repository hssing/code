class ExtendList extends eui.Group {

	private items: IRBase[];
	private scroller: eui.Scroller;
	private group: eui.Group;
 
	public constructor() {
		super();

		this.group = new eui.Group();
		this.group.percentWidth = 100;
		this.group.percentHeight = 100;
		this.group.layout = new eui.VerticalLayout();
		this.group.horizontalCenter = 0;

		this.scroller = new eui.Scroller();
		this.scroller.viewport = this.group;
		this.scroller.percentWidth = 100;
		this.scroller.percentHeight = 100;
		this.addChild(this.scroller);
	}

	public setItems(items: any[]) {
		if(!items) {
			return;
		}
		
		if(this.items) {
			for(let i = 0; i < this.items.length; i ++) {
				this.items[i].parent.removeChild(this.items[i]);
			}
		}
		this.items = items;
		for(let i: number = 0; i < items.length; i++) {
			this.group.addChild(this.items[i]);
		}
	}

	public insertItem(item: IRBase, index: number) {
		this.items.splice(index, 0, item);
		this.group.addChild(item);
		this.group.setChildIndex(item, index);
	}

	public removeItem(index: number) {
		if(this.items.length <= index) {
			return;
		}

		let item = this.items[index];
		this.items.splice(index, 1);
		item.parent.removeChild(item);
	}

	public getItem(index: number): any {
		if(this.items.length <= index) {
			return undefined;
		}

		let item = this.items[index];
		return item;
	}

	public updateDataItem(index: number, data: any) {
		if(this.items.length <= index) {
			return;
		}

		this.items[index].data = data;
	}

	public getItemsCount() {
		return this.items.length;
	}

	public setGap(gap: number) {
		let layout = this.group.layout as eui.VerticalLayout;
		layout.gap = 10;
		this.group.layout = layout;
	}
}
