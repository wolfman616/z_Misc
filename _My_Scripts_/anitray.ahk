; launched @ start up. and intended to be reloaded @ log on event MW2022
; mod tray item icon and of newly created processes tray items additionally and optionally ( with "ShellHookEnabled" set True )
;#Notrayicon ;
;#include <trayicon>
#NoEnv 
#Singleinstance,           Force
;ListLines,                       Off ; & dont 4get to k33st4h ur #keyhistory :)
DetectHiddenWindows,  On ; 
DetectHiddenText,    On ; 
SetTitleMatchMode,   2	
SetTitleMatchMode,   Slow
SetBatchLines,                -1
DetectHiddenText,         On
SetTitleMatchMode,        2
SetTitleMatchMode,      Slow
menu tray, add, hide me pls, hidmepls
menu tray, icon, hide me pls, C:\Icon\32\32.ico
gosub, Vars

ShellHookEnabled := True, RegKeeTray := "HKCU\SOFTWARE\_MW\Icons\Tray", AHK_exe := "C:\Program Files\Autohotkey\AutoHotkey.exe", Animate_target_scriptloc := "C:\Script\AHK\stixman_runnin\Animate_Target.ahk" ; see second half of script

gosub, regread_tray
settimer, TrAnIconZ_iNiT,-500

;r3gistrationZ
OnExit("AtExit") 
WM_Allow()												     ; allow windowmessages from lower process elevation
;OnMessage(0x4a, "Receive_WM_COPYDATA") ; register to recieve CDS "CopyDataStr" ; 

;shell3vnthooks
if     !ShellHookEnabled
	    return, ; end of init trayicons, see below for eventhooking events of new and old processes thus keeping systemtray up to date inline with desired changes.
else, gosub, Shellhook_stuff
return,
; end  of script main
; start of funcs & labels
;~`~'~💘~'~`~`~'~💘~'~`~`~'~💘~'~`~`~'~💘~'~`~`~'~💘~'~`~`~'~💘~'~`~`~'~💘~'~`~`~'~💘~'~`~`~'~💘~'~`~`~'~💘~'~`~`~'~💘~'~`~`~'~💘~'
hidmepls:
menu,tray,noicon
return,

Destroyanimations:
for, i, pid in Ani_PiD_icon
	Process, Close,% pid
return,

AtExit() { ; close each previously launched satellite script *ouch*
	gosub, Destroyanimations ; closes each previously launched satellite animation script pid
}

regread_tray: ; read saved prefs in format keyname = 
Loop, Reg,% RegKeeTraY
{
    if (A_LoopRegType = "REG_SZ") {
		regRead, TranIconSpath,% ( A_LoopRegKey . "\" . A_LoopRegSubKey),% A_LoopRegName
		TraniconREG_pARRsd[A_LoopRegName] := TranIconSpath
		dTect_TrayPname .=   A_LoopRegName . ","
}	}
return,

74iLHo0k( wParam , lParam ) {
	global TrayFullCnt,TrayInfo_Init_ARR,TraniconREG_pARRsd
	WinGet,      pname,% "ProcessName",% hwand := ("ahk_id " . tray_target_hwnd:= (Format("{:#x}", lParam)))
	wingetClass, Clas5,%      hwand 
	wingettitle, Title_last,% hwand 	
	switch wParam {		
		case "1": ; HSHELL_WINDOWCREATED
			tt(pname)
			TrayFullCnt:=TrayCount( 7000)	
			if !Tray_oldcnt {
				Tray_oldcnt := TrayFullCnt
				;gosub, TrAnIconZ_Refresh ;or settimer or make a func
			}
			if (TrayFullCnt != Tray_oldcnt) {
				settimer, TrAnIconZ_Refresh, -1 ;or settimer or make a func
				return
			}
		case "2": ; HSHELL_WINDOWDESTROYED	
			Tray_oldcnt := TrayCount()
			return,			
	}	
	return
}


TrAnIconZ_iNiT:
	TrAnIconZ_Refresh: ;gay :=  False ;Ani_T_Upd8_AllOW:=True
	TrayFullCnt:=TrayCount(delaytime := 10)	
	if analled
		analled:=""
	WinGet,      pname,% "ProcessName",% hwand := ("ahk_id " . (Format("{:#x}", lParam)))
	wingetClass, Clas5,%      hwand 
	wingettitle, Title_last,% hwand 	
	TrayInfo_Init_ARR  := TrayInfoGet()  ;  get all tray items !TrayInfo_Init_ARR := TrayIcon_GetInfo("MSIAfterburner.exe")
	loop,% (TrayFullCnt :=  TrayCount()) {
		_PN_ := TrayInfo_Init_ARR[ a_index ].process 
		TrAnItem_handl  :=  Format("{:#x}", TrayInfo_Init_ARR[ a_index ].hwnd)
		TrAnItem_UiD     :=  TrayInfo_Init_ARR[ a_index ].uid

		
		for, Index, TranIconSpath in TraniconREG_pARRsd  
		{
			;TrAnItem_hic:= ICO2hicon(TranIconSpath)
		a:=TranIconSpath  
			Ani_T_Upd8_AllOW:=(gay:=False)
			Animate_Target_PName := Index
			if (_PN_ = 		strreplace(Index,"Ani_",""))    {
				if (instr(Index,"Ani_"))        {                 
					_PN_NIGGER := index
					if !(instr(Ani_Trig_Ccstr, _PN_))          {
						if (a_thislabel = "TrAnIconZ_Refresh") {
							for, index in TranIcon_ArrQ
								if !( liv3handle := winexist("ahk_pid " . (liv3pid:=TranIcon_ArrQ[index].pid)))
									Ani_T_Upd8_AllOW := false
								else Ani_T_Upd8_AllOW := True ; preserve current animations
						}
						
						if (_PN_NIGGER = "AutoHotkeyU64_UIA.exe")    { 
							wingettitle, event_title_check, ahk_id %TrAnItem_handl%                            						
							if !(event_title_check ="C:\Script\AHK\WinEvent.ahk - AutoHotkey v1.1.33.10")  ; host script that launches this script
								gay := True
							else if !init_Eventscript_Trayico           {
									Ani_Trig_Ccstr .= ("," . _PN_NIGGER)
									Ani_T_Upd8_AllOW       := True,  
									init_Eventscript_Trayico := True
						  } else Ani_T_Upd8_AllOW        := False
						} else

						if (a_thislabel = "TrAnIconZ_iNiT") {
							Ani_Trig_Ccstr .=     ("," . _PN_)
							Ani_T_Upd8_AllOW := True
					}	}

					if (!gay && Ani_T_Upd8_AllOW )       { 	; proceed with target animation 
						Animate_Target_PName := _PN_ 
						faggot="%TranIconSpath%;%TrAnItem_handl%;%TrAnItem_UiD%"
						;msgbox % faggot " fag"
						run, "%AHK_exe%" "%Animate_target_scriptloc%" %faggot%,,,anipidNEW
						Ani_PiD_icon.push(anipidNEW)
						TranIcon_ArrQ[Animate_Target_PName]:=({ "hwnd" : TrAnItem_handl , "uid" : TrAnItem_UiD , "pid" : anipidNEW , "spath" : TranIconSpath , "sPN" : Animate_Target_PName })
		}	}	}	
	} ; end of for loop ; static icons below ;

									;msgbox % " dd" a_index				;msgbox % TrAnItem_hic "`n" TraniconREG_pARRsd[_PN_].hic
if TraniconREG_pARRsd[_PN_] 
		if zzz:=TraniconREG_pARRsd[_PN_]
			if(instr(dTect_TrayPname, _PN_)) { 
	if !strlen(zzz)
						tt( TrayInfo_Init_ARR[ a_index ].process	" " a_index)			;msgbox % TrAnItem_hic "`n" TraniconREG_pARRsd[_PN_].hic
		 ss:=(TraniconREG_pARRsd[_PN_].hic)
		if !ss {
							;msgbox % (TrAnItem_hic =TraniconREG_pARRsd[TrayInfo_Init_ARR[ a_index ].process ].hic) " coon " a_index

					Tray_Target_hicon := ICO2hicon(zzz)  
					if !strlen(Tray_Target_hicon)
					msgbox % Tray_Target_hicon
				;   create get handle of desired icon (hbitmap) 
					TrayIcon_SetII( TrAnItem_handl, TrAnItem_UiD, Tray_Target_hicon)
					TraniconREG_pARRsd[_PN_]:=({"hic" : Tray_Target_hicon }) 
						 ss:=(TraniconREG_pARRsd[_PN_].hic)
		if !ss 
							msgbox % (TrAnItem_hic =TraniconREG_pARRsd[TrayInfo_Init_ARR[ a_index ].process ].hic) " coondfd " a_index "prick"

				;msgbox % _PN_ " "  a:=TraniconREG_pARRsd[_PN_] " `n" TrAnItem_handl " " TrAnItem_UiD " , 2" Tray_Target_hicon
				}  else tt( "negros" TrAnItem_hic "`n" TraniconREG_pARRsd[_PN_].hic " " _PN_)
			} ;else, TrayIcon_Set( TrAnItem_handl, TrAnItem_UiD, Tray_Target_hicon := ICO2hicon(a:=TraniconREG_pARRsd[_PN_])  )
	}
	;end main loop
return




return,	
Shellhook_stuff:
gui, Slav3:	 New                    ; Dummy gui to reg SH_WM_
gui, Slav3: +LastFound +hwnd_Hw1nd  ; Hw1nd := WinExist() also works
gui, Slav3:	 Show,,% "SHELLHOOK"
gui, Slav3:	 Hide
DllCall("RegisterShellHookWindow", "UInt", _Hw1nd ) 
u_Msg_id  := DllCall("RegisterWindowMessage",   "Str" ,  "SHELLHOOK")
if errorlevel {
	msgbox, 0x0 ,% "shellhook",% "error"
	exitapp,
}   else, OnMessage( u_Msg_id,"74iLHo0k" )
return,

TrayCount(delaytime=""){
	global 
	sleep, %delaytime%
	loop, parse,% "Shell_TrayWnd,NotifyIconOverflowWindow", `,
	{
		idxTB := TrayIcon_GetTrayBar(a_loopfield)
		switch a_index {
			case "1":
				SendMessage, 0x0418, 0, 0, ToolbarWindow32%idxTB%,ahk_class %a_loopfield%
				Tray_MainCount     := ErrorLevel
			case "2":
				SendMessage, 0x0418, 0, 0, ToolbarWindow32%idxTB%,ahk_class %a_loopfield%
				Tray_OverflowCount := ErrorLevel
	}	}
	return, TrayFullCnt := (Tray_OverflowCount + Tray_MainCount)
}

TrayInfoGet(sExeName := "") { 
    oTrayInfo := []
    For key,sTray in ["Shell_TrayWnd", "NotifyIconOverflowWindow"]
    {
        WinGet, pidTaskbar, PID, ahk_class %sTray%
        hProc := DllCall("OpenProcess",    UInt,0x38, Int,0, UInt,pidTaskbar)
        pRB   := DllCall("VirtualAllocEx", Ptr,hProc, Ptr,0, UPtr,20, UInt,0x1000, UInt,0x04)
        szBtn := VarSetCapacity(btn, (A_Is64bitOS ? 32 : 20), 0)
        szNfo := VarSetCapacity(nfo, (A_Is64bitOS ? 32 : 24), 0)
        szTip := VarSetCapacity(tip, 128 * 2, 0)
        idxTB := TrayIcon_GetTrayBar(sTray)
        SendMessage,    0x0418,   0,    0,   ToolbarWindow32%idxTB%, ahk_class %sTray% ; TB_BUTTONCOUNT = 0x0418
        Loop,% (TB_BUTTONCOUNT := ErrorLevel) { 
            SendMessage,0x0417,A_Index-1,pRB,ToolbarWindow32%idxTB%, ahk_class %sTray% ; TB_GETBUTTON 0x0417
            DllCall("ReadProcessMemory", Ptr, hProc, Ptr, pRB,    Ptr,&btn, UPtr,szBtn,  UPtr, 0)
            dwData  := NumGet(btn, (A_Is64bitOS ? 16 : 12), "UPtr")
            iString := NumGet(btn, (A_Is64bitOS ? 24 : 16), "Ptr" )
            DllCall("ReadProcessMemory", Ptr,hProc, Ptr,dwData, Ptr,&nfo, UPtr,szNfo, UPtr, 0)
            uId     := NumGet(nfo, (A_Is64bitOS ?  8 :  4), "UInt")
            msgId   := NumGet(nfo, (A_Is64bitOS ? 12 :  8), "UPtr")
            hIcon   := NumGet(nfo, (A_Is64bitOS ? 24 : 20), "Ptr" )
			hWnd    := NumGet(nfo, 0, "Ptr")
			WinGet, sPN, ProcessName, ahk_id %hWnd%
            WinGetClass, sClass,      ahk_id %hWnd%
            WinGet, nPid, PID,        ahk_id %hWnd%
            If ( !sExeName || sExeName == sPN || sExeName == nPid ) {
                DllCall("ReadProcessMemory", Ptr,hProc, Ptr,iString, Ptr,&tip, UPtr,szTip, UPtr,0)
                oTrayInfo.Push({ "idx" : A_Index-1
                               , "idcmd"    : idCmd
                               , "pid"      : nPid
                               , "uid"      : uId
                               , "msgid"    : msgId
                               , "hicon"    : hIcon
                               , "hwnd"     : hWnd
                               , "class"    : sClass
                               , "process"  : sPN
                               , "tooltip"  : StrGet(&tip, "UTF-16")
                               , "tray"     : sTray })
		}	}
        DllCall("VirtualFreeEx", "Ptr", hProc, "Ptr", pRB, "UPtr",0, "UInt", 0x8000)
        DllCall("CloseHandle",   "Ptr", hProc)
    } 
    return, oTrayInfo
}
TrayIcon_SetII(hWnd, uId, hIcon){
   ;VarSetCapacity(NID, szNID := (A_IsUnicode ? 2 : 1) * 384 + A_PtrSize*5 + 40,0)
    VarSetCapacity(NID, szNID := 528)
    NumPut( szNID, NID, 0 )
    NumPut( hWnd,  NID, (A_PtrSize == 4) ? 4  : 8  )
    NumPut( uId,   NID, (A_PtrSize == 4) ? 8  : 16 )
    NumPut( 2,     NID, (A_PtrSize == 4) ? 12 : 20 )
    NumPut( hIcon, NID, (A_PtrSize == 4) ? 20 : 32 )
	try res:=DllCall("Shell32.dll\Shell_NotifyIcon", "UInt" ,0x1, "Ptr",&NID,"ptr")
    ; NIM_MODIFY := 0x1
	if !res {
		;tt( "tray icon issue: " LastError.hex " " runwait1("C:\Windows\System32\Err_6.4.5.exe " LastError.hex),2)
		return, 0
	} else, Return, res
}
TrayIcon_MoveII(idxOld, idxNew, sTray := "Shell_TrayWnd"){
    d := A_DetectHiddenWindows
    DetectHiddenWindows, On
    idxTB := TrayIcon_GetTrayBar(sTray)
    SendMessage, 0x452, idxOld, idxNew, ToolbarWindow32%idxTB%, ahk_class %sTray% ; TB_MOVEBUTTON = 0x452
    DetectHiddenWindows, %d%
}

TrayIcon_HideII(idCmd, sTray:="Shell_TrayWnd", bHide:=True){
    d := A_DetectHiddenWindows
    DetectHiddenWindows, On
    idxTB := TrayIcon_GetTrayBar(sTray)
    SendMessage, 0x0404, idCmd, bHide, ToolbarWindow32%idxTB%, ahk_class %sTray% ; TB_HIDEBUTTON
    SendMessage, 0x001A, 0, 0, , ahk_class %sTray%
    DetectHiddenWindows, %d%
}

TrayIcon_DeleteII(idx, sTray="Shell_TrayWnd"){
    d := A_DetectHiddenWindows
    DetectHiddenWindows, On
    idxTB := TrayIcon_GetTrayBar(sTray)
    SendMessage, 0x0416, idx, 0, ToolbarWindow32%idxTB%, ahk_class %sTray% ; TB_DELETEBUTTON = 0x0416
    SendMessage, 0x001A, 0, 0, , ahk_class %sTray%
    DetectHiddenWindows, %d%
}

TrayIcon_RemoveII(hWnd, uId){
        VarSetCapacity(NID, szNID := 528)
        NumPut( szNID, NID, 0           )
        NumPut( hWnd,  NID, A_PtrSize   )
        NumPut( uId,   NID, A_PtrSize*2 )
        Return DllCall("Shell32.dll\Shell_NotifyIcon", UInt,0x2, UInt,&NID)
}

Tray_Count() {
	static TB_BUTTONCOUNT = 0x418
	tid := Tray_getTrayBarII()
	SendMessage,TB_BUTTONCOUNT,,,, ahk_id %tid%
	return, ErrorLevel
}				
  
Tray_Focus(hGui="", hTray="") { ; If both parameters are missing, function will focus Notification area.
	static NIM_SETFOCUS=0x3

	if (hGui hTray = "") {
		hwnd := WinExist("ahk_class Shell_TrayWnd")
		WinActivate, ahk_id %hwnd%
		WinWaitActive, ahk_id %hwnd%
		ControlSend,, ^{TAB}, ahk_class Shell_TrayWnd
		return
	}

	VarSetCapacity( NID, 528, 0) 
	 ,NumPut(88,	NID)
	 ,NumPut(hGui,	NID, 4)	
	 ,NumPut(hTray,	NID, 8)
	
	r := DllCall("shell32.dll\Shell_NotifyIconA", "uint", NIM_SETFOCUS, "uint", &NID)
}

Tray_ModifyII( hGui, hTray, Icon, Tooltip="~`a " ) {
	static NIM_MODIFY=1, NIF_ICON=2, NIF_TIP=4
	VarSetCapacity( NID, 528, 0)
	NumPut(88, NID, 0)
	hFlags := 0
	hFlags |= Icon != "" ?  NIF_ICON : 0
	hFlags |= Tooltip != "" ? NIF_TIP : 0
	if (Icon != "") {
		hIcon := Icon/Icon ? Icon : Tray_loadIcon(Icon)
		DllCall("DestroyIcon", "uint", Tray( hTray "hIcon", "") )
		Icon/Icon ? Tray( hTray "hIcon", hIcon) :
	}
	if (Tooltip != "~`a ")
		DllCall("lstrcpyn", "uint", &NID+24, "str", Tooltip, "int", 64)
	NumPut(hGui,	  NID, 4)
	 ,NumPut(hTray,	  NID, 8)
	 ,NumPut(hFlags,  NID, 12)
	 ,NumPut(hIcon,   NID, 20)
	return, DllCall("shell32.dll\Shell_NotifyIconA", "uint", NIM_MODIFY, "uint", &NID)	
}

Tray_getTrayBarII(){
	ControlGet, h, HWND,, TrayNotifyWnd1  , ahk_class Shell_TrayWnd
	ControlGet, h, HWND,, ToolbarWindow321, ahk_id %h%
	return h
}
Tray_Add( hGui, Handler, Icon, Tooltip="") {
	static NIF_ICON=2, NIF_MESSAGE=1, NIF_TIP=4, MM_SHELLICON := 0x500
	static uid=100, hFlags

	if !hFlags
		OnMessage( MM_SHELLICON, "Tray_onShellIcon" ), hFlags := NIF_ICON | NIF_TIP | NIF_MESSAGE 

	if !IsFunc(Handler)
		return A_ThisFunc "> Invalid handler: " Handler

	hIcon := Icon/Icon ? Icon : Tray_loadIcon(Icon, 32)
    VarSetCapacity(NID, szNID :=528)
    numput( szNID, NID, 0)
    numput( hGui,  NID, (A_PtrSize == 4) ? 4    : 8  )
	numput( ++uid, NID, (A_PtrSize == 4) ? 8   : 16 )
	numput( hFlags,NID, (A_PtrSize == 4) ? 12  : 20 )
	numput( MM_SHELLICON, NID, (A_PtrSize == 4) ? 16  : 28 )
	numput( hIcon, NID, (A_PtrSize == 4) ? 20  : 32 )
	DllCall("lstrcpyn", "uint", &NID+24, "str", Tooltip, "int", 128) ; not working at this point

	if !DllCall("shell32.dll\Shell_NotifyIconW", "uint", 0, "uint", &NID)
		return, 0
	Tray( uid . "handler", Handler)
	Icon/Icon ? Tray( uid "hIcon", hIcon) :		;save icon handle allocated by Tray module so icon can be destroyed.
	return, hIcon
}

Tray_onShellIcon(Wparam, Lparam) {
	static EVENT_512="P", EVENT_513="L", EVENT_514="Lu", EVENT_515="Ld", EVENT_516="R", EVENT_517="Ru", EVENT_518="Rd", EVENT_519="M", EVENT_520="Mu", EVENT_521="Md"
	TT(Wparam " " Lparam "`n" EVENT_%event%)
	;wparam = uid, ; msg = lparam loword
	handler := Tray(Wparam "handler")  ,event := (Lparam & 0xFFFF)
	return %handler%(Wparam, EVENT_%event%)
}











MinTrayGO: ; launch surrogate tray item bearing ahkproc, supplanting the designated exilee
AHK_exe   := "C:\Program Files\Autohotkey\AutoHotkey.exe"
MintrayPN := "C:\Script\AHK\stixman_runnin\trayholder.ahk"
;s:=new_path . ";" . OutputVarWin . ";" . new_PiD . ";" .\ new_tt
s:= therest
loop, parse, therest,% ";",
{
	switch a_index {
		case "1":
			pathh  := a_loopfield
		case "2":
			handle := a_loopfield
		case "3":
			pid    := a_loopfield
		case "4":
			ttl    := a_loopfield
}	}
s:="""%therest%""" 
run, %AHK_exe% %MintrayPN% %s%,,,minholdernew
sleep, 330
minholder.push({"pid" : pid : "hwnd" : handle, "pth" : pathh})
winhide, ahk_id %OutputVarWin% 
return
 
mintraycombine:   
for, i in minholder
	if (minholder[i].pth = new_path) {
		if fagbot := minholder[i].PiD 
			;s:=new_path . ";" . OutputVarWin . ";" . new_PiD . ";" . new_tt
			s:= therest
		Send_WM_COPYDATA(s, t:=("trayholder.ahk  ahk_pid " . fagbot))
		winhide, ahk_id %OutputVarWin% 	 
	}
return,

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


HIWORD(Dword,Hex=0){
    BITS:=0x10,WORD:=0xFFFF
    return (!Hex)?((Dword>>BITS)&WORD):Format("{1:#x}",((Dword>>BITS)&WORD))
}

LOWORD(Dword,Hex=0){
    WORD:=0xFFFF
    Return (!Hex)?(Dword&WORD):Format("{1:#x}",(Dword&WORD))
}
 

MAKELONG(LOWORD,HIWORD,Hex=0){
    BITS:=0x10,WORD:=0xFFFF
    return (!Hex)?((HIWORD<<BITS)|(LOWORD&WORD)):Format("{1:#x}",((HIWORD<<BITS)|(LOWORD&WORD)))
}
vars:
global Init_Wineventtrani,a_Path,Animate_target_scriptloc,Ani_PiD_icon,Ani_Trig_Ccstr,TrayInfo_Init_ARR,TraniconREG_pARRsd,dTect_TrayPname,Tray_array_target_pos,TrayFullCnt,tray_hwnd,Trayicon_loaded_PN,Trayicon_loaded_Title,Trayicon_loaded_uid,Tray_MainCount,Tray_newTT,Tray_OverflowCount,Tray_Target_hicon,tray_target_hwnd,tray_target_Parent,Tray_Target_PN,Tray_target_pos,tray_target_title,tray_target_tloc,tray_target_tlocm,tray_target_tt,tray_target_uid,tray_target_UNCPath,trayhw,TTTParent,tpname,FullIndex,IconArr_PN,ShellHookEnabled,Animate_target_scriptloc,AHK_exe,TranIcon_ArrQ,Ani_T_Upd8_AllOW,gay,init_Eventscript_Trayico,RegKeeTray,minholder,s,therest,TrAnItem_handl,TrAnItem_UiD,_PN_,analled,a,TranIconSpath,_PN_NIGGER,zzz,ss,Tray_oldcnt

loop, parse,% "TrayInfo_Init_ARR,TraniconREG_pARRsd,Ani_PiD_icon,TranIcon_ArrQ,minholder", `, 
	%a_loopfield% :=[{}] ; create empty array 
return,