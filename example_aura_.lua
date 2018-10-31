(


function(allstates, event, unit, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID = ...
        if subEvent == "SPELL_AURA_APPLIED" and spellID == 268074 and destName == WeakAuras.me then
            aura_env.guids[sourceGUID] = true
            for i = 1, 255 do
                local u = "nameplate" .. i
                if UnitExists(u) then
                    if UnitGUID(u) == sourceGUID then
                        allstates[sourceGUID] = {
                            show = true,
                            changed = true,
                            PassUnit = u,
                            progressType = "static",
                        }
                    end
                end
            end
        end
        if subEvent == "SPELL_AURA_REMOVED" and spellID == 268074 and destName == WeakAuras.me then
            if allstates[sourceGUID] then
                allstates[sourceGUID].show = false
                allstates[sourceGUID].changed = true
            end
            if aura_env.guids[sourceGUID] then
                aura_env.guids[sourceGUID] = nil
            end
        end
    end
    if event == "NAME_PLATE_UNIT_REMOVED" then
        if unit then
            if allstates[UnitGUID(unit)] then
                allstates[UnitGUID(unit)].changed = true
                allstates[UnitGUID(unit)].PassUnit = "none"
            end
        end
    end
    if event == "NAME_PLATE_UNIT_ADDED" then
        if unit and unit ~= "target" then
            if aura_env.guids[UnitGUID(unit)] then
                allstates[UnitGUID(unit)] = {
                    show = true,
                    changed = true,
                    PassUnit = unit,
                    progressType = "static",
                }
            end
        end
    end
    return true
end



)()