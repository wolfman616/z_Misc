#NoEnv 
#persistent
#Singleinstance,%     "Force"
DetectHiddenWindows,% "On"
DetectHiddenText,%    "On"
SetTitleMatchMode,%   "2"		
SetTitleMatchMode,%   "Slow"
setWorkingDir,%    A_ScriptDir
SetBatchLines,%       "-1"
SetWinDelay,%         "-1"
 ListLines,%           "Off"    ;    dont4get 
coordMode,%   "ToolTip",%  "Screen"	
coordmode,%   "Mouse"  ,%  "Screen" 
#include C:\Script\AHK\- LiB\Taskbar.ahk
global ID_VIEW_VARIABLES, ID_TRAY_EDITSCRIPT, ID_TRAY_RELOADSCRIPT, ID_TRAY_SUSPEND, ID_TRAY_PAUSE, ID_TRAY_EXIT
ID_VIEW_VARIABLES := 65407
ID_TRAY_EDITSCRIPT := 65304
ID_TRAY_SUSPEND := 65305
ID_TRAY_PAUSE := 65306
ID_TRAY_EXIT := 65307
ID_TRAY_RELOADSCRIPT := 65303

menu, Tray, NoStandard
menu, Tray, Add ,% "Open", ID_VIEW_VARIABLES
menu, Tray, Icon,% "Open",%            "C:\Icon\24\Gterminal_24_32.ico"
menu, Tray, Add ,% "Open Containing",  S_OpenDir
menu, Tray, Icon,% "Open Containing",% "C:\Icon\24\explorer24.ico"
menu, Tray, Add ,% "Edit Script",      ID_TRAY_EDITSCRIPT
menu, Tray, Icon,% "Edit Script",%     "C:\Icon\24\explorer24.ico"
menu, Tray, Add ,% "Reload",           ID_TRAY_RELOADSCRIPT
menu, Tray, Icon,% "Reload",%          "C:\Icon\24\eaa.bmp"
menu, Tray, Add ,% "Suspend VKs",      ID_TRAY_SUSPEND
menu, Tray, Icon,% "Suspend VKs",%     "C:\Icon\24\head_fk_a_24_c1.ico"
menu, Tray, Add ,% "Pause",            ID_TRAY_PAUSE
menu, Tray, Icon,% "Pause",%           "C:\Icon\24\head_fk_a_24_c2b.ico"
menu, Tray, Add ,% "Exit",             ID_TRAY_EXIT
menu, Tray, Icon,% "Exit",%            "C:\Icon\24\head_fk_a_24_c2b.ico"

global mwheeldrag := []

tt("reading reg...", 300)
loop parse,% "HKCU\SOFTWARE\_MW\mousewheel", `,
{
	key_ := A_Loopfield
	Loop, Reg,% key_, KV
	{
		regRead, v_	
		mwheeldrag[A_LoopRegName] :=v_
}	}
Stylemenu_init:  ; tooltip % "Analyzing, please wait" ++++*+*+*+*
TargetHandle := "", style:=""
if Dix
	;if F 
	{
	menu, F, DeleteAll
		mousedragwh := := false 
			 mouselockdrag := false
	}
global Dix := True
MouseGetPos,,, OutputVarWin
TargetHandle := ("ahk_id " . OutputVarWin)
wingetClass, new_cl,%        TargetHandle 
wingetTitle, TargetTitle,%   TargetHandle
if !TargetTitle 
	return,
new_tt := TargetTitle
winget, new_PN,       ProcessName,% TargetHandle
winget, new_style,    Style,% 		TargetHandle
winget, new_exstyle,  ExStyle,% 	TargetHandle
WinGet, new_path,     ProcessPath,% TargetHandle
a_Path:=new_path
menu_Style_main:

if new_PN {
	if (new_PN = "ApplicationFrameHost.exe")
		if (new_tt = "Camera")
			;winget ppath, processpath, ahk_exe windowscamera.exe
			new_PN := "windowscamera.exe"
	menu,     F,   Add,%  "&Open process location   (" new_PN ")",%  "new_menu_path"

if new_hicon:=ICO2hicon(a_Path)
	menu,     F,   icon,% "&Open process location   (" new_PN ")",% "HICON: " new_hicon,,0
}
for index,element in mwheeldrag
{
	if (index=new_PN)
		if (mwheeldrag[index]="mouselockdrag")
			mouselockdrag :=true	
}
if mouselockdrag
	menu,         F,   Add,%     "remove mouselockdrag wheel", mouselockdrag
else 

if !mouselockdrag
	menu,         F,   Add,%     "Add mouselockdrag wheel",    mouselockdrag

for index,element in mwheeldrag
{
	if (index=new_PN)
		if (mwheeldrag[index]="mousedragwh")
			mousedragwh :=true 
}

if mousedragwh
	menu,         F,   Add,%     "remove mousedrag wheel", mousedragwh
else
if !mousedragwh
	menu,         F,   Add,%     "Add mousedrag wheel",    mousedragwh
return,

$v::
global VScrollDelayT_m1 := 20 ; controls vscrol sensi. (pick something between 20 - 100 
GetKeyState,  CapsSt8, CapsLock, T ;^^ ^scrol sensi^ (doesnt seem to hv desired effect))
mousegetpos,  x, y, mwin_hwnd
wingetclass,  mclass_now,  ahk_id %mwin_hwnd%
winget, mpn_, processname ,ahk_id %mwin_hwnd%

for index,element in mwheeldrag 
{
	if( mwheeldrag[index]="mousedragwh" ) {
		if (mpn_ = index) {
			mousedragwh :=true	
		continue 
}	}	} 

if !mousedragwh {
	settimer,p0ngang,-50
	return,
} else {
	initposx:=x,   initposy:=y,   init:=true, trigger3d_:=false
	while getkeystate("v","P") {
		if   ( (aggy:=y-initposy)>16) {
			if !trigger3d_
                trigger3d_:=true
			initposy   := y
			LOOP 2
				send, {wheelup}
		} else, if(aggy    < -16) {
			if !trigger3d_
				trigger3d_ := true
			initposy       := y
			LOOP 2
				send, {wheeldown}
		}
		mousegetpos, , y,bvbbbbbb
		sleep, %VScrollDelayT_m1%
	}		
	if !trigger3d_
		settimer, p0ngang, -50
	trigger3d_  := ( mousedragwh := false )
}	
return,

$b:: ; lock mouse in place and grabs at scroll via the mouse Y axis see $V for the opposite with stylus
global VScrollDelayT_m2:= 1
GetKeyState, CapsSt8, CAPSLOCK, T
mousegetpos, x, y, mwin_hwnd
wingetclass, mclass_now, ahk_id %mwin_hwnd%
winget, mpn_, processname ,ahk_id %mwin_hwnd%

for index,element in mwheeldrag 
{
	if( mwheeldrag[index]="mouselockdrag" ) {
		if (mpn_ = index) {
			mouselockdrag :=true	
			break, 
}	}	} 
if !mouselockdrag { 
	TriggerNotUsed := true 
	settimer p0n2gang,-50
	return
} else {
	initposx := x,	initposy := y, 	init:= true
	DllCall("SystemParametersInfo","UInt",0x70,"UInt",0,"UIntP",OrigMouseSpeed,   "UInt",0) ;SPI GET MOUSE VEL
	DllCall("SystemParametersInfo","UInt",0x71,"UInt",0,"Ptr",  OrigMouseSpeed*.3,"UInt",0) ;SPI sET MOUSE VEL
	blockinput, on
	
	while getkeystate("b","P") {
		DllCall("SetCursorPos", "int", x, "int", initposy) 
		blockinput, off 
		sleep, 1
		mousegetpos, , y,
		DllCall("SetCursorPos", "int", x, "int", initposy) 
		blockinput, on
		DllCall("SetCursorPos", "int", x, "int", initposy) 
			if ((aggy:= y - initposy) > 0){
				if !trigger3d_
					trigger3d_:= true
				LOOP 5
					send {wheelup}
			} else if (aggy < 0) {
				if !trigger3d_ 
					trigger3d_:= true
				LOOP 5
					send {wheeldown}
			}
		sleep, %VScrollDelayT_m2%
	}		
		
	loop 1 {
		blockinput off
		DllCall("SystemParametersInfo","UInt",0x71,"UInt",0,"Ptr",OrigMouseSpeed,"UInt",0)
		TriggerNotUsed    :=  false
		ORIGMOUSESPEEDOLD :=  OrigMouseSpeed
		if !trigger3d_
			settimer, p0n2gang, -50 
		trigger3d_        :=  false
		mouselockdrag     :=  False
		return,
	}		
	

}
return,

p0ngang:
if  trigger3d_
	TriggerNotUsed := false
else{
	GetKeyState, CapsSt8, CapsLock, T
	switch CapsSt8 {
		case "D":
			send, V
		case "U":
			send, v
	}	
	trigger3d_ :=false
}
mousedragwh:=false
return,

p0n2gang:
if trigger3d_
	TriggerNotUsed := false
else{
	GetKeyState, CapsSt8, CapsLock, T
	switch CapsSt8 {
		case "D":
			send, B
			return
		case "U":
			send, b
			return	
	}	
	return
	trigger3d_      := false
}
mouselockdrag   := false
return,

ID_VIEW_VARIABLES:
ID_TRAY_EDITSCRIPT:
ID_TRAY_RELOADSCRIPT:
ID_TRAY_SUSPEND:
ID_TRAY_PAUSE:
ID_TRAY_EXIT:
PostMessage, 0x0111, (%a_thislabel%),,,% A_ScriptName " - AutoHotkey"
return,

AHK_NOTIFYICON(wParam, lParam) {
	static init:=OnMessage(0x404, "AHK_NOTIFYICON")
	switch lParam {
		;case 0x201:  ; WM_LBUTTONDOWN
		;case 0x202:  ; WM_LBUTTONUP
		case 0x203:   ; WM_LBUTTONDBLCLK           
			tt("Loading...")
			settimer, ID_VIEW_VARIABLES,-1
			;PostMessage, 0x0111,%ID_VIEW_VARIABLES%,,,% (A_ScriptName " - AutoHotkey")
		;case 0x205: ; WM_RBUTTONUP
		;case 0x206:  ; WM_RBUTTONDBLCLK 
		;case 0x020B:  ; WM_XBUTTONDOWN 
			;	tt("fdsgg")
		case 0x0208:  ; WM_MBUTTONUP  
		tt("fdsgg")
			settimer, ID_TRAY_RELOADSCRIPT,-1
}	}

S_OpenDir:
tt(a_scriptFullPath, 1000)
Open_Containing(a_scriptFullPath)
return,