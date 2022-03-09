#noEnv 	;#warn
SetControlDelay, 20
SetKeyDelay, 20
#persistent
#InstallKeybdHook
#singleInstance,     	Force
;#KeyHistory,         	1
;ListLines,           	On
#maxhotkeysPerInterval, 1440
#maxThreadsPerhotkey,	10
DetectHiddenText, 		On
DetectHiddenWindows, 	On
settitlematchmode,		2
setbatchlines,        	-1
SetWinDelay,         	-1
coordMode,		Mouse,	Screen
coordMode, 		Pixel,	Screen
coordMode, 	  Tooltip,	Screen
sendMode,            	Input
setWorkingDir,      	%A_ScriptDir%
Init_4gain :=  False,   UndoRate   :=  300
DbgTT      :=  True,    TT := -666 	; def tooltip time
global explorer, desktop ; Define group: -=Explorer windows=-=-=-=-=-=-
GroupAdd, Explorer, ahk_class CabinetWClass
GroupAdd, Explorer, ahk_class Progman 
GroupAdd, Explorer, ahk_class WorkerW
GroupAdd, Explorer, ahk_class ExploreWClass
GroupAdd, Desktop,  ahk_class Progman 
GroupAdd, Desktop,  ahk_class WorkerW
---------=========----------============--------------===========----
global 	TrayIconPath		:= 	"C:\Icon\256\ICON5356_1.ico", 
;-=========-------------=========----------============--------------===========----	; BLOCK KEYS PER TITLE
global 	BList_NmPad 		:= 	"ahk_class MozillaWindowClass,ahk_exe wmplayer.exe"
global 	BList_F1_12 		:= 	"ahk_eXe notepad++.exe,ahk_Group Desktop,ahk_class MozillaWindowClass"
global 	BList_Arr0w 		:= 	"ahk_class MozillaWindowClass,ahk_Group Desktop"
global 	WList_Arr0w 		:= 	;"ahk_class MozillaWindowClass,ahk_Group Desktop"
global 	BList_num0_9 		:= 	"ahk_Group Explorer,YouTube," ;			<---; NOT IMPLEMENTED !!!
;-=========-------------=========----------============--------------===========----	; Esc 2 Quit ExEs
global 	EscCloseWL_Exe 		:= 	"vlc,fontview,WMPlayer,RzSynapse,ApplicationFrameHost,Professional_CPL,"
global 	EscCloseAskWL_Exe 	:= 	"regedit"
;-=========-------------=========----------============--------------===========----	; c 	hole
M2dLB_resize		:= 	True
keybypass_Arrows	:= 	True
keybypass_Numpad	:= 	True
keybypass_FKeys 	:= 	True
DbgTT				:= 	True
;-=========----
gosub, 	Varz
gosub, 	Menus
gosub, 	Binds
gosub, 	m41n
RETURN,
;-=========----
;-=========----
m41n:
onExit, Rid_Karma

wm_allow()

OnMessage(0x4a, "Receive_WM_COPYDATA")

return,    
   
Paste:
SendInput, {Raw}%clipboard%
return
;traytip,GHHG,% "ADMhotkeyS LOADED",
	
Binds:	; -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~hotkeys-~-~-~-~-~-	-~-~-~-~	~-~-~-~- ~-~-~-
gosub, 	Digits_MAIN
gosub, 	arrow_bypasscheck
gosub, 	KBypass_f1_12_Enable ;gosub, 	f1_f12_bypasscheck
gosub, 	togl_numpad_i
hotkey, IF
hotkey, %loou%, 2_knuckle_Shuffle, on
; hotkey, ~LAlt, 		Wt_, 		On 
hotkey, ^!Enter, 	phLaunch, 	on		
hotkey, IfWinActive, ahk_class ConsoleWindowClass
hotkey, ^V, Paste, ON
hotkey, %pooo%, 2_knuckle_Shuffle, on
; hotkey, ^Up, 2_knuckle_Shuffle, on
; hotkey, ^down, 2_knuckle_Shuffle, on  
; hotkey, Delete,   delete_bypass_custom, on		
; hotkey, +Delete, 	KB_SendSelf_Unshifted, on		
; hotkey, +!Delete, KB_SendSelf_UnControlled, on
; hotkey, IfWinNotActive , 	% "ahk_class " A_LoopField
; hotkey,  <^>!Space,		PauseToggle, on
 ; -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~HotStrings-~-~-~-~-~-~-~-~	~-~-~-~-	-~-~-~-~ -~-~-~
::btw::		by the way		                                                             
::myemail:: % email		                                                             
; -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~BINDS-~-~-~-~-~-~-~-~-~-~-	-~-~-~-~	~-~-~-~- ~-~-~-
;'$$$$$$$$$$$$$$$$$$$£££££££££££££££££££££££££££££££££""""""	""""""""	$$$$$$$$ $$$$$$
; 	-~-~-~-~-~-~ 	Win M 	-~-		Magnifier Toggle 		-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
; #M::  			;		ALTgr + Right Arrow
; +#M::	
; TargetScript := winevent, STR_ := "mag_", result := (Send_WM_COPYDATA(STR_, TargetScript))
return,
Digits_MAIN:			;	digits keywrap
loop 9 {
			h_KI      := A_index
		;	Shift_KI  := ( "+" . A_index )
	hotkey,	%A_index%, Digits_0_9, on
	;hotkey,	%Shift_KI%, 	Digits_0_9
}
hotkey, 0,  Digits_0_9, on
;hotkey, +0, Digits_0_9
return,

LAlt & rbutton::
ttp("sent")
settimer, StyleMenu_FixLaunch, -1
return

~rbutton::
mousegetpos, x, y, LB_hWnd
return

~$^Lbutton::	                                                                     
~Lbutton::                                                                           
Active_hwnd := 	WinExist("A")
WinGetClass, class_active, A
LB_cWnd22	:=
MouseGetPos,	X_Cursor1, 	Y_Cursor1, 	, 	LB_cWnd22,
wingetClass, 	Class,%  "ahk_id " LB_hWnd
if getKeyState("Rbutton", "P") {
	if (Class = "WorkerW")
		return,
	if Bypass_pname_True || Bypass_Class_True
		Trigger_bypassed 	:= 	True
	if Bypass_Class_True
		Trigger_bypassed 	:= 	True
		mousegetpos, 	X_mSt4, 	Y_MSt4, 
		wingetpos, 		X_Wins, 	Y_Wins, 	W_Wins, 	H_Wins, 	ahk_id %LB_hWnd%
		winGetClass, ClassN, % ( id_ . LB_hWnd),
		;if ClassN != CabinetWClass	;msgbox % ClassN
	if (Class = "CabinetWClass") {
		PostMessage, %WM_LB_down%, %WMResize_N_W%,% "ahk_id " LB_cWnd22
		while getKeyState("Lbutton", "P")
			sleep 1
		Send {LButton up} ; or  click up ; IMPORTANT : NEEDED IF NOT HOOKED LBUTTONUP ELSEWHERE OR CTRL ADDED TO DRAG WILL DIE!
		return,
	} else {
		if !rbt_ {
		;	PostMessage, %WM_LB_down%, %WMResize_S_E%,% "ahk_id " LB_cWnd22
			wingetpos, 	X_Wins, Y_Wins, W_Wins, H_Wins, ahk_id %LB_hWnd%
			MouseGetPos,X_mSt4, Y_MSt4, ,LB_cWnd22
			wingetpos, 	X_Win, 	Y_Win, 	W_Win, 	H_Win, 	ahk_id %LB_hWnd%
			MouseGetPos,X_Cursor1 ,Y_Cursor1 , , LB_cWnd22
			x_winn := ""
			gosub, Watch_Lb
			gosub, corner_offset_get
			rbt_ := True
		} else, gosub, DimensionChk
	}
	while( getKeyState("Lbutton", "P")) { 
		mousegetpos, 	X_Cursor1, Y_Cursor1
		wingetpos, 		X_Win, 	Y_Win, 	W_Win, 	H_Win, 	ahk_id %LB_hWnd%
		;tooltip % X_mSt4 " " y_mSt4 "`n" X_Cursor1 " " Y_Cursor1
		gosub, 	Watch_Lb
		gosub, 	DimensionChk
		xx := (x0x - XOff),	yy := (y0y - YOff)
		Win_Move(LB_hWnd, xx, yy, wii, hii, "")
	}
rbt_ := False	
}
return,
;[][][][][][][][][][][][][][]
StyleMenu_FixLaunch:
StyleMenu_trigger := False
result := Send_WM_COPYDATA("StyleMenu", EventScript)
return,
;[][][][][][][][][][][][][][]
Wt_:
if dbgtt
	tooltip,% "menuinit"
hotkey, ~LAlt, Wt_, off
hotkey, LAlt, zzz, on
KeyWait, LAlt
settimer, BlockInput_Toggle, -1
hotkey, ~LAlt, Wt_, off
sleep 1
hotkey, LAlt, zzz, off
return,
;[][][][][][][][][][][][][][]
#e::
zzz:
ttp(( a_now . "`n" . nigg))
return,
;[][][][][][][][][][][][][][]
^+Delete::
Del_this := A_thishotkey
WinGetClass, cl_s, A
if (instr(ExplorerClss,cl_s)) { 	; 	sendself_no_ctrl:
	ControlGetFocus, cnt, % "ahk_id " (handl := winactive("a"))
	if (InStr(cnt, "Edit")) 
		 Del_this  := strreplace(Del_this, "^+")
	else, Del_this := strreplace(Del_this, "^" )
	send {%Del_this%}
	if (InStr(Del_this, "+")) 
	a3 		  :=  "Shift-"
	else, a3  :=  "Normal "
	ttp(( a3  .   "Delete"))
} else {
	send {%A_thishotkey%}
	if DbgTT_advanced
		ttp("Sent: Ctrl, Shift & Del")
}
return,
$delete::
WinGetClass, cl_s, A
if (instr(ExplorerClss,cl_s)) { 	; 	sendself_no_ctrl:
	handl := winactive("a")
	ControlGetFocus, Ct_fc, ahk_id %handl%
	if (instr("Edit1",Ct_fc)) { 	; 	sendself_no_ctrl:
		send {delete}
		sleep 1
		return,
	} else, 
if (instr(ExplorerCnts,Ct_fc)) {	; 	sendself_no_ctrl:
	BT := A_THISHOTKEY
	gosub, TT
	}
} else {	; all other classes
	send {delete}
	if DbgTT_advanced
		ttp("Delete Not Suppressed undefined", "-500")
}
handl := ""
return,

$+Delete::
turds:=Explorer_GetSelection()
loop, parse, turds, `n,
	ct4 := a_index
if ct4 > 1
	FileStrCc := ct4 . " items"
else, {
	SplitPath, 	turds,,, OutExtension, OutNameNoExt,
	FileStrCc := (OutNameNoExt . "." . OutExtension)
}
msgbox,0x2121, Confirm Deletion, % ("Send " FileStrCc " to RecycleBin?")
ifmsgbox ok
	msgbox, 0x2131, % "Del?...Sure?", R U sH0Re?....`n`nhuhu
	ifmsgbox, ok		;if ct4 > 1	;loop, parse, turds, `n,;filerecycle,% a_loopindex
		filerecycle,% turds
	return,
; 	'-~_~_~_~_~_~_~_ UN-DO MO-FO _~_~_~_~_~_~_~-'	 	'-~_~_~_~_~_~_~_ UN-DO MO-FO _~_~_~_~_~_~_~-'	 	'-~_~_~_~_~_~_~_ UN-DO MO-FO _~_~_~_~_~_~_~-'	
; UNDO MOFO
$^z:: 				;			"Ctrl Z" - bypass "Undo." in Explorer.exe
$^y:: 				; 			"Ctrl Y" - bypass "Redo". in Explorer .exe
if !(winactive("ahk_Group Explorer"))
	  gosub, nodollarsend
else, if    (edit_dtect()) 
	  gosub, nodollarsend
else, {
	BT := A_THISHOTKEY
	gosub, TT
}
return,

TT:
IF !bt
	BT := A_THISHOTKEY
if (bt contains "$"  &&	bt != $)
	bt := strreplace(	bt, "$") 
if (bt contains "^"  &&	bt != $)
	bt := strreplace(	bt, "^", "Control + ")
if (bt contains "!"  &&	bt != $)	
	bt := strreplace(	bt, "!", "Alt + ")
ttp(	bt " Disabled."	, 	"-300" ) 
BT :=""
return,

^#i:: 	; Press ctl 1 to make the color under the mouse cursor invisible.
mouseGetPos, MouseX, MouseY, MouseWin
pixelGetColor, MouseRGB, %MouseX%, %MouseY%, RGB
WinSet, TransColor, Off, ahk_id %MouseWin%
ttp( (msg := ( MouseRGB . " Will BE MADE TRANS_COLOR`n" . MouseX . ", " . MouseY . "`n" . MouseWin)))
WinSet, TransColor, %MouseRGB% 200, ahk_id %MouseWin% 	;	 WinSet, TransColor, 0xFFFFFF, ahk_id %MouseWin%
return,

~$esc::
$+esc::
#hotkeyInterval 1000
winGet ProcN, ProcessName,% "ahk_id " (handl3	:=	winactive("a"))
ProcN := strreplace(ProcN, ".exe")
if ProcN in %EscCloseWL_Exe%
{
	ttp((ProcN . ", Closing..."))
	WinClose
} else, if ProcN in %EscCloseAskWL_Exe%
{ 
	msgbox, 262209, Close %ProcN%? , Closing.`nTimeout in 4 Sec`nIssue forth,4 ; Icon Asterisk (info) 64 0x40 ;; Icon "Question" 32 0x20 ; ; WS_EX_TOPMOST 	262144 	0x40000 ;; 	OK/Cancel 1 0x1 ;	Yes/No 4 0x4 ; ; System Modal (top) 4096 0x1000 
	;ifmsgbox OK		
	if ((ifmsgbox Cancel) || (ifmsgbox no))	
	{
		traytip,% "ESC_2_CLOSE",% "Cancelled"
		return,
	} else, WinClose
} else {
IfWinActive, Get Parameters ahk_exe AutoHotkey.exe 
	winClose, 	
	if winactive(cls_IMGGLASS[1])
	winClose, % cls_IMGGLASS[1]
	if !trigg3r3d {
		trigg3r3d := True
		mousegetpos , , , winz
		WinGetClass, aaa ,  ahk_id %winz%, 
	}
	if aaa = #32768
		ok2esc := true 
	else, if fag:=instr(aaa,"CustomizerGod")
	{
		WinGetActiveStats, Title, Width, Height, X, Y		
		if ((Width < 1220) && (height < 830))
			winclose,
	} else {
		escaped:=True
		send {Esc}
}	}
return,
$esc up::
$+esc up::
if (ok2esc || escaped) {
	trigg3r3d := False, ok2esc := false, escaped := False
	if    escaped 
		  send {esc up}
	else, send {esc}
}
#hotkeyInterval %hi%
return,
; SUPPRESS HOTKEY-PAIR @ DESKTOP-MOUSE-OVER ! : @@~~~ EG CTRL + MWHEEL TO ZOOM

^WheelUp::      
^Wheeldown::      
2_knuckle_Shuffle:
ttp(a_now)
mousegetpos, , , mHwnd
WinGetClass, mclss,% (mhnd := ("ahk_id " . mHwnd))
if !instr("WorkerW,Progman", mclss) ; desktop
	settimer HK_PairSend, -1
return

HK_PairSend:    
	hK := StrSplit(A_Thishotkey , , , 2)
	switch hK[1] {
		case "!":
			HK[1] := "Alt"
		case "^":
			HK[1] := "Control"
		case "+":		
			HK[1] := "Shift"
		default:
			msgbox,% HK[1] ": unrecognised hkotkey prefix."
	}
	send,% "{" . (hk[1]) . "}" . "{" . (hk[2]) . "}"
			;msgbox,% "{" (hk[1]) "}" "{" (hk[2]) "}"
	
return,

+^Delete::+Delete
!Shift::   ;   -~-~-~-~-~-~   ;   input-locale selector gui hotbind bypass   -~-~-~-~-~-~
+Alt::
if w10_LocaleGui_Allowed
		send, {%A_Thishotkey%}
else, ttp("shift-alt blocked (inputlocale bypass)")
return,
	;	>>>-------------======-------------------------======------------- WACOM TABlet Stuff -------------======------------- >
	;       Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad
+F9::     ;-------------======-------------     WACKEM STYLUS NIB EVENT     ^^-------------======-------------
ttp("Nib Down")
send {LButton Down}
return,
+F9 up::
ttp("Nib Up")
send {LButton Up}
return,

$insert::	 	; -------------======------------- 	GIMP Undo = Stylus button && GIMP ReDo = Ctrl + stylus button 1 	-------------======-------------
if !(winactive("ahk_exe gimp-2.10.exe")) {
	;hotkeySendSelf(A_thishotkey)	;		undo 		-------------=============------------- 		 			undo 	
	send {insert}
	return,
} else {
	sleep 20
	send {escape}
	sleep 70
	send ^z
	while getKeyState,insert
		ttp(a_now)
; settimer, dbgtt_nibdown5, -%UndoRate%
}	
return,

$^insert::	 
send {escape}	 			; 		get rid of annoying hardcoded Rbutton menu popup in GIMP 
send ^Y
if !(winactive("ahk_exe gimp-2.10.exe")) {
	hotkeySendSelf(A_thishotkey)	;		undo 		-------------=============------------- 		 			undo 		
	return,
} else {
	sleep 20
	send {escape}
	sleep 70
	send ^y
	while getKeyState,insert {
		tooltip,% A_NOW ; settimer, dbgtt_nibdown5, -%UndoRate%
}	}
return,

; g i m p routed Mouse1 / pen nib 1 -----=====-----; g i m p routed Mouse2 / undo barrel 1
 ~#F10:: ;~ sending thru to m2drag
click right down
ttp("Barrel 1 Down")
return,
~#F10 up::
click right up
ttp("Barrel 1 Up")
return,
~!f13::
ttp("rotate CW")
return,
~!f14::
ttp("rotate C-CW")
return,
~+wheeldown::
ttp("2 Finger swipe L")
return,
~+wheelup::

ttp("2 Finger swipe R")
return,

~^!z::
ttp("3 finga tap")
return,
~^+!#h::
ttp("4 finga upswipe")
return,
~#Tab::
ttp("4 finga downswipe")
return,
~!^+u:: 
ttp("5 finga downswipe")
return,
~^+f6:: 				;		ctrl shift F6 
ttp("5 finga tap")
return,

XButton1::			 	;		System Back and Forward
XButton2::				;		MOUSE BUTTONS BACK / FWD 
A_hwnd := WinExist("A")
winGetClass, a_Class, ahk_id %A_hwnd%
if (A_Class = "MultitaskingViewFrame") {
	Send !{tab} 
	return,
} else, 
if (A_Class = "WorkerW")
	ttp("D-Top (Not Implemented")
else, send {%A_thishotkey%}
return,

;	 -~-~-~-~-~-~-~-~--~>>   Bypass   >>-~--~-~-~-~-~-~-~-~-~-~>>
winGet ProcN, ProcessName, ahk_id %A_hwnd%
for k, v in PName {
	if (v = ProcN)
		GOSUB hotkeySendSelf
}
Swipe(A_hwnd, a_thishotkey)
return,

<^>!PgUp::				;		ALTgr + Page UP 	; 	Volume Up	
;+<^>!PgUp::		
TargetScript := WMPMATT, STR_ := "VolUp", result := (Send_WM_COPYDATA(STR_, TargetScript))
return,
<^>!PgDn::	 			;	ALTgr + Page Down 	; 	Volume Up	
;+<^>!PgDn::
TargetScript := WMPMATT, STR_ := "VolDn", result := (Send_WM_COPYDATA(STR_, TargetScript))
return,
<^>!Space::				;	ALTgr + Space
;+<^>!Space::
TargetScript := WMPMATT, STR_ := "PauseToggle", result := (Send_WM_COPYDATA(STR_, TargetScript))
return,
<^>!Left::				;	ALTgr + Left Arrow
+<^>!::	
TargetScript := WMPMATT, STR_ := "JumpPrev", result := (Send_WM_COPYDATA(STR_, TargetScript))
return,
<^>!Right::	 			;	ALTgr + Right Arrow
;+<^>!Right::	
TargetScript := WMPMATT, STR_ := "JumpNext", result := (Send_WM_COPYDATA(STR_, TargetScript))
return,
<^>!Enter:: 			;	ALTgr + Enter	
;+<^>!Enter:: 			;	open current media loc & clipboard details
TargetScript := WMPMATT, STR_ := "Open_Containing", result := Send_WM_COPYDATA(STR_, TargetScript)
return,
<^>!c::					;	ALTgr + C
;+<^>!c::	
TargetScript := WMPMATT, STR_ := "Converter", result := Send_WM_COPYDATA(STR_, TargetScript)
return,
<^>!x::					;	ALTgr x 
;+<^>!x::
TargetScript := WMPMATT, STR_ := "CutCurrent", result := Send_WM_COPYDATA(STR_, TargetScript)
return,
<^>!Del::				;	ALTgr + Del
;+<^>!Del::	
TargetScript := WMPMATT, STR_ := "godie", result := Send_WM_COPYDATA(STR_, TargetScript)
return,
<^>!p::					;	ALTgr + Enter
;+<^>!p::			
TargetScript := WMPMATT, STR_ := "Add2Playlist", result := Send_WM_COPYDATA(STR_, TargetScript)
return,
<^>!f::					;	ALTgr + f
+<^>!f::	
TargetScript := WMPMATT, STR_ := "SearchExplorer", result := Send_WM_COPYDATA(STR_, TargetScript)
return,
<^>!s::					;	ALTgr + s
+<^>!s::				;	Search SlSK for alternatives to current
TargetScript := WMPMATT, STR_ := "CopySearchSlSk", result := Send_WM_COPYDATA(STR_, TargetScript)
return,
^#x::	
+^#x::					;		ExtractAudio from youtube
TargetScript := YTScript, STR_ := "ExtractAudio", result := Send_WM_COPYDATA(STR_, TargetScript)
return,
^#Space::				;Youtube Audio-Xtract 
+^#Space::				; CTRL - WIN - SPACEBAR
TargetScript := YTScript, STR_ := "PlayPause", result := Send_WM_COPYDATA(STR_, TargetScript)
return,
^#Left::				; Youtube Prev			
+^#Left::				; CTRL-WIN-LEFTARROW
TargetScript := YTScript, STR_ := "prev", result := Send_WM_COPYDATA(STR_, TargetScript)
return,
^#Right::				; Youtube Next
+^#Right::				; CTRL-WIN-LEFTARROW			
TargetScript := YTScript, STR_ := "next", result := Send_WM_COPYDATA(STR_, TargetScript)
return,

ttp(TxT = "", ti="") {
if dbgtt {
		tooltip, % TxT,
		if ti
			  settimer, TT_Off,% ti
		else, settimer, TT_Off,% tt
}	}

TT_Off:
tooltip,
return
return,

Receive_WM_COPYDATA(wParam, lParam) {				
	StringAddress := NumGet(lParam + 2*A_PtrSize)		 
	CopyOfData := StrGet(StringAddress) 						 
	msgbox,% CopyOfData " sds!"									
	C_Str=C:\Windows\system32\cmd.exe /s /k pushd "%CopyOfData%"	
	return, True
}

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
	return, errorlevel
}

Swipe(hwnd, hotkey) {
	if !hwnd {
		send !{tab}
		send +!{tab}
		return,
	}
	if ( hotkey = "XButton1") {
		send #{Left}
		ttp("Bk-butt")
	} else {
		if ( hotkey	= "XButton2") {
			send #{Right}
			ttp("Fwd butt")
		} else, Msgbox % "other back fwd buttons pls consult the p===---"
	}
	WinWaitActive, ahk_class MultitaskingViewFrame,, 2
	if (winactive("ahk_class MultitaskingViewFrame")) {
		S_hwnd := wineXist("A")
		if (S_hwnd = hwnd) {
			Send !{tab} 
			ttp("alt tabbed")
			return,
		} else {	;	ActivateWin(hwnd, -10)
			winactivate, AHK_ID %hwnd%,, 2		
			if errorlevel
				msgbox % errorlevel		
		}
		WinWaitActive, AHK_ID %hwnd%,, 2
	}
	x_hwnd := hwnd
}

ActivateWin(hwnd, delay) {
	if !hwnd { 
		send !{tab} 
		ttp("Failed, rem")
	} else {
		if !Delay
			Delay := -100	
		Act_handle_str := ("ahk_id " . hwnd ), Act_DelayT := delay
		settimer, Act_Then, %Act_DelayT% 
		return,
		
		Act_Then:
		winactivate %Act_handle_str%
		WinWait, Act_handle_str,, 2
		if winactive(Act_handle_str) {
			Act_DelayT := "", Act_handle_str := ""
			return, 1
		} else, return, 0
}	}

Digits_0_9: 	;	 disable digit-keys ( for youtube mainly )

; handle := winactive("A")
; winGet ProcN, ProcessName, ahk_id %handle%
; if ( ProcN = "firefox.exe" ) {
ifwinactive, ahk_exe firefox.exe
	if shif not in %A_Thishotkey%
	{
		WinGetActiveTitle, Title_Active
		if 	Title_Active contains YouTube 
			traytip, YouTube, % "Numbers disabled`nPress Shift with them...", 1, 34
		else, gosub, KB_SendSelf
	} else, gosub, KB_SendSelf
return,

togl_numpad:	; numpad bypass
numpadkeys_str := ""
keybypass_Numpad := !keybypass_Numpad
togl_numpad_i:

;if keybypass_Numpad {
	;menu, tray, check, Disable Numpad
	;if !num_init_trigger {
		;num_init_trigger := true
		loop, 10		{
			aa := (a_index - 1)
			Loop, Parse, BList_NmPad, `,
			{
					;MSGBOX %A_LoopField%  
				;if A_LoopField contains £
				;{
				;	loop, parse, A_LoopField, £,
				;	{
							;MSGBOX %A_LoopField%3
					;	if a_index = 1
					;		1st := A_LoopField
						;if a_index = 2
					;		2nd	:= A_LoopField
				;	}
					;hotkey, IfWinActive,% 1st,% 2nd
			;	}
			;	else, 
			;	{
				hotkey, IfWinActive,% A_LoopField
				hotkey,  Numpad%aa%, TT, on
	}
				; if   numpadkeys_str
				     ; numpadkeys_str := (numpadkeys_str . "," . "Numpad" . aa)
				; else,numpadkeys_str := ("Numpad" . aa)
		}	
		Loop Parse, num_others, `,
		{
			bb := A_LoopField
			Loop Parse, BList_NmPad, `,
			{
				hotkey, IfWinActive, %A_LoopField% 
				hotkey, % bb, TT, on
				;numpadkeys_str := (numpadkeys_str . "," . bb)
			;	key_NumP_ar.Push(bb)	
		}	}
		;}
		RETURN
	;} else {
	;	for index, element in key_NumP_ar
		;	hotkey, % element, TT
	;}
; } else {
	; menu, tray, uncheck, Disable Numpad
	; if !num_init_trigger {
		; num_init_trigger := true
		; loop, 10 {
			; cc := (a_index-1)
			; Loop, Parse, BList_NmPad, `,
			; {
			; MSGBOX % A_LoopField
				; hotkey, IfWinActive, % A_LoopField
				; hotkey, % "Numpad" . cc, TT
				; }
			;	numpadkeys_str := (numpadkeys_str . "," . "Numpad" . cc)
				;key_NumP_ar.Push("Numpad" . cc)
		; }
		; Loop, Parse, num_others, `,
		; {
			; Loop, Parse, BList_NmPad, `,
			; {
				; hotkey, IfWinActive, % A_LoopField
				; hotkey, % A_LoopField, TT
				; }
			;	numpadkeys_str := (numpadkeys_str . "," . A_LoopField)
				;key_NumP_ar.Push(A_LoopField)	
		; };
	; } else {
		; for index, 	element in key_NumP_ar
			; hotkey,	% element, off
; }	}
; return

F1_F12_Toggle:
keybypass_FKeys := !keybypass_FKeys
f1_f12_bypasscheck:
if keybypass_FKeys {
	 GOSUB KBypass_f1_12_Enable
} else, {
 if KBpF112_Init
	 GOSUB KBypass_f1_12_Disable
}
return,

msgbox, this will never appear

KBypass_f1_12_Enable:
loop, 12 {
	if a_index = 1
		hotkey, F1, f1_bypassed_explorer, on
	else, {	
		tyt  := ("F" . A_Index)

		Loop Parse, BList_F1_12, `,
		{
			hotkey, IfWinActive, %A_LoopField%
			hotkey, %tyt%, TT, on
		}
		hotkey, If
}	}	
kbpf112_init := True
return,

KBypass_f1_12_Disable:
loop 12
	hotkey % ("F" . A_Index), off
return,

arrow_toggle:
keybypass_Arrows := !keybypass_Arrows
if keybypass_Arrows
	 GOSUB, arrow_bypasscheck 
else,GOSUB, arrow_reenable
return,

arrow_bypasscheck:
if keybypass_Arrows
Loop, Parse, arrowlist, `,
{
	bm := A_LoopField
	Loop, Parse, BList_Arr0w, `,
	{
		hotkey, IfWinActive, %A_LoopField%
		hotkey, %bm%, TT	
}	}

return,

arrow_reenable:
msgbox, ccc
for index,	 element  in key_Arrow_ar
	hotkey,% element, off
return,

f1_bypassed_explorer:	;:	F1	:: ; remove help
msgbox
IfWinNotActive, AHK_GROUP Explorer
	send {%A_thishotkey%}  
else {
	BT := A_THISHOTKEY
	gosub, TT
	
	}

return,

KB_SendSelf:
if 	InStr(A_Thishotkey, "$")
		send,% 	(Orig_Int := strReplace(A_Thishotkey, "$", ""))
else, 	send,	{%A_Thishotkey%}
return,

KB_SendSelf_UnControlled:
if InStr(A_Thishotkey, "^")
		send % (Orig_Int := strReplace(A_Thishotkey, "^", ""))
else, 	send {%A_Thishotkey%}
return,

BlockInput_Toggle:
if !bi {
	bi 	:= 	True,	BlockInput, on
		;send {LAlt Up}
settimer, BI_OFF, -500
	return,
	
	BI_OFF:
	bi 	:= 	False, BlockInput, OFF
	;send {LAlt Up}
	return,
} 
else, settimer, StyleMenu_FixLaunch, -100
return,

dbgtt_nibdown0:
ttp("nib down")
return,
dbgtt_nibdown2:
ttp("barrel 1 click")
return,
dbgtt_nibdown5:
ttp("undo")
send ^z
sleep 300
return,
dbgtt_redo:
ttp("redo")
send ^y
sleep 300
return,

hotkeySendSelf:
send {%a_thishotkey%}
ttp("%a_thishotkey%`n%hwnd%")
return,

hotkeySendSelf(A_HOTKI) {
	if instr(a_hotKi, PassThru-LoopBk) {
		a_hotKi := strReplace(a_hotKi, ("`"PassThru - "`"LoopBk), "") 
		if !errorlevel {
			if getKeyState(a_hotKi, a_hkMeth := "P")
				a_hkPrest := True
			else, 
			if getKeyState(a_hotKi, a_hkMeth := "L") 
				a_hkPrest := True
			else, 
				ttp("hotkey error`nIssue detecting Logical or Physical")
			while getKeyState(a_hotKi, a_hkMeth) {
				if !getKeyState(a_hotKi, a_hkMeth) {
					a_hkPrest := False, 	temp := True
				}
				If !a_hkPrest 
					if !temp
						a_hkPrest := True
					else, msgbox % "issue with LOGIC, Professor."
				sleep 1
			}
			if !a_hkPrest && !temp
				msgbox issue
			else, {
				a_hkPrest := False
				if !getKeyState(a_hotKi, a_hkMeth) {
					SetKeyDelay, 1000
					send {%a_hotKi%}
					SetKeyDelay, 0
					ttp((a_hotKi . "`nSent"))	
		}	}	}
		else, ttp((HK_Stript . errorlevel))
	}
	return,
}

lb_size_go:
MouseGetPos, x, y, LB_hWnd, LB_cWnd,2
LB_cWnd2 := ("ahk_id " . LB_cWnd)
PostMessage, 0x00A1, 13, %LB_cWnd2%
while getKeyState("Lbutton", "P") { 
	sleep 2
	Active_hwnd := WinExist("A")
	WinGetClass, class_active, A
	tooltip % LB_cWnd "`n" LB_cWnd2
}
tooltip,% "up11"
return,  

testi:
if (EvaluateBypass_Class(LB_hWnd) ) {

	Bypass_Class_True :=	True
	;tooltip pric
	;gosub, BypassDrag
	return,
}
else
if (EvaluateBypass_Proc(LB_hWnd) ) {
	Bypass_pname_True :=	True
	;tooltip pric
	;gosub, BypassDrag
	return,
}
else
if (EvaluateBypass_Title(LB_hWnd) ) {
	Bypass_title_True :=	True
	;tooltip pric
;gosub, BypassDrag
;==----============----
	return,
}

EvaluateBypass_Proc(hWnd) 					 {
	winGet ProcN, ProcessName, % id_ hWnd,
	if BypassProcListStr contains %procn%
		return, 1
	switch ProcN 							 {
		case anus:
			return, 1
		case (Bypass_ProcList contains ProcN):
			return, 1
		default:
			return, 0	
}	}

EvaluateBypass_Class(hWnd) 				   {
	winGetClass, ClassN,% ( id_ . hWnd)
	if  BypassClassListStr contains %ClassN%
		return, 1
return, 0
}

EvaluateBypass_Title(hWnd) 				   {
	winGetTitle, Titl3, % id_ . hWnd,
		if Titl3 in %BypassTitleListStr%
			return, 1
	
	switch Titl3 						   {
		case BypassTitleListArr[1], BypassTitleListArr[2], BypassTitleListArr[3], BypassTitleListArr[4], BypassTitleListArr[5], BypassTitleListArr[6], BypassTitleListArr[7], BypassTitleListArr[8], BypassTitleListArr[9], BypassTitleListArr[10], BypassTitleListArr[11], BypassTitleListArr[12], BypassTitleListArr[13], BypassTitleListArr[14], BypassTitleListArr[15], BypassTitleListArr[16], BypassTitleListArr[17], BypassTitleListArr[18], BypassTitleListArr[19], BypassTitleListArr[20]:
		return, 1

		default:
			return, 0
}	}

lb_size_end:
tooltip LB Resize`nup
return,

Watch_Lb:
x_NET := (X_mSt4-X_Cursor1), y_NET := (Y_MSt4-Y_Cursor1), x0x := (X_Cursor1+x_NET), y0y := (Y_Cursor1+y_NET)
return,

corner_offset_get:
XOff := (X_mSt4 - X_WinS), YOff := (Y_MSt4 - Y_WinS)
corner_offset_get2:
XOff2 := (X_Cursor1 - X_Win), YOff2 := (Y_Cursor1 - Y_Win) 	;	tooltip % XOff " ww " YOff " hh " ,,,2 	;tooltip % XOff " ww " YOff " hh " ,,,2                                              
return,

nodollarsend:
if	 a_thishotkey contains $
	 send % (b_thishotkey := strreplace(a_thishotkey, "$"))
else, ttp("Error", "-3000")
return,

Rid_Karma:
Global Die := True
TreeStance:
sleep, 777
ttp((A_thislabel "called tho"))
if !Die
	return,
else, exitapp, 
;___----\
;.,.,.,.,.,.,.,.,.,.,		;	return,
; -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~vARz-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
vARz:
Globals:
global WM_LB_down, WMResize_N_W, WMResize_S_E, WM_LB_down, RB_Down, EscCloseAskWL_Exe, EscCloseWL_Exe, turds, aa, bb, bbbb, cc, tyt, fkk, rbt_, LB_cWnd2, handle, handl2, handl3, dhand, LB_cWnd, lb_CLass, LB_cWnd, Active_hwnd, procn, Act_DelayT, eMail, TrayIconPath, num_init_trigger, Trigger_bypassed, TTn, tt, LB_hWnd, ClassPicView1, ClassPicView2, cls_IMGGLASS, xx, yy, UndoRate, Bypass_Class_True, num_others, trigg3r3d, ok2esc, escaped, shif, HK_PH1, HK_PH2, passThru, LoopBk, ExplorerCnts, ExplorerClss, YTScript, M2DRAG, WMPMATT, EventScript, Mag_Path, Path_PH, Clix, bi, x_hwnd, DbgTT, TargetScript, Act_handle_str, quote_MAX_INDEX, fkeys_str0, quotes, qstr, x_NET, y_NET, x0x, XOff, y0y, YOff, X_mSt4, Y_MSt4, X_Cursor1, Y_Cursor1, x_NET, y_NET, W_Wins, h_Wins, X_Win, Y_Win, W_Win, H_Win, wii, hii, XCent, keybypass_Numpad, M2dLB_resize, keybypass_Arrows, keybypass_FKeys, loou, pooo, Bypass_ClassList, TTn, HK_PH1, C_Ahk, qq, qt, key_Func_ar, key_Del_ar, key_NumP_ar, key_Arrow_ar, w10_LocaleGui_Allowe, d8Cntxt_Reg, d8Cntxt_RegFixValue,	BypassClassListArr, w10_LocaleGui_Allowed, email, Desktop_Margin, BList_Arr0w, BList_NmPad, arrowlist, bt, KBpF112_Init, bm, BlacklistClassCount
	; -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~vARz-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
;^^^^^^`'`'<
regRead,     Bypass_ClassList,%  "HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag", Blacklist_ClassList
loop, Parse, Bypass_ClassList, `,
{
	BypassClassListArr[A_Index] := 	A_LoopField
	If  !BypassClassListStr 
		 BypassClassListStr     :=  ( q . A_LoopField . q )
	else BypassClassListStr     := 	( BypassClassListStr . "," . q . A_LoopField . q )
	BlacklistClassCount 		:= 	A_Index
}
loou := "^Up"
pooo := "^down"
Init_4gain := True
Sysget, Desktop_Margin, MonitorWorkArea
Sysget, XCent, 	78
Sysget, YCent, 	79
XCent	:= 	(floor(0.5*XCent)) 
YCent	:= 	(floor(0.5*YCent))
iniRead, email, ad.ini, e, e, test@i.cycles.co 
w10_LocaleGui_Allowed :=  False
d8Cntxt_Reg           :=  "HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\z99 File Admin\shell\copyPaste_mod_date"  ; Cosmetic workaround to avoid confusing context entry txt
d8Cntxt_RegFixValue   :=  "Copy Date-Modified" ; Reset the context menu entry txt to "Copy Date.." (System was shutdown unexpectedly after FileDate was retained.) 
regWrite, REG_SZ,% d8Cntxt_Reg, muiverb,% d8Cntxt_RegFixValue 		; 		rebuke the abomination!	goto Globals 
Init_4gain  :=  False		;	}
num_others  :=  "NumLock,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter,NumpadPgDn,NumpadPgUp,NumpadEnd,NumpadHome,NumpadClear,NumpadDel,NumpadDot,NumpadIns,NumpadUp,NumpadLeft,NumpadRight,NumpadDown"      
arrowlist   :=  "Left,Right,Up,Down"

TTn         :=  1
HK_PH1 	    :=  "^!Enter", HK_PH2 := ("+" . HK_PH1), shif := "+", passThru := "~", LoopBk := "$"
C_Ahk	    :=	" ahk_class Autohotkey"
ExplorerCnts:= 	"DirectUIHWND3,SysListView321,DirectUIHWND"
ExplorerClss:= 	"CabinetWClass,WorkerW,Progman"
YTScript 	:=	("YT.ahk" , C_Ahk)
M2DRAG 		:=	("M2Drag.ahk" , C_Ahk)
WMPMATT 	:=	("wmp_Matt.ahk" , C_Ahk)
EventScript :=	("WinEvent.ahk" , C_Ahk)
Mag_Path 	:=	"C:\Program Files\Autohotkey\Autohotkey.exe C:\Script\AHK\Working\M2DRAG_MAG.AHK"
Path_PH 	:=	"C:\Apps\Ph\processhacker\x64\ProcessHacker.exe"
WM_LB_down  := 	0x00A1
WMResize_N_W 	:= 	13
WMResize_S_E 	:= 	17
cls_IMGGLASS 	:= 	[]
qq 				:= 	[]
qt 				:= 	[]
key_Func_ar 	:= 	[]		
key_Del_ar 		:= 	[]		
key_NumP_ar 	:= 	[]		
key_Arrow_ar	:= 	[]		
key_Arrow_ar[1] := 	"Left"
key_Arrow_ar[2] := 	"Right"
key_Arrow_ar[3]	:= 	"Up"
key_Arrow_ar[4] := 	"Down"

ClassPicView1	:= 	"WindowsForms10.Window.8.app.0.34f5582_r6_ad1"
ClassPicView2 	:= 	"WindowsForms10.Window.8.app.0.141b42a_r6_ad1"
cls_IMGGLASS[1] := 	("ahk_class " . ClassPicView1)
cls_IMGGLASS[2] := 	("ahk_class " . ClassPicView2)
return,

Menus:
menu, 	tray, 	add,%  "Open Script Folder", Open_ScriptDir
menu, 	tray, 	icon,%  TrayIconPath
menu, 	tray, 	add,%  "Disable Numpad", 	 togl_numpad
if keybypass_Numpad 
		menu, 	tray, 	check,%				"Disable Numpad"
else, 	menu, 	tray, 	uncheck,%           "Disable Numpad"
menu, 	tray, 	standard
return,

Desktop_Margins:
tooltip, % (prick := ("Left: " Desktop_MarginLeft "`nRight: " Desktop_MarginRight "`nTop: " Desktop_MarginTop "`nBottom: " Desktop_MarginBottom))
return,

sendf5:
send {f5}
ttp("F5", "-400")
return,

phLaunch: 				;	Process Hacker CTRL ALT ENTER
ttp("LAUNCHING PH")
run % Path_PH
return,

Open_ScriptDir()

^q:: ;Write out menu entries
mousegetpos,,,hw_nd,
wingetclass, Ac, ahk_id %hw_nd%
if (AC = "#32768")
	settimer, menudetail_dump, -1
else send {ctrl}{q}
return,

menudetail_dump:
WinGet, hWnd, ID, ahk_class #32768
if !hWnd
	return
SendMessage, 0x1E1, 0, 0, , ahk_class #32768 ;MN_GETHMENU
if !hMenu := ErrorLevel
	return
WinGet, vPID, PID, % "ahk_id " hWnd
;OpenProcess may not be needed to set an external menu item's icon to HBMMENU_MBAR_RESTORE
if !hProc := DllCall("OpenProcess", UInt,0x1F0FFF, Int,0, UInt,vPID, Ptr)
	return
Loop, % DllCall("GetMenuItemCount", Ptr,hMenu)
	{
	if !Vtext
		Vtext:="-------------------separator"
	vtextold:=trim((vtextold . "`n" . vtext))
	
	vChars := DllCall("user32\GetMenuString", Ptr,hMenu, UInt,vIndex, Ptr,0, Int,0, UInt,0x400) + 1
	VarSetCapacity(vText, vChars << !!A_IsUnicode)
	DllCall("user32\GetMenuString", Ptr,hMenu, UInt,vIndex, Str,vText, Int,vChars, UInt,0x400) ;MF_BYPOSITION 
	vPos := A_Index-1
	vIndex := A_Index-1
	vSize := A_PtrSize=8?80:48
	VarSetCapacity(MENUITEMINFO, vSize, 0)
	DllCall("SetMenuItemInfo", Ptr,hMenu, UInt,vPos, Int,1, Ptr,&MENUITEMINFO)
	}
DllCall("CloseHandle", Ptr,hProc) 
clipboard=%vtextold%,%vtext%
vtextold:=
vtext:=
return

DimensionChk:
WII := (W_Wins + X_net)
		if 	 WII  <  256
			 WII  := 256
	else, if WII  >  3000
			 WII  := 3000	
HII := (H_Wins + Y_net)
		if   HII  <  256
			 HII  := 256
	else, if HII  >  2000
		HII	:=	2000
x0x := (X_Cursor1 - X_net)
		if   x0X  < -1000
			 X0X  := -1000
	else, if X0X  >  3500
		     X0X  := 3500
y0y := (Y_Cursor1 - Y_net)
		if 	 y0y  <  -1000
			 y0y  := -1000
	else, if y0y  >	 2000
		     y0y  := 2000	
return,

class CloseExe
{
	Static 	EscEscCloseAskWL_ExeArr	:= 	["regedit"]
	Static 	EscCloseNoaskArr 		:= 	["vlc", "fontview", "RzSynapse", "ApplicationFrameHost", "Professional_CPL,"]
	Static 	EscNoClosearr 			:= 	["Calculator"]
	_NewEnum() {
		return, new CEnumerator(this.PNameArr)
}	}

class PName
{
	static PNameArr	:= ["firefox.exe", "chrome.exe", "explorer.exe"]
	_NewEnum() {
		return, new CEnumerator(this.PNameArr)
}	}

class SwipeBypassCName
{
	static SwipeBypassCNameArr := ["ahk_class WorkerW", "ahk_class Progman", "ahk_class CabinetWClass", "ahk_class Shell_TrayWnd", "ahk_class #32770"]
	_NewEnum() {
		return, new CEnumerator(this.SwipeBypassCNameArr)
}	}

class TName
{
	static TNameArr := ["Replace", "Infromation", "explorer.exe", "sidebar.exe", "StartMenuExperienceHost.exe"]
	_NewEnum() {
		return, new CEnumerator(this.TNameArr)
}	}

class CEnumerator
{
	__New(Object) {
		this.Object := Object
		this.first := True
		this.ObjMaxIndex := Object.MaxIndex()
	}
	Next(ByRef key, ByRef value) {
		if (this.first) {
			this.Remove("first")
			key 	:=	1
		}
		else, 	key ++
		if 	(key 	<=	this.ObjMaxIndex)
			value 	:=	this.Object[key]
		else,	key :=	""
		return,,	key !=	""
}	}

/* 
; The following DllCall is optional: it tells the OS to shut down this script first (prior to all other applications).
DllCall("kernel32.dll\SetProcessShutdownParameters", "UInt", 0x4FF, "UInt", 0)
OnMessage(0x0011, "WM_QUERYENDSESSION") 
return,
WM_QUERYENDSESSION(wParam, lParam)
{
    ENDSESSION_LOGOFF := 0x80000000
    if (lParam & ENDSESSION_LOGOFF)  ; User is logging off.
        EventType := "Logoff"
    else,  ; System is either shutting down or restarting.
        EventType := "Shutdown"
    try
    {
        ; Set a prompt for the OS shutdown UI to display.  We do not display
        ; our own confirmation prompt because we have only 5 seconds before
        ; the OS displays the shutdown UI anyway.  Also, a program without
        ; a visible window cannot block shutdown without providing a reason.
        BlockShutdown("Example script attempting to prevent " EventType ".")
        return, false
    }
    catch
    {
        ; ShutdownBlockReasonCreate is not available, so this is probably
        ; Windows XP, 2003 or 2000, where we can actually prevent shutdown.
        MsgBox, 4,, %EventType% in progress.  Allow it?
        IfMsgBox Yes
            return, true  ; Tell the OS to allow the shutdown/logoff to continue.
        else
            return, false  ; Tell the OS to abort the shutdown/logoff.
    }
}
BlockShutdown(Reason)
{
    ; If your script has a visible GUI, use it instead of A_ScriptHwnd.
    DllCall("ShutdownBlockReasonCreate", "ptr", A_ScriptHwnd, "wstr", Reason)
    OnExit("StopBlockingShutdown")
}
StopBlockingShutdown()
{
    OnExit(A_ThisFunc, 0)
    DllCall("ShutdownBlockReasonDestroy", "ptr", A_ScriptHwnd)
}
; Uncomment the appropriate line below or leave them all commented to
;   reset to the default of the current build.  Modify as necessary:
; codepage := 0        ; System default ANSI codepage
; codepage := 65001    ; UTF-8
; codepage := 1200     ; UTF-16
; codepage := 1252     ; ANSI Latin 1; Western European (Windows)
if (codepage != "")
    codepage := " /CP" . codepage
cmd="%A_AhkPath%"%codepage% "`%1" `%*
key=AutohotkeyScript\Shell\Open\Command
if A_IsAdmin    ; Set for all users.
    RegWrite, REG_SZ, HKCR, %key%,, %cmd%
else,            ; Set for current user only.
    RegWrite, REG_SZ, HKCU, Software\Classes\%key%,, %cmd%
 */
  ;hotkey, LControl & RAlt, volup
/* 
HK_WMP_ 			 :=  "<^>!" ;global yt_arr
HK_WMP_ARR			 :=  []
HK_WMP_ARR["PgUp" ]	 :=  "wmpVolUp"
HK_WMP_ARR["PgDn" ]	 :=  "VolDn"
HK_WMP_ARR["Space"]  :=  "PauseToggle"
HK_WMP_ARR["Left" ]	 :=  "JumpPrev"
HK_WMP_ARR["Right"]  :=  "JumpNext"

for index, element in HK_WMP_ARR
	hotkey,% ki:= (HK_WMP_ . index),% element
return 
VolDn:
VolUp:
wmpVolUp:
if dbgtt
	traytip, test, vol
PauseToggle:
JumpPrev:
JumpNext:
tooltip asdsd
result := (Send_WM_COPYDATA(A_thislabel, WMPMATT)) ;result := (Send_WM_COPYDATA(%a_thislabel%, WMPMATT))
return
*/



