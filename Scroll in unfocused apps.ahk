#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#persistent
#singleinstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
global Mouse_ClassNN

+PgDn::    ;Wheel Right = page down without interfering with selection
	MouseGetPos,,, Mouse_hWnd, Mouse_ClassNN
	WinGetClass, Active_WinClass , A
	WinGetClass, Mouse_WinClass , ahk_id %Mouse_hWnd%
	WinGetTitle Mouse_WinTitle, ahk_id %Mouse_hWnd%
	ControlGet, Mouse_ControLhWnd, Hwnd ,, %Mouse_ClassNN%, ahk_id %Mouse_hWnd%
	if Active_WinClass != Mouse_WinClass
		background_page_scrolling:=1
	if Mouse_WinClass in MozillaWindowClass
		{
		controlsend, %Mouse_ClassNN%, { PgDn }, ahk_id %Mouse_hWnd%
		tooltip cunt %Mouse_ClassNN%
		}
	else if Mouse_WinClass in CabinetWClass,Notepad++
		{
		if Mouse_ClassNN=DirectUIHWND2
			SendMessage, 0x115, 3, 2, ScrollBar2,  ahk_id %Mouse_hWnd%
		else	
			SendMessage, 0x115, 3, 2, %Mouse_ClassNN%,  ahk_id %Mouse_hWnd%

	} else {
		tooltip unknown process`n%Mouse_ClassNN%`n%Mouse_WinTitle%
		SetTimer, ToolOff, -1200
		}
	Return    

+PgUp::    ;Wheel Left = page up without interfering with selection
	MouseGetPos, ax, ay, Mouse_hWnd, Mouse_ClassNN
	WinGetClass, Active_WinClass , A
	WinGetClass, Mouse_WinClass , ahk_id %Mouse_hWnd%
	WinGetTitle Mouse_WinTitle, ahk_id %Mouse_hWnd%
	ControlGet, Mouse_ControLhWnd, Hwnd ,, %Mouse_ClassNN%, ahk_id %Mouse_hWnd%
	if Active_WinClass != Mouse_WinClass
		background_page_scrolling:=1
	if Mouse_WinClass in MozillaWindowClass
		controlsend, %Mouse_ClassNN%, { PgUp }, ahk_id %Mouse_hWnd%
	else if Mouse_WinClass in CabinetWClass,Notepad++
		{
		if Mouse_ClassNN=DirectUIHWND2
			SendMessage, 0x115, 2, 2, ScrollBar2,  ahk_id %Mouse_hWnd%
		else	
			SendMessage, 0x115, 2, 2, %Mouse_ClassNN%,  ahk_id %Mouse_hWnd%

	} else {
		ToolTip, unknown process`n%Mouse_ClassNN%`n%Mouse_WinTitle%
		SetTimer, ToolOff, -1200
		}
	Return    

ToolOff:
{
Tooltip,
Return
}

/* 
SB_LINEUP			:= 0		; Scrolls one line up.
SB_LINEDOWN			:= 1		; Scrolls one line down.
SB_PAGEUP			:= 2		; Scrolls one page up.
SB_PAGEDOWN			:= 3		; Scrolls one page down.
SB_THUMBPOSITION	:= 4		; scroll box Dragged
SB_THUMBTRACK		:= 5		; scroll box dragging 
SB_TOP				:= 6		; Scrolls to the upper left.
SB_BOTTOM			:= 7		; Scrolls to the lower right.
SB_ENDSCROLL		:= 8		; Ends scroll.
 */
