;AutoHotkeyU64_UIA.exe

#noEnv ; #warn
#persistent 
#SingleInstance force
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard

f1::
winGetClass, Active_WinClass , A
mouseGetPos, , , Mouse_hWnd
winGetClass, Mouse_WinClass , ahk_id %Mouse_hWnd%
if ( Active_WinClass != Mouse_WinClass ) { 	; 	unfocused
	if (Mouse_WinClass in "MozillaWindowClass,Chrome_WidgetWin_1") {
		ControlSend, ahk_parent, {f1}, ahk_class %Mouse_WinClass%
	} else 
	ControlSend, ahk_parent, {f1}, ahk_class %Mouse_WinClass%
} else 
ControlSend, ahk_parent, {f1}, ahk_class %Mouse_WinClass%
return

f2::
winGetClass, Active_WinClass , A
mouseGetPos, , , Mouse_hWnd
winGetClass, Mouse_WinClass , ahk_id %Mouse_hWnd%
if ( Active_WinClass != Mouse_WinClass ) { 	; 	unfocused
	if (Mouse_WinClass in "MozillaWindowClass,Chrome_WidgetWin_1") {
		ControlSend, ahk_parent, {f2}, ahk_class %Mouse_WinClass%
	} else 
	ControlSend, ahk_parent, {f2}, ahk_class %Mouse_WinClass%
} else 
ControlSend, ahk_parent, {f2}, ahk_class %Mouse_WinClass%
return

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return
