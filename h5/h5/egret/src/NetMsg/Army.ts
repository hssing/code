namespace msg {

	export class Army extends NetMsg {

		public proto: string = "net/proto.proto";
		public modId: number = 140;
		public subIds = 
		{
			1 : "m_army_get_own_soldier_tos",
			2 : "m_army_get_own_soldier_toc",
			3 : "m_army_set_soldier_tos",
			4 : "m_army_set_soldier_toc",
		};

		public on(name: "m_army_get_own_soldier_toc"|"m_army_set_soldier_toc", event: events.Event): void {
			super.on(name, event);
		}

		public send(name: "m_army_get_own_soldier_tos"|"m_army_set_soldier_tos", obj?: Object): void {
			super.send(name, obj);
		}
	}

}