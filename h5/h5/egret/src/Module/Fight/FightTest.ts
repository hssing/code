namespace Fight {
    export class FightTest {
        public fightData = [];
        public roundIndex = 0
        public calculateFightData(startArmyViews: ArmyView,targetArmyViews: ArmyView) :any {
                //暂时测试 ...
                

                let startRoleViews = startArmyViews.getRoleViews();
                let targetRoleViews = targetArmyViews.getRoleViews();

               for (let k1 in startRoleViews) {
                   for (let k2 in targetRoleViews) {
                       //找相对的格子
                       if ((startRoleViews[k1].vo.getCellX() + 1 == targetRoleViews[k2].vo.getCellX() ) && (startRoleViews[k1].vo.getCellY() - 1 == targetRoleViews[k2].vo.getCellY()))
                       {
                           startRoleViews[k1].setAttackView(targetRoleViews[k2]);
                           targetRoleViews[k2].setAttackView(startRoleViews[k1]);
                           console.log("一对..............");
                           continue;
                       }
                   }
               }

               let viewsIndex = 0;
               let launchRoleViews = startRoleViews;
               while(!this.meAttackOther(launchRoleViews,viewsIndex)) {
                   viewsIndex++;
                   launchRoleViews = viewsIndex % 2 == 0?startRoleViews:targetRoleViews;
               }


               return this.fightData;
        }

        public meAttackOther(launchRoleViews,viewsIndex) {
               //本军打敌军
               let lose = true;;
               for (let k1 in launchRoleViews ){
                   let view = launchRoleViews[k1] as RoleView;
                //    if (view.getVO_temp().getCurHp() <= 0 || view.getAttackView().getVO_temp().getCurHp() <= 0) {
                   if ( view.getAttackView().getVO_temp().getCurHp() <= 0) {
                       console.log("(攻击或被击)该单位阵亡................. id =" +view.getAttackView().getVO_temp().getId());
                       continue;
                   }
                   lose = false;
                   let oneRound = {};
                   
                   console.log(view.getVO().getId() +  " 击打了 " + view.getAttackView().getVO().getId()  ) ;

                   oneRound['attacker_id'] = k1;
                   oneRound['attacker_type'] = 0;
                   oneRound['attacker_hp'] = view.vo.getCurHp();
                   oneRound['skill_id'] = 0;
                   oneRound['attacker_x'] = view.vo.getX();
                   oneRound['attacker_y'] = view.vo.getY();

                   let attack_info_list = {};
                   attack_info_list['defender_id'] = view.getAttackView().getVO().getId();

                   let damage_info_list = {};
                   
                   damage_info_list['damage'] =  Math.floor(Math.random() *( viewsIndex % 2 == 0?500:200));
                   damage_info_list['defender_hp'] = view.getAttackView().getVO_temp().getCurHp() - damage_info_list['damage']
                   view.getAttackView().getVO_temp().setCurHp(damage_info_list['defender_hp']);

                   attack_info_list['damage_info_list'] = damage_info_list;

                   oneRound['attack_info_list'] = attack_info_list;

                    this.fightData[this.roundIndex] = oneRound;
                    this.roundIndex++;
               }  

               return lose;
        }
    }
}