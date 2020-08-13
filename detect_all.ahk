#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
global EVENT_SYSTEM_MENUPOPUPSTART := 0x0006


;Gui +LastFound
;hWnd := WinExist()

OnPopupMenu(hWinEventHook, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	if (event == EVENT_SYSTEM_MENUPOPUPSTART) {
 ;WinGet, pn, ProcessName, ahk_id %hwnd%
	
MsgBox:
 WinGetTitle, Title, ahk_id %NewID%
 WinGetClass, Class, ahk_id %NewID%
 TrayTip, New Window Opened, Title:`t%Title%`nClass:`t%Class%
}
}
Return