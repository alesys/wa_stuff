
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

for i, spell ipairs (spells) do
    local _,_,count = WA_GetUnitDebuff ( WeakAuras.CurrentUnit, spell, "HARMFUL" )
    if count == 2 then
      SendChatMessage ("[2 Stacks!] Cabron, ponte algo y usa la Healthstone o HealingPot!", "WHISPER", nil, name)
    elseif count >= 3 then
      SendChatMessage ("[".. count .." Stacks] ALV! Si no tienes inmunidad estas bien DED")
    end
    if count >= 2 then
      -- add fail count for the player
    end
end

-- Display, %c

function ()
  return aura_env.output
end

-- 
