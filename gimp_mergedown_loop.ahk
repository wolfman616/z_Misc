#NoEnv
#persistent
SendMode Input
Global Delay, Global Iter
Return

^0::
if(winactive("AHK_Class gdkWindowToplevel")) {
	Gui, Add, Text,, &Please enter iteration count:
	Gui, Add, Edit, vIter
	Gui, Add, Text,, &Delay(ms):
	Gui, Add, Edit, vDelay
	Gui, Show
} Return 

~Enter::
if(winactive("AHK_Class AutoHotkeyGUI")) {
	Gui, Submit , NoHide
	Gui, destroy
	try
		Gimp_Layer_Key_Macro()
	catch e
		MsgBox % "Error in " e.What ", which was called at line " e.Line 
} Return

Gimp_Layer_Key_Macro() {
	Init_Macro:
	if(winactive("AHK_Class AutoHotkeyGUI")){
		loop %iter% {
			Send ^+d 			; duplicate layer
			sleep % delay
			send { down } 	; downarrow
			sleep % delay
			Send ^+m 		; mergedown
			sleep % delay
			Send ^+r 			; raise in layerorder 
			sleep % delay
			send { down }
			sleep % delay
		} 
	} else {
		WinActivate AHK_Class gdkWindowToplevel
		goto Init_Macro
	}
	IF ERRORLEVEL throw Exception("Fail", -1)
		Return
}

