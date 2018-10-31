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
    local events = {combatlog = "COMBAT_LOG_EVENT_UNFILTERED", on_start = "ENCOUNTER_START", on_end = "ENCOUNTER_END"}
    local spell = 265370 --
    --spell = 8936 -- test
    --print(aura_env.output)
    if (mainevent == events.combatlog) then
        if (spellID == spell and destName ~= nil) then
            --SendChatMessage("Subiste el stack a "..count,"WHISPER",nil,sourceName)
            print (destName)
            SendChatMessage("Cagaste el baile " .. destName, "WHISPER", nil, destName)
            aura_env.blood_geyser_counter = aura_env.blood_geyser_counter + 1
            aura_env.output = "Blood Geyser Count: " .. aura_env.blood_geyser_counter
        end
    end

    if (mainevent == events.on_start) then
        aura_env.blood_geyser = {}
        aura_env.blood_geyser_counter = 0
        print ("blood_geyser initialized")
    end

    if (mainevent == events.on_end) then
        print ("blood_geyser ended")
    end
    return true
end



)()



