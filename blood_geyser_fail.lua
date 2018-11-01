-- output
(

function ()
    local output = ""
    output = aura_env.output
    if ( aura_env.output == nil or aura_env.output == "") then
        output = "nada"
    end
    return output
end

)()
--
(


function (displays, mainevent, _, subEvent, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID)
    --aura_env.output = mainevent .. " " .. sourceName .. "\n" .. destName
    --SendChatMessage(mainevent)
    --  COMBAT_LOG_EVENT_UNFILTERED, ENCOUNTER_START, ENCOUNTER_END
    local events = {combatlog = "COMBAT_LOG_EVENT_UNFILTERED", on_start = "ENCOUNTER_START", on_end = "ENCOUNTER_END", died = "UNIT_DIED"}
    local spell = 265370 --
    local newline = "\n"
    --spell = 8936 -- test
    --print(aura_env.output)
    if mainevent == events.combatlog then
        if spellID == spell and destName ~= nil then
            --SendChatMessage("Subiste el stack a "..count,"WHISPER",nil,sourceName)
            print (destName)
            SendChatMessage("Cagaste el baile " .. destName, "WHISPER", nil, destName)
            aura_env.blood_geyser_counter = aura_env.blood_geyser_counter + 1
            aura_env.output = "Blood Geyser Count: " .. aura_env.blood_geyser_counter .. newline .. "--------" .. newline

            if not aura_env.blood_geyser_buffer[destName] then aura_env.blood_geyser_buffer[destName] = 0 end
            aura_env.blood_geyser_buffer[destName] = aura_env.blood_geyser_buffer[destName] + 1

--[[
            -- table.sort(aura_env)

            local keys = {}
            for k,v in pairs(aura_env.blood_geyser_buffer) do
                table.insert(keys, k)
            end
            table.sort(keys)
            for i,k in ipairs(keys) do
                aura_env.output = aura_env.output .. k .. "[".. aura_env.blood_geyser_buffer[k] .. "]" .. newline
            end
--]]
            -- sort 2
            local offenders = {}
            for k,v in pairs(aura_env.blood_geyser_buffer) do
                table.insert(offenders, {name = k, count = v})
            end
            table.sort(offenders, function(a, b) return a.count < b.count end)
            for i,offender in ipairs(offenders) do
                aura_env.output = aura_env.output .. offender.name .. "[".. offender.count .."]" .. newline
            end
            aura_env.offenders = offenders
        end
        if subEvent == events.died then
            aura_env.blood_geyser_deaths = aura_env.blood_geyser_deaths + 1
        end
    end



    if mainevent == events.on_start then
        aura_env.blood_geyser = {}
        aura_env.blood_geyser_buffer = {}
        aura_env.blood_geyser_counter = 0
        aura_env.blood_geyser_max_deaths = 3
        aura_env.blood_geyser_deaths = 0
        print ("blood_geyser initialized")
    end

    if (mainevent == events.on_end) then
        print ("blood_geyser ended")
        local keys = {}
        local delay = 0.1
        -- for k,v in pairs(aura_env.blood_geyser_buffer) do
        --     table.insert(keys, k)
        -- end
        -- table.sort(keys)
        -- for i,k in ipairs(keys) do
        --     C_Timer.After(delay, function () SendChatMessage(k .. "[" .. aura_env.blood_geyser_buffer[k] .. "]") end )
        --     delay = delay + 0.1
        -- end
        if aura_env.offenders then
            for i,offender in ipairs(aura_env.offenders) do
                C_Timer.After(delay, function () SendChatMessage(offender.name .. "["..offender.count.."]") end)
                delay = delay + 0.1
            end
        end
    end

    return true
end



)()
