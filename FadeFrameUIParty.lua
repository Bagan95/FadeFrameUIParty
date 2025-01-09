-- FadeFrameUIParty.lua
local f = CreateFrame("Frame")

-- Function to update opacity based on each party member's health and debuffs
local function UpdateIndividualPartyFrameOpacity()
    -- Iterate through all party members
    for i = 1, GetNumPartyMembers() do
        local unit = "party" .. i
        local health = UnitHealth(unit)
        local maxHealth = UnitHealthMax(unit)

        -- Check if the unit has any debuffs
        local hasDebuff = false
        for j = 1, 40 do
            local debuffName = UnitDebuff(unit, j)
            if debuffName then
                hasDebuff = true
                break
            end
        end
        
        -- Determine the target opacity
        local targetOpacity
        if health < maxHealth * 0.8 then
            targetOpacity = 1.0 -- full opacity if health is below 80%
        elseif not hasDebuff then
            targetOpacity = 0.2 -- 20% opacity if no debuff
        else
            targetOpacity = 1.0 -- full opacity if health is above 80% and debuff exists
        end

        -- Get the party frame
        local frame = _G["PartyMemberFrame" .. i]
        if frame then
            -- If opacity is going to 100% (instant fade-in)
            if targetOpacity == 1.0 then
                frame:SetAlpha(1.0)
            else
                -- Fade out smoothly to 20% opacity
                UIFrameFadeOut(frame, 0.5, frame:GetAlpha(), targetOpacity)
            end
        end
    end
end

-- Event handler to trigger the function on health updates and aura changes
f:RegisterEvent("UNIT_HEALTH")
f:RegisterEvent("UNIT_MAXHEALTH")
f:RegisterEvent("PARTY_MEMBER_ENABLE")
f:RegisterEvent("PARTY_MEMBER_DISABLE")
f:RegisterEvent("UNIT_AURA")  -- Listen for debuff/buff changes
f:SetScript("OnEvent", UpdateIndividualPartyFrameOpacity)

-- Initial update when the addon is loaded
UpdateIndividualPartyFrameOpacity()
