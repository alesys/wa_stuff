
-- custom action Lunar Beacon
local name = GetUnitName(WeakAuras.CurrentUnit)
SendChatMessage("Lunar Beacon! Andate a una esquina!", "WHISPER", nil, name)

-- todo: Un WA para ver los weyes que tienen MoonBurn como barra de tiempo

-- COMBAT_LOG_EVENT_UNFILTERED ENCOUNTER_START ENCOUNTER_END
(
function (displays, mainevent, _, subEvent, _, sourceGUID, sourceName, _, _, destGUID, _, _, _, spellID)
  local findSpellID = 23633
  local limit = 6
  if mainevent == "ENCOUNTER_START" then
    purge_history = {}
  end
  if mainevent == "ENCOUNTER_END" then
    SendChatMessage("--// Purge Fail Count History //--", "RAID")
    for i,purge_history_item in ipairs(purge_history) do
      if purge_history_item["count"] >= limit then
        SendChatMessage("--//".. purge_history_item["text"], "RAID")
      end
    end
  end
  if mainevent == "COMBAT_LOG_EVENT_UNFILTERED" and subEvent:find("SPELL_CAST_SUCCESS") and destGUID == sourceGUID and spellID == findSpellID then
      local _, _, _, count = UnitDebuff(sourceName, "Astral Vulnerability")
      local output = sourceName.. " ("..count..") "
      if count >= limit then
          SendChatMessage("Subiste la purga a "..count.." stacks", "WHISPER", nil, sourceName)
          print("** "..output)
        else
          print(output)
      end
      -- Record history
      if count == 1 then
        purge_history = purge_history or {}
        tinsert(purge_history, {count=0, text=""})
      end
      local index = table.maxn(purge_history)
      purge_history[index]["count"] = purge_history[index]["count"] + 1
      purge_history[index]["text"] = purge_history[index]["text"] .. output
  end
end
)

-- COMBAT_LOG_EVENT_UNFILTERED, ENCOUNTER_START, ENCOUNTER_END
     (
function(displays, mainevent, _, subEvent, _, sourceGUID, sourceName, _, _, destGUID, _, _, _, spellID)
    if subEvent:find("SPELL_CAST_SUCCESS") and destGUID == sourceGUID and spellID == 236330 then
        local duration = 10 --in seconds. change to modify the duration of time before fade
        local maxDisplays = 3 --# of names that will be shown at maximum. 0 causes it to be unlimited. I recommend keeping it limited if you do not autoHide.
        local name, _, _, count = UnitDebuff(sourceName, "Astral Vulnerability")
        local output = sourceName.." ("..count..") "
        print(output)
        WeakAurasSaved['purges_story'] = purge_counter.. ", ".. output
        if count > 5 then
            SendChatMessage("Cuidado, pusiste la purga: "..count, "WHISPER", nil, sourceName)
        end

        tinsert(displays,1, {
                name = WrapTextInColorCode(sourceName,color),
                --delete following 4 lines if you don't want to autohide
                duration = duration,
                expirationTime = GetTime() + duration,
                autoHide = true,
                progressType = 'timed',
                changed = true,
                show = true
        })
        for i,v in ipairs(displays) do
            v.changed = true
            v.show = maxDisplays == 0 or i <= maxDisplays
        end
        return true
    end
    if mainevent == "ENCOUNTER_START" then
        WeakAurasSaved['purges_story'] = "Purges: "
    end
    if mainevent == "ENCOUNTER_END" then
        print(WeakAurasSaved['purges_story'])
        SendChatMessage("---------------------------------------------", "RAID")
        SendChatMessage(WeakAurasSaved['purges_story']..".", "RAID")
        SendChatMessage("---------------------------------------------", "RAID")
    end
end

    )()
    (
function (displays, mainevent)
    print(mainevent)
    if mainevent == "PLAYER_ENTER_COMBAT" then
        WeakAurasSaved['test_msg'] = "Combate empezo"
        print("lol, combate")
    end
    if mainevent == "PLAYER_LEAVE_COMBAT" then
        WeakAurasSaved['test_msg'] = WeakAurasSaved['test_msg'].."Comate termino"
        print("lol, end")
        print(WeakAurasSaved['test_msg'])
    end
end
)()

(
-- 265370  Blood Geyser id
function (displays, mainevent, _, subEvent, _, sourceGUID, sourceName, _, _, destGUID, _, _, _, spellID)
  local findSpellID = 265370
  local feedback = {
    "Blood Geyser fail!!!",
    "Pecho frio!",
    "Cabrón los putos rayos!",
    "ALV de qué guild te trajimos?"
  }
  if mainevent == "ENCOUNTER_START" then
    aura_env["blood_geyser_counter"] = {}
  end
  if mainevent == "COMBAT_LOG_EVENT_UNFILTERED" and subEvent:find("SPELL_CAST_SUCCESS") and destGUID == sourceGUID and spellID == findSpellID then
    if aura_env["blood_geyser_counter"][sourceName] == nil then aura_env["blood_geyser_counter"][sourceName] = 0 end
    aura_env["blood_geyser_counter"][sourceName] = aura_env["blood_geyser_counter"][sourceName] + 1
    local count = aura_env["blood_geyser_counter"][sourceName]
    local count_output = "[Blood Fail: ".. count .."] " .. feedback[0]
      -- testing
      SendChatMessage("Cagaste " .. sourceName .. "!", "WHISPER", nil, player)
  end
  if mainevent == "ENCOUNTER_END" then
    -- todo: print resume
  end 
end


)