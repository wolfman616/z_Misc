#Singleinstance,      Force
coordMode,  tooltip,  Screen	
coordmode,  mouse,    screen
DetectHiddenWindows,  On
DetectHiddenText,     On
SetTitleMatchMode,    2	;	
SetTitleMatchMode,    Slow
setWorkingDir,        %A_ScriptDir%
SetBatchLines,        -1
SetWinDelay,          -1
;ListLines,           Off 
#include              <_struct>
#include              <tb>
#NoEnv 

; ===>" binds " below line 500

INIT_SEQ := "Varz>quotEI>RegReads>Menu_Tray_Init>Menu_Style_Init>Hooks>Main"

gosub, init_matt
UProc := RegisterCallback("UEventHook", "")
return,

Main: ; sript & hooks initiated 
dbgtt := True
wm_allow()
aero_lib()  
Aero_StartUp()

return,

	; Time_Idle := A_TimeIdlePhysical	; total time to screensaver = 420
	; if Time_Idle < 440
	; settimer, timer_idletime,% ("-" . (430 - A_TimeIdlePhysical))	
	;timer_idletime: 		        ; test
	;ttp("timer complete.")
	;return,

UEventHook(UProc, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
global
	i:=Format("{:#x}", event) 
	for, index, element in winevents
		if element = %i%
			evt := Index
	ttp(( "Event: " evt "`nhandle: " hWnd "`nOBJ: " idObject ), "800")
}
 
windowiconRem:
WindowIconSet(OutputVarWin,Ppath)
loop, parse,% "new_cl,new_Pn,new_tt",`,
{
	icon_Path_temp_ := a_loopfield
	stringTrimLeft, iid_grp, icon_Path_temp_, 4
	regdelete,% ("HKEY_CURRENT_USER\SOFTWARE\_MW\Icons\" . iid_grp),% (%icon_Path_temp_%)
	icon_%iid_grp%_arr.pop(%icon_Path_temp_%)
}
icon_Path_temp_ := ""
winget, ppath, ProcessPath,% TargetHandle
return,
  
Iconchange_Check(handle,cl="",Pn="",TTl="")  {
	global
	if !(icon_cl_arr[cl]) && !(icon_PN_arr[Pn]) && !(icon_tt_arr[TTl])
		return, False
	if ttl
		act:="tt"
	if cl
		act:="cl"
	if Pn
		act:="pn"
	tt23=icon_%act%_arr
	if %tt23%[%act%]  {
		Ico_arr_temp_ := %tt23%[%act%]
		if ( instr(Ico_arr_temp_, " *") )
			StringTrimRight, filename, Ico_arr_temp_, 2
		else filename:=Ico_arr_temp_
		WindowIconSet(handle,filename)	
		icon_clhw_arr.push(handle)
		return, True
}	}		

window_icon_New: 
wingetClass, Cl_,% TargetHandle 
winGet,      pn_, processname,% TargetHandle
wingettitle, tt_,% TargetHandle
fileSelectFile, new_icon_path, Options, C:\ICON\,% pn_ "Icon Selector" ,% "Icun (*.ico)"
if fileexist( new_icon_path ) { 	
	WindowIconSet(OutputVarWin,new_icon_path)
	msgbox,% "ok Icon will be saved for " processname
} else{
	msgbox,% new_icon_path ". error with selected file."
	return,
}
if  !IProcName && !ITitle && !IClass {
	 msgbox, nothing to save dave
	 return,
} else { 
	    if !IProcName  && ITitle  && !IClass 
		 action_ :=  "tt"
	else if !IProcName && !ITitle && IClass 
		 action_ :=  "cl"
	else if IProcName  && !ITitle && !IClass 
		 action_ :=  "pn"
	else { 
		action_ :=  "pn"
		new_icon_path := (new_icon_path . " *")
}	}
typeid = %action_%_
icon_%action_%_arr[%typeid%] := new_icon_path     ; set array member up for current session
regWrite,% "REG_SZ",% ("HKEY_CURRENT_USER\SOFTWARE\_MW\Icons\" . action_),% %typeid% ,% new_icon_path
WindowIconSet(OutputVarWin,new_icon_path)         ; apply the new icon
return,

#c::	;-=-LASTWINDOWSGUI-=--=-LASTWINDOWSGUI-=--=-LASTWINDOWSGUI-=--=-LASTWINDOWSGUI-=--=-LASTWINDOWSGUI-=--=-LASTWINDOWSGUI-=--=-LASTWINDOWSGUI-=-
Menu, MenuBar,   Add, File,     last_classes_names2
Menu, MenuBar,   Add, View,     last_classes_names2
Menu, MenuBar,   Add, Options,  last_classes_names2

guilastclass: ;gui, Gui_lastclass: Destroy
gui, Gui_lastclass: New, +dpiscale +hwndWindle, Last Window-Class Objects
gui, Gui_lastclass: Margin,% marginSz,% marginSz
gui, Gui_lastclass: Menu, MenuBar

;-=-ToolBar-=--=-ToolBar-=--=-ToolBar-=--=-ToolBar-=--=-ToolBar-=--=-ToolBar-=--=-ToolBar-=--=-ToolBar-=--=-ToolBar-=--=-ToolBar-=--=-ToolBar-=-
gui, Gui_lastclass:Add, Custom , x0 y0 h36 ClassToolbarWindow32 0x100   ;(TBSTYLE_TOOLTIPS:=0x100)|(TBSTYLE_LIST:=0x1000); button-text to side 
vCount := 5, vSize := (A_PtrSize=8?32:20)
ControlGet,  hTB,Hwnd,,ToolbarWindow321, % "ahk_id " Windle
SendMessage, 0x43C,0,0,,% ("ahk_id " . hTB) ;TB_SETMAXTEXTROWS ;button text omitted.*if more than one button has the same idCommand, then only the last button with that idCommand will have make the call.
VarSetCapacity(TBBUTTON, vCount * vSize, 0)
Loop, %vCount% {
	vTxt%A_Index%    :=   "TB " A_Index
	vOffset          :=   (A_Index-1)*vSize
	NumPut(A_Index - 1,   TBBUTTON, vOffset,   "Int")                  ;iBitmap
	NumPut(A_Index - 1,   TBBUTTON, vOffset + 4, "Int")                ;idCommand
	NumPut(0x4,           TBBUTTON, vOffset + 8, "UChar")              ;fsState	;TBSTATE_ENABLED := 4
	NumPut(&vTxt%A_Index%,TBBUTTON, vOffset+(A_PtrSize=8?24:16),"Ptr") ;iString
}
hIL := IL_Create(5, 2, 0) ; set up button resz
IL_Add(hIL, "C:\Script\AHK\APP_COG.ico",      0)
IL_Add(hIL, "C:\Icon\24\recycle24shadow.ico", 0) 
IL_Add(hIL, "C:\Icon\24\invert_goatse_24.ico",0)
IL_Add(hIL, "C:\Icon\24\unndoo3_0.ico",       0)
IL_Add(hIL, "C:\Icon\24\reedoo_2 - Copy.ico", 0) 
SendMessage, 0x430, 0,% hIL,,% "ahk_id " hTB                           ;(TB_SETIMAGELIST := 0x430)
TB_ADDBUTTONSW   :=  0x444                                             ;(TB_ADDBUTTONSA  := 0x414)
vMsg := (A_IsUnicode?0x444:0x414)
SendMessage, % vMsg,% vCount,% &TBBUTTON,,% "ahk_id " hTB              ;(TB_ADDBUTTONSW / TB_ADDBUTTONSA)
;-=-ListView-=--=-ListView-=--=-ListView-=--=-ListView-=--=-ListView-=--=-ListView-=--=-ListView-=--=-ListView-=--=-ListView-=--=-ListView-=-
gui, Gui_lastclass:Add, ListView, w800 y35 x0 0x4 LV0x8200 Grid R38 +Multi NoSort, Class (Created)|hWnd (Created)|Class (Focused)|hwnd (Focused)
LV_ModifyCol(1, "185 Text"), LV_ModifyCol(2, "Text 125"),LV_ModifyCol(3, "185 Text"), LV_ModifyCol(4, "Text 125")
loop %clst_max_I%
	LV_Add(,classeslast[ a_index ], Format("{:#x}", classhwlast[ a_index ]), classeslast2[ a_index ], Format("{:#x}", classhwlast2[ a_index ]))
gui,  Gui_lastclass: Show, noactivate w530 h600 center
if hTB
	 SendMessage, 0x421,,,, % "ahk_id " hTB ; TB_AUTOSIZE
gui, Gui_lastclass:submit, nohide
return,

; for  index, element in classeslast
; if   index = 1
	 ; classeslast_list:=element . "`n"
; else classeslast_list:=classeslast_list . element . "`n"
; return,
; msgbox,,% "Last-Initialized Classes",% classeslast_list

OnObjectCreated(HookCr, event, hWnds, idObject, idChild, dwEventThread, dwmsEventTime) {
global
	wingetClass, Class,% (hwand := ("ahk_id " . Format("{:#x}", hWnds))) ;
	winget, PName, ProcessName,% hwand
	wingettitle, Title_last,% hwand 
	if Title_last = no_glass
		return	
	if TTCCquick 
		tt(pname)
	switch Class {
	 	case "AutohotkeyGUI":
		if !Instr("no_glass,rotate png alpha device context.ahk",Title_last)
				Aero_BlurWindow(hWnds)
			if (instr(Title_last,(ccc:="C:\Script\AHK\adminhotkeys.ahk"))) { 
				menu, tray, check, Launch Adhkrun
				tt(Title_last . " detected admin hotkey connecting")
			}
		;case "AutoHotkey":
			;Aero_BlurWindow(hWnds)
		case "#32768","BaseBar":
			Aero_BlurWindow(hWnds)
			return,
		case "SysShadow":
			winset, transparent, 1,% ("ahk_id " . hWnds)
		case "gdkWindowToplevel","Net UI Tool Window":
			Aero_BlurWindow(hWnds)
		case "MainWindowClassName","FileTypesMan":
			Aero_BlurWindow(hWnds)
		case "Notepad++":
		msgbox notepad
			Aero_BlurWindow(hWnds)
		;case "WTouch_Message_Window":
		;case "Notepad":
		case "OperationStatusWindow": 		
			Aero_BlurWindow(hWnds)
			if ((Title_last = "Replace or Skip Files") || (Title_last = "Confirm Folder Replace") || (Title_last = "Folder In Use")) {
				return, ;currently disabled
				msgbox,% " test 5 ",,,4
				DEBUGTEST_FOC := True
				DEBUGTEST_HWND    := wineXist("A")
				winset, exStyle, +0x08000080,% hwand
				winset, Style,   +0x80000000,% hwand
				win_move((oioi:=Format("{:#x}"), hWnds), 3000, 900, "", "", "")
				tooltip,% "Preparing...",,,4
				msgbox,%  ("old1" old_focus1 "`nold2" old_focus2 "`nold3" old_focus3 "`nol4g1" old4gnd1 "`nol4g2" old4gnd2 "`nol4g3" old4gnd3)
				winactivate,% ("ahk_id " . old_focus1)Title_last ,% hwand
				settimer, tooloff, -128
			}
		case "MozillaDialogClass":
			winget, Style, Style,% hwand
			winget, exStyle, exStyle,% hwand
			If ((STYLE = 0x16CE0084) && (EXSTYLE = 0x00000101)) ; identifying popout window
				winset, Style,0x16860084,% hwand 
		case "NotifyIconOverflowWindow","TaskListThumbnailWnd","Net UI Tool Window Layered":
			winset, ExStyle, ^0x00000100,% hwand
			winset, Style,    0x94000000,% hwand
		case "MMCMainFrame":
			Aero_BlurWindow(hWnds)
			1998 := hwand
			settimer, 1998, -700
		case "TaskListThumbnailWnd":	
			Aero_BlurWindow(hWnds)
		case "CabinetWClass":
			Aero_BlurWindow(hWnds)
			1999 := hwand
			settimer, 1999, -700
		case "RegEdit_RegEdit","FM":
			Aero_BlurWindow(hWnds)
			ControlGet, ctrlhand, Hwnd,, SysListView321,% hwand
			; enable row select (vs single cell) LVM_SETEXTENDEDLISTVIEWSTYLE := 0x1036
			SendMessage 0x1036, 0, 0x00000020,, ahk_id %ctrlhand% 
			ControlGet, ctrlhand2, Hwnd,, SysTreeView321,% hwand
			winset, Style, +0x00000200, ahk_id %ctrlhand2%
		case "WMP Skin Host":
			if wmp_init_trigger 
				return,
			wmp_init_trigger:= true
			winset, style, -0x480000,% hwand
		case "7 Sidebar":
			winget, Time_hWnd, iD, ahk_class 7 Sidebar
			winset, ExStyle, 0x000800A8,%  "HUD Time",% "ahk_id " Time_hWnd:=Format("{:#x}",Time_hWnd)
			winset, ExStyle, 0x000800A8,%  "Moon Phase II"
			sidebar := True
		case "ApplicationFrameWindow","Chrome_WidgetWin_1","WINDOWSCLIENT":	
			if !(Title_Last="Roblox") 
				return,
			p ="C:\Program Files\AHK\AutoHotkeyU32_UIA.exe" "C:\Script\AHK\Roblox_Rapid.ahk"
			result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
			settimer, RobloxGetHandle, -2000
			run,% p
			sbardisabletoggle() 
			if (m2dstatus != "not running or paused") && (m2dstatus !=False) {
				PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey
				PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey	
			}
			if(m2dstatus = False) {
				settimer, m2_Status_Req36, -5000
				return,
				m2_Status_Req36:
				if (m2dstatus != "not running or paused"	) && (m2dstatus !=False) {
					PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey		
					PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey		
			}	}	
		case "MsiDialogCloseClass":
			if id := winexist("ahk_class MsiDialogCloseClass") 
				txt  :=  "dialog",   c_ntrolName  :=  "Static1"
			if (mainc_nt = Format("{:#x}", (WinExist("ahk_exe msiexec.exe",txt)))) {
				ControlGet, c_ntHandle, hWnd ,,%c_ntrolName% , ahk_id %mainc_nt%
				StyleMenu_Showindow( c_ntHandle, !IsWindowVisible( c_ntHandle))
				tooltip,% ("ProcdEvent: " . MsiDialogCloseClass . "`n" . id " yes..." . mainc_nt . " main " . hWnds . "`n" . c_ntHandle)
			}
		case "WindowsForms10.Window.8.app.0.141b42a_r9_ad1": ; Multi game instance (ROBLOX)
			StyleMenu_Showindow(hWnds, !IsWindowVisible(hWnds))
			winset, Style, 0x80000000,% hndDS
		case "#32770":
			Aero_BlurWindow(hWnds)
			explorer_opensave_DLG:="Open,Save As,Save File As,Save Image,Enter name of file to save to...,"
			if (Title_last = "Information") {
				winactivate, Information
				winwaitactive, Information
				send, N
			}
			else if Title_last {
				if instr(explorer_opensave_DLG,(Title_last . ",")) {
					nnd := Format("{:#x}", hWnds)
					return, ; disabled for testing
					gosub, 32770Fix
				}
			if (PName = "notepad++.exe")       {
				winget, currentstyle, Style,% hwand
				if (currentstyle = 0x94CC004C) {
					sleep, 580
					winset, Style, -0x00400000,% hwand
			}	}
			 else, if (PName = "explorer.exe")    {
				if (Title_last = "Folder In Use") {
					WinGetText, testes,% hwand
					tt("File handle open")
			} } }
		case "Notepad++":
			Aero_BlurWindow(hWnds)
			if np 
				return,
			sem := "Notepad++ Insert AHK Parameters.ahk - AutoHotkey"
			if !WinExist(sem) 
				run,% "C:\Script\AHK\- Script\Notepad++ Insert AHK Parameters.ahk",,hide
			np := True
		default: 
			if (IsWindow(hWnds))           {
				winget Style, Style,% hwand
				if (Style & 0x10000000)    {
					if   !Tool || if Tool=20
						  Tool := 1
					else, Tool += 1
					offset:= offsett 
					if !EventLogBuffer_Old {
						EventLogBuffer_Old=%class%`n
					} else,                {
						clist=%EventLogBuffer_Old%%class%`n
						EventLogBuffer_Old = % CLIST
					}
					tooly =% offset	
					classname=%Class%`n
					settimer, EventLogBuffer_Push, -4000
	}	}	}	
	pushclsl_(Class)
	pushclsh_(hWnds)
	 Iconchange_Check(hWnds, Class, PName)

	winget PName, ProcessName,% hwand
	if TTcr
		ttp(("OBJ_CREATE EVENT: " PName "`nTitle: " Title_last "`nAHK_Class: " Class "`nAHK_ID: " hWnds))
	StyleDetect(hWnds, Style_ClassnameList2, Class,      Array_LClass) 
	StyleDetect(hWnds, Style_wintitleList2,  Title_last, Array_LTitle) 
	StyleDetect(hWnds, Style_procnameList2,  PName,      Array_LProc) 

	switch pname {
		case "slsk2.exe","ResourceHacker.exe","J COLOR PICKER.exe":
		Aero_BlurWindow(hWnds)
		;case "RzSynapse.exe":
			;settimer RZ_LOG, -1
		;case "WTabletServicePro.exe":
			;msgbox
		;case "GoogleDriveFS.exe":
			;msgbox,% (Title_last . " titlelast!")
	}
	
	switch, Title_last {
		case "Razer Synapse Account Login":
			settimer RZ_LOG, -1
		case "Google Drive Sharing Dialog":
			;msgbox, ggg
	}
	
	EventLogBuffer_Push:
	If   !EventLogBuffer
		  EventLogBuffer =% EventLogBuffer_Old
	else, EventLogBuffer := EventLogBuffer . "`n" . EventLogBuffer_Old
		EventLogBuffer_Old:=(clist:=(offset:=(tool:=(""))))
	return,
}

On4ground(hook4g, event, hWnd4, idObject, idChild, dwEventThread, dwmsEventTime) {
	old4gnd3 := old4gnd2, old4gnd2 := old4gnd1, old4gnd1 := hWnd4
	; if (DEBUGTEST_FOC && (hWnd4 != DEBUGTEST_HWND)) {
		; msgbox,% ("focus lost " .  DEBUGTEST_HWND)	;ttp(("focus lost " . DEBUGTEST_HWND))
		; DEBUGTEST_HWND := ""
		; DEBUGTEST_FOC := False
	; }
	4gnd_hwnd := ("ahk_id " . hWnd4)
	wingetClass, Class,%              4gnd_hwnd
	wingettitle, Title_last,%         4gnd_hwnd	
	winget,      PName, ProcessName,% 4gnd_hwnd
	if TT4g
		tooltip, 4Ground EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd4%
	Iconchange_Check(hWnd4,Class,PName)
	
	switch Class {
		case "MainWindowClassName": ; ProcessHacker
			controlget, PH_edit1_cHnd ,hwnd,, Edit1, ahk_id %hWnd4%
			if PH_edit1_cHnd
				ControlGetFocus, PM_focused_cHnd,  ahk_id %hWnd4%
			if PM_focused_cHnd != Edit1
				ControlFocus , Edit1, ahk_id %hWnd4%
            SendMessage,% (EM_SETSEL := 0x00B1), 0, -1,Edit1, ahk_id %hWnd4% 
			;Selects a range of characters in edit control. If the start is 0 and the end is -1, all the text in the edit control is selected. If the start is -1, any current selection is deselected.
		case "#32770":	; msg box 
			wingettitle, Title_last,% 4gnd_hwnd	
			if (Title_last = "Roblox Crash")  {
				if !crashmb
					crashmb   := 1
				else, crashmb += 1
				winget, RobloxCrash_PID, PID ,% 4gnd_hwnd
				Roblox_PID=TASKKILL.exe /PID %RobloxCrash_PID%
				run %comspec% /C %Roblox_PID%,, hide
				if winexist("ahk_exe robloxplayerbeta.exe") 
					run C:\Apps\Kill.exe robloxplayerbeta.exe,, hide	; 	run C:\Apps\Kill.exe Multiple_ROBLOX.exe,, hide
				if winexist("ahk_pid %Roblox_PID%")
					msgbox,% "Error",% A_lasterror
					if SBAR_disable
						sbardisabletoggle() 
			} else,
			if (Title_last = "Information")   {
				winexist()
				WinActivate, ; WinActivate, ahk_class #32770
				send, n
				MessageBoxKill(hWnd4)
	}
		case "ApplicationFrameWindow","Chrome_WidgetWin_1","WINDOWSCLIENT":
			ttt := "M2Drag.ahk - AutoHotkey", result := Send_WM_COPYDATA("status",ttt)
			wingettitle, Title_last,% 4gnd_hwnd	
			ttt := "M2Drag.ahk - AutoHotkey", result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
			settimer, tooloff, -2222
			if roblox {
				gethandle_roblox() 
				settimer, m2_Status_check, -4000
				return,
				
				m2_Status_check:
				if( m2dstatus != "not running or paused"	) {
					PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey	; 	65306 = Pause
					PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey	; 	65305 = Suspend
				}
				m2dstatus := False
			}
		Default:
			ttt := "M2Drag.ahk - AutoHotkey", result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
			if (result = "FAIL") {
				settimer, m2_Status_Req, -1000
				return,
				
				m2_Status_Req:
				result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
				return,
			}
			else, if (result = 0) {
				settimer, m2_Status_Req2, -1000
				return,
				
				m2_Status_Req2:
				result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
				return,
			}
			settimer, tooloff, -2222

			if roblox 
				gethandle_roblox() 
				settimer, m2_Status_Req3, -2800
				return,
				m2_Status_Req3:
			if (m2dstatus = "not running or paused") {
				settimer, m2_Status_Req4, -2800
				return,
				
				m2_Status_Req4:
				result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
				PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey
				PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey
				return,
			}
			m2dstatus := False 
			return,
	} 
	
	switch pname {
		case "RzSynapse.exe":
			settimer RZ_LOG, -1
		case "GoogleDriveFS.exe":
		msgbox,% "gfs",% "detected"
			invert_win(hWnd4)		
	}
	
	switch, Title_last {
		case "Razer Synapse Account Login":	;case "Google Drive Sharing Dialog":;msgbox
			settimer RZ_LOG, -1
	}
}

OnFocus(HookFc, event, BK_UN_T, idObject, idChild, dwEventThread, dwmsEventTime) {	;old_focus2 := old_focus1 ;	old_focus1 := BK_UN_T
	if (DEBUGTEST_FOC && (BK_UN_T != DEBUGTEST_HWND)) {
		msgbox,% ("focus lost " . DEBUGTEST_HWND)	;ttp(("focus lost " . DEBUGTEST_HWND))
		DEBUGTEST_HWND := ""
		DEBUGTEST_FOC := False
	}
	wingetClass, Class,%              hnd_ := ("ahk_id " . BK_UN_T)
	winget       PName, ProcessName,% hnd_
	wingettitle, Title_last,%         hnd_		;
	if TTFoc
		tooltip,% ("FOCUS EVENT:`n" PName "`n" Title_last "`nAHK_Class " Class "`nAHK_ID " BK_UN_T)
	;Iconchange_Check(BK_UN_T,Class) 
	loop 4 {
		if classeslast2[a_index+15]
			if (classeslast2[a_index+15] = "SDL_app") {
				Iconchange_Check(classhwlast2[a_index+15],"SDL_app") ;settimer, steamicu, -800
				break
	}		}
	pushclsl2_(Class)
	pushclsh2_(BK_UN_T)	
	
	;steamicu:
	;Iconchange_Check(hWnd4st,"SDL_app")
	;;;tooltip steam was ere %hWnd4st%
	;return 
	
	switch pname {
		case "RzSynapse.exe":
			settimer RZ_LOG, -1
		case "GoogleDriveFS.exe":
			if !triggeredGFS {
				return,
				;disabled
				triggeredGFS := True
				sleep, 1000 ;msgbox % BK_UN_T "asdsads"
				invert_win(BK_UN_T)
	}		}
	
	switch, Title_last {
		case "Razer Synapse Account Login":
			settimer, RZ_LOG, -1
		;case "Google Drive Sharing Dialog":
			;msgbox
	}	
	
	switch Class {
		case "MozillaDialogClass":
			winget, Style, Style,% hnd_
			If(STYLE = "0x16CE0084") { ;&& (EXSTYLE = 0x00000101)   
				Youtube_Popoutwin := hnd_
				wingetPos, X, Y, , EdtH,% hnd_
				WinMove,% hnd_,, , , , (EdtH - 39)
				winset, Style, 0x16860084,	ahk_id %BK_UN_T%	
				SLEEP, 500
				SEND, {SPACE}
			}
		case "#32770":		
			if !(Title_last = "Information")
				return,
			send,% N
		; case "MozillaDialogClass":
			; Escape_TargetWin = ahk_id %Youtube_Popoutwin%
			; winget, Style, Style,% hnd_
			; winget, exStyle, exStyle,% hnd_
			; IF((STYLE = 0x16CE0084) && (EXSTYLE = 0x00000101) ) {
				; Youtube_Popoutwin := BK_UN_T
				; winclose,
				; wingetPos, X, Y, , EdtH,% hnd_
				; WinMove,% hnd_,, , , , (EdtH - 39)
				; winset, Style, 0x16860084,% hnd_	
				; MSGBOX,% (Youtube_Popoutwin . "`nAhk_id: " . BK_UN_T)
			; }	
	;	case "Notepad++":
	; 	case "CabinetWClass":;{ ;winset, transparent, 130,% hnd_;msgbox;}
}	}		 

OnMsgBox(HookMb, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	wingetTitle, Title_last,% (h_Wd := ("ahk_id " . Format("{:#x}",hWnd)))	
	if TTmb {
		wingetClass Class,% h_Wd
		winget PName, ProcessName,% h_Wd
		tooltip MSGBOX EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd%
	}
	If (Title_last = "Information") {
		MSG_WIN_TARGET := "Information"
		winactivate, Information
		winwaitactive, Information
		sleep, 200
		Send, N
		return,
	}
	If WinExist("Reminder") { 
		MSG_WIN_TARGET=Reminder
		WIN_TARGET_DESC=%MSG_WIN_TARGET%
		MessageBoxKill(hwnd)
	}
	If (DeadManHandle :=WinExist("Roblox Crash")) { 
		MSG_WIN_TARGET=Roblox Crash
		WIN_TARGET_DESC=%MSG_WIN_TARGET% ; MessageBoxKill(MSG_WIN_TARGET)
		if !crashmb 
			crashmb    = 1
		else, crashmb += 1
		TestMbkill(DeadManHandle)
	}
	If WinExist(KILLSWITCH) {
		tooltip, Shutting Down Scripts, (A_ScreenWidth*0.5), (A_ScreenHeight*0.5)
		settimer, m2_Status_Req33, -2800
		return,
		m2_Status_Req33:
		Exitapp
}	}

OnObjectDestroyed(HookOD, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	wingetClass, Class, (hndDS := ("ahk_id " . Format("{:#x}"mhWnd))) 	
	wingettitle, Title_last,% hndDS	
	winget PName, ProcessName,% hndDS	
	if TTds
		tooltip OBJ_DESTROY EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hndDS%
;	if pname contains AutoHotkey 
;	&& IsWindowVisible( hWnd)
;		settimer, quotE, -1
	switch Class { ; case "Autohotkey": { ; if % "C:\Script\AHK\adminhotkeys.ahk in " Title_last ; { ; menu, tray, uncheck, Launch AdminHotkeyz, ; tooltip detected admin hotkey disconnecting ; } ; }
		case "ApplicationFrameWindow","WINDOWSCLIENT":
			wingetTitle, Last_Title,% hndDS 
			if ( Last_Title = "Roblox" ) {	;winClose,% hndDS
				setTimer, SBAR_Restore, -1
				if (m2dstatus = "not running or paused") {
					PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey
					PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey
				}
				Roblox := False
				Result1:= Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle)
				Result2 := Send_WM_COPYDATA("resum", "M2Drag.ahk ahk_class AutoHotkey")
				If ((result1 or result2) = "FAIL") 				;if (result = "FAIL")
					Display_Msg("SendMessage failed.", "1000", "True")
				sleep, 500
				Result := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle2)
				If ((result1 or result2) = "FAIL")
					Display_Msg("SendMessage failed.", "1000", "True")
				If ((result1 and result2) = 0)
					Display_Msg("Roblox Exiting: Scripts Closing", "1000", "True")
			;	run C:\Apps\Kill.exe \Multiple_ROBLOX.exe,, hide 
}	}		}	
return, 

; end of event hooks funcs  <<<--------------------------------------- 
; binds                     <<<---------------------------------------
; ~^s::	 ; 		Capture Save hotkey Ctrl-S
; wingetActiveTitle, A_Title 
; if winactive("ahk_exe notepad++.exe") 				{ 
	; if instr(A_Title, ".ahk") 						{   
		; if instr(A_Title, "*")						{   	
			; A_Title := StrReplace(A_Title, "*" , "") 	; *ASTERISK denotes unsaved doc in np++ WinTitle
			; SplitPath, A_Title, tName, npDir, npExtension, npNameNoExt, npDrive 
			; ser := npNameNoExt . ".ahk - AutoHotkey"
			; TargetScriptName := (npNameNoExt . ".ahk"	)
			; if (WinExist(ser)) or if (npNameNoExt = "WinEvent") {
				; MsgBox, 4129,%ser% dtect`NnReload AHK Script, Reload %TargetScriptName% now?`nTimeout in 6 Secs, 7
				;;IfMsgBox Timeout
				;;	ttp("testi")
				; ifmsgbox OK					
					; if npNameNoExt = WinEvent		
; {					
						; reload
						; exit 
						; }
					; traytip, %TargetScriptName%, reloading, 2, 32
					; postMessage, 0x0111, 65303,,, %TargetScriptName% - AutoHotkey		; Reload WMsg 
; }	}	}	}	
; return, 

#M::  					;		ALTgr + Right Arrow
+#M::	
Mag_="C:\Program Files\Autohotkey\Autohotkey.exe" "C:\Script\AHK\Working\M2DRAG_MAG.AHK"
run,% Mag_
return,
f18::
settimer, Stylemenu_init, -1
return

#a::
gosub, ApplyMSStyles ; does nothing atm
return,
+#a::
gosub, AeroTheme_Set ; does nothing atm
return,

#z::
gosub, quotE
return,

 ~esc::
send {escape up}
IF !JIZD
	settimer JIZZ, -1
return,

JIZZ:
GLOBAL JIZD:=TRUE
gui, ttt: DESTROY
gui, eventgui: DESTROY
return,
	;	<------------< [ End of Script ] <------------------<
	;	>------------> [ Begin ... Functions ] >------------>
AtExit() {
	if (hgui != "")
		DllCall("magnification.dll\MagUninitialize")
	;splitpath a_ScriptFullPath,,,, OutNameNoExt
;	pap := "`n", Script_Title=%OutNameNoExt%.txt
	;if !fileexist(Script_Title)
;		pap := ""
	;fileAppend,% ("`n" . EventLogBuffer . ", " . Script_Title)
UNHOOK:
	if (UProc)
		DllCall("UnhookWinEvent", "Ptr", UProc)
		DllCall("GlobalFree", "Ptr", UProc, "Ptr"), UProc := 0	
	if (hook4g)
		DllCall("UnhookWinEvent", "Ptr", hook4g), hook4g := 0
	if (Proc4g_)
		DllCall("GlobalFree", "Ptr", Proc4g_, "Ptr"), Proc4g_ := 0	
	if (HookMb)
		DllCall("UnhookWinEvent", "Ptr", HookMb), HookMb := 0
	if (ProcMb_)
		DllCall("GlobalFree", "Ptr", ProcMb_, "Ptr"), ProcMb_ := 0	
	if (HookCr)
		DllCall("UnhookWinEvent", "Ptr", HookCr), HookCr := 0
	if (HookOD)
		DllCall("UnhookWinEvent", "Ptr", HookOD), HookOD := 0
	if (ProcCr_)
		DllCall("GlobalFree", "Ptr", ProcCr_, "Ptr"), ProcCr_ := 0	
	if (ProcDstroyd)
		DllCall("GlobalFree", "Ptr", ProcDstroyd, "Ptr"), ProcDstroyd := 0	
	if (HookFc)
		DllCall("UnhookWinEvent", "Ptr", HookFc), HookFc := 0
	if (procFc_)
		DllCall("GlobalFree", "Ptr", procFc_, "Ptr"), procFc_ := 0	
	return, 0
}

; 	A string may be sent via wParam or lParam by specifying the address of a variable. 
;	The following example uses the address operator (&) to do this:
; 	SendMessage, 0x000C, 0, &MyVar, ClassNN, WinTitle  ; 0x000C is WM_SETTEXT

Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle) {
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0) 
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize) 
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)
	Prev_DetectHiddenWindows := A_DetectHiddenWindows
	Prev_TitleMatchMode := A_TitleMatchMode
	DetectHiddenWindows On
	SetTitleMatchMode 2
	TimeOutTime := 2700
	SendMessage, 0x4a, 0, &CopyDataStruct,,% TargetScriptTitle,,,,% TimeOutTime
	DetectHiddenWindows %Prev_DetectHiddenWindows%
	SetTitleMatchMode %Prev_TitleMatchMode%
	return, ErrorLevel
}

Receive_WM_COPYDATA(wParam, lParam) {
	StringAddress := NumGet(lParam + 2*A_PtrSize)
	CopyOfData := StrGet(StringAddress)
	if instr(CopyOfData, "Þ") {
		if !FileListStr {
			FileListStr := CopyOfData, FileCount := 1
		} else, FileListStr := (FileListStr . CopyOfData), FileCount := (FileCount + 1) ; FileListStr := FileListStr . "`n" . CopyOfData
		FileListStrGen(Delimiter:="Þ") 
	}
	else, if (CopyOfData = "RobloxFalse") {
		roblox  := False, Result  := (Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle2)), Result1 := (Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle))
	}
	else, if CopyOfData = 10
		m2dstatus := "Suspended"
	else, if CopyOfData = 00
		m2dstatus := "Running Normally"
	else, if (CopyOfData = "StyleMenu")
		settimer, Stylemenu_init, -1
	else, if (CopyOfData = "mag_")
		gosub, mag_	
	else, if CopyOfData
		gosub,% CopyOfData
	else, m2dstatus := "not running or paused"
	return, True
}

FileListStrGen(abc) {
	adelim := abc
	if   !oldlist
		  oldlist := FileListStr
	else, oldlist := FileListStr
	settimer, FileListStrGen2, -500
	return,
}

gethandle_roblox() {
	loop 3 {
		winget, Roblox_hWnd, id, AHK_Class WINDOWSCLIENT
		if !Roblox_Hwnd 
			roblox := False
		else, return, Roblox_hWnd
}	}

TestMbkill(handle) {
	if !8skin_crash 
		8skin_crash = 1
	else, 
		8skin_crash := 8skin_crash + 1
	run C:\Apps\Kill.exe robloxplayerbeta.exe,, hide
	if winexist("ahk_id %handle%") {
		settimer, Quotings, -2000
		return,
		Quotings:
		run C:\Apps\Kill.exe robloxplayerbeta.exe,, hide
	}
	if winexist("ahk_id %handle%")
		  return, 0
	else, return, 1
}	

MessageBoxKill(Target_MSGBOX) {
	Target_hwnd := WinExist(Target_MSGBOX)	;winactivate ;send n ;ControlGet, OutputVar, SubCommand , Value, Button2, WinTitle, WinText, ExcludeTitle, ExcludeText	;ControlSendraw, ahk_parent, n, ahk_class #32770
	ControlClick, "Button2", "ahk_class #32770",	;ControlSend, ahk_parent, {N}, ahk_id %anus%
	settimer, tooloff, -2000
	if WinExist(ahk_ID %target_hwnd% ) {
		MsgBox_MsgBox_TargetHandle := 4gnd_hwnd
		winget, TargetPID, PID ,% MsgBox_MsgBox_TargetHandle
		Target_PID=TASKKILL.exe /PID %TargetPID%
		run, %comspec% /C %Target_PID%,, hide
		sleep, 100
		if WinExist(MsgBox_MsgBox_TargetHandle ) {
			msgbox unable to close the target msgbox 
		} else {
			if  !KillCount
				 KillCount := 1
			else, KillCount := KillCount + 1
			traytip,% KillCount " kills", 4000, 2000
			settimer, tooloff, -7000
}	}	}

IsWindow(hWnd) {
	return, DllCall("IsWindow", "Ptr", hWnd)
}

IsWindowEnabled(hWnd) {
	return, DllCall("IsWindowEnabled", "Ptr", hWnd)
}

IsWindowVisible(hWnd) {
	return, DllCall("IsWindowVisible", "Ptr", hWnd)
}

StyleMenu_Showindow(hWnd, nCmdShow := 1) {
	DllCall("StyleMenu_Showindow", "Ptr", hWnd, "Int", nCmdShow)
}

IsChild(hWnd) {
	winget Style, Style, ahk_id %hWnd%
	return, Style & 0x40000000 ; WS_CHILD
}
GetParent(hWnd) {
	return, DllCall("GetParent", "Ptr", hWnd, "Ptr")
}

SetAcrylicGlassEffect(hWnd) {
	Static Init, accent_state := 4
	Static Pad := A_PtrSize = 8 ? 4 : 0, WCA_ACCENT_POLICY := 19
	accent_size := VarSetCapacity(ACCENT_POLICY, 200, 0) 
	NumPut(accent_state, ACCENT_POLICY, 0, "Int")
	NumPut(0x77400020, ACCENT_POLICY, 8, "Int")
	VarSetCapacity(WINCOMPATTRDATA, 4 + Pad + A_PtrSize + 4 + Pad, 0)
	&& NumPut(WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0, "Int")
	&& NumPut(&ACCENT_POLICY, WINCOMPATTRDATA, 4 + Pad, "Ptr")
	&& NumPut(accent_size, WINCOMPATTRDATA, 4 + Pad + A_PtrSize, "Uint")
	If !(DllCall("user32\SetWindowCompositionAttribute", "Ptr", hWnd, "Ptr", &WINCOMPATTRDATA))
		return, 0
	return, 1
}

Hooks:
OnExit("AtExit")
OnMessage(0x4a, "Receive_WM_COPYDATA")
hook4g  :=  DllCall("SetWinEventHook", "Uint", OBJ4g, "Uint", OBJ4g, "Ptr", 0, "Ptr", (Proc4g_ := RegisterCallback("On4ground", "")),        "Uint", 0, "Uint", 0, "Uint", OoC | SkpO)
HookFc  :=  DllCall("SetWinEventHook", "Uint", OBJFc, "Uint", OBJFc, "Ptr", 0, "Ptr", (procFc_ := RegisterCallback("OnFocus", "")),          "Uint", 0, "Uint", 0, "Uint", OoC | SkpO)
HookMb  :=  DllCall("SetWinEventHook", "Uint", 0x0010,"Uint", 0x0010,"Ptr", 0, "Ptr", (ProcMb_ := RegisterCallback("OnMsgBox", "")),         "Uint", 0, "Uint", 0, "Uint", OoC | SkpO)
HookCr  :=  DllCall("SetWinEventHook", "Uint", OBJCR, "Uint", OBJCR, "Ptr", 0, "Ptr", (ProcCr_ := RegisterCallback("OnObjectCreated", "")),  "Uint", 0, "Uint", 0, "Uint", OoC ) 
HookOD  :=  DllCall("SetWinEventHook", "Uint", OBJDS, "Uint", OBJDS, "Ptr", 0, "Ptr", (ProcOD_ := RegisterCallback("OnObjectDestroyed", "")),"Uint", 0, "Uint", 0, "Uint", OoC | SkpO)

omd:=0x0010
loop, parse,% (a:="OBJ4g,OBJFc,omd,OBJCR,OBJDS"), `,
	hooked_events.push(a_loopfield)
	; for index, element in hooked_events
	; if !ass
		; ass := element
	; else ass := ass . "," . element
	; msgbox % ass
return,     

FileListStrGen2:
if (oldlist = FileListStr) {
	Loop, parse, FileListStr,% ("ø")	
	{
		if A_Index = 1
			  action := A_LoopField
		else, FileListStr := A_LoopField
	}
	FileListStr_ar := (StrSplit(FileListStr, "%adelim%")), FileListStr := "", oldlist := "", FileCount := ""
	return,
} else, oldlist := FileListStr
return,

RobloxGetHandle: 
winget, Roblox_hWnd, id, AHK_Class WINDOWSCLIENT
if !Roblox_Hwnd {
	roblox := False
	send {shift up}
	settimer, RobloxGetHandle2, -3000
}
return,

RobloxGetHandle2:
Roblox_Hwnd := ""
loop 5 {
	winget, Roblox_hWnd, id, AHK_Class WINDOWSCLIENT
	if !Roblox_Hwnd {
		tooltip, Exiting
		settimer, tooloff, -2000
		Result 	:= Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle2)
		Result1 := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle),
	} else {
		roblox := True
		break
}	}
return,

Toggle_sbar:
if !SBAR_DISABLE{
	SBAR_DISABLE := True
	Tooltip Sidsebar will be disabled ingame
} else {
	SBAR_DISABLE := False
	Tooltip Sidsebar will be enabled ingame
}
settimer, tooloff, -1000
return,

Toggle_dbg:
if !dbg {
	dbg	:=	True
	listlines on
	#KeyHistory 900
	menu, tray, check,   Toggle debug,
} else {
	listlines off
	#KeyHistory 0
	menu, tray, uncheck, Toggle debug,
	dbg	 :=	 False
}
return,

;= debug tooltip message TRAY-MENU toggles
TT4g: ;TT4g := !TT4g debug tooltip message TRAY-MENU toggles
TTFoc: ;TTFoc := !TTFoc
TTcr: ;TTcr := !TTcr
TTds: ;TTds := !TTds
TTmb: ;TTmb := !TTmb
IF !%A_THISLABEL% {
	%A_THISLABEL% := TRUE
	menu, tray, check,%    MenuLablTitlAr[A_THISLABEL]
} ELSE {
	%A_THISLABEL% := FALSE
	menu, tray, UNcheck,%  MenuLablTitlAr[A_THISLABEL]
}
return,

1999:
ControlGet, CtrlHandL, Hwnd,, SysTreeView321,% 1999
Chwn_ := ("ahk_id " . CtrlHandL)
sleep, 1200
winset, Style,        -0x00000004,% Chwn_ ;TVM_SETEXTENDEDSTYLE := 0x112C = tvmX
winset, Style,        -0x00100000,% Chwn_ ; 0x00000020 auto h scroll
SendMessage, 0x112C,0, 0x00003C75,% Chwn_ 
return,

1998:
ControlGet, CtrlHandL, Hwnd,, SysTreeView321,% 1998
Chwn_ := ("ahk_id " . CtrlHandL)
winset, Style, +0x00000202,% Chwn_
return,

GoGoGadget_Cl0ck: ; sidebar-clock click-thru
winget, Time_hWnd, iD,% "HUD Time",
if errorlevel	
	msgbox,% errorlevel " err0r"
else, ; winset, ExStyle, 0x000800A8, M oon P hase I I
	winset, ExStyle, 0x000800A8,% ("ahk_id " . Time_hWnd)
return,

;GDIP FUNCS
GetDC(hwnd:=0) {
   return, DllCall("GetDC", "UPtr", hwnd)
}

Gdip_Startup(multipleInstances:=0) {
   pToken := 0
   If (multipleInstances=0)        {
      if !DllCall("GetModuleHandle", "str", "gdiplus", "UPtr")
         DllCall("LoadLibrary", "str", "gdiplus")
   } else, DllCall("LoadLibrary", "str", "gdiplus")
   VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
   DllCall("gdiplus\GdiplusStartup", "UPtr*", pToken, "UPtr", &si, "UPtr", 0)
   return, pToken
}

Gdi_CreateCompatibleDC(hDC = 0) {
   return, DllCall("gdi32\CreateCompatibleDC", "Uint", hDC)
}

Gdi_CreateDIBSection(hDC, nW, nH, bpp = 32, ByRef pBits = "") {
   NumPut(VarSetCapacity(bi, 40, 0), bi)
   NumPut(nW, bi, 4)
   NumPut(nH, bi, 8)
   NumPut(bpp, NumPut(1, bi, 12, "UShort"), 0, "Ushort")
   return, DllCall("gdi32\CreateDIBSection", "Uint", hDC, "Uint", &bi, "Uint", DIB_RGB_COLORS:=0, "UintP", pBits, "Uint", 0, "Uint", 0)
}

Gdi_SelectObject(hDC, hGdiObj) {
   return, DllCall("gdi32\SelectObject", "Uint", hDC, "Uint", hGdiObj)
}

Gdip_ShutdownI(pToken) {
   DllCall("gdiplus\GdiplusShutdown", "Uint", pToken)
   If hModule := DllCall("GetModuleHandle", "str", "gdiplus")
         DllCall("FreeLibrary"    , "Uint", hModule)
   return, 0 
}
;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~
invert_win(hw)                  { ; not working
	hTarget 	:= hw
	if (hTarget = hTargetPrev)  {
		hTargetPrev := ""
		count--
		return,
	}
	count++
	hTargetPrev := hTarget
	if (hgui = "") 				{
		DllCall("LoadLibrary", "str", "magnification.dll")
		DllCall("magnification.dll\MagInitialize")

		VarSetCapacity(MAGCOLOREFFECT, 100, 0)
		Loop, Parse, Matrix, |
		NumPut(A_LoopField, MAGCOLOREFFECT, (A_Index - 1) * 4, "Float")
		loop 2 					{
			if (A_Index = "2")
				gui, %A_Index%: +AlwaysOnTop ; needed for ZBID_UIACCESS
			gui, %A_Index%: +HWNDhgui%A_Index% -DPIScale +toolwindow -Caption +E0x02000000 +E0x00080000 +E0x20 ; WS_EX_COMPOSITED := E0x02000000 WS_EX_LAYERED := E0x00080000 WS_EX_CLICKTHROUGH := E0x20
			hChildMagnifier%A_Index% := DllCall("CreateWindowEx", "Uint", 0, "str", "Magnifier", "str", "MagnifierWindow", "Uint", WS_CHILD := 0x40000000, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "ptr", hgui%A_Index%, "Uint", 0, "Ptr", DllCall("GetWindowLong" (A_PtrSize=8 ? "Ptr" : ""), "Ptr", hgui%A_Index%, "Int", GWL_HINSTANCE := -6 , "Ptr"), "Uint", 0, "Ptr")
			DllCall("magnification.dll\MagSetColorEffect", "Ptr", hChildMagnifier%A_Index%, "Ptr", &MAGCOLOREFFECT)
	}	}
	gui, 2: Show, NA ; needed for removing flickering
	hgui := hgui1
	hChildMagnifier := hChildMagnifier1
	loop {
		if (count != 1) { ; target window changed
			if (count = 2)
				count--
			WinHide, ahk_id %hgui%
			return,
		}
		VarSetCapacity(WINDOWINFO, 60, 0)
		if (DllCall("GetWindowInfo", "Ptr", hTarget, "Ptr", &WINDOWINFO) = 0) and (A_LastError = 1400) ; destroyed
		{
			count--
			WinHide, ahk_id %hgui%
			return,
		}
		if (NumGet(WINDOWINFO, 36, "Uint") & 0x20000000) or !(NumGet(WINDOWINFO, 36, "Uint") & 0x10000000) ; minimized or not visible
		{
			if (wPrev != 0) {
				WinHide, ahk_id %hgui%
				wPrev := 0
			}
			sleep, 2
			continue
		}
		x 	:= NumGet(WINDOWINFO, 20, "Int")
		y 	:= NumGet(WINDOWINFO, 8, "Int")
		w 	:= NumGet(WINDOWINFO, 28, "Int") - x
		h	:= NumGet(WINDOWINFO, 32, "Int") - y
		if (hgui = hgui1) and ((NumGet(WINDOWINFO, 44, "Uint") = 1) or (DllCall("GetAncestor", "Ptr", WinExist("A"), "Uint", GA_ROOTOWNER := 3, "Ptr") = hTarget)) ; activated
		{
			hgui := hgui2
			hChildMagnifier := hChildMagnifier2
			WinMove, ahk_id %hgui%,, x, y, w, h
			WinMove, ahk_id %hChildMagnifier%,, 0, 0, w, h
			settimer 1, -20
			settimer 2, -20
			settimer 3, -20
			hidegui := hgui1
		} else, 
		if (hgui = hgui2) and (NumGet(WINDOWINFO, 44, "Uint") != 1) and ((hr := DllCall("GetAncestor", "Ptr", WinExist("A"), "Uint", GA_ROOTOWNER := 3, "ptr")) != hTarget) and hr ; deactivated
		{
			hgui := hgui1
			hChildMagnifier := hChildMagnifier1
			WinMove, ahk_id %hgui%,, x, y, w, h
			WinMove, ahk_id %hChildMagnifier%,, 0, 0, w, h
			DllCall("SetWindowPos", "ptr", hgui, "ptr", hTarget, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "Uint", 0x0040|0x0010|0x001|0x002)
			DllCall("SetWindowPos", "ptr", hTarget, "ptr", 1, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "Uint",    0x0040|0x0010|0x001|0x002) ; some windows can not be z-positioned before setting them to bottom
			DllCall("SetWindowPos", "ptr", hTarget, "ptr", hgui, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "Uint", 0x0040|0x0010|0x001|0x002)
			settimer 1, -20
			settimer 2, -20
			settimer 3, -20
			hidegui := hgui2 
		} else, 
		if (x != xPrev) or (y != yPrev) or (w != wPrev) or (h != hPrev) ; location changed
		{
			WinMove, ahk_id %hgui%,, x, y, w, h
			WinMove, ahk_id %hChildMagnifier%,, 0, 0, w, h
			settimer 1, -20
			settimer 2, -20
			settimer 3, -20
		}
		if (A_PtrSize = 8) {
			VarSetCapacity(RECT, 16, 0)
			NumPut(x, RECT, 0, "Int")
			NumPut(y, RECT, 4, "Int")
			NumPut(w, RECT, 8, "Int")
			NumPut(h, RECT, 12, "Int")
			DllCall("magnification.dll\MagSetWindowSource", "ptr", hChildMagnifier, "ptr", &RECT)
		} 
		else, 	DllCall("magnification.dll\MagSetWindowSource", "ptr", hChildMagnifier, "Int", x, "Int", y, "Int", w, "Int", h)
		xPrev := x, yPrev := y, wPrev := w, hPrev := h
		if hidegui {
			WinHide, ahk_id %hidegui%
			hidegui := ""
	}	}
	return,
	
	1:
	gui, 2: Show, NA ; needed for removing flickering
	return,
	2:
	WinShow, ahk_id %hChildMagnifier%
	return,
	3:
	WinShow, ahk_id %hgui%
	return,
}
;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
StyleDetect(hwnd,Style_xList,XTitle,XtitlesArray) {
	if (InStr(Style_xList, XTitle))               {
		for index, value in XtitlesArray		  {
			if (InStr(value, XTitle))             {
				retpos 	:= RegExMatch(value, "(\µ)\K(.*)",    ret_class,   p0s := 1) 
				retpos 	:= RegExMatch(value, "^0.{9}",		  ret_style,   p0s := 1)
				retpos 	:= RegExMatch(value, "(\»)\K(.{10})", ret_exstyle, p0s := 1)
				winset, Style,  % ret_style,  % "ahk_id" hwnd  
				winset, ExStyle,% ret_exstyle,% "ahk_id" hwnd
				msgbox,% ( XTitle . " detected`n" . ret_style . "`n" . ret_exstyle )
				return, 1
	}	}	}
				return, 0
}
;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
runlabel(VarString, hide="")    { 
	static hidestatic := "Hide"
	if hide            ;           "Mag_CleanME_PLZz\/DWMFixS\/PConfig\/WMPRun" etc
		hid := hidestatic
	if (InStr(VarString, "\/")) {
		loop, parse, VarString, "\/",
		{
			run,% VarString,,% hid
			if errorlevel
				return, 0
		}
				return, 1
	} else,                     {
		run,% VarString,,% hid
		if !errorlevel
			 return, 1
		else, return, 0
}	}
;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
toggle_m2drag_bypass:
ttt := "M2Drag.ahk - AutoHotkey", result := Send_WM_COPYDATA("Bypass_Last_Dragged_GUI",ttt)
return,
;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
MiDiRun:
run % MiDiRun
return, 
;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
;next on the stylemenu 
toggle_sysmenu:
toggle_DLGFRAME:
toggle_thickframe:
toggle_modalframe:
toggle_border:
toggle_raisededge:
toggle_sunkenedge:
toggle_staticedge:
toggle_3dedge:
toggle_MinBox:
toggle_Maxbox:
toggle_hscroll:
toggle_vscroll:
toggle_LeftScroll:
toggle_Clickthru:
toggle_RightAlign:
toggle_RightoLeft:
toggle_AppWindow:
switch a_thislabel {
	case "toggle_sysmenu","toggle_DLGFRAME","toggle_thickframe","toggle_border","toggle_MinBox","toggle_Maxbox","toggle_hscroll","toggle_vscroll":
		winset, Style,   stylearr[  a_thislabel ],% ("ahk_id " . OutputVarWin )
	case "toggle_modalframe","toggle_raisededge","toggle_sunkenedge","toggle_staticedge","toggle_3dedge","toggle_LeftScroll","toggle_Clickthru","toggle_RightAlign","toggle_RightoLeft","toggle_AppWindow":
		winset, ExStyle, stylexarr[ a_thislabel ],% ("ahk_id " . OutputVarWin )
}
goto ResetMenu

SAVEGUI:
if !TargetHandle
	TargetHandle := ("ahk_id " OutputVarWin)
winget      savePN, ProcessName,% "ahk_id " TargetHandle
wingetTitle save_new_Title,%      "ahk_id " TargetHandle
wingetClass save_new_Class,%      "ahk_id " TargetHandle
winget, Style, Style,%            "ahk_id " TargetHandle
winget, ExStyle, ExStyle,%        "ahk_id " TargetHandle
if !Style or !ExStyle
	msgbox,% ("error " . A_lasterror)
gui, SaveGuI:new , , SAVE WINDOW STYLES
gui +hwndSaveGuI_hWnd
gui, SaveGuI:add, checkbox, vTProcName, Process %savePN%
gui, SaveGuI:add, checkbox, vTTitle,    WindowTitle %save_new_Title%
gui, SaveGuI:add, checkbox, vTClass,    save Class %save_new_Class%
gui, SaveGuI:add, button, default gSaveGUISubmit w80,% "Save (Enter)"
gui, SaveGuI:add, button, w80 gSaveGUIDestroy,% 	   "Cancel (Esc)"
gui, show, center, SAVE WINDOW STYLES
OnMessage(0x200, "Help")
return,

PushNewSave: 	
if TProcName  ;  regKey contains unique combo of info picked by user as a search key allowing for combinations of classnamed title and procname. Should be enough
	regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\procname, 	% Style . "»" . exStyle . "»" . "µ" . savePN . "µ" . save_new_Title . "µ" . save_new_Class,% savePN
if TTitle
	regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\wintitle, 	% Style . "»" . exStyle . "»" . "µ" . savePN . "µ" . save_new_Title . "µ" . save_new_Class,% save_new_Title
if TClass
	regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\classname, 	% Style . "»" . exStyle . "»" . "µ" . savePN . "µ" . save_new_Title . "µ" . save_new_Class,% save_new_Class
return

SaveGUISubmit: 	
gui, SaveGuI: Submit
return,

SaveGUIDestroy:
gui, SaveGuI: destroy
TProcName := "", TTitle := "", TClass := ""
return,

ResetMenu:
menu, F, DeleteAll
return,

RZ_LOG:
coord_old := A_CoordModePixel
CoordMode, pixel , window
WinGet, list_rzexe, List, ahk_exe RzSynapse.exe
Loop %list_rzexe% {
	ss := ("ahk_id " . list_rzexe%A_index%)
	winGet, Style, Style,% SS
	winGet, ExStyle, ExStyle,% SS
	if ((Style = "0x16080000") && (ExStyle = "0x000C0000")) {
		winactivate,% ss
		send, ^{a}
		send, %Log1_RZ%	
		send, {tab}
		send, ^{a}
		send, %Pa5s_RZ%
		PixelGetColor, color, 219, 326
		if color != 0x02DD02
			def:="default snot saved"
		else, send, {enter}
}	}	
CoordMode,% coord_old
return,

;------------==========================++++++++++++++++++++*+*+*+*
;~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~
;------------==========================++++++++++++++++++++*+*+*+*
RegReads: ; -=-==-=====-= REG READZZZZ =-=-=----==--@~@'''~~--__
AhkPath := ErrorLevel ? "" : AHKdir "\AutoHotkey.exe",.
 
keys:="HKCU\SOFTWARE\_MW\Icons\cl,HKCU\SOFTWARE\_MW\Icons\pn"
loop parse, keys, `,
{
	dildo := A_Loopfield
	Loop, Reg,% dildo, KV
	{
		fuka := A_LoopRegName
		regRead, v_
	;	msgbox % v_
		StringTrimLeft, db, dildo, 24
		icon_%db%_arr[fuka] := v_
}	}

regRead, Log1RZ, HKEY_CURRENT_USER\Software\_Mouse2Drag\Login , rz
if Log1RZ {
	loop, parse, Log1RZ, `,
	{
		switch A_index {
			case "1":
				Log1_RZ := A_LoopField
			case "2": 
				Pa5s_RZ := A_LoopField
}	}	}

Loop, Reg,% wintitlekey
{
    if (A_LoopRegType = "REG_SZ") {
        value1 	:= A_LoopRegKey . "\" . A_LoopRegSubKey
        regRead, value2, %value1%, %A_LoopRegName%
		Style_wintitleList2 := Style_wintitleList2 . value2 . "‡"	
		retpos 	:= RegExMatch(A_LoopRegName, "^0.{9}" ,         ret_style,   p0s := 1)
		retpos 	:= RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , 	ret_exstyle, p0s := 1)
		Array_wintitleList.push(	ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
}	}
Loop, Reg,% procnamekey
{
    if (A_LoopRegType = "REG_SZ") {
        value1 := A_LoopRegKey . "\" . A_LoopRegSubKey
        regRead, value2, %value1%, %A_LoopRegName%
		Style_procnameList2 := Style_procnameList2 . value2 . "‡"	
		retpos := RegExMatch(A_LoopRegName, "^0.{9}" , ret_style, p0s := 1)
		retpos := RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , ret_exstyle, p0s := 1)
		Array_ProcnameList.push(	ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
}	}
Loop, Reg,% classnamekey
{
    if (A_LoopRegType = "REG_SZ") {
        value1 := A_LoopRegKey . "\" . A_LoopRegSubKey
        regRead, value2, %value1%, %A_LoopRegName%
		Style_ClassnameList2 := (Style_ClassnameList2 . value2 . "‡")	
		retpos := RegExMatch(A_LoopRegName, "^0.{9}" , ret_style, p0s := 1)
		retpos := RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , ret_exstyle, p0s := 1)
		Array_LClass.push(		ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
}	}
return,
;~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`
getwintxt:
WinGetText, wintxt , ahk_id %OutputVarWin%
msgbox,% ( wintxt . "`nWintext" )
cliboard:=wintxt
wintxt :=""
return,
;------------==========================++++++++++++++++++++*+*+*+*
filechk_msstyles_themefile:
theme_test_File1      :=  fileexist("c:\windows\resources\themes\test.theme"         )
if !(theme_test_File1 :=  fileexist("c:\windows\resources\themes\test.theme")        )
or !(theme_test_File2 :=  fileexist("c:\windows\resources\themes\test\test.msstyles"))
	msgbox,% "Test.Msstyles MiA"
else,
	traytip,% "File attrib query Sux_cesS . fulLy confirmed ",% "Test.msstyles and Test.theme present & correct! OK" 
return,
ApplyMSStyles: 	 ; 	or Basic / Aero
cmd=
(LTrim
   C:\Windows\system32\rundll32.exe C:\Windows\system32\shell32.dll,Control_RunDLL C:\Windows\system32\desk.cpl desk,@Themes /Action:OpenTheme /file "C:\Users\ninj\AppData\Local\Microsoft\Windows\Themes\p00p.theme"
)
return,
AeroTheme_Set:
if !(fileexist("c:\windows\resources\themes\test\test.msstyles"))
	msgbox,% "Test.Msstyles MiA"
else, {
	regwrite, REG_SZ,% (HKCUCurVer . "\ThemeManager"),       DllName,       % test_aero_style
	regwrite, REG_SZ,% (HKCUCurVer . "\Themes\Personalize"), CurrentTheme,	% test_aero_style2 
	regwrite, REG_SZ,% (HKCUCurVer . "\Themes"),	    	 CurrentTheme,	% test_aero_theme 
}
return,

;------------==========================++++++++++++++++++++*+*+*+*
quotEI:
q_dlim	= \
loop, 6
	sp := (" " .  sp . sp)
KV_    := ( "`n" . sp . "Kurt Vonnegut" . q_dlim )
BJB_   := ( "`n" . sp . "Buju Banton" .   q_dlim ), sp := ""
qstr   := (" ""And I urge you to please notice when you are happy,`nand exclaim or murmur or think at some point,`n 'If this isn't nice, I don't know what is.'"" " . KV_ .	" ""Everything was beautiful and nothing hurt."" " . KV_ .	" ""Those who believe in telekinesis, Please raise my hand."" " . KV_ . " ""We are what we pretend to be, so we must be careful about what we pretend to be."" " . KV_ .	" ""I tell you, we are here on Earth to fart around, and don't let anybody tell you different."" " . KV_ . " ""Tiger got to hunt,bird got to fly,`nMan got to sit and wonder 'why, why, why?'"" " . KV_ " ""Tiger got to sleep, bird got to land,`nMan got to tell himself he understand."" " . KV_ . " ""While elephants play the grass gets trampled."" " . BJB_ )

loop, parse, qstr,% q_dlim, 
	quote_MAX_INDEX := A_index
return,

quotE:
randOm, rNd, 1, quote_MAX_INDEX ; quote_MAX_INDEX
if !Quoting {
	Quoting := True
	tooltip,% Quotes[rNd], (XCent-240), (YCent-40),2  ; replace with stringcount of rNd result, delimited with newlines; for x/y
	settimer, Qoff2, -3000
} else, settimer, Quote, -3000
return,

Qoff2:
tooltip,,,,2
Quoting := False
return,
;------------==========================++++++++++++++++++++*+*+*+*
32770Fix:     
wingetClass, Cls_A, a
if Cls_A != "#32770"                   ;    "Save as" & "Open" dlgs called from the eventHook.
	winwaitActive,% "ahk_class #32770" ;  * takesawhile to visually materialise ui, hence prev.
wingetClass, Cls_A, a
if (Cls_A = "#32770") {	               ;    "Active" is not actually ready to be drawn over.
	gdipfix_start:
	sleep, 1000
	Nnn := Gdip_Startup()
	dcC := GetDC(nnd)
	mDC := Gdi_CreateCompatibleDC(0)
	mBM := Gdi_CreateDIBSection(mDC, 1, 1, 32) 
	oBM := Gdi_SelectObject(mDC, mBM)
	a:=DllCall("gdi32.dll\SetStretchBltMode", "Uint", dcC, "Int", 5)
	b:=DllCall("gdi32.dll\StretchBlt", "Uint", dcC, "Int", 0, "Int", 0, "Int", desk_wi, "Int", desk_hi, "Uint", mdc, "Uint", 0, "Uint", 0, "Int", 1, "Int", 1, "Uint", "0x00CC0020")
	Gdip_ShutdownI(Nnn)
	if (a = 0 || b = 0)
		goto, gdipfix_start
}
return,

;LAbeL_Ladder ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>
AdHkRun:      ; menu, tray, check,% "Launch " A_ThisLabel ; swap wih a dictionary for titles ;
mattdwmrun2:  ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>
test_move:    ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()
Mag_:         ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()
MiDi_:        ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[
CleanME_PLZz: ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>()[](
DWMFixS:      ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>
PConfig:      ; []()<>()[]()<>()[]()<>()[]()<>()[ 
clsids:       ; []()<>()[]()<>()[]()<>()[]()<>(  
WMPRun:       ; []()<>()[]()<>()[]()<>()[]()<
M2dRun:       ; []()<>()[]()<>()[]()<>()[]
YT_DL:        ; []()<>()[]()<>()[]()<>()
DESKTOP_AREA:
syscols:
SysMetrix:
	
LABElA(( Your_Label_Sir := A_thislabeL ))
return,
			
LABElA(Tingz) 	 {
	switch Tingz {
		case "AdHkRun":
			settimer, reload_orload_admhk, -1
		default:
		traytip, Launching %tingz%
			run,% (%Tingz%)
}	}	

sbardisabletoggle()     {
	if !SBAR_DISABLE    {
		if winexist("ahk_exe sidebar.exe") {
			run,%   "C:\Apps\Kill.exe sidebar.exe",,hide
			SBAR_2berestored_True := True, Sidebar := False, Roblox := True
		}	
	SBAR_DISABLE := True
	return, 1
	} else,             {
		SBAR_Restore:
		if SBAR_DISABLE { ; if SBAR_2berestored_True {
			run % SidebarPath,, hide, 
			settimer, BEadZ, -1000
			return,
			BEadZ: 
			winget,    SideBar_Handle,    ID,%       "HUD Time"
			Sidebar := 1, SBAR_2berestored_True  :=  False
			winset,    ExStyle, +0x20,%   "ahk_id "  SideBar_Handle
		}	;}
		return, 2
}	}

check_ADMHOTKEY() {
	if uiu := wineXist("ahk_class AutoHotkey", ADM_wTtL) ;"adminhotkeys.ahk - AutoHotkey"
		return, 1
	return, 0
}

window_iconset_guiDestroy:
gui, window_iconset_gui:destroy
return,

window_iconset_guiSubmit: 	
gui, window_iconset_gui:Submit
goto, window_icon_New

pushclsl_(cls="")         {
global	
clst_max_I         += 1 
	if (clst_max_I > 20)  {
		clst_max_I -= 1 
		classeslast.removeat(1)    ;   pop da' head
	}
	classeslast.push(cls)
}

pushclsh_(hw_="")         {
global	
clht_max_I         += 1 
	if (clht_max_I > 20)  {
		clht_max_I -= 1 
		classhwlast.removeat(1)    ;   pop da' head
	}
	classhwlast.push(hw_)
} 

pushclsl2_(cls2="")       {
global	
	clst2_max_I     += 1 
	if (clst2_max_I > 20) {
		clst2_max_I -= 1 
		classeslast2.removeat(1)   ;   pop da' head
	}
	classeslast2.push(cls2)
}

pushclsh2_(hw_2="")       {
global	
clht2_max_I         += 1 
	if (clht2_max_I > 20) {
		clht2_max_I -= 1 
		classhwlast2.removeat(1)   ;   pop da' head
	}
	classhwlast2.push(hw_2)
} 

last_classes_handles:
for index, element in classhwlast
	concat := concat . "`n" . element
tooltip,% "e " concat " "  clst_max_I " "  clht_max_I
concat :=""
return,
	
last_classes_names:
for index, element in classeslast
	concat := concat . "`n" . element
tooltip,% "e " concat " "  clst_max_I " "  clht_max_I
concat :=""
return,
	
last_classes_handles2:
for index, element in classhwlast2
	concat := concat . "`n" . element
tooltip,% "e " concat " "  clst2_max_I " "  clht2_max_I
concat :=""
return,
	
last_classes_names2:
for index, element in classeslast2
	concat := concat . "`n" . element
tooltip,% "e " concat " "  clst2_max_I " "  clht2_max_I
concat :=""
return,

reload_orload_admhk:
if !aasa:=check_ADMHOTKEY()
	run,% AdHkRun
else, settimer, admhotkey_reload_, -1
return,
admhotkey_reload_:
PostMessage, 0x0111, 65303,,,% "adminhotkeys.ahk - AutoHotkey"
return

Stylemenu_init:  ; tooltip % "Analyzing, please wait" ++++*+*+*+*
TargetHandle := "", style:=""
if Dix
	if F
	menu, F, DeleteAll
Dix := True
MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
TargetHandle := ("ahk_id " . OutputVarWin)
wingetClass, new_cl,%              TargetHandle 
wingetTitle, TargetTitle,%          TargetHandle
if !TargetTitle 
	return,
new_tt := TargetTitle
winget, new_PN,     ProcessName,%   TargetHandle
winget, new_style,    Style,% 		TargetHandle
winget, new_exstyle,  ExStyle,% 	TargetHandle

menu_Style_main:
if new_PN {
	menu,     F,   Add,%     new_PN, donothing
	menu,     F,   Disable,% new_PN
}
menu,         F,   Add,%     Style_Men_arr_["Sys_Menu"],  toggle_sysmenu
if (new_style    &    0x00080000)
	  menu,   F,   check,%   Style_Men_arr_["Sys_Menu"]
else, menu,   F,   uncheck,% Style_Men_arr_["Sys_Menu"]
      menu,   F,   add,%     Style_Men_arr_["Clickthru"], toggle_Clickthru
if(new_exstyle   &    0x00000001)
	  menu,   F,   check,%   Style_Men_arr_["Clickthru"]
else, menu,   F,   uncheck,% Style_Men_arr_["Clickthru"]
      Menu,   F,   add,%     Style_Men_arr_["AppWindow"], toggle_AppWindow
if(new_exstyle   &    0x00040000)
	  menu,   F,   check,%   Style_Men_arr_["AppWindow"]
else, menu,   F,   uncheck,% Style_Men_arr_["AppWindow"]
goto, menus_subitem

Submenus:
menu, F, add, Frame / & X Controls, :S1
menu, F, add, Scrollbars, 			:S2
menu, F, add, Layout, 				:S3
goto, menus_other

menus_subitem:    
      menu,      S1, add,%      "DLG Frame",              toggle_DLGFRAME
if(Style2    &   0x00400000)   
	  menu,      S1, check,%    "DLG Frame"
else, menu,      S1, uncheck,%  "DLG Frame"
      menu,      S1, Add,%      "THICK Frame",            toggle_thickframe
if (Style2   &   0x00040000)   
	  menu,      S1, check,%    "THICK Frame"
else, menu,      S1, uncheck,%  "THICK Frame"
      menu,      S1, Add,%      "Modal Frame",            toggle_Modalframe
if(new_exstyle  &   0x00000001)   
	  menu,      S1, check,%    "Modal Frame"
else, menu,      S1, uncheck,%  "Modal Frame"
      menu,      S1, Add,%      "Static edge",            toggle_staticedge
if(new_exstyle  &   0x00020000)   
	  menu,      S1, check,%    "Static edge"
else, menu,      S1, uncheck,%  "Static edge"
      menu,      S1, Add,%      Style_Men_arr_["Maxbox"],     toggle_Maxbox
if (Style2   &    0x00010000)                     
	  menu,      S1, check,%    Style_Men_arr_["Maxbox"]        
else, menu,      S1, uncheck,%  Style_Men_arr_["Maxbox"]       
      menu,      S1, Add,%      Style_Men_arr_["MinBox"],     toggle_MinBox
if (Style2   &   0x00020000)                   
	  menu,      S1, check,%    Style_Men_arr_["MinBox"]          
else, menu,      S1, uncheck,%  Style_Men_arr_["MinBox"]          
      menu,      S2, Add,%      "HScroll",                toggle_hscroll
if (Style2   &   0x00100000)                  
	  menu,      S2, check,% 	"HScroll"  
else, menu,      S2, uncheck,%  "HScroll"     
      menu,      S2, Add,%      "VScroll",                toggle_hscroll
if(Style2    &   0x00200000)                    
	  menu,      S2, check,% 	"VScroll"      
else, menu,      S2, uncheck,%   "VScroll"   
      menu,      S2, Add,%      Style_Men_arr_["LeftScroll"], toggle_LeftScroll
if(new_exstyle  &   0x00004000)                   
	  menu,      S2, check,%    Style_Men_arr_["LeftScroll"]     
else, menu,      S2, uncheck,%  Style_Men_arr_["LeftScroll"]   
      menu,      S3, Add,%      Style_Men_arr_["RightAlign"], toggle_RightAlign
if (new_exstyle &   0x00001000)                   
	  menu,      S3, check,%    Style_Men_arr_["RightAlign"]
else, menu,      S3, uncheck,%  Style_Men_arr_["RightAlign"]
      menu,      S3, Add,%      Style_Men_arr_["RightoLeft"], toggle_RightoLeft
if (new_exstyle &   0x00002000)                   
	  menu,      S3, check,%    Style_Men_arr_["RightoLeft"]    
else, menu,      S3, uncheck,%  Style_Men_arr_["RightoLeft"]
goto, Submenus

menus_other: ; below submenus
menu, 	F, 	add,  m2drag bypass,     toggle_m2drag_bypass
menu, 	F, 	Icon, m2drag bypass,%    mouse24
menu, 	F, 	add,% "Get window text", getwintxt

; if !new_PN
; msgbox error new_PN
; if !new_cl
; msgbox error clsn

if (icon_PN_arr[new_PN]) || if (icon_cl_arr[new_cl]) 
	   menu, F, 	add,% "remove icon", windowiconrem
else   menu, F, 	add,% "Set icon",    window_iconset_gui ;windowiconset
menu, 	     F, 	add,% "Save",        Savegui
goto,   StyleMenu_Show

StyleMenu_Show: ;l=[][][][[[]l=[][][][[[]l=[][][][[[]
menu, F, Show
menu, F, DeleteAll
return,  
;`~	;`~	;`~	;`~	;`~	;`~	;`~	;`~			

NewTrayMenuParam( LabelPointer = "", Title = "", Icon = "" ) {
	if Title                                                 {
		MenuLablTitlAr[%LabelPointer%]:= Title
		menu,tray,add,% MenuLablTitlAr["LabelPointer"], %LabelPointer%
		if !Icon
			return, 1
		else, menu, tray, Icon,% Title ,% Icon 
		return, 2
	} else, if Icon
		menu, tray, icon,% Icon
	else, return, 0
	return, 3
}

; ~`~`~~`~;`~`~`~`~		~`~`~`~		~`~`~`~		~`~`~`  ~`~`~` ~`~`~	`~` ~`~ `~  ~`~`	~`~	`~`~`~	`~	`~`
MenuP:
loop, parse, mmenuListLbl, /,
	MenuLablAr[A_index]:= A_loopfield
loop, parse, mmenuListTtl, /,
	MenuLablTitlAr[MenuLablAr[A_index]] := A_loopfield
for index, element in MenuLablTitlAr
	menu, tray, Add,% element,% index
return,

; ~`~`~~`~;`~`~`~`~		~`~`~`~		~`~`~`~		~`~`~`  ~`~`~` ~`~`~	`~` ~`~ `~  ~`~`	~`~	`~`~`~	`~	`~`
test_icons:
mti := (NewTrayMenuParam("", "Launch PowerConfig", ((icn := "C:\Icon\") . "20\alien.ico") )), mti := (NewTrayMenuParam("", "Launch MattDWM", (icn . "24\dwm24.ico") )), mti := (NewTrayMenuParam("", "Launch YouTube_DL", (icn . "24\YouTube.ico") )), mti := (NewTrayMenuParam("", "DWM_Axnt_fix", (icn . "24\pNG\refresh.png") )), mti := (NewTrayMenuParam("", "LoadAeroRegKeyz", (icn . "24\PNG\refresh.png") )), mti := (NewTrayMenuParam("", "Launch M2Drag", (ScpW . "\Mouse242.ico") )), mti := (NewTrayMenuParam("", "Launch screen clean!", (icn . "24\AF_Icon.ico") )), mti := (NewTrayMenuParam("", "setsyscols", (icn . "24\colwh_24.ico") ))
mti := ""
return, 
; ~`~`~~`~;`~`~`~`~		~`~`~`~		~`~`~`~		~`~`~`  ~`~`~` ~`~`~	`~` ~`~ `~  ~`~`	~`~	`~`~`~	`~	`~`
;`~					  ~`~`~~`~`~`~`~`~``~`~``~`~`~`~`~`~`~`~`~`~`~`~`~
;~~~~~~~^^; 
 Menu_Tray_Init: ;=---- `~;/ add your own ; NewTrayMenuParam("LabelPointer", "Title", "Icon")
;~~~~~~~^^;  []
menu, 	tray, 	  NoStandard ;  menu, tray, icon,% TrayIconPath
menu, 	tray, 	  Icon, Context32.ico
menu, 	tray, 	  add, 	"SysMetrix", SysMetrix
menu, 	tray, 	  add, 	"DESKTOP_AREA", DESKTOP_AREA

menu, 	tray, 	  add, 	Open Script Dir, Open_ScriptDir

menu, 	tray, 	  Standard

gosub, 	MenuP               ; add the rest...
gosub, 	test_icons 			; and their ico

menu, 	SubMenu1, add,  restart wacom,   SvcRestartWacom
menu, 	SubMenu1, icon, restart wacom,   C:\Icon\24\DNA.ico

menu,   tray,     add,  Services,        :SubMenu1
menu,   tray,     icon, Services,        C:\Icon\24\DNA.ico
return,

SvcRestartWacom:
result := service_restart("WTabletServicePro")   
settimer, testresult, -4500
return,

testresult:  ;0 = OK
if result ! = 0	
{
	tries := tries + 1
	if(tries > 5) {
		msgbox % "unable to restart the " Target_Service " service"
		exitapp 
	}
	Tooltip retrying
	sleep 2000
	result := service_restart("WTabletServicePro")    
	
} else 
	ttp(("Success..`nThe" Target_Service " Restarted succesfully" A_now))
return,

;               Style and extended style setter menu Init
Menu_Style_Init:           
;                    -DeLimiters
_x := ("|"), _y := "£" 
; -String
str_aL:=("Sys_Menu" . _y . """Title (+ & X Conrols) (SysMenu)""" . _x . "Maxbox" . _y . """Maximise Button (□)""" . _x . "MinBox" . _y . """Minimise Button (_)""" . _x . "LeftScroll" . _y . """Left Scroll Orientation""" . _x . "ClickThru" . _y . """Click-through""" . _x . "RightAlign" . _y . """Generic Right-alignment""" . _x . "RightoLeft" . _y . """Right-to-Left reading""" . _x . "AppWindow" . _y . """Taskbar Item (not 100%)""" . _x . "Save" . _y . """Save window style preferences""" . _x . "Reset" . _y . """Reset window style preferences""")
;        -Parse
loop,     parse, str_aL,%      _x
	loop, parse, A_loopfield,% _y
		switch a_index {  
			case "1":
				eyeBall:=A_loopfield
			case "2": ; msgbox %
				Style_Men_arr_[eyeBall] := A_loopfield
		}
		for index, element in Style_Men_arr_
		;msgbox % index "`n" element
		bum="sysmenu"
		;msgbox % Style_Men_arr_["sys_menu"]
return  ;END
;	^-=___=-^				^-=___=-^				^--___=-^   ^   ~   ~   _   ¬   ¬   ¬   ¬   ¬   ¬   ¬   ¬   _
Varz:   ; 01010101010 ' ` ' `' `':C\Root\`'`'''`'      `''`0101'`'`'```''`'`'     ``'010101`''`'0xFFEEDD`'`'`'`'``'`'     			`''`''KILL!'`'`' '`''`'``'' `'`''`''` ''`'` '`''` `''` `''` `'` 
global AHKdir, AF, AF2, AutoFireScript, Scr_, dbgtt, AutoFireScript2, TargetScriptTitle, TargetScriptTitle2, AF_Delay, SysShadowStyle_New, SysShadowExStyle_New, toolx, offsett, XCent, YCent, starttime, text, X_X, Last_Title, autofire, RhWnd_old, MouseTextID, DMT, roblox, toggleshift, Norm_menuStyle, Norm_menuexStyle, Title_last, dcStyle, classname, tool, tooly, EventLogBuffer_Old, Roblox_hwnd, Time_Elapsed, KillCount, SBAR_2berestored_True, Sidebar, TT, TT4g, TTFoc, TTcr, TTds, TTmb, dbg, TClass, TTitle, TProcName, delim, delim2, TitleCount, ClassCount, ProcCount, style2, new_exstyle, ArrayProc, ArrayClass, ArrayTitle, Array_LProc, Array_LTitle, Array_LClass, Style_ClassnameList2, Style_procnameList2, Style_wintitleList2, Youtube_Popoutwin, Script_Title, np, m2dstatus, crashmb, 8skin_crash, OutputVarWin, F, s1, s2, s3, FileListStr, oldlist, FileCount, ADELIM, hTarget, hTargetprev, hgui, xPrev, yPrev, hPrev, logvar, ADM_wTtL, triggeredGFS, Matrix, Maxbox, MinBox, LeftScroll, ClickThru, RightAlign, RightoLeft, AppWindow, Save, Reset, MiDiRun, test_move, 

global mattdwmrun, Quoting, mmenuListTtl, MenuLablAr, MenuLablTitlAr, mmenuListLbl, Desk_Wi, Desk_Hi, FileListStr_Ar, hTargetPrev, wPrev, hPrev, xPrev, yPrev, hidegui, q_dlim, quotes, DEBUGTEST_HWND, hook4g, HookMb, HookCr, HookOD, HookFc, DEBUGTEST_FOC, hook4g, Proc4g_, AhkPath, HookMb, ProcMb_, ProcCr_, ProcDstroyd, procFc_, nnd, 1998, 1999, SkpO, old_focus1, old_focus2, old_focus3, old4gnd1, old4gnd2, old4gnd3, qstr, mattdwmrun2, test_move, SidebarPath, Path_PH, AHK_Rare, CleanME_PLZz, Schd_T, HKCUCurVer, stylekey, AdHkRun, PConfig, YT_DL, M2dRun, Mag_, DWMFixS, WMPRun, MiDiRun, MiDi_, adh, ScpW, MiDir, winevents, winevents_i, Split_Tail, Split_Head, RiPpLe, ripoldm, t_x, t_Y, lo0, Style_Men_arr_, mouse24, wintitlekey, procnamekey, classnamekey, OBJ4g, OBJFc, OBJCR, OBJDS, MNPPS, WIN_TARGET_DESC, MSG_WIN_TARGET, WINEVENT_SkpOROCESS, WINEVENT_OUTOFCONTEXT, OoC, Desktop_Margin, hooked_events, newhook, firefoxhandles, classeslast, clst_max_I, classeslast, Clss_, Pnamee_, AHkold, SysMetrix, Contextmenu 
 
global TargetHandle, old_classfocus2, old_classfocus1, old_classfocus3, old_classfocus4, hWnd4st, classhwlast, classeslast2, classhwlast2, clht_max_I, clht2_max_I, TBBUTTON, vCount, extension_set, alignment, Gui_W, GuiRolled, met_desc, copy, Gui_lastclass_W, Gui_lastclass_H, Gui_extended, Windle, hookreadonly, count23, list_death, icon_clhw_arr, icon_cl_arr, icon_PN_arr, icon_tt_arr, icon_style_arrnew_PN, new_style, new_exstyle, onlytt, onlypn, onlycl, syscols, action_, act, typeid, IProcName, IClass, ITitle, pn_, cl_, tt_

;hookreadonly := "create,destroy,focus,foreground,dialogstart" ; hardcoded , Can be added to uhook. to restrict, uncomment this line

Gui_extended    := true
Gui_lastclass_W := 1010
Gui_lastclass_H := 1077

marginSz  := 11
met_desc  := []
sysmetric := []

clht_max_I  := 0
clst_max_I  := 0
clht2_max_I := 0
clst2_max_I := 0

 ;	^-=___=-^ 	 ;-=-=;'`'``''`'`'``''`'`'``''`'`'`
 
tt := 800 			     ; default tooltip timeout
loop, parse,% "ArrayProc,ArrayClass,ArrayTitle,Array_LProc,Array_LTitle,Array_LClass,MenuLablAr,MenuLablTitlAr,FileListStr_Ar,quotes,winevents_i,winevents,hooked_events,Style_Men_arr_,firefoxhandles,classeslast,classhwlast,classeslast2,classhwlast2,icon_clhw_arr,icon_cl_arr,icon_PN_arr,icon_tt_arr,icon_style_arr", `,
	%A_loopfield% := []  ; array_inits:

mmenuListTtl := "4ground hook tip/focus hook tip/obj_create tip/obj_destroy tip/msgbox hook tip/Toggle debug/Toggle Sidebar off/DWM_Axnt_fix/LoadAeroRegKeyz/Launch PowerConfig/Launch MattDWM/Launch M2Drag/Launch WMP_MATT/Launch midi_in_out/Launch AdHkRun/Launch YouTube_DL/Launch test_move/Launch screen clean!/CLSIDS Folders/SetSysCols"
mmenuListLbl := "TT4g/TTFoc/TTcr/TTds/TTmb/Toggle_dbg/Toggle_sbar/DWMFixS/AeroTheme_Set/pconfig/mattdwmrun2/M2dRun/WMPRun/MiDi_/AdHkRun/YT_DL/test_move/CleanME_PLZz/clsids/syscols"
loop, 22 {               ; -=-=;'`'``''`'`'``''`'`'``''`'`'``
	v1 :=  ("hChildMagnifier" . A_index) 
	global (%v1%)
	v2 :=  ("hgui" .            A_Index) 
	global (%v2%)
	v3 :=  ("HWNDhgui" .        A_Index) 
	global (%v3%)       ; -=-=-;'`'``''`
}		
;`'``''`'`'``''`'`'``''`'`'`'``
Matrix :=(  "-1	|0	|0	|0	|0|"  ;'``''
.           "0	|-1	|0	|0	|0|"  ;``''`
.           "0	|0	|-1	|0	|0|"  ;`''`'
.           "0	|0	|0	|1	|0|"  ;''`'`
.           "1	|1	|1	|0	|1 " ) ;'`'`
;"!!!        vARi4bl3z !!!!" ...         ^-=___=-^	>>>>>>>>>>>>;??? ;  	 ~@~peww~@~	
; DWM_Run:= ((Autoit3path := "C:\Program Files (x86)\AutoIt3\AutoIt3_x64.exe") . " " . "C:\Script\autoit\_MattDwmBlurBehindWindow.au3") 
;regRead, AHKdir,  HKLM\SOFTWARE\AutoHotkey,% "InstallDir"    registrykey no longer present post 1.33.11
sysget,   Desktop_Margin, MonitorWorkArea
sysget,   Desk_Wi, 78
sysget,   Desk_Hi, 79
XCent       :=  (floor(0.5*Desk_Wi))
YCent       :=  (floor(0.5*Desk_Hi))
AHKdir      :=  "c:\program files\AutoHotkey" 
AHk64       :=  (AHKdir . "\Autohotkey.exe ")
AHkold      :=  "c:\program files\ahk\Autohotkey.exe "
ScpW        :=  "C:\Script\AHK\Working"
mattdwmrun2	:=  "C:\Script\autoit\_MattDwmBlurBehindWindow.au3"    ;   ^^^Wrong start dir envVar 1nce launched?
test_move	:=  "C:\Users\ninj\DESKTOP\winmove_test.ahk"
SidebarPath :=  "C:\Program Files\Windows Sidebar\sidebar.exe"
Path_PH 	:=  "C:\Apps\Ph\processhacker\x64\ProcessHacker.exe"
AHK_Rare 	:=  ((Scr_ := ("C:\Script\AHK")) . ("\- Script\AHK-Rare-master\AHKRareTheGui.ahk"))
CleanME_PLZz:=  (Scr_ . "\white_full-screen_gui.ahk")
Schd_T      :=  "C:\Windows\system32\schtasks.exe"
HKCUCurVer	:=  "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion"
stylekey    :=  "HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles"
syscols     :=  "C:\Script\AHK\- Script\syscolors.ahk"
;    menu    labels    building
AdHkRun  := (sched_tsk:=(Schd_T . " /run /tn ") . (adh:="adminhotkeys.ahk") . "_407642875")
PConfig  := (sched_tsk  .  "cmd_output_to_msgbox.ahk_407642875")                           
YT_DL    := (( (AHkU64Uia := (AHKdir . "\AutoHotkeyU64_UIA.exe ")) . ScpW . "\YT.ahk" ))
Mag_     := ( AHk64 . " " . ScpW . "\M2DRAG_MAG.AHK") 
DWMFixS  := ( AHkU64UiaaDM := ((AHKdir . "\AutoHotkeyU64_UIA - admin.exe ")) . (Scr_ . "\Working\dwm_accentcolour.ahk"))
;WMPRun  := ( AHkU64    .  Scr_ . "\Z_MIDI_IN_OUT\wmp_Matt.ahk")
WMPRun   := ( AHk64    .  Scr_ . "\Z_MIDI_IN_OUT\wmp_Matt.ahk")
MiDiRun  := ( AHKdir    .  "AutoHotkeyU64.exe " . Scr_ . MiDir)
ADM_wTtL := ( Scr_      .  "\" . adh . " - AutoHotkey v1.1.33.10")
MiDi_    := ( AHkU64 . Scr_ .  (MiDir:=("\Z_MIDI_IN_OUT" . "\z_in_out.ahk")))
SysMetrix:=AHk64 . "C:\Script\AHK\sysget_(GUI).ahk"
M2dRun   := ( AHkU64Uia .  Scr_ .  "\Working\M2Drag.ahk")
clsids   := ( AHkU64    .  Scr_ . "\Explorer_CLSIDs_W10.ahk")
BF := "Roblox_Rapid.ahk", BF2 := "Roblox_Bunny.ahk", af_1 := ("\" . BF),   Bun_ := ("\" . BF2), AF := (Scr_ . af_1), AF2 := (Scr_ . Bun_), AutoFireScript := BF, AutoFireScript2 := BF2 , TargetScriptTitle := (AutoFireScript . " ahk_class AutoHotkey"), TargetScriptTitle2 := (AutoFireScript2 . " ahk_class AutoHotkey"), AF_Delay := 10, SysShadowStyle_New := 0x08000000, SysShadowExStyle_New := 0x08000020, toolx := "-66", offsett := 40, delim := "Þ", delim1 := "µ", delim2 := "»",KILLSWITCH := "kill all AHK procs.ahk", mouse24 := "C:\Script\AHK\Working\mouse24.ico", 
OBJ4g := 0x0003, OBJFc:=0x8005, OBJCR := 0x8000, OBJDS := 0x8001, MNPPS := 0x0006, WIN_TARGET_DESC := "Information", MSG_WIN_TARGET := WIN_TARGET_DESC, WINEVENT_SkpOROCESS := 0x0002, SkpO := WINEVENT_SkpOROCESS, WINEVENT_OUTOFCONTEXT := 0x0000, OoC := WINEVENT_OUTOFCONTEXT, wintitlekey := (stylekey . "\wintitle"), procnamekey := (stylekey . "\procname"), classnamekey := (stylekey . "\classname")
DESKTOP_AREA= %AHk64% "C:\Script\AHK\Desktop_Set-Workarea.ahk"

stylearr:=[]
stylearr["toggle_sysmenu"]     :=  "^0x00080000"
stylearr["toggle_DLGFRAME"]    :=  "^0x00400000"
stylearr["toggle_thickframe"]  :=  "^0x00040000"
stylearr["toggle_border"]      :=  "^0x00040000"
stylearr["toggle_MinBox"]      :=  "^0x00020000"
stylearr["toggle_Maxbox"]      :=  "^0x00010000"
stylearr["toggle_hscroll"]     :=  "^0x00100000"
stylearr["toggle_vscroll"]     :=  "^0x00200000"

stylexarr:=[]
stylexarr["toggle_modalframe"] :=  "^0x00000001"
stylexarr["toggle_raisededge"] :=  "^0x00000100"
stylexarr["toggle_sunkenedge"] :=  "^0x00000100"
stylexarr["toggle_staticedge"] :=  "^0x00020000"
stylexarr["toggle_3dedge"]     :=  "^0x00020000"
stylexarr["toggle_LeftScroll"] :=  "^0x00004000"
stylexarr["toggle_Clickthru"]  :=  "^0x00000020"
stylexarr["toggle_RightAlign"] :=  "^0x00001000"
stylexarr["toggle_RightoLeft"] :=  "^0x00002000"
stylexarr["toggle_AppWindow"]  :=  "^0x00040000"

donothing:
return,
;------------=========================++++++++++++++++++++*+*+*+*
Open_ScriptDir() ; not called ever, using to invoke its label(s).
;------------=========================++++++++++++++++++++*+*+*+*
init_matt:
loop, parse, INIT_SEQ, ">",
	gosub,% A_loopfield

event1 := ("EVENT_OBJECT_ACCELERATORCHANGE|0x8012|An object's KeyboardShortcut property has changed. Server applications send this event for their accessible objects.¬EVENT_OBJECT_CLOAKED|0x8017|Sent when a window is cloaked. A cloaked window still exists, but is invisible to the user.¬EVENT_OBJECT_CONTENTSCROLLED|0x8015|A window object's scrolling has ended. Unlike EVENT_SYSTEM_SCROLLEND, this event is associated with the scrolling window. Whether the scrolling is horizontal or vertical scrolling, this event should be sent whenever the scroll action is completed.  The hwnd parameter of the WinEventProc callback function describes the scrolling window  the idObject parameter is OBJID_CLIENT, and the idChild parameter is CHILDID_SELF.¬EVENT_OBJECT_CREATE|0x8000|An object has been created. The system sends this event for the following user interface elements: caret, header control, list-view control, tab control, toolbar control, tree view control, and window object. Server applications send this event for their accessible objects.  Before sending the event for the parent object, servers must send it for all of an object's child objects. Servers must ensure that all child objects are fully created and ready to accept IAccessible calls from clients before the parent object sends this event.  Because a parent object is created after its child objects, clients must make sure that an object's parent has been created before calling IAccessible::get_accParent, particularly if in-context hook functions are used.¬EVENT_OBJECT_DEFACTIONCHANGE|0x8011|An object's DefaultAction property has changed. The system sends this event for dialog boxes. Server applications send this event for their accessible objects.¬EVENT_OBJECT_DESCRIPTIONCHANGE|0x800D|An object's Description property has changed. Server applications send this event for their accessible objects.¬EVENT_OBJECT_DESTROY|0x8001|An object has been destroyed. The system sends this event for the following user interface elements: caret, header control, list-view control, tab control, toolbar control, tree view control, and window object. Server applications send this event for their accessible objects. Clients assume that all of an object's children are destroyed when the parent object sends this event.  After receiving this event, clients do not call an object's IAccessible properties or methods. However, the interface pointer must remain valid as long as there is a reference count on it due to COM rules, but the UI element may no longer be present. Further calls on the interface pointer may return failure errors  to prevent this, servers create proxy objects and monitor their life spans.¬EVENT_OBJECT_DRAGSTART|0x8021|The user started to drag an element. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the object being dragged.¬EVENT_OBJECT_DRAGCANCEL|0x8022|The user has ended a drag operation before dropping the dragged element on a drop target. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the object being dragged.¬EVENT_OBJECT_DRAGCOMPLETE|0x8023|The user dropped an element on a drop target. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the object being dragged.¬EVENT_OBJECT_DRAGENTER|0x8024|The user dragged an element into a drop target's boundary. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the drop target.¬EVENT_OBJECT_DRAGLEAVE|0x8025|The user dragged an element out of a drop target's boundary. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the drop target.¬EVENT_OBJECT_DRAGDROPPED|0x8026|The user dropped an element on a drop target. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the drop target.¬EVENT_OBJECT_END|0x80FF|The highest object event value.¬EVENT_OBJECT_FOCUS|0x8005|An object has received the keyboard focus. The system sends this event for the following user interface elements: list-view control, menu bar, pop-up menu, switch window, tab control, tree view control, and window object. Server applications send this event for their accessible objects.  The hwnd parameter of the WinEventProc callback function identifies the window that receives the keyboard focus.¬EVENT_OBJECT_HELPCHANGE|0x8010|An object's Help property has changed. Server applications send this event for their accessible objects.¬EVENT_OBJECT_HIDE|0x8003|An object is hidden. The system sends this event for the following user interface elements: caret and cursor. Server applications send this event for their accessible objects. When this event is generated for a parent object, all child objects are already hidden. Server applications do not send this event for the child objects.	Hidden objects include the STATE_SYSTEM_INVISIBLE flag  shown objects do not include this flag. The EVENT_OBJECT_HIDE event also indicates that the STATE_SYSTEM_INVISIBLE flag is set. Therefore, servers do not send the EVENT_STATE_CHANGE event in this case.¬EVENT_OBJECT_HOSTEDOBJECTSINVALIDATED|0x8020|A window that hosts other accessible objects has changed the hosted objects. A client might need to query the host window to discover the new hosted objects, especially if the client has been monitoring events from the window. A hosted object is an object from an accessibility framework MSAA or UI Automation that is different from that of the host. Changes in hosted objects that are from the same framework as the host should be handed with the structural change events, such as EVENT_OBJECT_CREATE for MSAA. For more info see comments within winuser.h.¬EVENT_OBJECT_IME_HIDE|0x8028|An IME window has become hidden.¬EVENT_OBJECT_IME_SHOW|0x8027|An IME window has become visible.¬EVENT_OBJECT_IME_CHANGE|0x8029|The size or position of an IME window has changed.¬EVENT_OBJECT_INVOKED|0x8013|An object has been invoked  for example, the user has clicked a button. This event is supported by common controls and is used by UI Automation.	For this event, the hwnd, ID, and idChild parameters of the WinEventProc callback function identify the item that is invoked.¬EVENT_OBJECT_LIVEREGIONCHANGED|0x8019|An object that is part of a live region has changed. A live region is an area of an application that changes frequently and/or asynchronously.¬")
event15 := ("EVENT_OBJECT_LOCATIONCHANGE|0x800B|An object has changed location, shape, or size. The system sends this event for the following user interface elements: caret and window objects. Server applications send this event for their accessible objects.  This event is generated in response to a change in the top-level object within the object hierarchy  it is not generated for any children that the object might have. For example, if the user resizes a window, the system sends this notification for the window, but not for the menu bar, title bar, scroll bar, or other objects that have also changed.  The system does not send this event for every non-floating child window when the parent moves. However, if an application explicitly resizes child windows as a result of resizing the parent window, the system sends multiple events for the resized children.	  If an object's State property is set to STATE_SYSTEM_FLOATING, the server sends EVENT_OBJECT_LOCATIONCHANGE whenever the object changes location. If an object does not have this state, servers only trigger this event when the object moves in relation to its parent. For this event notification, the idChild parameter of the WinEventProc callback function identifies the child object that has changed.¬EVENT_OBJECT_NAMECHANGE|0x800C|An object's Name property has changed. The system sends this event for the following user interface elements: check box, cursor, list-view control, push button, radio button, status bar control, tree view control, and window object. Server applications send this event for their accessible objects.¬EVENT_OBJECT_PARENTCHANGE|0x800F|An object has a new parent object. Server applications send this event for their accessible objects.¬EVENT_OBJECT_REORDER|0x8004|A container object has added, removed, or reordered its children. The system sends this event for the following user interface elements: header control, list-view control, toolbar control, and window object. Server applications send this event as appropriate for their accessible objects.	  For example, this event is generated by a list-view object when the number of child elements or the order of the elements changes. This event is also sent by a parent window when the Z-order for the child windows changes.¬EVENT_OBJECT_SELECTION|0x8006|The selection within a container object has changed. The system sends this event for the following user interface elements: list-view control, tab control, tree view control, and window object. Server applications send this event for their accessible objects. This event signals a single selection: either a child is selected in a container that previously did not contain any selected children, or the selection has changed from one child to another.  The hwnd and idObject parameters of the WinEventProc callback function describe the container  the idChild parameter identifies the object that is selected. If the selected child is a window that also contains objects, the idChild parameter is OBJID_WINDOW.¬EVENT_OBJECT_SELECTIONADD|0x8007|A child within a container object has been added to an existing selection. The system sends this event for the following user interface elements: list box, list-view control, and tree view control. Server applications send this event for their accessible objects.  The hwnd and idObject parameters of the WinEventProc callback function describe the container. The idChild parameter is the child that is added to the selection.¬EVENT_OBJECT_SELECTIONREMOVE|0x8008|An item within a container object has been removed from the selection. The system sends this event for the following user interface elements: list box, list-view control, and tree view control. Server applications send this event for their accessible objects.  This event signals that a child is removed from an existing selection.  The hwnd and idObject parameters of the WinEventProc callback function describe the container  the idChild parameter identifies the child that has been removed from the selection.¬")
event2 := ("EVENT_OBJECT_SELECTIONWITHIN|0x8009|Numerous selection changes have occurred within a container object. The system sends this event for list boxes  server applications send it for their accessible objects.	  This event is sent when the selected items within a control have changed substantially. The event informs the client that many selection changes have occurred, and it is sent instead of several EVENT_OBJECT_SELECTIONADD or EVENT_OBJECT_SELECTIONREMOVE events. The client queries for the selected items by calling the container object's IAccessible::get_accSelection method and enumerating the selected items.  For this event notification, the hwnd and idObject parameters of the WinEventProc callback function describe the container in which the changes occurred.¬EVENT_OBJECT_SHOW|0x8002|A hidden object is shown. The system sends this event for the following user interface elements: caret, cursor, and window object. Server applications send this event for their accessible objects.  Clients assume that when this event is sent by a parent object, all child objects are already displayed. Therefore, server applications do not send this event for the child objects.  Hidden objects include the STATE_SYSTEM_INVISIBLE flag  shown objects do not include this flag. The EVENT_OBJECT_SHOW event also indicates that the STATE_SYSTEM_INVISIBLE flag is cleared. Therefore, servers do not send the EVENT_STATE_CHANGE event in this case.¬EVENT_OBJECT_STATECHANGE|0x800A|An object's state has changed. The system sends this event for the following user interface elements: check box, combo box, header control, push button, radio button, scroll bar, toolbar control, tree view control, up-down control, and window object. Server applications send this event for their accessible objects.	  For example, a state change occurs when a button object is clicked or released, or when an object is enabled or disabled.	  For this event notification, the idChild parameter of the WinEventProc callback function identifies the child object whose state has changed.¬EVENT_OBJECT_TEXTEDIT_CONVERSIONTARGETCHANGED|0x8030|The conversion target within an IME composition has changed. The conversion target is the subset of the IME composition which is actively selected as the target for user-initiated conversions.¬EVENT_OBJECT_TEXTSELECTIONCHANGED|0x8014|An object's text selection has changed. This event is supported by common controls and is used by UI Automation.  The hwnd, ID, and idChild parameters of the WinEventProc callback function describe the item that is contained in the updated text selection.¬EVENT_OBJECT_UNCLOAKED|0x8018|Sent when a window is uncloaked. A cloaked window still exists, but is invisible to the user.¬EVENT_OBJECT_VALUECHANGE|0x800E|An object's Value property has changed. The system sends this event for the user interface elements that include the scroll bar and the following controls: edit, header, hot key, progress bar, slider, and up-down. Server applications send this event for their accessible objects.¬EVENT_SYSTEM_ALERT|0x0002|An alert has been generated. Server applications should not send this event.¬EVENT_SYSTEM_ARRANGMENTPREVIEW|0x8016|A preview rectangle is being displayed.¬EVENT_SYSTEM_CAPTUREEND|0x0009|A window has lost mouse capture. This event is sent by the system, never by servers.¬EVENT_SYSTEM_CAPTURESTART|0x0008|A window has received mouse capture. This event is sent by the system, never by servers.¬EVENT_SYSTEM_CONTEXTHELPEND|0x000D|A window has exited context-sensitive Help mode. This event is not sent consistently by the system.¬EVENT_SYSTEM_CONTEXTHELPSTART|0x000C|A window has entered context-sensitive Help mode. This event is not sent consistently by the system.¬EVENT_SYSTEM_DESKTOPSWITCH|0x0020|The active desktop has been switched.¬EVENT_SYSTEM_DIALOGEND|0x0011|A dialog box has been closed. The system sends this event for standard dialog boxes  servers send it for custom dialog boxes. This event is not sent consistently by the system.¬EVENT_SYSTEM_DIALOGSTART|0x0010|A dialog box has been displayed. The system sends this event for standard dialog boxes, which are created using resource templates or Win32 dialog box functions. Servers send this event for custom dialog boxes, which are windows that function as dialog boxes but are not created in the standard way.  This event is not sent consistently by the system.¬EVENT_SYSTEM_DRAGDROPEND|0x000F|An application is about to exit drag-and-drop mode. Applications that support drag-and-drop operations must send this event the system does not send this event.¬EVENT_SYSTEM_DRAGDROPSTART|0x000E|An application is about to enter drag-and-drop mode. Applications that support drag-and-drop operations must send this event because the system does not send it.¬EVENT_SYSTEM_END|0x00FF|The highest system event value.¬EVENT_SYSTEM_FOREGROUND|0x0003|The foreground window has changed. The system sends this event even if the foreground window has changed to another window in the same thread. Server applications never send this event.	For this event, the WinEventProc callback function's hwnd parameter is the handle to the window that is in the foreground, the idObject parameter is OBJID_WINDOW, and the idChild parameter is CHILDID_SELF.¬EVENT_SYSTEM_MENUPOPUPEND|0x0007|A pop-up menu has been closed. The system sends this event for standard menus  servers send it for custom menus.  When a pop-up menu is closed, the client receives this message, and then the EVENT_SYSTEM_MENUEND event.	This event is not sent consistently by the system.¬EVENT_SYSTEM_MENUPOPUPSTART|0x0006|A pop-up menu has been displayed. The system sends this event for standard menus, which are identified by HMENU, and are created using menu-template resources or Win32 menu functions. Servers send this event for custom menus, which are user interface elements that function as menus but are not created in the standard way. This event is not sent consistently by the system.¬EVENT_SYSTEM_MENUEND|0x0005|A menu from the menu bar has been closed. The system sends this event for standard menus  servers send it for custom menus.  For this event, the WinEventProc callback function's hwnd, idObject, and idChild parameters refer to the control that contains the menu bar or the control that activates the context menu. The hwnd parameter is the handle to the window that is related to the event. The idObject parameter is OBJID_MENU or OBJID_SYSMENU for a menu, or OBJID_WINDOW for a pop-up menu. The idChild parameter is CHILDID_SELF.¬EVENT_SYSTEM_MENUSTART|0x0004|A menu item on the menu bar has been selected. The system sends this event for standard menus, which are identified by HMENU, created using menu-template resources or Win32 menu API elements. Servers send this event for custom menus, which are user interface elements that function as menus but are not created in the standard way.	For this event, the WinEventProc callback function's hwnd, idObject, and idChild parameters refer to the control that contains the menu bar or the control that activates the context menu. The hwnd parameter is the handle to the window related to the event. The idObject parameter is OBJID_MENU or OBJID_SYSMENU for a menu, or OBJID_WINDOW for a pop-up menu. The idChild parameter is CHILDID_SELF.	The system triggers more than one EVENT_SYSTEM_MENUSTART event that does not always correspond with the EVENT_SYSTEM_MENUEND event.¬EVENT_SYSTEM_MINIMIZEEND|0x0017|A window object is about to be restored. This event is sent by the system, never by servers.¬EVENT_SYSTEM_MINIMIZESTART|0x0016|A window object is about to be minimized. This event is sent by the system, never by servers.¬EVENT_SYSTEM_MOVESIZEEND|0x000B|The movement or resizing of a window has finished. This event is sent by the system, never by servers.¬EVENT_SYSTEM_MOVESIZESTART|0x000A|A window is being moved or resized. This event is sent by the system, never by servers.¬EVENT_SYSTEM_SCROLLINGEND|0x0013|Scrolling has ended on a scroll bar. This event is sent by the system for standard scroll bar controls and for scroll bars that are attached to a window. Servers send this event for custom scroll bars, which are user interface elements that function as scroll bars but are not created in the standard way.  The idObject parameter that is sent to the WinEventProc callback function is OBJID_HSCROLL for horizontal scroll bars, and OBJID_VSCROLL for vertical scroll bars.¬EVENT_SYSTEM_SCROLLINGSTART|0x0012|Scrolling has started on a scroll bar. The system sends this event for standard scroll bar controls and for scroll bars attached to a window. Servers send this event for custom scroll bars, which are user interface elements that function as scroll bars but are not created in the standard way.  The idObject parameter that is sent to the WinEventProc callback function is OBJID_HSCROLL for horizontal scrolls bars, and OBJID_VSCROLL for vertical scroll bars.¬EVENT_SYSTEM_SOUND|0x0001|A sound has been played. The system sends this event when a system sound, such as one for a menu, is played even if no sound is audible for example, due to the lack of a sound file or a sound card. Servers send this event whenever a custom UI element generates a sound.  For this event, the WinEventProc callback function receives the OBJID_SOUND value as the idObject parameter.¬EVENT_SYSTEM_SWITCHEND|0x0015|The user has released ALT+TAB. This event is sent by the system, never by servers. The hwnd parameter of the WinEventProc callback function identifies the window to which the user has switched.  If only one application is running when the user presses ALT+TAB, the system sends this event without a corresponding EVENT_SYSTEM_SWITCHSTART event.¬EVENT_SYSTEM_SWITCHSTART|0x0014|The user has pressed ALT+TAB, which activates the switch window. This event is sent by the system, never by servers. The hwnd parameter of the WinEventProc callback function identifies the window to which the user is switching.  If only one application is running when the user presses ALT+TAB, the system sends an EVENT_SYSTEM_SWITCHEND event without a corresponding EVENT_SYSTEM_SWITCHSTART event.")

EVENT_AIA_START :=  0xA000
EVENT_AIA_END   :=  0xAFFF
EVENT_MIN       :=  0x00000001
EVENT_MAX       :=  0x7FFFFFFF
EVENT_UIA_EVENTID_START := 0x4E00
EVENT_UIA_EVENTID_END   := 0x4EFF
EVENT_OEM_DEFINED_START := 0x0101	; The range of event constant values reserved for OEMs. 
EVENT_OEM_DEFINED_END   := 0x01FF
EVENT_UIA_PROPID_START  := 0x7500	; The range of event constant values reserved for UI Automation event identifiers. 
EVENT_UIA_PROPID_END    := 0x75FF

eventgui:
gui, DGuI: new, +owner 
gui, DGui: -Caption -DPIScale -SysMenu +ToolWindow +OwndiaLogs

eventgui_create:
Split_Head  :=  "OBJECT_REORDER,ECT_END"
Split_Tail  :=  "DRAGCANCEL,ECT_END"
loop, parse,% "event1,event15,event2", `,
	loop, parse, %A_loopfield%, ¬,
		loop, parse, A_loopfield, |,
			switch A_index {
				case 1:
					eventname:= substr(A_loopfield, 14) ; trim prefix "EVENT_OBJECT_"
				case 2:
					eventcode:= A_loopfield
				case 3:
					winevents[eventname]  :=  eventcode 
					leng := StrLen(A_loopfield)		
					if (leng > 99 )                    { 
						mainstring:= ""
						aiold     :=  1
						loop,% lo0 := ceil((leng*0.01)){
							if (a_index = "1")         {
								if (a_index = lo0)
									  mainstring    := (SubStr(A_loopfield, 1)) ;
								else, mainstring    := (SubStr(A_loopfield, 1, 100)) . "`n"
							} else {
								if (a_index = lo0)     {
									azss :=(SubStr(A_loopfield, ((a_index -1) * 100)))
									mainstring      :=  mainstring . azss
								} else {
									if(a_index != lo0) {
										m_String_temp      :=  SubStr(A_loopfield, ((a_index -1) * 100), 100)
										mainstring  := (mainstring . m_String_temp . "`n")
						}	}	}	} 
						    winevents_i[eventname]  :=  mainstring
					} else, winevents_i[eventname]  :=  A_loopfield
			}

sleep, 200
global TBBUTTON, vCount, extension_set, alignment, Gui_W, GuiRolled, Gui_sysL_H, Gui_sys_H

alignment := "C"

;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray;tray
;menu, tray,     icon,%  "C:\Script\AHK\APP_COG.ico"
menu, M_align,   add,%  "Left",   Align_l
menu, M_align,   add,%  "Center", Align_c
menu, M_align,   add,%  "Right",  Align_r
switch alignment {
	case "L":
		menu, M_align, uncheck,%  "Right", 
		menu, M_align, uncheck,%  "Center", 
		menu, M_align,   check,%  "Left", 
		na:=" x5 y57 "
	case "C":
		menu, M_align, uncheck,%  "Right", 
		menu, M_align, uncheck,%  "Left", 
		menu, M_align,   check,%  "Center", 
		na:="center"
	case "R":
		menu, M_align, uncheck,%  "Center", 
		menu, M_align, uncheck,%  "Left", 
		menu, M_align,   check,%  "Right", 
		na:=" x2632 y62 "
}
menu, tray,      add,%    "Aligment",  :M_align
menu, tray,      add,%    "extended entries",  GoGoGadget_Gui
menu, M_align,   Check,%  "Center"

;gui
Menu, m_file,    Add
Menu, m_view,    Add
Menu, m_Options, Add
Menu, MenuBar, Add
Menu, premenu,   Add

tt("loading...")
Menu, m_file,    DeleteAll
Menu, m_view,    DeleteAll
Menu, m_Options, DeleteAll
Menu, MenuBar,   DeleteAll
Menu, premenu,   DeleteAll

Menu, MenuBar,   Add, File,     :m_file
Menu, MenuBar,   Add, View,     :m_view
Menu, MenuBar,   Add, Options,  :m_Options
Menu, m_file,    Add, Save, MyMenuLabel
Menu, m_file,    Add, Open previous results, MyMenuLabel
Menu, m_file,    Add, Open results in new Window, MyMenuLabel
Menu, m_view,    Add, Position, :premenu
Menu, premenu,   Add, Left,     MyMenuLabel
Menu, premenu,   Add, Center,   MyMenuLabel
Menu, premenu,   Add, Bottom,   MyMenuLabel
Menu, m_view,    Add, Icons,    MyMenuLabel
Menu, m_view,    Add, Legend,   MyMenuLabel
Menu, m_view,    Add, Extended, extension_toggle
if extension_set 
	Menu, m_view,    check, Extended

Menu, m_Options, Add, Size,     MyMenuLabel
Menu, m_Options, Add, Font,     MyMenuLabel
Menu, m_Options, Add, Colours,  MyMenuLabel

Gui_extended := !Gui_extended
GoGoGadget_Gui:

gui, Gui_sys: Destroy
Gui, Gui_sys: New, +hwndWindle -dpiscale, Event-Hooks ; 
Gui, Gui_sys: Margin,% marginSz,% marginSz
;Gui, Gui_sys: Menu, MenuBar
;RICHEDIT50W
;hModuleME := DllCall("kernel32.dll\LoadLibrary", Str,"msftedit.dll", Ptr)
vPos := "y35" 
vCount := 5, vSize := A_PtrSize=8?32:20
VarSetCapacity(TBBUTTON, vCount*vSize, 0)
Loop, %vCount% {
	switch a_index {
		case 1:
			vTxt%A_Index% := "Tearing soul apart..."
		default:
			vTxt%A_Index% := "dicks..."
	}
		vOffset       := (A_Index-1)*vSize
		NumPut(A_Index-1,      TBBUTTON, vOffset,   "Int")                   ;iBitmap
		NumPut(A_Index-1,      TBBUTTON, vOffset+4, "Int")                   ;idCommand
		NumPut(0x4,            TBBUTTON, vOffset+8, "UChar")                 ;fsState	;TBSTATE_ENABLED := 4
		NumPut(&vTxt%A_Index%, TBBUTTON, vOffset+(A_PtrSize=8?24:16), "Ptr") ;iString
}
hIL := IL_Create(5, 2, 48)
IL_Add(hIL, "C:\Icon\256\pinhead.ico", 0)
IL_Add(hIL, "C:\Icon\48\copy248.ico", 0) 
IL_Add(hIL, "C:\Icon\48\chrome_48.ico", 0)
IL_Add(hIL, "C:\Icon\48\paste_send_to48.ico", 0)
IL_Add(hIL, "C:\Icon\48\Star (4).ico", 0) 

GUISYS_LVW := 890
Gui_sysL_H := 890
gui, Gui_sys:Add, ListView, gTranny vCopy x0 y0 Checked ReadOnly w%GUISYS_LVW% h%Gui_sysL_H% +E0x4000 0x4 LV0x8200 Grid R38 +Multi NoSort NoSortHdr, Sys-Event|Description|Value
 LV_ModifyCol(1, "180 Text"), LV_ModifyCol(2, "Text 600"), LV_ModifyCol(3, "Text c0xFF2211 80")  
 GuiControl, +Report, tranny
 for Index, element in winevents {
	t_Ind := strreplace(Index,"EVENT_OBJECT_") ;strrip prefix
	max_index += 1
	loop, parse, hookreadonly, `,
		if  (a_loopfield = t_Ind) {
			count23  += 1
			detected := true
			break,
		}
	if !detected
		LV_Add("-Select",t_Ind, winevents_i[ index ],winevents[ index ])	
	if !list_death
		list_death := max_index . ","
	list_death := list_death . max_index . ","
	detected :=
}
GLOBAL GUISYS_TB_Y := Gui_sysL_H + 10 
Gui, Gui_sys:Add, Custom,  y%GUISYS_TB_Y% ClassToolbarWindow32 0x100 ;TBSTYLE_TOOLTIPS := 0x100 | (TBSTYLE_LIST:=0x1000) ;text to side of buttons
ControlGet,  hTB, Hwnd,, ToolbarWindow321,% "ahk_id " Windle
SendMessage, 0x43C, 0, 0,,% "ahk_id " hTB ;TB_SETMAXTEXTROWS ;text omitted from buttons; ;note: if more than one button has the same idCommand, then only the last button with that idCommand will have make the call.
SendMessage, 0x430, 0, % hIL,,% "ahk_id " hTB               ;  (TB_SETIMAGELIST := 0x430) ;  (TB_ADDBUTTONSA := 0x414) 
vMsg := A_IsUnicode ? 0x444 : 0x414
SendMessage, % vMsg, % vCount, % &TBBUTTON,,% "ahk_id " hTB ;  TB_ADDBUTTONSW / TB_ADDBUTTONSA ; TB_ADDBUTTONSW := 0x444
extension_set:
GLOBAL SYSGUI_TBbUTTSZ:= 56
	Toolbar_SetButtonSize(hTB,SYSGUI_TBbUTTSZ,SYSGUI_TBbUTTSZ) 
winset, style, -0x1,% "ahk_id " hTB

if Gui_extended {
	menu, tray, Check,%  "extended entries"
 	Gui_sysL_H := 1000
	Gui_sys_H  := 1050
} else {
	menu, tray, UnCheck,%  "extended entries"
	Gui_sysL_H := 865
	Gui_sys_H  := (GUISYS_TB_Y + SYSGUI_TBbUTTSZ)
}
	if GuiRolled {
					WINSET, STYLE, ^0X20000, AHK_ID %WINDLE%
					Gui_sys_W := 280
				}
				else, Gui_sys_W := GUISYS_LVW
				
gui_show_hooks:
gui, Gui_sYs: Show, W%Gui_sys_W% H%Gui_sys_H% %na% ;noactivate

if hTB
	;
	SendMessage, 0x421,,,, % "ahk_id " hTB ; TB_AUTOSIZE
OnMessage(   0x111, "WM_COMMAND")
OnMessage(   0x201, "WM_LBUTTONDOWN")
return,

WM_LBUTTONDOWN(wParam, lParam) 						{
	global xxx := lParam & 0xFFFF
	global yyy := lParam >> 16
    if A_GuiControl
		loop, parse, list_death, `,
			lv_modifycol(a_loopfield, select)
}

switch alignment {
	case "L":
		na:=" x5 y57 "
	case "C":
		na:="center" 
	case "R":
		na:=" x2632 y62 "
}

Gui_H := Gui_sys_H
gui, Gui_sYs: Show, W%Gui_W% H%Gui_H%  %na% ;noactivate
return
;ControlMove,, 0, -10, 0, 0, % "ahk_id " hTB

~^c::
tranny:
copy:
loop, parse, list_death, `,
	lv_modifycol(a_loopfield, select)
if (A_GuiEvent = "DoubleClick")  ; There are many other possible values the script can check.
{
    LV_GetText(s1, A_EventInfo, 1) ; Get the text of the first field.
    LV_GetText(s2, A_EventInfo, 2)  ; Get the text of the second field.
	
	MsgBox % s1 " " s2
    if ErrorLevel
        MsgBox Could not open "%FileDir%\%FileName%".
}
 
if winactive("ahk_id " Windle) {
	gui, Gui_sys:submit, NoHide
	CLIPBOARD =% COPY       ;not copying?
}
return,

extension_toggle:
extension_set:=!extension_set
goto, GoGoGadget_Gui 


~Escape::
if !(winactive("ahk_id " Windle))
	return,
	
guiclose:
	return,

Align_L:
alignment     := "L"
GuiLeftAlignX := ("x" . ( A_ScreenWidth * 0.3 ) - ( 0.5 * Gui_sys_W ) )
msgbox % GuiLeftAlignX
Gui,  Gui_sys: Show, noactivate w1006 %Gui_sys_H% x5 y57
menu, M_align, check  ,%  "Left"
menu, M_align, uncheck,%  "Center"
menu, M_align, uncheck,%  "Right"                       
return,

Align_C:
alignment := "C"
Gui,  Gui_sys: Show, noactivate w%Gui_sys_W% %Gui_sys_H% center
menu, M_align, check  ,%  "Center"
menu, M_align, uncheck,%  "Left"
menu, M_align, uncheck,%  "Right"   
return,

Align_R:
alignment := "R"
Gui,  Gui_sys: Show, NoActivate w%Gui_sys_W% %Gui_sys_H% x2632 y62
menu, M_align, Check  ,%  "Right"
menu, M_align, Uncheck,%  "Left"
menu, M_align, Uncheck,%  "Center"  
return,

MyMenuLabel:
tooltip poop
return

WM_COMMAND(wParam, lParam, uMsg, hWnd) {
	DetectHiddenWindows, On
	WinGetClass, vWinClass, % "ahk_id " lParam
	if (vWinClass = "ToolbarWindow32") {
		switch wParam                  { 
			case "0": 	;button number 0 based index
				GuiRolled:=!GuiRolled
				if GuiRolled {
					WINSET, STYLE, ^0X20000, AHK_ID %WINDLE%
					Gui_W := 280
					;Gui_h := 950
					
					LV_DeleteCol(2)		
					if   alignment = C
						 na:= "Center"
					else na:=""
					
					gui, Gui_sYs: Show, noactivate W%Gui_W% H%Gui_sys_h% %na%
				} else { 
					Gui_W := 900
					gui, Gui_sYs:hide
					;gui Gui_sYs:Destroy 
					settimer, GoGoGadget_Gui, -1
					exit 
				}
			case "1":
				Tooltip, Refreshing...
				settimer tooloff, -600
				settimer GoGoGadget_Gui,-1
			case "2":
				Tooltip, A shower of glass issues forth...
				settimer tooloff, -1300
				Loop, %vCount% {
					vTxt%A_Index% := "TB " A_Index
					vOffset := (A_Index-1)*vSize
					NumPut(A_Index-1,      TBBUTTON, vOffset,   "Int")                   ;iBitmap
					NumPut(A_Index-1,      TBBUTTON, vOffset+4, "Int")                   ;idCommand
					NumPut(0x0,            TBBUTTON, vOffset+8, "UChar")                 ;fsState	;TBSTATE_ENABLED := 4
					NumPut(&vTxt%A_Index%, TBBUTTON, vOffset+(A_PtrSize=8?24:16), "Ptr") ;iString
				;   NumPut(0x4,            TBBUTTON, vOffset+8, "UChar")                 ;fsState
		}		}
		sleep, 1500
		ToolTip
}	}

window_iconset_gui:
gui, window_iconset_gui:new, +hwndwindow_iconset_gui_hWnd,% ("Set Icon for " . new_PN)
gui, window_iconset_gui:
gui, window_iconset_gui:add, checkbox, vIProcName,% ("Process "   .   new_PN)
gui, window_iconset_gui:add, checkbox, vITitle,%    ("WindowTitle " . new_tt)
gui, window_iconset_gui:add, checkbox, vIClass,%    ("save Class " .  new_cl)
gui, window_iconset_gui:add, button, default gwindow_iconset_guiSubmit w80,% "Save (Enter)"
gui, window_iconset_gui:add, button, w80     gwindow_iconset_guiDestroy,%	 "Cancel (Esc)"
gui, show, center 
OnMessage(0x200, "Help")
return,

poop(gname, hGUI){
	global
}

stripchars(str2strip) {
	if instr(strpt, ";")
		return, 0
	strpt:=StrReplace(str2strip, ".exe")
	if instr(strpt, ":")
		strpt := StrReplace(strpt, ":" , "c0L")
	if instr(strpt, " ")
		strpt := StrReplace(strpt, " " , "_")
	if instr(strpt, "+")
		strpt := StrReplace(strpt, "+" , "Plus")
	if instr(strpt, ".")
		strpt := StrReplace(strpt, "." , "dot")
	if instr(strpt, "-")
		strpt := StrReplace(strpt, "-" , "dash")
	return,  strpt
}

TT_Off:
tooltip,
return,
	
ttp(TxT = "",Ti = "") {
	if dbgtt          {
		tooltip, % TxT,
		if !ti 
			  settimer, TT_Off, % ("-" . tt),
		else, settimer, TT_Off, % ("-" . ti),
}	}	

/*  ; Notes for popup: NP++; ahk_id 0x2e1120 PID: 8332; process name AutoHotkey.exe; Title Get Parameters; AHK_Class AutoHotkeyGUI; Style / ExStyle 0x940A0000 - 0x00000088; Control Edit1 C_hWnd: 0x130c78 ; Style / ExStyle 0x50010080 - 0x00000200
ID_TRAY_OPEN := 65300
ID_FILE_RELOADSCRIPT := 65400 ;ID_TRAY_RELOADSCRIPT := 65303
ID_FILE_EDITSCRIPT := 65401 ;ID_TRAY_EDITSCRIPT := 65304
ID_FILE_WINDOWSPY := 65402 ;ID_TRAY_WINDOWSPY := 65302
ID_FILE_PAUSE := 65403 ;ID_TRAY_PAUSE := 65306
ID_FILE_SUSPEND := 65404 ;ID_TRAY_SUSPEND := 65305
ID_FILE_EXIT := 65405 ;ID_TRAY_EXIT := 65307
ID_VIEW_LINES := 65406
ID_VIEW_VARIABLES := 65407
ID_VIEW_HOTKEYS := 65408
ID_VIEW_KEYHISTORY := 65409
ID_VIEW_REFRESH := 65410
ID_HELP_USERMANUAL := 65411 ;ID_TRAY_HELP := 65301
ID_HELP_WEBSITE := 65412		
*/

;Modify as necessary: 	Uncomment the appropriate line below or leave them all commented to reset to the default of the current build. 
;	codepage := 0        ; System default ANSI codepage
;	codepage := 65001    ; UTF-8
;	codepage := 1200     ; UTF-16
;	codepage := 1252     ; ANSI Latin 1; Western European (Windows)
;	if (codepage != "")
;		codepage := " /CP" . codepage
;	cmd="%A_AhkPath%"%codepage% "`%1" `%*
;	key=AutoHotkeyScript\Shell\Open\Command
;	if A_IsAdmin    ; Set for all users.
;		RegWrite, REG_SZ, HKCR, %key%,, %cmd%
;	else,            ; Set for current user only.
;	 RegWrite, REG_SZ, HKCU, Software\Classes\%key%,, %cmd%
;	;----;
	
; DllCall("kernel32.dll\SetProcessShutdownParameters", "Uint", 0x4FF, "Uint", 0)
; OnMessage(0x0011, "WM_QUERYENDSESSION")
; return,	; The above DllCall is optional: it tells the OS to shut down this script first (prior to all other applications).

; WM_QUERYENDSESSION(wParam, lParam){
    ; ENDSESSION_LOGOFF := 0x80000000
    ; if (lParam & ENDSESSION_LOGOFF)  ; User is logging off.
        ; EventType := "Logoff"
    ; else,  ; System is either shutting down or restarting.
        ; EventType := "Shutdown"
    ; try { ; Set a prompt for the OS shutdown UI to display.  We do not display        ; our own confirmation prompt because we have only 5 seconds before        ; the OS displays the shutdown UI anyway.  Also, a program without        ; a visible window cannot block shutdown without providing a reason.
        ; BlockShutdown("Example script attempting to prevent " EventType ".")
        ; return, false
    ; }    catch    {
        ; MsgBox, 4,, %EventType% in progress.  Allow it?; ShutdownBlockReasonCreate is not available, so this is probably
        ; IfMsgBox Yes        ; Windows XP, 2003 or 2000, where we can actually prevent shutdown.

            ; return, true  ; Tell the OS to allow the shutdown/logoff to continue.
        ; else
            ; return, false  ; Tell the OS to abort the shutdown/logoff.
; }   }

; BlockShutdown(Reason) { ; If your script has a visible gui, use it instead of A_ScriptHwnd.
    ; DllCall("ShutdownBlockReasonCreate", "ptr", A_ScriptHwnd, "wstr", Reason)
    ; OnExit("StopBlockingShutdown")
; }
; StopBlockingShutdown(){
    ; OnExit(A_ThisFunc, 0)
    ; DllCall("ShutdownBlockReasonDestroy", "ptr", A_ScriptHwnd)
; }
