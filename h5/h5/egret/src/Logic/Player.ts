namespace logic {

	export class Player extends Logic {

        public static EVT = utils.Enum([
            "REFRESH_RES",
			"REFRESH_RES_CAPACITY",
        ]);

		private uid: string           //用户id
        private role_id: number;      //角色id
        private nick: string;         //角色名字
        private lv: number;           //角色等級
        private roleExp: number;      //角色经验
        private nextLevelExp: number; //下一等级需要的经验
        private svrId: string;        //服务器id
        private svrName: string;      //服务器名字
        private vipLevel: number;     //vip等级
        private camp: number;         //阵营
		private p_base_tax: BaseTax;  //
		private p_res: Res;           //资源数量
		private army_enroll_infos: ArmyEnrollInfo[]; //军营征兵
		private resCapacity: ResCapacity     //基础资源的容量
		private resProduction: ResProduction //基础资源产量

		public constructor() {
            super();
        }

		public refreshRes(): void {
			this.fireEvent(Player.EVT.REFRESH_RES, this.p_res);
		}

		public refreshResCapacity(): void {
			this.fireEvent(logic.Player.EVT.REFRESH_RES_CAPACITY, this.resCapacity, this.p_res);
		}

		public isPlayer(roleId: number): boolean {
			return this.getRoleId() === roleId;
		}

		public setUid(uid: string) {
			this.uid = uid;
		}

		public getUid(): string {
			return this.uid;
		}

		public setRoleId(roleId: number) {
			this.role_id = roleId;
		}

		public getRoleId(): number {
			return this.role_id;
		}

		public setRoleName(roleName: string) {
			this.nick = roleName;
		}

		public getRoleName(): string {
			return this.nick;
		}

		public setRoleLevel(roleLevel: number) {
			this.lv = roleLevel;
		}

		public getRoleLevel(): number {
			return this.lv;
		}

		public setRoleExp(roleExp: number) {
			this.roleExp = roleExp;
		}

		public getRoleExp(): number {
			return this.roleExp;
		}

		public setNextLevelExp(nextLevelExp: number) {
			this.nextLevelExp = nextLevelExp;
		}

		public getNextLevelExp(): number{
			return this.nextLevelExp;
		}

		public setSvrId(svrId: string) {
			this.svrId = svrId;
		}

		public getSvrId(): string {
			return this.svrId;
		}

		public setSvrName(svrName: string) {
			this.svrName = svrName;
		}

		public getSvrName(): string {
			return this.svrName;
		}

		public setCoin(coin: number) {
			this.p_res.coin = coin;
		}

		public getCoin() {
			return this.p_res.coin;
		}

		public setIngot(ingot: number) {
			this.p_res.ingot = ingot;
		}

		public getIngot(): number {
			return this.p_res.ingot;
		}

		public setVipLevel(vipLevel: number) {
			this.vipLevel = vipLevel;
		}

		public getVipLevel(): number {
			return this.vipLevel;
		}

		public setCamp(camp: number) {
			this.camp = camp;
		}

		public getCamp(): number {
			return this.camp
		}

		public setBaseTax(baseTax: BaseTax) {
			this.p_base_tax = baseTax
		}

		public getBaseTax(): BaseTax {
			return this.p_base_tax;
		}

		public setRedif(redif: number) {
			this.p_res.redif = redif;
		}

		public getRedidf(): number {
			return this.p_res.redif;
		}

		public setRes(useRes: Res) {
			this.p_res = useRes;
			this.refreshRes();
		}

		public getRes(): Res {
			return this.p_res;
		}

		public setArmyEnrollInfos(army_enroll_infos) {
			this.army_enroll_infos = army_enroll_infos;
		}

		public getArmyEnroolInfos(): ArmyEnrollInfo[] {
			return this.army_enroll_infos;
		}

		public getCereal(): number {       //获取粮食数
			return this.p_res.cereals;
		}

		public getBaseCereal(): number {
			return this.p_res.cereals_base;
		}

		public setCereal(count: number) {  //设置粮食数
			this.p_res.cereals = count;
		}

		public setBaseCereal(count: number) {
			this.p_res.cereals_base = count;
		}

		public getStone(): number {        //得到石头数
			return this.p_res.stone;
		}

		public getBaseStone(): number {
			return this.p_res.stone_base;
		}

		public setStone(count: number) {   //设置石头数
			this.p_res.stone = count;
		}

		public setBaseStone(count: number) {
			this.p_res.stone_base = count;
		}

		public getSteel(): number {         //得到钢铁数
			return this.p_res.steel;
		}

		public getBaseSteel(): number {
			return this.p_res.steel_base;
		}

		public setSteel(count: number) {    //设置钢铁数
			this.p_res.steel = count;
		}

		public setBaseSteel(count: number) {
			this.p_res.steel_base = count;
		}

		public getSoil(): number {      //设置硅土数
			return this.p_res.soil;
		}

		public getBaseSoil(): number {
			return this.p_res.soil_base;
		}

		public setSoil(count: number) { //得到硅土数
			this.p_res.soil = count;
		}

		public setBaseSoil(count: number) {
			this.p_res.soil_base = count;
		}

		public setResCapacity(resCapacity: ResCapacity) {
			this.resCapacity = resCapacity;
			this.refreshResCapacity();
		}

		public setResProduction(resProduction: ResProduction) {
			this.resProduction = resProduction;
		}

		public getCerealCapacity(): number {
			return this.resCapacity.cereals;
		}

		public getStoneCapacity(): number {
			return this.resCapacity.stone;
		}

		public getSteelCapacity(): number {
			return this.resCapacity.steel;
		}

		public getTripoliCapacity(): number {
			return this.resCapacity.soil;
		}

		public getCerealProduction(): number {
			return this.resProduction.cereals;
		}

		public getStoneProduction(): number {
			return this.resProduction.stone;
		}

		public getSteelProduction(): number {
			return this.resProduction.steel;
		}

		public getSoilProduction(): number {
			return this.resProduction.soil;
		}

		public getRedifProduction(): number {
			return this.resProduction.redif;
		}

		public getRedifCapacity(): number {
			return this.resCapacity.redif;
		}

		public getCoinProduction(): number {
			return this.resProduction.coin;
		}

		public getResProductionByResId(id: number): number {
			let resProductionIdMap = {
				[ResTypeId.Cereal]: this.resProduction.cereals,
				[ResTypeId.Stone]: this.resProduction.stone,
				[ResTypeId.Steel]: this.resProduction.steel,
				[ResTypeId.Soil]: this.resProduction.soil,
				[ResTypeId.Coin]: this.resProduction.coin,
				[ResTypeId.Redif]: this.resProduction.redif,
			}
			return resProductionIdMap[id];
		}

		public getResCapacityByResId(id: number): number {
			let resCapacityIdMap = {
				[ResTypeId.Cereal]: this.resCapacity.cereals,
				[ResTypeId.Stone]: this.resCapacity.steel,
				[ResTypeId.Steel]: this.resCapacity.steel,
				[ResTypeId.Soil]: this.resCapacity.soil,
				[ResTypeId.Redif]: this.resCapacity.redif,
			}
			return resCapacityIdMap[id];
		}
	}

	export class BaseTax{
    	public today_tax_count: number; // 今日征税次数
   		public today_buy_count: number; // 今日购买次数
    	public buy_count_used: number;  // 购买次数使用
    	public next_timestamp: number;  // 下次刷新时间戳
	} 

	export class ArmyEnrollInfo {
		public building: number;              //军营id
		public start_time: number;            //开始时间
		public end_time: number;              //结束时间
		public army_enrolling: ArmyEnrolling[]; //征兵情况
	}

	export class ArmyEnrolling {
		public pos: number;        //位置
		public enroll_num: number;  //征兵数量
	}

	export class Res{
		public cereals?: number;//普通粮食
		public stone?: number;//普通石头
		public steel?: number;//普通钢铁
		public soil?: number;//普通土
		public coin?: number;//金币
		public ingot?: number;//钻石
		public energy?: number;//体力
		public redif?: number;//预备兵 
		public cereals_base?: number;//保护粮食
		public stone_base?: number;//保护石头
		public steel_base?: number;//保护钢铁
		public soil_base?: number;//保护土
	}

	export class ResCapacity{
		public cereals: number; //粮食上限
		public stone: number; //石头上限
		public steel: number; //钢铁上限
		public soil: number; //硅土上限
		public redif: number; //预备兵上限
	}

	export class ResProduction{
		public cereals: number; //粮食产量
		public stone: number; //石头产量
		public steel: number; //钢铁产量
		public soil: number; //硅土产量
		public coin: number; //金币征税的数量
		public redif: number; //预备兵产量
	}

	export const enum ResTypeId { 
		Cereal = 1,         //粮食
		Stone,              //石头
		Steel,              //钢铁
		Soil,               //硅土
		Coin,               //金币
		Ingot,              //钻石
		Power,              //体力
		Redif,              //预备兵
	}
}