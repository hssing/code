// TypeScript file

/**WWW
 *
 * 角色数据基类
 *
 */
class PlayerVO {
    public constructor(){
    }

    private id:number; //
    private modelId:number = 1002;// 
    private name:string;//
    private x; //地图坐标
    private y;
    private cellX = 0;  //格子坐标
    private cellY = 0; 
    private moveSpeed:number//
    private curHp:number = 5000; //当前血量
    private maxHp:number = 5000; //最大血量
    private unitCount:number = 4; //一个玩家 动画单位数量

    public setId(id: number): void {
        this.id = id;
    }
    public getId(): number {
        return this.id;
    }


    public setModelId(modelId: number): void {
        this.modelId = modelId;
    }
     
    public getModelId():number {
        return this.modelId;
    }

    public setName(name: string): void {
        this.name = name;
    }

    public getName():string {
        return this.name;
    }

    public setX(x: number): void {
        this.x = x;
    }
    public getX():number {
        return this.x;
    }

    public setY(y: number): void {
        this.y = y;
    }
    public getY():number {
        return this.y;
    }

    public setXY(x: number,y: number):void {
        this.x = x;
        this.y = y;
    }

    public getXY(): any {
        return [this.x , this.y];
    }

    public setCellX(cellX: number): void {
        this.cellX = cellX;
    }
    public getCellX():number {
        return this.cellX;
    }

    public setCellY(cellY: number): void {
        this.cellY = cellY;
    }
    public getCellY():number {
        return this.cellY;
    }

    public setCellXY(cellX: number,cellY: number):void {
        this.cellX = cellX;
        this.cellY = cellY;
    }

    public getCellXY(): any {
        return [this.cellX , this.cellY];
    }


    public setMoveSpeed(moveSpeed: number):void {
        this.moveSpeed = moveSpeed;
    }

    public getMoveSpeed():number {
        return this.moveSpeed
    }


    public setCurHp(curHp: number): void {
        this.curHp = curHp < 0?0:curHp;
    }

    public getCurHp(): number {
        return this.curHp;
    }


    public setMaxHp(maxHp: number): void {

    }

    public getMaxHp(): number {
        return this.maxHp;
    }    

    public getPecentHp(): number {
        return this.curHp / this.maxHp;
    }

    public setUnitCount(unitCount : number) {
        this.unitCount = unitCount;
    }

    public getUnitCount(): number{
        return this.unitCount;
    }
}