#noEnv ; #warn
#SingleInstance force
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard
Run, Notepad.exe,,,pid
WinWait, ahk_pid %pid%   
child := WinExist("ahk_pid " pid) 
Gui, +hwndParent +Resize
Gui, Show, w500 h500
DllCall("SetParent", "ptr", Child, "ptr", Parent)
WinMove, ahk_id %child%,, 1, 1, 480, 480
return

GuiClose:
  exitApp,
return

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return
