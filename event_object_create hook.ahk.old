#NoEnv
#Persistent
DetectHiddenWindows on
coordMode tooltip screen
SetTitleMatchMode 2
SetBatchLines -1
ListLines, Off
Menu, Tray, NoStandard
Menu, Tray, Add, Open script folder, Open_script_folder,
Menu, Tray, Standard
Menu, Tray, Icon, Context32.ico
Script := "C:\Script\AHK"
BF := "Roblox_Rapid.ahk"
BF2 := "Roblox_Bunny.ahk"
af_1 := "\" . BF 
Bun_ := "\" . BF2
global AF := Script . af_1  
global AF2 := Script . Bun_
global TargetScriptTitle := AutoFireScript . " ahk_class AutoHotkey"
global TargetScriptTitle2 := AutoFireScript2 . " ahk_class AutoHotkey"
global AutoFireScript := BF, global AutoFireScript2 := BF2 
global starttime, global text, global xx, global xxx, global Last_Title, global AF_Delay := 10, global autofire, global RhWnd_old, global MouseTextID, global cunt, global DMT, global roblox, global toggleshift, global newSysShadow_style := 0x08000000, global newSysShadow_styleex := 0x08000020, global Norm_menuStyle, global Norm_menuexStyle, global Title_Last, global dcStyle, global classname, global tool, global toolx := "-66", global tooly, global offsett := 40, global Logger_Stack_Old, global Roblox_hwnd, global t_elapsed, Global KillCount, global KILLSWITCH := "kill all AHK procs.ahk"

OBJ_CREATED := 0x8000, OBJ_DESTROYED := 0x8001, WIN_TARGET_DESC := "Information", AHK_Rare := "C:\Script\AHK\- Script\AHK-Rare-master\AHKRareTheGui.ahk"
MSG_WIN_TARGET=%WIN_TARGET_DESC%

Hook_ObjCreate := DllCall("SetWinEventHook", "UInt", OBJ_CREATED, "UInt", OBJ_CREATED, "Ptr", 0, "Ptr", (lpfnWinEventProc := RegisterCallback("OnObjectCreated", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002) 

Hook_ObjDestroyed := DllCall("SetWinEventHook", "UInt", OBJ_DESTROYED, "UInt", OBJ_DESTROYED, "Ptr", 0, "Ptr", (lpfnWinEventProc := RegisterCallback("OnObjectDestroyed", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)

Hook_MsgBox_Obj := DllCall("SetWinEventHook", "UInt", 0x0010, "UInt", 0x0010, "Ptr", 0, "Ptr", (MsgBoxEventProc := RegisterCallback("OnMsgBox", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)

WinGet, Time_hWnd, iD, HUD Time						
if errorlevel
	msgbox %errorlevel%
winSet, ExStyle, 0x000800A8, ahk_id %Time_hWnd%		; SIDEBAR-CLOCK CLICK-THRU
winSet, ExStyle, 0x000800A8, Moon Phase II

OnMsgBox(Hook_MsgBox_Obj, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	If WinExist("Information") MSG_WIN_TARGET=Information
	If WinExist("Reminder") MSG_WIN_TARGET=Reminder
		WIN_TARGET_DESC=%MSG_WIN_TARGET%
		MessageBoxKill(MSG_WIN_TARGET)
	If WinExist(KILLSWITCH)
		Exitapp
}

MessageBoxKill(Target_MSGBOX) {
	If WinExist(Target_MSGBOX) {		
		winactivate
		send n
	if !KillCount
		KillCount = 1
	else
		KillCount := KillCount + 1
	tooltip %KillCount% kills, 4000, 2000
	settimer tooloff, -7000
		}
}
return 

OnObjectCreated(Hook_ObjCreate, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	WinGetClass Class, ahk_id %hWnd%
	switch Class {
		case "NotifyIconOverflowWindow","DropDown","BaseBar","TaskListThumbnailWnd","Net UI Tool Window Layered":
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
		case "RegEdit_RegEdit,FM":
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
			return
		}
		case "ApplicationFrameWindow","Chrome_WidgetWin_1","WINDOWSCLIENT":
		{
			sleep 5000
			wingettitle, Title_Last, ahk_id %hwnd%	
		;	tooltip % Title_Last " " hwnd " " class
			if Title_Last=Roblox
			{
				;run "C:\Program Files\AHK\AutoHotkeyU32_UIA.exe" "%AF%"
				run "%AF%"
				sleep 2000
				Roblox_hwnd =% hwnd
			}
			;winGet dcStyle, Style, ahk_id %hWnd%
			;if (dcStyle = 0x14030000) { 	
				;parent := GetParent(hWnd) 
		;		winSet, Style, +0x00840000,, ahk_id %parent%  	; give thick frame (dropshadow)
			;	tooltip % parent "111" clacker hwnd
		;	}
			return
		}
		case "ListBox","WMPMessenger","Scintilla":
		{
			return
		}	
		case "SysShadow":
		{
			winSet, transparent , 1,  ahk_id %hwnd%
			return
		}
	;	case "MozillaDropShadowWindowClass":
	;	{
			; winSet, transparent , 230,  ahk_id %hwnd%
			; winSet, ExStyle, 0x00000181, ahk_id %hWnd% 		;		copied from regular menus and no joy
			; winSet, Style, 0x84800000, ahk_id %hWnd%	
		;SetAcrylicGlassEffect(hWnd) 
	;	return
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
					if !Logger_Stack_Old {
						Logger_Stack_Old=%class%`n
					} else {
						clist=%Logger_Stack_Old%%class%`n
						Logger_Stack_Old = % CLIST
					}
					tooly = % offset
					;tooltip, %tool% %clist%, %toolx%, %tooly%
					classname=%Class%`n
					settimer Logger_Stack_Push, -4000
				}
			}
			return
		}
	}
Return

	Logger_Stack_Push:
	If !Logger_Stack
		Logger_Stack = % Logger_Stack_Old
	else
		Logger_Stack=%Logger_Stack%`n%Logger_Stack_Old%
	tooltip,,,2
	tooltip
	Logger_Stack_Old:="", clist:="", offset:="", tool:=""
	return
}

OnObjectDestroyed(Hook_ObjDestroyed, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	WinGetClass, Class, ahk_id %hWnd% 	
	switch Class {
		case "ApplicationFrameWindow","WINDOWSCLIENT":
			WinGetTitle, Last_Title, ahk_id %hWnd% 
			if ( Last_Title != "Roblox" ) {
				if Roblox_hwnd =% hwnd
					Roblox := True
				else 
					winget, Roblox_hwnd, ID, "Roblox" 
			} else
			if ( Last_Title = "Roblox" ) {	;winclose, ahk_id %hwnd%
				Roblox := False
				Result := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle)
				if (result = "FAIL")
					Display_Msg("SendMessage failed.", "1000", "True")
				sleep 500
				Result := Send_WM_COPYDATA("RobloxClosing", TargetScriptTitle2)
				if (result = "FAIL")
					Display_Msg("SendMessage failed.", "1000", "True")
				else if (result = 0)
					Display_Msg("Roblox Exiting: Scripts Closing", "1000", "True")
				return
			}
		}
return
}

IsWindow(hWnd) {
    Return DllCall("IsWindow", "Ptr", hWnd)
}

IsWindowEnabled(hWnd) {
    Return DllCall("IsWindowEnabled", "Ptr", hWnd)
}

IsWindowVisible(hWnd) {
    Return DllCall("IsWindowVisible", "Ptr", hWnd)
}

ShowWindow(hWnd, nCmdShow := 1) {
    DllCall("ShowWindow", "Ptr", hWnd, "Int", nCmdShow)
}

IsChild(hWnd) {
    WinGet Style, Style, ahk_id %hWnd%
    Return Style & 0x40000000 ; WS_CHILD
}

GetParent(hWnd) {
    Return DllCall("GetParent", "Ptr", hWnd, "Ptr")
}

SetAcrylicGlassEffect(hWnd) {
	Static init, accent_state := 4,
	Static pad := A_PtrSize = 8 ? 4 : 0, WCA_ACCENT_POLICY := 19
	accent_size := VarSetCapacity(ACCENT_POLICY, 200, 0) 
	NumPut(accent_state, ACCENT_POLICY, 0, "int")
	NumPut(0x77400020, ACCENT_POLICY, 8, "int")
	VarSetCapacity(WINCOMPATTRDATA, 4 + pad + A_PtrSize + 4 + pad, 0)
	&& NumPut(WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0, "int")
	&& NumPut(&ACCENT_POLICY, WINCOMPATTRDATA, 4 + pad, "ptr")
	&& NumPut(accent_size, WINCOMPATTRDATA, 4 + pad + A_PtrSize, "uint")
	If !(DllCall("user32\SetWindowCompositionAttribute", "ptr", hWnd, "ptr", &WINCOMPATTRDATA))
		Return 0
	Return 1
}

Display_Msg(Text, Display_Msg_Time, xx) {
	DMT =% Display_Msg_Time 
	StartTime := A_TickCount
	xx:=
	wingetpos, WindowX, WindowY, WindowWidth, WindowHeight, Roblox
	xmid := (windowx + (WindowWidth/2)) - 45, ymid := (WindowY + (WindowHeight/2)) - 20
	textx:=x+100, texty:=y+100
	splashimage,,b 0000EFFF ct00EFFF x%xmid% y%ymid%,,%text%,MouseTextID
	winSet,transcolor,00000000 254,MouseTextID
	mousegetpos,x,y
	textx:=xmid, texty:=ymid
	winmove,MouseTextID,,%textx%,%texty%
	settimer elapsed_timer, 180
	return
	elapsed_timer:
	t_elapsed := A_TickCount - StartTime
	if ( t_elapsed > DMT)	{	
		winclose MouseTextID
		cunt := ""
		xx := false
		settimer elapsed_timer, off
		bk:
		winclose MouseTextID
		xx := true
	}
	return
}

OnExit("AtExit")
AtExit() {
	splitpath A_ScriptFullPath,,,, OutNameNoExt
	pap := "`n", 
	no_tooth=%OutNameNoExt%.txt
	if !fileexist(no_tooth)
		pap := ""
	FileAppend , `n%Logger_Stack%, %no_tooth%
	winSet, Transparent, 0 , ahk_id %hWnd%
	global Hook_ObjCreate, lpfnWinEventProc, lpfnWinEventProc2
	global Hook_MsgBox_Obj, MsgBoxEventProc
	global Hook_ObjDestroyed, lpfnWinEventProc
if (Hook_MsgBox_Obj)
		DllCall("UnhookWinEvent", "Ptr", Hook_MsgBox_Obj), Hook_MsgBox_Obj := 0
	if (MsgBoxEventProc)
		DllCall("GlobalFree", "Ptr", MsgBoxEventProc, "Ptr"), MsgBoxEventProc := 0	
	if (Hook_ObjCreate)
		DllCall("UnhookWinEvent", "Ptr", Hook_ObjCreate), Hook_ObjCreate := 0
	if (lpfnWinEventProc)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc, "Ptr"), lpfnWinEventProc := 0	
	if (Hook_ObjDestroyed)
		DllCall("UnhookWinEvent", "Ptr", Hook_ObjDestroyed), Hook_ObjDestroyed := 0
	if (lpfnWinEventProc2)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc2, "Ptr"), lpfnWinEventProc2 := 0	
	Return 0
}

Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle)
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize) 
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    TimeOutTime := 4000
    SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%,,,, %TimeOutTime%
    DetectHiddenWindows %Prev_DetectHiddenWindows%
    SetTitleMatchMode %Prev_TitleMatchMode%
    return ErrorLevel
}


ahk_r:
run %AHK_Rare%
return

tooloff:
tooltip
return


Open_script_folder:
tooltip %A_ScriptFullPath%
e=explorer /select,%A_ScriptFullPath%
Run %Comspec% /c %e%,,hide
Return