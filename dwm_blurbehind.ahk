#noEnv
#SingleInstance force
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard
aero_lib()  

#B::
Aero_StartUp()
mousegetpos,,,hw
Aero_BlurWindow(hw)
return,

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return
