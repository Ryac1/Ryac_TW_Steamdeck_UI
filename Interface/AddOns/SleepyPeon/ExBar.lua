

local xp, exh, lvl, xp_denom, exhState = nil, nil, nil, nil, nil
local fontPath = "Fonts\\ARIALN.ttf"

local xpTt = CreateFrame( "GameTooltip", "xpTt", nil, "GameTooltipTemplate"); -- Tooltip name cannot be nil
xpTt:SetOwner( WorldFrame, "ANCHOR_BOTTOMRIGHT",-500,500);



--init the XP bar frame
barFrame = CreateFrame("Frame","xpbar",MainMenuBar);
barFrame:SetFrameStrata("MEDIUM");
barFrame:SetPoint("TOP",MainMenuBar,"TOP",0,0);
barFrame:SetWidth(1024);
barFrame:SetHeight(8);
barFrame:EnableMouse();
barFrame:RegisterForDrag("LeftButton");
barFrame:SetMovable();
barFrame:SetClampedToScreen();

local barOverlay = CreateFrame("Frame","barOverlay",barFrame);
barOverlay:SetAllPoints(barFrame);
barOverlay:SetFrameStrata("DIALOG");


--init lock/unlock flag
barFrame.lock = true;

--init layout variable
barFrame.layout = nil;

-- store level fontstrings fontstrings
barFrame.levelStrings = {};

-- store level boundary markers
barFrame.divs = {};
 
-- Cumulative XP to level
barFrame.CumX = {};

-- assign not rest xp/rest xp colors
barFrame.colors = {}
barFrame.colors.restColor = {250.0/255, 225.0/255, 35.0/255}
-- barFrame.colors.restColor = {0.98, 0.52,0.137}
barFrame.colors.color = {0.98, 0.52,0.137}


--cumulative xp table
local sumXP = 0;
for i, XP in ipairs(XToLevel) do
    barFrame.CumX[i] = sumXP + XP;
    sumXP = barFrame.CumX[i];

end


function barFrame:ExpRest_OnLoad()
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:RegisterEvent("PLAYER_XP_UPDATE");
    self:RegisterEvent("UPDATE_EXHAUSTION");
    self:RegisterEvent("PLAYER_LEVEL_UP");
    self:RegisterEvent("PLAYER_UPDATE_RESTING");
end

--register events
barFrame:ExpRest_OnLoad();

--init XP and rest XP bars
local bar = CreateFrame("StatusBar", "bar", barFrame);
local restbar = CreateFrame("StatusBar","restbar",barFrame);


--init middle text
barOverlay.MidText = barOverlay:CreateFontString(nil, "OVERLAY")
barOverlay.MidText:SetPoint("CENTER", barFrame, "LEFT", 1024.0/6, 1)
barOverlay.MidText:SetFont(fontPath, 11, "OUTLINE")
barOverlay.MidText:SetJustifyH("LEFT")
-- barOverlay.MidText:SetShadowOffset(1, -1)
barOverlay.MidText:SetTextColor(1, 1, 1)


--init left fontstring
barOverlay.LeftText = barOverlay:CreateFontString(nil, "OVERLAY")
barOverlay.LeftText:SetPoint("CENTER", barFrame, "LEFT", 1024.0/6, 1)
barOverlay.LeftText:SetFont(fontPath, 11, "OUTLINE")
barOverlay.LeftText:SetJustifyH("LEFT")
-- barOverlay.LeftText:SetShadowOffset(1, -1)
barOverlay.LeftText:SetTextColor(1, 1, 1)
   
--init right fontstring
barOverlay.RightText = barOverlay:CreateFontString(nil, "OVERLAY")
barOverlay.RightText:SetPoint("CENTER", barFrame, "RIGHT", -1024.0/6, 1)
barOverlay.RightText:SetFont(fontPath, 11, "OUTLINE")
barOverlay.RightText:SetJustifyH("RIGHT")
-- barOverlay.RightText:SetShadowOffset(1, -1)
barOverlay.RightText:SetTextColor(1, 1, 1)



-- init XP text
barOverlay.XPText = barOverlay:CreateFontString(nil,"OVERLAY")
barOverlay.XPText:SetPoint("CENTER", barFrame, "LEFT",60, 1)
barOverlay.XPText:SetFont(fontPath, 11, "OUTLINE")
barOverlay.XPText:SetJustifyH("LEFT")
-- barOverlay.XPText:SetShadowOffset(1, -1)
barOverlay.XPText:SetTextColor(1, 1, 1)


--store level strings
barFrame.levelStrings = {barOverlay.LeftText, barOverlay.MidText, barOverlay.RightText}

-- store markers for each fontstring
barFrame.levelContainers = {}

-- assign levelContainers, @experimental 
for i, _ in ipairs(barFrame.levelStrings) do
    local levelContainer = barFrame:CreateTexture(nil,"OVERLAY")
    levelContainer:SetTexture("Interface\\Calendar\\UI-Calendar-Button-Glow")
    levelContainer:SetWidth(32)
    levelContainer:SetHeight(32)
    barFrame.levelContainers[i] = levelContainer

end





--set bar visuals
bar:SetStatusBarTexture("Interface\\AddOns\\SleepyPeon\\art\\bar_elvui")
bar:ClearAllPoints()
bar:SetAllPoints(barFrame)
bar:SetMinMaxValues(0, 100)
bar:SetFrameStrata(barFrame:GetFrameStrata())
bar:SetFrameLevel(barFrame:GetFrameLevel()+1)

-- set xp bar visuals
restbar:SetStatusBarTexture("Interface\\AddOns\\SleepyPeon\\art\\bar_elvui")
restbar:ClearAllPoints()
restbar:SetAllPoints(barFrame)
restbar:SetMinMaxValues(0, 100)
restbar:SetFrameStrata(barFrame:GetFrameStrata())
restbar:SetFrameLevel(barFrame:GetFrameLevel())

-- set background visuals
barFrame.bg = barFrame:CreateTexture(nil, "BACKGROUND")
barFrame.bg:SetTexture("Interface\\AddOns\\SleepyPeon\\art\\bar_tukui")
barFrame.bg:SetAllPoints(true)
barFrame.bg:SetVertexColor(0.41, 0.41, 0.41)
barFrame.bg:SetAlpha(0.4)

-- create ticker for rested xp bar
local exhTicker = CreateFrame("Button","ticker",restbar);
exhTicker:SetNormalTexture("Interface\\AddOns\\SleepyPeon\\art\\red_spark");
exhTicker:GetNormalTexture():SetBlendMode("ADD");
exhTicker:SetHighlightTexture("Interface\\AddOns\\SleepyPeon\\art\\spark");
exhTicker:SetFrameStrata("DIALOG");
exhTicker:SetFrameLevel(barOverlay:GetFrameLevel()-1);
exhTicker:SetWidth(32);
exhTicker:SetHeight(32*barFrame:GetHeight()/8);
exhTicker:RegisterEvent("PLAYER_UPDATE_RESTING");
exhTicker.resting = false;



-- create dividers
bar.firstDiv = bar:CreateTexture(nil,"OVERLAY");
bar.firstDiv:SetTexture("Interface\\AddOns\\SleepyPeon\\art\\divider")
bar.firstDiv:SetHeight(barFrame:GetHeight())
bar.firstDiv:SetVertexColor(0,0,0,0.7)
bar.firstDiv:SetWidth(12)
bar.firstDiv:Hide()

bar.secondDiv = bar:CreateTexture(nil,"OVERLAY");
bar.secondDiv:SetTexture("Interface\\AddOns\\SleepyPeon\\art\\divider")
bar.secondDiv:SetHeight(barFrame:GetHeight())
bar.secondDiv:SetVertexColor(0,0,0,0.7)
bar.secondDiv:SetWidth(12)
bar.secondDiv:Hide()

-- store dividers
barFrame.divs = {bar.firstDiv, bar.secondDiv};


-- xp bar borders
local f = CreateFrame("Frame", nil, barFrame);
f:SetPoint("CENTER",barFrame,"CENTER",0,0);
f:SetWidth(barFrame:GetWidth()+6);
f:SetHeight(barFrame:GetHeight()+7);
f:SetBackdrop({ 
    bgFile = "",-- defaults
	edgeFile = "Interface\\AddOns\\SleepyPeon\\art\\glassborder",
	tile = false,
	tileEdge = true,
	tileSize = 20,
	edgeSize = 7,
	insets = { left = 40, right = 40, top = 40, bottom = 40 }
})




-- @experimental borders
function barFrame:SetBorders()

    local offset = 0
    local dividerDrawLayer = nil
    for i = 0, 3, 1 do


            local topDivider = self:CreateTexture(nil,"BORDER")

            topDivider:SetTexture("Interface\\AddOns\\SleepyPeon\\art\\border"..i+1)
            topDivider:SetPoint("LEFT",barFrame,"TOPLEFT",offset + i * topDivider:GetWidth(),-4)
            topDivider:Show()

            local botDivider = self:CreateTexture(nil,"BORDER")
            botDivider:SetTexture("Interface\\AddOns\\SleepyPeon\\art\\border"..i+1)
            botDivider:SetPoint("LEFT",barFrame,"BOTTOMLEFT",offset + i * botDivider:GetWidth(),8)
            botDivider:SetTexCoord(0,1,0,0,1,1,1,0)
            botDivider:Show()

            if(dividerDrawLayer == nil) then
                dividerDrawLayer = botDivider:GetDrawLayer();
            end

        offset = 0
    end 

    local studLeft = self:CreateTexture(nil,"BORDER")
    studLeft:SetTexture("Interface\\AddOns\\SleepyPeon\\art\\borderStud")
    studLeft:SetPoint("LEFT",barFrame,"LEFT",-9,2)
    studLeft:SetDrawLayer(dividerDrawLayer,1);
    studLeft:SetWidth(24);
    studLeft:SetHeight(24);
    studLeft:Hide()

    local studRight = self:CreateTexture(nil,"BORDER")
    studRight:SetTexture("Interface\\AddOns\\SleepyPeon\\art\\borderStud")
    studRight:SetPoint("RIGHT",barFrame,"RIGHT",9,2)
    studRight:SetDrawLayer(dividerDrawLayer,1);
    studRight:SetWidth(24);
    studRight:SetHeight(24);
    studRight:SetTexCoord(1,0,1,1,0,0,0,1)
    


end

-- barFrame:SetBorders()



-- xp highlight
barFrame:SetScript("OnLeave", function()
    barOverlay.RightText:SetTextColor(1, 1, 1, 1);
    barOverlay.MidText:SetTextColor(1, 1, 1, 1);
    barOverlay.LeftText:SetTextColor(1, 1, 1, 1);
    barOverlay.XPText:SetTextColor(1, 1, 1, 1);
end);

barFrame:SetScript("OnEnter", function()
    barOverlay.RightText:SetTextColor(0, 1, 1, 1);
    barOverlay.MidText:SetTextColor(0, 1, 1, 1);
    barOverlay.LeftText:SetTextColor(0, 1, 1, 1);
    barOverlay.XPText:SetTextColor(0, 1, 1, 1);    
end);

-- barFrame dragging
barFrame:SetScript("OnDragStart", function()
    if(not this.lock) then
        this:StartMoving();
    end
end);

barFrame:SetScript("OnDragStop", function()
    this:StopMovingOrSizing();
end);

-- bar
barFrame:SetScript("OnMouseUp", function()
    if(arg1 == "RightButton") then
        if(not optionFrame:IsVisible()) then
            optionFrame:Show();
            optionFrame:SetPoint("CENTER",UIParent,"CENTER")

        end
    end
    
end);


-- tooltip pop-up
exhTicker:SetScript("OnEnter", function()
    xpTt:SetOwner( WorldFrame, "ANCHOR_BOTTOMRIGHT",-200,150 );
    xpTt:AddLine("Rest XP",1,1,1);
    xpTt:AddDoubleLine("Quantity","Percent",1,1,1,1,1,1);
    xpTt:AddDoubleLine(tostring(exh), 
    singledecimalformat(exh / XToLevel[lvl] * 100)
    ,0,1,1,0,1,1);

    if(IsResting() ~= 1) then
        xpTt:AddLine("\nRested",1,1,1);

    else
        xpTt:AddLine("\nResting",0,1,1);
    end

    xpTt:Show();


end);

exhTicker:SetScript("OnLeave", function()
    xpTt:Hide();
end);


-- barframe logic
barFrame:SetScript("OnEvent", function()
        
        if event == "PLAYER_ENTERING_WORLD" then


            -- purge bar
            local oldbar = MainMenuExpBar     
            oldbar:SetParent(UIParent);
            oldbar:ClearAllPoints();   
            oldbar:UnregisterAllEvents();
            oldbar.Show = oldbar.Hide
            oldbar:Hide();

            -- hide Eagle Caps
            MainMenuBarLeftEndCap:Hide(); 
            MainMenuBarRightEndCap:Hide();

            -- set xp, rest xp, player level, and rest state 
            xp, exh, lvl, exhState = UnitXP("player"), GetXPExhaustion(), UnitLevel("player"), GetRestState();
            
            


            -- identify and set layout of barFrame
            barFrame:SetBarState();
            barFrame:FormatBar();

            --set xp bar text
            -- barOverlay.XPText:SetText("XP "..xp.."/"..barFrame[lvl].." ("..(xp/barFrame[lvl]*100).."%)");

            -- set bar color
            SetBarColor();

            Update_bar();
            Update_restbar();



        elseif event == "PLAYER_LEVEL_UP" then

            --fix
            xp, exh, lvl = UnitXP("player"), GetXPExhaustion(), arg1

            if (lvl == 60 and ReputationWatchBar:IsShown()) then
                barFrame:Hide();
            else
                -- update layout then reformat to layout
                barFrame:SetBarState();
                barFrame:FormatBar();
            end

            Update_restbar();
            Update_bar();
        end


        if event == "PLAYER_XP_UPDATE" then 
            xp = UnitXP("player")
            Update_bar();
        end




        if event == "UPDATE_EXHAUSTION" then
           
        
            exh = GetXPExhaustion();
            original_layout = barFrame.layout

            --set layout to reflect change in xp ticker
            barFrame:SetBarState();

            --if current layout is different from previous layout then reformat the bar
            if current_layout ~= barFrame.layout then
                barFrame:FormatBar();
            end
               
            -- if rest state changed, change bar color
            currentRested = exhState
            exhState = GetRestState();
            if(currentRest ~= exhState) then
                SetBarColor();
            end
            -- update the rest xp bar    
            Update_restbar();  
            Update_bar();          

        end

        

            -- purge tick
            ExhaustionTick:Hide();
            local oldtick = ExhaustionTick
            oldtick:SetParent(UIParent);
            oldtick:ClearAllPoints();
            oldtick:UnregisterAllEvents();
            oldtick.Show = oldtick.Hide
            oldtick:Hide();


    end
    );


-- designates bar state according to quantity of rest xp and xp level cap
-- @TODO add robust checks for lvl 60
function barFrame:SetBarState()


    if(exh ~=nil) then

        if exh + xp > XToLevel[lvl + 1] + XToLevel[lvl] then
            self.layout = "tri-bar"
        elseif exh + xp > XToLevel[lvl] then
            self.layout = "duo-bar" 
        else  
            self.layout = "uni-bar"
        end
    else 

        self.layout = "uni-bar"
    end

    
end

-- xp to level from lvlStart to lvlEnd, lvlStart = lvlEnd gives xp to level on lvlStart
function barFrame:XFromTo(lvlStart,lvlEnd)
    if(lvlEnd > 60) then
        lvlEnd = 60;
    end

    return self.CumX[lvlEnd] - self.CumX[lvlStart] + XToLevel[lvlStart];
    

end

-- format bar to current layout
function barFrame:FormatBar()
    
    -- calculate the xp denominator to set the 'scale' for bar level
    local lvlStart = lvl;
    local lvlEnd = lvl + LayoutTable[self.layout]["lvl"][3];
    xp_denom = self:XFromTo(lvlStart,lvlEnd);

    -- calculate xp numerators for each level up to final level in the layout, this sets position of "LVL:" texts on the bar 
    local xp_nums = {};
    for i = 0, LayoutTable[self.layout]["lvl"][3], 1 do
        xp_nums[i+1] = self:XFromTo(lvl,lvl + i) 
    end

    -- sets level fontstring's
    for i = 1, 3, 1 do
        levelContainer = self.levelContainers[i]
        fs = self.levelStrings[i]
        text = LayoutTable[self.layout]["levelString"][i]
        lvl_num = lvl + LayoutTable[self.layout]["lvl"][i]
        
        if text ~= nil then
            if not fs:IsVisible() then
                fs:Show()
            end

                fs:SetText(text..tostring(lvl_num))
                
                if i == 1 then
                    fs:SetPoint("CENTER", barFrame, "LEFT", xp_nums[1]*0.5/xp_denom * self:GetWidth(), 1)
                    levelContainer:SetPoint("CENTER", barFrame, "LEFT", xp_nums[1]*0.5/xp_denom * self:GetWidth(), 1)
                else
                    fs:SetPoint("CENTER", barFrame, "LEFT", (0.5*xp_nums[i-1]+0.5*xp_nums[i])/xp_denom * self:GetWidth(), 1)
                    levelContainer:SetPoint("CENTER", barFrame, "LEFT", (0.5*xp_nums[i-1]+0.5*xp_nums[i])/xp_denom * self:GetWidth(), 1)
                end
        else
            levelContainer:Hide();
            fs:Hide();
        end
        
        --align dividers according to layout (0 dividers if uni-bar, 1 is duo-bar, 2 if tri-bar)
        local flag = LayoutTable[self.layout]["dividerFlag"][i];
        local divider = self.divs[i];
        if flag == true then
            divider:SetPoint("CENTER",barFrame,"LEFT", xp_nums[i]/xp_denom * self:GetWidth(), 0);
            divider:Show();
        else
            if(divider ~= nil) then
                divider:Hide();
            end
        end


    end     

end

-- updates xp bar value and xp text
function Update_bar()
    local formatted = singledecimalformat(UnitXP('player') / UnitXPMax('player') * 100)
    barOverlay.XPText:SetText("XP "..xp.."/"..XToLevel[lvl].." ("..formatted..")");
    bar:SetValue(xp / xp_denom * 100)
end

-- updates rest xp bar value and ticker position
function Update_restbar()
    if(exh ~= nil) then
        if( not restbar:IsVisible()) then
            restbar:Show();
        end
        local restPos = ( xp + exh ) / xp_denom * 100
        local tickPos = restPos * barFrame:GetWidth() / 100
        restbar:SetValue(restPos);
        exhTicker:SetPoint("CENTER",barFrame,"LEFT",tickPos,0)

        -- exhTicker:SetPoint("CENTER",barFrame,"LEFT",restPos * barFrame:GetWidth(),0)

    else
        restbar:Hide();
    end
end

-- sets bar color
function SetBarColor()
    if exhState == 1 then
        color = barFrame.colors.restColor;
    else
        color = barFrame.colors.color;
    end

    bar:SetStatusBarColor(unpack(color));
    bar:SetAlpha(1);
    restbar:SetStatusBarColor(unpack(color));
    restbar:SetAlpha(0.5);

end

