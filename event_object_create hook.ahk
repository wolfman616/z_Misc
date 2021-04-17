#NoEnv
#Persistent
DetectHiddenWindows on
SetTitleMatchMode 2
SetBatchLines -1
Menu, Tray, NoStandard
Menu, Tray, Add, Open script folder, Open_script_folder,
Menu, Tray, Standard
Menu, Tray, Icon, Context32.ico
coordMode tooltip screen
global newSysShadow_style := "0x08000000"
global newSysShadow_styleex := "0x08000020"
global classname, global tool, global toolx := "-66", global tooly, global offsett := 40,
global clistold,
;DllStructCreate("int cxLeftWidth;int cxRightWidth;int cyTopHeight;int cyBottomHeight;")
;NumPut("int cxLeftWidth;int cxRightWidth;int cyTopHeight;int cyBottomHeight;", Size * 2, 0}
hWinEventHook := DllCall("SetWinEventHook", "UInt", 0x8000, "UInt", 0x8000, "Ptr", 0, "Ptr", (lpfnWinEventProc := RegisterCallback("OnEvent", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)		;  EVENT_OBJECT_CREATE := 0x8000

WinGet, Timehandle, iD, HUD Time								; SIDEBAR CLOCKTRANS
if errorlevel
	msgbox %errorlevel%
WinSet, ExStyle, 0x000800A8, ahk_id %Timehandle%
WinSet, ExStyle, 0x000800A8, Moon Phase II
return

OnEvent(hWinEventHook, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	WinGetClass Class, ahk_id %hWnd%
	if Class in NotifyIconOverflowWindow,DropDown,BaseBar,TaskListThumbnailWnd,Net UI Tool Window Layered
	{
		WinSet, TransColor, 0xff0000 , ahk_id %hWnd%
		WinSet, ExStyle, ^0x00000100, ahk_id %hWnd%
		WinSet, Style, 0x94000000, ahk_id %hWnd%
}

	else if Class in #32768	
	{
		; WinSet, TransColor, 0x000000 , ahk_id %hWnd%
		; WinSet, ExStyle, 0x00000100, ahk_id %hWnd%
		; WinSet, Style, 0x94000000, ahk_id %hWnd%
		return
	}
	else if Class in TaskListThumbnailWnd	
	{

	}
	else if Class in RegEdit_RegEdit,FM 
	{ 
		ControlGet, ctrlhand, Hwnd,, SysListView321, ahk_id %hWnd%
		SendMessage 0x1036, 0, 0x00000020,, ahk_id %ctrlhand% ; 
	}
	else if Class = 7 Sidebar 
	{
		winGet, Timehandle, iD, ahk_class 7 Sidebar
		winSet, ExStyle, 0x000800A8, HUD Time, ahk_id %Timehandle%
		winSet, ExStyle, 0x000800A8, Moon Phase II
	}
	else if Class = Chrome_WidgetWin_1 
	{
		wingettitle, turdy, ahk_id %hwnd%
		if InStr(turdy, "Discord")  {
			winGet Style, Style, ahk_id %hWnd%
			if Style & 0x40000000 ;	 WS_CHILD
			{ 	
				msgbox
				parent := GetParent(hWnd) 
				winSet, Style, +0x00040000,, ahk_id %parent% ;give thick frame (dropshadow)
				tooltip % parent "111" clacker hwnd
			}
		}
	} 
	else if class in ListBox,WMPMessenger,Scintilla 
	{
		return
	}	
	else if class in SysShadow
	{
		winSet, transparent , 1,  ahk_id %hwnd%
	}
	 else if class in MozillaDropShadowWindowClass
	{
		winget, Style, Style, ahk_id %hwnd%
		winget, exStyle, exStyle, ahk_id %hwnd%
		tooltip % Style "`n" exStyle
	} 
	else 
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
				if !clistold {
					clistold=%class%`n
				} else {
					clist=%CLISTold%%class%`n
					CLISTold = % CLIST
				}
				tooly = % offset
				;tooltip, %tool% %clist%, %toolx%, %tooly%
				classname=%Class%`n
				settimer Fuck_Off, -4000
			}
		}
	}
	
	Return
	Fuck_Off:
	If !CLOG
		CLOG = % CLISTold
	else
		clog=%clog%`n%clistold%
	tooltip,,,2
	tooltip
	CLISTold:="", clist:="", offset:="", tool:=""
	return
}
return
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
	If !(DllCall(	"user32\SetWindowCompositionAttribute", "ptr", hWnd, "ptr", &WINCOMPATTRDATA))
		Return 0
	Return 1
}

OnExit("AtExit")
AtExit() {
	no_tooth=%OutNameNoExt%.txt
	pap := "`n"
	splitpath A_ScriptFullPath,,,, OutNameNoExt
	if !fileexist(no_tooth)
		pap := ""
	FileAppend , `n%clog%, %no_tooth%
	WinSet, Transparent, 255 , ahk_id %hWnd%
	global hWinEventHook, lpfnWinEventProc
	if (hWinEventHook)
		DllCall("UnhookWinEvent", "Ptr", hWinEventHook), hWinEventHook := 0
	if (lpfnWinEventProc)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc, "Ptr"), lpfnWinEventProc := 0	
	Return 0
}

Open_script_folder:
tooltip %A_ScriptFullPath%
e=explorer /select,%A_ScriptFullPath%
Run %Comspec% /c %e%,,hide
Return