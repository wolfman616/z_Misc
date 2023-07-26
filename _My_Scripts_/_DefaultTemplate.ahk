#NoEnv ; (MW:2023) (MW:2023)
#NoTrayicon
SetBatchLines,-1
#Persistent
#Singleinstance,Force
a_scriptStartTime:= a_tickCount 
Setworkingdir,% (splitpath(A_AhkPath)).dir
; #IfTimeout,200 ;* DANGER * : Performance impact if set too low. *think about using this*.
; ListLines,Off 
DetectHiddenWindows,On
DetectHiddenText,	On
SetTitleMatchMode,2
SetTitleMatchMode,Slow
SetWinDelay,-1
coordMode,	ToolTip,Screen
coordmode,	Mouse,	Screen
loop,parse,% "VarZ,Menus,Hookinit",`,
	 gosub,% a_loopfield
menu,tray,icon,% "HICON: " b64_2_hicon(smicon64)
menu,tray,icon

onexit,exit
OnMessage(0x6,"activ8")
OnMessage(0x404,"AHK_NOTIFYICON")

return,

onMsgbox(HookCr,eventcr,hWnd,idObject,idChild,dwEventThread) {
	winget,pid,pid,ahk_id %hwnd% 
	if(pid!=r_pid)
		return,	;if its our mbox change icon
	activ8(wparam="",lparam="",msg="",hwnd)
}

Hookinit:
HookMb:= dllcall("SetWinEventHook","Uint",0x0010,"Uint",0x0010,"Ptr",0,"Ptr"
, ProcMb_:= RegisterCallback("onMsgbox",""),"Uint",0,"Uint",0,"Uint",0x0000) ;WINEVENT_OUTOFCONTEXT:= 0x0000
return,

exit:
menu,tray,noicon
gosub,unhook
ExitApp,


unHook:
if(FileExist(TEMP_FILE))
	FileDelete,%TEMP_FILE%
else,sleep,300
dllcall("UnhookWinEvent","Ptr",ProcMb_)
sleep,20
dllcall("GlobalFree",    "Ptr",ProcMb_,"Ptr")
(%ProcMb_%):= ""
dllcall("UnhookWinEvent","Ptr",HookMb)
sleep,20
dllcall("GlobalFree",    "Ptr",HookMb,"Ptr")
(%HookMb%):= ""
return,









main() {

}

activ8(wparam="",lparam="",msg="",hwnd="") {
	local static smicon:= b64_2_hicon(smicon64)
	, lgicon:= b64_2_hicon(lgicon64)
	,large:=1, small:=0, m:= 0x80
	SendMessage,m,small,smicon,,ahk_id %hWnd% ;WM_SETICON,ICON_SMALL
	SendMessage,m,large,lgicon,,ahk_id %hWnd% ;WM_SETICON,ICON_LARGE
	Return,ErrorLevel
}

MenuTray:
mousegetpos,,,hwnd,CN
if(instr(CN,"ToolbarWindow")) {
	send,{RButton Up}
	Menu,Tray,Show
} return,

Menus:
menu,Tray,NoStandard
menu,Tray,Add,%	 splitpath(A_scriptFullPath).fn,% "do_nothing"
menu,Tray,disable,% splitpath(A_scriptFullPath).fn
menu,Tray,Add ,% "Open",%	"MenHandlr"
menu,Tray,Icon,% "Open",%	"C:\Icon\24\Gterminal_24_32.ico"
menu,Tray,Add ,% "Open Containing",%	"MenHandlr"
menu,Tray,Icon,% "Open Containing",%	"C:\Icon\24\explorer24.ico"
menu,Tray,Add ,% "Edit",%	"MenHandlr"
menu,Tray,Icon,% "Edit",%	"C:\Icon\24\explorer24.ico"
menu,Tray,Add ,% "Reload",%	"MenHandlr"
menu,Tray,Icon,% "Reload",%	"C:\Icon\24\eaa.bmp"
menu,Tray,Add,%	 "Suspend",%	"MenHandlr"
menu,Tray,Icon,% "Suspend",%	"C:\Icon\24\head_fk_a_24_c1.ico"
menu,Tray,Add,%	 "Pause",%		"MenHandlr"
menu,Tray,Icon,% "Pause",%		"C:\Icon\24\head_fk_a_24_c2b.ico"
menu,Tray,Add ,% "Exit",%		"MenHandlr"
menu,Tray,Icon,% "Exit",%		"C:\Icon\24\head_fk_a_24_c2b.ico"

;msgb0x((ahkexe:= splitpath(A_AhkPath)).fn
;,	 (_:= (splitpath(A_scriptFullPath).fn) " Started`n@ " time4mat() "   In:  "
;.	_:= (a_tickCount-a_scriptStartTime) " Ms"),3) ;sleep,100 ;_:=""

a_scriptStartTime:= time4mat(a_now,"H:m - d\M")
menu,Tray,Tip,% splitpath(A_scriptFullPath).fn "`nRunning, Started @`n" a_scriptStartTime
do_nothing:
return,

MenHandlr(isTarget="") {
	listlines,off
	switch,(isTarget=""? a_thismenuitem : isTarget) {
		case,"Open Containing": TT("Opening "   a_scriptdir "..." Open_Containing(A_scriptFullPath),1)
		case,"edit","Open","SUSPEND","pAUSE":
			PostMessage,0x0111,(%a_thismenuitem%),,,% A_ScriptName " - AutoHotkey"
		case,"RELOAD": reload()
		case,"EXIT": exitapp
		default: isLabel(a_thismenuitem)? timer(a_thismenuitem,-10) : ()
	}	return,1
}

AHK_NOTIFYICON(byref wParam="", byref lParam="") {
	listlines,off
	switch,lParam {
		case,0x0204: settimer,MenuTray,-10 ;WM_RBUTTONdn RBD Will initiate the menu RBU will select item
		case,0x0203: 	PostMessage,0x0111,%open%,,,% A_ScriptName " - AutoHotkey"
			sleep(80),tt("Loading...","tray",1) ; WM_LBdoubleclick
	}	return,
}

reload() {
	reload,
	exitapp,
}

Varz:
global r_pid,	smicon64, lgicon64, EDIT:=65304, open:=65407, Suspend:=65305, PAUSE:=65306, exit:=6530
,	r_pid:= DllCall("GetCurrentProcessId")
smicon64:="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"
lgicon64:="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"
return,