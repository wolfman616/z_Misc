#noEnv ; #warn
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard
;				8==========D~ ~ ~ ~				;
;					Start	...		;]						;
;Gui, Add, Button, h50 w100, My taskbar button is green!
;Gui, Show, , A Gui
WinGet, hWnd, ID , ahk_exe slsk2.exe
IconFile =  Green.ico

;hWnd  := WinExist("A Gui")
hIcon := DllCall("LoadImage", uint, 0, str, IconFile, uint, 1, int, 0, int, 0, uint, LR_LOADFROMFILE:=0x10)
PostMessage, 0x80, 0, hIcon,, ahk_id %hWnd%
PostMessage, 0x80, 1, hIcon,, ahk_id %hWnd%  

return

GuiClose:
ExitApp
return,

Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return