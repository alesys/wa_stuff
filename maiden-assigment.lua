function()
   local spell1 = GetSpellInfo(235213)
   local spell2 = GetSpellInfo(235240)
   local name = UnitName("player")
   aura_env.holy = {}
   aura_env.fel = {}
   local j = GetNumGroupMembers()
   if j > 20 then j = 20 end
   for i=1,j do
       local name2 = GetRaidRosterInfo(i)
       local role = UnitGroupRolesAssigned(name2)
       if role ~= "TANK" and not UnitIsDead(name2) then
           if UnitDebuff(name2, spell1) then
               table.insert(aura_env.holy, name2)
           elseif UnitDebuff(name2, spell2) then
               table.insert(aura_env.fel, name2)
           end
       end
   end
   local holy = getn(aura_env.holy)
   local fel = getn(aura_env.fel)
   if UnitGroupRolesAssigned(name) == "TANK" then
       return "OUTER"
   else
       if aura_env.holy[1] == name or aura_env.fel[1] == name then
           return "MIDDLE"
       elseif aura_env.holy[2] == name or aura_env.fel[2] == name then
           return "INNER"
       else
           if aura_env.holy[holy] == name or aura_env.fel[fel] == name then
               return "BEHIND - OUTER"
           end
           if aura_env.holy[holy-1] == name or aura_env.fel[fel-1] == name then
               return "BEHIND - MIDDLE"
           end
           if aura_env.holy[holy-2] == name or aura_env.fel[fel-2] == name then
               return "BEHIND - INNER"
           end
           return "CAMP"
       end
       return "ERROR/CAMP"
   end
 end
