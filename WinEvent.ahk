#NoEnv 			; ListLines, Off 			; 
setWorkingDir %A_ScriptDir%
#Persistent
#Singleinstance Force
DetectHiddenWindows on
coordMode tooltip screen
SetTitleMatchMode 2
SetBatchLines -1
setWinDelay, -1

; ===>" binds " below line 500

gosub TrayMenu
gosub Locals
gosub Globals
gosub Locals
setTimer adminHotkeyz, -1
gosub RegReadStyles
gosub Hooks

On4ground(Hook_4Gnd, event, hWnd4, idObject, idChild, dwEventThread, dwmsEventTime) {
	4gnd_hwnd =% "ahk_id " hWnd4
	WinGetClass Class, % 4gnd_hwnd
	if 4groundtt {
		wingettitle, Title_last, ahk_id %hWnd4%	
		winGet PName, ProcessName, ahk_id %hWnd4%
		tooltip 4Ground EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd4%
	}
	switch Class {
		case "#32770":	; msg box 
		{ 
			wingettitle, Title_last, % 4gnd_hwnd	
			if (Title_last = "Roblox Crash") {
				if !4skin_crash
					4skin_crash = 1
				else 4skin_crash := 4skin_crash + 1
				WinGet, RobloxCrash_PID, PID , % 4gnd_hwnd
				Roblox_PID=TASKKILL.exe /PID %RobloxCrash_PID%
				run %comspec% /C %Roblox_PID%,, hide
				if winexist("ahk_exe robloxplayerbeta.exe") 
					run C:\Apps\Kill.exe robloxplayerbeta.exe,, hide	; 	run C:\Apps\Kill.exe Multiple_ROBLOX.exe,, hide
				if winexist("ahk_pid %Roblox_PID%")
					msgbox major malc
				gosub SBAR_Restore
			} else
				if (Title_last = "Information") 
					send {n}
			return
		} 		; 		;		 else 	other clases
		case "ApplicationFrameWindow","Chrome_WidgetWin_1","WINDOWSCLIENT":
		{
			ttt := "M2Drag.ahk - AutoHotkey"
			result := Send_WM_COPYDATA("status",ttt)
			wingettitle, Title_last, ahk_id %hWnd4%	
			if (Title_last != "Roblox")
				TOOLTIP
			ttt := "M2Drag.ahk - AutoHotkey"
			result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
			settimer tooloff, -2222
			if roblox {
				gethandle_roblox() 
				settimer ballbagger, -4000
				return
				ballbagger:
				if( m2dstatus != "not running or paused"	) {
					PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey	; 	65306 = Pause
					PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey	; 	65305 = Suspend
				}
				m2dstatus := false
			}
			return
		}
		Default:
		{ 	
			ttt := "M2Drag.ahk - AutoHotkey"
			result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
			if (result = "FAIL") {
				settimer cuntface, -1000
				return
				cuntface:
				result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
				return
			}
			else if (result = 0) {
				settimer fuckyou, -1000
				return
				fuckyou:
				result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
				return
			}
			settimer tooloff, -2222

			if roblox 
				gethandle_roblox() 
				settimer fuckme, -2800
				return
				fuckme:
			if( m2dstatus = "not running or paused"	) {
				settimer fuckme2, -2800
				return
				fuckme2:
						result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")

				PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey
				PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey
				return
			}
			m2dstatus := false
			return
		} 
	} 
return	
}

OnMsgBox(Hook_MsgBox, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	if msgboxtt {
		winGetClass Class, ahk_id %hWnd%
		winGetTitle, Title_last, ahk_id %hWnd4%	
		winGet PName, ProcessName, ahk_id %hWnd4%
		tooltip MSGBOX EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd4%
	}
	If WinExist("Information") MSG_WIN_TARGET=Information
		If WinExist("Reminder") { 
			MSG_WIN_TARGET=Reminder
			WIN_TARGET_DESC=%MSG_WIN_TARGET%
			MessageBoxKill(MSG_WIN_TARGET)
		}
	If HANDOFGOD :=WinExist("Roblox Crash") { 
		MSG_WIN_TARGET=Roblox Crash
		WIN_TARGET_DESC=%MSG_WIN_TARGET%
		;MessageBoxKill(MSG_WIN_TARGET)
		if !4skin_crash 
			4skin_crash = 1
		else 4skin_crash := 4skin_crash + 1
		Spunkmessagebox(HANDOFGOD)
	}
	If WinExist(KILLSWITCH) {
		tooltip, Shutting Down Scripts, (A_ScreenWidth*0.5), (A_ScreenHeight*0.5)
		settimer fuckme3, -2800
		return
		fuckme3:
		Exitapp
	}
	wingettitle, TitleR, ahk_id %hwnd%			;	tooltip % Title_Last " " hwnd " " class
	switch TitleR {
		case "Roblox Crash": 
		{		;	run C:\Apps\Kill.exe Multiple_ROBLOX.exe,, hide
			run C:\Apps\Kill.exe RobloxPlayerBeta.exe,, hide
			tooltip, Roblox Crash Detected: `nClosing All related scripts, A_ScreenWidth*0.5, A_ScreenHeight*0.5
			settimer tooloff, -3000
			if !4skin_crash 
				4skin_crash = 1
			else 4skin_crash := 4skin_crash + 1
				settimer fuckme4, -1000
				return
				fuckme4:
			settimer SBAR_Restore, -1
			SICK:
				settimer fuckme5, -2800
				return
				fuckme5:
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
				SBAR_2berestored_True := False, Sidebar := true
			else {
				tooltip, Sidebar Not Loading, (A_ScreenWidth * 0.5), (A_ScreenHeight * 0.5)
				settimer tooloff, -3000
				goto SICK
			}
			return
		}
		case "Roblox Game Client":
		{
			WinGet, RobloxCrashP, PID, ahk_id %hwnd%
			RobloxCR_PID=TASKKILL.exe /PID %RobloxCrashP%
			run %comspec% /C %RobloxCR_PID%,, hide
		}
	}
}

OnObjectCreated(Hook_ObjCreate, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	WinGetClass Class, ahk_id %hWnd%
	GOSUB Manual_Classhook_objCreated
	wingettitle, Title_last, ahk_id %hWnd%
	winGet PName, ProcessName, ahk_id %hWnd%
	if creatett 
		tooltip OBJ_CREATE EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd4%
	StyleDetect(hWnd, Style_ClassnameList2, 	Class, 		Array_LClass) 
	StyleDetect(hWnd, Style_wintitleList2, 			Title_last, 	Array_LTitle) 
	StyleDetect(hWnd, Style_procnameList2, 	PName, 	Array_LProc) 
	Manual_Classhook_objCreated:
	switch Class {
		case "OperationStatusWindow":
		{
			WinGetTitle, tits , AHK_ID %hWnd%
			if( tits = "Folder In Use" ) {
				asas := "AHK_Class WindowsForms10.Window.8.app.0.141b42a_r6_ad1"
				WinGet, hwnd2, ID , %asas%
				if asas
					winclose ahk_id %hwnd2%
			}
			return
		}
		case "MozillaDialogClass":
		{
			winget, Style, Style, ahk_id %hwnd%
			winget, exStyle, exStyle, ahk_id %hwnd%
			IF((STYLE = 0x16CE0084) && (EXSTYLE = 0x00000101) ) {
				MSGBOX POO1
				winSet, Style, 0x16860084, ahk_id %hwnd%
			}
		}
			case "NotifyIconOverflowWindow","DropDown","TaskListThumbnailWnd","Net UI Tool Window Layered":
			{
				;winSet, TransColor, 0xff0000 , ahk_id %hWnd%
				winSet, ExStyle, ^0x00000100, ahk_id %hWnd%
				winSet, Style, 0x94000000, ahk_id %hWnd%
				return
			}
			; case "#32768":	
			; {
				; winSet, TransColor, 0x000000 , ahk_id %hWnd%	; tooltip Context Menu
				; winSet, ExStyle, 0x00000100, ahk_id %hWnd%
				; winSet, Style, 0x94000000, ahk_id %hWnd%
				; winget, Norm_menuStyle, Style, ahk_id %hwnd%
				; winget, Norm_menuexStyle, exStyle, ahk_id %hwnd%
				; tooltip % Norm_menuStyle "`n" Norm_menuexStyle
				; clipboard := Norm_menuStyle . Norm_menuexStyle . FFmenuStyle . FFmenuexStyle
				; return
			; }
			case "TaskListThumbnailWnd":	
			{
				SetAcrylicGlassEffect(hWnd)
				return
			}
			case "QPopup":	
			{
				;winSet,transcolor, 000000 100, ahk_id %hWnd%
				;winSet, transparent , 200, ahk_id %hwnd%
				;SetAcrylicGlassEffect(hWnd)
				;tooltip addadadad
				return
			}
			case "Qwidget":	
			{
				;	winSet,transcolor, 000000 100, ahk_id %hWnd%
				;	winSet, transparent , 200, ahk_id %hwnd%
				;	SetAcrylicGlassEffect(hWnd)
				;	tooltip addadadad
				return
			}
			case "RegEdit_RegEdit","FM":
			{
				ControlGet, ctrlhand, Hwnd,, SysListView321, ahk_id %hWnd%
				SendMessage 0x1036, 0, 0x00000020,, ahk_id %ctrlhand% 	 ; enable row select (vs single cell)
				return
			}
			case "7 Sidebar":
			{
				winGet, Time_hWnd, iD, ahk_class 7 Sidebar
				winSet, ExStyle, 0x000800A8, HUD Time, ahk_id %Time_hWnd%
				winSet, ExStyle, 0x000800A8, Moon Phase II
				sidebar := true
				return
			}
			case "ApplicationFrameWindow","Chrome_WidgetWin_1","WINDOWSCLIENT":
			{
				wingettitle, Title_Last, ahk_id %hwnd%			;	tooltip % Title_Last " " hwnd " " class
				if (Title_Last="Roblox") {
					;Result :=Send_WM_COPYDATA("Susp", "M2Drag.ahk ahk_class AutoHotkey")
					p ="C:\Program Files\AHK\AutoHotkeyU32_UIA.exe" "C:\Script\AHK\Roblox_Rapid.ahk"
					result := Send_WM_COPYDATA("status", "M2Drag.ahk - AutoHotkey")
					settimer, RobloxGetHandle, -2000
					run %p%
					;run "%AF%"				;run "C:\Program Files\AHK\AutoHotkeyU32_UIA.exe" "%AF%"
					if SBAR_DISABLE {
						if winexist("ahk_exe sidebar.exe") {
							run C:\Apps\Kill.exe sidebar.exe,, hide
							SBAR_2berestored_True := True, Sidebar := False, Roblox := True
						}
					}
					
					if (m2dstatus != "not running or paused"	) && (m2dstatus !=false) {
						PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey
						PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey	
					}
					if(m2dstatus = false) {
						settimer fuckme6, -5000
						return
						fuckme6:
						if (m2dstatus != "not running or paused"	) && (m2dstatus !=false) {
							PostMessage, 0x0111, 65306,,, M2Drag.ahk - AutoHotkey		; Use 65306 to Pause, 
							PostMessage, 0x0111, 65305,,, M2Drag.ahk - AutoHotkey		; 65305 to Suspend.
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
					ShowWindow( c_ntHandle, !IsWindowVisible( c_ntHandle))
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
				ShowWindow(hWnd, !IsWindowVisible(hWnd))
				winSet, Style, 0x80000000, ahk_id %hWnd%
				;WinMinimize , ahk_id %hWnd%
			;	sleep 500
				return
			}
			case "#32770":
			{		
				winGetTitle, Title_last, ahk_id %hWnd4%	
				if (Title_last = "Information") {
					SEND {N}
					RETURN
				}
				winGet PName, ProcessName, ahk_id %hWnd%
				if (PName = "notepad++.exe") {
					winGet, currentstyle, Style, ahk_id %hWnd%
					if (currentstyle = 0x94CC004C) {
						sleep 580
						winSet, Style, -0x00400000, ahk_id %hWnd%
					}
				}
				; else if (PName = "explorer.exe") {
					; WinGetTitle, tits, ahk_id %hWnd%
					; msgbox %tits%
					; if (tits = "Folder In Use") {
						; asas := "AHK_Class WindowsForms10.Window.8.app.0.141b42a_r6_ad1"
						; WinGet, hwnd2, ID , %asas%
						; if asas {
							; winclose ahk_id %hwnd2%
							; winactivate, ahk_id %fuk%
							; sleep 20
							; send {left}
							; send {enter}
							; return
					;	}
				; 	}				
			; 	}
				return
			}
			case "Notepad++":
			{
				if !np {
					 sem := "Notepad++ Insert AHK Parameters.ahk - AutoHotkey"
					 if !WinExist(,sem) 
						run "C:\Script\AHK\- Script\Notepad++ Insert AHK Parameters.ahk",,, npPID
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
			default: 
			{
				if (IsWindow(hWnd)) {
					WinGet Style, Style, ahk_id %hWnd%
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
						setTimer EventLogBuffer_Push, -4000
					}
				}
				return
			}		
		return 		;	 	end case	
		}	
		
	EventLogBuffer_Push:
		If !EventLogBuffer
			EventLogBuffer = % EventLogBuffer_Old
		else
			EventLogBuffer=%EventLogBuffer%`n%EventLogBuffer_Old%
		EventLogBuffer_Old:="", clist:="", offset:="", tool:=""
		return
}
return

OnFocus(Hook_Focus, event, BLACK_CUN_T, idObject, idChild, dwEventThread, dwmsEventTime) {
	WinGetClass, Class, ahk_id %BLACK_CUN_T% 		
	winGet PName, ProcessName, ahk_id %BLACK_CUN_T%
	wingettitle, Title_last, ahk_id %BLACK_CUN_T%	

	if focustt
		tooltip FOCUS EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %BLACK_CUN_T%	
		
	switch Class {
	case "MozillaDialogClass":
		{
			winget, Style, Style, ahk_id %BLACK_CUN_T%
			IF(STYLE = 0x16CE0084) ;&& (EXSTYLE = 0x00000101)   
			{
				popoutyt := "ahk_id " . BLACK_CUN_T
				WinGetPos, X, Y, , EdtH, ahk_id %BLACK_CUN_T%
				WinMove ahk_id %BLACK_CUN_T%,, , , , (EdtH - 39)
				winSet, Style, 0x16860084,	ahk_id %BLACK_CUN_T%	
				SLEEP 500
				SEND {SPACE}
			}
		}
		case "MozillaDialogClass":
		{
			ecape_target = ahk_id %popoutyt%
			winget, Style, Style, ahk_id %BLACK_CUN_T%
			winget, exStyle, exStyle, ahk_id %BLACK_CUN_T%
			IF((STYLE = 0x16CE0084) && (EXSTYLE = 0x00000101) ) {
				popoutyt := BLACK_CUN_T
	
				winclose
				WinGetPos, X, Y, , EdtH, ahk_id %BLACK_CUN_T%
				WinMove ahk_id %BLACK_CUN_T%,, , , , (EdtH - 39)
				winSet, Style, 0x16860084, ahk_id %BLACK_CUN_T%	
				MSGBOX %popoutyt% `n Ahk_id %BLACK_CUN_T%
			}
		}
		case "DirectUIHWND":
		{
			fuk := WinExist("A")
			WinGetTitle, tits, ahk_id %fuk%
			if (tits = "Folder In Use") {
				asas := "AHK_Class WindowsForms10.Window.8.app.0.141b42a_r6_ad1"
				WinGet, hwnd2, ID , %asas%
				if asas {
					winclose ahk_id %hwnd2%
					winactivate, ahk_id %fuk%
					sleep 20
					send {left}
					send {enter}
					return
				}
			}
			else if (tits = "Confirm Folder Replace") {
				WinSetTitle, ahk_id %fuk%, , Confirm Folder Merge
				return
			}
			return
		}
		case "#32770":
		{		
			if (Title_last = "Information") {
				TOOLTIP c_nt
					SEND {N}
					RETURN
			}
		}
	}
	return
}

OnObjectDestroyed(Hook_ObjDestroyed, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	WinGetClass, Class, ahk_id %hWnd% 	
		if destroytt {
			wingettitle, Title_last, ahk_id %hWnd%	
			winGet PName, ProcessName, ahk_id %hWnd%
			tooltip OBJ_DESTROY EVENT:`n%PName%`n%Title_last%`nAHK_Class %Class%`nAHK_ID %hWnd%
		}
	switch Class {
		case "ApplicationFrameWindow","WINDOWSCLIENT":
		{
			WinGetTitle, Last_Title, ahk_id %hWnd% 
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
			}
		}
		return
	}
	return
}

; binds <<<---------------------------------------

~^s::	 
winGetActiveTitle, Atitle 
if winactive("ahk_exe notepad++.exe") {
	if instr(Atitle, ".ahk") { 
		if instr(Atitle, "*") {
			Atitle := StrReplace(Atitle, "*" , " ") 	; * denotes unsaved doc in np+ 
			SplitPath, Atitle, tName, npDir, npExtension, npNameNoExt, npDrive 
			TargetScriptName := (npNameNoExt . ".ahk"	), ser := npNameNoExt . ".ahk - AutoHotkey"
			if (npNameNoExt = "WinEvent") {
				if WinExist(ser) {
					MsgBox, 4,%ser% dtect`nReload AHK Script, Reload %TargetScriptName% now?`nTimeout in 6 Secs, 7
					ifmsgbox yes 
					{
						if (npNameNoExt = "WinEvent")
							reload
						else
							PostMessage, 0x0111, 65303,,, %TargetScriptName% - AutoHotkey		; Reload WMsg
					}
				}
			}
		}
	}
}
return

$^z:: 		;	"ctrl Z" - bypass "Undo." in Explorer.exe
if !winactive("AHK_Class WorkerW") && !winactive("AHK_Class Progman") && !winactive("AHK_Class CabinetWClass") 
	sendinput ^z
return

$^y:: 		; 	"ctrl Y" - bypass "Redo". in Explorer .exe
if !winactive("AHK_Class WorkerW") && !winactive("AHK_Class Progman") && !winactive("AHK_Class CabinetWClass") 
	sendinput ^y
return

!Shift:: 		; 	Windows 10 local language selection bypass (can be bypassed in settings)
+Alt::
if KB_Langswitch
	send A_ThisHotkey
;else	;tooltip bypassed
return

~Escape:: ; 
IF popoutyt{
	ecape_target = ahk_id %popoutyt%
	 ifwinactive(ecape_target) {
		msgbox
		winclose
	}
}
return

	;		 <------------< [ End of Script ] <------------<
	
	;		 >------------> [ Begin ... Functions ] >------------>
	
MessageBoxKill(Target_MSGBOX) {
	If Target_hwnd := WinExist(Target_MSGBOX) {
		winactivate
		sleep 10
		send n
		tooltip sent N
		settimer tooloff, -2000
		sleep 10
		if WinExist(ahk_ID %target_hwnd% ) {
			MsgBox_MsgBox_TargetHandle = ahk_id %hWnd4%
				WinGet, TargetPID, PID , % MsgBox_MsgBox_TargetHandle
				Target_PID=TASKKILL.exe /PID %TargetPID%
				run %comspec% /C %Target_PID%,, hide
			sleep 100
			if WinExist(MsgBox_MsgBox_TargetHandle ) {
				msgbox unable to close the target msgbox 
			} else{
				if !KillCount
					KillCount := 1
				else
					KillCount := KillCount + 1
				tooltip %KillCount% kills, 4000, 2000
				setTimer tooloff, -7000
			}
		}
	}
return
}

IsWindow(hWnd) {
 return DllCall("IsWindow", "Ptr", hWnd)
}

IsWindowEnabled(hWnd) {
 return DllCall("IsWindowEnabled", "Ptr", hWnd)
}

IsWindowVisible(hWnd) {
 return DllCall("IsWindowVisible", "Ptr", hWnd)
}

ShowWindow(hWnd, nCmdShow := 1) {
 DllCall("ShowWindow", "Ptr", hWnd, "Int", nCmdShow)
}

IsChild(hWnd) {
 WinGet Style, Style, ahk_id %hWnd%
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
	setTimer Elapsed_Timer, 180
	return

	Elapsed_Timer:
	Time_Elapsed := a_TickCount - StartTime
	if (Time_Elapsed > DMT) {	
		winClose MouseTextID
		X_X := false
		setTimer Elapsed_Timer, off
		winClose MouseTextID
		X_X := true
	}
	return
}

Hooks:
CRITICAL
OnMessage(0x4a, "Receive_WM_COPYDATA")

EVENT_4GND := 0x0003, OBJ_FOCUS:=0x8005, OBJ_CREATED := 0x8000, OBJ_DESTROYED := 0x8001, WIN_TARGET_DESC := "Information", MSG_WIN_TARGET := WIN_TARGET_DESC
Hook_4Gnd 			:= DllCall("SetWinEventHook", "UInt", EVENT_4GND, "UInt", EVENT_4GND, "Ptr", 0, "Ptr", (ForegroundChangeProc := RegisterCallback("On4ground", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)
Hook_Focus 			:= DllCall("SetWinEventHook", "UInt", OBJ_FOCUS, "UInt", OBJ_FOCUS, "Ptr", 0, "Ptr", (MsgBoxEventProc := RegisterCallback("OnFocus", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)
Hook_MsgBox 		:= DllCall("SetWinEventHook", "UInt", 0x0010, "UInt", 0x0010, "Ptr", 0, "Ptr", (MsgBoxEventProc := RegisterCallback("OnMsgBox", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)
Hook_ObjCreate 		:= DllCall("SetWinEventHook", "UInt", OBJ_CREATED, "UInt", OBJ_CREATED, "Ptr", 0, "Ptr", (lpfnWinEventProc 	:= RegisterCallback("OnObjectCreated", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002) 
Hook_ObjDestroyed := DllCall("SetWinEventHook", "UInt", OBJ_DESTROYED, "UInt", OBJ_DESTROYED, "Ptr", 0, "Ptr", (lpfnWinEventProc := RegisterCallback("OnObjectDestroyed", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)

OnExit("AtExit")
return


AtExit() {
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
return

FileListStrGen(abc) {
	adelim := abc
	if !oldlist
		oldlist := FileListStr
	else
		oldlist := FileListStr
	settimer FileListStrGen2, -500
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
}

Receive_WM_COPYDATA(wParam, lParam)
{
	StringAddress := NumGet(lParam + 2*A_PtrSize)
	CopyOfData := StrGet(StringAddress)
	if CopyOfData contains Þ ; <-- gonna be this delimiting a list of files (sent from context menu)
	{ 	; 		now generate a string of all in FileListStr 
		if !FileListStr {
			FileListStr := CopyOfData, FileCount := 1
		} else {
			FileListStr := (FileListStr . CopyOfData), FileCount := (FileCount + 1) ; FileListStr := FileListStr . "`n" . CopyOfData
		}
		FileListStrGen(Delimiter:="Þ") ; this will confirm filelist recieved, parsing into array
	}
	else if (CopyOfData = "RobloxFalse")
	{
		roblox := false
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
	else m2dstatus := "not running or paused"
	return true
}

gethandle_roblox() {
	loop 3 {
		winGet, Roblox_hWnd, id, AHK_Class WINDOWSCLIENT
		if !Roblox_Hwnd 
			roblox := False
		else break
	}
	return
}

Spunkmessagebox(handle) {
	if !8skin_crash 
		8skin_crash = 1
	else 
		8skin_crash := 8skin_crash + 1
	run C:\Apps\Kill.exe robloxplayerbeta.exe,, hide
	if winexist("ahk_id %handle%") {
		settimer turdss, -2000
		return
		turdss:
		run C:\Apps\Kill.exe robloxplayerbeta.exe,, hide
	}
}

RobloxGetHandle: 
winGet, Roblox_hWnd, id, AHK_Class WINDOWSCLIENT
if !Roblox_Hwnd {
	roblox := false
	send {shift up}
	settimer RobloxGetHandle2, -3000
}
return

RobloxGetHandle2:
Roblox_Hwnd := ""
loop 5 {
	winGet, Roblox_hWnd, id, AHK_Class WINDOWSCLIENT
	if !Roblox_Hwnd {
		tooltip, Exiting
		settimer tooloff, -2000
		Result 	:= Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle2)
		Result1 := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle),
	} else {
		roblox := true
		break
	}
	return
} 
return

SBAR_Restore:
if SBAR_DISABLE {
	if SBAR_2berestored_True {
		run % SidebarPath,, hide, 
		settimer beads, -1000
		return
		beads:
		WinGet, SideBar_Handle, ID, HUD Time
		Sidebar := 1, SBAR_2berestored_True := False
		winSet, ExStyle, +0x20, ahk_id %SideBar_Handle%
	}
}
return

Toggle_sbar:
if !SBAR_DISABLE{
	SBAR_DISABLE := True
	Tooltip Sidsebar will be disabled ingame
} Else {
	SBAR_DISABLE := False
	Tooltip Sidsebar will be enabled ingame
}
settimer tooloff, -1000
return

ahk_r() {
	run %AHK_Rare%
	return
}

Toggle_dbg:
if !dbg {
	dbg	:=	true
	listlines on
	#KeyHistory 900
	menu, tray, check, Toggle debug,
} else {
	listlines off
	#KeyHistory 0
	menu, tray, uncheck, Toggle debug,
	dbg	:=	false
}
return

m2drag_run:
a = "C:\Program Files\AHK\AutoHotkeyU32_UIA.exe" "C:\Script\AHK\Working\M2Drag.ahk"
run %a%,,hide,m2d_pid
return

wmp_matt_run:
a = "C:\Program Files\AHK\AutoHotkey.exe" "C:\Script\AHK\Z_MIDI_IN_OUT\wmp_Matt.ahk"
run %a%,,hide,mattwmp_pid
return

zinout:
a = "C:\Program Files\AHK\AutoHotkeyU32_UIA.exe" "C:\Script\AHK\Z_MIDI_IN_OUT\z_in_out.ahk"
run %a%,,hide,zinout_pid
return

YT_DL:
a = "C:\Program Files\AHK\AutoHotkeyU32_UIA.exe" "C:\Script\AHK\Working\YT.ahk"
run %a%,,hide,zinout_pid
return

4groundtt:
4groundtt := !4groundtt
if !4gtt {
	global 4gtt := true
	menu, tray, check, 4ground hook tip,
} else {
	menu, tray, uncheck, 4ground hook tip,
	4gtt 			:= false
}
return

focustt:
focustt := !focustt
if !4gtt {
	global 4gtt := true
	menu, tray, check, focus hook tip,
} else {
	menu, tray, uncheck, focus hook tip,
	4gtt 			:= false
}
return

creatett:
creatett := !creatett
if !crtt {
	global crtt 	:= true
	menu, tray, check, obj_create tip,
} else {
	menu, tray, uncheck, obj_create tip,
	crtt 			:= false
}
return

destroytt:
destroytt := !destroytt
if !dstt {
	global dstt := true
	menu, tray, check, obj_destroy tip,
} else {
	menu, tray, uncheck, obj_destroy tip,
	dstt 			:= false
}
return
pconfig:
e=C:\Windows\system32\schtasks.exe /run /tn "cmd_output_to_msgbox.ahk_407642875"
run %E%,, hide
return

adminHotkeyz:
a = "C:\Script\AHK\ADMIN_HOTKEYZ.lnk"
run %a%,,hide,adminHotkeyz_pid	
menu, tray, check, Launch AdminHotkeyz,
return

msgboxtt:
msgboxtt := !msgboxtt
if !mbtt {
	global mbtt := true
	menu, tray, check, msgbox hook tip,
} else {
	menu, tray, uncheck, msgbox hook tip,
	mbtt 			:= false
}
return

gadget_gayness:
WinGet, Time_hWnd, iD, HUD Time						
if errorlevel	
	msgbox %errorlevel%
else {
	winSet, ExStyle, 0x000800A8, ahk_id %Time_hWnd%		; SIDEBAR-CLOCK CLICK-THRU
	winSet, ExStyle, 0x000800A8, Moon Phase II
}
return

StyleDetect(hwnd,Style_xList,XTitle,XtitlesArray) {

	if fpos:=InStr(Style_xList, XTitle)  {
	;	tooltip % Style_xList " "XTitle 

		;tooltip % value " " index
		for index, value in XtitlesArray	{

			if fpos:=InStr(value, XTitle) {
				retpos 	:= RegExMatch(value, "(\µ)\K(.*)" , 		ret_class, p0s := 1) 
				retpos 	:= RegExMatch(value, "^0.{9}" , 			ret_style, p0s := 1)
				retpos 	:= RegExMatch(value, "(\»)\K(.{10})" , 	ret_exstyle, p0s := 1)
				WinSet, Style, 		% ret_style, 	% "ahk_id" hwnd
				WinSet, ExStyle, 	% ret_exstyle, 	% "ahk_id" hwnd
				;msgbox %XTitle% detected`n%ret_style%`n%ret_exstyle%
			}
	}}
}

toggle_m2drag_bypass:
ttt := "M2Drag.ahk - AutoHotkey", result := Send_WM_COPYDATA("Bypass_Last_Dragged_GUI",ttt)
return


Stylemenu_init:
; tooltip % "Analyzing, please wait"
TargetHandle := "", style:=""
if Dix
	Menu F, DeleteAll
Dix:= true

MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
TargetHandle = ahk_id %OutputVarWin%

WinGetTitle, TargetTitle, ahk_id %OutputVarWin%
if !TargetTitle 
return
winGet PName, ProcessName, ahk_id %OutputVarWin%
WinGet, Style2, Style, ahk_id %OutputVarWin%
WinGet, ExStyle2, ExStyle, ahk_id %OutputVarWin%

MainMenu:
Menu F, add, %PName%, donothing,
Menu F, Disable, %PName%
Menu F, add , , , 

Menu F, add, % sysmenu, toggle_sysmenu
if (Style2 & 0x00080000)
	Menu F, check, % SysMenu
else	Menu F, uncheck, % SysMenu

Menu F, add, % Clickthru, toggle_Clickthru
if (ExStyle2 & 0x00000001)
	Menu F, check, % Clickthru
else 	Menu F, uncheck, % Clickthru

Menu F, add, % AppWindow, toggle_AppWindow
if (ExStyle2 & 0x00040000)
	Menu F, check, % AppWindow
else 	Menu F, uncheck, % AppWindow
goto Sumenu_items

Submenus:
Menu F, 	add, Frame / & X Controls, 	:S1
Menu F, 	add, Scrollbars, 					:S2
Menu F, 	add, Layout, 						:S3
goto othermenus

Sumenu_items:
Menu S1, add, DLG Frame, toggle_DLGFRAME
if (Style2 & 0x00400000)
	Menu S1, check, DLG Frame
else Menu S1, uncheck, DLG Frame
	
Menu S1, add, THICK Frame, toggle_thickframe
if (Style2 & 0x00040000)
	Menu S1, check, THICK Frame,
else Menu S1, uncheck, THICK Frame
	
Menu S1, add, Modal Frame, toggle_Modalframe
if (ExStyle2 & 0x00000001)
	Menu S1, check, Modal Frame,
else Menu S1, uncheck, Modal Frame
	
Menu S1, add, Static edge, toggle_staticedge
if (ExStyle2 & 0x00020000) 
	Menu S1, check, Static edge,
else Menu S1, uncheck, Static edge

Menu S1, add, %Maxbox%, toggle_Maxbox
if (Style2 & 0x00010000)
	Menu S1, check, %Maxbox%
else Menu S1,uncheck, %Maxbox%

Menu S1, add, %MinBox%, toggle_MinBox
if (Style2 & 0x00020000)
	Menu S1, check, %MinBox%
else Menu S1, uncheck, %MinBox%

Menu S2, add, HScroll, toggle_hscroll
if (Style2 & 0x00100000)
	Menu S2, check, HScroll 
else Menu S2, uncheck, HScroll 

Menu S2, add, VScroll, toggle_hscroll
if (Style2 & 0x00200000)
	Menu S2, check, VScroll 
else Menu S2, uncheck, VScroll 

Menu S2, add, %LeftScroll%, toggle_LeftScroll
if (ExStyle2 & 0x00004000)
	Menu S2, check, %LeftScroll%
else Menu S2, uncheck, %LeftScroll%
	
Menu S3, add, %RightAlign%, toggle_RightAlign
if (ExStyle2 & 0x00001000)
	Menu S3, check, %RightAlign% 
else Menu S3, uncheck, %RightAlign%
	
Menu S3, add, %RightoLeft%, toggle_RightoLeft
if (ExStyle2 & 0x00002000)
	Menu S3, check, %RightoLeft%
else Menu S3, uncheck, %RightoLeft%
gosub Submenus
return

othermenus: ; below submenus
Menu F, 	add, m2drag bypass, toggle_m2drag_bypass
Menu F, 	Icon, m2drag bypass, % mouse24
Menu F, 	add, %Save% , Savegui
gosub showw
return

showw:
tooltip
Menu F, Show
return
;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
donothing:
return

toggle_sysmenu:
WinSet, Style, ^0x00080000, ahk_id %OutputVarWin%
goto ResetMenu

toggle_DLGFRAME:
WinSet, Style, ^0x00400000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_thickframe:
WinSet, Style, ^0x00040000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_modalframe:
WinSet, ExStyle, ^0x00000001, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_border:
WinSet, Style, ^0x00040000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_raisededge:
WinSet, ExStyle, ^0x00000100, ahk_id %OutputVarWin%
goto ResetMenu

toggle_sunkenedge:
WinSet, ExStyle, ^0x00000100, ahk_id %OutputVarWin%
goto ResetMenu

toggle_staticedge:
WinSet, ExStyle, ^0x00020000, ahk_id %OutputVarWin%
goto ResetMenu

toggle_3dedge:
WinSet, ExStyle, ^0x00020000, ahk_id %OutputVarWin%
goto ResetMenu

toggle_MinBox:
WinSet, Style, ^0x00020000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_Maxbox:
WinSet, Style, ^0x00010000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_hscroll:
WinSet, Style, ^0x00100000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_vscroll:
WinSet, Style, ^0x00200000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_LeftScroll:
WinSet, ExStyle, ^0x00004000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_Clickthru:
WinSet, ExStyle, ^0x00000020, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_RightAlign:
WinSet, ExStyle, ^0x00001000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_RightoLeft:
WinSet, ExStyle, ^0x00002000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_AppWindow:
WinSet, ExStyle, ^0x00040000, ahk_id %OutputVarWin% 
goto ResetMenu

SAVEGUI:
winGet save_new_ProcName, ProcessName, ahk_id %OutputVarWin%
winGetTitle save_new_Title, ahk_id %OutputVarWin%
winGetClass save_new_Class, ahk_id %OutputVarWin%
WinGet, Style, Style, ahk_id %OutputVarWin%
WinGet, ExStyle, ExStyle, ahk_id %OutputVarWin%
if !Style or !ExStyle
	msgbox error
gui, SaveGuI:new , , SAVE WINDOW STYLES
gui +hwndSaveGuI_hWnd
gui, SaveGuI:add, checkbox, vTProcName ,Process %save_new_ProcName%
gui, SaveGuI:add, checkbox, vTTitle ,WindowTitle %save_new_Title%
gui, SaveGuI:add, checkbox, vTClass ,save Class %save_new_Class%
gui, SaveGuI:add, button, default gSaveGUISubmit w80, Save (Enter)
gui, SaveGuI:add, button, w80 gSaveGUIDestroy, Cancel (Esc)
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
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\wintitle, 		% Style . "»" . exStyle . "»" . "µ" . save_new_ProcName . "µ" . save_new_Title . "µ" . save_new_Class, % save_new_Title
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

RegReadStyles:
Loop, Reg, % wintitlekey
{
    if (A_LoopRegType = "REG_SZ") {
        value1 	:= A_LoopRegKey . "\" . A_LoopRegSubKey
        regRead, value2, %value1%, %A_LoopRegName%
		Style_wintitleList2 := Style_wintitleList2 . value2 . "‡"	
		retpos 	:= RegExMatch(A_LoopRegName, "^0.{9}" , 			ret_style, p0s := 1)
		retpos 	:= RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , 	ret_exstyle, p0s := 1)
		Array_wintitleList.push(ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
	}
}
Loop, Reg, % procnamekey
{
    if (A_LoopRegType = "REG_SZ") {
        value1 := A_LoopRegKey . "\" . A_LoopRegSubKey
        regRead, value2, %value1%, %A_LoopRegName%
		Style_procnameList2 := Style_procnameList2 . value2 . "‡"	
		retpos := RegExMatch(A_LoopRegName, "^0.{9}" , ret_style, p0s := 1)
		retpos := RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , ret_exstyle, p0s := 1)
		Array_ProcnameList.push(ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
		}
}
Loop, Reg, % classnamekey
{
    if (A_LoopRegType = "REG_SZ") {
        value1 := A_LoopRegKey . "\" . A_LoopRegSubKey
        regRead, value2, %value1%, %A_LoopRegName%
		Style_ClassnameList2 := Style_ClassnameList2 . value2 . "‡"	
		retpos := RegExMatch(A_LoopRegName, "^0.{9}" , ret_style, p0s := 1)
		retpos := RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , ret_exstyle, p0s := 1)
		Array_LClass.push(ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
	}
}
return

Open_script_folder:
e = explorer /select,%a_ScriptFullPath%
tooltip %a_ScriptFullPath%
run %comspec% /c %e%,,hide,
tooloff:
tooltip
return 

TrayMenu:
menu, tray, NoStandard
menu, tray, Add, Open script folder, Open_script_folder,
menu, tray, add, 4ground hook tip, 4groundtt,
menu, tray, add, focus hook tip, focustt,
menu, tray, add, obj_create tip, creatett,
menu, tray, add, obj_destroy tip, destroytt,
menu, tray, add, msgbox hook tip, msgboxtt,
menu, tray, add, Toggle debug, Toggle_dbg,
menu, tray, add, Toggle Sidebar off ingame, Toggle_sbar
menu, tray, add, Launch PowerConfig, pconfig
menu, tray, add, Launch M2Drag, m2drag_run
menu, tray, add, Launch WMP_MATT, wmp_matt_run
menu, tray, add, Launch midi_in_out, zinout
menu, tray, add, Launch AdminHotkeyz, adminHotkeyz
menu, tray, add, Launch YouTube_DL, YT_DL
menu, tray, Standard
menu, tray, Icon, Context32.ico
return

Globals:
global AF := (Script . af_1), global AF2 := (Script . Bun_), global AutoFireScript := BF, global AutoFireScript2 := BF2 , global TargetScriptTitle := (AutoFireScript . " ahk_class AutoHotkey"), global TargetScriptTitle2 := (AutoFireScript2 . " ahk_class AutoHotkey"), global AHK_Rare := "C:\Script\AHK\- Script\AHK-Rare-master\AHKRareTheGui.ahk", global SidebarPath := "C:\Program Files\Windows Sidebar\sidebar.exe", global AF_Delay := 10, global SysShadowStyle_New := 0x08000000, global SysShadowExStyle_New := 0x08000020, global toolx := "-66", global offsett := 40, global KILLSWITCH := "kill all AHK procs.ahk", global starttime, global text, global X_X, global Last_Title, global autofire, global RhWnd_old, global MouseTextID, global DMT, global roblox, global toggleshift, global Norm_menuStyle, global Norm_menuexStyle, global Title_Last, global Title_last, global dcStyle, global classname, global tool, global tooly, global EventLogBuffer_Old, global Roblox_hwnd, global Time_Elapsed, global KillCount, global SBAR_2berestored_True, global Sidebar, global 4groundtt, global focustt, global creatett, global destroytt, global msgboxtt, global dbg, global TClass, global TTitle, global TProcName, global delim, global delim2, global TitleCount, global ClassCount, global ProcCount, global style2, global exstyle2, delim := "µ", delim2 := "»", global ArrayProc, global ArrayClass, global ArrayTitle, global Array_LProc, global Array_LTitle, global Array_LClass, global Style_ClassnameList2, global Style_procnameList2, global Style_wintitleList2, global popoutyt, global Script_Title, global np, global m2dstatus, global 4skin_crash, global 8skin_crash, global OutputVarWin, global F, global s1, global s2, global s3, global delim := "Þ", global FileListStr, global oldlist, global FileCount, global FileListStr_array := [], GLOBAL ADELIM

return

Locals:
global SysMenu	:= 	"Title (+ & X Conrols) (SysMenu)"
global Maxbox 		:= 	"Maximise Button (□)"
global MinBox 		:= 	"Minimise Button (_)"
global LeftScroll 		:= 	"Left Scroll Orientation"
global ClickThru 		:= 	"Click-through"
global RightAlign	:= 	"Generic Right-alignment"
global RightoLeft	:= 	"Right-to-Left reading"
global AppWindow	:= 	"Taskbar Item (not 100%)"
global Save 			:= 	"Save window style preferences"
global Reset 			:= 	"Reset window style preferences"

stylekey 				:= 	"HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles"
wintitlekey 				:= 	stylekey . "\wintitle"
procnamekey 		:= 	stylekey . "\procname"
classnamekey 		:= 	stylekey . "\classname"

test := Style2 . "»" . exStyle2 . "»" . "µ" . save_new_ProcName . "µ" . save_new_Title . "µ" .  "µ" . save_new_Class

mouse24 	:= "C:\Script\AHK\Working\mouse24.ico"
Script 		:= "C:\Script\AHK"
BF 			:= "Roblox_Rapid.ahk"
BF2 			:= "Roblox_Bunny.ahk"
af_1 			:= "\" . BF
Bun_ 		:= "\" . BF2

ArrayProc 			:= []
ArrayClass 		:= []
ArrayTitle			:= []
Array_LProc 		:= []
Array_LTitle 		:= []
Array_LClass 		:= []

return

 ; Notes for popup: NP++; ahk_id 0x2e1120 PID: 8332; process name AutoHotkey.exe; Title Get Parameters; AHK_Class AutoHotkeyGUI; Style / ExStyle 0x940A0000 - 0x00000088; Control Edit1 C_hWnd: 0x130c78 ; Style / ExStyle 0x50010080 - 0x00000200