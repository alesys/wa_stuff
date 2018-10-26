-- Trigger
function(event, _, message, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId)
    if message == "SPELL_AURA_APPLIED" and spellId == 230139 then
        local t = GetTime()
        if t-aura_env.prev > 5 then
            wipe(aura_env.shots)
            wipe(aura_env.soaker)
            aura_env.myPos = nil
            aura_env.prev = t
        end


        aura_env.shots[#aura_env.shots+1] = destName

        if #aura_env.shots == aura_env.getNumberOfShotsForDifficulty() then
            WeakAuras.ScanEvents('WA_SdP_HydraShot')
        end
    end
    if event == "WA_SdP_HydraShot" then
        local _, _, _, instanceId = _G["Unit".."Position"]("player")

        aura_env.myPos = nil
        for i=1,30 do
            local unit = ("raid%d"):format(i)
            local _, _, _, tarInstanceId = _G["Unit".."Position"](unit)

            if tarInstanceId == instanceId
            and UnitIsConnected(unit)
            and not GetPartyAssignment("MAINTANK", unit)
            and UnitGroupRolesAssigned(unit) ~= "TANK"
            and not UnitDebuff(unit, aura_env.buff)
            and not UnitDebuff(unit, aura_env.debuff)
            and not UnitIsDead(unit) then
                local pos = (#aura_env.soaker+1)%aura_env.getNumberOfShotsForDifficulty() + 1
                aura_env.soaker[#aura_env.soaker+1] = {name = UnitName(unit), pos = pos}

                if UnitIsUnit(unit, "player") then
                    aura_env.myPos = pos
                end
            end
        end

        WeakAuras.ScanEvents('WA_SdP_HydraList', aura_env.shots, aura_env.soaker)

        if aura_env.myPos then
            PlaySoundFile(("interface/sounds/soak_rt%d.ogg"):format(aura_env.myPos), "MASTER")
            return true
        end
    end
end

-- text

function()
    local t = aura_env.getIconTexture(aura_env.myPos)
    local color = aura_env.getColor(aura_env.myPos)
    return aura_env.myPos and (t .. color .. "SOAK" .. t) or "don't soak"
end


-- action


aura_env.getIconTexture = function (n)
    return ("|TInterface\\\\TARGETINGFRAME\\\\UI-RaidTargetingIcon_%d.png:0|t"):format(n or 1)
end

aura_env.getColor = function(n)
    return
    n == 1 and "|cffffff00" or
    n == 2 and "|cffffaa00" or
    n == 3 and "|cffee00ee" or
    n == 4 and "|cff00ff00" or
    "|cffffffff"
end

aura_env.debugPrint = function(t)
    local p = {}
    for _,v in pairs(t) do
        p[v.pos] = (p[v.pos] or v.pos) .. " - " .. v.name
    end
    for _,v in ipairs(p) do
        print(v)
    end
end

aura_env.getNumberOfShotsForDifficulty = function()
    local _, _, diff = GetInstanceInfo()
    return diff == 15 and 3 or 4 -- Heroic: 3, Mythic: 4
end

aura_env.prev = 0

aura_env.shots = {}
aura_env.soaker = {}
aura_env.myPos = 8

aura_env.buff = GetSpellInfo(239362)
aura_env.debuff = GetSpellInfo(230139)
