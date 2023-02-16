a_scriptStartTime:= a_tickCount ; (MW:2022) (MW:2022)
#notrayicon
#NoEnv 
menu,tray,icon,% "C:\Icon\24\Gterminal_24_32.ico"
; #IfTimeout,200 ;* DANGER * : Performance impact if set too low. *think about using this*.
; ListLines,Off 
#persistent
#Singleinstance,	Force
DetectHiddenWindows,On
DetectHiddenText,	On
SetTitleMatchMode,	2
SetTitleMatchMode,	Slow
Setworkingdir,% (splitpath(A_AhkPath)).dir
coordMode,	ToolTip,Screen
coordmode,	Mouse,	Screen
SetBatchLines,	-1
SetWinDelay,	-1

overlay_init("ahk_Class rctrl_renwnd32","3300aa")
return,

overlay_init(win_id,colour) {
	static cnt:= 0
	cnt++
	switch,win_id {
		case,"ahk_Class rctrl_renwnd32" : bh:=29
	}
	gui,cover%cnt%:new,-dpiscale -Caption +hwndcover_hwnd%cnt% +e0x40020 +0x840000
	gui,cover%cnt%:color,% colour
	gui,cover%cnt%:show,na w%a_screenwidth% h%a_screenheight%
	winget,outlook_hwnd,id,% win_id
	oulk:= wingetPos(outlook_hwnd)
	covp:= wingetPos(cover_hwnd%cnt%)
	RE11:= DllCall("SetParent","uint",cover_hwnd%cnt%,"uint",outlook_hwnd)
	winset,transparent,40,% "ahk_id " cover_hwnd%cnt%
	win_move(cover_hwnd%cnt%,covp.x,covp.y-bh,covp.w,covp.h+bh)
}