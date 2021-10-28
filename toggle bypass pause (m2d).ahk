#noEnv ; #warn
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard
SetTitleMatchMode 2
DetectHiddenWindows on

;				8==========D~ ~ ~ ~				;
;					Start	...		;]						;

		PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey		; Use 65306 to Pause,  65303 to Reload and 65305 to Suspend.
				PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey		; Use 65306 to Pause,  65303 to Reload and 65305 to Suspend.

return,

Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return