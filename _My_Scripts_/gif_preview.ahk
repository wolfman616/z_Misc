				;				MW2023				;		
; Displays AniGif or image with alpha.
; LeftClick & drag image to move.

; RightClick image to close.			

				;				MW2023				;		
			
		
	

; _      _  _)_
;(_ (_( ) ) (_ 

#NoEnv
#NoTrayicon
#SingleInstance off
#include <ImagePut>

setbatchlines,	-1
setControlDelay,-1
SetBatchLines,	-1
SetWinDelay,		-1
SetTitleMatchMode,2
SetTitleMatchMode,Slow
coordmode,	Mouse,	Screen
SetFormat,FloatFast,3.0
DetectHiddenWindows,On
DetectHiddenText,		On

global Opt_OutputQuotedPath:= True

, r_pid:= DllCall("GetCurrentProcessId")

, Argz1:= A_Args[1]? A_Args[1] : "D:\Documents\My Pictures\- GiF\_cm__nabu_chok_by_cylithren-da7g8r3.gif"

, r:= ImageShow(Argz1), rr:= uiband_set(r,2)

OnExit,Exit
OnMessage(0x201,"WM_LBD")
OnMessage(0x100,"OnWM_KEYDOWN")

winset,Alwaysontop,on,ahk_id %r%
;settimer,exit,-450000
return,

WM_LBD() { ; 0xA1-WM_NCLBUTTONDOWN
	PostMessage,0xA1,2 ; The same thing as dragging on the TitleBar to move Window.
}

OnWM_KEYDOWN(wparam="",lparam="") {
	switch,lparam {
		case,0X010001: (wparam=0X1B? timer("Exit",-150)) 
		case,0X2E0001: (getkeystate("Ctrl","P")? 
				, Clipboard:= (Opt_OutputQuotedPath? quote(Argz1) : Argz1))
	}
}

~RButton::
MouseGetPos,xx,yy,hwnd
Return,

~RButton Up::
MouseGetPos,xxx,yyy,hwndup
winget,pid,pid,ahk_id %hwndup%

if((hwnd=hwndup)&&(pid!=r_pid))
	Return,

if !((xxx >= xx -20) && (xxx <= xx +20) && (yyy >= yy -20) && (yyy <= yy +20))
	Return,

GuiEscape:
GuiClose:
Exit:
menu,tray,Noicon
Exitapp,