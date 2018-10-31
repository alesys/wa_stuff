
-- 2 triggers: 262313, 262314 -- action: OnShow

local name = GetUnitName ( WeakAuras.CurrentUnit )
local spell = 262313
local _, _, count = WA_GetUnitDebuff ( WeakAuras.CurrentUnit, spell, "HARMFUL" )

if count == 2 then
  SendChatMessage ("[2 Stacks!] Cabron, ponte algo y usa la Healthstone o HealingPot!", "WHISPER", nil, name)
elseif count >= 3 then
  SendChatMessage ("[".. count .." Stacks] ALV! Si no tienes inmunidad estas bien DED")
end

-- Actions: OnShow

local name = GetUnitName ( WeakAuras.CurrentUnit )
local spells = { 262313, 262314 }

for i, spell in ipairs (spells) do
    local _,_,count = WA_GetUnitDebuff ( WeakAuras.CurrentUnit, spell, "HARMFUL" )
    if count == 2 then
      SendChatMessage ("[2 Stacks!] Cabron, ponte algo y usa la Healthstone o HealingPot!", "WHISPER", nil, name)
      SendChatMessage (name.." la cagó, trae " .. count .. " stacks!", "YELL")
    elseif count >= 3 then
      SendChatMessage ("[".. count .." Stacks] ALV! Si no tienes inmunidad estas bien DED")
      SendChatMessage (name.." está bien DED, trae " .. count .. " stacks!", "YELL")
    end
end

-- Mudarlo a un evento UNIT_AURA en una nueva WeakAuras o en la misma con un custom trigger.. no, mejor en uno nuevo... en el del titulo
-- COMBAT_LOG_EVENT_UNFILTERED, UNIT_DIED, UNIT_AURA
-- checar los vivos
(

function (displays, mainevent, _, subEvent, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID)
  if (mainevent == "UNIT_AURA") then
    local spells = { 262313, 262314 }
    for i, spell in ipairs (spells) do
      if (spellID == spell) then
        local _, _, count = WA_GetUnitDebuff(destGUID, spell, "HARMFUL")
        if count == 2 then
          SendChatMessage ("[2 Stacks!] Cabron, ponte algo y usa la Healthstone o HealingPot!", "WHISPER", nil, name)
          SendChatMessage (name.." la cagó, trae " .. count .. " stacks!", "YELL")
        elseif count >=3 then
          SendChatMessage ("[".. count .." Stacks] ALV! Si no tienes inmunidad estas bien DED")
          SendChatMessage (name.." está bien DED, trae " .. count .. " stacks!", "YELL")
        end
      end
    end
  end
end

)


(
-- si fuera COMBAT_LOG_EVENT_UNFILTERED
function (displays, mainevent, _, subEvent, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID)
  if (subEvent == "UNIT_AURA") then
    local spells = { 262313, 262314 }
    for i, spell in ipairs (spells) do
      if (spellID == spell) then
        local _, _, count = WA_GetUnitDebuff(destGUID, spell, "HARMFUL")
        if count == 2 then
          SendChatMessage ("[2 Stacks!] Cabron, ponte algo y usa la Healthstone o HealingPot!", "WHISPER", nil, name)
          SendChatMessage (name.." la cagó, trae " .. count .. " stacks!", "YELL")
        elseif count >=3 then
          SendChatMessage ("[".. count .." Stacks] ALV! Si no tienes inmunidad estas bien DED")
          SendChatMessage (name.." está bien DED, trae " .. count .. " stacks!", "YELL")
        end
      end
    end
  end
end

)

-- events: COMBAT_LOG_EVENT_UNFILTERED, ENCOUNTER_START, ENCOUNTER_END

(

function (displays, mainevent, _, subEvent, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID)
  if ( mainevent == "ENCOUNTER_START") then
    aura_env.buffer = {}
    aura_env.deaths = 0;
    aura_env.deaths_limit = 3;
  elseif mainevent == "ENCOUNTER_END" then
    SendChatMessage('Fails Resume:')
    for k,v in pairs(aura_env.buffer) do
        SendChatMessage(k .. "[".. v .."]")
    end
  elseif ( mainevent == "COMBAT_LOG_EVENT_UNFILTERED" ) then
    if ( subEvent == "UNIT_DIED" ) then
      aura_env.deaths = aura_env.deaths + 1;
    elseif ( subEvent == "SPELL_AURA_APPLIED_DOSE" or subEvent == "SPELL_AURA_APPLIED" ) and aura_env.deaths < aura_env.deaths_limit then -- aura applied
      local spells = { 262313, 262314 }
      for i, spell in ipairs (spells) do
        if ( spellID == spell ) then
          local _, _, count = WA_GetUnitDebuff(destGUID, spell, "HARMFUL")
          if count == 2 then
            SendChatMessage ("[2 Stacks!] Cabron, ponte algo y usa la Healthstone o HealingPot!", "WHISPER", nil, destName)
            SendChatMessage (destName.." la cagó, trae " .. count .. " stacks!", "YELL")
          elseif count >=3 then
            SendChatMessage ("[".. count .." Stacks] ALV! Si no tienes inmunidad estas bien DED", "WHISPER", nil, destName)
            SendChatMessage (destName.." está bien DED, trae " .. count .. " stacks!", "YELL")
          end
          if count >= 2 then
            if not aura_env.buffer[destName] then aura_env.buffer[destName] = 0 end
            aura_env.buffer[destName] = aura_env.buffer[destName] + 1
          end
        end
      end
    end
  end
end



)