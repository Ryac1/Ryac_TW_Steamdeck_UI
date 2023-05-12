


optionFrame = CreateFrame("Frame", nil, UIParent);

optionFrame.titleColor = {1,1,1};
optionFrame.backdropColor = {0,0,0,0.5}
optionFrame.width = 160;
optionFrame.height = 100;
optionFrame.lockText = "Lock"
optionFrame.defaultsText = "Default"
optionFrame.titleText = "SleepyPeon"


optionFrame:SetWidth(optionFrame.width);
optionFrame:SetHeight(optionFrame.height);
optionFrame:SetPoint("CENTER",UIParent,"CENTER",-optionFrame.width * 0.5, optionFrame.width * 0.5)

optionFrame:EnableMouse();
optionFrame:SetMovable();
optionFrame:SetClampedToScreen(true);
optionFrame:RegisterForDrag("LeftButton");
optionFrame:SetScript("OnDragStart", function() this:StartMoving() end);
optionFrame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end);

optionFrame:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
optionFrame:SetBackdropColor(unpack(optionFrame.backdropColor));

local title = optionFrame:CreateFontString(nil, nil, "GameFontNormalLarge");
title:SetPoint("TOPLEFT",optionFrame,"TOPLEFT",15,-12);
title:SetText(optionFrame.titleText);
title:SetTextColor(unpack(optionFrame.titleColor));
title:SetJustifyH("LEFT");

-- close button
local close = CreateFrame("Button", nil, optionFrame, "UIPanelCloseButton");
close:SetPoint("TOPRIGHT", optionFrame, "TOPRIGHT", -5, -5);





-- lock bar check button
local btnLockBar = CreateFrame("CheckButton", nil, optionFrame, "OptionsCheckButtonTemplate");
btnLockBar:SetPoint("TOPLEFT", optionFrame, "LEFT",30,20);
btnLockBar:SetChecked(true);

btnLockBar:SetScript("OnClick", function()
    local tick = this:GetChecked();
    barFrame.lock = tick;

    if tick then
		PlaySound(856); -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
	else
		PlaySound(857); -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
	end


end);



local btnLockBarText = optionFrame:CreateFontString(nil,nil,"GameFontHighlight");
btnLockBarText:SetPoint("LEFT", btnLockBar, "RIGHT", 0, 1);
btnLockBarText:SetText(optionFrame.lockText);

local btnDefaults = CreateFrame("Button",nil,optionFrame, "OptionsButtonTemplate");
btnDefaults:Enable();
btnDefaults:SetPoint("TOP", optionFrame, "BOTTOM", 0, 30);
btnDefaults:SetText(optionFrame.defaultsText)
btnDefaults:SetScript("OnClick", function()
    
    


    barFrame:ClearAllPoints();
    barFrame:SetPoint("TOP",MainMenuBar,"TOP",0,0);
    barFrame:SetFrameStrata("MEDIUM");

    if(not barFrame.lock) then
        barFrame.lock = true;
        btnLockBar:SetChecked();
    end

end);

optionFrame:Hide();



