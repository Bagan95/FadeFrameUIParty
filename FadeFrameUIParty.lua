-- FadeFrameUIParty.lua
local f = CreateFrame("Frame")

-- Function to update opacity based on each party member's health
local function UpdateIndividualPartyFrameOpacity()
    -- Iterate through all party members
    for i = 1, GetNumPartyMembers() do
        local unit = "party" .. i
        local health = UnitHealth(unit)
        local maxHealth = UnitHealthMax(unit)
        
        -- Determine the target opacity based on the health threshold (80% of max health)
        local targetOpacity = (health < maxHealth * 0.8) and 1.0 or 0.2

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

-- Event handler to trigger the function on health updates
f:RegisterEvent("UNIT_HEALTH")
f:RegisterEvent("UNIT_MAXHEALTH")
f:RegisterEvent("PARTY_MEMBER_ENABLE")
f:RegisterEvent("PARTY_MEMBER_DISABLE")
f:SetScript("OnEvent", UpdateIndividualPartyFrameOpacity)

-- Initial update when the addon is loaded
UpdateIndividualPartyFrameOpacity()
