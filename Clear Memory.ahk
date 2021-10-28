#noEnv ; #warn
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard
; Clear Memory

Gui, Margin, 10, 10
Gui, Add, ListView, w500 h600, PID|Process Name|Command Line
for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
    LV_Add("", process.ProcessID,  process.Name, process.CommandLine)
LV_ModifyCol()  
Gui, Show,, Process List 	; 	The part marked as red, process.ProcessID, contains the process ID in each iteration of the loop. And the following code can release the private working set of the given process ID. The red part is the variable for the target process ID to release the memory.

handle := DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", ProcessID)
DllCall("SetProcessWorkingSetSize", "UInt", handle, "Int", -1, "Int", -1)
DllCall("CloseHandle", "Int", handle)

for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process") {
    handle := DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", process.ProcessID)
    DllCall("SetProcessWorkingSetSize", "UInt", handle, "Int", -1, "Int", -1)
    DllCall("CloseHandle", "Int", handle)
}
return

Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return