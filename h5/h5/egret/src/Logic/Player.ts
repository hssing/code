namespace logic {
	export class Player extends Logic { 
		private uid: string           //用户id
        private roleId: number;       //角色id
        private roleName: string;     //角色名字
        private roleLevel: number;    //角色等級
        private roleExp: number;      //角色经验
        private nextLevelExp: number; //下一等级需要的经验
        private svrId: string;        //服务器id
        private svrName: string;      //服务器名字
        private coin: number;         //金币
        private ingot: number;        //钻石
        private vipLevel: number;     //vip等级
        private camp: number;         //阵营

		public constructor() {
            super();
        }

		public setUid(uid: string) {
			this.uid = uid;
		}

		public getUid(): string {
			return this.uid;
		}

		public setRoleId(roleId: number) {
			this.roleId = roleId;
		}

		public getRoleId(): number {
			return this.roleId;
		}

		public setRoleName(roleName: string) {
			this.roleName = roleName;
		}

		public getRoleName(): string {
			return this.roleName;
		}

		public setRoleLevel(roleLevel: number) {
			this.roleLevel = roleLevel;
		}

		public getRoleLevel(): number {
			return this.roleLevel;
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
			this.coin = coin;
		}

		public getCoin() {
			return this.coin;
		}

		public setIngot(ingot: number) {
			this.ingot = ingot;
		}

		public getIngot(): number {
			return this.ingot;
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
	}
}