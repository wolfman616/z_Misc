#Singleinstance,      Force
ListLines,            Off 
coordMode, tooltip,   Screen
DetectHiddenWindows,  On
DetectHiddenText,     On
SetTitleMatchMode,    2	;	SetTitleMatchMode Slow
setWorkingDir,        %A_ScriptDir%
SetBatchLines,        -1
SetWinDelay,          -1
#Persistent
#NoEnv 

PreLabL: ; ===>" binds " below line 500
gosub, init_matt
return,

Main: ; sript & hooks initiated 
dbgtt := True
tt("SDFFSD")

wm_allow()

Time_Idle := A_TimeIdlePhysical	;	total time to screensaver = 420
if Time_Idle < 440
	settimer, timer_idletime,% ("-" . (430 - A_TimeIdlePhysical))

		;gui, +HWNDhgui +AlwaysOnTop
		;DllCall("GetWindowBand", "ptr", hgui, "uint*", band)
		;gui, Destroy
		;hgui := ""	
return,

timer_idletime: 		; testing
tt("timer complete.")
return,

#M::  					;		ALTgr + Right Arrow
+#M::	
Mag_ = "C:\Program Files\Autohotkey\Autohotkey.exe" "C:\Script\AHK\Working\M2DRAG_MAG.AHK"
run,% Mag_
return,

#a::
gosub, ApplyMSSTYLES ; does nothing atm
return,
+#a::
gosub, AeroTheme_Set ; does nothing atm
return,

OnObjectCreated(Hook_ObjCreate, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	CRITICAL
	wingetClass Class,% (hwand := "ahk_id " hWnd)
	gosub, Manual_Classhook_objCreated
	wingettitle, Title_last,% hwand
	winget PName, ProcessName,% hwand ;logvar := (logvar . "`r`n" . ( PName . "e" . Class . "e" . Title_last ))
	TT(("OBJ_CREATE EVENT: " PName "`nTitle: " Title_last "`nAHK_Class: " Class "`nAHK_ID: " hWnd4))
	StyleDetect(hWnd, Style_ClassnameList2,	Class,      Array_LClass) 
	StyleDetect(hWnd, Style_wintitleList2,  Title_last, Array_LTitle) 
	StyleDetect(hWnd, Style_procnameList2,	PName,      Array_LProc) 
	Manual_Classhook_objCreated:
	switch Class {
		case "OperationStatusWindow":
			;if( tits = "Folder In Use" ) {;;asas := "AHK_Class WindowsForms10.Window.8.app.0.141b42a_r6_ad1";;winget, hwnd2, ID , %asas%;;if 		asas;;winclose ahk_id %hwnd2%;;}
			ripyoursoulapart := True
			HandalDRandal := wineXist("A")
			winset, Style, -0x08000000,% hwand
			TT("Preparing...")
			; go_off_n_test_FOCUS(ActiveNow:=HandalDRandal)
			; go_off_n_test_FOCUS:
			; go_off_n_test_FOCUS(ActiveNow:=HandalDRandal)
			wingetTitle, tits , AHK_ID %hWnd% ; WinGetActiveStats, Title, Width, Height, X, Y
			settimer, tooloff, -128
			return,
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

			1998:
			ControlGet, CtrlHandL, Hwnd,, SysTreeView321,% 1998
			winset, Style, +0x00000202, ahk_id %CtrlHandL%
			return,
		case "TaskListThumbnailWnd":	
			SetAcrylicGlassEffect(hWnd)
		case "CabinetWClass":
			1999 := hwand
			settimer, 1999, -700
			return,

			1999:
			ControlGet, CtrlHandL, Hwnd,, SysTreeView321,% 1999
			sleep, 1200
			winset, Style,        -0x00000004,  ahk_id %CtrlHandL%
			winset, Style,        -0x00100000,  ahk_id %CtrlHandL%
			SendMessage, 0x112C,0, 0x00003C75,, ahk_id %CtrlHandL% 	 ;TVM_SETEXTENDEDSTYLE := 0x112C = tvmX ;; 0x00000020 auto h scroll
			return,
		case "RegEdit_RegEdit","FM":
			ControlGet, ctrlhand, Hwnd,, SysListView321,% hwand
			SendMessage 0x1036, 0, 0x00000020,, ahk_id %ctrlhand% 	 ; enable row select (vs single cell) 	LVM_SETEXTENDEDLISTVIEWSTYLE := 0x1036
			ControlGet, ctrlhand2, Hwnd,, SysTreeView321,% hwand
			winset, Style, +0x00000200, ahk_id %ctrlhand2%
		case "7 Sidebar":
			winget, Time_hWnd, iD, ahk_class 7 Sidebar
			winset, ExStyle, 0x000800A8,%  "HUD Time", ahk_id %Time_hWnd%
			winset, ExStyle, 0x000800A8,%  "Moon Phase II"
			sidebar := True
			return,
		case "ApplicationFrameWindow","Chrome_WidgetWin_1","WINDOWSCLIENT":	
			;wingettitle, Title_Last, ahk_id %hwnd% ; tooltip % Title_Last " " hwnd " " class
			if (Title_Last="Roblox") {
				;Result :=Send_WM_COPYDATA("Susp", "M2Drag.ahk ahk_class AutoHotkey")
				p ="C:\Program Files\AHK\AutoHotkeyU32_UIA.exe" "C:\Script\AHK\Roblox_Rapid.ahk"
				result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
				settimer, RobloxGetHandle, -2000
				run %p%		;run "%AF%"			;run "C:\Program Files\AHK\AutoHotkeyU32_UIA.exe" "%AF%"
				if SBAR_DISABLE {
					if winexist("ahk_exe sidebar.exe") {
						run C:\Apps\Kill.exe sidebar.exe,, hide
						SBAR_2berestored_True := True, Sidebar := False, Roblox := True
				}	}
				if (m2dstatus != "not running or paused"	) && (m2dstatus !=False) {
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
			}	} 	}
			return,
		case "ListBox","WMPMessenger":
			return,
		case "MsiDialogCloseClass":
			if id := winexist("ahk_class MsiDialogCloseClass")
				txt := "dialog", c_ntrolName := "Static1"
			if (mainc_nt = WinExist("ahk_exe msiexec.exe",txt)) {
				ControlGet, c_ntHandle, hWnd ,,%c_ntrolName% , ahk_id %mainc_nt%
				StyleMenu_Showindow( c_ntHandle, !IsWindowVisible( c_ntHandle))
				tooltip ProcdEvent: MsiDialogCloseClass`n.%id% yes %mainc_nt% main hwnd`n.%c_ntHandle%
			}
			return,
		; case "SysShadow":
		; {
			; if !DWMBLUR
				; winset, transparent , 1, ahk_id %hwnd%
			; return,
		; }
		case "WindowsForms10.Window.8.app.0.141b42a_r9_ad1": ; Multi game instance (ROBLOX)
			; winset, Style, -0x00400000, ahk_id %hWnd%
			; winset, Style, +0x20000, ahk_id %hWnd%
			StyleMenu_Showindow(hWnd, !IsWindowVisible(hWnd))
			winset, Style, 0x80000000, ahk_id %hWnd%
			;WinMinimize , ahk_id %hWnd%
		;	sleep, 500
			return,
		case "#32770":
			;wingetTitle, Title_last,% 4gnd_hwnd	
			if (Title_last = "Information") {
				winactivate, ahk_class #32770
				send n
				return,
			}
			if (Title_last = "Open" || Title_last = "Save As") {
				nnd := hwnd
				gosub, 32770Fix
				return,
			}
			winget PName, ProcessName, ahk_id %hWnd%
			if (PName = "notepad++.exe")       {
				winget, currentstyle, Style, ahk_id %hWnd%
				if (currentstyle = 0x94CC004C) {
					sleep, 580
					winset, Style, -0x00400000, ahk_id %hWnd%
			}	}
			 else, if (PName = "explorer.exe") { ; wingetTitle, tits, ahk_id %hWnd%
				if (tits = "Folder In Use")   {
					WinGetText, testes, ahk_id %hWnd%
					traytip,% "bumcuntface",% "6161 Folder in use mbocks 'tected`n" testes	
					; asas := "AHK_Class WindowsForms10.Window.8.app.0.141b42a_r6_ad1" ; winget, hwnd2, ID , %asas% ; if asas { ;not working and not good ; winclose ahk_id %hwnd2% ; winactivate, ahk_id %fuk% ; sleep, 20 ; send {left} ; send {enter} ; return, ;	}
			}	}				
			return,
		case "Notepad++":
			if !np {
				 sem := "Notepad++ Insert AHK Parameters.ahk - AutoHotkey"
				 if !WinExist(sem) 
					run "C:\Script\AHK\- Script\Notepad++ Insert AHK Parameters.ahk",,hide
				np := True
			}
	;	case "MozillaDropShadowWindowClass": ; copied from regular menus and no joy
	;	{ 		
	;		winset, transparent , 230, ahk_id %hwnd%
	;		winset, ExStyle, 0x00000181, ahk_id %hWnd%
	;		winset, Style, 0x84800000, ahk_id %hWnd%	
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
				winget Style, Style, ahk_id %hWnd%
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
	
	switch pname {
		;ase "RzSynapse.exe":
			;settimer RZ_LOG, -1
		case "GoogleDriveFS.exe":
			msgbox,% Title_last
	}
	
	switch, Title_last {
		case "Razer Synapse Account Login":
			settimer RZ_LOG, -1
		case "Google Drive Sharing Dialog":
			msgbox, 
	}

	EventLogBuffer_Push:
		If !EventLogBuffer
			EventLogBuffer = % EventLogBuffer_Old
		else
			EventLogBuffer=%EventLogBuffer%`n%EventLogBuffer_Old%
		EventLogBuffer_Old:="", clist:="", offset:="", tool:=""
		return,
}

On4ground(Hook_4Gnd, event, hWnd4, idObject, idChild, dwEventThread, dwmsEventTime) {
CRITICAL
	if (ripyoursoulapart && (hWnd4 != HandalDRandal)) {
		msgbox,% ("focus lost " . HandalDRandal)	;Tt(("focus lost " . HandalDRandal))
		HandalDRandal := ""
		ripyoursoulapart := False
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
					msgbox error %a_lasterror%
				gosub, SBAR_Restore
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
		msgbox
			invert_win(hWnd4)		
	}
	switch, Title_last {
		case "Razer Synapse Account Login":
			settimer RZ_LOG, -1
	;case "Google Drive Sharing Dialog":;msgbox
	}
return,	
}

OnFocus(Hook_Focus, event, BK_UN_T, idObject, idChild, dwEventThread, dwmsEventTime) {
CRITICAL
	if (ripyoursoulapart && (hWnd4 != HandalDRandal)) {
		msgbox,% ("focus lost " . HandalDRandal)	;Tt(("focus lost " . HandalDRandal))
		HandalDRandal := ""
		ripyoursoulapart := False
	}
	wingetClass, Class, ahk_id %BK_UN_T% 		
	winget PName, ProcessName, ahk_id %BK_UN_T%
	wingettitle, Title_last, ahk_id %BK_UN_T%	

	if TTFoc
		tooltip FOCUS EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %BK_UN_T%	
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
		case "MozillaDialogClass":
			winget, Style, Style, ahk_id %BK_UN_T%
			If(STYLE = "0x16CE0084") { ;&& (EXSTYLE = 0x00000101)   
				Youtube_Popoutwin := "ahk_id " . BK_UN_T
				wingetPos, X, Y, , EdtH, ahk_id %BK_UN_T%
				WinMove ahk_id %BK_UN_T%,, , , , (EdtH - 39)
				winset, Style, 0x16860084,	ahk_id %BK_UN_T%	
				SLEEP, 500
				SEND, {SPACE}
			}
		case "MozillaDialogClass":
			Escape_TargetWin = ahk_id %Youtube_Popoutwin%
			winget, Style, Style, ahk_id %BK_UN_T%
			winget, exStyle, exStyle, ahk_id %BK_UN_T%
			IF((STYLE = 0x16CE0084) && (EXSTYLE = 0x00000101) ) {
				Youtube_Popoutwin := BK_UN_T
				winclose,
				wingetPos, X, Y, , EdtH, ahk_id %BK_UN_T%
				WinMove ahk_id %BK_UN_T%,, , , , (EdtH - 39)
				winset, Style, 0x16860084, ahk_id %BK_UN_T%	
				MSGBOX %Youtube_Popoutwin% `n Ahk_id %BK_UN_T%
			}
		case "#32770":		
			if (Title_last = "Information") {
				tooltip, c_nt
					send,% N
					return,
}	}		} ; case "CabinetWClass":;{ ;winset, transparent, 130, ahk_id %BK_UN_T%;msgbox;}

OnMsgBox(Hook_MsgBox, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
CRITICAL
	wingetTitle, Title_last, ahk_id %hWnd%	
	if TTmb {
		wingetClass Class, ahk_id %hWnd%
		winget PName, ProcessName, ahk_id %hWnd%
		tooltip MSGBOX EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd%
	}
	If (Title_last = "Information") {
		punny:
		MSG_WIN_TARGET := "Information"
		wingetActiveTitle, Z_Title 
		if (Z_Title = MSG_WIN_TARGET) {
			settimer ororo, -600
			return,
		} else, settimer, Punny
		return,
	
		ororo:
			WinActivate, ,% "Information"
			sleep, 200
			send N
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
	wingettitle, TitleR, ahk_id %hwnd% ; tooltip % Title_Last " " hwnd " " class
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
			winget, RobloxCrashP, PID, ahk_id %hwnd%
			RobloxCR_PID=TASKKILL.exe /PID %RobloxCrashP%
			run %comspec% /C %RobloxCR_PID%,, hide
}	}

OnObjectDestroyed(Hook_ObjDestroyed, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
CRITICAL
	wingetClass, Class, ahk_id %hWnd% 	
	wingettitle, Title_last, ahk_id %hWnd%	
	winget PName, ProcessName, ahk_id %hWnd%	
	if TTds
		tooltip OBJ_DESTROY EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd%
	if pname contains AutoHotkey 
	&& IsWindowVisible( hWnd)
		settimer, quotE, -1
	switch Class { ; case "Autohotkey": { ; if % "C:\Script\AHK\adminhotkeys.ahk in " Title_last ; { ; menu, tray, uncheck, Launch AdminHotkeyz, ; tooltip detected admin hotkey disconnecting ; } ; }
		case "ApplicationFrameWindow","WINDOWSCLIENT":
			wingetTitle, Last_Title, ahk_id %hWnd% 
			if ( Last_Title = "Roblox" ) {	;winClose, ahk_id %hwnd%
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
				MsgBox, 4,%ser% dtect`NnReload AHK Script, Reload %TargetScriptName% now?`nTimeout in 6 Secs, 7
				ifmsgbox yes, 						{
					if (npNameNoExt != "WinEvent")	{
						PostMessage, 0x0111, 65303,,, %TargetScriptName% - AutoHotkey		; Reload WMsg
						traytip, %TargetScriptName%, reloading, 2, 32
						TrayTip[, Title, Text, Seconds, Options]
					}
					else, reload
}	}	}	}	}
return,
; ~Escape:: 				; 	see AdminHotkeys as this should be migrated
; IF Youtube_Popoutwin { 	;	Youtube_Popoutwin (a bad addin)
	; Escape_TargetWin = %Youtube_Popoutwin%
	; if winactive(Escape_TargetWin) {
		; winclose,
		; traytip,% "escapetarget dispatched",% Escape_TargetWin
; }	}   ; return,
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
	
	if (Hook_4Gnd)
		DllCall("UnhookWinEvent", "Ptr", Hook_4Gnd), Hook_4Gnd := 0
	if (Proc4gnd)
		DllCall("GlobalFree", "Ptr", Proc4gnd, "Ptr"), Proc4gnd := 0	
	if (Hook_MsgBox)
		DllCall("UnhookWinEvent", "Ptr", Hook_MsgBox), Hook_MsgBox := 0
	if (ProcMb0x)
		DllCall("GlobalFree", "Ptr", ProcMb0x, "Ptr"), ProcMb0x := 0	
	if (Hook_ObjCreate)
		DllCall("UnhookWinEvent", "Ptr", Hook_ObjCreate), Hook_ObjCreate := 0
	if (Hook_ObjDestroyed)
		DllCall("UnhookWinEvent", "Ptr", Hook_ObjDestroyed), Hook_ObjDestroyed := 0
	if (ProcCreat)
		DllCall("GlobalFree", "Ptr", ProcCreat, "Ptr"), ProcCreat := 0	
	if (ProcDstroyd)
		DllCall("GlobalFree", "Ptr", ProcDstroyd, "Ptr"), ProcDstroyd := 0	
	if (Hook_Focus)
		DllCall("UnhookWinEvent", "Ptr", Hook_Focus), Hook_Focus := 0
	if (ProcF0cus)
		DllCall("GlobalFree", "Ptr", ProcF0cus, "Ptr"), ProcF0cus := 0	
	return, 0
}
; 	A string may be sent via wParam or lParam by specifying the address of a variable. The following example uses the address operator (&) to do this:
; 	SendMessage, 0x000C, 0, &MyVar, ClassNN, WinTitle  ; 0x000C is WM_SETTEXT
Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle) {
	VarSetCapacity(CopyDataStruct, 3*a_PtrSize, 0) 
	SizeInBytes := (StrLen(StringToSend) + 1) * (a_IsUnicode ? 2 : 1)
	NumPut(SizeInBytes, CopyDataStruct, a_PtrSize) 
	NumPut(&StringToSend, CopyDataStruct, 2*a_PtrSize)
	Prev_DetectHiddenWindows := a_DetectHiddenWindows
	Prev_TitleMatchMode := a_TitleMatchMode
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
		msgbox wank, aaa
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
			run %comspec% /C %Target_PID%,, hide
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
	Static Pad := a_PtrSize = 8 ? 4 : 0, WCA_ACCENT_POLICY := 19
	accent_size := VarSetCapacity(ACCENT_POLICY, 200, 0) 
	NumPut(accent_state, ACCENT_POLICY, 0, "Int")
	NumPut(0x77400020, ACCENT_POLICY, 8, "Int")
	VarSetCapacity(WINCOMPATTRDATA, 4 + Pad + a_PtrSize + 4 + Pad, 0)
	&& NumPut(WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0, "Int")
	&& NumPut(&ACCENT_POLICY, WINCOMPATTRDATA, 4 + Pad, "Ptr")
	&& NumPut(accent_size, WINCOMPATTRDATA, 4 + Pad + a_PtrSize, "Uint")
	If !(DllCall("user32\SetWindowCompositionAttribute", "Ptr", hWnd, "Ptr", &WINCOMPATTRDATA))
		return, 0
	return, 1
}

Display_Msg(Text, Display_Msg_Time, X_X) {
	wingetpos, WindowX, WindowY, w_TxT, H_TxT, Roblox
	DMT := Display_Msg_Time, StartTime := a_TickCount, X_X := ""
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
	Time_Elapsed := a_TickCount - StartTime
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
EVENT_4GND := 0x0003, OBJ_FOCUS:=0x8005, OBJ_CREATED := 0x8000, OBJ_DESTROYED := 0x8001, WIN_TARGET_DESC := "Information", MSG_WIN_TARGET := WIN_TARGET_DESC
SETHOOK:="SetWinEventHook"
Hook_4Gnd := DllCall(SETH00k, "Uint", EVENT_4GND, "Uint", EVENT_4GND, "Ptr", 0, "Ptr", (Proc4gnd := RegisterCallback("On4ground", "")), "Uint", 0, "Uint", 0, "Uint", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)
Hook_Focus := DllCall(SETH00k, "Uint", OBJ_FOCUS, "Uint", OBJ_FOCUS, "Ptr", 0, "Ptr",  (ProcF0cus := RegisterCallback("OnFocus", "")), "Uint", 0, "Uint", 0, "Uint", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)
Hook_MsgBox := DllCall(SETH00k, "Uint", 0x0010, "Uint", 0x0010, "Ptr", 0, "Ptr",       (ProcMb0x := RegisterCallback("OnMsgBox", "")), "Uint", 0, "Uint", 0, "Uint", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)
Hook_ObjCreate := DllCall(SETH00k, "Uint", OBJ_CREATED, "Uint", OBJ_CREATED, "Ptr", 0, "Ptr",(ProcCreat := RegisterCallback("OnObjectCreated", "")), "Uint", 0, "Uint", 0, "Uint", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002) 
Hook_ObjDestroyed := DllCall(SETH00k, "Uint", OBJ_DESTROYED, "Uint", OBJ_DESTROYED, "Ptr", 0, "Ptr", (ProcCreat := RegisterCallback("OnObjectDestroyed", "")), "Uint", 0, "Uint", 0, "Uint", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)
return,

FileListStrGen2:
if (oldlist = FileListStr) {
	Loop, parse, FileListStr,% "ø",
	{
		If A_Index = 1
			global action := A_LoopField
		else,
			FileListStr := A_LoopField
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
	}
	return,
} 
return,

SBAR_Restore:
if SBAR_DISABLE {
	if SBAR_2berestored_True {
		run % SidebarPath,, hide, 
		settimer, beads, -1000
		return,
		beads:
		winget, SideBar_Handle, ID, HUD Time
		Sidebar := 1, SBAR_2berestored_True := False
		winset, ExStyle, +0x20, ahk_id %SideBar_Handle%
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
	menu, tray, check, Toggle debug,
} else {
	listlines off
	#KeyHistory 0
	menu, tray, uncheck, Toggle debug,
	dbg	:=	False
}
return,

TT4g:
TT4g := !TT4g
if !TT4g {
	TT4g := True
	menu, tray, check,%   "4ground hook tip",
} else {	
	menu, tray, uncheck,% "4ground hook tip",
	TT4g := False
}
return,

TTFoc:
TTFoc := !TTFoc
if !TTFoc {
	TTFoc := True
	menu, tray, check,%   "focus hook tip",
} else {
	menu, tray, uncheck,% "focus hook tip",
	TTFoc := False
}
return,

TTcr:
TTcr := !TTcr
if !TTcr {
	TTcr := True
	menu, tray, check,%   "obj_create tip",
} else {
	menu, tray, uncheck,% "obj_create tip",
	TTcr := False
}
return,

TTds:
TTds := !TTds
if !TTds {
	TTds := True
	menu, tray, check,%   "obj_destroy tip",
} else {
	menu, tray, 		uncheck,% "obj_destroy tip",
	TTds := False
}
return,

TTmb:
TTmb := !TTmb
if !TTmb {
	TTmb := True
	menu, tray, check,%   "msgbox hook tip",
} else {
	menu, tray, uncheck,% "msgbox hook tip",
	TTmb := False
}
return,

GoGoGadget_Cunt:
winget, Time_hWnd, iD,% "HUD Time",
if errorlevel	
	msgbox,% errorlevel
else, 						; SIDEBAR-CLOCK CLICK-THRU	
	winset, ExStyle, 0x000800A8,% ("ahk_id " . Time_hWnd)		;winset, ExStyle, 0x000800A8, Moon Phase II
return,

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
				msgbox, %XTitle% detected`n%ret_style%`n%ret_exstyle%
				return, 1
	}	}	}
				return, 0
}

runlabel(VarString, hide="")	   { 
	static hidestatic := "Hide"
	if hide            ;           "Mag_CleanME_PLZz\/dwmaccentfix\/PConfig\/wmp_matt_run" etc
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

midiScriptR:
run % midiScriptR
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
	msgbox error %a_lasterror%
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

SaveGUISubmit: 	; keyname will contain unique information as a search key and allow for other combinations such as different classnamed windows for the same target app without duplication
gui, SaveGuI:Submit
return,

PushNewSave: 	
if TProcName
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

;~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`

RegReads: ; -=-==-=====-= REG READZZZZ =-=-=----==--@~@'''~~--__
RegRead, Log1RZ, HKEY_CURRENT_USER\Software\_Mouse2Drag\Login , rz
if Log1RZ {
	loop, parse, Log1RZ, `,
	{
		if (a_index = "1")
			Log1_RZ := A_LoopField
		if (a_index = "2")
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
		Style_ClassnameList2 := Style_ClassnameList2 . value2 . "‡"	
		retpos := RegExMatch(A_LoopRegName, "^0.{9}" , ret_style, p0s := 1)
		retpos := RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , ret_exstyle, p0s := 1)
		Array_LClass.push(		ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
}	}
return,

;~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`

getwintxt:
WinGetText, wintxt , ahk_id %OutputVarWin%
msgbox,% wintxt
return,

Open_script_folder:
e = explorer /select, %a_ScriptFullPath%
tooltip % a_ScriptFullPath
run %comspec% /c %e%,,hide,
settimer, tooloff, -1222
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

filechk_msstyles_themefile:
theme_test_File1      := fileexist("c:\windows\resources\themes\test.theme")
if !(theme_test_File1 := fileexist("c:\windows\resources\themes\test.theme"))
or !(theme_test_File2 := fileexist("c:\windows\resources\themes\test\test.msstyles"))
	msgbox,% "Test.Msstyles MiA"
else,
	traytip,% "File attrib query Sux_cesS . fulLy confirmed ",% "Test.msstyles and Test.theme present & correct! OK" 
return,

ApplyMSSTYLES: 	 ; 	or Basic / Aero
cmd=
(LTrim
   C:\Windows\system32\rundll32.exe C:\Windows\system32\shell32.dll,Control_RunDLL C:\Windows\system32\desk.cpl desk,@Themes /Action:OpenTheme /file "C:\Users\ninj\AppData\Local\Microsoft\Windows\Themes\p00p.theme"
)
return,

quotEI:
q_dlim	:= 	42
loop, 6
	sp 	:= 	(" " .  sp . sp)
kVon    :=  ( "`n" . sp . "Kurt Vonnegut" . q_dlim )
bujub 	:=  ( "`n" . sp . "Buju Banton" .   q_dlim )
loop, parse, qstr,% q_dlim, 
	quotes[quote_MAX_INDEX] := 	A_loopfield				; quote_MAX_INDEX := A_index working
return,

quotE:
randOm, rNd, 1, quotes[quote_MAX_INDEX] 				; quote_MAX_INDEX working
if !Quoting {
	Quoting := True
	tooltip,% 	Quotes[rNd], (XCent-240), (YCent-40),2  ; replace with stringcount of rNd result, delimited with newlines; for x/y
	settimer, 	Qoff2, -3000
} else, settimer, Quote, -3000
return,

Qoff2:
tooltip,,,,2
Quoting := False
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

NewTrayMenuParam( LabelPointer = "", Title = "", Icon = "" ) {
	if Title                                                 {
		MenuLablTitlAr["LabelPointer"]:= Title
		menu,tray,add,% MenuLablTitlAr["LabelPointer"],% LabelPointer
		if !Icon
			return, 1
		else, menu, tray, Icon,% Title ,% Icon
		return, 2
	} else, if Icon
		menu, tray, icon,% Icon
	else, return, 0
	return, 3
}

32770Fix:                          ; "Save as" & "Open" Dialogs called from the eventHook.
winwaitActive,% "ahk_class #32770" ; *takes some time to visually materialise ui hence the previous.
settimer, PaintItBlack,  -1400    ; "Active" is not actually ready to be drawn over.
return,
		  PaintItBlack:
N_  := Gdip_Startup()
dc  := GetDC(nnd)
mDC := Gdi_CreateCompatibleDC(0)
mBM := Gdi_CreateDIBSection(mDC, 1, 1, 32) 
oBM := Gdi_SelectObject(mDC, mBM)
DllCall("gdi32.dll\SetStretchBltMode",  "Uint", dc, "Int", 5)
DllCall("gdi32.dll\StretchBlt",         "Uint", dc, "Int", 0, "Int", 0, "Int", Desk_Wi , "Int", Desk_Hi, "Uint", mdc, "Uint", 0, "Uint", 0, "Int",	1, "Int",	1, "Uint", "0x00CC0020")
Gdip_ShutdownI(N_)
return,

LAbel_Ladder:
mattdwmrun2:
test_move:
adminHotkeyzRun: ; menu, tray, check,% "Launch " A_ThisLabel ; swap wih a dictionary for titles
Mag_:
zinout: 
CleanME_PLZz:
dwmaccentfix:
PConfig:
wmp_matt_run:
m2drag_run:
YT_DL:
			
LABElA((    Your_Label_Sir := A_thislabeL   ))
return,
			
LABElA(Tingz) 	 {
	switch Tingz {
		case "adminHotkeyzRun":
			settimer, reload_orload_admhk, -1
		default:
			run,% %Tingz%
}	}
			
check_ADMHOTKEY() {
	if (wineXist("ahk_class AutoHotkey", ADM_wTtL)) { ;"adminhotkeys.ahk - AutoHotkey"
		return, 1
		}
	return, 0
}
			
reload_orload_admhk:
if !(check_ADMHOTKEY()) 
	run,% adminHotkeyzRun
else, settimer, admhotkey_reload_, -1
return,
			
admhotkey_reload_:
PostMessage, 0x0111, 65303,,,% "adminhotkeys.ahk - AutoHotkey"
return
		
Open_ScriptDir() ; not called here but this is enough to invoke its label(s)
		
Stylemenu_init:  ; tooltip % "Analyzing, please wait"
TargetHandle := "", style:=""
if Dix
	menu, F, DeleteAll
Dix := True
MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
TargetHandle := ("ahk_id " . OutputVarWin)
wingetTitle, TargetTitle,% TargetHandle
if !TargetTitle 
	return,
winget, PName,    ProcessName,% TargetHandle
winget, Style2,   Style,% 		TargetHandle
winget, ExStyle2, ExStyle,% 	TargetHandle

MainMenu:
menu, F, add, %PName%, donothing,
menu, F, Disable, %PName%
menu, F, add,% sysmenu, toggle_sysmenu
if (Style2 & 0x00080000)
	menu, F, check,% doom_array[%SysMenu%]
else	menu, F, uncheck,% SysMenu
Menu	  F, 	add,% Clickthru, toggle_Clickthru
if (ExStyle2 & 0x00000001)
	 menu, F, 	check,% Clickthru
else, menu, F, 	uncheck,% Clickthru
Menu	  F, 	add,% AppWindow, toggle_AppWindow
if (ExStyle2 & 0x00040000)
	menu,  F, 	check,% AppWindow
else, menu, F, 	uncheck,% AppWindow
goto, Sumenu_items

Submenus:
menu, F,	add, Frame / & X Controls, 	:S1
menu, F,	add, Scrollbars, 			:S2
menu, F,	add, Layout, 				:S3
goto, OtherMenus

Sumenu_items:
menu, 	S1, 	add, DLG Frame, toggle_DLGFRAME
if (Style2 & 0x00400000)
	 menu, 	S1, check, DLG Frame
else, menu, 	S1, uncheck, DLG Frame
menu, S1, add, THICK Frame, toggle_thickframe
if (Style2 & 0x00040000)
	 menu, 	S1, 	check, THICK Frame,
else, menu, 	S1, 	uncheck, THICK Frame
menu, S1, add, Modal Frame, toggle_Modalframe
if (ExStyle2 & 0x00000001)
	 menu, 	S1, 	check, Modal Frame,
else, menu, 	S1, 	uncheck, Modal Frame
menu, S1, add, Static edge, toggle_staticedge
if (ExStyle2 & 0x00020000) 
	 menu, 	S1, 	check, Static edge,
else, menu, 	S1, 	uncheck, Static edge
menu, S1, add, %Maxbox%, toggle_Maxbox
if (Style2 & 0x00010000)
	 menu, 	S1, 	check, %Maxbox%
else, menu, 	S1,	uncheck, %Maxbox%
menu, S1, add, %MinBox%, toggle_MinBox
if (Style2 & 0x00020000)
	 menu, 	S1, check, 	%MinBox%
else, menu, 	S1, uncheck, 	%MinBox%
menu, S2, add, HScroll, toggle_hscroll
if (Style2 & 0x00100000)
	 menu, 	S2, check, 	HScroll 
else, menu, 	S2, uncheck, 	HScroll 
menu, S2, add, VScroll, toggle_hscroll
if (Style2 & 0x00200000)
	 menu, 	S2, check, 	VScroll 
else, menu, 	S2, uncheck, 	VScroll 
menu, S2, add, %LeftScroll%, toggle_LeftScroll
if (ExStyle2 & 0x00004000)
	 menu, 	S2, check, 	%LeftScroll%
else, menu, 	S2, uncheck, 	%LeftScroll%
menu, S3, add, %RightAlign%, toggle_RightAlign
if (ExStyle2 & 0x00001000)
	 menu, 	S3, check, 	%RightAlign% 
else, menu, 	S3, uncheck, 	%RightAlign%
menu, S3, add, %RightoLeft%, toggle_RightoLeft
if (ExStyle2 & 0x00002000)
	 menu, 	S3, 	check, 		%RightoLeft%
else, menu, 	S3, 	uncheck, 	%RightoLeft%
gosub, Submenus
return,

othermenus: ; below submenus
menu, 	F, 	add, m2drag bypass, toggle_m2drag_bypass
menu, 	F, 	Icon, m2drag bypass,% mouse24
menu, 	F, 	add, Get window text , getwintxt
menu, 	F, 	add, %Save% , Savegui
gosub, StyleMenu_Show
return,
StyleMenu_Show:
tooltip
menu, F, Show
return,  

;`~`~`~`~		~`~`~`~		~`~`~`~		~`~`~`  ~`~`~` ~`~`~	`~` ~`~ `~  ~`~`	~`~	`~`~`~	`~	`~`

MenuP:
loop, parse, labellist, /,
	MenuLablAr[A_index]:= A_loopfield
loop, parse, titlelist, /,
	MenuLablTitlAr[MenuLablAr[A_index]] := A_loopfield
for index, element in MenuLablTitlAr
	menu, tray, add,% element,% index
return,

test_icons:
mti := (NewTrayMenuParam("", "Launch PowerConfig", ((icn := "C:\Icon\") . "20\alien.ico") )), mti := (NewTrayMenuParam("", "Launch MattDWM", (icn . "24\dwm24.ico") )), mti := (NewTrayMenuParam("", "Launch YouTube_DL", (icn . "24\YouTube.ico") )), mti := (NewTrayMenuParam("", "DWM_Axnt_fix", (icn . "24\refresh.png") )), mti := (NewTrayMenuParam("", "LoadAeroRegKeyz", (icn . "24\refresh.png") )), mti := (NewTrayMenuParam("", "Launch M2Drag", ((ScpW := "C:\Script\AHK\Working\") . "Mouse242.ico") )), mti := (NewTrayMenuParam("", "Launch screen clean!", (icn . "24\AF_Icon.ico") ))
mti := ""
return, 

;`~					      ~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`
;`~					      ~`~`~`~`~`~`															  ~`~`
;`~					      ~`~`~`~`~`~`															  ~`~`
;`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`															  ~`~``~`~`~`~`~
;`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`															  ~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~
;`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`															  ~`~``~`~`~`~`~					`~
;`~						  ~`~`~`~`~`~`															  ~`~								  []
;`~						  ~`~`~`~`~`~`															  ~`~
;`~						  ~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~

;~~~~~~~^^; 
 Menu_Tray: ;=---- `~
;~~~~~~~^^; 		[]

menu, 	tray, 	NoStandard	; menu, 	tray, 	icon, 	% TrayIconPath
menu, 	tray, 	Icon, 	Context32.ico
menu, 	tray, 	add, 	Open Script Folder, Open_ScriptDir
menu, 	tray, 	Standard

gosub, 	MenuP 				; add the rest... /;/ add your own ; NewTrayMenuParam("LabelPointer", "Title", "Icon")
gosub, 	test_icons 	
return,

;	^-=___=-^				^-=___=-^				^--___=-^   ^   ~   ~   _   ¬   ¬   ¬   ¬   ¬   ¬   ¬   ¬   _
Varz: ; 01010101010 ' ` ' `' `':C\Root\`'`'''`'      `''`0101'`'`'```''`'`'     ``'010101`''`'0xFFEEDD`'`'`'`'``'`'     			`''`''KILL!'`'`' '`''`'``'' `'`''`''` ''`'` '`''` `''` `''` `'` 
loop, parse,% glob4Lz := ("AF/AF2/AutoFireScript/MyScrpt/dbgtt/AutoFireScript2/TargetScriptTitle/TargetScriptTitle2/AHK_Rare/SidebarPath/AF_Delay/SysShadowStyle_New/SysShadowExStyle_New/toolx/offsett/XCent/YCent/starttime/text/X_X/Last_Title/autofire/RhWnd_old/MouseTextID/DMT/roblox/toggleshift/Norm_menuStyle/Norm_menuexStyle/Title_Last/Title_last/dcStyle/classname/tool/tooly/EventLogBuffer_Old/Roblox_hwnd/Time_Elapsed/KillCount/SBAR_2berestored_True/Sidebar/TT4g/TTFoc/TTcr/TTds/TTmb/dbg/TClass/TTitle/TProcName/delim/delim2/TitleCount/ClassCount/ProcCount/style2/exstyle2/ArrayProc/ArrayClass/ArrayTitle/Array_LProc/Array_LTitle/Array_LClass/Style_ClassnameList2/Style_procnameList2/Style_wintitleList2/Youtube_Popoutwin/Script_Title/np/m2dstatus/crashmb/8skin_crash/OutputVarWin/F/s1/s2/s3/FileListStr/oldlist/FileCount/ADELIM/hTarget/hTargetprev/hgui/xPrev/yPrev/wPrev/hPrev/logvar/ADM_wTtL/triggeredGFS/Matrix/SysMenu/Maxbox/MinBox/LeftScroll/ClickThru/RightAlign/RightoLeft/AppWindow/Save/Reset/midiScriptR/test_move/mattdwmrun/Quoting/titlelist/MenuLablAr/MenuLablTitlAr/labellist/Desk_Wi/Desk_Hi/FileListStr_Ar/hTargetPrev/wPrev/hPrev/xPrev/yPrev/hidegui/q_dlim/quotes/HandalDRandal/Hook_4Gnd/Hook_MsgBox/Hook_ObjCreate/Hook_ObjDestroyed/Hook_Focus/ripyoursoulapart/Hook_4GndProc4gnd/Hook_MsgBox/ProcMb0x/Hook_ObjCreate/ProcCreat/Hook_ObjDestroyed/ProcDstroyd/Hook_Focus/ProcF0cus/nnd"),% "/",
	global (%A_loopfield%)
glob4Lz := "" ;	^-=___=-^				^-=___=-^				^-=___=-^				^-=___=-^				^-=___=-^			
loop, 22, 
	gosub,  GDIpInvertVars  ;-=-=-;'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'`'```'`'``''`
								  ;`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'``''`
Matrix 	:=(	"-1	|0	|0	|0	|0|"  ;'``''`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'``''`
.           "0	|-1	|0	|0	|0|"  ;``''`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'``''`
.           "0	|0	|-1	|0	|0|"  ;`''`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'``''`
.           "0	|0	|0	|1	|0|"  ;''`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'``''`
.           "1	|1	|1	|0	|1" ) ;'`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'`'``''`'`'''`
;"!!! vARi4bl3z !!!!" ...		 ^-=___=-^			>>>>>>>>>>>>
																;???
RegRead InstallDir, HKLM\SOFTWARE\AutoHotkey, InstallDir        ;  	 ~@~peww~@~	
AhkPath := ErrorLevel ? "" : InstallDir "\AutoHotkey.exe"
;   mattdwmrun:= ((Autoit3path := "C:\Program Files (x86)\AutoIt3\AutoIt3_x64.exe") . " " .  "C:\Script\autoit\_MattDwmBlurBehindWindow.au3") 
mattdwmrun2	:=	"C:\Script\autoit\_MattDwmBlurBehindWindow.lnk" ;			^^^	Wrong start dir variable 1nce launched 	^	^	^
test_move	:= 	"C:\Users\ninj\DESKTOP\winmove_test.ahk"
SidebarPath := 	"C:\Program Files\Windows Sidebar\sidebar.exe"
Path_PH 	:= 	"C:\Apps\Ph\processhacker\x64\ProcessHacker.exe"
AHK_Rare 	:= 	((MyScrpt := "C:\Script\AHK") . "\- Script\AHK-Rare-master\AHKRareTheGui.ahk")
CleanME_PLZz:= 	MyScrpt . "\white_full-screen_gui.ahk"	

qstr := (" ""And I urge you to please notice when you are happy,`nand exclaim or murmur or think at some point,`n 'If this isn't nice, I don't know what is.'"" " . kVon .	" ""Everything was beautiful and nothing hurt."" " . kVon .	" ""Those who believe in telekinesis, raise my hand."" " . kVon . " ""We are what we pretend to be, so we must be careful about what we pretend to be."" " . kVon .	" ""I tell you, we are here on Earth to fart around, and don't let anybody tell you different."" " . kVon . " ""Tiger got to hunt,bird got to fly,`nMan got to sit and wonder 'why, why, why?'"" " . kVon " ""Tiger got to sleep, bird got to land,`nMan got to tell himself he understand."" " . kVon . " ""While elephants play the grass gets trampled."" " . bujub )

adminHotkeyzRun :=  ((sched_tsk	     :=  "C:\Windows\system32\schtasks.exe /run /tn ")         .  "adminhotkeys.ahk_407642875") 	; HideMe
PConfig 		:= 	(sched_tsk       .   "cmd_output_to_msgbox.ahk_407642875")														; HideMe
zinout 			:= 	((ahk_exe_u64    :=  InstallDir . "\AutoHotkeyU64.exe ") .  MyScrpt . "\Z_MIDI_IN_OUT\z_in_out.ahk") 	; HideMe
YT_DL 			:= 	((ahk_exe_u64uia :=  InstallDir . "\AutoHotkeyU64_UIA.exe ") .  ScpW . "YT.ahk")		 	  			  	 	; HideMe
m2drag_run 		:= 	ahk_exe_u64Uia   . MyScrpt . "\Working\M2Drag.ahk"															; HideMe
Mag_ 			:= 	(ahk_exe_64	 :=  AhkPath . " " . ScpW . "M2DRAG_MAG.AHK")                                                       ; HideMe
dwmaccentfix 	:= 	ahk_exe_64   	 . 	MyScrpt . "\__TESTS\dwm_accentcolour.ahk"											    ; HideMe
wmp_matt_run 	:= 	ahk_exe_u64 	 .	MyScrpt . "\Z_MIDI_IN_OUT\wmp_Matt.ahk"                  								; HideMe
midiScriptR 	:= 	( InstallDir . "AutoHotkeyU64.exe " . MyScrpt . "\Z_MIDI_IN_OUT\z_in_out.ahk")                         		; HideMe
ADM_wTtL 		:= 	MyScrpt . "\adminhotkeys.ahk - AutoHotkey v1.1.33.10"
AF := (MyScrpt . af_1), AF2 := (MyScrpt . Bun_), AutoFireScript := BF, AutoFireScript2 := BF2 , TargetScriptTitle := (AutoFireScript . " ahk_class AutoHotkey"), TargetScriptTitle2 := (AutoFireScript2 . " ahk_class AutoHotkey"), AF_Delay := 10, SysShadowStyle_New := 0x08000000, SysShadowExStyle_New := 0x08000020, toolx := "-66", offsett := 40, delim := "Þ", delim1 := "µ", delim2 := "»",KILLSWITCH := "kill all AHK procs.ahk", mouse24 := "C:\Script\AHK\Working\mouse24.ico", BF := "Roblox_Rapid.ahk", BF2 := "Roblox_Bunny.ahk"

test := (Style2 . "»" . exStyle2 . "»" . "µ" . savenew_PNm . "µ" . save_new_Title . "µ" .  "µ" . save_new_Class) ; konkat the d-lims mw 202

titlelist := "4ground hook tip/focus hook tip/obj_create tip/obj_destroy tip/msgbox hook tip/Toggle debug/Toggle Sidebar off/DWM_Axnt_fix/LoadAeroRegKeyz/Launch PowerConfig/Launch MattDWM/Launch M2Drag/Launch WMP_MATT/Launch midi_in_out/Launch adminHotkeyzRun/Launch YouTube_DL/Launch test_move/Launch screen clean!"

labellist := "TT4g/TTFoc/TTcr/TTds/TTmb/Toggle_dbg/Toggle_sbar/dwmaccentfix/AeroTheme_Set/pconfig/mattdwmrun2/m2drag_run/wmp_matt_run/zinout/adminHotkeyzRun/YT_DL/test_move/CleanME_PLZz"

test_aero_style :=	"C:\Windows\Resources\Themes\Aero\Aero.msstyles"
test_aero_style2:=	"%SystemRoot%\resources\Themes\Aero\Aero.msstyles"
test_aero_theme :=	"C:\Windows\Resources\Themes\Aero.theme"

_x := ",,"
_y := "<<>>"

stringaling:=("SysMenu" . _y . "Title (+ & X Conrols) (SysMenu)" . _x . "Maxbox" . _y . "Maximise Button (□)" . _x . "MinBox" . _y . "Minimise Button (_)" . _x . "LeftScroll" . _y . "Left Scroll Orientation" . _x . "ClickThru" . _y . "Click-through" . _x . "RightAlign" . _y . "Generic Right-alignment" . _x . "RightoLeft" . _y . "Right-to-Left reading" . _x . "AppWindow" . _y . "Taskbar Item (not 100%)" . _x . "Save" . _y . "Save window style preferences" . _x . "Reset" . _y . "Reset window style preferences")

loop, parse, stringaling,% _x, 
	loop, parse, a_loopfield,% _y, 
		switch index {
			case 1:
				my_index := a_loopfield
			case 2:
				doom_array[my_index] := a_loopfield
		}
	
HKCUCurVer	:= 	"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion" 
stylekey	:= 	"HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles"
wintitlekey	:= 	stylekey . "\wintitle"
procnamekey	:= 	stylekey . "\procname"
classnamekey:= 	stylekey . "\classname"
af_1 		:= 	"\" . BF
Bun_ 		:= 	"\" . BF2
ArrayProc	:= 	[]
ArrayClass	:= 	[]
ArrayTitle	:= 	[]
Array_LProc	:= 	[]
Array_LTitle:= 	[]
Array_LClass:= 	[]
MenuLablAr 	:=	[] 
MenuLablTitlAr:=[] 
FileListStr_Ar:=[]
quotes 		:= 	[]
	
GDIpInvertVars:
global  ("hChildMagnifier" . a_index) 
global  ("hgui" . A_Index)
global  ("HWNDhgui" . A_Index)
return,

init_matt:
InitLabelOrder := "Varz>Menu_Tray>RegReads>Hooks>quotEI>reload_orload_admhk>Main"
loop, parse, InitLabelOrder, ">",
	gosub,% A_loopfield
return,

donothing:
return,

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
		 
 ; Uncomment the appropriate line below or leave them all commented to
;   reset to the default of the current build.  Modify as necessary:
; codepage := 0        ; System default ANSI codepage
; codepage := 65001    ; UTF-8
; codepage := 1200     ; UTF-16
; codepage := 1252     ; ANSI Latin 1; Western European (Windows)
; if (codepage != "")
    ; codepage := " /CP" . codepage
; cmd="%A_AhkPath%"%codepage% "`%1" `%*
; key=AutoHotkeyScript\Shell\Open\Command
; if A_IsAdmin    ; Set for all users.
    ; RegWrite, REG_SZ, HKCR, %key%,, %cmd%
; else,            ; Set for current user only.
    ; RegWrite, REG_SZ, HKCU, Software\Classes\%key%,, %cmd%
	;----;
	
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
