#noEnv ; #warn
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard
;				8==========D~ ~ ~ ~				;
;					Start	...		;]						;
e=C:\Windows\system32\schtasks.exe /run /tn "cmd_output_to_msgbox.ahk_407642875"
run %comspec% /C %E%,, hide

return,

Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return