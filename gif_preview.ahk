#NoEnv
#include <ImagePut>
#SingleInstance force
; Display image without borders. Click & drag image to move. Right click image to close.
if a_args[1]
	ImageShow(a_args[1])
	, OnMessage(0x201,"WM_LBD")
return,

esc::exitapp

WM_LBD() {
	PostMessage,0xA1,2 ;WM_NCLBUTTONDOWN
}
