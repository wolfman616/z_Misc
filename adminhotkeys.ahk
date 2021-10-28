#noEnv ; #warn;#noTrayIcon
#persistent
#SingleInstance force
#MaxThreadsPerhotkey 10
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard

global M2DRAG 		:= "M2Drag.ahk ahk_class AutoHotkey"
global WMPMATT 		:= "wmp_Matt.ahk ahk_class AutoHotkey"
global WinEventScript 	:= "WinEvent.ahk ahk_class AutoHotkey"
global YTScript 			:= "YT.ahk ahk_class AutoHotkey"
global TargetScript 		:= "wmp_Matt.ahk ahk_class AutoHotkey"
global Trigger

OnMessage(0x4a, "Receive_WM_COPYDATA")
return

::btw::by the way

return

Receive_WM_COPYDATA(wParam, lParam){
	msgbox
    StringAddress := NumGet(lParam + 2*A_PtrSize)
    CopyOfData := StrGet(StringAddress)
	c= C:\Windows\system32\cmd.exe /s /k pushd "%CopyOfData%"
	run %c%,,,amd_pid
    return true
}

^!Enter::
+^!Enter::
run C:\Apps\Ph\processhacker\x64\ProcessHacker.exe
return

~rButton::
Trigger:=false
return

~rButton up::
if getKeyState("LAlt" , "P") {
	Trigger:=true
	goto dickinarse
}
return

<!rbutton:: ; Left Alt and right mouse button (doesnt work properly hence the above)
dickinarse:
TargetScript := WinEventScript, STR_ := "StyleMenu", result := Send_WM_COPYDATA(STR_, TargetScript)
BlockInput, On
SLEEP 500
BlockInput, OFF
send {lalt up}
return

~+esc::
~esc::
    if winactive("ahk_exe vlc.exe")
        WinClose
Return
return

#M::				; 		Win M
+#M::		
; not working
; TargetScript := "M2Drag.ahk ahk_class AutoHotkey"
; STR_ := "magtoggle"
; result := Send_WM_COPYDATA(STR_, TargetScript)
run C:\Program Files\AHK\Autohotkey.exe C:\Script\AHK\Working\M2DRAG_MAG.AHK ; WORKING
return

<^>!PgUp::		;		ALTgr + Page UP 	; 	Volume Up	
+<^>!PgUp::		
TargetScript := WMPMATT, STR_ := "VolUp", result := Send_WM_COPYDATA(STR_, TargetScript)
return

<^>!PgDn::	 	;		ALTgr + Page Down 	; 	Volume Up	
+<^>!PgDn::
TargetScript := WMPMATT, STR_ := "VolDn", result := Send_WM_COPYDATA(STR_, TargetScript)
return

<^>!Space::		;	ALTgr + Space
+<^>!Space::
TargetScript := WMPMATT, STR_ := "PauseToggle", result := Send_WM_COPYDATA(STR_, TargetScript)
return

<^>!Left::			;	ALTgr + Left Arrow
+<^>!Left::	
TargetScript := WMPMATT, STR_ := "JumpPrev", result := Send_WM_COPYDATA(STR_, TargetScript)
return

<^>!Right::			;	ALTgr + Right Arrow
+<^>!Right::	
TargetScript := WMPMATT, STR_ := "JumpNext", result := Send_WM_COPYDATA(STR_, TargetScript)
return

<^>!Enter:: 			;	ALTgr + Enter	
+<^>!Enter:: 		;	open current media loc & clipboard details
TargetScript := WMPMATT, STR_ := "Open_Containing", result := Send_WM_COPYDATA(STR_, TargetScript)
return

<^>!c::				;	ALTgr + C
+<^>!c::
TargetScript := WMPMATT, STR_ := "Converter", result := Send_WM_COPYDATA(STR_, TargetScript)
return

<^>!x::				; 	altGr x 
+<^>!x::
TargetScript := WMPMATT, STR_ := "CutCurrent", result := Send_WM_COPYDATA(STR_, TargetScript)
return

<^>!Del::			;	ALTgr + Del
+<^>!Del::	
TargetScript := WMPMATT, STR_ := "DelCurrent", result := Send_WM_COPYDATA(STR_, TargetScript)
return

<^>!p::			;	ALTgr + Enter
+<^>!p::			;	ALTgr + Enter
TargetScript := WMPMATT, STR_ := "Add2Playlist", result := Send_WM_COPYDATA(STR_, TargetScript)
return

<^>!s::			;	ALTgr + S
+<^>!s::
TargetScript := WMPMATT, STR_ := "SearchExplorer", result := Send_WM_COPYDATA(STR_, TargetScript)
return

<^>!i::			;	ALTgr + i
+<^>!i::			;	Search SlSK for alternatives to current
TargetScript := WMPMATT, STR_ := "CopySearchSlSk", result := Send_WM_COPYDATA(STR_, TargetScript)
return

^#x::	
+^#x::			;	ExtractAudio from youtube
TargetScript := YTScript, STR_ := "ExtractAudio", result := Send_WM_COPYDATA(STR_, TargetScript)
return

^#Space::
+^#Space::		;	ExtractAudio from youtube
TargetScript := YTScript, STR_ := "PlayPause", result := Send_WM_COPYDATA(STR_, TargetScript)
return

^#Left::			
+^#Left::	
TargetScript := YTScript, STR_ := "prev", result := Send_WM_COPYDATA(STR_, TargetScript)
return

^#Right::			
+^#Right::			
TargetScript := YTScript, STR_ := "next", result := Send_WM_COPYDATA(STR_, TargetScript)
return

Send_WM_COPYDATA(ByRef STR_, ByRef TargetScript) {
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
    SizeInBytes := (StrLen(STR_) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
    NumPut(&STR_, CopyDataStruct, 2*A_PtrSize)
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    TimeOutTime := 4000
    SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScript%,,,, %TimeOutTime%
    DetectHiddenWindows %Prev_DetectHiddenWindows%
    SetTitleMatchMode %Prev_TitleMatchMode%
    return ErrorLevel
}

Open_Script_Location:
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
sleep 1000
tooloff:
tooltip
return