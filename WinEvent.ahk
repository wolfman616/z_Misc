#Singleinstance,      Force
;ListLines,           Off 
coordMode,  tooltip,  Screen	
coordmode,  mouse,    screen
DetectHiddenWindows,  On
DetectHiddenText,     On
SetTitleMatchMode,    2	;	
SetTitleMatchMode,    Slow
setWorkingDir,        %A_ScriptDir%
SetBatchLines,        -1
SetWinDelay,          -1
#Persistent
#NoEnv 

gui, DGuI:new, +owner
gui, DGui:-Caption -DPIScale -SysMenu +ToolWindow +owndialogs
global ProcJIZM_ := RegisterCallback("jizzyfuckstart", "")

PreLabL: ; ===>" binds " below line 500
gosub, init_matt
return,

Main: ; sript & hooks initiated 
dbgtt := True
wm_allow()

; Time_Idle := A_TimeIdlePhysical	;	total time to screensaver = 420
; if Time_Idle < 440
	; settimer, timer_idletime,% ("-" . (430 - A_TimeIdlePhysical))
	settimer jizz, -1
return,

	;gui, +HWNDhgui +AlwaysOnTop
	;DllCall("GetWindowBand", "ptr", hgui, "uint*", band)
	;gui, Destroy
	;hgui := ""	
	
timer_idletime: 		; testing
ttp("timer complete.")
return
;EVENT_OBJECT_SELECTIONREMOVE:=0x8008 ; UNDO SELECTION MISTAKES
;MENUHOOKS:
;EVENT_SYSTEM_MENUPOPUPEND:=0x0007
;EVENT_SYSTEM_MENUPOPUPSTART:=0x0006
;EVENT_SYSTEM_MENUEND:=0x0005
;EVENT_SYSTEM_MENUSTART:=0x0004

#F::
initt := DllCall("SetWinEventHook", "Uint", winevents["MENUPOPUPSTART"], "Uint",winevents["MENUPOPUPSTART"], "Ptr", 0, "Ptr", ProcJIZM_ ,"Uint", 0, "Uint", 0, "Uint", 0x0000 | 0x0002)
return

#z::
Hookmps :=  DllCall("SetWinEventHook", "Uint", winevents["MENUPOPUPEND"], "Uint",winevents["MENUPOPUPEND"], "Ptr", 0, "Ptr", (ProcJIZM_ := RegisterCallback("jizzyfuckstart", "")),"Uint", 0, "Uint", 0, "Uint", 0x0000| 0x0002)
return

jizzyfuckstart(ProcJIZM_, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
global
	;static initt := DllCall("SetWinEventHook", "Uint", 0x0006, "Uint",0x0006, "Ptr", 0, "Ptr",  ,"Uint", 0, "Uint", 0, "Uint", 0x0000 | 0x0002)
	;static ProcJIZM_ := RegisterCallback("jizzyfuckstart", "")
	i:=Format("{:#x}", event) 
	for, index, element in winevents
		if element = %i%
			evt := Index
	ttp(( "Event: " evt "`nhandle: " hWnd "`nOBJ: " idObject ), "3000")
}

OnObjectCreated(HookCr, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	CRITICAL
	wingetClass, Class,% (hwand := "ahk_id " . Format("{:#x}", hWnd)) ;if( Title_last = "Folder In Use" ) {;;asas := ; "AHK_Class WindowsForms10.Window.8.app.0.141b42a_r6_ad1"
	wingettitle, Title_last,% hwand ;;winget, hwnd2, ID , %asas%;;if asas;
	switch       Class {			 ; winclose ahk_id %hwnd2%;;}
		case     "OperationStatusWindow": 		
			if (Title_last = "Replace or Skip Files") || (Title_last = "Confirm Folder Replace") || (Title_last = "Folder In Use") {
				msgbox,% " test 5 ",,,4
				DEBUGTEST_FOC := True
				DEBUGTEST_HWND    := wineXist("A")
				winset, exStyle, +0x08000080,% hwand ;worx but dont
				winset, Style,   +0x80000000,% hwand ;worx but dont
				win_move((oioi:=Format("{:#x}"), hWnd), 3000, 900, "", "", "")
				tooltip,% "Preparing...",,,4 ; go_off_n_test_FOCUS(ActiveNow:=DEBUGTEST_HWND); 
				msgbox,%  ("old1" old_focus1 "`nold2" old_focus2 "`nold3" old_focus3 "`nol4g1" old4gnd1 "`nol4g2" old4gnd2 "`nol4g3" old4gnd3) ;go_off_n_test_FOCUS:; ;wingetTitle, 
				winactivate,% ("ahk_id " . old_focus1)Title_last ,% hwand ; WinGetActiveStats, Title, Width, Height, X, Y
				settimer, tooloff, -128
				return,
			}
		case "MozillaDialogClass":
			winget, Style, Style,% hwand
			winget, exStyle, exStyle,% hwand
			If ((STYLE = 0x16CE0084) && (EXSTYLE = 0x00000101))
				winset, Style,0x16860084,% hwand
		case "NotifyIconOverflowWindow","DropDown","TaskListThumbnailWnd","Net UI Tool Window Layered":
			winset, ExStyle, ^0x00000100,% hwand
			winset, Style,    0x94000000,% hwand
		case "MMCMainFrame":
			1998 := hwand
			settimer, 1998, -700
			return,
		case "TaskListThumbnailWnd":	
			SetAcrylicGlassEffect(hWnd)
		case "CabinetWClass":
			1999 := hwand
			settimer, 1999, -700
			return,
		case "RegEdit_RegEdit","FM":
			ControlGet, ctrlhand, Hwnd,, SysListView321,% hwand
			SendMessage 0x1036, 0, 0x00000020,, ahk_id %ctrlhand% 	 ; enable row select (vs single cell) 	LVM_SETEXTENDEDLISTVIEWSTYLE := 0x1036
			ControlGet, ctrlhand2, Hwnd,, SysTreeView321,% hwand
			winset, Style, +0x00000200, ahk_id %ctrlhand2%
		case "7 Sidebar":
			winget, Time_hWnd, iD, ahk_class 7 Sidebar
			winset, ExStyle, 0x000800A8,%  "HUD Time",% "ahk_id " Time_hWnd:=Format("{:#x}",Time_hWnd)
			winset, ExStyle, 0x000800A8,%  "Moon Phase II"
			sidebar := True
			return,
		case "ApplicationFrameWindow","Chrome_WidgetWin_1","WINDOWSCLIENT":	
			if (Title_Last="Roblox") {
				p ="C:\Program Files\AHK\AutoHotkeyU32_UIA.exe" "C:\Script\AHK\Roblox_Rapid.ahk"
				result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
				settimer, RobloxGetHandle, -2000
				run,% p	;run "%AF%"			;run "C:\Program Files\AHK\AutoHotkeyU32_UIA.exe" "%AF%"
				
		sbardisabletoggle() 

				if (m2dstatus != "not running or paused"	) && (m2dstatus !=False)     {
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
					}
					return
			}	}
		case "MsiDialogCloseClass":
			if id := winexist("ahk_class MsiDialogCloseClass") {
				txt  :=  "dialog",   c_ntrolName  :=  "Static1"
			}
			if (mainc_nt = Format("{:#x}", (WinExist("ahk_exe msiexec.exe",txt)))) {
				ControlGet, c_ntHandle, hWnd ,,%c_ntrolName% , ahk_id %mainc_nt%
				StyleMenu_Showindow( c_ntHandle, !IsWindowVisible( c_ntHandle))
				tooltip,% ("ProcdEvent: " . MsiDialogCloseClass . "`n" . id " yes..." . mainc_nt . " main " . hwnd . "`n" . c_ntHandle)
			}
	; !!case "SysShadow": ; { ; if !DWMBLUR ; winset, transparent , 1, ahk_id %hwnd% ; return, ; }
		case "WindowsForms10.Window.8.app.0.141b42a_r9_ad1": ; Multi game instance (ROBLOX)
			StyleMenu_Showindow(hWnd, !IsWindowVisible(hWnd))
			winset, Style, 0x80000000,% hndDS
		case "#32770":
			if (Title_last = "Information") {
				winactivate, ahk_class #32770
				
				send, N
				return,
			}
			if ( (Title_last = "Open") || (Title_last = "Save As") || (Title_last = "Save File As ...") || (Title_last = "Save Image") || (Title_last = "Enter name of file to save to...") ) {
				nnd := Format("{:#x}", hwnd) ; return proper hex
				gosub, 32770Fix
				return,
			}
			winget PName, ProcessName,% hwand
			if (PName = "notepad++.exe")       {
				winget, currentstyle, Style,% hwand
				if (currentstyle = 0x94CC004C) {
					sleep, 580
					winset, Style, -0x00400000,% hwand
			}	}
			 else, if (PName = "explorer.exe") { ; wingetTitle, Title_last, ahk_id %hWnd%
				if (Title_last = "Folder In Use")   {
					WinGetText, testes,% hwand
					traytip,% "bctfe",% "6161 Folder in use mB0cks'tected`n" testes	
					; asas := "AHK_Class WindowsForms10.Window.8.app.0.141b42a_r6_ad1" ; winget, hwnd2, ID , %asas% ; if asas { ;not working and not good ; winclose ahk_id %hwnd2% ; winactivate, ahk_id %fuk% ; sleep, 20 ; send {left} ; send {enter} ; return, ;	}
			}	}				
		case "Notepad++":
			if !np {
				 sem := "Notepad++ Insert AHK Parameters.ahk - AutoHotkey"
				 if !WinExist(sem) 
					run "C:\Script\AHK\- Script\Notepad++ Insert AHK Parameters.ahk",,hide
				np := True
			}
	;	case "MozillaDropShadowWindowClass": ; copied from regular menus and no joy
	;	{ 		
	;		winset, transparent , 230,% hwand
	;		winset, ExStyle, 0x00000181,% hwand
	;		winset, Style, 0x84800000,% hwand	
	;		SetAcrylicGlassEffect(hWnd) 
	;		return,
	;	} 
	 	case "Autohotkey":
			ccc := "C:\Script\AHK\adminhotkeys.ahk"
			if CCC in %Title_last%
			{
				menu, tray, check, Launch AdminHotkeyz,
				tooltip  %Title_last% detected admin hotkey connecting
			}
		default: 
			if (IsWindow(hWnd))            {
				winget Style, Style,% hwand
				if (Style & 0x10000000)    {
					if !Tool || if Tool=20
						Tool := 1
					else,
						Tool := tool + 1
					offset:= offsett 
					if !EventLogBuffer_Old {
						EventLogBuffer_Old=%class%`n
					} else,                {
						clist=%EventLogBuffer_Old%%class%`n
						EventLogBuffer_Old = % CLIST
					}		;		tooltip, %tool% %clist%, %toolx%, %tooly%
					tooly = % offset	
					classname=%Class%`n
					settimer, EventLogBuffer_Push, -4000
			}	}
			return,
		return, 		;	 	end case	
	}	
	
	winget PName, ProcessName,% hwand ;logvar := (logvar . "`r`n" . ( PName . "e" . Class . "e" . Title_last ))
	if TTcr
		ttp(("OBJ_CREATE EVENT: " PName "`nTitle: " Title_last "`nAHK_Class: " Class "`nAHK_ID: " hWnd4))
	StyleDetect(hWnd, Style_ClassnameList2,	Class,      Array_LClass) 
	StyleDetect(hWnd, Style_wintitleList2,  Title_last, Array_LTitle) 
	StyleDetect(hWnd, Style_procnameList2,	PName,      Array_LProc) 
	
	switch pname {
		;ase "RzSynapse.exe":
			;settimer RZ_LOG, -1
		case "GoogleDriveFS.exe":
			msgbox,% (Title_last . " titlelast!")
	}
	
	switch, Title_last {
		case "Razer Synapse Account Login":
			settimer RZ_LOG, -1
		case "Google Drive Sharing Dialog":
			msgbox, gfs
	}

	EventLogBuffer_Push:
		If !EventLogBuffer
			EventLogBuffer = % EventLogBuffer_Old
		else
			EventLogBuffer=%EventLogBuffer%`n%EventLogBuffer_Old%
		EventLogBuffer_Old:="", clist:="", offset:="", tool:=""
		return,
}

On4ground(hook4g, event, hWnd4, idObject, idChild, dwEventThread, dwmsEventTime) {
old4gnd3 := old4gnd2
old4gnd2 := old4gnd1
old4gnd1 := hWnd4
CRITICAL

	if (DEBUGTEST_FOC && (hWnd4 != DEBUGTEST_HWND)) {
		msgbox,% ("focus lost " . DEBUGTEST_HWND)	;ttp(("focus lost " . DEBUGTEST_HWND))
		DEBUGTEST_HWND := ""
		DEBUGTEST_FOC := False
	}
	4gnd_hwnd =% "ahk_id " hWnd4
	wingetClass, Class,% 4gnd_hwnd
	wingettitle, Title_last, 4gnd_hwnd	
	winget,      PName, ProcessName,% 4gnd_hwnd
	if TT4g
		tooltip, 4Ground EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd4%
	switch Class {
		case "#32770":	; msg box 
			wingettitle, Title_last,% 4gnd_hwnd	
			if (Title_last = "Roblox Crash")  {
				if !crashmb
					crashmb := 1
				else, crashmb := crashmb + 1
				winget, RobloxCrash_PID, PID ,% 4gnd_hwnd
				Roblox_PID=TASKKILL.exe /PID %RobloxCrash_PID%
				run %comspec% /C %Roblox_PID%,, hide
				if winexist("ahk_exe robloxplayerbeta.exe") 
					run C:\Apps\Kill.exe robloxplayerbeta.exe,, hide	; 	run C:\Apps\Kill.exe Multiple_ROBLOX.exe,, hide
				if winexist("ahk_pid %Roblox_PID%")
					msgbox,% "Error",% A_lasterror
					if SBAR_disable
						sbardisabletoggle() 
			} else
			
			if (Title_last = "Information")   {
				;MessageBoxKill(hWnd4)
				WinActivate, ahk_class #32770
				send n
				settimer, tooloff, -10000
			}
			return,
		case "ApplicationFrameWindow","Chrome_WidgetWin_1","WINDOWSCLIENT":
			ttt := "M2Drag.ahk - AutoHotkey", result := Send_WM_COPYDATA("status",ttt)
			wingettitle, Title_last,% 4gnd_hwnd	
			;if (Title_last != "Roblox")
			;	TOOLTIP
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
			return,
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
		case "Razer Synapse Account Login":
			settimer RZ_LOG, -1
	;case "Google Drive Sharing Dialog":;msgbox
	}
return,	
}

OnFocus(HookFc, event, BK_UN_T, idObject, idChild, dwEventThread, dwmsEventTime) {
old_focus3 := old_focus2
old_focus2 := old_focus1
old_focus1 := hWnd4
CRITICAL
	if (DEBUGTEST_FOC && (hWnd4 != DEBUGTEST_HWND)) {
		msgbox,% ("focus lost " . DEBUGTEST_HWND)	;ttp(("focus lost " . DEBUGTEST_HWND))
		DEBUGTEST_HWND := ""
		DEBUGTEST_FOC := False
	}
	hnd_ := ("ahk_id " . BK_UN_T)
	wingetClass, Class,% hnd_
	winget PName, ProcessName,% hnd_
	wingettitle, Title_last,% hnd_	

	if TTFoc
		tooltip,% ("FOCUS EVENT:`n" PName "`n" Title_last "`nAHK_Class " Class "`nAHK_ID " BK_UN_T)
	switch pname {
		case "RzSynapse.exe":
			settimer RZ_LOG, -1
		case "GoogleDriveFS.exe":
			if !triggeredGFS {
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
	case "WTouch_Message_Window":
	msgbox jdjdjj
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
		case "MozillaDialogClass":
			Escape_TargetWin = ahk_id %Youtube_Popoutwin%
			winget, Style, Style,% hnd_
			winget, exStyle, exStyle,% hnd_
			IF((STYLE = 0x16CE0084) && (EXSTYLE = 0x00000101) ) {
				Youtube_Popoutwin := BK_UN_T
				winclose,
				wingetPos, X, Y, , EdtH,% hnd_
				WinMove,% hnd_,, , , , (EdtH - 39)
				winset, Style, 0x16860084,% hnd_	
				MSGBOX,% (Youtube_Popoutwin . "`nAhk_id: " . BK_UN_T)
			}
		case "#32770":		
			if (Title_last = "Information") {
				tooltip, c_nt
					send,% N
					return,
}	}		} ; case "CabinetWClass":;{ ;winset, transparent, 130,% hnd_;msgbox;}

;MenPopStart(HookMps, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
;tooltip $ hWnd 

;}
OnMsgBox(HookMb, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
CRITICAL
	wingetTitle, Title_last,% (h_Wd := ("ahk_id " . Format("{:#x}",hWnd)))	
	if TTmb {
		wingetClass Class,% h_Wd
		winget PName, ProcessName,% h_Wd
		tooltip MSGBOX EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd%
	}
	If (Title_last = "Information") {
		MSG_WIN_TARGET := "Information"
		wingetActiveTitle, Z_Title 
		if (Z_Title = MSG_WIN_TARGET) {
			sleep, 250
			winactivate
			sleep, 200
			Send, N
		}
		return,
	}
	If WinExist("Reminder") { 
		MSG_WIN_TARGET=Reminder
		WIN_TARGET_DESC=%MSG_WIN_TARGET%
		MessageBoxKill(hwnd)
	}
	If (DeadManHandle :=WinExist("Roblox Crash")) { 
		MSG_WIN_TARGET=Roblox Crash
		WIN_TARGET_DESC=%MSG_WIN_TARGET%
		;MessageBoxKill(MSG_WIN_TARGET)
		if !crashmb 
			crashmb = 1
		else, crashmb := crashmb + 1
		TestMbkill(DeadManHandle)
	}
	If WinExist(KILLSWITCH) {
		tooltip, Shutting Down Scripts, (A_ScreenWidth*0.5), (A_ScreenHeight*0.5)
		settimer, m2_Status_Req33, -2800
		return,
		m2_Status_Req33:
		Exitapp
	}
	wingettitle, TitleR,% h_Wd ; tooltip % Title_Last " " hwnd " " class
	switch TitleR {
		case "Roblox Crash": ; run C:\Apps\Kill.exe Multiple_ROBLOX.exe,, hide
			run C:\Apps\Kill.exe RobloxPlayerBeta.exe,, hide
			tooltip, Roblox Crash Detected: `nClosing All related scripts, A_ScreenWidth*0.5, A_ScreenHeight*0.5
			settimer, tooloff, -3000
			if !crashmb 
				crashmb = 1
			else, crashmb := crashmb + 1
				settimer, m2_Status_Req34, -1000
				return,
				m2_Status_Req34:
			settimer, SBAR_Restore, -1
			M2STATUS_Start:
				settimer, m2_Status_Req35, -2800
				return,
				m2_Status_Req35:
			Roblox := False, Result := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle)
			if (result = "FAIL")
				Display_Msg("SendMessage failed.", "1000", "True")
			sleep, 500
			Result := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle2)
			if ( result = "FAIL")
				Display_Msg("SendMessage failed.", "1000", "True")
			else, if (result = 0)
				Display_Msg("Roblox Exiting: Scripts Closing", "1000", "True")
			if winexist("ahk_exe sidebar.exe") 
				SBAR_2berestored_True := False, Sidebar := True
			else, {
				tooltip, Sidebar Not Loading, (A_ScreenWidth * 0.5), (A_ScreenHeight * 0.5)
				settimer, tooloff, -3000
				goto M2STATUS_Start
			}
			return,
		case "Roblox Game Client":
			winget, RobloxCrashP, PID,% h_Wd
			RobloxCR_PID=TASKKILL.exe /PID %RobloxCrashP%
			run %comspec% /C %RobloxCR_PID%,, hide
}	}

OnObjectDestroyed(HookOD, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
CRITICAL
	wingetClass, Class, (hndDS := ("ahk_id " . Format("{:#x}"mhWnd))) 	
	wingettitle, Title_last,% hndDS	
	winget PName, ProcessName,% hndDS	
	if TTds
		tooltip OBJ_DESTROY EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hndDS%
	if pname contains AutoHotkey 
	&& IsWindowVisible( hWnd)
		settimer, quotE, -1
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
; end of hooks  <<<--------------------------------------- 
return, 
; binds 		<<<---------------------------------------
~^s::	 ; 		Capture Save hotkey Ctrl-S
wingetActiveTitle, A_Title 
if winactive("ahk_exe notepad++.exe") 				{ 
	if instr(A_Title, ".ahk") 						{   
		if instr(A_Title, "*")						{   	
			A_Title := StrReplace(A_Title, "*" , "") 	; *ASTERISK denotes unsaved doc in np++ WinTitle
			SplitPath, A_Title, tName, npDir, npExtension, npNameNoExt, npDrive 
			ser := npNameNoExt . ".ahk - AutoHotkey"
			TargetScriptName := (npNameNoExt . ".ahk"	)
			if (WinExist(ser)) or if (npNameNoExt = "WinEvent") {
				MsgBox, 4129,%ser% dtect`NnReload AHK Script, Reload %TargetScriptName% now?`nTimeout in 6 Secs, 7
				; IfMsgBox Timeout
					; ttp("cuntface")
				ifmsgbox OK					
					if npNameNoExt = WinEvent		
{					
						reload
						exit 
						}
					traytip, %TargetScriptName%, reloading, 2, 32
					postMessage, 0x0111, 65303,,, %TargetScriptName% - AutoHotkey		; Reload WMsg 
}	}	}	}	
return, 

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
;#z::
;Hookmps :=  DllCall("SetWinEventHook", "Uint", winevents["MENUPOPUPEND"], "Uint",winevents["MENUPOPUPEND"], "Ptr", 0, "Ptr", (ProcCr_ := RegisterCallback("jizzyfuckstart", "")),"Uint", 0, "Uint", 0, "Uint", 0x0000| 0x0002)

gosub, quotE
return,
; ~Escape:: 				; 	see AdminHotkeys as this should be migrated
; IF Youtube_Popoutwin { 	;	Youtube_Popoutwin (a bad addin)
	; Escape_TargetWin = %Youtube_Popoutwin%
	; if winactive(Escape_TargetWin) {
		; winclose,
		; traytip,% "escapetarget dispatched",% Escape_TargetWin
; }	}   ; return,
;guiclose:
~esc::
settimer jizz, -1
return,

jizz:
;ttp("cuntjsjfkjs")
gui, ttt: hide
Gui, eventgui: hide
return,
	;	<------------< [ End of Script ] <------------------<
	;	>------------> [ Begin ... Functions ] >------------>
AtExit() {
	if (hgui != "")
		DllCall("magnification.dll\MagUninitialize")
	splitpath a_ScriptFullPath,,,, OutNameNoExt
	pap := "`n", Script_Title=%OutNameNoExt%.txt
	if !fileexist(Script_Title)
		pap := ""
	fileAppend,% ("`n" . EventLogBuffer . ", " . Script_Title)
	
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
	;msgbox % copyofdata
	if CopyOfData contains Þ ;
	{ 	
		if !FileListStr {
			FileListStr := CopyOfData, FileCount := 1
		} else, {
			FileListStr := (FileListStr . CopyOfData), FileCount := (FileCount + 1) ; FileListStr := FileListStr . "`n" . CopyOfData
		}
		FileListStrGen(Delimiter:="Þ") 
	}
	else, if (CopyOfData = "RobloxFalse")
	{
		roblox := False
		Result := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle2)
		Result1 := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle),
		msgbox, aaa, aaa
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
	if !oldlist
		oldlist := FileListStr
	else
		oldlist := FileListStr
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

Display_Msg(Text, Display_Msg_Time, X_X) {
	wingetpos, WindowX, WindowY, w_TxT, H_TxT, Roblox
	DMT := Display_Msg_Time, StartTime := A_TickCount, X_X := ""
	X_Mid := ((WindowX + (w_TxT/2)) - 45), Y_Mid := ( ( WindowY + (H_TxT*0.5 )) - 20 )
	X_TxT := ( x + 100 ), Y_TxT := ( y + 100 )
	splashimage,,b 0000EFFF ct00EFFF x%X_Mid% y%Y_Mid%,,%text%,MouseTextID
	winset,transcolor,00000000 254,MouseTextID
	mouseGetPos,x,y
	X_TxT:=X_Mid, Y_TxT := Y_Mid
	winMove,%MouseTextID%,,%X_TxT%,%Y_TxT%
	settimer, Elapsed_Timer, 180
	return,

	Elapsed_Timer:
	Time_Elapsed := A_TickCount - StartTime
	if (Time_Elapsed > DMT) {	
		winClose MouseTextID
		X_X := False
		settimer, Elapsed_Timer, off
		winClose MouseTextID
		X_X := True
}	}

Hooks:
OnExit("AtExit")
OnMessage(0x4a, "Receive_WM_COPYDATA")
hook4g  :=  DllCall("SetWinEventHook", "Uint", OBJ4g, "Uint", OBJ4g, "Ptr", 0, "Ptr", (Proc4g_ := RegisterCallback("On4ground", "")),"Uint", 0, "Uint", 0, "Uint", OoC | SkpO)
HookFc  :=  DllCall("SetWinEventHook", "Uint", OBJFc, "Uint", OBJFc, "Ptr", 0, "Ptr", (procFc_ := RegisterCallback("OnFocus", "")),  "Uint", 0, "Uint", 0, "Uint", OoC | SkpO)
HookMb  :=  DllCall("SetWinEventHook", "Uint", 0x0010,"Uint", 0x0010,"Ptr", 0, "Ptr", (ProcMb_ := RegisterCallback("OnMsgBox", "")), "Uint", 0, "Uint", 0, "Uint", OoC | SkpO)
HookCr  :=  DllCall("SetWinEventHook", "Uint", OBJCR, "Uint", OBJCR, "Ptr", 0, "Ptr", (ProcCr_ := RegisterCallback("OnObjectCreated", "")),  "Uint", 0, "Uint", 0, "Uint", OoC| SkpO) 
HookOD  :=  DllCall("SetWinEventHook", "Uint", OBJDS, "Uint", OBJDS, "Ptr", 0, "Ptr", (ProcOD_ := RegisterCallback("OnObjectDestroyed", "")),"Uint", 0, "Uint", 0, "Uint", OoC| SkpO)
;Hookmps :=  DllCall("SetWinEventHook", "Uint", MNPPS, "Uint", MNPPS, "Ptr", 0, "Ptr", (ProcCr_ := RegisterCallback("jizzyfuckstart", "")),"Uint", 0, "Uint", 0, "Uint", OoC| SkpO)
return,     

FileListStrGen2:
if (oldlist = FileListStr) {
	Loop, parse, FileListStr,% "ø",
	{
		If A_Index = 1
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

invert_win(hw)                  { ; not working atm
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

Uninitialize:
if (hgui != "")
	DllCall("magnification.dll\MagUninitialize")
exitapp

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

runlabel(VarString, hide="")	   { 
	static hidestatic := "Hide"
	if hide            ;           "Mag_CleanME_PLZz\/DWMFixS\/PConfig\/WMPRun" etc
		hid := hidestatic
	if (InStr(VarString, "\/"))    {
		loop, parse, VarString, "\/",
		{
			run,% VarString,,% hid
			if errorlevel
				return, 0
		}
				return, 1
	} else, 					       {
		run,% VarString,,% hid
		if !errorlevel
			 return, 1
		else, return, 0
}	}
toggle_m2drag_bypass:
ttt := "M2Drag.ahk - AutoHotkey", result := Send_WM_COPYDATA("Bypass_Last_Dragged_GUI",ttt)
return,

MiDiRun:
run % MiDiRun
return, 
;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
;next on the menu to refine
toggle_sysmenu:
winset, Style, 		^0x00080000, 	ahk_id %OutputVarWin%
goto ResetMenu
toggle_DLGFRAME:
winset, Style, 		^0x00400000, 	ahk_id %OutputVarWin% 
goto ResetMenu
toggle_thickframe:
winset, Style, 		^0x00040000, 	ahk_id %OutputVarWin% 
goto ResetMenu
toggle_modalframe:
winset, ExStyle, 	^0x00000001, 	ahk_id %OutputVarWin% 
goto ResetMenu
toggle_border:
winset, Style, 		^0x00040000, 	ahk_id %OutputVarWin% 
goto ResetMenu
toggle_raisededge:
winset, ExStyle, 	^0x00000100, 	ahk_id %OutputVarWin%
goto ResetMenu
toggle_sunkenedge:
winset, ExStyle, 	^0x00000100, 	ahk_id %OutputVarWin%
goto ResetMenu
toggle_staticedge:
winset, ExStyle, 	^0x00020000, 	ahk_id %OutputVarWin%
goto ResetMenu
toggle_3dedge:
winset, ExStyle, 	^0x00020000, 	ahk_id %OutputVarWin%
goto ResetMenu
toggle_MinBox:
winset, Style, 		^0x00020000, 	ahk_id %OutputVarWin% 
goto ResetMenu
toggle_Maxbox:
winset, Style, 		^0x00010000, 	ahk_id %OutputVarWin% 
goto ResetMenu
toggle_hscroll:
winset, Style, 		^0x00100000, 	ahk_id %OutputVarWin% 
goto ResetMenu
toggle_vscroll:
winset, Style, 		^0x00200000, 	ahk_id %OutputVarWin% 
goto ResetMenu
toggle_LeftScroll:
winset, ExStyle, 	^0x00004000, 	ahk_id %OutputVarWin% 
goto ResetMenu
toggle_Clickthru:
winset, ExStyle, 	^0x00000020, 	ahk_id %OutputVarWin% 
goto ResetMenu
toggle_RightAlign:
winset, ExStyle, 	^0x00001000, 	ahk_id %OutputVarWin% 
goto ResetMenu
toggle_RightoLeft:
winset, ExStyle, 	^0x00002000, 	ahk_id %OutputVarWin% 
goto ResetMenu
toggle_AppWindow:
winset, ExStyle, 	^0x00040000, 	ahk_id %OutputVarWin% 
goto ResetMenu

SAVEGUI:
id := ("ahk_id " OutputVarWin)
winget savenew_PNm, ProcessName,% "ahk_id " OutputVarWin
wingetTitle save_new_Title,% "ahk_id " OutputVarWin
wingetClass save_new_Class,% "ahk_id " OutputVarWin
winget, Style, Style,% "ahk_id " OutputVarWin
winget, ExStyle, ExStyle,% "ahk_id " OutputVarWin
if !Style or !ExStyle
	msgbox,% ("error " . A_lasterror)
gui, SaveGuI:new , , SAVE WINDOW STYLES
gui +hwndSaveGuI_hWnd
gui, SaveGuI:add, checkbox, vTProcName ,	Process %savenew_PNm%
gui, SaveGuI:add, checkbox, vTTitle ,		WindowTitle %save_new_Title%
gui, SaveGuI:add, checkbox, vTClass ,		save Class %save_new_Class%
gui, SaveGuI:add, button, default gSaveGUISubmit w80, Save (Enter)
gui, SaveGuI:add, button, w80 gSaveGUIDestroy, 	Cancel (Esc)
gui, show, center, SAVE WINDOW STYLES
OnMessage(0x200, "Help")
return,

SaveGUISubmit: 	
gui, SaveGuI:Submit
return,

PushNewSave: 	
if TProcName  ;  regKey contains unique combo of info picked by user as a search key allowing for combinations of classnamed title and procname. Should be enough
	regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\procname, 	% Style . "»" . exStyle . "»" . "µ" . savenew_PNm . "µ" . save_new_Title . "µ" . save_new_Class,% savenew_PNm
if TTitle
	regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\wintitle, 	% Style . "»" . exStyle . "»" . "µ" . savenew_PNm . "µ" . save_new_Title . "µ" . save_new_Class,% save_new_Title
if TClass
	regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\classname, 	% Style . "»" . exStyle . "»" . "µ" . savenew_PNm . "µ" . save_new_Title . "µ" . save_new_Class,% save_new_Class
return,

SaveGUIDestroy:
gui, SaveGuI:destroy
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
		send ^{a}
		send %Log1_RZ%	
		send {tab}
		send ^{a}
		send %Pa5s_RZ%
		PixelGetColor, color, 219, 326
		if color != 0x02DD02
			msgbox,% "default snot saved"
		else, send {enter}
}	}	
CoordMode,% coord_old
return,
;------------==========================++++++++++++++++++++*+*+*+*
;~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~
;------------==========================++++++++++++++++++++*+*+*+*
RegReads: ; -=-==-=====-= REG READZZZZ =-=-=----==--@~@'''~~--__
AhkPath := ErrorLevel ? "" : AHKdir "\AutoHotkey.exe"
RegRead, Log1RZ, HKEY_CURRENT_USER\Software\_Mouse2Drag\Login , rz
if Log1RZ {
	loop, parse, Log1RZ, `,
	{
		if (A_index = "1")
			Log1_RZ := A_LoopField
		if (A_index = "2")
			Pa5s_RZ := A_LoopField
}	}
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
	sp 	:= 	(" " .  sp . sp)
KV_    :=  ( "`n" . sp . "Kurt Vonnegut" . q_dlim )
BJB_ 	:=  ( "`n" . sp . "Buju Banton" .   q_dlim ), sp := ""
qstr := (" ""And I urge you to please notice when you are happy,`nand exclaim or murmur or think at some point,`n 'If this isn't nice, I don't know what is.'"" " . KV_ .	" ""Everything was beautiful and nothing hurt."" " . KV_ .	" ""Those who believe in telekinesis, Please raise my hand."" " . KV_ . " ""We are what we pretend to be, so we must be careful about what we pretend to be."" " . KV_ .	" ""I tell you, we are here on Earth to fart around, and don't let anybody tell you different."" " . KV_ . " ""Tiger got to hunt,bird got to fly,`nMan got to sit and wonder 'why, why, why?'"" " . KV_ " ""Tiger got to sleep, bird got to land,`nMan got to tell himself he understand."" " . KV_ . " ""While elephants play the grass gets trampled."" " . BJB_ )

loop, parse, qstr,% q_dlim, 
quote_MAX_INDEX := A_index ;working
return,
quotE:
randOm, rNd, 1, quote_MAX_INDEX				; quote_MAX_INDEX working
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
Nnn  := Gdip_Startup()
dcC  := GetDC(nnd)
mDC := Gdi_CreateCompatibleDC(0)
mBM := Gdi_CreateDIBSection(mDC, 1, 1, 32) 
oBM := Gdi_SelectObject(mDC, mBM)
a:=DllCall("gdi32.dll\SetStretchBltMode", "Uint", dcC, "Int", 5)
b:=DllCall("gdi32.dll\StretchBlt", "Uint", dcC, "Int", 0, "Int", 0, "Int", desk_wi, "Int", desk_hi, "Uint", mdc, "Uint", 0, "Uint", 0, "Int", 1, "Int", 1, "Uint", "0x00CC0020")
Gdip_ShutdownI(Nnn)
if a = 0 || b = 0
	goto gdipfix_start
}
return,

LAbeL_Ladder: ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>
AdHkRun:      ; menu, tray, check,% "Launch " A_ThisLabel ; swap wih a dictionary for titles ;
mattdwmrun2:  ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>
test_move:    ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()
Mag_:         ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()
MiDi_:        ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>()[]()<>()[
CleanME_PLZz: ; []()<>()[]()<>()[]()<>()[]()<>()[]()<>()[
DWMFixS:      ; []()<>()[]()<>()[]()<>()[]()<>()[]()
PConfig:      ; []()<>()[]()<>()[]()<>()[]()<>()  
WMPRun:       ; []()<>()[]()<>()[]()<>()[]()<
M2dRun:       ; []()<>()[]()<>()[]()<>()[]
YT_DL:        ; []()<>()[]()<>()[]()<>()
											
LABElA(( Your_Label_Sir := A_thislabeL ))
return,
			
LABElA(Tingz) 	 {
	switch Tingz {
		case "AdHkRun":
			settimer, reload_orload_admhk, -1
		default:
		msgbox  % %tingz%
			run,% %Tingz%
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
reload_orload_admhk:
if !aasa:=check_ADMHOTKEY()
	run,% AdHkRun
else, settimer, admhotkey_reload_, -1
return,
admhotkey_reload_:
PostMessage, 0x0111, 65303,,,% "adminhotkeys.ahk - AutoHotkey"
return
;------------=========================++++++++++++++++++++*+*+*+*
Open_ScriptDir() ; not called ever, using to invoke its label(s).
;------------=========================++++++++++++++++++++*+*+*+*
Stylemenu_init:  ; tooltip % "Analyzing, please wait" ++++*+*+*+*
TargetHandle := "", style:=""
if Dix
	if F
	 menu, F, DeleteAll
Dix := True
MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
TargetHandle := ("ahk_id " . OutputVarWin)
wingetTitle, TargetTitle,% TargetHandle
if !TargetTitle 
	return,
winget, PName,     ProcessName,%      TargetHandle
winget, Style2,    Style,% 		      TargetHandle
winget, ExStyle2,  ExStyle,% 	      TargetHandle

menu_Style_main:
menu,         F,   Add,%     PName,   donothing
menu,         F,   Disable,% PName
menu,         F,   Add,%   Grants_Son["Sys_Menu"], toggle_sysmenu
if (Style2    &    0x00080000)
	  menu,   F,   check,% Grants_Son["Sys_Menu"]
else, menu,   F,   uncheck,% Grants_Son["Sys_Menu"]
      menu,   F,   add,% Grants_Son["Clickthru"],   toggle_Clickthru
if(ExStyle2   &    0x00000001)
	  menu,   F,   check,% Grants_Son["Clickthru"]
else, menu,   F,   uncheck,% Grants_Son["Clickthru"]
      Menu,   F,   add,% Grants_Son["AppWindow"],   toggle_AppWindow
if(ExStyle2   &    0x00040000)
	  menu,   F,   check,% Grants_Son["AppWindow"]
else, menu,   F,   uncheck,% Grants_Son["AppWindow"]
goto, menus_subitem

Submenus:
menu, F, add, Frame / & X Controls, :S1
menu, F, add, Scrollbars, 			:S2
menu, F, add, Layout, 				:S3
goto, menus_other

menus_subitem:    
      menu,      S1, add,%      "DLG Frame",   toggle_DLGFRAME
if(Style2    &   0x00400000)   
	  menu,      S1, check,%    "DLG Frame"
else, menu,      S1, uncheck,%  "DLG Frame"
      menu,      S1, Add,%      "THICK Frame", toggle_thickframe
if (Style2   &   0x00040000)   
	  menu,      S1, check,%    "THICK Frame"
else, menu,      S1, uncheck,%  "THICK Frame"
      menu,      S1, Add,%      "Modal Frame", toggle_Modalframe
if(ExStyle2  &   0x00000001)   
	  menu,      S1, check,%    "Modal Frame"
else, menu,      S1, uncheck,%  "Modal Frame"
      menu,      S1, Add,%      "Static edge", toggle_staticedge
if(ExStyle2  &   0x00020000)   
	  menu,      S1, check,%    "Static edge"
else, menu,      S1, uncheck,%  "Static edge"
      menu,      S1, Add,%      Grants_Son["Maxbox"],       toggle_Maxbox
if (Style2   &    0x00010000)                     
	  menu,      S1, check,%     Grants_Son["Maxbox"]        
else, menu,      S1, uncheck,%   Grants_Son["Maxbox"]       
      menu,      S1, Add,%       Grants_Son["MinBox"],       toggle_MinBox
if (Style2   &   0x00020000)                    
	  menu,      S1, check,%     Grants_Son["MinBox"]          
else, menu,      S1, uncheck,%   Grants_Son["MinBox"]          
      menu,      S2, Add,%      "HScroll",     toggle_hscroll
if (Style2   &   0x00100000)                  
	  menu,      S2, check,% 	"HScroll"  
else, menu,      S2, uncheck,%  "HScroll"     
      menu,      S2, Add,%      "VScroll",     toggle_hscroll
if(Style2    &   0x00200000)                    
	  menu,      S2, check,% 	"VScroll"      
else, menu,      S2, uncheck,%   "VScroll"   
      menu,      S2, Add,%      Grants_Son["LeftScroll"],    toggle_LeftScroll
if(ExStyle2  &   0x00004000)                   
	  menu,      S2, check,%    Grants_Son["LeftScroll"]     
else, menu,      S2, uncheck,%  Grants_Son["LeftScroll"]   
      menu,      S3, Add,%      Grants_Son["RightAlign"],    toggle_RightAlign
if (ExStyle2 &   0x00001000)                   
	  menu,      S3, check,%    Grants_Son["RightAlign"]
else, menu,      S3, uncheck,%  Grants_Son["RightAlign"]
      menu,      S3, Add,%      Grants_Son["RightoLeft"],    toggle_RightoLeft
if (ExStyle2 &   0x00002000)                   
	  menu,      S3, check,%    Grants_Son["RightoLeft"]    
else, menu,      S3, uncheck,%  Grants_Son["RightoLeft"]
goto, Submenus

; SysMenu		:= 	"Title (+ & X Conrols) (SysMenu)"
; Maxbox 		:= 	"Maximise Button (□)"
; MinBox 		:= 	"Minimise Button (_)"
; LeftScroll 	:= 	"Left Scroll Orientation"
; ClickThru 	:= 	"Click-through"
; RightAlign	:= 	"Generic Right-alignment"
; RightoLeft	:= 	"Right-to-Left reading"
; AppWindow		:= 	"Taskbar Item (not 100%)"
; Save			:= 	"Save window style preferences" delete me
; Reset			:= 	"Reset window style preferences"
menus_other: ; below submenus
menu, 	F, 	add,  m2drag bypass,     toggle_m2drag_bypass
menu, 	F, 	Icon, m2drag bypass,%     mouse24
menu, 	F, 	add,% "Get window text", getwintxt
menu, 	F, 	add,% Save,              Savegui
goto,   StyleMenu_Show

StyleMenu_Show:
menu, 	F,  Show
return,  
;`~			
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
mti := (NewTrayMenuParam("", "Launch PowerConfig", ((icn := "C:\Icon\") . "20\alien.ico") )), mti := (NewTrayMenuParam("", "Launch MattDWM", (icn . "24\dwm24.ico") )), mti := (NewTrayMenuParam("", "Launch YouTube_DL", (icn . "24\YouTube.ico") )), mti := (NewTrayMenuParam("", "DWM_Axnt_fix", (icn . "24\refresh.png") )), mti := (NewTrayMenuParam("", "LoadAeroRegKeyz", (icn . "24\refresh.png") )), mti := (NewTrayMenuParam("", "Launch M2Drag", (ScpW . "\Mouse242.ico") )), mti := (NewTrayMenuParam("", "Launch screen clean!", (icn . "24\AF_Icon.ico") ))
mti := ""
return, 
; ~`~`~~`~;`~`~`~`~		~`~`~`~		~`~`~`~		~`~`~`  ~`~`~` ~`~`~	`~` ~`~ `~  ~`~`	~`~	`~`~`~	`~	`~`
;`~					  ~`~`~~`~`~`~`~`~``~`~``~`~`~`~`~`~`~`~`~`~`~`~`~
;~~~~~~~^^; 
 Menu_Tray_Init: ;=---- `~;/ add your own ; NewTrayMenuParam("LabelPointer", "Title", "Icon")
;~~~~~~~^^;  []
menu, 	tray, 	  NoStandard ;  menu, tray, icon,% TrayIconPath
menu, 	tray, 	  Icon, Context32.ico
menu, 	tray, 	  add, 	Open Script Dir, Open_ScriptDir

menu, 	tray, 	  Standard
gosub, 	MenuP               ; add the rest... /
gosub, 	test_icons 			; and their ico
menu, 	SubMenu1, add,  restart wacom,   SvcRestartWacom
menu, 	SubMenu1, icon, restart wacom,   C:\Icon\24\DNA.ico

menu,   tray,     add,  Services,        :SubMenu1
menu,   tray,     icon, Services,        C:\Icon\24\DNA.ico

return,
SvcRestartWacom:
result := service_restart("WTabletServicePro")   
settimer, testresult, -4500
return

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
return
;         Style and extended style setter menu Init
Menu_Style_Init:           
;        -DeLimiters
_x := ("|"), _y := "£" 
;        -String
str_aL:=("Sys_Menu" . _y . """Title (+ & X Conrols) (SysMenu)""" . _x . "Maxbox" . _y . """Maximise Button (□)""" . _x . "MinBox" . _y . """Minimise Button (_)""" . _x . "LeftScroll" . _y . """Left Scroll Orientation""" . _x . "ClickThru" . _y . """Click-through""" . _x . "RightAlign" . _y . """Generic Right-alignment""" . _x . "RightoLeft" . _y . """Right-to-Left reading""" . _x . "AppWindow" . _y . """Taskbar Item (not 100%)""" . _x . "Save" . _y . """Save window style preferences""" . _x . "Reset" . _y . """Reset window style preferences""")
;        -Parse
loop,     parse, str_aL,% _x
	loop, parse, A_loopfield,% _y
		switch a_index {  
			case "1":
				my_i := A_loopfield
			case "2": ; msgbox %
				Grants_Son[my_i] := A_loopfield
		}
		;for index, element in grants_son
		;msgbox % index "`n" element
		;bum="sysmenu"
		;msgbox % Grants_Son["sys_menu"]
return  ;END
;	^-=___=-^				^-=___=-^				^--___=-^   ^   ~   ~   _   ¬   ¬   ¬   ¬   ¬   ¬   ¬   ¬   _
Varz:   ; 01010101010 ' ` ' `' `':C\Root\`'`'''`'      `''`0101'`'`'```''`'`'     ``'010101`''`'0xFFEEDD`'`'`'`'``'`'     			`''`''KILL!'`'`' '`''`'``'' `'`''`''` ''`'` '`''` `''` `''` `'` 
global AHKdir, AF, AF2, AutoFireScript, Scr_, dbgtt, AutoFireScript2, TargetScriptTitle, TargetScriptTitle2, AF_Delay, SysShadowStyle_New, SysShadowExStyle_New, toolx, offsett, XCent, YCent, starttime, text, X_X, Last_Title, autofire, RhWnd_old, MouseTextID, DMT, roblox, toggleshift, Norm_menuStyle, Norm_menuexStyle, Title_last, dcStyle, classname, tool, tooly, EventLogBuffer_Old, Roblox_hwnd, Time_Elapsed, KillCount, SBAR_2berestored_True, Sidebar, TT, TT4g, TTFoc, TTcr, TTds, TTmb, dbg, TClass, TTitle, TProcName, delim, delim2, TitleCount, ClassCount, ProcCount, style2, exstyle2, ArrayProc, ArrayClass, ArrayTitle, Array_LProc, Array_LTitle, Array_LClass, Style_ClassnameList2, Style_procnameList2, Style_wintitleList2, Youtube_Popoutwin, Script_Title, np, m2dstatus, crashmb, 8skin_crash, OutputVarWin, F, s1, s2, s3, FileListStr, oldlist, FileCount, ADELIM, hTarget, hTargetprev, hgui, xPrev, yPrev, hPrev, logvar, ADM_wTtL, triggeredGFS, Matrix, Maxbox, MinBox, LeftScroll, ClickThru, RightAlign, RightoLeft, AppWindow, Save, Reset, MiDiRun, test_move, mattdwmrun, Quoting, mmenuListTtl, MenuLablAr, MenuLablTitlAr, mmenuListLbl, Desk_Wi, Desk_Hi, FileListStr_Ar, hTargetPrev, wPrev, hPrev, xPrev, yPrev, hidegui, q_dlim, quotes, DEBUGTEST_HWND, hook4g, HookMb, HookCr, HookOD, HookFc, DEBUGTEST_FOC, hook4gProc4g_, AhkPath, HookMb, ProcMb_, ProcCr_, ProcDstroyd, procFc_, nnd, 1998, 1999, SkpO, old_focus1, old_focus2, old_focus3, old4gnd1, old4gnd2, old4gnd3, qstr, mattdwmrun2, test_move, SidebarPath, Path_PH, AHK_Rare, CleanME_PLZz, Schd_T, HKCUCurVer, stylekey, AdHkRun, PConfig, YT_DL, M2dRun, Mag_, DWMFixS, WMPRun, MiDiRun, MiDi_, adh, ScpW, MiDir, winevents, winevent_I, Split_Tail, Split_Head, ripple, ripoldm, t_x, t_Y, lo0, Grants_Son, mouse24, wintitlekey, procnamekey, classnamekey, OBJ4g, OBJFc, OBJCR, OBJDS, MNPPS, WIN_TARGET_DESC, MSG_WIN_TARGET, WINEVENT_SkpOROCESS, WINEVENT_OUTOFCONTEXT, OoC, Desktop_Margin, 











 ;	^-=___=-^ 	 ;-=-=;'`'``''`'`'``''`'`'``''`'`'`
tt := 800 			     ; default tooltip timeout
loop, parse,% "ArrayProc,ArrayClass,ArrayTitle,Array_LProc,Array_LTitle,Array_LClass,MenuLablAr,MenuLablTitlAr,FileListStr_Ar,quotes,winevent_I,winevents,Grants_Son", `,
	%A_loopfield% := []  ; array_inits:
mmenuListTtl := "4ground hook tip/focus hook tip/obj_create tip/obj_destroy tip/msgbox hook tip/Toggle debug/Toggle Sidebar off/DWM_Axnt_fix/LoadAeroRegKeyz/Launch PowerConfig/Launch MattDWM/Launch M2Drag/Launch WMP_MATT/Launch midi_in_out/Launch AdHkRun/Launch YouTube_DL/Launch test_move/Launch screen clean!"
mmenuListLbl := "TT4g/TTFoc/TTcr/TTds/TTmb/Toggle_dbg/Toggle_sbar/DWMFixS/AeroTheme_Set/pconfig/mattdwmrun2/M2dRun/WMPRun/MiDi_/AdHkRun/YT_DL/test_move/CleanME_PLZz"
loop, 22 {               ; -=-=;'`'``''`'`'``''`'`'``''`'`'``
	v1 := ("hChildMagnifier" . A_index) 
	global (%v1%)
	v2 := ("hgui" . A_Index) 
	global  (%v2%)
	v3 := ("HWNDhgui" . A_Index)  
	global  (%v3%)       ; -=-=-;'`'``''`'`'``''``''``''
}		
						 ;`'``''`'`'``''`'`'``''`'`'`'``
Matrix 	:=(	"-1	|0	|0	|0	|0|"  ;'``''`'`'``''`'`'``''`'`'
.           "0	|-1	|0	|0	|0|"  ;``''`'`'``''`'`'``''`'`'``'
.           "0	|0	|-1	|0	|0|"  ;`''`'`'``''`'`'``''`'`'``'''
.           "0	|0	|0	|1	|0|"  ;''`'`'``''`'`'``''`'`'``''`'
.           "1	|1	|1	|0	|1 " ) ;'`'`'``''`'`'``''`'`'``''`'
;"!!! vARi4bl3z !!!!" ...		 ^-=___=-^	>>>>>>>>>>>>;??? ;  	 ~@~peww~@~	
; DWM_Run:= ((Autoit3path := "C:\Program Files (x86)\AutoIt3\AutoIt3_x64.exe") . " " . "C:\Script\autoit\_MattDwmBlurBehindWindow.au3") 
regRead, AHKdir,  HKLM\SOFTWARE\AutoHotkey,% "InstallDir"    
sysget,  Desktop_Margin, MonitorWorkArea
sysget,  Desk_Wi, 78
sysget,  Desk_Hi, 79
XCent := (floor(0.5*Desk_Wi))
YCent := (floor(0.5*Desk_Hi))
AHk64 := (AHKdir . "\Autohotkey.exe ")
ScpW  := "C:\Script\AHK\Working"
mattdwmrun2	:= "C:\Script\autoit\_MattDwmBlurBehindWindow.lnk"    ;   ^^^Wrong start dir envVar 1nce launched?
test_move	:= "C:\Users\ninj\DESKTOP\winmove_test.ahk"
SidebarPath := "C:\Program Files\Windows Sidebar\sidebar.exe"
Path_PH 	:= "C:\Apps\Ph\processhacker\x64\ProcessHacker.exe"
AHK_Rare 	:= ((Scr_ := ("C:\Script\AHK")) . ("\- Script\AHK-Rare-master\AHKRareTheGui.ahk"))
CleanME_PLZz:= (Scr_ . "\white_full-screen_gui.ahk")
Schd_T      := "C:\Windows\system32\schtasks.exe"
HKCUCurVer	:= "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion"
stylekey    := "HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles"
;    menu    labels    building
AdHkRun := (sched_tsk:=(Schd_T . " /run /tn ") . (adh:="adminhotkeys.ahk") . "_407642875")
PConfig := (sched_tsk  .  "cmd_output_to_msgbox.ahk_407642875")                           
YT_DL   := (( (AHkU64Uia := (AHKdir . "\AutoHotkeyU64_UIA.exe ")) . ScpW . "\YT.ahk" ))
Mag_    := ( AHk64 . " " . ScpW . "\M2DRAG_MAG.AHK") 
DWMFixS := ( AHkU64UiaaDM := ((AHKdir . "\AutoHotkeyU64_UIA - admin.exe ")) . (Scr_ . "\__TESTS\dwm_accentcolour.ahk"))
WMPRun  := ( AHkU64    .  Scr_ . "\Z_MIDI_IN_OUT\wmp_Matt.ahk")
MiDiRun := ( AHKdir    .  "AutoHotkeyU64.exe " . Scr_ . MiDir)
ADM_wTtL:= ( Scr_      .  "\" . adh . " - AutoHotkey v1.1.33.10")
MiDi_:= ( AHkU64 . Scr_ .  (MiDir:=("\Z_MIDI_IN_OUT" . "\z_in_out.ahk")))
M2dRun  := ( AHkU64Uia .  Scr_ .  "\Working\M2Drag.ahk")

BF := "Roblox_Rapid.ahk", BF2 := "Roblox_Bunny.ahk", af_1 := ("\" . BF),   Bun_ := ("\" . BF2), AF := (Scr_ . af_1), AF2 := (Scr_ . Bun_), AutoFireScript := BF, AutoFireScript2 := BF2 , TargetScriptTitle := (AutoFireScript . " ahk_class AutoHotkey"), TargetScriptTitle2 := (AutoFireScript2 . " ahk_class AutoHotkey"), AF_Delay := 10, SysShadowStyle_New := 0x08000000, SysShadowExStyle_New := 0x08000020, toolx := "-66", offsett := 40, delim := "Þ", delim1 := "µ", delim2 := "»",KILLSWITCH := "kill all AHK procs.ahk", mouse24 := "C:\Script\AHK\Working\mouse24.ico", 
OBJ4g := 0x0003, OBJFc:=0x8005, OBJCR := 0x8000, OBJDS := 0x8001, MNPPS := 0x0006, WIN_TARGET_DESC := "Information", MSG_WIN_TARGET := WIN_TARGET_DESC, WINEVENT_SkpOROCESS := 0x0002, SkpO := WINEVENT_SkpOROCESS, WINEVENT_OUTOFCONTEXT := 0x0000, OoC := WINEVENT_OUTOFCONTEXT, wintitlekey := (stylekey . "\wintitle"), procnamekey := (stylekey . "\procname"), classnamekey := (stylekey . "\classname")

donothing:
return,

init_matt:
InitLabelOrder := "Varz>Menu_Tray_Init>Menu_Style_Init>RegReads>Hooks>quotEI>reload_orload_admhk>Main"
loop, parse, InitLabelOrder, ">",
	gosub,% A_loopfield
;return,
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

; BlockShutdown(Reason) { ; If your script has a visible GUI, use it instead of A_ScriptHwnd.
    ; DllCall("ShutdownBlockReasonCreate", "ptr", A_ScriptHwnd, "wstr", Reason)
    ; OnExit("StopBlockingShutdown")
; }
; StopBlockingShutdown(){
    ; OnExit(A_ThisFunc, 0)
    ; DllCall("ShutdownBlockReasonDestroy", "ptr", A_ScriptHwnd)
; }

; Open_script_folder:
; e = explorer /select, %a_ScriptFullPath%
; tooltip % a_ScriptFullPath
; run %comspec% /c %e%,,hide,
; settimer, tooloff, -1222
; return,


;Event Ranges  of WinEvent constant values specified by AIA for use across the industry. 
EVENT_AIA_START :=  0xA000
EVENT_AIA_END   :=  0xAFFF
EVENT_MIN       :=  0x00000001
EVENT_MAX       :=  0x7FFFFFFF
EVENT_UIA_EVENTID_START := 0x4E00
EVENT_UIA_EVENTID_END   := 0x4EFF
EVENT_OEM_DEFINED_START := 0x0101	;The range of event constant values reserved for OEMs. 
EVENT_OEM_DEFINED_END   := 0x01FF
EVENT_UIA_PROPID_START  := 0x7500	; The range of event constant values reserved for UI Automation event identifiers. 
EVENT_UIA_PROPID_END    := 0x75FF

; The range of event constant values reserved for UI Automation property-changed event identifiers. 
event1 := ("EVENT_OBJECT_ACCELERATORCHANGE|0x8012|An object's KeyboardShortcut property has changed. Server applications send this event for their accessible objects.¬EVENT_OBJECT_CLOAKED|0x8017|Sent when a window is cloaked. A cloaked window still exists, but is invisible to the user.¬EVENT_OBJECT_CONTENTSCROLLED|0x8015|A window object's scrolling has ended. Unlike EVENT_SYSTEM_SCROLLEND, this event is associated with the scrolling window. Whether the scrolling is horizontal or vertical scrolling, this event should be sent whenever the scroll action is completed.  The hwnd parameter of the WinEventProc callback function describes the scrolling window  the idObject parameter is OBJID_CLIENT, and the idChild parameter is CHILDID_SELF.¬EVENT_OBJECT_CREATE|0x8000|An object has been created. The system sends this event for the following user interface elements: caret, header control, list-view control, tab control, toolbar control, tree view control, and window object. Server applications send this event for their accessible objects.  Before sending the event for the parent object, servers must send it for all of an object's child objects. Servers must ensure that all child objects are fully created and ready to accept IAccessible calls from clients before the parent object sends this event.  Because a parent object is created after its child objects, clients must make sure that an object's parent has been created before calling IAccessible::get_accParent, particularly if in-context hook functions are used.¬EVENT_OBJECT_DEFACTIONCHANGE|0x8011|An object's DefaultAction property has changed. The system sends this event for dialog boxes. Server applications send this event for their accessible objects.¬EVENT_OBJECT_DESCRIPTIONCHANGE|0x800D|An object's Description property has changed. Server applications send this event for their accessible objects.¬EVENT_OBJECT_DESTROY|0x8001|An object has been destroyed. The system sends this event for the following user interface elements: caret, header control, list-view control, tab control, toolbar control, tree view control, and window object. Server applications send this event for their accessible objects. Clients assume that all of an object's children are destroyed when the parent object sends this event.  After receiving this event, clients do not call an object's IAccessible properties or methods. However, the interface pointer must remain valid as long as there is a reference count on it due to COM rules, but the UI element may no longer be present. Further calls on the interface pointer may return failure errors  to prevent this, servers create proxy objects and monitor their life spans.¬EVENT_OBJECT_DRAGSTART|0x8021|The user started to drag an element. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the object being dragged.¬EVENT_OBJECT_DRAGCANCEL|0x8022|The user has ended a drag operation before dropping the dragged element on a drop target. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the object being dragged.¬EVENT_OBJECT_DRAGCOMPLETE|0x8023|The user dropped an element on a drop target. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the object being dragged.¬EVENT_OBJECT_DRAGENTER|0x8024|The user dragged an element into a drop target's boundary. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the drop target.¬EVENT_OBJECT_DRAGLEAVE|0x8025|The user dragged an element out of a drop target's boundary. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the drop target.¬EVENT_OBJECT_DRAGDROPPED|0x8026|The user dropped an element on a drop target. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the drop target.¬EVENT_OBJECT_END|0x80FF|The highest object event value.¬EVENT_OBJECT_FOCUS|0x8005|An object has received the keyboard focus. The system sends this event for the following user interface elements: list-view control, menu bar, pop-up menu, switch window, tab control, tree view control, and window object. Server applications send this event for their accessible objects.  The hwnd parameter of the WinEventProc callback function identifies the window that receives the keyboard focus.¬EVENT_OBJECT_HELPCHANGE|0x8010|An object's Help property has changed. Server applications send this event for their accessible objects.¬EVENT_OBJECT_HIDE|0x8003|An object is hidden. The system sends this event for the following user interface elements: caret and cursor. Server applications send this event for their accessible objects. When this event is generated for a parent object, all child objects are already hidden. Server applications do not send this event for the child objects.	Hidden objects include the STATE_SYSTEM_INVISIBLE flag  shown objects do not include this flag. The EVENT_OBJECT_HIDE event also indicates that the STATE_SYSTEM_INVISIBLE flag is set. Therefore, servers do not send the EVENT_STATE_CHANGE event in this case.¬EVENT_OBJECT_HOSTEDOBJECTSINVALIDATED|0x8020|A window that hosts other accessible objects has changed the hosted objects. A client might need to query the host window to discover the new hosted objects, especially if the client has been monitoring events from the window. A hosted object is an object from an accessibility framework MSAA or UI Automation that is different from that of the host. Changes in hosted objects that are from the same framework as the host should be handed with the structural change events, such as EVENT_OBJECT_CREATE for MSAA. For more info see comments within winuser.h.¬EVENT_OBJECT_IME_HIDE|0x8028|An IME window has become hidden.¬EVENT_OBJECT_IME_SHOW|0x8027|An IME window has become visible.¬EVENT_OBJECT_IME_CHANGE|0x8029|The size or position of an IME window has changed.¬EVENT_OBJECT_INVOKED|0x8013|An object has been invoked  for example, the user has clicked a button. This event is supported by common controls and is used by UI Automation.	For this event, the hwnd, ID, and idChild parameters of the WinEventProc callback function identify the item that is invoked.¬EVENT_OBJECT_LIVEREGIONCHANGED|0x8019|An object that is part of a live region has changed. A live region is an area of an application that changes frequently and/or asynchronously.¬EVENT_OBJECT_LOCATIONCHANGE|0x800B|An object has changed location, shape, or size. The system sends this event for the following user interface elements: caret and window objects. Server applications send this event for their accessible objects.  This event is generated in response to a change in the top-level object within the object hierarchy  it is not generated for any children that the object might have. For example, if the user resizes a window, the system sends this notification for the window, but not for the menu bar, title bar, scroll bar, or other objects that have also changed.  The system does not send this event for every non-floating child window when the parent moves. However, if an application explicitly resizes child windows as a result of resizing the parent window, the system sends multiple events for the resized children.	  If an object's State property is set to STATE_SYSTEM_FLOATING, the server sends EVENT_OBJECT_LOCATIONCHANGE whenever the object changes location. If an object does not have this state, servers only trigger this event when the object moves in relation to its parent. For this event notification, the idChild parameter of the WinEventProc callback function identifies the child object that has changed.¬EVENT_OBJECT_NAMECHANGE|0x800C|An object's Name property has changed. The system sends this event for the following user interface elements: check box, cursor, list-view control, push button, radio button, status bar control, tree view control, and window object. Server applications send this event for their accessible objects.¬EVENT_OBJECT_PARENTCHANGE|0x800F|An object has a new parent object. Server applications send this event for their accessible objects.¬EVENT_OBJECT_REORDER|0x8004|A container object has added, removed, or reordered its children. The system sends this event for the following user interface elements: header control, list-view control, toolbar control, and window object. Server applications send this event as appropriate for their accessible objects.	  For example, this event is generated by a list-view object when the number of child elements or the order of the elements changes. This event is also sent by a parent window when the Z-order for the child windows changes.¬")
event2 := ("EVENT_OBJECT_SELECTION|0x8006|The selection within a container object has changed. The system sends this event for the following user interface elements: list-view control, tab control, tree view control, and window object. Server applications send this event for their accessible objects. This event signals a single selection: either a child is selected in a container that previously did not contain any selected children, or the selection has changed from one child to another.  The hwnd and idObject parameters of the WinEventProc callback function describe the container  the idChild parameter identifies the object that is selected. If the selected child is a window that also contains objects, the idChild parameter is OBJID_WINDOW.¬EVENT_OBJECT_SELECTIONADD|0x8007|A child within a container object has been added to an existing selection. The system sends this event for the following user interface elements: list box, list-view control, and tree view control. Server applications send this event for their accessible objects.  The hwnd and idObject parameters of the WinEventProc callback function describe the container. The idChild parameter is the child that is added to the selection.¬EVENT_OBJECT_SELECTIONREMOVE|0x8008|An item within a container object has been removed from the selection. The system sends this event for the following user interface elements: list box, list-view control, and tree view control. Server applications send this event for their accessible objects.  This event signals that a child is removed from an existing selection.  The hwnd and idObject parameters of the WinEventProc callback function describe the container  the idChild parameter identifies the child that has been removed from the selection.¬EVENT_OBJECT_SELECTIONWITHIN|0x8009|Numerous selection changes have occurred within a container object. The system sends this event for list boxes  server applications send it for their accessible objects.	  This event is sent when the selected items within a control have changed substantially. The event informs the client that many selection changes have occurred, and it is sent instead of several EVENT_OBJECT_SELECTIONADD or EVENT_OBJECT_SELECTIONREMOVE events. The client queries for the selected items by calling the container object's IAccessible::get_accSelection method and enumerating the selected items.  For this event notification, the hwnd and idObject parameters of the WinEventProc callback function describe the container in which the changes occurred.¬EVENT_OBJECT_SHOW|0x8002|A hidden object is shown. The system sends this event for the following user interface elements: caret, cursor, and window object. Server applications send this event for their accessible objects.  Clients assume that when this event is sent by a parent object, all child objects are already displayed. Therefore, server applications do not send this event for the child objects.  Hidden objects include the STATE_SYSTEM_INVISIBLE flag  shown objects do not include this flag. The EVENT_OBJECT_SHOW event also indicates that the STATE_SYSTEM_INVISIBLE flag is cleared. Therefore, servers do not send the EVENT_STATE_CHANGE event in this case.¬EVENT_OBJECT_STATECHANGE|0x800A|An object's state has changed. The system sends this event for the following user interface elements: check box, combo box, header control, push button, radio button, scroll bar, toolbar control, tree view control, up-down control, and window object. Server applications send this event for their accessible objects.	  For example, a state change occurs when a button object is clicked or released, or when an object is enabled or disabled.	  For this event notification, the idChild parameter of the WinEventProc callback function identifies the child object whose state has changed.¬EVENT_OBJECT_TEXTEDIT_CONVERSIONTARGETCHANGED|0x8030|The conversion target within an IME composition has changed. The conversion target is the subset of the IME composition which is actively selected as the target for user-initiated conversions.¬EVENT_OBJECT_TEXTSELECTIONCHANGED|0x8014|An object's text selection has changed. This event is supported by common controls and is used by UI Automation.  The hwnd, ID, and idChild parameters of the WinEventProc callback function describe the item that is contained in the updated text selection.¬EVENT_OBJECT_UNCLOAKED|0x8018|Sent when a window is uncloaked. A cloaked window still exists, but is invisible to the user.¬EVENT_OBJECT_VALUECHANGE|0x800E|An object's Value property has changed. The system sends this event for the user interface elements that include the scroll bar and the following controls: edit, header, hot key, progress bar, slider, and up-down. Server applications send this event for their accessible objects.¬EVENT_SYSTEM_ALERT|0x0002|An alert has been generated. Server applications should not send this event.¬EVENT_SYSTEM_ARRANGMENTPREVIEW|0x8016|A preview rectangle is being displayed.¬EVENT_SYSTEM_CAPTUREEND|0x0009|A window has lost mouse capture. This event is sent by the system, never by servers.¬EVENT_SYSTEM_CAPTURESTART|0x0008|A window has received mouse capture. This event is sent by the system, never by servers.¬EVENT_SYSTEM_CONTEXTHELPEND|0x000D|A window has exited context-sensitive Help mode. This event is not sent consistently by the system.¬EVENT_SYSTEM_CONTEXTHELPSTART|0x000C|A window has entered context-sensitive Help mode. This event is not sent consistently by the system.¬EVENT_SYSTEM_DESKTOPSWITCH|0x0020|The active desktop has been switched.¬EVENT_SYSTEM_DIALOGEND|0x0011|A dialog box has been closed. The system sends this event for standard dialog boxes  servers send it for custom dialog boxes. This event is not sent consistently by the system.¬EVENT_SYSTEM_DIALOGSTART|0x0010|A dialog box has been displayed. The system sends this event for standard dialog boxes, which are created using resource templates or Win32 dialog box functions. Servers send this event for custom dialog boxes, which are windows that function as dialog boxes but are not created in the standard way.  This event is not sent consistently by the system.¬EVENT_SYSTEM_DRAGDROPEND|0x000F|An application is about to exit drag-and-drop mode. Applications that support drag-and-drop operations must send this event the system does not send this event.¬EVENT_SYSTEM_DRAGDROPSTART|0x000E|An application is about to enter drag-and-drop mode. Applications that support drag-and-drop operations must send this event because the system does not send it.¬EVENT_SYSTEM_END|0x00FF|The highest system event value.¬EVENT_SYSTEM_FOREGROUND|0x0003|The foreground window has changed. The system sends this event even if the foreground window has changed to another window in the same thread. Server applications never send this event.	For this event, the WinEventProc callback function's hwnd parameter is the handle to the window that is in the foreground, the idObject parameter is OBJID_WINDOW, and the idChild parameter is CHILDID_SELF.¬EVENT_SYSTEM_MENUPOPUPEND|0x0007|A pop-up menu has been closed. The system sends this event for standard menus  servers send it for custom menus.  When a pop-up menu is closed, the client receives this message, and then the EVENT_SYSTEM_MENUEND event.	This event is not sent consistently by the system.¬EVENT_SYSTEM_MENUPOPUPSTART|0x0006|A pop-up menu has been displayed. The system sends this event for standard menus, which are identified by HMENU, and are created using menu-template resources or Win32 menu functions. Servers send this event for custom menus, which are user interface elements that function as menus but are not created in the standard way. This event is not sent consistently by the system.¬EVENT_SYSTEM_MENUEND|0x0005|A menu from the menu bar has been closed. The system sends this event for standard menus  servers send it for custom menus.  For this event, the WinEventProc callback function's hwnd, idObject, and idChild parameters refer to the control that contains the menu bar or the control that activates the context menu. The hwnd parameter is the handle to the window that is related to the event. The idObject parameter is OBJID_MENU or OBJID_SYSMENU for a menu, or OBJID_WINDOW for a pop-up menu. The idChild parameter is CHILDID_SELF.¬EVENT_SYSTEM_MENUSTART|0x0004|A menu item on the menu bar has been selected. The system sends this event for standard menus, which are identified by HMENU, created using menu-template resources or Win32 menu API elements. Servers send this event for custom menus, which are user interface elements that function as menus but are not created in the standard way.	For this event, the WinEventProc callback function's hwnd, idObject, and idChild parameters refer to the control that contains the menu bar or the control that activates the context menu. The hwnd parameter is the handle to the window related to the event. The idObject parameter is OBJID_MENU or OBJID_SYSMENU for a menu, or OBJID_WINDOW for a pop-up menu. The idChild parameter is CHILDID_SELF.	The system triggers more than one EVENT_SYSTEM_MENUSTART event that does not always correspond with the EVENT_SYSTEM_MENUEND event.¬EVENT_SYSTEM_MINIMIZEEND|0x0017|A window object is about to be restored. This event is sent by the system, never by servers.¬EVENT_SYSTEM_MINIMIZESTART|0x0016|A window object is about to be minimized. This event is sent by the system, never by servers.¬EVENT_SYSTEM_MOVESIZEEND|0x000B|The movement or resizing of a window has finished. This event is sent by the system, never by servers.¬EVENT_SYSTEM_MOVESIZESTART|0x000A|A window is being moved or resized. This event is sent by the system, never by servers.¬EVENT_SYSTEM_SCROLLINGEND|0x0013|Scrolling has ended on a scroll bar. This event is sent by the system for standard scroll bar controls and for scroll bars that are attached to a window. Servers send this event for custom scroll bars, which are user interface elements that function as scroll bars but are not created in the standard way.  The idObject parameter that is sent to the WinEventProc callback function is OBJID_HSCROLL for horizontal scroll bars, and OBJID_VSCROLL for vertical scroll bars.¬EVENT_SYSTEM_SCROLLINGSTART|0x0012|Scrolling has started on a scroll bar. The system sends this event for standard scroll bar controls and for scroll bars attached to a window. Servers send this event for custom scroll bars, which are user interface elements that function as scroll bars but are not created in the standard way.  The idObject parameter that is sent to the WinEventProc callback function is OBJID_HSCROLL for horizontal scrolls bars, and OBJID_VSCROLL for vertical scroll bars.¬EVENT_SYSTEM_SOUND|0x0001|A sound has been played. The system sends this event when a system sound, such as one for a menu, is played even if no sound is audible for example, due to the lack of a sound file or a sound card. Servers send this event whenever a custom UI element generates a sound.  For this event, the WinEventProc callback function receives the OBJID_SOUND value as the idObject parameter.¬EVENT_SYSTEM_SWITCHEND|0x0015|The user has released ALT+TAB. This event is sent by the system, never by servers. The hwnd parameter of the WinEventProc callback function identifies the window to which the user has switched.  If only one application is running when the user presses ALT+TAB, the system sends this event without a corresponding EVENT_SYSTEM_SWITCHSTART event.¬EVENT_SYSTEM_SWITCHSTART|0x0014|The user has pressed ALT+TAB, which activates the switch window. This event is sent by the system, never by servers. The hwnd parameter of the WinEventProc callback function identifies the window to which the user is switching.  If only one application is running when the user presses ALT+TAB, the system sends an EVENT_SYSTEM_SWITCHEND event without a corresponding EVENT_SYSTEM_SWITCHSTART event.")

createeventgui:
gui, eventgui: new, +owner, eventgui
gui, eventgui: +LastFound +Hwndeventguihwnd -Caption -DPIScale +AlwaysOnTop -SysMenu +ToolWindow +owndialogs
gui, eventgui: color, 0f0022
Split_Head   :=  "OBJECT_REORDER,ECT_END"
Split_Tail   :=  "DRAGCANCEL,ECT_END"
gui, ttt: new, +owner, ttt
gui, ttt: +LastFound +Hwndttthwnd -Caption -DPIScale +AlwaysOnTop -SysMenu +ToolWindow +owndialogs
gui, ttt: color, 3f0059

loop, parse,% "event1,event2", `,
	loop, parse, %A_loopfield%, ¬,
		loop, parse, A_loopfield, |,
			switch A_index {
				case 1:
					eventname:= substr(A_loopfield, 14) ; trim off the prefix EVENT_OBJECT_
				case 2:
					eventcode:= A_loopfield
				case 3:
					winevents[eventname]  :=  eventcode 
					leng := StrLen(A_loopfield)		
					if (leng > 99 )                    { 
						mainstring:= ""
						aiold     :=  1
						loop,% ( lo0 := (ceil((leng*0.01) ) ) )
						{
							if (a_index = "1")         {
								if (a_index = lo0)
									  mainstring := (SubStr(A_loopfield, 1)) ; . "END CUNTTT"
								else, mainstring := (SubStr(A_loopfield, 1, 100)) . "`n"
							} else {
								if (a_index = lo0)     {
									azss :=(SubStr(A_loopfield, ((a_index -1) * 100)))
									mainstring := mainstring . azss ; . "END CUNT"
								} else {
									if(a_index != lo0) {
										nigger := SubStr(A_loopfield, ((a_index -1) * 100), 100)
										mainstring := (mainstring . nigger . "`n")
						}	}	}	} 
						    winevent_I[eventname]  :=  mainstring
					} else, winevent_I[eventname]  :=  A_loopfield
			}
sleep 200
for Index, element in winevents {
	max_index += 1
	t_Ind := strreplace(Index,"EVENT_OBJECT_")
	gui, ttt:Add, Text, x24 y8,% winevent_i[index]
	gui, ttt:Add, Text,  ,% winevent_i[index]
	
	;msgbox % winevent_i[index]
	LOOP, PARSE, Split_Tail, `, 
	{
		if Index CONTAINS %A_LOOPFIELD%
			ripple += 1
	}	
	if ripple {
		1_ := (23 - RIPPLE)
		_1 := (24 - RIPPLE)
		2_ := (46 - RIPPLE)
		_2 := (47 - RIPPLE)
		3_ := (63 - RIPPLE)
		_3 := (64 - RIPPLE)
		4_ := (72 - RIPPLE)
	} else {
		1_ := 23 
		_1 := 24
		2_ := 46
		_2 := 47 
		3_ := 63
		_3 := 64
		4_ := 72
	} 
	if max_index BETWEEN 1 AND %1_%
	{  
		if (max_index =   "1") {
			ripple   :=   0	
			col      :=   1
		}
		if (col       =   "1") {
			t_X := "x48", t_Y := ("y" . ( (max_index * 24) + (rIPPLE * 24)) )
	}	}
	Else if max_index BETWEEN %_1% AND %2_%
	{
		if (col            =    "1")   {
			if ripple                  {
				ripold    :=    rippple
				rippple   :=    0
			}
			col           :=    2
		}
		if (COL            =    "2")  
			t_Y := "y" . ((max_index - 20 ) * 24)
	}
	Else if max_index BETWEEN %_2% AND %3_%
	{
		if (col       = "2") {
			ripold:=rippple
			rippple  := 0
			col      := 3
		} 
		if (COL       = "3") 
			t_Y := "y" . (((max_index-42) ) * 24) 
	}	
	Else if max_index BETWEEN %_3% AND %4_%
	{
		if (col = "3") {
			rippple := 0
			col     := 4
		} 
		if (COL = "4") 
			t_Y     :=   ("y" . ((max_index-59) * 24) )
	}	
	t_X := ("x" . (48 + ( (COL-1) * 420) ) ) ; MSGBOX % T_X " " INDEX
	LOOP,PARSE, Split_Head, `,
	{
		if Index CONTAINS %A_LOOPFIELD%
			ripple += 1
	}
	gui, eventgui:Add, Text, %t_X% %t_Y%, %Index%
}

;gui, ttt:Add, Text, x24 y24,% winevent_i[index]
gui, ttt: show, autosize
gui, eventgui: show, autosize
return,

WM_MOUSEMOVE(wParam, lParam, Msg, Hwnd) { 
	Global ; Assume-global mode
	Static Init := OnMessage(0x0200, "WM_MOUSEMOVE")
	;VarSetCapacity(TME, 16, 0)
	;NumPut(16, TME, 0)
	;NumPut(2, TME, 4) ; TME_LEAVE
	;NumPut(hColorPalette, TME, 8)
	;DllCall("User32.dll\TrackMouseEvent", "UInt", &TME)
	MouseGetPos,x,y,hwnd, MouseCtl
	;GuiControlGet, ColorVal,, % MouseCtl%	ControlGet, ControlhWnd, hWnd ,, %Control%, ahk_id %Window%
	ControlGet, ControlhWnd, hWnd ,, %MouseCtl%, ahk_id %hwnd%
	if (MouseCtlold != MouseCtl) {
		gui, ttt:destroy
		MouseCtlold:=MouseCtl 
		ControlGetText, TOAAA, %MouseCtl%, ahk_id %hwnd%
		gui, ttt:new, +owner, ttt
		gui, ttt: +LastFound +Hwndttthwnd -Caption -DPIScale +AlwaysOnTop -SysMenu +ToolWindow +owndialogs
		gui, ttt: color, 3f0059
		gui, ttt:Add, Text, x24 y14,% winevent_i[TOAAA]
		gui, ttt:show,% "noactivate "(x_x := ("x" . ( x - 500))) " " (y_y := ("y" . ( y - 200)))  " autosize " ;" w500 h256"  
		sleep 250
}	}

WM_MOUSELEAVE(wParam, lParam, Msg, Hwnd) { 
	Global ; Assume-global mode
	Static Init := OnMessage(0x02A3, "WM_MOUSELEAVE")
}
 
WM_LBUTTONDOWN(wParam, lParam, Msg, Hwnd) {
	Global ; Assume-global mode
	Static Init := OnMessage(0x0201, "WM_LBUTTONDOWN")
	MouseGetPos,x,y, hwnd, MouseCtl
			ControlGetText, TOAAA, %MouseCtl%, ahk_id %hwnd%

	ToolTip, % TOAAA "`nHook Activated"
}

ttp(TxT = "",Ti = "") {
	if dbgtt {
		tooltip, % TxT,
		if !ti 
			settimer, TT_Off, % ("-" . tt),
		else 
			settimer, TT_Off, % ("-" . ti),
}	}	


TT_Off:
tooltip,
return
return,
 