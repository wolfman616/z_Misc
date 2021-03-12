#NoEnv
#Persistent
DetectHiddenWindows on
SetTitleMatchMode 2
SetBatchLines -1

Menu, Tray, NoStandard
Menu, Tray, Add, Open script folder, Open_script_folder,
Menu, Tray, Standard
Menu, Tray, Icon, Context32.ico

hWinEventHook := DllCall("SetWinEventHook", "UInt", 0x8000, "UInt", 0x8000, "Ptr", 0, "Ptr", (lpfnWinEventProc := RegisterCallback("OnEvent", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)		;  EVENT_OBJECT_CREATE := 0x8000

OnMessage(0x4a, "Receive_WM_COPYDATA")  ; 0x4a WM_COPYDATA
Return

Receive_WM_COPYDATA(wParam, lParam) {
    StringAddress := NumGet(lParam + 2*A_PtrSize)  ; Retrieves the CopyDataStruct's lpData member.
    CopyOfData := StrGet(StringAddress)  ; Copy the string out of the struct
    ;ToolTip %A_ScriptName%`nReceived the following string:`n%CopyOfData%
	Run %COMSPEC% /c explorer.exe /select`, "%CopyOfData%" ,, Hide
    return true  ; Returning 1 (true) is the traditional way to acknowledge this message.
}

OnEvent(hWinEventHook, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	WinGetClass Class, ahk_id %hWnd%
	if Class in #32768,#32769,NotifyIconOverflowWindow,Net UI Tool Window Layered,DropDown,BaseBar,TaskListThumbnailWnd
	{
		SetAcrylicGlassEffect(hWnd)
		Return
	}	
	Else if Class in RegEdit_RegEdit,FM
	{	
		ControlGet, ctrlhand, Hwnd,, SysListView321, ahk_id %hWnd%
		SendMessage 0x1036, 0, 0x00000020,, ahk_id %ctrlhand% ; 
	}
	Else if Class = 7 Sidebar
		WinSet, ExStyle, 0x000800A8, HUD Time, ahk_id %hWnd%
else if(class = "Chrome_WidgetWin_1") {
	wingettitle, turdy, ahk_id %hwnd%
	if(clacker := InStr(turdy, "Discord"))
		    WinGet Style, Style, ahk_id %hWnd%
    if Style & 0x40000000 ; WS_CHILD
		{
			msgbox
			parent := GetParent(hWnd) 
			WinSet, Style, +0x0004,, ahk_id %parent% ;give thick frame (dropshadow)
			tooltip % parent " " clacker hwnd
		}
			
	}
}
    
GetParent(hWnd) {
    Return DllCall("GetParent", "Ptr", hWnd, "Ptr")
}

IsChild(hWnd) {
    WinGet Style, Style, ahk_id %hWnd%
    Return Style & 0x40000000 ; WS_CHILD
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

OnExit("AtExit")
AtExit() {
	WinSet, Transparent, 255 , ahk_id %hWnd%
	global hWinEventHook, lpfnWinEventProc
	if (hWinEventHook)
		DllCall("UnhookWinEvent", "Ptr", hWinEventHook), hWinEventHook := 0
	if (lpfnWinEventProc)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc, "Ptr"), lpfnWinEventProc := 0	
	Return 0
}

Open_script_folder:
;Run %A_ScriptDir%
tooltip %A_ScriptFullPath%
gump=explorer /select,%A_ScriptFullPath%
Run %Comspec% /c %gump%,,hide
Return