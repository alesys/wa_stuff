function(event, timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags,  spellid, spellName)
    if subevent == "SPELL_AURA_APPLIED"  and spellName == "Wrath of Gul'dan" then

        if destName == aura_env.playerName then
            aura_env.wrathOnMe = true
        end

        for i=1,GetNumGroupMembers() do
            local raider="raid"..i
            if destName == UnitName(raider) then
                table.insert(aura_env.hasDebuffTable, raider) -- insert the person who has the debuff
            end
        end

        return true


    elseif  subevent == "SPELL_AURA_REMOVED" and spellName == "Wrath of Gul'dan" then -- check if the aura is removed.

        if destName == aura_env.playerName then
            aura_env.wrathOnMe = false
        end

        for k,v in pairs(aura_env.hasDebuffTable) do -- for every player that has the debuff
            local name = UnitName(v)
            if name == destName then -- check if their name matches
                table.remove(aura_env.hasDebuffTable, k) -- remove the item from the table.
            end
        end
    end

end


--

function()
    ------------------OPTIONS----------------------
    --- Min/Max distance is for changing the color to red.
    local minDistance = 0-- 0 for no min.
    local maxDistance = 0 -- 0 for no max.
    --------------------------------------------------


    local nearestPlayerID = aura_env.NearestPlayer()
    local returnString = ""

    if nearestPlayerID == nil then
        nearestPlayerID = "player"
    end

    if  aura_env.wrathOnMe then

        local _, _, _, wrathCount = UnitDebuff("player", "Wrath of Gul'dan") -- get wrath stacks
        local _, _, _, grippingCount = UnitDebuff(nearestPlayerID, "Gripping Shadows")  -- get gripping stacks


        local name = UnitName(nearestPlayerID) -- get name of nearest player
        local coloredName = aura_env.setClassColor(name) -- class color the names

        local distanceBetween = aura_env.DistanceBetweenUnits("player", nearestPlayerID) -- check the distance between you and the nearest player

        -- color distance based on min/max
        if (distanceBetween <= minDistance and minDistance ~= 0) or (distanceBetween >= maxDistance and maxDistance ~= 0) then
            distanceBetween = "|cFFFF0001" .. ("%.02f"):format(distanceBetween) .. "|r yds"
        else
            distanceBetween = "|cFFFFFFFF" .. ("%.02f"):format(distanceBetween) .. "|r yds"
        end

        -- SQUASHING STOOPID BUGS, BAD BUGS
        if wrathCount == nil then  wrathCount = 0 end
        if distanceBetween == nil then distanceBetween = 0 end
        if grippingCount == nil then grippingCount = 0 end
        --

        returnString = string.format("Wrath: %s - %s: %s - %s", wrathCount, coloredName, grippingCount, distanceBetween )
        --return "Wrath: Count - NearestPlayer: GripCount - Distance"

    elseif not aura_env.wrathOnMe then
        -- inital variables
        local name = ""
        local coloredName  = ""
        local _, _, _, wrathCount = ""
        local  distanceBetween = ""


        for k,v in pairs(aura_env.hasDebuffTable) do
            name = UnitName(v) -- get player name
            coloredName = aura_env.setClassColor(name) -- class color the names
            _, _, _, wrathCount = UnitDebuff(v, "Wrath of Gul'dan") --  get wrath stacks
            distanceBetween = aura_env.DistanceBetweenUnits("player", v) -- check the distance between you and the debuffed player

            -- color distance based on min/max
            if (distanceBetween <= minDistance and minDistance ~= 0) or (distanceBetween >= maxDistance and maxDistance ~= 0) then
                distanceBetween = "|cFFFF0001" .. ("%.02f"):format(distanceBetween) .. "|r yds"
            else
                distanceBetween = "|cFFFFFFFF" .. ("%.02f"):format(distanceBetween) .. "|r yds"
            end

            -- SQUASHING STOOPID BUGS, BAD BUGS
            if wrathCount == nil then  wrathCount = 0 end
            if distanceBetween == nil then distanceBetween = 0 end
            --

            returnString = returnString .. string.format("%s: %s - %s\\",  coloredName, wrathCount, distanceBetween)
            --return "Name: Stack - Distance"
        end

    end

    if WeakAuras.IsOptionsOpen() then
        return "Name: Stack - Distance"
    end

    return returnString

end


-- ini

aura_env.playerName  = UnitName("player")
aura_env.wrathOnMe = false
aura_env.hasDebuffTable = {}



-------------------------------
--setClassColor(playerName) - returns the player name coloered with theri class color.  Player name must be exact name.
aura_env.setClassColor = function(playerName) -- local function to determine the player class and color it
    local  _, playerClass = UnitClass(playerName) -- Determines the player class
    if playerClass == "DEATHKNIGHT" then
        return "|cFFC41F3B" .. playerName .. "|r" -- Place color tags based on class colors on http://www.wowwiki.com/Class_colors
    elseif playerClass == "DRUID" then
        return "|cFFFF7D0A" .. playerName .. "|r"
    elseif playerClass == "HUNTER" then
        return "|cFFABD473" .. playerName .. "|r"
    elseif playerClass == "MAGE" then
        return "|cFF69CCF0" .. playerName .. "|r"
    elseif playerClass == "MONK" then
        return "|cFF00FF96" .. playerName .. "|r"
    elseif playerClass == "PALADIN" then
        return "|cFFF58CBA" .. playerName .. "|r"
    elseif playerClass == "PRIEST" then
        return "|cFFFFFFFF" .. playerName .. "|r"
    elseif playerClass == "ROGUE" then
        return "|cFFFFF569" .. playerName .. "|r"
    elseif playerClass == "SHAMAN" then
        return "|cFF0070DE" .. playerName .. "|r"
    elseif playerClass == "WARLOCK" then
        return "|cFF9482C9" .. playerName .. "|r"
    elseif playerClass == "WARRIOR" then
        return "|cFFC79C6E" .. playerName .. "|r"
    else
        return "|cFFF900FF" .. playerName .. "|r"
    end
end

---------------------------


-- DistanceBetweenUnits('raid3', 'player') - Get the distance (in yards) between the player and the third raid member.
-- DistanceBetweenUnits('raid3') - Same as above (default unit is 'player').
-- DistanceBetweenUnits('raid19, 'party4') - Distance between raid member nineteen and player's party member four.
-- [@unitA] string - (Optional) Friendly unit A to check.  Defaults to 'player'.
-- [@unitB] string - (Optional) Friendly unit B to check.  Defaults to 'player'.
-- return number - Distance (in yards) between both units.
aura_env.DistanceBetweenUnits = function(unitA, unitB)
    unitA = unitA or 'player'
    unitB = unitB or 'player'
    local ax, ay = UnitPosition(unitA)
    local bx, by = UnitPosition(unitB)
    if ax and bx then
        local dx = ax - bx
        local dy = ay - by
        return (dx * dx + dy * dy) ^ 0.5
    end
    return nil
end

------------------------------------------------------

-- NearestPlayer() - Get the unitId of the nearest player in party/raid
-- return string - UnitId string of nearest player OR nil if invalid
aura_env.NearestPlayer = function()
    local numPlayers = GetNumGroupMembers()
    if numPlayers == 0 then return nil end
    local DistanceToUnit = function(unit)
        local distanceSquared = UnitDistanceSquared(unit)
        if distanceSquared then return distanceSquared  ^ 0.5 end
        return nil
    end
    local distance, nearestUnit, nearestDistance
    for i = 1, numPlayers do
        local unitId = IsInRaid() and "raid"..i or "party"..i
        distance = DistanceToUnit(unitId)
        if UnitExists(unitId) and not UnitIsUnit(unitId, 'player') and not UnitIsDeadOrGhost(unitId) then
            if nearestUnit then
                -- Shorter
                if distance < nearestDistance then
                    nearestUnit = unitId
                    nearestDistance = distance
                end
            else
                nearestUnit = unitId
                nearestDistance = distance
            end
        end
    end
    return nearestUnit
end
--------------------------------------------------------------------








































",
