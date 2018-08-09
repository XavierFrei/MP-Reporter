MPR_Dispels = CreateFrame("Frame", "MPR Dispels", UIParent)
MPR_Dispels.Loaded = false

local lines = {}
local texts = {}
local buttons = {}
local NUM_LINES = 12
local BUTTON_HEIGHT = 14

function MPR_Dispels:Initialize()
    MPR_Dispels:Hide()
    MPR_Dispels.name = "MPR_Dispels"
    MPR_Dispels:SetBackdrop(MPR.Settings["BACKDROP"])
    MPR_Dispels:SetBackdropColor(unpack(MPR.Settings["BACKDROPCOLOR"]))
    MPR_Dispels:SetBackdropBorderColor(MPR.Settings["BACKDROPBORDERCOLOR"].R/255, MPR.Settings["BACKDROPBORDERCOLOR"].G/255, MPR.Settings["BACKDROPBORDERCOLOR"].B/255)
    MPR_Dispels:SetPoint("CENTER",UIParent)
    MPR_Dispels:EnableMouse(true)
    MPR_Dispels:SetMovable(true)
    MPR_Dispels:RegisterForDrag("LeftButton")
    MPR_Dispels:SetUserPlaced(true)
    MPR_Dispels:SetScript("OnDragStart", function(self) MPR_Dispels:StartMoving() end)
    MPR_Dispels:SetScript("OnDragStop", function(self) MPR_Dispels:StopMovingOrSizing() end)
    MPR_Dispels:SetFrameStrata("FULLSCREEN_DIALOG")

    MPR_Dispels:SetWidth(270)
    MPR_Dispels:SetHeight(238)

    MPR_Dispels.Title = MPR_Dispels:CreateFontString(nil, "OVERLAY", "GameTooltipText")
    MPR_Dispels.Title:SetPoint("TOP", 0, -8)
    MPR_Dispels.Title:SetTextColor(190/255, 190/255, 190/255)
    MPR_Dispels.Title:SetText("|cff"..MPR.Colors["TITLE"].."MP Reporter|r - Ignore Dispels")
    MPR_Dispels.Title:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    MPR_Dispels.Title:SetShadowOffset(1, -1)

    CloseButton = CreateFrame("button", "BtnClose", MPR_Dispels, "UIPanelButtonTemplate")
    CloseButton:SetHeight(BUTTON_HEIGHT)
    CloseButton:SetWidth(14)
    CloseButton:SetPoint("TOPRIGHT", -8, -8)
    CloseButton:SetText("x")
    CloseButton:SetScript("OnClick", function(self)
        MPR_Dispels.FrameNumber = nil
        MPR_Dispels:Hide()
        BtnToggleIgnoreDispels:SetText("Show")
    end)

    MPR_Dispels.ScrollFrame = CreateFrame("ScrollFrame", "ListSpellsScrollFrame", MPR_Dispels, "FauxScrollFrameTemplate")--"UIPanelScrollFrameTemplate")
    MPR_Dispels.ScrollFrame:SetHeight(NUM_LINES * BUTTON_HEIGHT)
    MPR_Dispels.ScrollFrame:SetPoint("TOPLEFT",35,-30)
    MPR_Dispels.ScrollFrame:SetPoint("BOTTOMRIGHT",-32,40)
    MPR_Dispels.ScrollFrame:SetScript("OnVerticalScroll", function(self, offset)
        -- Need to call the function twice or the offsets won't correct for some reason
        FauxScrollFrame_OnVerticalScroll(self, offset, BUTTON_HEIGHT, MPR_Dispels:UpdateScrollFrame(self))
        FauxScrollFrame_OnVerticalScroll(self, offset, BUTTON_HEIGHT, MPR_Dispels:UpdateScrollFrame(self))
    end)

    for i = 1, NUM_LINES do
        local line = CreateFrame("Frame", "line"..i, MPR_Dispels.ScrollFrame:GetParent())
        if i == 1 then
            line:SetPoint("TOP", MPR_Dispels.ScrollFrame)
        else
            line:SetPoint("TOP",lines[i-1],"BOTTOM")
        end
        line:SetHeight(BUTTON_HEIGHT)
        line:SetWidth(MPR_Dispels:GetWidth()-20)
        local spellText = CreateFrame("SimpleHTML", "spellText"..i, line);
        spellText:SetJustifyV("TOP")
        spellText:SetPoint("LEFT",0,0)
        spellText:SetHeight(BUTTON_HEIGHT)
        spellText:SetWidth(MPR_Dispels:GetWidth()-100)
        spellText:SetTextColor(255/255, 255/255, 255/255)
        spellText:SetFont("Fonts\\FRIZQT__.TTF", 11, nil)
        spellText:SetText(MPR.Settings["IGNOREDISPELS"][i])

        local removeButton = CreateFrame("Button","removeBtn"..i, line, "UIPanelButtonTemplate")
        removeButton:SetHeight(BUTTON_HEIGHT)
        removeButton:SetWidth(14)
        removeButton:SetPoint("RIGHT",-5,0)
        removeButton:SetText("x")
        removeButton:SetScript("OnClick", function(self)
            MPR_Dispels:RemoveSpell(MPR.Settings["IGNOREDISPELS"][i])
        end)
        texts[i] = spellText
        buttons[i] = removeButton
        lines[i] = line
    end

    MPR_Dispels.EB_ADDSPELL = CreateFrame("EditBox", "AddSpellEditBox", MPR_Dispels, "InputBoxTemplate")
    MPR_Dispels.EB_ADDSPELL:SetPoint("BOTTOMLEFT",16,16)
    MPR_Dispels.EB_ADDSPELL:SetAutoFocus(false)
    MPR_Dispels.EB_ADDSPELL:SetHeight(18)
    MPR_Dispels.EB_ADDSPELL:SetWidth(170)
    MPR_Dispels.EB_ADDSPELL:SetMaxLetters(20)

    MPR_Dispels.BTN_ADDSPELL = CreateFrame("button","BtnAddSpell", MPR_Dispels, "UIPanelButtonTemplate")
    MPR_Dispels.BTN_ADDSPELL:SetHeight(18)
    MPR_Dispels.BTN_ADDSPELL:SetWidth(70)
    MPR_Dispels.BTN_ADDSPELL:SetPoint("BOTTOMRIGHT", -12, 16)
    MPR_Dispels.BTN_ADDSPELL:SetText("Add Spell")
    MPR_Dispels.BTN_ADDSPELL:SetScript("OnClick", function(self)
        MPR_Dispels:AddSpell(MPR_Dispels.EB_ADDSPELL:GetText())
        MPR_Dispels.EB_ADDSPELL:ClearFocus()
        MPR_Dispels.EB_ADDSPELL:SetText("")
    end)

    MPR_Dispels.Loaded = true
end

function MPR_Dispels:AddSpell(spell)
    MPR.Settings["IGNOREDISPELS"][#MPR.Settings["IGNOREDISPELS"]+1] = spell
    MPR_Dispels:UpdateScrollFrame(MPR_Dispels.ScrollFrame)
    MPR:SelfReport("Added <" .. MPR_Dispels.EB_ADDSPELL:GetText() .. "> to Ignore Dispel List")
end

function MPR_Dispels:RemoveSpell(spell)
    for i,v in pairs(MPR.Settings["IGNOREDISPELS"]) do
        if v == spell then
            table.remove(MPR.Settings["IGNOREDISPELS"],i)
            MPR_Dispels:UpdateScrollFrame(MPR_Dispels.ScrollFrame)
            MPR:SelfReport("Removed <" .. spell .. "> from Ignore Dispel List")
            break
        end
    end
end

function MPR_Dispels:UpdateScrollFrame(self)
    local numItems = #MPR.Settings["IGNOREDISPELS"]
    FauxScrollFrame_Update(self, numItems, NUM_LINES, BUTTON_HEIGHT)
    local offset = FauxScrollFrame_GetOffset(self)
    for line = 1, NUM_LINES do
        local lineplusoffset = line + offset
        local entry = lines[line]
        local text = texts[line]
        local rmButton = buttons[line]
        if lineplusoffset > numItems then
            entry:Hide()
        else
            text:SetText(MPR.Settings["IGNOREDISPELS"][lineplusoffset])
            rmButton:SetScript("OnClick", function(self)
                MPR_Dispels:RemoveSpell(MPR.Settings["IGNOREDISPELS"][lineplusoffset])
            end)
            if numItems > 12 then
                rmButton:SetPoint("RIGHT",-25,0)
            else
                rmButton:SetPoint("RIGHT",-5,0)
            end
            entry:Show()
        end
    end
end

function MPR_Dispels:Toggle()
    if MPR_Dispels:IsVisible() then
        MPR_Dispels:Hide()
    else
        MPR_Dispels:Show()
        MPR_Dispels:UpdateScrollFrame(MPR_Dispels.ScrollFrame)
    end
end
