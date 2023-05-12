SellValue - v38

===========
Quick Start
===========
Unzip the contents of the zip archive into your WoW Interface\AddOns 
directory.  Make sure you "Use folder names" so the files end up in 
the right place.  You should end up with:
  <wowdir>\Interface\AddOns\SellValue\readme.txt
	<wowdir>\Interface\AddOns\SellValue\Bindings.xml
  <wowdir>\Interface\AddOns\SellValue\SellValue.toc
  <wowdir>\Interface\AddOns\SellValue\SellValue.xml
  <wowdir>\Interface\AddOns\SellValue\SellValue.lua
  <wowdir>\Interface\AddOns\SellValue\InventoryList.xml
  <wowdir>\Interface\AddOns\SellValue\InventoryList.lua

For every item in your inventory when you visit a merchant, that price is
saved and you can refer to it when not at the vendor.

Use /inventorylist or /il to get a list of things in your inventory 
and their sell prices.  The list should function the same as all 
your bags. This can be bound to a key using the Toggle Inventory Sell 
List keybinding.

==============
Slash Commands
==============
In addition to using /inventorylist to toggle the frame display
you can also prevent certain items from ever showing up on the
list.  For example, my skinning knife, poisons, bandages, etc
which I never want to drop or sell.

/inventorylist hide <itemname>
/inventorylist show <itemname>
/inventorylist list
/inventorylist tooltipmode <mode>
	0 = do not show sell value on tooltips
	1 = show only for things not on the hidden list
	2 = show for all items

Note that itemname is CASE-SENSITIVE!

** CapnBry <bmayland@capnbry.net> **

Thanks to sarf (Azam) for writing the original SellValue code.
Thanks to vjeux for removing the GameTooltip override requirement.
Thanks to Malkai for pointing out there is a MERCHANT_SHOW event and the 
	"No Sell Price" idea.
Thanks to Hawkes for narrowing down the scrolling tooltip problem.
Thanks to Telo for figuring out that the CLEAR_TOOLTIP event sucks.
Thanks to Angarth for suggesting new CLEAR_TOOLTIP behavior.
Thanks to Juki for providing French localization.
Thanks to Zett for providing German localization.
Thanks to Snuggles@Hyjal for the excellent suffix-agnostic sell value idea.

Version History
38 - Interface version 11200.
37 - Interface version 11100.
36 - Fix sorting to stop juggling items with the same value or name on 
     repeated sorts.
35 - Unregisters from events when player leaves world for improved zoning times.
34 - Interface version 11000.
33 - Fix inventory list getting a streched texture of a scrollbar when full.
32 - I'm playing WoW again.  Interface version 10900.  
     Wtf did they do the interface version number?
29 - 31 Changes maintained by Greenman in my absence, see below.
28 - Interface version 1500.
27 - Workaround for AllInOneInventory calling my functions with bogus params.
26 - Fixed bug in tooltip mode 1 showing sell values on attribute-suffixed items
     in the hide list.
25 - Interface version 1300.
24 - Interface version 4216.
23 - Interface version 4222.
22 - Now removes attribute suffixes before checking SellValues, such as 
     " of the Monkey" (since they all sell for the same amount).
     Interface version 4211.
21 - German localization courtesy of Zett.
20 - French localization courtesy of Juki.
19 - Fixed error about the period on startup.
18 - Added /il tooltipmode.
17 - Added sounds for dialog open and close.
16 - Removed code to only get pricecheck once on an item.
15 - Added sounds for invlist open/close.
14 - Renamed no sell price to "No sell value" for consistency with merchant
13 - Added "No Sell price" tooltip to items which have no value (Malkai's Suggestion)
     Fix for disappearing values on people with other addons which jack the tooltip.
12 - Reordered some code to prevent multiple adds?
11 - Changed trigger for adding money to tip, might fix people with disappearing
     money syndrome.  Changed merchant show trigger for scan.
10 - No longer requires you to mouseover the items to get the sell price;
     just need to visit a merchant.
9 - Added /il and Show/Hide commands.  Now updates the prices if you have
		inventory list frame open while at a merchant.
8 - Aligns properly like other UI windows.
7 - Attempt to make the list window function just like inventory.
    Added cosmos button.
6 - Added shift-left and right click handlers.
5 - Fixed the "invalid order function" error, "Print is nil" error.
    Fixed column widths, added total value indicator, sorts work.
4 - Added "Include items with unknown value checkbox".  Interface v4150
3 - Added Inventory List dialog.
2 - Removed GameTooltip.xml override.
1 - Initial version

==========================================================================

Version 31 changes include:
    - updated for Interface: 1800
    - fixed MoneyTypeInfo bug in inventory window under 1.8.0
    - cleaned out unused code and generally straightened things up
    - Released:  11-Oct-2005

Version 30 changes include:
    - "/il show" and "/il hide" now recognize shift-click item links.
      This allows you to hide an item by typing "/il hide " and then
      shift-clicking the item to make a link, thus saving you from
      typing out the long name exactly right each time.
      -- Thanks to Demonhunter for this suggestion.
    - Control-clicking on items in the Inventory List window 
      now brings up the new Dressing Room window as you might expect.
    - Expanded the comments in the TOC file to include my contact
      information.
    - Released:  21-Sept-2005

Version 29 is a patch by Greenman of Lothar, to make the mod work again
under WoW v1.7.0. Changes include:
    - removed handler for TOOLTIP_ADD_MONEY event that was changed
      in v1.7.0
    - added a new replacement sub to handle OnTooltipAddMoney instead
    - Special thanks to Telo and his LootLink module for hints on 
      how to fix this.
    - Released: 14-Sept-2005

** Greenman <greenman@tragicheroes.org> **
