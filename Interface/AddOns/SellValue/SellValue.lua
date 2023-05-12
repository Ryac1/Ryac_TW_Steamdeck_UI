-- global SellValues = shortname -> price

function SellValue_OnLoad()
	this:RegisterEvent("MERCHANT_SHOW");

	SellValue_Saved_OnTooltipAddMoney = SellValue_Tooltip:GetScript("OnTooltipAddMoney");
	SellValue_Tooltip:SetScript("OnTooltipAddMoney", SellValue_OnTooltipAddMoney);
end

function SellValue_OnEvent()
    if event == "MERCHANT_SHOW" then
        return SellValue_MerchantScan(this);
    end
end

SellValue_Saved_GameTooltip_OnEvent = GameTooltip_OnEvent;
GameTooltip_OnEvent = function ()
    if event ~= "CLEAR_TOOLTIP" then
        return SellValue_Saved_GameTooltip_OnEvent();
    end 
end

function SellValue_OnTooltipAddMoney ()
    -- call the original function first
    SellValue_Saved_OnTooltipAddMoney();

    -- The money in repair mode is the cost to repair, not sell
    if InRepairMode() then return; end;

    SellValue_LastItemMoney = arg1;   
end

function SellValue_SaveFor(bag, slot, name, money)

    if not (bag and slot and name and money) then return; end;
		
    local _, stackCount = GetContainerItemInfo(bag, slot);
    if stackCount and stackCount > 0 then
        local costOfOne = money / stackCount;
            
        if not SellValues then SellValues = {}; end
        
        SellValues[name] = costOfOne;

        if InvListFrame:IsVisible() then InvList_ForceUpdate(); end
    end
end

function SellValue_AddMoneyToTooltip()
    if SellValues and not MerchantFrame:IsVisible() then
        local lbl = getglobal("GameTooltipTextLeft1");
        if lbl then
            local itemName = lbl:GetText();
            local itemShortName = InvList_ShortenItemName(itemName);
            
            -- Don't add a tooltip for hidden items
            if not InvList_TooltipMode or
                (InvList_TooltipMode == 1 and 
                 InvList_HiddenItems and 
                 InvList_HiddenItems[itemName]) then
                return;
            end
            
            local price = SellValues[itemShortName];
          
            if price then
                local linesAdded = 0;
                if price == 0 then
                    GameTooltip:AddLine(ITEM_UNSELLABLE, 1.0, 1.0, 0);
                    linesAdded = 1;
                else
                    GameTooltip:AddLine(SELLVALUE_COST, 1.0, 1.0, 0);
                    SetTooltipMoney(GameTooltip, price);
                    linesAdded = 2;
                    
                    if InvList_TooltipShowStackTotal then
                    	MoneyFrame_Update("SellValueMoneyFrame", price * 2);
	                linesAdded = 3;
                    end  -- if showstacktotal
                end  -- if price > 0

                -- Adjust width and height to account for new lines
                GameTooltip:SetHeight(GameTooltip:GetHeight() 
                                      + (14 * linesAdded));
                if GameTooltip:GetWidth() < 120 then 
                    GameTooltip:SetWidth(120); 
                end
            end  -- if price
        end
    end
end

function SellValue_MerchantScan(frame)

    for bag=0,NUM_BAG_FRAMES do
        for slot=1,GetContainerNumSlots(bag) do
    
            local itemName =  InvList_GetShortItemName(bag, slot);
            if itemName ~= "" then
                SellValue_LastItemMoney = 0;
                SellValue_Tooltip:SetBagItem(bag, slot);
                SellValue_SaveFor(bag, slot, itemName, SellValue_LastItemMoney);
            end  -- if item name
        end  -- for slot
    end -- for bag
    
end

function SellValue_OnShow()
    return SellValue_AddMoneyToTooltip();
end

function SellValue_OnHide()
    -- ClearMoney() expects this to point to the tooltip itself, and this here
    -- points to us, a child of the tip
    this = this:GetParent();
    return GameTooltip_ClearMoney();
end
