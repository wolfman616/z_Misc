#NoEnv ; (MW:2022) (MW:2022)
#NoTrayicon
SetBatchLines,	-1
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
SetWinDelay,		-1
coordMode,	ToolTip,Screen
coordmode,	Mouse,	Screen
loop,parse,% "VarZ,MenuZ",`,
	 gosub,% a_loopfield
menu,tray,icon,% "HICON: " b64_2_hicon(tray64)
menu,tray,icon
r_pid:= DllCall("GetCurrentProcessId")
OnMessage(0x404,"AHK_NOTIFYICON")
OnMessage(0x2A2,"main")
main()

return,

main() {
tooltip test
}

menutray(){
	global
	send,{rbutton up}
	Menu,Tray,Show
}

menuz:
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
		default: islabel(a_thismenuitem)? timer(a_thismenuitem,-10) : ()
	}	return,1
}

AHK_NOTIFYICON(byref wParam="", byref lParam="") {
	listlines,off
	global CntHooked
	switch,lParam {
	;	case,0x200 : (!CntHooked? CntHooked:= True ;onmousehover ontrayicon set up hook to await menu.
	;			,Hookcx:= dllcall("SetWinEventHook","Uint",0x0006,"Uint",0x0007,"Ptr",0,"Ptr"
	;			, Proccx_:= RegisterCallback("onCntMen","turd"),"Uint",0,"Uint",0,"Uint",0x0))
	;;	case,0x0206: ; WM_RBUTTONDBLCLK	;	case 0x020B: ; WM_XBUTTONDOWN
	;	case,0x0201: ; WM_LBUTTONDOWN	;	case 0x0202: ; WM_LBUTTONUP
		case,0x0204: settimer,menutray,-10 ;WM_RBUTTONdn RBD Will initiate the menu RBU will select item
		case,0x0203: 	PostMessage,0x0111,%open%,,,% A_ScriptName " - AutoHotkey"
			sleep(80),tt("Loading...","tray",1) ; WM_LBdoubleclick
	}	return,
}

onCntMen(Hook,eventcx,hWnd,idObject,idChild,dwEventThread) {
	listlines,off	;aim to hook the tray menu and redirect potentially back to our own menu thread with the right button released.
	global r_pid
	static rpid
	global static hookcx, proccx_, CntHooked
	(!rpid? rpid:= r_pid)
	winget,pid,pid,ahk_id %hwnd%
	switch,eventcx {
		case,6:	if(pid=r_pid) {
			blockinput,on
			send,{rbutton up}
			sleep,10
			blockinput,off
		} else,loop,Parse,% "hookcx,proccx_",`, ;unhook on next (any other) menu.
			{	dllcall("UnhookWinEvent","Ptr",a_loopfield)
				sleep,20
				dllcall("GlobalFree",    "Ptr",a_loopfield,"Ptr")
				(%a_loopfield%) := CntHooked:= ""
			}
		case,7: loop,Parse,% "hookcx,proccx_",`,
			{	dllcall("UnhookWinEvent","Ptr",a_loopfield)
				sleep,20
				dllcall("GlobalFree",    "Ptr",a_loopfield,"Ptr")
				(%a_loopfield%) := CntHooked:= ""
			}
	}
}

reload() {
	reload,
	exitapp,
}

Varz:
global r_pid,	EDIT:=65304, open:=65407, Suspend:=65305, PAUSE:=65306, exit:=6530
,	This_PiD:= DllCall("GetCurrentProcessId")
tray64:="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"
return,