				;				MW2023				;		
;Display AniGif with alpha.				
;Left Click & drag image to move.	
;Right Click image to close.			
				;				MW2023				;		

#NoEnv
#NoTrayicon
#include <ImagePut>
#SingleInstance off

r_pid:= DllCall("GetCurrentProcessId")

if(!a_args[1])
	exitapp,
ImageShow(a_args[1])
, OnMessage(0x201,"WM_LBD")
, OnMessage(0x100,"OnWM_KEYDOWN")
return,

OnWM_KEYDOWN(a,b) {
	if(a=27&&b=65537)
		exitapp,
}

~^c:: clipboard:= a_args[1]

~esc::
if(winactive("ahk_pid " r_pid))
	exitapp,
else,return,

WM_LBD() { ; 0xA1-WM_NCLBUTTONDOWN
	PostMessage,0xA1,2 ; The same thing as dragging on the TitleBar to move Window.
}