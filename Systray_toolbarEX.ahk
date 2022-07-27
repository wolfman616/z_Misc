; testing systray-tb setups
#persistent 
#NoEnv 
;#notrayicon
;ListLines, Off ; & dont 4get to k33st4h ur #keyhistory :); DetectHiddenText,    On ; SetTitleMatchMode,   2	SetTitleMatchMode,   Slow
#Singleinstance,    Force
DetectHiddenWindows,  On 
SetBatchLines,        -1
DetectHiddenText,     On
SetTitleMatchMode,     2
SetTitleMatchMode,  Slow
#include <TrayIcon>
global result
;gui, t:NEW, +hwnd_hwnd_
;gui, T:Show, x100 y100 h100 w100
winget, _hwnd_,id,ahk_exe notepad.exe

P_P:=MAKELONG(4,4,true)

res:=Tray_Add( _hwnd_, "Tray_onShellIcon" , "C:\Icon\48\Star (4).ico", "sdsdds") 

sleep 1000

Tray_Modify( _hwnd_, res, "C:\Icon\32\letter32.ico", Tooltip:="~`a " ) 

gosub g37
gosub settraybs
gosub settraypads
msgbox % result
return,

g37:
gettraybs:
idxTB := TrayIcon_GetTrayBar("Shell_TrayWnd")
SendMessage,0x043A,0,0,ToolbarWindow32%idxTB%,ahk_class Shell_TrayWnd ; TB_GETBUTTONSIZE=0x043A
result .= "buttonsize X: " loword(ErrorLevel) "`nButtonsize Y: " hiword(ErrorLevel) 
; return
gettraypads:
    idxTB:=TrayIcon_GetTrayBar("Shell_TrayWnd")
    SendMessage,0x0456,0,0,ToolbarWindow32%idxTB%,ahk_class Shell_TrayWnd ; TB_GETPADDING=0x0456
result .= "`nMain Padding X: " loword(ErrorLevel) "`nMain Padding Y: " hiword(ErrorLevel) 
; return   
getoverflowpads:
    idxTB:=TrayIcon_GetTrayBar("NotifyIconOverflowWindow")
    SendMessage,0x0456,0,0,ToolbarWindow32%idxTB%,ahk_class NotifyIconOverflowWindow ; TB_GETHOTITEM = 0x0447
result .= "`nOverflow Padding X: " loword(ErrorLevel) "`nOverflow Padding Y: " hiword(ErrorLevel) 
return

settraybs:
P_P:=MAKELONG(36,36)
idxTB := TrayIcon_GetTrayBar("Shell_TrayWnd")
SendMessage,0x041F,0,%P_P%,ToolbarWindow32%idxTB%,% "ahk_class Shell_TrayWnd" ; TB_SETBUTTONSIZE=0x041F
msgbox %	result:= loword(ErrorLevel) "`n"  result2:= hiword(ErrorLevel)  
return 

settraypads:
P_P:=MAKELONG(4,4)
idxTB := TrayIcon_GetTrayBar("Shell_TrayWnd")
SendMessage, 0x0457, 0, %P_P%, ToolbarWindow32%idxTB%,% "ahk_class Shell_TrayWnd" ; TB_SETPADDING=0x0457
msgbox %	result:= loword(ErrorLevel) "`n"  result2:= hiword(ErrorLevel) 
return 

setoverflowpads:
P_P:=MAKELONG(0,0)
    idxTB := TrayIcon_GetTrayBar("NotifyIconOverflowWindow")
    SendMessage, 0x0457, 0, P_P, ToolbarWindow32%idxTB%, ahk_class NotifyIconOverflowWindow ; TB_GETHOTITEM = 0x0447
msgbox %	result:= loword(ErrorLevel) "`n"  result2:= hiword(ErrorLevel) 
return 


^space::
TrayIcon_Move(5, 3, "NotifyIconOverflowWindow")
return
winget _hwnd_,id,ahk_exe notepad.exe
Tray_loadIcon("C:\Icon\48\Star (4).ico", 32)
return

Tray_Add( hGui, Handler, Icon, Tooltip="") {
	static NIF_ICON=2, NIF_MESSAGE=1, NIF_TIP=4, MM_SHELLICON := 0x500
	static uid=100, hFlags

	if !hFlags
		OnMessage( MM_SHELLICON, "Tray_onShellIcon" ), hFlags := NIF_ICON | NIF_TIP | NIF_MESSAGE 

	if !IsFunc(Handler)
		return A_ThisFunc "> Invalid handler: " Handler

	hIcon := Icon/Icon ? Icon : Tray_loadIcon(Icon, 32)

    VarSetCapacity(NID, szNID := ((A_IsUnicode ? 2 : 1) * 384 + A_PtrSize*5 + 40),0)
    numput( szNID, NID, 0)
    numput( hGui,  NID, (A_PtrSize == 4) ? 4   : 8  )
	numput( ++uid,  NID, (A_PtrSize == 4) ? 8   : 16 )
	numput( hFlags, NID, (A_PtrSize == 4) ? 12  : 20 )
	numput( MM_SHELLICON, NID, (A_PtrSize == 4) ? 16  : 28 )
	numput( hIcon, NID, (A_PtrSize == 4) ? 20  : 32 )
	DllCall("lstrcpyn", "uint", &NID+24, "str", Tooltip, "int", 128) ; not working at this point

	if !DllCall("shell32.dll\Shell_NotifyIconW", "uint", 0, "uint", &NID)
		return, 0

	Tray( uid . "handler", Handler)
	Icon/Icon ? Tray( uid "hIcon", hIcon) :		;save icon handle allocated by Tray module so icon can be destroyed.
	return, hIcon
}

; Tray_loadIcon(pPath, pSize=32){
	; j := InStr(pPath, ":", 0, 0), idx := 0
	; if j > 2
		; idx := Substr( pPath, j+1), pPath := SubStr( pPath, 1, j-1)

	; DllCall("PrivateExtractIcons"
            ; ,"str",pPath,"int",idx,"int",pSize,"int", pSize
            ; ,"uint*",hIcon,"uint*",0,"uint",1,"uint",0,"int")

	; return hIcon
; }
 
Tray_onShellIcon(Wparam, Lparam) {
	static EVENT_512="P", EVENT_513="L", EVENT_514="Lu", EVENT_515="Ld", EVENT_516="R", EVENT_517="Ru", EVENT_518="Rd", EVENT_519="M", EVENT_520="Mu", EVENT_521="Md"
TT(Wparam " " Lparam "`n" EVENT_%event%)
	;wparam = uid, ; msg = lparam loword
	handler := Tray(Wparam "handler")  ,event := (Lparam & 0xFFFF)
	return %handler%(Wparam, EVENT_%event%)
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
