#noEnv ; #warn
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard
;				8==========D~ ~ ~ ~				;
;					Start	...		;]						;

#persistent
hwnd := DllCall("CreateWindowInBand", "uint", 0, "str", "Autohotkey", "str", "title", "uint", 0, "int", 0, "int", 0, "int", 200, "int", 200, "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0, "int", ZBID_UIACCESS := 2, "ptr")
if !a_lasterror
   WinShow ahk_id %hwnd%
else 
   msgbox % a_lasterror
return,

Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return