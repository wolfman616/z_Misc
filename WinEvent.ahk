#Singleinstance,		Force
ListLines, 				Off 
coordMode, tooltip,		screen
DetectHiddenWindows, 	on
DetectHiddenText, 		On
SetTitleMatchMode, 		2	;	SetTitleMatchMode Slow
setWorkingDir, 			%A_ScriptDir%
SetBatchLines, 			-1
setWinDelay, 			-1
#Persistent
#NoEnv 		
; ===>" binds " below line 500

gosub, init_mate
Main:
wm_allow()
settimer,	adminHotkeyz,	-1440
gui, +HWNDhgui +AlwaysOnTop
DllCall("GetWindowBand", "ptr", hgui, "uint*", band)
gui, Destroy
hgui := ""

return

#M::  			;		ALTgr + Right Arrow
+#M::	
Mag_Path := "C:\Program Files\Autohotkey\Autohotkey.exe C:\Script\AHK\Working\M2DRAG_MAG.AHK", 
run % Mag_Path,			;			^ ^ 	above not working 	^ ^
return
OnObjectCreated(Hook_ObjCreate, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
CRITICAL
	wingetClass Class, ahk_id %hWnd%
	gosub, Manual_Classhook_objCreated
	wingettitle, Title_last, ahk_id %hWnd%
	winget PName, ProcessName, ahk_id %hWnd%
	;logvar := (logvar . "`r`n" . ( PName . "e" . Class . "e" . Title_last ))

	if TTcr
		tooltip OBJ_CREATE EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd4%
	StyleDetect(hWnd, Style_ClassnameList2,	Class, 		Array_LClass) 
	StyleDetect(hWnd, Style_wintitleList2,	Title_last, Array_LTitle) 
	StyleDetect(hWnd, Style_procnameList2,	PName, 		Array_LProc) 
	Manual_Classhook_objCreated:
	switch Class {
		case "OperationStatusWindow":
		{	;if( tits = "Folder In Use" ) {;;asas := "AHK_Class WindowsForms10.Window.8.app.0.141b42a_r6_ad1";;winget, hwnd2, ID , %asas%;;if 		asas;;winclose ahk_id %hwnd2%;;}
			wingetTitle, tits , AHK_ID %hWnd%
			tooltip Preparing...
			settimer, tooloff, -128
			return
		}
		case "MozillaDialogClass":
		{
			winget, Style, Style, ahk_id %hwnd%
			winget, exStyle, exStyle, ahk_id %hwnd%
			IF((STYLE = 0x16CE0084) && (EXSTYLE = 0x00000101) ) {
				MSGBOX P
				winSet, Style, 	0x16860084, ahk_id %hwnd%
			}
		}
		case "NotifyIconOverflowWindow","DropDown","TaskListThumbnailWnd","Net UI Tool Window Layered":
		{
			winSet, ExStyle, 	^0x00000100, ahk_id %hWnd%
			winSet, Style, 		0x94000000, ahk_id %hWnd%
			return
		}
		case "MMCMainFrame":
		{
			sleep 700
			ControlGet, cutrlhand, Hwnd,, SysTreeView321, ahk_id %hWnd%
			winSet, Style, 		+0x00000202, ahk_id %cutrlhand%
			return
		}
		case "TaskListThumbnailWnd":	
		{
			SetAcrylicGlassEffect(hWnd)
			return
		}
		case "CabinetWClass":
		{
			sleep, 700
			ControlGet, cutrlhand, Hwnd,, SysTreeView321, ahk_id %hWnd%
			;winSet, Style, 		+0x00008000, ahk_id %cutrlhand%
			; else
			sleep, 1200
			winSet, Style, 		-0x00000004,	ahk_id %cutrlhand%
			winSet, Style, 		-0x00100000, 	ahk_id %cutrlhand%
			SendMessage, tvmX,0, 0x00003C75,, 	ahk_id %cutrlhand% 	 ;TVM_SETEXTENDEDSTYLE := 0x112C = tvmX ;; 0x00000020 auto h scroll
			return
		}
		case "RegEdit_RegEdit","FM":
		{
			ControlGet, ctrlhand, Hwnd,, SysListView321, ahk_id %hWnd%
			SendMessage 0x1036, 0, 0x00000020,, ahk_id %ctrlhand% 	 ; enable row select (vs single cell) 	LVM_SETEXTENDEDLISTVIEWSTYLE := 0x1036
			ControlGet, ctrlhand2, Hwnd,, SysTreeView321, ahk_id %hWnd%
			winSet, Style, +0x00000200, ahk_id %ctrlhand2%

			return
		}
		case "7 Sidebar":
		{
			winget, Time_hWnd, iD, ahk_class 7 Sidebar
			winSet, ExStyle, 	0x000800A8, HUD Time, ahk_id %Time_hWnd%
			winSet, ExStyle, 	0x000800A8, Moon Phase II
			sidebar := True
			return
		}
		case "ApplicationFrameWindow","Chrome_WidgetWin_1","WINDOWSCLIENT":
		{
			;wingettitle, Title_Last, ahk_id %hwnd%			;	tooltip % Title_Last " " hwnd " " class
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
					}
				}
				
				if (m2dstatus != "not running or paused"	) && (m2dstatus !=False) {
					PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey
					PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey	
				}
				if(m2dstatus = False) {
					settimer, m2_Status_Req36, -5000
					return
					m2_Status_Req36:
					if (m2dstatus != "not running or paused"	) && (m2dstatus !=False) {
						PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey		
						PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey		
					}
					return
				}
			}
			return
		}
		case "ListBox","WMPMessenger":
		{
			return
		}	
		case "MsiDialogCloseClass":
		{
			if id := winexist("ahk_class MsiDialogCloseClass")
				txt := "dialog", c_ntrolName := "Static1"
			if (mainc_nt = WinExist("ahk_exe msiexec.exe",txt)) {
				ControlGet, c_ntHandle, hWnd ,,%c_ntrolName% , ahk_id %mainc_nt%
				StyleMenu_Showindow( c_ntHandle, !IsWindowVisible( c_ntHandle))
				tooltip ProcdEvent: MsiDialogCloseClass`n.%id% yes %mainc_nt% main hwnd`n.%c_ntHandle%
			}
			return
		}	
		; case "SysShadow":
		; {
			; if !DWMBLUR
				; winSet, transparent , 1, ahk_id %hwnd%
			; return
		; }
		case "WindowsForms10.Window.8.app.0.141b42a_r9_ad1": ; Multi game instance (ROBLOX)
		{			
			; winSet, Style, -0x00400000, ahk_id %hWnd%
			; winSet, Style, +0x20000, ahk_id %hWnd%
			StyleMenu_Showindow(hWnd, !IsWindowVisible(hWnd))
			winSet, Style, 0x80000000, ahk_id %hWnd%
			;WinMinimize , ahk_id %hWnd%
		;	sleep 500
			return
		}
		case "#32770":
		{		
			;wingetTitle, Title_last, ahk_id %hWnd4%	
			if (Title_last = "Information") {
				winactivate, ahk_class #32770
				send n
				RETURN
			}
			winget PName, ProcessName, ahk_id %hWnd%
			if (PName = "notepad++.exe") {
				winget, currentstyle, Style, ahk_id %hWnd%
				if (currentstyle = 0x94CC004C) {
					sleep 580
					winSet, Style, -0x00400000, ahk_id %hWnd%
				}
			}
			 else if (PName = "explorer.exe") {
				;wingetTitle, tits, ahk_id %hWnd%
				if (tits = "Folder In Use") {
				WinGetText, testes, ahk_id %hWnd%
				msgbox % "6161 Folder in use msgb tected`n"testes
					; asas := "AHK_Class WindowsForms10.Window.8.app.0.141b42a_r6_ad1"
					; winget, hwnd2, ID , %asas%
					; if asas { 			;not working and not good
						; winclose ahk_id %hwnd2%
						; winactivate, ahk_id %fuk%
						; sleep 20
						; send {left}
						; send {enter}
						; return
				;	}
				}				
		 	}
			return
		}
		case "Notepad++":
		{
			if !np {
				 sem := "Notepad++ Insert AHK Parameters.ahk - AutoHotkey"
				 if !WinExist(sem) 
					run "C:\Script\AHK\- Script\Notepad++ Insert AHK Parameters.ahk",,hide
				np := True
			}
			}
		;	case "MozillaDropShadowWindowClass":
		;	{ 		;		copied from regular menus and no joy
		;		winSet, transparent , 230, ahk_id %hwnd%
		;		winSet, ExStyle, 0x00000181, ahk_id %hWnd%
		;		winSet, Style, 0x84800000, ahk_id %hWnd%	
		;		SetAcrylicGlassEffect(hWnd) 
		;		return
		;	} 
		; case "Autohotkey":
		; {
			; if % "C:\Script\AHK\adminhotkeys.ahk in " Title_last
			; {
				; menu, tray, check, Launch AdminHotkeyz,
				; tooltip detected admin hotkey connecting
			; }
		; }
		default: 
		{
			if (IsWindow(hWnd)) {
				winget Style, Style, ahk_id %hWnd%
				if Style & 0x10000000 
				{
					if !Tool || if Tool=20
						Tool := 1
					else 
						Tool := tool + 1
					offset:= offsett 
					if !EventLogBuffer_Old {
						EventLogBuffer_Old=%class%`n
					} else {
						clist=%EventLogBuffer_Old%%class%`n
						EventLogBuffer_Old = % CLIST
					}		;		tooltip, %tool% %clist%, %toolx%, %tooly%
					tooly = % offset	
					classname=%Class%`n
					settimer, EventLogBuffer_Push, -4000
				}
			}
			return
		}		
		return 		;	 	end case	
		}	
		
		switch pname {
		case "RzSynapse.exe":
			settimer RZ_LOG, -1
		
		case "GoogleDriveFS.exe":
		msgbox Title_last
		}
	switch, Title_last {
	case "Razer Synapse Account Login":
				settimer RZ_LOG, -1

	case "Google Drive Sharing Dialog":
		msgbox

	}

	EventLogBuffer_Push:
		If !EventLogBuffer
			EventLogBuffer = % EventLogBuffer_Old
		else
			EventLogBuffer=%EventLogBuffer%`n%EventLogBuffer_Old%
		EventLogBuffer_Old:="", clist:="", offset:="", tool:=""
		return
}

On4ground(Hook_4Gnd, event, hWnd4, idObject, idChild, dwEventThread, dwmsEventTime) {
CRITICAL
	4gnd_hwnd =% "ahk_id " hWnd4
	wingetClass Class, % 4gnd_hwnd
	wingettitle, 	Title_last, ahk_id %hWnd4%	
		winget,			PName, ProcessName, ahk_id %hWnd4%
		if TT4g {
	
		tooltip, 			4Ground EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd4%
	}
	switch Class {
		case "#32770":	; msg box 
		{ 
			wingettitle, Title_last, % 4gnd_hwnd	
			
			if (Title_last = "Roblox Crash") {
				if !crashmb
					crashmb := 1
				else crashmb := crashmb + 1
				winget, RobloxCrash_PID, PID , % 4gnd_hwnd
				Roblox_PID=TASKKILL.exe /PID %RobloxCrash_PID%
				run %comspec% /C %Roblox_PID%,, hide
				if winexist("ahk_exe robloxplayerbeta.exe") 
					run C:\Apps\Kill.exe robloxplayerbeta.exe,, hide	; 	run C:\Apps\Kill.exe Multiple_ROBLOX.exe,, hide
				if winexist("ahk_pid %Roblox_PID%")
					msgbox error %a_lasterror%
				gosub, SBAR_Restore
			} else
			
			if (Title_last = "Information") {
				;MessageBoxKill(hWnd4)
				WinActivate, ahk_class #32770
				send n
				settimer, tooloff, -10000
			}
			return
		} 		; 		;		 else 	other clases
		case "ApplicationFrameWindow","Chrome_WidgetWin_1","WINDOWSCLIENT":
		{
			ttt := "M2Drag.ahk - AutoHotkey", result := Send_WM_COPYDATA("status",ttt)
			wingettitle, Title_last, ahk_id %hWnd4%	
			;if (Title_last != "Roblox")
			;	TOOLTIP
			ttt := "M2Drag.ahk - AutoHotkey", result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
			settimer, tooloff, -2222
			if roblox {
				gethandle_roblox() 
				settimer, m2_Status_check, -4000
				return
				m2_Status_check:                                                                                                                                                                                

				if( m2dstatus != "not running or paused"	) {
					PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey	; 	65306 = Pause
					PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey	; 	65305 = Suspend
				}
				m2dstatus := False
			}
			return
		}

		Default:
		{ 	
			ttt := "M2Drag.ahk - AutoHotkey", result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
			if (result = "FAIL") {
				settimer, m2_Status_Req, -1000
				return
				
				m2_Status_Req:
				result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
				return
			}
			else if (result = 0) {
				settimer, m2_Status_Req2, -1000
				return
				m2_Status_Req2:
				result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
				return
			}
			settimer, tooloff, -2222

			if roblox 
				gethandle_roblox() 
				settimer, m2_Status_Req3, -2800
				return
				m2_Status_Req3:
			if (m2dstatus = "not running or paused") {
				settimer, m2_Status_Req4, -2800
				return
				m2_Status_Req4:
				result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
				PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey
				PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey
				return
			}
			m2dstatus := False 
			return
		} 
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

	;case "Google Drive Sharing Dialog":
		;msgbox

	}
	
return	
}

OnFocus(Hook_Focus, event, BK_UN_T, idObject, idChild, dwEventThread, dwmsEventTime) {
CRITICAL
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
				sleep 1000
				;msgbox % BK_UN_T "asdsads"
				invert_win(BK_UN_T)
			}
		}
	switch, Title_last {
	case "Razer Synapse Account Login":
				settimer RZ_LOG, -1

	;case "Google Drive Sharing Dialog":
		;msgbox

	}	
	switch Class {
	case "MozillaDialogClass":
		{
			winget, Style, Style, ahk_id %BK_UN_T%
			IF(STYLE = 0x16CE0084) ;&& (EXSTYLE = 0x00000101)   
			{
				Youtube_Popoutwin := "ahk_id " . BK_UN_T
				wingetPos, X, Y, , EdtH, ahk_id %BK_UN_T%
				WinMove ahk_id %BK_UN_T%,, , , , (EdtH - 39)
				winSet, Style, 0x16860084,	ahk_id %BK_UN_T%	
				SLEEP 500
				SEND {SPACE}
			}
		}
		case "MozillaDialogClass":
		{
			Escape_TargetWin = ahk_id %Youtube_Popoutwin%
			winget, Style, Style, ahk_id %BK_UN_T%
			winget, exStyle, exStyle, ahk_id %BK_UN_T%
			IF((STYLE = 0x16CE0084) && (EXSTYLE = 0x00000101) ) {
				Youtube_Popoutwin := BK_UN_T
	
				winclose
				wingetPos, X, Y, , EdtH, ahk_id %BK_UN_T%
				WinMove ahk_id %BK_UN_T%,, , , , (EdtH - 39)
				winSet, Style, 0x16860084, ahk_id %BK_UN_T%	
				MSGBOX %Youtube_Popoutwin% `n Ahk_id %BK_UN_T%
			}
		}

		case "#32770":
		{		
			if (Title_last = "Information") {
				TOOLTIP c_nt
					SEND {N}
					RETURN
			}
		}
;case "CabinetWClass":
;{		
			 
;winSet, transparent, 130, ahk_id %BK_UN_T%
;msgbox
;}
		}
		return
}

OnMsgBox(Hook_MsgBox, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
CRITICAL
	wingetTitle, Title_last, ahk_id %hWnd%	
	if TTmb {
		wingetClass Class, ahk_id %hWnd%
		winget PName, ProcessName, ahk_id %hWnd%
		tooltip MSGBOX EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd%
	}
	If (Title_last = "Information") {
	MSG_WIN_TARGET=Information
		WinActivate
		send N
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
		else crashmb := crashmb + 1
		TestMbkill(DeadManHandle)
	}
	If WinExist(KILLSWITCH) {
		tooltip, Shutting Down Scripts, (A_ScreenWidth*0.5), (A_ScreenHeight*0.5)
		settimer, m2_Status_Req33, -2800
		return
		m2_Status_Req33:
		Exitapp
	}
	wingettitle, TitleR, ahk_id %hwnd%			;	tooltip % Title_Last " " hwnd " " class
	switch TitleR {
		case "Roblox Crash": 
		{		;	run C:\Apps\Kill.exe Multiple_ROBLOX.exe,, hide
			run C:\Apps\Kill.exe RobloxPlayerBeta.exe,, hide
			tooltip, Roblox Crash Detected: `nClosing All related scripts, A_ScreenWidth*0.5, A_ScreenHeight*0.5
			settimer, tooloff, -3000
			if !crashmb 
				crashmb = 1
			else crashmb := crashmb + 1
				settimer, m2_Status_Req34, -1000
				return
				m2_Status_Req34:
			settimer, SBAR_Restore, -1
			M2STATUS_Start:
				settimer, m2_Status_Req35, -2800
				return
				m2_Status_Req35:
			Roblox := False, Result := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle)
			if (result = "FAIL")
				Display_Msg("SendMessage failed.", "1000", "True")
			sleep 500
			Result := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle2)
			if ( result = "FAIL")
				Display_Msg("SendMessage failed.", "1000", "True")
			else if (result = 0)
				Display_Msg("Roblox Exiting: Scripts Closing", "1000", "True")
			if winexist("ahk_exe sidebar.exe") 
				SBAR_2berestored_True := False, Sidebar := True
			else {
				tooltip, Sidebar Not Loading, (A_ScreenWidth * 0.5), (A_ScreenHeight * 0.5)
				settimer, tooloff, -3000
				goto M2STATUS_Start
			}
			return
		}
		case "Roblox Game Client":
		{
			winget, RobloxCrashP, PID, ahk_id %hwnd%
			RobloxCR_PID=TASKKILL.exe /PID %RobloxCrashP%
			run %comspec% /C %RobloxCR_PID%,, hide
}	}	}

OnObjectDestroyed(Hook_ObjDestroyed, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
CRITICAL
	wingetClass, Class, ahk_id %hWnd% 	
	wingettitle, Title_last, ahk_id %hWnd%	
	winget PName, ProcessName, ahk_id %hWnd%	
	if TTds
			tooltip OBJ_DESTROY EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd%
	switch Class {
		; case "Autohotkey":
		; {
			; if % "C:\Script\AHK\adminhotkeys.ahk in " Title_last
			; {
				; menu, tray, uncheck, Launch AdminHotkeyz,
				
				; tooltip detected admin hotkey disconnecting
			; }
		; }
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
				sleep 500
				Result := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle2)
				If ((result1 or result2) = "FAIL")
					Display_Msg("SendMessage failed.", "1000", "True")
				If ((result1 and result2) = 0)
					Display_Msg("Roblox Exiting: Scripts Closing", "1000", "True")
			;	run C:\Apps\Kill.exe \Multiple_ROBLOX.exe,, hide 
}	}		}	

; end of hooks  <<<---------------------------------------
return 

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
					else reload
}	}	}	}	}
return

~Escape:: 				; 	see AdminHotkeys as this should be migrated
IF Youtube_Popoutwin { 	;	Youtube_Popoutwin (a bad addin)
	Escape_TargetWin = %Youtube_Popoutwin%
	if winactive(Escape_TargetWin) {
		winclose,
		traytip,% "escapetarget dispatched",% Escape_TargetWin
}	}

return
	;		 <------------< [ End of Script ] <------------<
	
	;		 >------------> [ Begin ... Functions ] >------------>

AtExit() {
	if (hgui != "")
		DllCall("magnification.dll\MagUninitialize")
	splitpath a_ScriptFullPath,,,, OutNameNoExt
	pap := "`n", Script_Title=%OutNameNoExt%.txt
	if !fileexist(Script_Title)
		pap := ""
	fileAppend , `n%EventLogBuffer%, %Script_Title%
	global Hook_4Gnd, 				ForegroundChangeProc 			
	global Hook_MsgBox, 			MsgBoxEventProc
	global Hook_ObjCreate, 			lpfnWinEventProc
	global Hook_ObjDestroyed, 		lpfnWinEventProc2
	global Hook_Focus, 				lpfnWinEventProc3

	if (Hook_4Gnd)
		DllCall("UnhookWinEvent", "Ptr", Hook_4Gnd), Hook_4Gnd := 0
	if (ForegroundChangeProc)
		DllCall("GlobalFree", "Ptr", ForegroundChangeProc, "Ptr"), ForegroundChangeProc := 0	
	if (Hook_MsgBox)
		DllCall("UnhookWinEvent", "Ptr", Hook_MsgBox), Hook_MsgBox := 0
	if (MsgBoxEventProc)
		DllCall("GlobalFree", "Ptr", MsgBoxEventProc, "Ptr"), MsgBoxEventProc := 0	
	if (Hook_ObjCreate)
		DllCall("UnhookWinEvent", "Ptr", Hook_ObjCreate), Hook_ObjCreate := 0
	if (Hook_ObjDestroyed)
		DllCall("UnhookWinEvent", "Ptr", Hook_ObjDestroyed), Hook_ObjDestroyed := 0
	if (lpfnWinEventProc)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc, "Ptr"), lpfnWinEventProc := 0	
	if (lpfnWinEventProc2)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc2, "Ptr"), lpfnWinEventProc2 := 0	
	if (Hook_Focus)
		DllCall("UnhookWinEvent", "Ptr", Hook_Focus), Hook_Focus := 0
	if (lpfnWinEventProc3)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc3, "Ptr"), lpfnWinEventProc3 := 0	
	return 0
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
	SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%,,,, %TimeOutTime%
	DetectHiddenWindows %Prev_DetectHiddenWindows%
	SetTitleMatchMode %Prev_TitleMatchMode%
	return ErrorLevel
}

Receive_WM_COPYDATA(wParam, lParam) {
	StringAddress := NumGet(lParam + 2*A_PtrSize)
	CopyOfData := StrGet(StringAddress)
	if CopyOfData contains Þ ;
	{ 	
		if !FileListStr {
			FileListStr := CopyOfData, FileCount := 1
		} else {
			FileListStr := (FileListStr . CopyOfData), FileCount := (FileCount + 1) ; FileListStr := FileListStr . "`n" . CopyOfData
		}
		FileListStrGen(Delimiter:="Þ") 
	}
	else if (CopyOfData = "RobloxFalse")
	{
		roblox := False
		Result := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle2)
		Result1 := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle),
		msgbox wank, aaa
	}
	else if CopyOfData = 10
		m2dstatus := "Suspended"
	else if CopyOfData = 00
		m2dstatus := "Running Normally"
	else if (CopyOfData = "StyleMenu")
		settimer, Stylemenu_init, -1
	else if (CopyOfData = "mag_")
		settimer, mag_, -1	
	else if CopyOfData
		gosub, %CopyOfData%
	else m2dstatus := "not running or paused"
	return True
}

FileListStrGen(abc) {
	adelim := abc
	if !oldlist
		oldlist := FileListStr
	else
		oldlist := FileListStr
	settimer, FileListStrGen2, -500
	return
}

gethandle_roblox() {
	loop 3 {
		winget, Roblox_hWnd, id, AHK_Class WINDOWSCLIENT
		if !Roblox_Hwnd 
			roblox := False
		else return Roblox_hWnd
}	}

TestMbkill(handle) {
	if !8skin_crash 
		8skin_crash = 1
	else 
		8skin_crash := 8skin_crash + 1
	run C:\Apps\Kill.exe robloxplayerbeta.exe,, hide
	if winexist("ahk_id %handle%") {
		settimer, turdss, -2000
		return
		turdss:
		run C:\Apps\Kill.exe robloxplayerbeta.exe,, hide
	}
	if winexist("ahk_id %handle%")
		 return 0
	else return 1
}
	
MessageBoxKill(Target_MSGBOX) {
	Target_hwnd := WinExist(Target_MSGBOX)	;winactivate		;send n		;ControlGet, OutputVar, SubCommand , Value, Button2, WinTitle, WinText, ExcludeTitle, ExcludeText	;ControlSendraw, ahk_parent, n, ahk_class #32770
	ControlClick, "Button2", "ahk_class #32770",	;ControlSend, ahk_parent, {N}, ahk_id %anus%
	settimer, tooloff, -2000
	if WinExist(ahk_ID %target_hwnd% ) {
		MsgBox_MsgBox_TargetHandle = ahk_id %hWnd4%
			winget, TargetPID, PID , % MsgBox_MsgBox_TargetHandle
			Target_PID=TASKKILL.exe /PID %TargetPID%
			run %comspec% /C %Target_PID%,, hide
		sleep 100
		if WinExist(MsgBox_MsgBox_TargetHandle ) {
			msgbox unable to close the target msgbox 
		} else {
			if  !KillCount
				 KillCount := 1
			else KillCount := KillCount + 1
			traytip,% KillCount " kills", 4000, 2000
			settimer, tooloff, -7000
}	}	}


IsWindow(hWnd) {
	return DllCall("IsWindow", "Ptr", hWnd)
}

IsWindowEnabled(hWnd) {
	return DllCall("IsWindowEnabled", "Ptr", hWnd)
}

IsWindowVisible(hWnd) {
	return DllCall("IsWindowVisible", "Ptr", hWnd)
}

StyleMenu_Showindow(hWnd, nCmdShow := 1) {
	DllCall("StyleMenu_Showindow", "Ptr", hWnd, "Int", nCmdShow)
}

IsChild(hWnd) {
	winget Style, Style, ahk_id %hWnd%
	return Style & 0x40000000 ; WS_CHILD
}

GetParent(hWnd) {
	return DllCall("GetParent", "Ptr", hWnd, "Ptr")
}

SetAcrylicGlassEffect(hWnd) {
	Static init, accent_state := 4,
	Static pad := a_PtrSize = 8 ? 4 : 0, WCA_ACCENT_POLICY := 19
	accent_size := VarSetCapacity(ACCENT_POLICY, 200, 0) 
	NumPut(accent_state, ACCENT_POLICY, 0, "int")
	NumPut(0x77400020, ACCENT_POLICY, 8, "int")
	VarSetCapacity(WINCOMPATTRDATA, 4 + pad + a_PtrSize + 4 + pad, 0)
	&& NumPut(WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0, "int")
	&& NumPut(&ACCENT_POLICY, WINCOMPATTRDATA, 4 + pad, "ptr")
	&& NumPut(accent_size, WINCOMPATTRDATA, 4 + pad + a_PtrSize, "uint")
	If !(DllCall("user32\SetWindowCompositionAttribute", "ptr", hWnd, "ptr", &WINCOMPATTRDATA))
		return 0
	return 1
}

Display_Msg(Text, Display_Msg_Time, X_X) {
	wingetpos, WindowX, WindowY, w_TxT, H_TxT, Roblox
	DMT := Display_Msg_Time, StartTime := a_TickCount, X_X := ""
	X_Mid := ((WindowX + (w_TxT/2)) - 45), Y_Mid := ( ( WindowY + (H_TxT*0.5 )) - 20 )
	X_TxT := ( x + 100 ), Y_TxT := ( y + 100 )
	splashimage,,b 0000EFFF ct00EFFF x%X_Mid% y%Y_Mid%,,%text%,MouseTextID
	winSet,transcolor,00000000 254,MouseTextID
	mouseGetPos,x,y
	X_TxT:=X_Mid, Y_TxT := Y_Mid
	winMove,%MouseTextID%,,%X_TxT%,%Y_TxT%
	settimer, Elapsed_Timer, 180
	return

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

Hook_4Gnd			:= 	DllCall("SetWinEventHook", "UInt", EVENT_4GND, "UInt", EVENT_4GND, "Ptr", 0, "Ptr", (ForegroundChangeProc := RegisterCallback("On4ground", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)
Hook_Focus			:= 	DllCall("SetWinEventHook", "UInt", OBJ_FOCUS, "UInt", OBJ_FOCUS, "Ptr", 0, "Ptr", (MsgBoxEventProc := RegisterCallback("OnFocus", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)
Hook_MsgBox			:= 	DllCall("SetWinEventHook", "UInt", 0x0010, "UInt", 0x0010, "Ptr", 0, "Ptr", (MsgBoxEventProc := RegisterCallback("OnMsgBox", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)
Hook_ObjCreate 		:= 	DllCall("SetWinEventHook", "UInt", OBJ_CREATED, "UInt", OBJ_CREATED, "Ptr", 0, "Ptr", (lpfnWinEventProc 	:= RegisterCallback("OnObjectCreated", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002) 
Hook_ObjDestroyed 	:= 	DllCall("SetWinEventHook", "UInt", OBJ_DESTROYED, "UInt", OBJ_DESTROYED, "Ptr", 0, "Ptr", (lpfnWinEventProc := RegisterCallback("OnObjectDestroyed", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)
return

FileListStrGen2:
	if (oldlist = FileListStr) {
		Loop, parse, FileListStr, ø,
		{
			IF (A_Index = 1)
				global action := A_LoopField
			Else
				FileListStr := A_LoopField
		}
		FileListStr_array := (StrSplit(FileListStr, "%adelim%")), FileListStr := "", oldlist := "", FileCount := ""
		return
	} 
	else oldlist := FileListStr
	return

RobloxGetHandle: 
winget, Roblox_hWnd, id, AHK_Class WINDOWSCLIENT
if !Roblox_Hwnd {
	roblox := False
	send {shift up}
	settimer, RobloxGetHandle2, -3000
}
return

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
	return
} 
return

SBAR_Restore:
if SBAR_DISABLE {
	if SBAR_2berestored_True {
		run % SidebarPath,, hide, 
		settimer, beads, -1000
		return
		beads:
		winget, SideBar_Handle, ID, HUD Time
		Sidebar := 1, SBAR_2berestored_True := False
		winSet, ExStyle, +0x20, ahk_id %SideBar_Handle%
}	}
return

Toggle_sbar:
if !SBAR_DISABLE{
	SBAR_DISABLE := True
	Tooltip Sidsebar will be disabled ingame
} Else {
	SBAR_DISABLE := False
	Tooltip Sidsebar will be enabled ingame
}
settimer, tooloff, -1000
return

ahk_r() {
	run %AHK_Rare%
	return
}

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
return

adminHotkeyz: ; Elevated UAC Bypass. AdminHKeyz can groom subsequent tasks via RunAsTask()
run, "C:\Windows\system32\schtasks.exe" /run /tn "adminhotkeys.ahk_407642875",, hide
;e="C:\Program Files\Autohotkey\AutoHotkeyA32_UIA.exe" "C:\Script\AHK\adminhotkeys.ahk"
;run %e%,,hide	
menu, tray, check, Launch AdminHotkeyz,
return

m2drag_run:
run, "C:\Program Files\Autohotkey\AutoHotkeyU64_uia.exe" "C:\Script\AHK\Working\M2Drag.ahk",,hide
return

wmp_matt_run:
run, "C:\Program Files\Autohotkey\AutoHotkeyU64.exe" "C:\Script\AHK\Z_MIDI_IN_OUT\wmp_Matt.ahk",,hide
return

zinout:
a = "C:\Program Files\Autohotkey\AutoHotkeyU64.exe" "C:\Script\AHK\Z_MIDI_IN_OUT\z_in_out.ahk" 
run %a%,,hide,zinout_pid
return

YT_DL:		;		a 	= 	"C:\Program Files\Autohotkey\AutoHotkeyU64.exe" "C:\Script\AHK\Working\YT.ahk"
run, "C:\Program Files\Autohotkey\AutoHotkeyU64_UIA.exe" "C:\Script\AHK\Working\YT.ahk",,hide,zinout_pid
return

pconfig:
run C:\Windows\system32\schtasks.exe /run /tn "cmd_output_to_msgbox.ahk_407642875",, hide
return


TT4g:
TT4g := !TT4g
if !TT4g {
	global 	TT4g := 	True
	menu, tray, 		check,   %	"4ground hook tip",
} else {	
	menu, tray, 		uncheck, % 	"4ground hook tip",
	TT4g		 :=		False
}
return

TTFoc:
TTFoc := !TTFoc
if !TTFoc {
	global TTFoc := 	True
	menu, tray, 		check, 	 % 	"focus hook tip",
} else {
	menu, tray, 		uncheck, % 	"focus hook tip",
	TTFoc		 := 	False
}
return

TTcr:
TTcr := !TTcr
if !TTcr {
	global 	TTcr := 	True
	menu, tray, 		check,	 % 	"obj_create tip",
} else {
	menu, tray, 		uncheck, %  "obj_create tip",
	TTcr		 := 	False
}
return

TTds:
TTds := !TTds
if !TTds {
	global TTds := 		True
	menu, tray, 		check,	 % 	"obj_destroy tip",
} else {
	menu, tray, 		uncheck, % 	"obj_destroy tip",
	TTds		:= 		False
}
return

TTmb:
TTmb := !TTmb
if !TTmb {
	global 	TTmb := 	True
	menu, tray,			check,	 % 	"msgbox hook tip",
} else {
	menu, tray, 		uncheck, % 	"msgbox hook tip",
	TTmb		 := 	False
}
return

gadget_gNess:
winget, Time_hWnd, iD, HUD Time						
if errorlevel	
	msgbox %errorlevel%
else {
	winSet, ExStyle, 0x000800A8, ahk_id %Time_hWnd%		; SIDEBAR-CLOCK CLICK-THRU
	;winSet, ExStyle, 0x000800A8, Moon Phase II
}
return

invert_win(hw) {
	hTarget 	:= hw
	if (hTarget = hTargetPrev) {
		hTargetPrev := ""
		count--
		return
	}
	count++
	hTargetPrev := hTarget
	if (hgui = "") {
		DllCall("LoadLibrary", "str", "magnification.dll")
		DllCall("magnification.dll\MagInitialize")

		VarSetCapacity(MAGCOLOREFFECT, 100, 0)
		Loop, Parse, Matrix, |
		NumPut(A_LoopField, MAGCOLOREFFECT, (A_Index - 1) * 4, "float")
		loop 2 {
			if (A_Index = "2")
				gui, %A_Index%: +AlwaysOnTop ; needed for ZBID_UIACCESS
			gui, %A_Index%: +HWNDhgui%A_Index% -DPIScale +toolwindow -Caption +E0x02000000 +E0x00080000 +E0x20 ; WS_EX_COMPOSITED := E0x02000000 WS_EX_LAYERED := E0x00080000 WS_EX_CLICKTHROUGH := E0x20
			hChildMagnifier%A_Index% := DllCall("CreateWindowEx", "uint", 0, "str", "Magnifier", "str", "MagnifierWindow", "uint", WS_CHILD := 0x40000000, "int", 0, "int", 0, "int", 0, "int", 0, "ptr", hgui%A_Index%, "uint", 0, "ptr", DllCall("GetWindowLong" (A_PtrSize=8 ? "Ptr" : ""), "ptr", hgui%A_Index%, "int", GWL_HINSTANCE := -6 , "ptr"), "uint", 0, "ptr")
				DllCall("magnification.dll\MagSetColorEffect", "ptr", hChildMagnifier%A_Index%, "ptr", &MAGCOLOREFFECT)
		}
	}
	;gui, 2: Show, NA ; needed for removing flickering
	hgui := hgui1
	hChildMagnifier := hChildMagnifier1
	loop {
		if (count != 1) { ; target window changed
			if (count = 2)
				count--
			WinHide, ahk_id %hgui%
			return
		}
		VarSetCapacity(WINDOWINFO, 60, 0)
		if (DllCall("GetWindowInfo", "ptr", hTarget, "ptr", &WINDOWINFO) = 0) and (A_LastError = 1400) ; destroyed
		{
			count--
			WinHide, ahk_id %hgui%
			return
		}
		if (NumGet(WINDOWINFO, 36, "uint") & 0x20000000) or !(NumGet(WINDOWINFO, 36, "uint") & 0x10000000) ; minimized or not visible
		{
			if (wPrev != 0) {
				WinHide, ahk_id %hgui%
				wPrev := 0
			}
			sleep 2
			continue
		}
		x 	:= NumGet(WINDOWINFO, 20, "int")
		y 	:= NumGet(WINDOWINFO, 8, "int")
		w 	:= NumGet(WINDOWINFO, 28, "int") - x
		h	:= NumGet(WINDOWINFO, 32, "int") - y
		if (hgui = hgui1) and ((NumGet(WINDOWINFO, 44, "uint") = 1) or (DllCall("GetAncestor", "ptr", WinExist("A"), "uint", GA_ROOTOWNER := 3, "ptr") = hTarget)) ; activated
		{
			hgui := hgui2
			hChildMagnifier := hChildMagnifier2
			WinMove, ahk_id %hgui%,, x, y, w, h
			WinMove, ahk_id %hChildMagnifier%,, 0, 0, w, h
			settimer 1, -20
			settimer 2, -20
			settimer 3, -20
			hidegui := hgui1
		} else 
		if (hgui = hgui2) and (NumGet(WINDOWINFO, 44, "uint") != 1) and ((hr := DllCall("GetAncestor", "ptr", WinExist("A"), "uint", GA_ROOTOWNER := 3, "ptr")) != hTarget) and hr ; deactivated
		{
			hgui := hgui1
			hChildMagnifier := hChildMagnifier1
			WinMove, ahk_id %hgui%,, x, y, w, h
			WinMove, ahk_id %hChildMagnifier%,, 0, 0, w, h
			DllCall("SetWindowPos", "ptr", hgui, "ptr", hTarget, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x0040|0x0010|0x001|0x002)
			DllCall("SetWindowPos", "ptr", hTarget, "ptr", 1, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x0040|0x0010|0x001|0x002) ; some windows can not be z-positioned before setting them to bottom
			DllCall("SetWindowPos", "ptr", hTarget, "ptr", hgui, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x0040|0x0010|0x001|0x002)
			settimer 1, -20
			settimer 2, -20
			settimer 3, -20
			hidegui := hgui2 
		} else 
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
			NumPut(x, RECT, 0, "int")
			NumPut(y, RECT, 4, "int")
			NumPut(w, RECT, 8, "int")
			NumPut(h, RECT, 12, "int")
			DllCall("magnification.dll\MagSetWindowSource", "ptr", hChildMagnifier, "ptr", &RECT)
		} 
		else 	DllCall("magnification.dll\MagSetWindowSource", "ptr", hChildMagnifier, "int", x, "int", y, "int", w, "int", h)
		xPrev := x, yPrev := y, wPrev := w, hPrev := h
		if hidegui {
			WinHide, ahk_id %hidegui%
			hidegui := ""
		}
	}
	return
}
	1:
	gui, 2: Show, NA ; needed for removing flickering
	return
	2:
	WinShow, ahk_id %hChildMagnifier%
	return
	3:
	WinShow, ahk_id %hgui%
	return

	Uninitialize:
	if (hgui != "")
	 DllCall("magnification.dll\MagUninitialize")
	exitapp

StyleDetect(hwnd,Style_xList,XTitle,XtitlesArray) 	{
	if fpos:=InStr(Style_xList, XTitle) 			{
		for index, value in XtitlesArray			{
			if fpos:=InStr(value, XTitle)			{
				retpos 	:= RegExMatch(value, "(\µ)\K(.*)", 		ret_class, 		p0s := 1) 
				retpos 	:= RegExMatch(value, "^0.{9}", 			ret_style, 		p0s := 1)
				retpos 	:= RegExMatch(value, "(\»)\K(.{10})", 	ret_exstyle, 	p0s := 1)
				WinSet, Style, 		% ret_style, 	% "ahk_id" hwnd  
				WinSet, ExStyle, 	% ret_exstyle, 	% "ahk_id" hwnd
				msgbox %XTitle% detected`n%ret_style%`n%ret_exstyle%
}	}	}	}

toggle_m2drag_bypass:
ttt := "M2Drag.ahk - AutoHotkey", result := Send_WM_COPYDATA("Bypass_Last_Dragged_GUI",ttt)
return

midiScriptR:
run % midiScriptR
return 

Stylemenu_init:
; tooltip % "Analyzing, please wait"
TargetHandle := "", style:=""
if Dix
	Menu F, DeleteAll
Dix:= True
MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
TargetHandle = ahk_id %OutputVarWin%
wingetTitle, TargetTitle, ahk_id %OutputVarWin%
if !TargetTitle 
	return
winget PName, ProcessName, ahk_id %OutputVarWin%
winget, Style2, Style, ahk_id %OutputVarWin%
winget, ExStyle2, ExStyle, ahk_id %OutputVarWin%

MainMenu:
Menu F, add, %PName%, donothing,
Menu F, Disable, %PName%
Menu F, add , , , 

Menu F, add, % sysmenu, toggle_sysmenu
if (Style2 & 0x00080000)
	Menu F, check, % SysMenu
else	Menu F, uncheck, % SysMenu

Menu	  F, 	add, % Clickthru, toggle_Clickthru
if (ExStyle2 & 0x00000001)
	 Menu F, 	check, % Clickthru
else Menu F, 	uncheck, % Clickthru

Menu	  F, 	add, % AppWindow, toggle_AppWindow
if (ExStyle2 & 0x00040000)
	Menu  F, 	check, % AppWindow
else Menu F, 	uncheck, % AppWindow
goto Sumenu_items

Submenus:
Menu F,	add, Frame / & X Controls, 	:S1
Menu F,	add, Scrollbars, 			:S2
Menu F,	add, Layout, 				:S3
goto othermenus

Sumenu_items:
Menu 	S1, 	add, DLG Frame, toggle_DLGFRAME
if (Style2 & 0x00400000)
	 Menu 	S1, check, DLG Frame
else Menu 	S1, uncheck, DLG Frame
	
Menu S1, add, THICK Frame, toggle_thickframe
if (Style2 & 0x00040000)
	 Menu 	S1, 	check, THICK Frame,
else Menu 	S1, 	uncheck, THICK Frame
	
Menu S1, add, Modal Frame, toggle_Modalframe
if (ExStyle2 & 0x00000001)
	 Menu 	S1, 	check, Modal Frame,
else Menu 	S1, 	uncheck, Modal Frame
	
Menu S1, add, Static edge, toggle_staticedge
if (ExStyle2 & 0x00020000) 
	 Menu 	S1, 	check, Static edge,
else Menu 	S1, 	uncheck, Static edge

Menu S1, add, %Maxbox%, toggle_Maxbox
if (Style2 & 0x00010000)
	 Menu 	S1, 	check, %Maxbox%
else Menu 	S1,	uncheck, %Maxbox%

Menu S1, add, %MinBox%, toggle_MinBox
if (Style2 & 0x00020000)
	 Menu 	S1, check, 	%MinBox%
else Menu 	S1, uncheck, 	%MinBox%

Menu S2, add, HScroll, toggle_hscroll
if (Style2 & 0x00100000)
	 Menu 	S2, check, 	HScroll 
else Menu 	S2, uncheck, 	HScroll 

Menu S2, add, VScroll, toggle_hscroll
if (Style2 & 0x00200000)
	 Menu 	S2, check, 	VScroll 
else Menu 	S2, uncheck, 	VScroll 

Menu S2, add, %LeftScroll%, toggle_LeftScroll
if (ExStyle2 & 0x00004000)
	 Menu 	S2, check, 	%LeftScroll%
else Menu 	S2, uncheck, 	%LeftScroll%
	
Menu S3, add, %RightAlign%, toggle_RightAlign
if (ExStyle2 & 0x00001000)
	 Menu 	S3, check, 	%RightAlign% 
else Menu 	S3, uncheck, 	%RightAlign%
	
Menu S3, add, %RightoLeft%, toggle_RightoLeft
if (ExStyle2 & 0x00002000)
	 Menu 	S3, 	check, 		%RightoLeft%
else Menu 	S3, 	uncheck, 	%RightoLeft%
gosub, Submenus
return

othermenus: ; below submenus
Menu 	F, 	add, m2drag bypass, toggle_m2drag_bypass
Menu 	F, 	Icon, m2drag bypass, % mouse24
Menu 	F, 	add, Get window text , getwintxt
Menu 	F, 	add, %Save% , Savegui
gosub, StyleMenu_Show
return
StyleMenu_Show:
tooltip
Menu F, Show
return
;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_

toggle_sysmenu:
WinSet, Style, ^0x00080000, 	ahk_id %OutputVarWin%
goto ResetMenu

toggle_DLGFRAME:
WinSet, Style, ^0x00400000, 	ahk_id %OutputVarWin% 
goto ResetMenu

toggle_thickframe:
WinSet, Style, ^0x00040000, 	ahk_id %OutputVarWin% 
goto ResetMenu

toggle_modalframe:
WinSet, ExStyle, ^0x00000001, 	ahk_id %OutputVarWin% 
goto ResetMenu

toggle_border:
WinSet, Style, ^0x00040000, 	ahk_id %OutputVarWin% 
goto ResetMenu

toggle_raisededge:
WinSet, ExStyle, ^0x00000100, 	ahk_id %OutputVarWin%
goto ResetMenu

toggle_sunkenedge:
WinSet, ExStyle, ^0x00000100, 	ahk_id %OutputVarWin%
goto ResetMenu

toggle_staticedge:
WinSet, ExStyle, ^0x00020000, 	ahk_id %OutputVarWin%
goto ResetMenu

toggle_3dedge:
WinSet, ExStyle, ^0x00020000, 	ahk_id %OutputVarWin%
goto ResetMenu

toggle_MinBox:
WinSet, Style, ^0x00020000, 	ahk_id %OutputVarWin% 
goto ResetMenu

toggle_Maxbox:
WinSet, Style, ^0x00010000, 	ahk_id %OutputVarWin% 
goto ResetMenu

toggle_hscroll:
WinSet, Style, ^0x00100000, 	ahk_id %OutputVarWin% 
goto ResetMenu

toggle_vscroll:
WinSet, Style, ^0x00200000, 	ahk_id %OutputVarWin% 
goto ResetMenu

toggle_LeftScroll:
WinSet, ExStyle, ^0x00004000, 	ahk_id %OutputVarWin% 
goto ResetMenu

toggle_Clickthru:
WinSet, ExStyle, ^0x00000020, 	ahk_id %OutputVarWin% 
goto ResetMenu

toggle_RightAlign:
WinSet, ExStyle, ^0x00001000, 	ahk_id %OutputVarWin% 
goto ResetMenu

toggle_RightoLeft:
WinSet, ExStyle, ^0x00002000, 	ahk_id %OutputVarWin% 
goto ResetMenu

toggle_AppWindow:
WinSet, ExStyle, ^0x00040000, 	ahk_id %OutputVarWin% 
goto ResetMenu

SAVEGUI:
winget save_new_ProcName, ProcessName, 	ahk_id %OutputVarWin%
wingetTitle save_new_Title, 			ahk_id %OutputVarWin%
wingetClass save_new_Class, 			ahk_id %OutputVarWin%
winget, Style, Style, 					ahk_id %OutputVarWin%
winget, ExStyle, ExStyle, 				ahk_id %OutputVarWin%
if !Style or !ExStyle
	msgbox error %a_lasterror%
gui, SaveGuI:new , , SAVE WINDOW STYLES
gui +hwndSaveGuI_hWnd
gui, SaveGuI:add, checkbox, vTProcName ,	Process %save_new_ProcName%
gui, SaveGuI:add, checkbox, vTTitle ,		WindowTitle %save_new_Title%
gui, SaveGuI:add, checkbox, vTClass ,		save Class %save_new_Class%
gui, SaveGuI:add, button, default gSaveGUISubmit w80, Save (Enter)
gui, SaveGuI:add, button, w80 gSaveGUIDestroy, 	Cancel (Esc)
gui, show, center, SAVE WINDOW STYLES
OnMessage(0x200, "Help")
return

SaveGUISubmit: 	; keyname will contain unique information as a search key and allow for other combinations such as different classnamed windows for the same target app without duplication
gui, SaveGuI:Submit

PushNewSave: 	
if TProcName {
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\procname, 	% Style . "»" . exStyle . "»" . "µ" . save_new_ProcName . "µ" . save_new_Title . "µ" . save_new_Class, % save_new_ProcName
} 
if TTitle {
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\wintitle, 	% Style . "»" . exStyle . "»" . "µ" . save_new_ProcName . "µ" . save_new_Title . "µ" . save_new_Class, % save_new_Title
} 
if TClass {
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\classname, 	% Style . "»" . exStyle . "»" . "µ" . save_new_ProcName . "µ" . save_new_Title . "µ" . save_new_Class, % save_new_Class
}
return

SaveGUIDestroy:
gui, SaveGuI:destroy
TProcName := "", TTitle := "", TClass := ""
return

ResetMenu:
Menu F, DeleteAll
return

RZ_LOG:
coord_old := A_CoordModePixel
CoordMode, pixel , window
WinGet, list_rzexe, List, ahk_exe RzSynapse.exe
Loop %list_rzexe% {
	ss := ("ahk_id " . list_rzexe%A_index%)
	winGet, Style, Style,% SS
	winGet, ExStyle, ExStyle,% SS
	if ((Style = "0x16080000") && (ExStyle = "0x000C0000")) {
		winactivate, % ss
		send ^{a}
		send %Log1_RZ%	
		send {tab}
		send ^{a}
		send %Pa5s_RZ%
		PixelGetColor, color, 219, 326
		if color != 0x02DD02
			msgbox, % "default snot saved"
		else send {enter}
}	}	
CoordMode,% coord_old
return,


RegReads:
RegRead, Log1RZ, HKEY_CURRENT_USER\Software\_Mouse2Drag\Login , rz
if Log1RZ {
	loop, parse, Log1RZ, `,
	{
		if (a_index = "1")
			Log1_RZ := A_LoopField
		if (a_index = "2")
			Pa5s_RZ := A_LoopField
}	}

Loop, Reg, % wintitlekey
{
    if (A_LoopRegType = "REG_SZ") {
        value1 	:= A_LoopRegKey . "\" . A_LoopRegSubKey
        regRead, value2, %value1%, %A_LoopRegName%
		Style_wintitleList2 := Style_wintitleList2 . value2 . "‡"	
		retpos 	:= RegExMatch(A_LoopRegName, "^0.{9}" , 		ret_style, p0s := 1)
		retpos 	:= RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , 	ret_exstyle, p0s := 1)
		Array_wintitleList.push(	ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
}	}

Loop, Reg, % procnamekey
{
    if (A_LoopRegType = "REG_SZ") {
        value1 := A_LoopRegKey . "\" . A_LoopRegSubKey
        regRead, value2, %value1%, %A_LoopRegName%
		Style_procnameList2 := Style_procnameList2 . value2 . "‡"	
		retpos := RegExMatch(A_LoopRegName, "^0.{9}" , ret_style, p0s := 1)
		retpos := RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , ret_exstyle, p0s := 1)
		Array_ProcnameList.push(	ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
}		}

Loop, Reg, % classnamekey
{
    if (A_LoopRegType = "REG_SZ") {
        value1 := A_LoopRegKey . "\" . A_LoopRegSubKey
        regRead, value2, %value1%, %A_LoopRegName%
		Style_ClassnameList2 := Style_ClassnameList2 . value2 . "‡"	
		retpos := RegExMatch(A_LoopRegName, "^0.{9}" , ret_style, p0s := 1)
		retpos := RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , ret_exstyle, p0s := 1)
		Array_LClass.push(		ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
}	}
return

;~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`

mag_:
Mag_Path := "C:\Program Files\Autohotkey\Autohotkey.exe C:\Script\AHK\Working\M2DRAG_MAG.AHK" 
run % Mag_Path		;			^ ^ 	above not working 	^ ^
return

screencleaner:
run % screencleaner
return

getwintxt:
WinGetText, wintxt , ahk_id %OutputVarWin%
msgbox, % wintxt
return

Open_script_folder:
e = explorer /select, %a_ScriptFullPath%
tooltip % a_ScriptFullPath
run %comspec% /c %e%,,hide,
settimer, tooloff, -1222
return

mattdwmrun:
run,% "C:\Program Files (x86)\AutoIt3\AutoIt3_x64.exe C:\Script\autoit\_MattDwmBlurBehindWindow.au3"
return

test_move:
run %test_move% 
tooloff:
tooltip
return 

;~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`~`

Menu_Tray:
menu, 	tray, 	NoStandard
menu, 	tray, 	Icon, 	Context32.ico
menu, 	tray, 	Add, 	Open script folder, 		Open_script_folder,
menu, 	tray, 	add, 	4ground hook tip, 			TT4g,
menu, 	tray, 	add, 	focus hook tip, 			TTFoc,
menu, 	tray, 	add, 	obj_create tip, 			TTcr,
menu, 	tray, 	add, 	obj_destroy tip, 			TTds,
menu, 	tray, 	add, 	msgbox hook tip, 			TTmb,
menu, 	tray, 	add, 	Toggle debug, 				Toggle_dbg,
menu, 	tray, 	add, 	Toggle Sidebar off ingame, Toggle_sbar
menu, 	tray, 	add, 	Launch PowerConfig, 		pconfig
menu, 	tray, 	icon,	Launch PowerConfig, 		C:\Icon\20\alien.ico
menu, 	tray, 	add, 	Launch MattDWM, 			mattdwmrun
menu, 	tray, 	icon,	Launch MattDWM, 			C:\Icon\24\dwm24.ico
menu, 	tray, 	add, 	Launch M2Drag, 				m2drag_run
menu, 	tray, 	icon,	Launch M2Drag, 				C:\Script\AHK\Working\Mouse242.ico 
menu, 	tray, 	add, 	Launch WMP_MATT,			wmp_matt_run
menu, 	tray, 	add, 	Launch midi_in_out, 		zinout
menu, 	tray, 	add, 	Launch AdminHotkeyz, 		adminHotkeyz
menu, 	tray, 	add, 	Launch YouTube_DL, 			YT_DL
menu, 	tray, 	Icon,	Launch YouTube_DL, 			YouTube.ico
menu, 	tray, 	add, 	Launch test_move, 			test_move
menu, 	tray, 	add, 	Launch screen clean!, 		screencleaner
menu, 	tray, 	Icon,	Launch screen clean!, 		C:\Icon\24\AF_Icon.ico
menu, 	tray, 	Standard
return

Globals:

global AF := (Script . af_1), global AF2 := (Script . Bun_), global AutoFireScript := BF, global AutoFireScript2 := BF2 , global TargetScriptTitle := (AutoFireScript . " ahk_class AutoHotkey"), global TargetScriptTitle2 := (AutoFireScript2 . " ahk_class AutoHotkey"), global AHK_Rare := "C:\Script\AHK\- Script\AHK-Rare-master\AHKRareTheGui.ahk", global SidebarPath := "C:\Program Files\Windows Sidebar\sidebar.exe", global AF_Delay := 10, global SysShadowStyle_New := 0x08000000, global SysShadowExStyle_New := 0x08000020, global toolx := "-66", global offsett := 40, global KILLSWITCH := "kill all AHK procs.ahk", global starttime, global text, global X_X, global Last_Title, global autofire, global RhWnd_old, global MouseTextID, global DMT, global roblox, global toggleshift, global Norm_menuStyle, global Norm_menuexStyle, global Title_Last, global Title_last, global dcStyle, global classname, global tool, global tooly, global EventLogBuffer_Old, global Roblox_hwnd, global Time_Elapsed, global KillCount, global SBAR_2berestored_True, global Sidebar, global TT4g, global TTFoc, global TTcr, global TTds, global TTmb, global dbg, global TClass, global TTitle, global TProcName, global delim, global delim2, global TitleCount, global ClassCount, global ProcCount, global style2, global exstyle2, delim := "µ", delim2 := "»", global ArrayProc, global ArrayClass, global ArrayTitle, global Array_LProc, global Array_LTitle, global Array_LClass, global Style_ClassnameList2, global Style_procnameList2, global Style_wintitleList2, global Youtube_Popoutwin, global Script_Title, global np, global m2dstatus, global crashmb, global 8skin_crash, global OutputVarWin, global F, global s1, global s2, global s3, global delim := "Þ", global FileListStr, global oldlist, global FileCount, global FileListStr_array := [], GLOBAL ADELIM, global Path_PH := "C:\Apps\Ph\processhacker\x64\ProcessHacker.exe", global hTarget, global hTargetprev, global hgui
global xPrev, global yPrev, global wPrev, global hPrev
return

Locals:

global Matrix

Matrix := 	"-1	|0	|0	|0	|0|"
.			"0	|-1	|0	|0	|0|"
.			"0	|0	|-1	|0	|0|"
.			"0	|0	|0	|1	|0|"
.			"1	|1	|1	|0	|1"

global triggeredGFS
global logvar
global SysMenu		:= 	"Title (+ & X Conrols) (SysMenu)"
global Maxbox 		:= 	"Maximise Button (□)"
global MinBox 		:= 	"Minimise Button (_)"
global LeftScroll 	:= 	"Left Scroll Orientation"
global ClickThru 	:= 	"Click-through"
global RightAlign	:= 	"Generic Right-alignment"
global RightoLeft	:= 	"Right-to-Left reading"
global AppWindow	:= 	"Taskbar Item (not 100%)"
global Save 		:= 	"Save window style preferences"
global Reset 		:= 	"Reset window style preferences"
global midiScriptR 	:= 	( "C:\Program Files\Autohotkey\AutoHotkeyU64.exe " . "C:\Script\AHK\Z_MIDI_IN_OUT\z_in_out.ahk")
global test_move	:= 	"C:\Users\ninj\DESKTOP\winmove_test.ahk"
loop 50 {
	global  ("hChildMagnifier" . a_index) 
	global  ("hgui" . A_Index)
	global  ("HWNDhgui" . A_Index)
}
global hTargetPrev
global wPrev
global hPrev
global xPrev
global yPrev
global hidegui
stylekey 			:= 	"HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles"
wintitlekey 		:= 	stylekey . "\wintitle"
procnamekey 		:= 	stylekey . "\procname"
classnamekey 		:= 	stylekey . "\classname"
screencleaner 		:= 	"C:\Script\AHK\white_full-screen_gui.ahk"	
test		:= 	(Style2 . "»" . exStyle2 . "»" . "µ" . save_new_ProcName . "µ" . save_new_Title . "µ" .  "µ" . save_new_Class)
mouse24 	:= 	"C:\Script\AHK\Working\mouse24.ico"
Script 		:= 	"C:\Script\AHK"
BF 			:= 	"Roblox_Rapid.ahk"
BF2 		:= 	"Roblox_Bunny.ahk"
af_1 		:= 	"\" . BF
Bun_ 		:= 	"\" . BF2
logvar 		:= 	""
ArrayProc	:= 	[]
ArrayClass	:= 	[]
ArrayTitle	:= 	[]
Array_LProc	:= 	[]
Array_LTitle:= 	[]
Array_LClass:= 	[]
return

init_mate:
gosub, Menu_Tray
gosub, Locals
gosub, Globals
gosub, Locals
gosub, RegReads 
gosub, Hooks
gosub, Main

return

donothing:

return

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
; else            ; Set for current user only.
    ; RegWrite, REG_SZ, HKCU, Software\Classes\%key%,, %cmd%
	
	;----;
	
; DllCall("kernel32.dll\SetProcessShutdownParameters", "UInt", 0x4FF, "UInt", 0)
; OnMessage(0x0011, "WM_QUERYENDSESSION")
; return	; The above DllCall is optional: it tells the OS to shut down this script first (prior to all other applications).

; WM_QUERYENDSESSION(wParam, lParam){
    ; ENDSESSION_LOGOFF := 0x80000000
    ; if (lParam & ENDSESSION_LOGOFF)  ; User is logging off.
        ; EventType := "Logoff"
    ; else  ; System is either shutting down or restarting.
        ; EventType := "Shutdown"
    ; try { ; Set a prompt for the OS shutdown UI to display.  We do not display        ; our own confirmation prompt because we have only 5 seconds before        ; the OS displays the shutdown UI anyway.  Also, a program without        ; a visible window cannot block shutdown without providing a reason.
        ; BlockShutdown("Example script attempting to prevent " EventType ".")
        ; return false
    ; }    catch    {
        ; MsgBox, 4,, %EventType% in progress.  Allow it?; ShutdownBlockReasonCreate is not available, so this is probably
        ; IfMsgBox Yes        ; Windows XP, 2003 or 2000, where we can actually prevent shutdown.

            ; return true  ; Tell the OS to allow the shutdown/logoff to continue.
        ; else
            ; return false  ; Tell the OS to abort the shutdown/logoff.
; }   }

; BlockShutdown(Reason) { ; If your script has a visible GUI, use it instead of A_ScriptHwnd.
    ; DllCall("ShutdownBlockReasonCreate", "ptr", A_ScriptHwnd, "wstr", Reason)
    ; OnExit("StopBlockingShutdown")
; }
; StopBlockingShutdown(){
    ; OnExit(A_ThisFunc, 0)
    ; DllCall("ShutdownBlockReasonDestroy", "ptr", A_ScriptHwnd)
; }

