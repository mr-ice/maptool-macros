[h:hasTempHP = if(getProperty("tempHP") == "", 0, 1)]
[h,if(hasTempHP), CODE: {
   <!-- has temp hp -->
   [h:doDamage = doDamage - tempHP]
   [h:tempHP = if(doDamage < 0, doDamage * - 1, "")]
   [h:doDamage = if(doDamage < 0, 0, doDamage)]
};
{
<!-- has no temp hp (no op) -->
}]
[h:Damage = Damage + doDamage]
[h:wasBloodied = getState("Bloodied")]
[h:Damage=if(Damage > HP, HP, Damage)]
[h:state.Bloodied=if(Damage > (HP / 2), 1, 0)]
[h:state.Dead=if(Damage == HP, 1, 0)]
[r:if((wasBloodied + getState("Bloodied")) == 1, "Bloodied!<br>", "")]
[h:isDead = getState("Dead")]
[h:state.Prone = if(isDead, isDead, state.Prone)]
[r:if(isDead == 1, "DEAD!", "Total Damage = " + Damage)]