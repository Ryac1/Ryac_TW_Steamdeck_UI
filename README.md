# Ryac Turtle WoW Steam Deck UI and control layout
Steamdeck UI for TurtleWow and other 1.12 servers with 40+ actionbuttons

Installation guide:
https://youtu.be/ZGRHh6pDgPY?si=1djr33Dtg1Fw7p0o

v2 overview:
https://www.youtube.com/watch?v=o0FAUSS4ZJQ

![Version_2__Turtle_WoW__112_Steam_Deck_setup_guide_with_40_b](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI/assets/133106738/d4642b87-53da-4c19-919e-dd7e0df47683)

## Jump to step:

- [Download](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI#download)
- [v2.1](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI#v21)
- [Extra addons](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI#extra-addons)
- [Target Macro](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI#target-macro)
- [Controller layout](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI#controller-layout)
- [Installation steps](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI#installation-steps)
- [Possible/known bugs](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI#possibleknown-bugs)
- [Frequently asked questions](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI#frequently-asked-questions)
- [Steam game images](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI#steam-game-images)
- [Screenshots](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI#screenshots)
- [Credits](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI#credits)

## Download: 
https://github.com/Ryac1/Ryac_TW_Steamdeck_UI/releases/download/v2.1/TW2_1.rar

Mirror: https://www.mediafire.com/file/riviil0tzhimnzz/TW2_1.rar/file

## v2.1:
This is a new release with the latest files i have been using.

Some changes i remember are:

- Added files/folders for the new PVP server (folder 'Turtle WoW' is PVP, 'Nordanaar' is PVE/RP) 
- Hunter Pet frame is now correctly in position.
- Fixed some positioning of the right side buttons.
- Some minor issues i can't remember :)
- There is also a 2.1 controller layout now added under game name "World of Warcraft" in Steam with some minor tweaks
- Added specific character profiles for Hunter,Warrior,Rogue and Druid in WTF\Account\XXXXXXX\Nordanaar (PVE) and in WTF\Account\XXXXXXX\Turtle WoW (PVP), remember to rename these folders to your own character names, this will ensure the least amount of tweaking.
  
-----------------------------------
## Extra addons
i recommend getting the following addons (that i use myself and stripped from the above file to save on space):
Get more addons here: https://turtle-wow.fandom.com/wiki/Addons

- PfQuest:  https://github.com/shagu/pfQuest/releases/latest/download/pfQuest-full.zip
- PfQuest Turtle Wow:  https://github.com/shagu/pfQuest-turtle/archive/master.zip
- LevelRange 2: https://github.com/Tenyar97/LevelRange-Turtle
- AutoDB 2: https://github.com/refaim/AutoDB2
- AUX: https://github.com/gwetchen/aux-addon-turtle
- Cooldowntimers: https://github.com/Road-block/CooldownTimers (usefull to see cooldowns on other pages, "/cdt unlock" to move frame)
- Exended Quest log 3: https://github.com/laytya/EQL3
- Equip compare: https://github.com/laytya/EQCompare-Vanilla
- Fishing buddy: https://github.com/Lexiebean/FishingBuddy
- SUCC-bag (all in one bag): https://github.com/GryllsAddons/SUCC-bag
- Trainer skills: https://github.com/refaim/TrainerSkills
- Wow Voiceover: https://github.com/mrthinger/wow-voiceover/releases/
- Shagu Plates: https://shagu.org/ShaguPlates/
- Grey auto sell: https://github.com/ttcremers/GrayAutoSell

## Target macro 

I recommend a target macro that i put on L1 actionbutton to target nearest enemies:

/run TargetNearestEnemy()

![RyacSteamDeck_macro](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI/assets/133106738/5271c3bc-a32b-43bb-8797-7aaf0f178608)


## Controller Layout
![IMG_20240218_164701](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI/assets/133106738/5477e7d4-1392-477a-8225-a0712ba84ad7)

You can find the layout if you rename the game in Steam to "World of Warcraft".
the layout is named: "Ryac's template DAB TW v2.1"

Here is a list of controls:

- L2/R2: hold to switch between button pages
- L1/R1: use middle two action buttons
- DPad: use left action buttons
- YXAB: use right action buttons
- START: Escape/Menu, hold to zoom out
- SELECT: Map, hold to Zoom in
- L4: Open all bags
- L5: Character panel
- R4: Right click
- R5: Jump
- Left track pad: UI panel menu
- right track pad: Mouse, press is left click
- Left stick: Movement, click is autorun
- Right stick: Camera, click is autorun, touch is move cursor to middle of screen

You can change anything you like to and save it as local layout.

## Installation steps

These steps are from the [installation guide video](https://youtu.be/ZGRHh6pDgPY?si=1djr33Dtg1Fw7p0o)

1. I assume you have made an account and downloaded the Turtle WoW and my file, check the description. If you have not then do this now.
2. First you go to the downloads folder and extract the turtle WoW file to you documents folder.
3. Then you extract the TW file into the downloads folder and copy both the WTF folder and Interface folder. Then paste it into the Turtle WoW folder in your documents.  Let it write into, and overwrite all files.
4. Go into the WTF folder and then into the Account folder. Rename the folder to your created account name. Use Steam plus X to get the keyboard.
5. Go into the account folder you just renamed and then into the Turtle WoW( For PVP, Nordanaar for PVE) folder. Now rename a folder to your characters name you intent to use. you can also skip this step and do it later.
6. Now open Steam from the desktop and go to 'Games', 'Add non steam game', Click 'Browse', find the 'documents folder', open the turtle wow folder. Then under 'file' type Select 'all files' and select the wow.exe file and add it to Steam.
7. Go back to your desktop and open 'Gaming Mode'.
8. Once you are in 'Gaming Mode', go to your 'library' and then 'Non Steam Games'. it should be all the way on the bottom.
9. Open Wow.exe and go to 'properties'. First rename 'wow.exe' to 'World of Warcraft'.
10. Then go to Compatibility, select the checkbox and then use Proton 7.06.
11. Then go to the controller screen, select the current layout go to search option and type in RYAC. It should find the DAB TW 2.1 layout. Press X to apply the layout.
12. Press 'Play' to start up the game. Fill in your Account name and password to log in. Make sure to select the 'Remember Account name' checkbox.
13. Create a character with the name you used to rename the character folder and log into the game.
14. When you are in the game it will probably looks like this.
15. Press Steam + X buttons to open the Keyboard. Type '/dab' and press enter.  Once DAB opens go to 'Misc Options' and under 'Load Profile' load the 'Ryac3' profile (or specific class profile) and close DAB again.
16. You can now play the game.. Because i created this character before it already shows the spells on the bars. When you first start the starterspells will be located on the L2 bars. I will show you now how to set up the UI when you do not rename a character folder first.
17. This is how it looks when you do not rename a character folder. You will need to move some elements into place. Let me show you.
18. First Open DAB by typing '/dab', Once DAB opens go to 'Misc Options' and under 'Load Profile' load the 'Ryac2' profile and close DAB again. Move the Experience bar by dragging it into place. Then  Resize the Chat window. Set Gradiant and set font size to 16 
19. The Starter spells are located on the L2 bar, you can see them when you hold down L2. You can drag them off while holding down L2.
20. You can drag your spells you need onto your bar. This time without holding L2. You can place the spells on the buttons on the right and left Plus spaces and in the middle two buttons. In the Macro buttons you should find a target macro. i recommend placing this on the L1 button.
21. Next you go to the advanced option on your start menu. I usually use the following options. Make sure to at least use the Minimap options below.
22. Drag the Turtle Wow buttons into place. To drag the big button you need to hold down Shift. you can do this by holding the open bag button down and then drag the big button into place. you can use the same trick to close the key bag.
23. I normally turn of the LFT Spam  in chat by typing in '/lft spam '. this will disable it.
24. Finally move the PF Quest window into place.  I usually turn off the big arrow and enable the minimap route. but you can choose for yourself.
25. You can zoom in and out by holding down the Select or Start buttons.
26. Here you see where to drag your spells to for the buttons to work.
27. You can hold down L2 to drag spells onto those bars.
28. Have fun :)

## possible/known bugs

- for warriors and other single spell classes, when buying new ranks (heroic strike for ex.) it will remove the button/spell from the bar for some reason, you need to do a reload once to fix it
- the Turtle Wow minimap icons sometimes do not stay in place

## Frequently asked questions

- Why can't i find the Ryac controller layout in steam?
  > Make sure you rename the game name in steam (wow.exe for ex.) to: World of Warcraft, it may take a few minutes for it to sync, i recommend restarting steam. Then search for 'Ryac' and you should find the 2.1 version, make sure to click apply layout.
- Why do i not see the profiles ingame in the /dab options?
  > Most likely you have not renamed the account folder that is named 'XXXXXX' by default in the WTF/account folder. Rename that folder to your account name and it should show correctly in game.
- Will this also work on X device?
  > Since it uses the 'on-touch' sensors and trackpads it will not work on other handheld devices. Shagu made a [controller addon](https://shagu.org/ShaguController/), you could try that. 
- How do i add spells onto the L2/R2 action buttons?
  > Make sure to hold down L2 or R2 first and then drag the spell you want onto that bar, for some reason it will not work the other way around.

## Steam game images

Right click current images to change them in Steam.

find more here: https://www.steamgriddb.com/
Tutorial: https://www.youtube.com/watch?v=kI8kSws7aS0

- Icon:
![icon](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI/assets/133106738/f87c6414-8c24-4c31-acf9-8d2c143d0226)

- Box:
![1ccc0ad70725fbdef023f6c431881114](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI/assets/133106738/baa4322d-0a26-42b9-84fe-4fc925c91284)

- Small banner:
![4e09bd41dcb70a21065f3ebdf67b605a](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI/assets/133106738/8d33db9d-f289-42ff-b294-464c3b65101e)

- Big banner:
![Wow_bg_banner](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI/assets/133106738/b9325a33-2eaa-41ca-a00a-7994df2e183b)

- Wow Logo:  
![wow_logo](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI/assets/133106738/a8e5c434-7ee1-485c-b2bb-569e12010aec)

## Screenshots
![20240218201304_1](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI/assets/133106738/890e71cf-8c5e-40e0-8908-23dc9d303e42)
![20240218164059_1](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI/assets/133106738/4666cbdd-0bf2-431f-873c-2295e795e333)

## Credits

Addons used:

- Discord Action Bars by 'Undercity' https://github.com/UndercityAddons-Vanilla/DiscordActionBars
- Moveanything by 'GryllsAddons' https://github.com/GryllsAddons/MoveAnything
- Shagu Tweaks by 'Shagu' https://shagu.org/

And ofcourse the Turtle WoW team! - https://turtle-wow.org
