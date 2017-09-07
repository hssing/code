// TypeScript file

/**
 *
 *怪物类
 *
 */

class MonsterView extends PlayerView{

    protected static instance:MonsterView;
    public constructor() {
        super();
        MonsterView.instance = this;
       
    }

    public static getMonster() {
        if (!MonsterView.instance){
            MonsterView.instance = new MonsterView();
        }
        return  MonsterView.instance;
    }

    protected createChildren(): void {
        // super.createChildren();
        this.autoMove();
    }

    //怪物ai 随意动
    public autoMove(): void {
        var vo:PlayerVO = RoleView.getRoleView().vo;
        // this.moveToPos(vo.getX()+200,vo.getY() + 500);
    }
}