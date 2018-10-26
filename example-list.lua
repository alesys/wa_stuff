function()
    local out = "|cffff9636Consuming Hunger|r\n"
    local has_any = false

    if (WeakAuras.IsOptionsOpen()) then
        return out.."TestPlayer1\nTestPlayer2\nTestPlayer3"
    end

    -- Local vars for aura_env values, as to conserve space
    local dn = aura_env.desired_n
    local sp = aura_env.spell_name

    local n = GetNumGroupMembers()
    if (n < dn) then -- not sure how the above call returns with a raid that has people outside
        return ""
    end

    for i = 1,dn do
        local has_aura = UnitAura("raid"..i, sp)
        if (has_aura) then
            has_any = true
            out = out .. UnitName("raid"..i) .. "\n"
        end
    end

    if (has_any) then
        return out
    else
        return ""
    end
end

















",
