SetWorkingDir %A_ScriptDir% 
#NoEnv
#SingleInstance force
#Persistent
SendMode Input  
Menu, Tray, Icon, C:\Script\AHK\Working\search_32.ico
;SetBatchLines -1
;#NoTrayIcon
Gui +AlwaysOnTop +Owner +Resize +ToolWindow
CoordMode Mouse, Screen
IniRead, LastScaleFactor, zoom.ini, LastScaleFactor, LastScaleFactor , 4
Global Antialiasing := 0, Global Rx := 256, Global Ry := 256, Global Zoom := 8, Paused := 1, FPS := 100
Global Zoom := LastScaleFactor
Global RefreshInterval:=(1000/FPS)
Global WinDPI := A_ScreenDPI
Global Rux := 256/((WinDPI/96))		; half vertical/horizontal side of ninjMag window
Global Ruy := 256/((WinDPI/96))
Global Zx := round(Rx/Zoom) 							
Global Zy := round(Ry/Zoom)

return
#M::
   if !Paused { 
		^+Up::	
			^+Down::	 
				^+WheelUp::                    ; Ctrl+Shift+ WHEEL or ARROW to Zoom
					^+WheelDown:: 
	If (Zoom < 16 and ( A_ThisHotKey = "^+WheelUp" or A_ThisHotKey = "^+Up" )) {
		Zoom *= 1.189207115         ; cube root of 2))
		rx:=rx*1.15
		ry:=ry*1.15
	}  Else	If (Zoom >  4.1 and ( A_ThisHotKey = "^+WheelDown" or A_ThisHotKey = "^+Down" )) {
			Zoom /= 1.189207115
			rx:=rx/1.15 
			ry:=ry/1.15
			}	
		SetTimer, Repaint, Off
		;SetTimer, BarebackOnTOP, Off

		Gui, 2:Hide 
		Gui, Hide 
		Paused := 1
		return
	} Else {
	;SetTimer, BarebackOnTOP, 3000
	Gosub Init_Gui
	Paused :=
	^+Up::^+Up
		return
	^+Down::^+Down
		return
	^+WheelUp::^+WheelUp             ; Ctrl+Shift+ WHEEL or ARROW to Zoom
		return
	^+WheelDown::^+WheelDown
		return
}


In(x,a,b)  { 
	IfLess x,%a%, Return a
	IfLess b,%x%, Return b
	Return x
	}

Repaint:
	MouseGetPos x, y
	xz := In(x-Zx-256,0,A_ScreenWidth-2*Zx) ; keep  Frame on screen
	yz := In(y-Zy-256,0,A_ScreenHeight-2*Zy) ; 
	WinMove ninjMag,,(x-271)+(2.248*zoom), (y-271)+ (2.248*zoom)
	DllCall("gdi32.dll\SetStretchBltMode",Uint, HDC_Frame, int, 5)
	DllCall("gdi32.dll\StretchBlt",UInt,HDC_Frame, Int,0, Int,0, Int,256, Int,256, UInt,HDD_Frame, UInt,x-zx, UInt,y-zy, Int,2*Zx, Int,2*Zy, UInt, SRCCOPY)        
	; NOTSRCCOPY
	if nignog 
		SRCCOPY:="0x00330008"
	Else 
		SRCCOPY:="0x00CC0020"
	Return

BarebackOnTOP:
WinActivate ahk_id %NinjMagID%
Return
#b::
nignog := !nignog
Return


Init_Gui:
MouseGetPos x, y
	jizzy:=(x-271)+(2.248*zoom)
	rascal:=(y-271)+ (2.248*zoom)
	Gui Show, w %Rux% h %Ruy% x %jizzy% y %rascal% NoActivate , ninjMag
	WinGet ninjMagID, id, ninjMag
	SetWinDelay, -1 
	WinSet, Region, 0-0 W256 H256 R256-256, ninjMag
	WinSet, Style, 0x10000000, ninjMag 
	WinSet, ExStyle, 0x00000028, ninjMag
	WinSet Transparent, 0, ninjMag 
	WinSet Transparent, 255, ninjMag 
	HDD_Frame := DllCall("GetDC", UInt, PrintSourceID)
	HDC_Frame := DllCall("GetDC", UInt, ninjMagID)
	SetTimer, Repaint, %RefreshInterval%
	Return


GuiClose:
	{
	DllCall("gdi32.dll\DeleteDC", UInt,HDC_Frame )
	DllCall("gdi32.dll\DeleteDC", UInt,HDD_Frame )
	;DllCall("gdi32.dll\DeleteObject", UInt,hbm_buffer)
	;DllCall("gdi32.dll\DeleteDC", UInt,HDC_buffer)
	IniWrite, %Zoom% , zoom.ini , LastScaleFactor, LastScaleFactor
	exitapp
	}

OnExit GuiClose 
