
INVLIST_ITEMS_PER_PAGE = 22;
INVLIST_ITEM_HEIGHT = 16;

local InvList_Cache = nil;  -- { name, money, bag, slot, count, quality }
local InvList_SortCol = "Money";
local InvList_SortOrder = "ASC";
InvList_TooltipMode = 2; -- nil -> No tips, 1 -> show if not hidden, 2 -> show all
local InvList_TooltipShowStackTotal = 1;
--InvList_ShowStackTotal;
--InvList_IncludeUnknown;
--InvList_HiddenItems; -- table of names of hidden items

UIPanelWindows["InvListFrame"] = { area = "left", pushable = 5 };

function InvList_OnLoad()
    if not Print then 
        Print = function(x) DEFAULT_CHAT_FRAME:AddMessage(x, 1,1,1); end
    end

    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent("PLAYER_LEAVING_WORLD");
	  
    return InvList_RegisterCosmos();
end

function InvList_RegisterEvents()
    InvListFrame:RegisterEvent("BAG_UPDATE");
end

function InvList_UnregisterEvents()
    InvListFrame:UnregisterEvent("BAG_UPDATE");
end

function InvList_RegisterCosmos()
    if Cosmos_RegisterButton then
        Cosmos_RegisterButton(INVLIST_BUTTON_TEXT, INVLIST_BUTTON_SUBTEXT, INVLIST_BUTTON_TIP, "Interface\\Icons\\INV_Misc_Coin_01.blp", InvList_Toggle);
    end

    if Cosmos_RegisterChatCommand then
        Cosmos_RegisterChatCommand("INVENTORYLIST", {"/inventorylist", "/il"}, InvList_Toggle, INVLIST_HELP);
    else
        SlashCmdList["INVENTORYLIST"] = InvList_Toggle;
        SLASH_INVENTORYLIST1 = "/inventorylist";
        SLASH_INVENTORYLIST2 = "/il";
    end
end

function InvList_OnEvent(event, arg1)
  if event == "BAG_UPDATE" then
     InvList_ForceUpdate();
  end
  if event == "PLAYER_ENTERING_WORLD" then
     return InvList_RegisterEvents();
	end
  if event == "PLAYER_LEAVING_WORLD" then
     return InvList_UnregisterEvents();
	end
end

function InvList_Toggle(cmd)
  if cmd and cmd ~= "" then
    InvList_SlashCommand(cmd);
    return;
  end
  
    if InvListFrame:IsVisible() then
        HideUIPanel(InvListFrame);
        PlaySound("igBackPackClose");
    else
        ShowUIPanel(InvListFrame);
        InvList_Update();
        PlaySound("igBackPackOpen");
    end
end

function InvList_GetItemCount()
  local retVal = 0;
  
  for bag=0,NUM_BAG_FRAMES,1 do
    for slot=1,GetContainerNumSlots(bag),1 do
        if GetContainerItemInfo(bag,slot) then
            retVal = retVal + 1;
        end
    end
  end
  
  return retVal;
end

function InvList_SlashCommand(cmd)
    local found,posend,action = string.find(cmd, "(%a+)");
    
    if not found then return; end
    
    action = string.lower(action);
    if action == "hide" then
        local itemname = string.sub(cmd, posend+2);
        InvList_HideItem(itemname);
    elseif action == "show" then
        local itemname = string.sub(cmd, posend+2);
        InvList_ShowItem(itemname);
    elseif action == "list" then
        if InvList_HiddenItems then
            Print("Inventory sell list hidden items:");
            table.foreach(InvList_HiddenItems, function (k,v) Print("  "..k); end);
        else
            Print("No hidden items in inventory sell list.");
        end
    elseif action == "tooltipmode" then
        InvList_SetTooltipMode(string.sub(cmd, posend+2));
    else
        Print("Unknown /inventorylist action.  Valid actions are:");
        Print("  /inventorylist hide <itemname>");
        Print("  /inventorylist show <itemname>");
        Print("  /inventorylist list");
        Print("  /inventorylist tooltipmode <mode>");
        Print("    0 = do not show sell value on tooltips");
        Print("    1 = show only for things not on the hidden list");
        Print("    2 = show for all items");
    end
end

function InvList_SetTooltipMode(mode)
    if not mode or mode == "0" then
        InvList_TooltipMode = nil;
        Print("Inventory list tooltip mode: no tooltips.");
    elseif mode == "1" then
        InvList_TooltipMode = 1;
        Print("Inventory list tooltip mode: show for not hidden items.");
    elseif mode == "2" then
        InvList_TooltipMode = 2;
        Print("Inventory list tooltip mode: show for all items.");
    else
        Print("Unknown inventory list tooltip mode ["..mode.."].  Must be 0, 1, or 2.");
    end
end

-- extract the item name from a link string
-- return the original string if it doesn't look like a link
function Invlist_NameFromLink(itemlink)
    if itemlink then
        local foundlink,_,name = string.find(itemlink, "^.*%[(.*)%].*$");
        if foundlink then
            return name;
        else
            return itemlink;
        end
    end
    return;
end

function InvList_HideItem(itemname)
    if itemname == "" then
        Print("Usage (case-sensitive): /inventorylist hide <itemname>");
        return;
    end

    -- check for link
    itemname = Invlist_NameFromLink(itemname);
    
    if not InvList_HiddenItems then 
        InvList_HiddenItems = {}; 
    end
    InvList_HiddenItems[itemname] = 1;
    Print("Inventory list: Hiding ["..itemname.."]");
    InvList_ForceUpdate();
end

function InvList_ShowItem(itemname)
    if itemname == "" then
        Print("Usage (case-sensitive): /inventorylist show <itemname>");
        return;
    end
    
    if not InvList_HiddenItems then return; end

    -- check for link
    itemname = Invlist_NameFromLink(itemname);
    
    InvList_HiddenItems[itemname] = nil;
    Print("Inventory list: Showing ["..itemname.."]");
    
    local hasitems = nil;
    for k,v in pairs(InvList_HiddenItems) do
        hasitems = true;
    end
    if not hasitems then InvList_HiddenItems = nil; end
    
    InvList_ForceUpdate();
end

function InvList_GetItemName(bag, slot)
    local linktext = nil;
  
    if (bag == -1) then
        linktext = GetInventoryItemLink("player", slot);
    else
        linktext = GetContainerItemLink(bag, slot);
    end

    if linktext then
        return Invlist_NameFromLink(linktext);
    else
        return "";
    end
end

function InvList_GetShortItemName(bag, slot)
    return InvList_ShortenItemName(InvList_GetItemName(bag, slot));
end

function InvList_ShortenItemName(itemName)
  -- do a quick search for " of ", since all the value we are looking for 
  -- contain "of", and it prevents a brute force search of the entire list
    local ofPos = string.find(itemName, SELLVALUE_SHORT_FENCEVAL);
    if ofPos then
        for i=1,table.getn(SELLVALUE_SHORT_STRIPLIST) do
            if string.find(itemName, SELLVALUE_SHORT_STRIPLIST[i]) then
                return string.sub(itemName, 1, ofPos - 1);
            end
        end
    end  -- if ofPos
    
    -- no match, return whole thing
    return itemName;
end

function InvList_RebuildCache()
  InvList_Cache = {};
    
  local itemName, itemMoney, stackCount, quality;
  for bag=0,NUM_BAG_FRAMES,1 do
    for slot=1,GetContainerNumSlots(bag),1 do
      itemName = InvList_GetItemName(bag, slot);
      if itemName ~= "" then              
        _,stackCount,_,quality = GetContainerItemInfo(bag,slot);

        if SellValues then 
          itemMoney = SellValues[InvList_ShortenItemName(itemName)];
        else
          itemMoney = nil;
        end
                
        if itemMoney and InvList_ShowStackTotal then
          itemMoney = itemMoney * stackCount;
        end
            
        if ((itemMoney and itemMoney > 0) or InvList_IncludeUnknown) and 
          not (InvList_HiddenItems and InvList_HiddenItems[itemName]) then
          table.insert(InvList_Cache, { name = itemName, money = itemMoney, 
            bag = bag, slot = slot, count = stackCount, quality = quality });
        end
      end  -- if itemname
    end  -- for slot
  end  -- for bag
  
  InvList_Sort();
end

function InvList_Sort()
  if not InvList_Cache then return; end
  
  table.sort(InvList_Cache, getglobal("InvList_SortBy"..InvList_SortCol..InvList_SortOrder));
end

function InvList_SortByASC(a,b)
    -- sort by bag,slot
    return (a.bag < b.bag) or (a.bag == b.bag and a.slot < b.slot);
end

function InvList_SortByNameASC(a,b)
    if a.name == b.name then
        return a.count < b.count;
    else
        return a.name < b.name;
    end
end

function InvList_SortByNameDESC(a,b)
    if a.name == b.name then
        return a.count > b.count;
    else
        return a.name > b.name;
    end
end

function InvList_SortByMoneyASC(a,b)
    -- if equal a is not less than b
    if not a.money and not b.money then
        return nil;
    -- nils go first
    elseif not a.money then
        return true;
    elseif not b.money then
        return nil;
    else 
        if a.money == b.money then
            return InvList_SortByNameASC(a,b);
        else
            return a.money < b.money;
        end
    end
end

function InvList_SortByMoneyDESC(a,b)
    -- if equal a is not less than b
    if not a.money and not b.money then
        return nil;
    -- nils go last
    elseif not a.money then
        return nil;
    elseif not b.money then
        return true;
    else
        if a.money == b.money then
            return InvList_SortByNameDESC(a,b);
        else 
            return a.money > b.money;
        end
    end
end

function InvList_Update()
  if not InvListFrame:IsVisible() then return; end
    
  if not InvList_Cache then InvList_RebuildCache(); end
  
  local itemCnt = table.getn(InvList_Cache);
  local scrollbarVisible = itemCnt > INVLIST_ITEMS_PER_PAGE;

  if scrollbarVisible then
    InvList_SetColWidth(216, InvListColumnHeader1);
  else
    InvList_SetColWidth(240, InvListColumnHeader1);
  end
  
  FauxScrollFrame_Update(InvListScrollFrame, itemCnt, INVLIST_ITEMS_PER_PAGE, INVLIST_ITEM_HEIGHT);
  local skipCount = FauxScrollFrame_GetOffset(InvListScrollFrame);
  
  local item;
  local btn, color, priceFrame, itemDesc;
  for i=1,INVLIST_ITEMS_PER_PAGE do
    if i > itemCnt then break; end
    
    item = InvList_Cache[skipCount+i];   
    btn = getglobal("InvListItem"..i);
    
    if item.quality then
      color = ITEM_QUALITY_COLORS[item.quality];
    else
      color = TOOLTIP_DEFAULT_COLOR;
    end
    
    if item.count > 1 then
      itemDesc = string.format("%s (x%d)", item.name, item.count);
    else
      itemDesc = item.name;
    end
      
    if scrollbarVisible then
      btn:SetWidth(210);
    else
      btn:SetWidth(230);
    end
       
    btn:SetText(itemDesc);          
    btn:SetTextColor(color.r, color.g, color.b);
    btn:Show();
    
    priceFrame = getglobal("InvListItemSell"..i);
    if item.money then
      IL_MoneyFrame_Update(priceFrame:GetName(), item.money, true);
    else
      priceFrame:Hide();
    end  -- if money
  end  -- for i=1,PER_PAGE
 
 -- turn off any lines we're not using
  for i=itemCnt+1,INVLIST_ITEMS_PER_PAGE,1 do
    btn = getglobal("InvListItem"..i);
    btn:Hide();
    priceFrame = getglobal("InvListItemSell"..i);
    priceFrame:Hide();
  end
  
  -- update total cashola
  local totalMoney = 0;
  for i=1,itemCnt do
    item = InvList_Cache[i];
    if item.money then totalMoney = totalMoney + item.money; end
  end
  
  if totalMoney > 0 then
    IL_MoneyFrame_Update("InvListTotalMoneyFrame", totalMoney, nil);
  else
    InvListTotalMoneyFrame:Hide();
  end
end

function InvList_SetShowStackTotal(enabled)
  InvList_ShowStackTotal = enabled;
  InvList_ForceUpdate();
end

function InvList_SetIncludeUnknown(enabled)
	InvList_IncludeUnknown = enabled;
  InvList_ForceUpdate();
end

function InvListItemButton_OnClick(arg1)
  local id = this:GetID();
  local offset = FauxScrollFrame_GetOffset(InvListScrollFrame);
  local item = InvList_Cache[id + offset];

  if arg1 == "LeftButton" then
    if ( IsShiftKeyDown() and ChatFrameEditBox:IsVisible() ) then
      local link = GetContainerItemLink(item.bag, item.slot);
      if link then ChatFrameEditBox:Insert(link); end
    elseif ( IsControlKeyDown() ) then
      local link = GetContainerItemLink(item.bag, item.slot);
      if link then DressUpItemLink(link); end
    else
      PickupContainerItem(item.bag, item.slot);
    end  -- shift down
        
  elseif arg1 == "RightButton" then
    UseContainerItem(item.bag, item.slot);
  end
end

function InvListItemButton_OnEnter()
  local id = this:GetID();
  local offset = FauxScrollFrame_GetOffset(InvListScrollFrame);
  local item = InvList_Cache[id + offset];

  GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
  local hasCooldown, repairCost = GameTooltip:SetBagItem(item.bag, item.slot);
  if ( hasCooldown ) then
    this.updateTooltip = TOOLTIP_UPDATE_TIME;
  else
    this.updateTooltip = nil;
  end
  if ( InRepairMode() and (repairCost and repairCost > 0) ) then
    GameTooltip:AddLine(TEXT(REPAIR_COST), "", 1, 1, 1);
    SetTooltipMoney(GameTooltip, repairCost);
    GameTooltip:Show();
  elseif ( MerchantFrame:IsVisible() ) then
    ShowContainerSellCursor(item.bag, item.slot);
  elseif ( this.readable ) then
    ShowInspectCursor();
  end
end

function InvList_ForceUpdate()
  InvList_Cache = nil;
  InvList_Update();
end

function InvListItemButton_OnLeave()
  GameTooltip:Hide();
  ResetCursor();
end

function InvList_SetColWidth(width, frame)
  if not frame then
    frame = this;
  end
  frame:SetWidth(width);
    getglobal(frame:GetName().."Middle"):SetWidth(width - 9);
end

function InvList_SortBy(sort)
  if sort == InvList_SortCol then
    if InvList_SortOrder == "ASC" then
      InvList_SortOrder = "DESC";
    else
      InvList_SortOrder = "ASC";
    end
  else
    InvList_SortCol = sort;
    InvList_SortOrder = "ASC";
  end
    
  InvList_Sort();
  InvList_Update();
end

function IL_MoneyFrame_Update(frameName, money, fixedWidthText)
  local frame = getglobal(frameName);
  local info = frame.info;
  if (not info) then
    info = MoneyTypeInfo["STATIC"];
  end

  -- Breakdown the money into denominations
  local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD));
  local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
  local copper = mod(money, COPPER_PER_SILVER);

  local goldButton = getglobal(frameName.."GoldButton");
  local silverButton = getglobal(frameName.."SilverButton");
  local copperButton = getglobal(frameName.."CopperButton");

  local iconWidth = MONEY_ICON_WIDTH;
  local spacing = MONEY_BUTTON_SPACING / 2;

  -- Set values for each denomination
  goldButton:SetText(gold);
  if fixedWidthText then 
    goldButton:SetWidth(15 + iconWidth); 
  else    
    goldButton:SetWidth(goldButton:GetTextWidth() + iconWidth); 
  end
  goldButton:Show();
  silverButton:SetText(silver);
  if fixedWidthText then 
    silverButton:SetWidth(15 + iconWidth);
  else    
    silverButton:SetWidth(silverButton:GetTextWidth() + iconWidth);
  end
  silverButton:Show();
  copperButton:SetText(copper);
  if fixedWidthText then 
    copperButton:SetWidth(15 + iconWidth);
  else    
    copperButton:SetWidth(copperButton:GetTextWidth() + iconWidth);
  end
  copperButton:Show();

  -- Store how much money the frame is displaying
  frame.staticMoney = money;

  local width = iconWidth;
  local showLowerDenominations, truncateCopper;
  if ( gold > 0 ) then
    width = width + goldButton:GetWidth();
    if ( info.showSmallerCoins ) then
      showLowerDenominations = 1;
    end
    if ( info.truncateSmallCoins ) then
      truncateCopper = 1;
    end
  else
    goldButton:Hide();
  end

  if ( silver > 0 or showLowerDenominations ) then
    width = width + silverButton:GetWidth();
    goldButton:SetPoint("RIGHT", frameName.."SilverButton", "LEFT", spacing, 0);
    if ( goldButton:IsVisible() ) then
      width = width - spacing;
    end
    if ( info.showSmallerCoins ) then
      showLowerDenominations = 1;
    end
  else
    silverButton:Hide();
    goldButton:SetPoint("RIGHT", frameName.."SilverButton", "RIGHT", 0, 0);
  end

  -- Used if we're not showing lower denominations
  if ( (copper > 0 or showLowerDenominations or info.showSmallerCoins == "Backpack") and not truncateCopper) then
    width = width + copperButton:GetWidth();
    silverButton:SetPoint("RIGHT", frameName.."CopperButton", "LEFT", spacing, 0);
    if ( silverButton:IsVisible() ) then
      width = width - spacing;
    end
  else
    copperButton:Hide();
    silverButton:SetPoint("RIGHT", frameName.."CopperButton", "RIGHT", 0, 0);
  end

  frame:Show();
end

