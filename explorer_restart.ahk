#noEnv ; #warn
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard
runwait C:\Apps\Kill.exe explorer.exe,, hide
runwait %comspec% /C explorer.exe,, hide
;runwait "S:\zBACKUP\_Tweak\taskbar toolbar\script\post_explorer_launch.bat",, hide

return,
Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return