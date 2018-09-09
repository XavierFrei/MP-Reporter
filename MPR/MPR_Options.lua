MPR_Options = CreateFrame("Frame", "MPR Options", UIParent);

local framecount = 0
function GetNewID()
    framecount = framecount + 1
    return framecount
end
function GetCurrentID()
    return framecount
end

function MPR_Options:Initialize()
    MPR_Options:Hide()
    MPR_Options.name = "MPR_Options"

    MPR_Options:SetBackdrop(MPR.Settings["BACKDROP"])
    MPR_Options:SetBackdropColor(unpack(MPR.Settings["BACKDROPCOLOR"]))
    MPR_Options:SetBackdropBorderColor(MPR.Settings["BACKDROPBORDERCOLOR"].R/255, MPR.Settings["BACKDROPBORDERCOLOR"].G/255, MPR.Settings["BACKDROPBORDERCOLOR"].B/255)

    MPR_Options:SetPoint("CENTER",UIParent)
    MPR_Options:SetWidth(425)
    MPR_Options:SetHeight(384)
    MPR_Options:EnableMouse(true)
    MPR_Options:SetMovable(true)
    MPR_Options:RegisterForDrag("LeftButton")
    MPR_Options:SetUserPlaced(true)
    MPR_Options:SetScript("OnDragStart", function(self) self:StartMoving() end)
    MPR_Options:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    MPR_Options:SetFrameStrata("FULLSCREEN_DIALOG")

    --[[ MP Reporter - Options ]]--
    MPR_Options.Title = MPR_Options:CreateFontString("Title"..GetNewID(), "ARTWORK", "GameFontNormal")
    MPR_Options.Title:SetPoint("TOP", 0, -12)
    if type(Color) ~= "string" then Color = "FFFFFF" end
    MPR_Options.Title:SetTextColor(tonumber(Color:sub(1,2),16)/255, tonumber(Color:sub(3,4),16)/255, tonumber(Color:sub(5,6),16)/255)
    MPR_Options.Title:SetText("|cFF"..MPR.Colors["TITLE"].."MP Reporter|r ("..MPR.Version..") - Options")
    MPR_Options.Title:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    MPR_Options.Title:SetShadowOffset(1, -1)

    MPR_Options_BtnClose = CreateFrame("button","MPR_Options_BtnClose", MPR_Options, "UIPanelButtonTemplate")
    MPR_Options_BtnClose:SetHeight(14)
    MPR_Options_BtnClose:SetWidth(14)
    MPR_Options_BtnClose:SetPoint("TOPRIGHT", -12, -11)
    MPR_Options_BtnClose:SetText("x")
    MPR_Options_BtnClose:SetScript("OnClick", function(self) MPR_Options:Hide() end)

    --[[ General ]]--
    local line1_offsetY = 14
    local line2_offsetY = 28
    local line3_offsetY = 42
    local general_posY = -30
    local genLine1_posY = general_posY-line1_offsetY
    MPR_Options:NewFS("General","00CCFF",16,general_posY)
    MPR_Options:NewCB("Self",    "1E90FF",    "SELF",16,genLine1_posY)        -- [ ] Self
    MPR_Options:NewCB("Raid",    "EE7600",    "RAID",56,genLine1_posY)        -- [ ] Raid
    MPR_Options:NewCB("Say",     "FFFFFF",    "SAY",100,genLine1_posY)        -- [ ] Say
    MPR_Options:NewCB("Whisper", "DA70D6",    "WHISPER",140,genLine1_posY)    -- [ ] Whisper

    --[[ Reporting ]]--
    local reporting_posY = general_posY-34
    local repLine1_posY = reporting_posY-line1_offsetY
    local repLine2_posY = reporting_posY-line2_offsetY
    local repLine3_posY = reporting_posY-line3_offsetY
    MPR_Options:NewFS("Reporting","20B2AA",16,reporting_posY)
    MPR_Options:NewCB("Dispels",nil,"REPORT_DISPELS",16,repLine1_posY)                              -- [ ] Dispels
    MPR_Options:NewCB("Mass Dispels",nil,"REPORT_MASSDISPELS",100,repLine1_posY)                    -- [ ] Mass Dispels
    local ParryHasteCB = MPR_Options:NewCB("Parry Haste",nil,"REPORT_PARRYHASTE",16,repLine2_posY)    -- [ ] Parry Haste
    ParryHasteCB:SetScript("OnEnter", function(self) MPR_Options:ShowGameTooltip(ParryHasteCB, "Only enabled on Sindragosa and Halion") end)
    ParryHasteCB:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    local TankCDsCB = MPR_Options:NewCB("Tank Cooldowns",nil,"REPORT_TANKCDS",100,repLine2_posY)      -- [ ] Tank Cooldowns
    local TankCDsTable = concatTables(tankCooldownsCast, tankAurasApplied)
    TankCDsCB:SetScript("OnEnter", function(self) MPR_Options:ShowGameTooltip(TankCDsCB, TankCDsTable, "Spells:") end)
    TankCDsCB:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    local OtherSpellsCB = MPR_Options:NewCB("Offensives & Other Spells",nil,"REPORT_OTHERSPELLS",16,repLine3_posY)  -- [ ] Offensives & Other Spells
    local OtherSpellsTable = concatTables(otherSpellsCast, otherSpellsCastOnTarget)
    OtherSpellsCB:SetScript("OnEnter", function(self) MPR_Options:ShowGameTooltip(OtherSpellsCB, OtherSpellsTable, "Spells:") end)
    OtherSpellsCB:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

    MPR_Options:NewFS("Ignore Dispel List","990099",16,repLine3_posY-19)
    BtnToggleIgnoreDispels = CreateFrame("button","BtnToggleIgnoreDispels", MPR_Options, "UIPanelButtonTemplate")
    BtnToggleIgnoreDispels:SetHeight(18)
    BtnToggleIgnoreDispels:SetWidth(60)
    BtnToggleIgnoreDispels:SetPoint("TOPLEFT",135,repLine3_posY-17)
    BtnToggleIgnoreDispels:SetText("Show")
    BtnToggleIgnoreDispels:SetScript("OnShow", function(self) BtnToggleIgnoreDispels:SetText(MPR_Dispels:IsVisible() and "Hide" or "Show") end)
    BtnToggleIgnoreDispels:SetScript("OnClick", function(self)
        if not MPR_Dispels:IsVisible() then
            MPR_Dispels:Show()
            MPR_Dispels:UpdateScrollFrame(MPR_Dispels.ScrollFrame)
            BtnToggleIgnoreDispels:SetText("Hide")
        else
            MPR_Dispels:Hide()
            BtnToggleIgnoreDispels:SetText("Show")
        end
    end)

    --[[ Reporting in ]]--
    local reporting_in_posY = reporting_posY-79
    local reporting_in_line1_posY = reporting_in_posY-line1_offsetY
    local reporting_in_line2_posY = reporting_in_posY-line2_offsetY
    MPR_Options:NewFS("Reporting in","3CB371",16,reporting_in_posY)
    MPR_Options:NewCB("Dungeon",nil,"REPORTIN_PARTY",16,reporting_in_line1_posY)
    MPR_Options:NewCB("Raid Instance",nil,"REPORTIN_RAIDINSTANCE",87,reporting_in_line1_posY)
    MPR_Options:NewCB("Battleground",nil,"REPORTIN_BATTLEGROUND",16,reporting_in_line2_posY)
    MPR_Options:NewCB("Arena",nil,"REPORTIN_ARENA",102,reporting_in_line2_posY)
    MPR_Options:NewCB("Outside",nil,"REPORTIN_OUTSIDE",154,reporting_in_line2_posY)

    --[[ Aura Info ]]--
    local aura_info_posY = reporting_in_posY-50
    local aura_info_line1_offsetY = aura_info_posY-line1_offsetY
    local aura_info_line2_offsetY = aura_info_posY-line2_offsetY
    MPR_Options:NewFS("Aura Info","FF2200",16,aura_info_posY)
    MPR_Options:NewCB("Enable","FFFFFF","AURAINFO",16,aura_info_line1_offsetY)

    BtnToggleAuraInfo = CreateFrame("button","BtnToggleAuraInfo", MPR_Options, "UIPanelButtonTemplate")
    BtnToggleAuraInfo:SetHeight(18)
    BtnToggleAuraInfo:SetWidth(60)
    BtnToggleAuraInfo:SetPoint("TOPLEFT", 16, aura_info_line2_offsetY-2)
    BtnToggleAuraInfo:SetText("Show")
    BtnToggleAuraInfo:SetScript("OnShow", function(self) BtnToggleAuraInfo:SetText(MPR_AuraInfo:IsVisible() and "Hide" or "Show") end)
    BtnToggleAuraInfo:SetScript("OnClick", function(self)
        if not MPR_AuraInfo:IsVisible() then
            MPR_AuraInfo:UpdateFrame()
            BtnToggleAuraInfo:SetText("Hide")
        else
            MPR_AuraInfo:Hide()
            BtnToggleAuraInfo:SetText("Show")
        end
    end)

    -- Frame Update Period slider --
    MPR_Slider = CreateFrame("Slider", "MPR_Slider", MPR_Options, "OptionsSliderTemplate")
    MPR_Slider:SetWidth(120)
    MPR_Slider:SetHeight(20)
    MPR_Slider:SetPoint('TOPLEFT', 84, aura_info_line1_offsetY-3)
    MPR_Slider:SetOrientation('HORIZONTAL')
    MPR_Slider:SetMinMaxValues(0.1, 3)
    MPR_Slider:SetValueStep(0.1)
    MPR_Slider:SetValue(MPR.Settings["UPDATEFREQUENCY"])
    _G[MPR_Slider:GetName().."Low"]:SetText("0.1")
    _G[MPR_Slider:GetName().."High"]:SetText("3")
    _G[MPR_Slider:GetName().."Text"]:SetText("|cFFffffffUpdate Period: "..round(MPR_Slider:GetValue(),1).."s|r")
    MPR_Slider:SetScript("OnValueChanged",function()
        _G[MPR_Slider:GetName()..'Text']:SetText("|cFFffffffUpdate Period: "..round(MPR_Slider:GetValue(),1).."s|r")
        MPR.Settings["UPDATEFREQUENCY"] = round(MPR_Slider:GetValue(),1)
    end)

    --[[ Timers ]]--
    local timers_posY = aura_info_posY-50
    MPR_Options:NewFS("Timers","1E90FF",16,timers_posY)
    MPR_Options:NewCB("Enable","FFFFFF","TIMERS",64,timers_posY+2)
    BtnToggleTimers = CreateFrame("button","BtnToggleTimers", MPR_Options, "UIPanelButtonTemplate")
    BtnToggleTimers:SetWidth(60)
    BtnToggleTimers:SetHeight(18)
    BtnToggleTimers:SetPoint("TOPLEFT", 120, timers_posY+1)
    BtnToggleTimers:SetText("Show")
    BtnToggleTimers:SetScript("OnShow", function(self) BtnToggleTimers:SetText(MPR_Timers:IsVisible() and "Hide" or "Show") end)
    BtnToggleTimers:SetScript("OnClick", function(self)
        MPR_Timers:Toggle()
        BtnToggleTimers:SetText(MPR_Timers:IsVisible() and "Hide" or "Show")
    end)

    --[[ Player Deaths ]]--
    local player_deaths_posY = timers_posY-20
    MPR_Options:NewFS("Player Deaths","22FF00",16,player_deaths_posY)
    MPR_Options:NewCB("Enable",  "FFFFFF",    "PD_REPORT",104,player_deaths_posY+2)        -- [ ] Enable
    local player_deaths_line1_posY = player_deaths_posY-line1_offsetY
    MPR_Options:NewCB("Self",    "1E90FF",    "PD_SELF",16,player_deaths_line1_posY)       -- [ ] Self
    MPR_Options:NewCB("Raid",    "EE7600",    "PD_RAID",56,player_deaths_line1_posY)       -- [ ] Raid
    MPR_Options:NewCB("Whisper", "DA70D6",    "PD_WHISPER",100,player_deaths_line1_posY)   -- [ ] Whisper
    MPR_Options:NewCB("Guild",   "40FF40",    "PD_GUILD",160,player_deaths_line1_posY)     -- [ ] Guild

    --[[ Report Deaths ]]--
    local report_deaths_posY = player_deaths_posY-36
    MPR_Options:NewFS("Report Deaths","FFAA00",16,report_deaths_posY)
    MPR_Options:NewCB("Enable logging","FFFFFF","PD_LOG",108,report_deaths_posY+2)         -- [ ] Enable logging

    -- SELF
    local report_deaths_btn_posY = report_deaths_posY-line1_offsetY
    MPR_Options.CB_Self = CreateFrame("CheckButton", "CB_Self", MPR_Options, "UICheckButtonTemplate")
    MPR_Options.CB_Self:SetWidth(20)
    MPR_Options.CB_Self:SetHeight(20)
    MPR_Options.CB_Self:SetPoint("TOPLEFT", 16, report_deaths_btn_posY)
    _G["CB_SelfText"]:SetText("|cFF1E90FFSelf|r")
    MPR_Options.CB_Self:SetScript("OnShow",  function(self) MPR_Options.CB_Self:SetChecked(MPR.Settings["DEATHREPORT_CHANNEL"] == "Self") end)
    MPR_Options.CB_Self:SetScript("OnClick", function(self)
        MPR_Options.CB_Self:SetChecked(true); MPR_Options.CB_Raid:SetChecked(false); MPR_Options.CB_Guild:SetChecked(false);
        MPR.Settings["DEATHREPORT_CHANNEL"] = "Self"
    end)
    -- RAID
    MPR_Options.CB_Raid = CreateFrame("CheckButton", "CB_Raid", MPR_Options, "UICheckButtonTemplate")
    MPR_Options.CB_Raid:SetWidth(20)
    MPR_Options.CB_Raid:SetHeight(20)
    MPR_Options.CB_Raid:SetPoint("TOPLEFT", 56, report_deaths_btn_posY)
    _G["CB_RaidText"]:SetText("|cFFEE7600Raid|r")
    MPR_Options.CB_Raid:SetScript("OnShow",  function(self) MPR_Options.CB_Raid:SetChecked(MPR.Settings["DEATHREPORT_CHANNEL"] == "Raid") end)
    MPR_Options.CB_Raid:SetScript("OnClick", function(self)
        MPR_Options.CB_Self:SetChecked(false); MPR_Options.CB_Raid:SetChecked(true); MPR_Options.CB_Guild:SetChecked(false);
        MPR.Settings["DEATHREPORT_CHANNEL"] = "Raid"
    end)
    -- GUILD
    MPR_Options.CB_Guild = CreateFrame("CheckButton", "CB_Guild", MPR_Options, "UICheckButtonTemplate")
    MPR_Options.CB_Guild:SetWidth(20)
    MPR_Options.CB_Guild:SetHeight(20)
    MPR_Options.CB_Guild:SetPoint("TOPLEFT", 100, report_deaths_btn_posY)
    _G["CB_GuildText"]:SetText("|cFF40FF40Guild|r")
    MPR_Options.CB_Guild:SetScript("OnShow",  function(self) MPR_Options.CB_Guild:SetChecked(MPR.Settings["DEATHREPORT_CHANNEL"] == "Guild") end)
    MPR_Options.CB_Guild:SetScript("OnClick", function(self)
        MPR_Options.CB_Self:SetChecked(false); MPR_Options.CB_Raid:SetChecked(false); MPR_Options.CB_Guild:SetChecked(true);
        MPR.Settings["DEATHREPORT_CHANNEL"] = "Guild"
    end)

    local enc_posY = report_deaths_posY-32
    MPR_Options.BTN_CLEAR_DEATHLOG = CreateFrame("button","BTN_CLEAR_DEATHLOG", MPR_Options, "UIPanelButtonTemplate")
    MPR_Options.BTN_CLEAR_DEATHLOG:SetHeight(14)
    MPR_Options.BTN_CLEAR_DEATHLOG:SetWidth(44)
    MPR_Options.BTN_CLEAR_DEATHLOG:SetPoint("TOPLEFT", 17, enc_posY)
    MPR_Options.BTN_CLEAR_DEATHLOG:SetText("Reset")
    MPR_Options.BTN_CLEAR_DEATHLOG:SetScript("OnClick", function(self) MPR:ClearDeathLog() end)

    MPR_Options.BTN_ID_LESS = CreateFrame("button","BTN_ID_LESS", MPR_Options, "UIPanelButtonTemplate")
    MPR_Options.BTN_ID_LESS:SetHeight(14)
    MPR_Options.BTN_ID_LESS:SetWidth(14)
    MPR_Options.BTN_ID_LESS:SetPoint("TOPLEFT", "BTN_CLEAR_DEATHLOG", "TOPRIGHT", 5, 0)
    MPR_Options.BTN_ID_LESS:SetText("-")
    MPR_Options.BTN_ID_LESS:SetScript("OnShow", function(self) MPR_Options:ID_HandleOnShow() end)
    MPR_Options.BTN_ID_LESS:SetScript("OnClick", function(self) MPR_Options:ID_HandleOnClick(-1) end)

    MPR_Options.BTN_ID_MORE = CreateFrame("button","BTN_ID_MORE", MPR_Options, "UIPanelButtonTemplate")
    MPR_Options.BTN_ID_MORE:SetHeight(14)
    MPR_Options.BTN_ID_MORE:SetWidth(14)
    MPR_Options.BTN_ID_MORE:SetPoint("TOPLEFT", "BTN_ID_LESS", "TOPRIGHT", 2, 0)
    MPR_Options.BTN_ID_MORE:SetText("+")
    MPR_Options.BTN_ID_MORE:SetScript("OnShow", function(self) MPR_Options:ID_HandleOnShow() end)
    MPR_Options.BTN_ID_MORE:SetScript("OnClick", function(self) MPR_Options:ID_HandleOnClick(1) end)

    MPR_Options.FS_ID = MPR_Options:CreateFontString("FS_ID", "ARTWORK", "GameFontNormal")
    MPR_Options.FS_ID:SetPoint("TOPLEFT", "BTN_ID_MORE", "TOPRIGHT", 3, 0)
    MPR_Options.FS_ID:SetTextColor(1,1,1)
    MPR_Options.FS_ID:SetText(#MPR.DataDeaths)
    MPR_Options.FS_ID:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")

    MPR_Options:SetScript("OnShow", function(self)
        MPR_Options.FS_ID:SetText(#MPR.DataDeaths)
        local Data = MPR.DataDeaths[tonumber(MPR_Options.FS_ID:GetText())]
        MPR_Options.FS_ID_NAME:SetText(Data and "|cFF"..(Data.Color or "FFFFFF")..Data.Name.."|r|cFFBEBEBE: "..#Data.Deaths.." deaths,|r" or "")
        MPR_Options.FS_ID_TIME:SetText(MPR.DataDeaths[tonumber(MPR_Options.FS_ID:GetText())] and (MPR.DataDeaths[tonumber(MPR_Options.FS_ID:GetText())].GameTimeStart or "unknown").." - "..(MPR.DataDeaths[tonumber(MPR_Options.FS_ID:GetText())].GameTimeEnd or "unknown") or "")
    end)

    -- Report!
    MPR_Options.BTN_REPORT = CreateFrame("button","BtnReport", MPR_Options, "UIPanelButtonTemplate")
    MPR_Options.BTN_REPORT:SetHeight(18)
    MPR_Options.BTN_REPORT:SetWidth(58)
    MPR_Options.BTN_REPORT:SetPoint("TOPLEFT", 150, report_deaths_btn_posY)
    MPR_Options.BTN_REPORT:SetText("Report!")
    MPR_Options.BTN_REPORT:SetScript("OnClick", function(self)
        if MPR.Settings["DEATHREPORT_CHANNEL"] and tonumber(MPR_Options.FS_ID:GetText()) then
            MPR:DeathReport(MPR.Settings["DEATHREPORT_CHANNEL"], tonumber(MPR_Options.FS_ID:GetText()))
        end
    end)

    -- Encounter
    local death_data_text_posY = report_deaths_posY-48
    MPR_Options.FS_ID_NAME = MPR_Options:CreateFontString("FS_ID_NAME", "ARTWORK", "GameFontNormal")
    MPR_Options.FS_ID_NAME:SetPoint("TOPLEFT", 18, death_data_text_posY)
    local Data = MPR.DataDeaths[tonumber(MPR_Options.FS_ID:GetText())]
    MPR_Options.FS_ID_NAME:SetText(Data and "|cFF"..(Data.Color or "FFFFFF")..Data.Name.."|r|cFFBEBEBE: "..#Data.Deaths.." deaths,|r" or "")
    MPR_Options.FS_ID_NAME:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")

    MPR_Options.FS_ID_TIME = MPR_Options:CreateFontString("FS_ID_TIME", "ARTWORK", "GameFontNormal")
    MPR_Options.FS_ID_TIME:SetPoint("TOPLEFT", "FS_ID_NAME", "BOTTOMLEFT", 0, -1)
    MPR_Options.FS_ID_TIME:SetTextColor(1,1,1)
    MPR_Options.FS_ID_TIME:SetTextColor(190/255,190/255,190/255)
    MPR_Options.FS_ID_TIME:SetText(MPR.DataDeaths[tonumber(MPR_Options.FS_ID:GetText())] and (MPR.DataDeaths[tonumber(MPR_Options.FS_ID:GetText())].GameTimeStart or "unknown").." - "..(MPR.DataDeaths[tonumber(MPR_Options.FS_ID:GetText())].GameTimeEnd or "unknown") or "")
    MPR_Options.FS_ID_TIME:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")

    --[[ Miscellaneous ]]--
    MPR_Options:NewFS("Miscellaneous","00CCFF",216,general_posY)
    MPR_Options:NewCB("Automatic combat log clear",nil,"CCL_ONLOAD",214,general_posY-line1_offsetY)             -- [ ] ClearEntriesOnLoad
    local SpellIconsCB = MPR_Options:NewCB("Spell Icons (|r\124T"..select(3, GetSpellInfo(33054))..":12:12:0:0:64:64:5:59:5:59\124t "..GetSpellLink(33054)..")",nil,"ICONS",214,general_posY-line2_offsetY)  -- [ ] Spell Icons
    local SpellIconsInfo = {"Spell icons will only show up in your own chat when self-reporting,\nthey will not show up in public chat channels."}
    SpellIconsCB:SetScript("OnEnter", function(self) MPR_Options:ShowGameTooltip(SpellIconsCB, SpellIconsInfo) end)
    SpellIconsCB:SetScript("OnLeave", function(self) GameTooltip:Hide() end)


    --[[ Masterloot ]]--
    local ml_posY = general_posY-48
    MPR_Options:NewFS("Masterloot","3CB371",216,ml_posY)
    MPR_Options:NewCB("Report |cFFB048F8epic|r items in loot",nil,"REPORT_LOOT", 214, ml_posY-line1_offsetY)    -- [ ] ReportLoot
    MPR_Options:NewCB("Only when BoP in loot",nil,"nil", 234, ml_posY-line2_offsetY)                            -- [ ] ReportOnlyWhenBOP    REPORT_LOOT_BOP_ONLY
    MPR_Options:NewCB("Add BiS information",nil,"REPORT_LOOT_BIS_INFO", 234, ml_posY-line3_offsetY)             -- [ ] AddClassBISinfo

    --[[ Window Style ]]--
    local window_style_posY = ml_posY-62
    MPR_Options:NewFS("Window Style","FF9912",216,window_style_posY)
    MPR_Options:NewFS("Border Color:","FFFFFF",218,window_style_posY-line1_offsetY-2)
    -- GRAY (A9A9A9 / 169 169 169)
    MPR_Options.CB_Gray = CreateFrame("CheckButton", "CB_Gray", MPR_Options, "UICheckButtonTemplate")
    MPR_Options.CB_Gray:SetWidth(20)
    MPR_Options.CB_Gray:SetHeight(20)
    MPR_Options.CB_Gray:SetPoint("TOPLEFT", 307, window_style_posY-line1_offsetY)
    _G["CB_GrayText"]:SetTextColor(169/255, 169/255, 169/255)
    _G["CB_GrayText"]:SetText("Gray")
    MPR_Options.CB_Gray:SetScript("OnShow",  function(self) MPR_Options.CB_Gray:SetChecked(MPR.Settings["BACKDROPBORDERCOLOR"].R == 0 and MPR.Settings["BACKDROPBORDERCOLOR"].G == 0 and MPR.Settings["BACKDROPBORDERCOLOR"].B == 0) end)
    MPR_Options.CB_Gray:SetScript("OnClick", function(self)
        MPR_Options:UncheckColors()
        MPR_Options.CB_Gray:SetChecked(true)
        MPR.Settings["BACKDROPBORDERCOLOR"] = {R = 169, G = 169, B = 169}
        MPR.Colors["TITLE"] = "a9a9a9"
        MPR:UpdateBackdrop()
    end)
    -- WHITE (FFFFFF / 255 255 255)
    MPR_Options.CB_White = CreateFrame("CheckButton", "CB_White", MPR_Options, "UICheckButtonTemplate")
    MPR_Options.CB_White:SetWidth(20)
    MPR_Options.CB_White:SetHeight(20)
    MPR_Options.CB_White:SetPoint("RIGHT", "CB_Gray", 43, 0)
    _G["CB_WhiteText"]:SetTextColor(255/255, 255/255, 255/255)
    _G["CB_WhiteText"]:SetText("White")
    MPR_Options.CB_White:SetScript("OnShow",  function(self) MPR_Options.CB_White:SetChecked(MPR.Settings["BACKDROPBORDERCOLOR"].R == 255 and MPR.Settings["BACKDROPBORDERCOLOR"].G == 255 and MPR.Settings["BACKDROPBORDERCOLOR"].B == 255) end)
    MPR_Options.CB_White:SetScript("OnClick", function(self)
        MPR_Options:UncheckColors()
        MPR_Options.CB_White:SetChecked(true)
        MPR.Settings["BACKDROPBORDERCOLOR"] = {R = 255, G = 255, B = 255}
        MPR.Colors["TITLE"] = "FFFFFF"
        MPR:UpdateBackdrop()
    end)
    -- BLUE (1E90FF / 30 144 255)
    MPR_Options.CB_Blue = CreateFrame("CheckButton", "CB_Blue", MPR_Options, "UICheckButtonTemplate")
    MPR_Options.CB_Blue:SetWidth(20)
    MPR_Options.CB_Blue:SetHeight(20)
    MPR_Options.CB_Blue:SetPoint("TOPLEFT", 219, window_style_posY-line2_offsetY)
    _G["CB_BlueText"]:SetTextColor(30/255, 144/255, 255/255)
    _G["CB_BlueText"]:SetText("Blue")
    MPR_Options.CB_Blue:SetScript("OnShow",  function(self) MPR_Options.CB_Blue:SetChecked(MPR.Settings["BACKDROPBORDERCOLOR"].R == 30 and MPR.Settings["BACKDROPBORDERCOLOR"].G == 144 and MPR.Settings["BACKDROPBORDERCOLOR"].B == 255) end)
    MPR_Options.CB_Blue:SetScript("OnClick", function(self)
        MPR_Options:UncheckColors()
        MPR_Options.CB_Blue:SetChecked(true)
        MPR.Settings["BACKDROPBORDERCOLOR"] = {R = 30, G = 144, B = 255}
        MPR.Colors["TITLE"] = "1E90FF"
        MPR:UpdateBackdrop()
    end)
    -- GREEN (00CC33 / 0 204 51)
    MPR_Options.CB_Green = CreateFrame("CheckButton", "CB_Green", MPR_Options, "UICheckButtonTemplate")
    MPR_Options.CB_Green:SetWidth(20)
    MPR_Options.CB_Green:SetHeight(20)
    MPR_Options.CB_Green:SetPoint("RIGHT", "CB_Blue", 43, 0)
    _G["CB_GreenText"]:SetTextColor(0/255, 204/255, 51/255)
    _G["CB_GreenText"]:SetText("Green")
    MPR_Options.CB_Green:SetScript("OnShow",  function(self) MPR_Options.CB_Green:SetChecked(MPR.Settings["BACKDROPBORDERCOLOR"].R == 0 and MPR.Settings["BACKDROPBORDERCOLOR"].G == 204 and MPR.Settings["BACKDROPBORDERCOLOR"].B == 51) end)
    MPR_Options.CB_Green:SetScript("OnClick", function(self)
        MPR_Options:UncheckColors()
        MPR_Options.CB_Green:SetChecked(true)
        MPR.Settings["BACKDROPBORDERCOLOR"] = {R = 0, G = 204, B = 51}
        MPR.Colors["TITLE"] = "00CC33"
        MPR:UpdateBackdrop()
    end)
    -- YELLOW (FFCC00 / 255 204 0)
    MPR_Options.CB_Yellow = CreateFrame("CheckButton", "CB_Yellow", MPR_Options, "UICheckButtonTemplate")
    MPR_Options.CB_Yellow:SetWidth(20)
    MPR_Options.CB_Yellow:SetHeight(20)
    MPR_Options.CB_Yellow:SetPoint("RIGHT", "CB_Green", 50, 0)
    _G["CB_YellowText"]:SetTextColor(255/255, 204/255, 0/255)
    _G["CB_YellowText"]:SetText("Yellow")
    MPR_Options.CB_Yellow:SetScript("OnShow",  function(self) MPR_Options.CB_Yellow:SetChecked(MPR.Settings["BACKDROPBORDERCOLOR"].R == 255 and MPR.Settings["BACKDROPBORDERCOLOR"].G == 204 and MPR.Settings["BACKDROPBORDERCOLOR"].B == 0) end)
    MPR_Options.CB_Yellow:SetScript("OnClick", function(self)
        MPR_Options:UncheckColors()
        MPR_Options.CB_Yellow:SetChecked(true)
        MPR.Settings["BACKDROPBORDERCOLOR"] = {R = 255, G = 204, B = 0}
        MPR.Colors["TITLE"] = "FFCC00"
        MPR:UpdateBackdrop()
    end)
    -- RED (FF0033 / 255 0 51)
    MPR_Options.CB_Red = CreateFrame("CheckButton", "CB_Red", MPR_Options, "UICheckButtonTemplate")
    MPR_Options.CB_Red:SetWidth(20)
    MPR_Options.CB_Red:SetHeight(20)
    MPR_Options.CB_Red:SetPoint("RIGHT", "CB_Yellow", 52, 0)
    _G["CB_RedText"]:SetTextColor(255/255, 0/255, 51/255)
    _G["CB_RedText"]:SetText("Red")
    MPR_Options.CB_Red:SetScript("OnShow",  function(self) MPR_Options.CB_Red:SetChecked(MPR.Settings["BACKDROPBORDERCOLOR"].R == 255 and MPR.Settings["BACKDROPBORDERCOLOR"].G == 0 and MPR.Settings["BACKDROPBORDERCOLOR"].B == 51) end)
    MPR_Options.CB_Red:SetScript("OnClick", function(self)
        MPR_Options:UncheckColors()
        MPR_Options.CB_Red:SetChecked(true)
        MPR.Settings["BACKDROPBORDERCOLOR"] = {R = 255, G = 0, B = 51}
        MPR.Colors["TITLE"] = "FF0033"
        MPR:UpdateBackdrop()
    end)
    -- SEAGREEN (20B2AA / 32 178 170)
    MPR_Options.CB_SeaGreen = CreateFrame("CheckButton", "CB_SeaGreen", MPR_Options, "UICheckButtonTemplate")
    MPR_Options.CB_SeaGreen:SetWidth(20)
    MPR_Options.CB_SeaGreen:SetHeight(20)
    MPR_Options.CB_SeaGreen:SetPoint("TOPLEFT", 219, window_style_posY-line3_offsetY)
    _G["CB_SeaGreenText"]:SetTextColor(32/255, 178/255, 170/255)
    _G["CB_SeaGreenText"]:SetText("SeaGreen")
    MPR_Options.CB_SeaGreen:SetScript("OnShow",  function(self) MPR_Options.CB_SeaGreen:SetChecked(MPR.Settings["BACKDROPBORDERCOLOR"].R == 32 and MPR.Settings["BACKDROPBORDERCOLOR"].G == 178 and MPR.Settings["BACKDROPBORDERCOLOR"].B == 170) end)
    MPR_Options.CB_SeaGreen:SetScript("OnClick", function(self)
        MPR_Options:UncheckColors()
        MPR_Options.CB_SeaGreen:SetChecked(true)
        MPR.Settings["BACKDROPBORDERCOLOR"] = {R = 32, G = 178, B = 170}
        MPR.Colors["TITLE"] = "20B2AA"
        MPR:UpdateBackdrop()
    end)
    -- ORANGE (FFA500 / 255 165 0)
    MPR_Options.CB_Orange = CreateFrame("CheckButton", "CB_Orange", MPR_Options, "UICheckButtonTemplate")
    MPR_Options.CB_Orange:SetWidth(20)
    MPR_Options.CB_Orange:SetHeight(20)
    MPR_Options.CB_Orange:SetPoint("RIGHT", "CB_SeaGreen", 67, 0)
    _G["CB_OrangeText"]:SetTextColor(255/255, 165/255, 0/255)
    _G["CB_OrangeText"]:SetText("Orange")
    MPR_Options.CB_Orange:SetScript("OnShow",  function(self) MPR_Options.CB_Orange:SetChecked(MPR.Settings["BACKDROPBORDERCOLOR"].R == 255 and MPR.Settings["BACKDROPBORDERCOLOR"].G == 165 and MPR.Settings["BACKDROPBORDERCOLOR"].B == 0) end)
    MPR_Options.CB_Orange:SetScript("OnClick", function(self)
        MPR_Options:UncheckColors()
        MPR_Options.CB_Orange:SetChecked(true)
        MPR.Settings["BACKDROPBORDERCOLOR"] = {R = 255, G = 165, B = 0}
        MPR.Colors["TITLE"] = "FFA500"
        MPR:UpdateBackdrop()
    end)
    -- Purple (800080, 128 0 128)
    MPR_Options.CB_Purple = CreateFrame("CheckButton", "CB_Purple", MPR_Options, "UICheckButtonTemplate")
    MPR_Options.CB_Purple:SetWidth(20)
    MPR_Options.CB_Purple:SetHeight(20)
    MPR_Options.CB_Purple:SetPoint("RIGHT", "CB_Orange", 58, 0)
    _G["CB_PurpleText"]:SetTextColor(128/255, 0/255, 128/255)
    _G["CB_PurpleText"]:SetText("Purple")
    MPR_Options.CB_Purple:SetScript("OnShow",  function(self) MPR_Options.CB_Purple:SetChecked(MPR.Settings["BACKDROPBORDERCOLOR"].R == 128 and MPR.Settings["BACKDROPBORDERCOLOR"].G == 0 and MPR.Settings["BACKDROPBORDERCOLOR"].B == 128) end)
    MPR_Options.CB_Purple:SetScript("OnClick", function(self)
        MPR_Options:UncheckColors()
        MPR_Options.CB_Purple:SetChecked(true)
        MPR.Settings["BACKDROPBORDERCOLOR"] = {R = 128, G = 0, B = 128}
        MPR.Colors["TITLE"] = "800080"
        MPR:UpdateBackdrop()
    end)

    -- Opacity Slider
    local opacity_posY = window_style_posY-77
    local OpacityValue = MPR.Settings["BACKDROPCOLOR"][4]*100
    MPR_OpacitySlider = CreateFrame("Slider", "MPR_OpacitySlider", MPR_Options, "OptionsSliderTemplate")
    MPR_OpacitySlider:SetWidth(160)
    MPR_OpacitySlider:SetHeight(20)
    MPR_OpacitySlider:SetPoint('TOPLEFT', 222, opacity_posY)
    MPR_OpacitySlider:SetOrientation('HORIZONTAL')
    MPR_OpacitySlider:SetMinMaxValues(0, 100)
    MPR_OpacitySlider:SetValueStep(1)
    MPR_OpacitySlider:SetValue(OpacityValue)
    _G[MPR_OpacitySlider:GetName().."Low"]:SetText("0%")
    _G[MPR_OpacitySlider:GetName().."High"]:SetText("100%")
    _G[MPR_OpacitySlider:GetName().."Text"]:SetText("|cFFffffffOpacity: "..OpacityValue.."%|r |cFFbebebe(Default: 70%)|r")
    MPR_OpacitySlider:SetScript("OnValueChanged",function()
        _G[MPR_OpacitySlider:GetName()..'Text']:SetText("|cFFffffffOpacity: "..MPR_OpacitySlider:GetValue().."%|r |cFFbebebe(Default: 70%)|r")
        MPR.Settings["BACKDROPCOLOR"][4] = MPR_OpacitySlider:GetValue()/100
        MPR:UpdateBackdrop()
    end)

    --[[ Killing Blow ]]--
    local kb_posY = opacity_posY-33
    MPR_Options:NewFS("Killing Blow","990099",216,kb_posY)
    MPR_Options:NewCB("Enable","FFFFFF","KILLINGBLOW",298,kb_posY+2)
    MPR_Options:NewFS("Announces killing blow/finishing damage","FFFFFF",218,kb_posY-line1_offsetY,9)
    MPR_Options:NewFS("on boss in |cFFEE7600raid|r channel.","FFFFFF",218,kb_posY-line1_offsetY-8,9)
    MPR_Options:NewFS("Display:","FFFFFF",218,kb_posY-line2_offsetY-4,11)
    MPR_Options:NewCB("Ability",nil,"KILLINGBLOW_ABILITY",268,kb_posY-line2_offsetY-2)
    MPR_Options:NewCB("Amount",nil,"KILLINGBLOW_AMOUNT",216,kb_posY-line3_offsetY-2)
    MPR_Options:NewCB("Overkill",nil,"KILLINGBLOW_OVERKILL",283,kb_posY-line3_offsetY-2)
    MPR_Options:NewCB("Critical",nil,"KILLINGBLOW_CRITICAL",349,kb_posY-line3_offsetY-2)
    local Button = CreateFrame("button","BtnTestKillingBlow", MPR_Options, "UIPanelButtonTemplate")
    Button:SetHeight(18)
    Button:SetWidth(60)
    Button:SetPoint("TOPLEFT", 340, kb_posY-line2_offsetY)
    Button:SetText("Test")
    Button:SetScript("OnClick", function(self)
        MPR:SelfReport(MPR:FormatKillingBlow("TestPlayer","Squirrel",GetSpellLink(49238),8,21350,true))
    end)

    --[[ Chat Prefix ]]--
    local prefix_posY = kb_posY-65
    local prefix_value = MPR.Settings["PREFIX_VALUE"]
    MPR_Options:NewFS("Chat Prefix", "1E90FF", 216, prefix_posY)
    MPR_Options:NewFS("(max. 10 characters)","FFFFFF",290,prefix_posY-3,9)
    MPR_Options.EB_PREFIX = CreateFrame("EditBox", "EditBox", MPR_Options, "InputBoxTemplate")
    MPR_Options.EB_PREFIX:SetText(prefix_value)
    MPR_Options.EB_PREFIX:SetPoint("TOPLEFT", 223, prefix_posY-16)
    MPR_Options.EB_PREFIX:SetAutoFocus(false)
    MPR_Options.EB_PREFIX:SetHeight(18)
    MPR_Options.EB_PREFIX:SetWidth(60)
    MPR_Options.EB_PREFIX:SetMaxLetters(10)
    local ChatSymbols = {"{star}", "{skull}", "{cross}", "{circle}", "{moon}", "{diamond}", "{square}", "{triangle}"}
    MPR_Options.EB_PREFIX:SetScript("OnEnter", function(self) MPR_Options:ShowGameTooltip(MPR_Options.EB_PREFIX, ChatSymbols, "E.g. Symbols:") end)
    MPR_Options.EB_PREFIX:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    MPR_Options.BTN_SAVE_PREFIX = CreateFrame("button","BtnSavePrefix", MPR_Options, "UIPanelButtonTemplate")
    MPR_Options.BTN_SAVE_PREFIX:SetHeight(18)
    MPR_Options.BTN_SAVE_PREFIX:SetWidth(60)
    MPR_Options.BTN_SAVE_PREFIX:SetPoint("TOPLEFT", 286, prefix_posY-17)
    MPR_Options.BTN_SAVE_PREFIX:SetText("Save")
    MPR_Options.BTN_SAVE_PREFIX:SetScript("OnClick", function(self)
        MPR.Settings["PREFIX_VALUE"] = MPR_Options.EB_PREFIX:GetText()
        MPR:SelfReport("Chat Prefix changed to " .. MPR_Options.EB_PREFIX:GetText())
        MPR_Options.EB_PREFIX:ClearFocus()
    end)
end

function MPR_Options:ID_HandleOnShow()
    local Index = tonumber(MPR_Options.FS_ID:GetText())
    if MPR.DataDeaths[Index+1] then MPR_Options.BTN_ID_MORE:Enable() else MPR_Options.BTN_ID_MORE:Disable() end
    if MPR.DataDeaths[Index-1] then MPR_Options.BTN_ID_LESS:Enable() else MPR_Options.BTN_ID_LESS:Disable() end
    if MPR.DataDeaths[Index] then MPR_Options.BTN_REPORT:Enable() else MPR_Options.BTN_REPORT:Disable() end
end

function MPR_Options:ID_HandleOnClick(num)
    local Index = tonumber(MPR_Options.FS_ID:GetText())
    local Data = MPR.DataDeaths[Index+(MPR.DataDeaths[Index+num] and num or 0)] or nil
    MPR_Options.FS_ID:SetText(Index+(MPR.DataDeaths[Index+num] and num or 0))
    MPR_Options.FS_ID_NAME:SetText(Data and "|cFF"..(Data.Color or "FFFFFF")..Data.Name.."|r|cFFBEBEBE: "..#Data.Deaths.." deaths,|r" or "")
    MPR_Options.FS_ID_TIME:SetText(Data and Data.GameTimeStart.." - "..Data.GameTimeEnd..", "..Data.Date or "")
    if Data then MPR_Options.BTN_REPORT:Enable() else MPR_Options.BTN_REPORT:Disable() end
    MPR_Options:ID_HandleOnShow()
end

function MPR_Options:UncheckColors()
    MPR_Options.CB_Gray:SetChecked(false)
    MPR_Options.CB_White:SetChecked(false)
    MPR_Options.CB_Blue:SetChecked(false)
    MPR_Options.CB_Green:SetChecked(false)
    MPR_Options.CB_Yellow:SetChecked(false)
    MPR_Options.CB_Red:SetChecked(false)
    MPR_Options.CB_SeaGreen:SetChecked(false)
    MPR_Options.CB_Orange:SetChecked(false)
    MPR_Options.CB_Purple:SetChecked(false)
end

Pack_PosY = -133
function MPR_Options:NewPack(SpellName,Enabled,Amount)
    local CheckBox = CreateFrame("CheckButton", "CheckBox"..GetNewID(), MPR_Options, "UICheckButtonTemplate")
    CheckBox:SetWidth(20)
    CheckBox:SetHeight(20)
    CheckBox:SetPoint("TOPLEFT", 213, Pack_PosY)
    if type(Color) ~= "string" then Color = "FFFFFF" end
    _G["CheckBox"..GetCurrentID().."Text"]:SetTextColor(tonumber(Color:sub(1,2),16)/255, tonumber(Color:sub(3,4),16)/255, tonumber(Color:sub(5,6),16)/255)
    _G["CheckBox"..GetCurrentID().."Text"]:SetText("["..SpellName.."]")
    CheckBox:SetScript("OnShow",  function(self) CheckBox:SetChecked(MPR.DKPPenalties[SpellName][1]) end)
    CheckBox:SetScript("OnClick", function(self) MPR.DKPPenalties[SpellName][1] = not MPR.DKPPenalties[SpellName][1] end)

    local Label = MPR_Options:CreateFontString("Label"..GetNewID(), "ARTWORK", "GameFontNormal")
    Label:SetPoint("TOPLEFT", 378, Pack_PosY)
    if type(Color) ~= "string" then Color = "FFFFFF" end
    Label:SetTextColor(tonumber(Color:sub(1,2),16)/255, tonumber(Color:sub(3,4),16)/255, tonumber(Color:sub(5,6),16)/255)
    Label:SetText(MPR.DKPPenalties[SpellName][2])

    local Button = CreateFrame("button","BtnDKPMore"..GetCurrentID(), MPR_Options, "UIPanelButtonTemplate")
    Button:SetHeight(14)
    Button:SetWidth(14)
    Button:SetPoint("TOPLEFT", 350, Pack_PosY)
    Button:SetText("+")
    Button:SetScript("OnClick", function(self) MPR.DKPPenalties[SpellName][2] = MPR.DKPPenalties[SpellName][2] + 1; Label:SetText(MPR.DKPPenalties[SpellName][2]) end)

    local Button = CreateFrame("button","BtnDKPLess"..GetCurrentID(), MPR_Options, "UIPanelButtonTemplate")
    Button:SetHeight(14)
    Button:SetWidth(14)
    Button:SetPoint("TOPLEFT", 364, Pack_PosY)
    Button:SetText("-")
    Button:SetScript("OnClick", function(self) if MPR.DKPPenalties[SpellName][2] > 1 then MPR.DKPPenalties[SpellName][2] = MPR.DKPPenalties[SpellName][2] - 1 end; Label:SetText(MPR.DKPPenalties[SpellName][2]) end)
end

function MPR_Options:HandleChecks()
    MPR_Options.CB_WHISPER:SetChecked(MPR.Settings["DKPPENALTIES_OUTPUT"] == "WHISPER")
    MPR_Options.CB_RAID:SetChecked(MPR.Settings["DKPPENALTIES_OUTPUT"] == "RAID")
    MPR_Options.CB_GUILD:SetChecked(MPR.Settings["DKPPENALTIES_OUTPUT"] == "GUILD")
end

function MPR_Options:NewFS(Text,Color,LocX,LocY,Size) -- Creates a fontstring
    local Title = MPR_Options:CreateFontString("Title"..GetNewID(), "ARTWORK", "GameFontNormal")
    Title:SetPoint("TOPLEFT", LocX, LocY)
    if type(Color) ~= "string" then Color = "FFFFFF" end
    Title:SetTextColor(tonumber(Color:sub(1,2),16)/255, tonumber(Color:sub(3,4),16)/255, tonumber(Color:sub(5,6),16)/255)
    Title:SetFont("Fonts\\FRIZQT__.TTF", Size or 12, "OUTLINE")
    Title:SetText(Text)

    return Title
end

function MPR_Options:NewCB(Text,Color,Var,LocX,LocY) -- Creates a checkbox
    local CheckBox = CreateFrame("CheckButton", "CheckBox"..GetNewID(), MPR_Options, "UICheckButtonTemplate")
    CheckBox:SetWidth(20)
    CheckBox:SetHeight(20)
    CheckBox:SetPoint("TOPLEFT", LocX, LocY)
    if type(Color) ~= "string" then Color = "FFFFFF" end
    if Var == "nil" then Color = "BEBEBE" end
    _G["CheckBox"..GetCurrentID().."Text"]:SetTextColor(tonumber(Color:sub(1,2),16)/255, tonumber(Color:sub(3,4),16)/255, tonumber(Color:sub(5,6),16)/255)
    _G["CheckBox"..GetCurrentID().."Text"]:SetText(Text)
    if Var ~= "nil" then
        CheckBox:SetScript("OnShow",  function(self) CheckBox:SetChecked(MPR.Settings[Var]) end)
        CheckBox:SetScript("OnClick", function(self)
            MPR.Settings[Var] = not MPR.Settings[Var]
            if MPR.Settings[Var] and (Var == "RAID" or Var == "SAY" or Var == "WHISPER" or Var == "PD_RAID" or Var == "PD_WHISPER" or Var == "PD_GUILD" or Var == "KILLINGBLOW") then
                CheckRaidOptions(Var)
            end
        end)
    else
        CheckBox:Disable()
    end
    return CheckBox
end

function MPR_Options:ShowGameTooltip(owner, content, text)
    GameTooltip:SetOwner(owner, "ANCHOR_BOTTOMRIGHT", 10, -5)
    if text then
        GameTooltip:SetText(text);
    end
    if type(content) == "table" then
        for i=1, #content do
            GameTooltip:AddLine(content[i],1,1,1)
        end
    else
        GameTooltip:AddLine(content,1,1,1,1)
    end
    GameTooltip:Show()
end

function concatTables(t, ...)
    local new = {unpack(t)}
    for i,v in ipairs({...}) do
        for j,w in ipairs(v) do
            new[#new+1] = w
        end
    end
    return new
end
