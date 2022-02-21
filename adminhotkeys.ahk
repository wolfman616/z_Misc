;#warn ;SetControlDelay, 200 ;SetKeyDelay, 200
#noEnv 	
#persistent
#singleInstance, 		Force
#InstallKeybdHook
#KeyHistory 0
#maxHotkeysPerInterval, 1440
#maxThreadsPerhotkey,	10
DetectHiddenText, 		On
DetectHiddenWindows, 	On
setWorkingDir,			%A_ScriptDir%
coordMode,		Mouse,	Screen
coordMode, 		Pixel,	Screen
sendMode, 			Input
settitlematchmode,	2
ListLines, 			Off
setbatchlines, 		-1
SetWinDelay, 		-1
HOTKEY, ~LAlt, Wt_, On 
i_To554h 	:= 		False
;-=========-------------=========----------============--------------===========----
global 	TrayIconPath		:= 	"C:\Icon\256\ICON5356_1.ico", 
;-=========-------------=========----------============--------------===========----	; BLOCK KEYS PER TITLE
global 	BList_NmPad 		:= 	"Youtube,ahk_exe wmplayer.exe"
global 	BList_F1_12 		:= 	"Youtube,ahk_exe notepad++.exe, ahk_class progman,ahk_class WorkerW"
global 	BList_Arr0w 		:= 	"YouTube,ahk_class progman,ahk_class WorkerW"
global 	BList_num0_9 		:= 	"YouTube,ahk_class progman,ahk_class WorkerW" ;			<---; NOT IMPLEMENTED !!!
;-=========-------------=========----------============--------------===========----	; Esc 2 Quit ExEs
global 	EscCloseWL_Exe 		:= 	"vlc,fontview,WMPlayer,RzSynapse,ApplicationFrameHost,Professional_CPL,"
global 	EscCloseAskWL_Exe 	:= 	"regedit,"
;-=========-------------=========----------============--------------===========----	; c 	hole
gosub, 	Varz
gosub, 	Menus
gosub, 	Binds
gosub, 	m4in
onExit, TreeStance
Exit

m4in:
regWrite, REG_SZ, %contextdate%, muiverb, % date_regfix 		; 		rebuke the abomination!
wm_allow()
OnMessage(0x4a, "Receive_WM_COPYDATA")
global Bypass_ClassList
regRead, Bypass_ClassList,	HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag, Blacklist_ClassList
loop, Parse, Bypass_ClassList, `,
{
	BypassClassListArr[A_Index] := 	A_LoopField
	If !BypassClassListStr 
		BypassClassListStr 		:=  ( q . A_LoopField . q )
	else
		BypassClassListStr 		:= 	( BypassClassListStr . "," . q . A_LoopField . q )
	BlacklistClassCount 		:= 	A_Index
}

return       
																
Binds:	; -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~HotKeys-~-~-~-~-~-	-~-~-~-~	~-~-~-~- ~-~-~-
gosub, 	togl_numpad_i
gosub, 	arrow_bypass
gosub, 	f1_f12_                             
gosub, 	Digits_MAIN		                                                             
hotkey, ^!Enter, 	phLaunch, 	on		 
hotkey, f5, 		sendf5, 	on		 
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

~$^Lbutton::	                                                                     
~Lbutton::                                                                           
Active_hwnd := WinExist("A")
WinGetClass, class_active, A

LB_cWnd22:=
MouseGetPos,X_Cursor1, Y_Cursor1, LB_hWnd, LB_cWnd22,
wingetClass, Class, ahk_id %LB_hWnd%
			
;if RB_Down {
	if getKeyState("Rbutton", "P") {
					if Class = WorkerW
					return

			;if Bypass_pname_True 
				;gaylove:=true
			if Bypass_Class_True
							gaylove:=true

			;if Bypass_title_True
				;gaylove:=true
				;if gaylove
				mousegetpos, 	X_mSt4, 	Y_MSt4, handlenotblade
				wingetpos, 		X_Wins, 	Y_Wins, 	W_Wins, 	H_Wins, 	ahk_id %cuntHwnd%
				winGetClass, ClassN, % ( id_ . handlenotblade),
				;if ClassN != CabinetWClass
			;msgbox % ClassN
	if( Class = "CabinetWClass") {
		PostMessage, %WM_LB_down%, %WMResize_N_W%,% "ahk_id " LB_cWnd22
		while getKeyState("Lbutton", "P")
			sleep 1
		Send {LButton up} ;or  click up ; IMPORTANT : NEEDED IF NOT HOOKED LBUTTONUP ELSEWHERE OR CTRL ADDED TO DRAG WILL DIE
		return
	} else {
		if !rbt_ {
			;	PostMessage, %WM_LB_down%, %WMResize_S_E%,% "ahk_id " LB_cWnd22
			wingetpos, X_Wins, Y_Wins, W_Wins, H_Wins, ahk_id %LB_hWnd%
			MouseGetPos,X_mSt4 ,Y_MSt4 , LB_hWnd, LB_cWnd22
			wingetpos, X_Win, Y_Win, W_Win, H_Win, ahk_id %LB_hWnd%
			x_winn := 
			MouseGetPos,X_Cursor1 ,Y_Cursor1 , LB_hWnd, LB_cWnd22
			gosub, Watch_Lb
			gosub, corner_offset_get
			rbt_ := True
		} else gosub, DimensionChk
	}
	while getKeyState("Lbutton", "P") { 
		mousegetpos, 	X_Cursor1, Y_Cursor1
		wingetpos, 		X_Win, Y_Win, W_Win, H_Win, ahk_id %LB_hWnd%
		;tooltip % X_mSt4 " " y_mSt4 "`n" X_Cursor1 " " Y_Cursor1
		gosub, Watch_Lb
		gosub, DimensionChk
		xx := (x0x - XOff),	yy := (y0y - YOff)
		Win_Move(LB_hWnd, xx, yy, wii, hii, "")
	}
	rbt_ := False	
}
return

*~rButton:: 				; 				menu ; 				menu ; 				menu ; 				menu ; 				menu ; 				menu 
menu_trigger:= False
RB_Down		:= True
if getKeyState("LAlt" , "P") {
	HOTKEY, ~LAlt, Wt_, off
	HOTKEY, LAlt, zzz, on 
	send % LAlt up
} 
HOTKEY, ~LAlt, Wt_, off
return

*rButton Up::
send % rbutton up
RB_Down		:= False
if getKeyState("LAlt" , "P") {
	menu_trigger:= True
}
return

~*<!rbutton up:: 
return
Menu_Fix:
	menu_trigger:= True
STR_ := "StyleMenu", TargetScript := EventScript, result := Send_WM_COPYDATA(STR_, TargetScript)
;settimer, BlockInput_Toggle, -1
RB_Down		:= False
return

Wt_:
HOTKEY, ~LAlt, Wt_, off
HOTKEY, LAlt, zzz, on
KeyWait, LAlt
settimer, BlockInput_Toggle, -1
HOTKEY, ~LAlt, Wt_, off
sleep 1
HOTKEY, LAlt, zzz, off
return

zzz:
;tooltip % a_now "`n" nigg
return

; 					/menu ; 				/menu ; 				/menu ; 				/menu ; 				/menu ; 				/menu 
;'$$$$$$$$$$$$$$$$$$$£££££££££££££££££££££££££££££££££"""""""""""""""""""""""$$$$$$$$$$$$$$$$$$$$$$$$$££££££££££££££££££
; togl_numpad_m:
; num_others 			:= 	"NumLock,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter"
; if togl_numpad {
	; menu, tray, check, Disable Numpad
	; if !triggernigger {
		; triggernigger := true
		; loop 10 {
			; global aa := (a_index-1)
			; Loop Parse, BList_NmPad, `,
			; {
				; Hotkey, IfWinActive, % A_LoopField
				; Hotkey, % "Numpad" . aa, TT
				; numpadkeys_str := (numpadkeys_str . "," . "Numpad" . aa)
				; numpadkeys_Arr.Push("Numpad" . aa)
			; }
		; }
		; Loop Parse, num_others, `,
		; {
			; global bb := A_LoopField
			; Loop Parse, BList_NmPad, `,
			; {
				; Hotkey, IfWinActive, % A_LoopField
				; Hotkey, % bb, TT
				; numpadkeys_str := (numpadkeys_str . "," . bb)
				; numpadkeys_Arr.Push(bb)	
			; }
		; }
	; } else {
		; for index, element in numpadkeys_Arr
			; Hotkey, % element, TT
	; }

^+Delete::
deldel := A_thisHotkey
WinGetClass, clart, A
if (instr(ExplorerClss,clart)) { 	; 	sendself_no_ctrl:
	ControlGetFocus, cnt, % "ahk_id " (handl := winactive("a"))
	if (InStr(cnt, "Edit")) 
		deldel:= strreplace(deldel, "^+")
	else deldel:= strreplace(deldel, "^")
	send {%deldel%}
	if (InStr(deldel, "+")) 
	a3 := "Shift-"
	else a3 := 	"Normal "
	tt((a3 . "Delete"))
} else {
	send {%A_thisHotkey%}
	if debugtt_advanced
		Tt("sent: control, shift & del")
}
return

$delete::
WinGetClass, clart, A
if (instr(ExplorerClss,clart)) 		{ 	; 	sendself_no_ctrl:
	handl := winactive("a")
	ControlGetFocus, louisafuckingfatpig, ahk_id %handl%
	if (instr("Edit1",louisafuckingfatpig)) 	{ 	; 	sendself_no_ctrl:
		send {delete}
		sleep 1
		return
	} else 
if (instr(ExplorerCnts,louisafuckingfatpig))	; 	sendself_no_ctrl:
	gosub, TT
} else {	; all other classes
	send {delete}
	if debugtt_advanced
		tt("Delete Not Suppressed undefined", "500")
}
handl := ""
return

$+Delete::
turds:=Explorer_GetSelection()
loop, parse, turds, `n,
	ct4 := a_index
if ct4 > 1
	cunt := ct4 . " items"
else {
	SplitPath, 	turds,,, OutExtension, OutNameNoExt,
	cunt := (OutNameNoExt . "." . OutExtension)
}
msgbox,0x2121, Confirm Deletion, % ("Send " cunt " to RecycleBin?")
ifmsgbox ok
	msgbox, 0x2131, % "Del?...Sure?", R U sH0Re?....`n`nhuhu
	ifmsgbox ok
		filerecycle, %turds%
return

; 	'-~_~_~_~_~_~_~_ UN-DO MO-FO _~_~_~_~_~_~_~-'	 	'-~_~_~_~_~_~_~_ UN-DO MO-FO _~_~_~_~_~_~_~-'	 	'-~_~_~_~_~_~_~_ UN-DO MO-FO _~_~_~_~_~_~_~-'	
; UNDO MOFO
$^z:: 				;			"Ctrl Z" - bypass "Undo." in Explorer.exe
$^y:: 				; 			"Ctrl Y" - bypass "Redo". in Explorer .exe
; if  !Clix 				;	Undo/Redo Hotkey-attempt counter
	 ; Clix 	:= 	1		;	Make into double or triple detecter 	( with timeout / reset )
; else Clix 	:= 	Clix +1	
if (!winactive("AHK_Class WorkerW") && !winactive("AHK_Class Progman") && !winactive("AHK_Class CabinetWClass")) {
	gosub, nodollarsend
} else 					{
	if 	(edit_dtect()) 	{
		gosub, nodollarsend
	} else {
		gosub, TT
}	}
return

TT:
bt 	:= 	a_thishotkey
if (bt contains "$"  &&	bt != $)
	bt := strreplace(	bt, "$") 
if (bt contains "^"  &&	bt != $)
	bt := strreplace(	bt, "^", "Control + ")
if (bt contains "!"  &&	bt != $)	
	bt := strreplace(	bt, "!", "Alt + ")
TT(	bt " Disabled."	, 	"200" ) 
return

^#i:: 	; Press ctl 1 to make the color under the mouse cursor invisible.
mouseGetPos, MouseX, MouseY, MouseWin
pixelGetColor, MouseRGB, %MouseX%, %MouseY%, RGB
WinSet, TransColor, Off, ahk_id %MouseWin%
TT( msg := ( MouseRGB . " Will BE MADE TRANS_COLOR`n" . MouseX . ", " . MouseY . "`n" . MouseWin))
WinSet, TransColor, %MouseRGB% 200, ahk_id %MouseWin% 	;	 WinSet, TransColor, 0xFFFFFF, ahk_id %MouseWin%
return

$esc::
$+esc::
#HotkeyInterval 1000
winGet ProcN, ProcessName,% "ahk_id " (handl3	:=	winactive("a"))
ProcN := strreplace(ProcN, ".exe")
if ProcN in %EscCloseWL_Exe%
{
	TT((ProcN . ", Closing..."))
	WinClose
} else		
					  	;	 	MsgboxClose 
if ProcN in %EscCloseAskWL_Exe%
{ ;	Icon Asterisk (info) 	64 0x40 ;; 	Icon "Question" 32 0x20 ; ; WS_EX_TOPMOST 	262144 	0x40000 ;; 	OK/Cancel 1 0x1 ;	Yes/No 4 0x4 ; ; System Modal (top) 4096 0x1000 
	msgbox, 262209, Close %ProcN%? , Closing.`nTimeout in 4 Sec`nIssue forth,4
	;ifmsgbox OK		
	ifmsgbox Cancel
			return

	ifmsgbox no	
		return
	else WinClose
} else {
	if !trigg3r3d {
		trigg3r3d := True
		mousegetpos , , , winz
		WinGetClass, aaa ,  ahk_id %winz%, 
	}
	if aaa = #32768
		ok2esc := true 
	else if fag:=instr(aaa,"CustomizerGod")
	{
		WinGetActiveStats, Title, Width, Height, X, Y		
		if ((Width < 1220) && (height < 830))
			winclose,
	} else {
		escaped:=True
		send {Esc}
}	}
return

$esc up::
$+esc up::
if (ok2esc || escaped) {
	trigg3r3d := False, ok2esc := false, escaped := False
	if escaped 
		send {esc up}
	else send {esc}
}
#HotkeyInterval %hi%
return

!Shift:: 			; 	-~-~-~-~-~-~ 	;		input-locale selector gui hotbind bypass 	-~-~-~-~-~-~
+Alt::
if w10KB_LocaleGui
	send A_ThisHotkey
return
	;	 -------------======------------- -------------======------------- WACOM TABlet Stuff -------------======------------- -------------======-------------

+F9::		 		;		 -------------======-------------		 WACKEM STYLUS NIB EVENT 			-------------======-------------
if debugtt 
	TT("Nib Down")
send {LButton Down}
return
+F9 up::
if debugtt 
	TT("Nib Up")
send {LButton Up}
return

$insert::	 	; -------------======------------- 	GIMP Undo = Stylus button && GIMP ReDo = Ctrl + stylus button 1 	-------------======-------------
if !(winactive("ahk_exe gimp-2.10.exe")) {
	HotkeySendSelf(A_thisHotkey)	;		undo 		-------------=============------------- 		 			undo 		
	return
} else {
	sleep 20
	send {escape}
	sleep 70
	send ^z
	while getKeyState,insert {
		msgbox		;settimer, dbgtt_nibdown5, -%UndoRate%
}	}

return
; $insert up::
; settimer, dbgtt_nibdown5, off
; return

$^insert::	 
send {escape}	 			; 		get rid of annoying hardcoded Rbutton menu popup in GIMP 
send ^Y
if !(winactive("ahk_exe gimp-2.10.exe")) {
	HotkeySendSelf(A_thisHotkey)	;		undo 		-------------=============------------- 		 			undo 		
	return
} else {
	sleep 20
	send {escape}
	sleep 70
	send ^y
	while getKeyState,insert {
		msgbox		;settimer, dbgtt_nibdown5, -%UndoRate%
}	}
return


; g i m p routed Mouse1 / pen nib 1 -----=====-----; g i m p routed Mouse2 / undo barrel 1
 ~#F10:: ;~ sending thru to m2drag
click right down
TT("Barrel 1 Down")
return
~#F10 up::
click right up
TT("Barrel 1 Up")
return 
~!f13::
TT("rotate CW")
return
~!f14::
TT("rotate C-CW")
return
~+wheeldown::
TT("2 Finger swipe L")
return
~+wheelup::
TT("2 Finger swipe R")
return

XButton1::			 		;				System Back and Forward
XButton2::					;				MOUSE BUTTONS BACK / FWD 
A_hwnd := WinExist("A")
winGetClass, a_Class, ahk_id %A_hwnd%
if (A_Class = "MultitaskingViewFrame") {
	Send !{tab} 
	return
} else 
if (A_Class = "WorkerW")
	TT("D-Top (Not Implemented")
else send {%A_thishotkey%}
return
;		 -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ 	 	Bypass 	-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
winGet ProcN, ProcessName, ahk_id %A_hwnd%
for k, v in PName {
	if (v = ProcN)	{
		goto HotkeySendSelf
	}
}		
Swipe(A_hwnd, a_thishotkey)
return

Swipe(hwnd, hotkey) {
	if !hwnd {
		send !{tab}
		send +!{tab}
		return
	}
	if ( hotkey = "XButton1") {
		send #{Left}
		TT("Bk butt")
	} else {
		if ( hotkey	= "XButton2") {
			send #{Right}
			TT("Fwd butt")
		} else Msgbox % "other back fwd buttons pls consult the p===---"
	}
	WinWaitActive, AHK_Class MultitaskingViewFrame,, 2
	if (winactive("AHK_Class MultitaskingViewFrame")) {
		S_hwnd := wineXist("A")
		if (S_hwnd = hwnd) {
			Send !{tab} 
			TT("alt tabbed")
			return
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
		TT("Failed, rem")
	} else {
		if !Delay
			Delay := -100	
		Act_handle_str := ("ahk_id " . hwnd ), Act_DelayT := delay
		settimer, Act_Then, %Act_DelayT% 
		return
		
		Act_Then:
		winactivate %Act_handle_str%
		WinWait, Act_handle_str,, 2
		if winactive(Act_handle_str) {
			Act_DelayT := "", Act_handle_str := ""
			return 1
		} else return 0
}	}
; 	-~-~-~-~-~-~ 	Win M 	-~-		Magnifier Toggle 		-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
; #M::  			;		ALTgr + Right Arrow
; +#M::	
; TargetScript := winevent, STR_ := "mag_", result := (Send_WM_COPYDATA(STR_, TargetScript))
;return
!R:: 					; nvidia share shortcut
return
~^!z::
TT("3 finga tap")
return
~^+!#h::
TT("4 finga upswipe")
return
~#Tab::
TT("4 finga downswipe")
return
~!^+u:: 
TT("5 finga downswipe")
return
~^+f6:: 				;		ctrl shift F6 
TT("5 finga tap")
return 

<^>!PgUp::				;		ALTgr + Page UP 	; 	Volume Up	
+<^>!PgUp::		
TargetScript := WMPMATT, 	STR_ := "VolUp", result := (Send_WM_COPYDATA(STR_, TargetScript))
return
<^>!PgDn::	 			;		ALTgr + Page Down 	; 	Volume Up	
+<^>!PgDn::
TargetScript := WMPMATT, 	STR_ := "VolDn", result := (Send_WM_COPYDATA(STR_, TargetScript))
return
<^>!Space::				;		ALTgr + Space
+<^>!Space::
TargetScript := WMPMATT, 	STR_ := "PauseToggle", result := (Send_WM_COPYDATA(STR_, TargetScript))
return
<^>!Left::				;		ALTgr + Left Arrow
+<^>!Left::	
TargetScript := WMPMATT, 	STR_ := "JumpPrev", result := (Send_WM_COPYDATA(STR_, TargetScript))
return
<^>!Right::	 			;		ALTgr + Right Arrow
+<^>!Right::	
TargetScript := WMPMATT, 	STR_ := "JumpNext", result := (Send_WM_COPYDATA(STR_, TargetScript))
return
<^>!Enter:: 			;		ALTgr + Enter	
+<^>!Enter:: 			;		open current media loc & clipboard details
TargetScript := WMPMATT, 	STR_ := "Open_Containing", result := Send_WM_COPYDATA(STR_, TargetScript)
return
<^>!c::					;		ALTgr + C
+<^>!c::	
TargetScript := WMPMATT, 	STR_ := "Converter", result := Send_WM_COPYDATA(STR_, TargetScript)
return
<^>!x::					; 		ALTgr x 
+<^>!x::
TargetScript := WMPMATT, 	STR_ := "CutCurrent", result := Send_WM_COPYDATA(STR_, TargetScript)
return
<^>!Del::				;		ALTgr + Del
+<^>!Del::	
TargetScript := WMPMATT, 	STR_ := "godie", result := Send_WM_COPYDATA(STR_, TargetScript)
return
<^>!p::					;		ALTgr + Enter
+<^>!p::			
TargetScript := WMPMATT, 	STR_ := "Add2Playlist", result := Send_WM_COPYDATA(STR_, TargetScript)
return
<^>!f::					;		ALTgr + f
+<^>!f::	
TargetScript := WMPMATT, 	STR_ := "SearchExplorer", result := Send_WM_COPYDATA(STR_, TargetScript)
return
<^>!s::					;		ALTgr + s
+<^>!s::				;		Search SlSK for alternatives to current
TargetScript := WMPMATT, 	STR_ := "CopySearchSlSk", result := Send_WM_COPYDATA(STR_, TargetScript)
return
^#x::	
+^#x::					;		ExtractAudio from youtube
TargetScript := YTScript, 		STR_ := "ExtractAudio", result := Send_WM_COPYDATA(STR_, TargetScript)
return
^#Space::				;		Youtube Audio-Xtract 
+^#Space::				; 		CTRL - WIN - SPACEBAR
TargetScript := YTScript, 		STR_ := "PlayPause", result := Send_WM_COPYDATA(STR_, TargetScript)
return
^#Left::				; 		Youtube Prev			
+^#Left::				; 		CTRL-WIN-LEFTARROW
TargetScript := YTScript, 		STR_ := "prev", result := Send_WM_COPYDATA(STR_, TargetScript)
return
^#Right::				; 		Youtube Next
+^#Right::				; 		CTRL-WIN-LEFTARROW			
TargetScript := YTScript, 		STR_ := "next", result := Send_WM_COPYDATA(STR_, TargetScript)
return

Receive_WM_COPYDATA(wParam, lParam) {				
	msgbox, SUX-S											
	StringAddress := NumGet(lParam + 2*A_PtrSize)		 
	CopyOfData := StrGet(StringAddress) 						 
	C_Str=C:\Windows\system32\cmd.exe /s /k pushd "%CopyOfData%"	
	return True
}
+^Delete::+Delete

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
	return errorlevel
}
class CloseExe
{
	Static 	EscEscCloseAskWL_ExeArr	:= 	["regedit"]
	Static 	EscCloseNoaskArr 		:= 	["vlc", "fontview", "RzSynapse", "ApplicationFrameHost", "Professional_CPL,"]
	Static 	EscNoClosearr 			:= 	["Calculator"]
	_NewEnum() {
		return new CEnumerator(this.PNameArr)
	}
}
class PName
{
	static PNameArr	:= ["firefox.exe", "chrome.exe", "explorer.exe"]
	_NewEnum() {
		return new CEnumerator(this.PNameArr)
	}
}
class SwipeBypassCName
{
	static SwipeBypassCNameArr := ["AHK_Class WorkerW", "AHK_Class Progman", "AHK_Class CabinetWClass", "AHK_Class Shell_TrayWnd", "AHK_Class #32770"]
	_NewEnum() {
		return new CEnumerator(this.SwipeBypassCNameArr)
	}
}
class TName
{
	static TNameArr := ["Replace", "Infromation", "explorer.exe", "sidebar.exe", "StartMenuExperienceHost.exe"]
	_NewEnum() {
		return new CEnumerator(this.TNameArr)
	}
}
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
			key 	:= 	1
		}
		else 	key ++
		if 	(key 	<= 	this.ObjMaxIndex)
			value 	:= 	this.Object[key]
		else 	key := 	""
		return 	key != 	""
	}
}

Digits_MAIN:			;	digits keywrap
loop 9 {
				h_KI 		:= ( "$"  . A_index )
				Shift_KI 	:= ( "$+" . A_index )
	hotkey,	% 	h_KI, 		Digits_0_9
	hotkey,	% 	Shift_KI, 	Digits_0_9
}
hotkey, $0,  Digits_0_9
hotkey, $+0, Digits_0_9
return

Digits_0_9: 	;	 disable digit-keys ( for youtube mainly )
handle := winactive("A")
winGet ProcN, ProcessName, ahk_id %handle%
if ( ProcN = "firefox.exe" ) {
	if shif not in A_ThisHotKey
	{
		WinGetActiveTitle, Title_Active
		if 	Title_Active contains YouTube 
			traytip, YouTube, % "Numbers disabled`nPress Shift with them...", 1, 34
		else gosub, KB_SendSelf
	} else gosub, KB_SendSelf
} else gosub, KB_SendSelf 
return

togl_numpad:	; numpad bypass
numpadkeys_str := ""
togl_numpad := !togl_numpad
togl_numpad_i:
if togl_numpad {
	menu, tray, check, Disable Numpad
	if !num_init_trigger {
		num_init_trigger := true
		loop 10 {
			aa := (a_index - 1)
			Loop Parse, BList_NmPad, `,
			{
				Hotkey, IfWinActive, % A_LoopField
				Hotkey, % ("Numpad" . aa), TT
				if 	 numpadkeys_str
					 numpadkeys_str := (numpadkeys_str . "," . "Numpad" . aa)
				else numpadkeys_str := ("Numpad" . aa)
		}	}
		Loop Parse, num_others, `,
		{
			bb := A_LoopField
			Loop Parse, BList_NmPad, `,
			{
				Hotkey, IfWinActive, % A_LoopField
				Hotkey, % bb, TT
				numpadkeys_str := (numpadkeys_str . "," . bb)
				numpadkeys_Arr.Push(bb)	
		}	}
	} else {
		for index, element in numpadkeys_Arr
			Hotkey, % element, TT
	}
} else {
	menu, tray, uncheck, Disable Numpad
	if !num_init_trigger {
		num_init_trigger := true
		loop 10 {
			cc := (a_index-1)
			Loop Parse, BList_NmPad, `,
				Hotkey, IfWinActive, % A_LoopField
				Hotkey, % "Numpad" . cc, TT
				numpadkeys_str := (numpadkeys_str . "," . "Numpad" . cc)
				numpadkeys_Arr.Push("Numpad" . cc)
		}
		Loop Parse, num_others, `,
		{
			Loop Parse, BList_NmPad, `,
				Hotkey, IfWinActive, % A_LoopField
				Hotkey, % A_LoopField, TT
				numpadkeys_str := (numpadkeys_str . "," . A_LoopField)
				numpadkeys_Arr.Push(A_LoopField)	
		}
	} else {
		for index, 	element in numpadkeys_Arr
			Hotkey,	% element, off
}	}
return

F1_F12_Toggle:
Fkeys_bypass_enabled := !Fkeys_bypass_enabled
f1_f12_:
if 	 Fkeys_bypass_enabled
	 goto F1_F12_Disable
else goto F1_F12_Default
return

F1_F12_Disable:
loop 12 {
	tyt  := ("F" . A_Index)
	if (a_index = "1") 
		Hotkey % tyt, f1_bypassed_explorer
	else {	
		Loop Parse, BList_F1_12, `,
			Hotkey, IfWinActive, % A_LoopField
		Hotkey % tyt, TT
		fkeys_str := (fkeys_str . "," . tyt)
}	}	
return

F1_F12_Default:
loop 12
	Hotkey % ("F" . A_Index), off
return

arrow_toggle:
arrow_bypass_enabled := !arrow_bypass_enabled
if arrow_bypass_enabled
	 goto arrow_bypass
else goto arrow_reenable
return

arrow_bypass:
if !arrow_bypass_enabled
	return
arrows_Arr 		:= 	[]
arrowlist 		:=	"Left,Right,Up,Down"
arrows_str 		:= 	""
Loop Parse, arrowlist, `,
{
	bm := A_LoopField
	Loop Parse, BList_Arr0w, `,
		Hotkey, IfWinActive, % A_LoopField
	Hotkey, % bm, TT
	if 	 arrows_str
		 arrows_str := (arrows_str . "," . bm)
	else arrows_str := bm
}
if arrows_str != %arrowlist%
	msgbox % arrows_str " error`n" arrowlist
return

arrow_reenable:
msgbox ccc
for index, element in arrows
	Hotkey, % element, off
return

f1_bypassed_explorer:	;:	F1	:: ; remove help
if !(a_Class = "WorkerW" || "Progman" || "CabinetWClass" ) {
A_hwnd 	:= 	WinExist("A")
winGetClass, a_Class, ahk_id %A_hwnd%
	send % A_thishotkey
} else gosub, TT
return

KB_SendSelf:
if InStr(A_ThisHotKey, "$")
		send % (Orig_Int := strReplace(A_ThisHotKey, "$", ""))
else 	send {%A_ThisHotKey%}
return



KB_SendSelf_UnControlled:
if InStr(A_ThisHotKey, "^")
		send % (Orig_Int := strReplace(A_ThisHotKey, "^", ""))
else 	send {%A_ThisHotKey%}
return

BlockInput_Toggle:
if !bi {
	bi 	:= 	True,	BlockInput, on
		;send {LAlt Up}
settimer, BI_OFF, -500
	return
	
	BI_OFF:
	bi 	:= 	False, BlockInput, OFF
	;send {LAlt Up}
	return
} 
else settimer, Menu_Fix, -100
return

dbgtt_nibdown0:
TT("nib down")
return
dbgtt_nibdown2:
TT("barrel 1 click")
return
dbgtt_nibdown5:
TT("undo")
send ^z
sleep 300
return
dbgtt_redo:
TT("redo")
send ^y
sleep 300
return

HotkeySendSelf:
send {%a_thishotkey%}
TT("%a_thishotkey%`n%hwnd%")
return

HotkeySendSelf(A_HOTKI) {
	if instr(a_hotKi, PassThru-LoopBk) {
		a_hotKi := strReplace(a_hotKi, ("`"PassThru - "`"LoopBk), "") 
		if !errorlevel {
			if getKeyState(a_hotKi, a_hkMeth := "P")
				a_hkPrest := True
			else 
			if getKeyState(a_hotKi, a_hkMeth := "L") 
				a_hkPrest := True
			else 
				TT("Hotkey error`nIssue detecting Logical or Physical")
				
			while getKeyState(a_hotKi, a_hkMeth) {
				if !getKeyState(a_hotKi, a_hkMeth) {
					a_hkPrest := False, 	temp := True
				}
				If !a_hkPrest 
					if !temp
						a_hkPrest := True
					else msgbox % "issue with LOGIC, Professor."
				sleep 1
			}
			
			if !a_hkPrest && !temp
				msgbox issue
			else {
				a_hkPrest := False
				if !getKeyState(a_hotKi, a_hkMeth) {
					SetKeyDelay, 1000
					send {%a_hotKi%}
					SetKeyDelay, 0
					TT((a_hotKi . "`nSent"))	
		}	}	}
		else TT((HK_Stript . errorlevel))
	}
	return
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
tooltip up1
return  

testi:


if (EvaluateBypass_Class(cuntHwnd) ) {

	Bypass_Class_True :=	True
	;tooltip pric
	;gosub, BypassDrag
	return
}
else
if (EvaluateBypass_Proc(cuntHwnd) ) {
	Bypass_pname_True :=	True
	;tooltip pric
	;gosub, BypassDrag
	return
}
else
if (EvaluateBypass_Title(cuntHwnd) ) {
	Bypass_title_True :=	True
	;tooltip pric
;gosub, BypassDrag
;==----============----
	return
}

EvaluateBypass_Proc(hWnd) {

	winGet ProcN, ProcessName, % id_ hWnd,
	if BypassProcListStr contains %procn%
		return 1
	switch ProcN {
		case anus:
			return 1
		case (Bypass_ProcList contains ProcN):
			return 1
		default:
			return 0	
		case fagg:
			return 1
}	}


EvaluateBypass_Class(hWnd) {
	winGetClass, ClassN,% ( id_ . hWnd)
	if  BypassClassListStr contains %ClassN%
		return 1
return 0
}

EvaluateBypass_Title(hWnd) {
	winGetTitle, Titl3, % id_ . hWnd,
		if Titl3 in %BypassTitleListStr%
		return 1
	
	switch Titl3 {
		case BypassTitleListArr[1], BypassTitleListArr[2], BypassTitleListArr[3], BypassTitleListArr[4], BypassTitleListArr[5], BypassTitleListArr[6], BypassTitleListArr[7], BypassTitleListArr[8], BypassTitleListArr[9], BypassTitleListArr[10], BypassTitleListArr[11], BypassTitleListArr[12], BypassTitleListArr[13], BypassTitleListArr[14], BypassTitleListArr[15], BypassTitleListArr[16], BypassTitleListArr[17], BypassTitleListArr[18], BypassTitleListArr[19], BypassTitleListArr[20]:
		return 1

		default:
			return 0
	}
}

lb_size_end:
tooltip LB Resize`nup
return

Watch_Lb:
x_NET := (X_mSt4-X_Cursor1), y_NET := (Y_MSt4-Y_Cursor1), x0x := (X_Cursor1+x_NET), y0y := (Y_Cursor1+y_NET)
return

corner_offset_get:
XOff := (X_mSt4 - X_WinS), YOff := (Y_MSt4 - Y_WinS)
corner_offset_get2:
XOff2 := (X_Cursor1 - X_Win), YOff2 := (Y_Cursor1 - Y_Win) 	;	tooltip % XOff " ww " YOff " hh " ,,,2 	;tooltip % XOff " ww " YOff " hh " ,,,2                                              
return		       

nodollarsend:
if	 a_thishotkey contains $
	 send % (b_thishotkey := strreplace(a_thishotkey, "$"))
else TT("Error","3000")
return
TreeStance:
tooltip,% 	"Try to notice whenever you are happy.`nKurt Vonnegut"
sleep, 777
exitapp
vARz:	; -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~vARz-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
iniRead, email, ad.ini, e, e, test@i.cycles.co
i_To554h := True, 	c 	:= 	" ahk_class AutoHotkey", 
w10KB_LocaleGui			:= 	False
contextdate 			:= 	"HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\z99 File Admin\shell\copyPaste_mod_date" 
date_regfix 			:= 	"Copy DateModified"
					
if i_To554h	            ;           if i_To554h {esc
	goto Globals  	    ;          	i_To554h := False
return         		    ;            	goto Globals 
						;	          }
						;	          return
i_To554h := False
Globals:
global WM_LB_down, global WMResize_S_E, global RB_Down, global EscCloseAskWL_Exe, global EscCloseWL_Exe,
WM_LB_down 		:= 	0x00A1
WMResize_S_E 	:= 	17
WMResize_N_W 	:= 	13
fagg 	:= 	0xA2
fkk		:= 	0x0201
fkkk	:= 	0x0202
poo		:= 	2 
global 	TTn := 1, global tt := 500, global turds := 0, global fagg, global trigg3r3d := False, ok2esc := false, escaped := False, global aa, global bb, global bbbb, global cc, global tyt, global fkk, global poo, global rbt_
global 	LB_hWnd := 0x0, global LB_cWnd := 0x0, global LB_cWnd2 := "", global handle := 0x0, global handl2 := handle, global handl3 := handle, global handl3 := handle,  global dhand, global LB_cWnd, global lb_CLass, global LB_cWnd, global Active_hwnd, global procn, 

global 	HK_PH1 := "^!Enter", global HK_PH2 := "+" . HK_PH1, global shif := "+", global passThru := "~", gLOBAL LoopBk := "$",
global 	ExplorerCnts 	:= 	"DirectUIHWND3,SysListView321,DirectUIHWND"
global 	ExplorerClss 	:= 	"CabinetWClass,WorkerW,Progman"
global 	YTScript 	:= 	"YT.ahk ahk_class AutoHotkey"
global 	M2DRAG 		:= 	"M2Drag.ahk ahk_class AutoHotkey"
global 	WMPMATT 	:= 	"wmp_Matt.ahk ahk_class AutoHotkey"
global 	EventScript := 	"WinEvent.ahk ahk_class AutoHotkey"
global 	Mag_Path 	:= 	"C:\Program Files\Autohotkey\Autohotkey.exe C:\Script\AHK\Working\M2DRAG_MAG.AHK", global Path_PH := "C:\Apps\Ph\processhacker\x64\ProcessHacker.exe"
global 	Clix := False, global bi := False, global x_hwnd := False, global debugtt := True, global TargetScript, global Act_handle_str
global 	Act_DelayT, global eMail, global TrayIconPath,  global menu_trigger, global num_init_trigger, 
global 	fkeys_str0

global 	ok2esc
global 	x_NET
global 	y_NET              ;~1
global 	x0x                   ;~
global 	y0y               ;~
global 	XOff                ;~
global 	YOff               ;~
global 	X_mSt4             ;~
global 	Y_MSt4             ;~
global 	X_Cursor1          ;~
global 	Y_Cursor1
global 	x_NET			  ;~
global 	y_NET			 ;~
global 	W_Wins	;========	
global 	h_Wins	;========	
global 	X_Win
global 	Y_Win
global 	W_Win
global 	H_Win
global 	wii
global 	hii

global 	xx, global yy
global 	num_others 	:= "NumLock,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter,NumpadPgDn,NumpadEnd,NumpadHome,NumpadClear,NumpadDel,NumpadIns,NumpadUp,NumpadLeft,NumpadRight,NumpadDown"

#HotkeyInterval %hi%

global 	UndoRate := 300, global TT := -666 ; def tooltip time
global 	DEBUGTT 				:= 	True
global 	M2dLB_resize 			:= 	True
global 	arrow_bypass 			:= 	True
global 	arrow_bypass_enabled 	:= 	True
global 	togl_numpad 			:= 	true
global 	Fkeys_bypass_enabled 	:= 	True
global Bypass_Class_True
global 	fkeys_Arr 		:= 	[]		arrows[1] 	:= 	"Left"
global 	deletearr 		:= 	[]		arrows[2] 	:= 	"Right"
global 	numpadkeys_Arr 	:= 	[]		arrows[3]	:= 	"Up"
Global 	arrows			:= 	[]		arrows[4] 	:= 	"Down"
return

Menus:
menu, 	tray, 	add, 	Open Script Folder, Open_ScriptDir
menu, 	tray, 	icon, 	% TrayIconPath
menu, 	tray, 	add, 	Disable Numpad, 	togl_numpad
if togl_numpad 
		menu, 	tray, 	check, 				Disable Numpad
else 	menu, 	tray, 	uncheck, 			Disable Numpad
menu, 	tray, 	standard
return

sendf5:
send {f5}
TT("F5", "100")
return
phLaunch: 				;				 Process Hacker CTRL ALT ENTER
TT("LAUNCHING PH")
run % Path_PH
return

Open_ScriptDir()

DimensionChk:
WII := (W_Wins + X_net)
		if 	WII	<	256
			WII	:= 	256
	else if	WII	>	3000
			WII	:=	3000	
HII := (H_Wins + Y_net)
		if 	HII	<	256
			HII	:=	256
	else if HII	>	2000
		HII	:=	2000
x0x := (X_Cursor1- X_net)
		if 	x0X	< 	-1000
			X0X	:= 	-1000
	else if	X0X	>	3500
		X0X	:= 	3500
y0y := (Y_Cursor1 - Y_net)
		if 	y0y	< 	-1000
			y0y	:= 	-1000
	else if	y0y	>	2000
		y0y	:= 	2000	
return

/* 

; The following DllCall is optional: it tells the OS to shut down this script first (prior to all other applications).
DllCall("kernel32.dll\SetProcessShutdownParameters", "UInt", 0x4FF, "UInt", 0)
OnMessage(0x0011, "WM_QUERYENDSESSION")
return

WM_QUERYENDSESSION(wParam, lParam)
{
    ENDSESSION_LOGOFF := 0x80000000
    if (lParam & ENDSESSION_LOGOFF)  ; User is logging off.
        EventType := "Logoff"
    else  ; System is either shutting down or restarting.
        EventType := "Shutdown"
    try
    {
        ; Set a prompt for the OS shutdown UI to display.  We do not display
        ; our own confirmation prompt because we have only 5 seconds before
        ; the OS displays the shutdown UI anyway.  Also, a program without
        ; a visible window cannot block shutdown without providing a reason.
        BlockShutdown("Example script attempting to prevent " EventType ".")
        return false
    }
    catch
    {
        ; ShutdownBlockReasonCreate is not available, so this is probably
        ; Windows XP, 2003 or 2000, where we can actually prevent shutdown.
        MsgBox, 4,, %EventType% in progress.  Allow it?
        IfMsgBox Yes
            return true  ; Tell the OS to allow the shutdown/logoff to continue.
        else
            return false  ; Tell the OS to abort the shutdown/logoff.
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
key=AutoHotkeyScript\Shell\Open\Command
if A_IsAdmin    ; Set for all users.
    RegWrite, REG_SZ, HKCR, %key%,, %cmd%
else            ; Set for current user only.
    RegWrite, REG_SZ, HKCU, Software\Classes\%key%,, %cmd%

 */