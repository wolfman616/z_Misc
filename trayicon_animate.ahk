#noEnv ; play animation of sequentially named series of ico files 
#persistent
#SingleInstance,% "force"
sendMode,%        "Input"
SETWINDELAY,      -1
SETBATCHLINES,    -1
setWorkingDir,%    a_scriptDir
menu, tray, nostandard
menu, tray, add,% "animation (toggle)", toggle_anim
menu, tray, add,% "Exit", xit

global frames, fps_desired, fps_sleep, Playing
fps_desired := 12, fps_sleep := ( 1000 / fps_desired )
if (framecount()) {
	Playing := True
	menu, tray, check,% "animation (toggle)"

	settimer, Icon_animation_loop_init, -200
} else {					; nO sequence of icons found (1.ico, 2.ico, 3.ico)
	if 		   0 != 1 	    ; Not run with parameter
		filePath := "D:\Documents\My Pictures\6pkB.ico" ; specify the file path to first icon
	else if     0 = 1	    ; run with parameter from menus
		filePath  = %1%
	if !(fileexist( filePath ) ) {
		msgbox,,%   "Error",% "Cant find `n" filePath
		FileSelectFile, filePath ,,% "D:\Documents\My Pictures\",% "select",% "iCO Files (*.ICO)"
}	}
return,

framecount() {
	global
	loop {
		if !( exist := fileexist((a_scriptDir . "\" . a_index . ".ico")) )
			return, ( frames := a_index -1 )
		else {
			varprefix%a_index% := (a_scriptDir . "\" . a_index . ".ico")
			VarSetCapacity(varprefix_i%a_index%, fisize := A_PtrSize + 688)
			if DllCall("shell32\SHGetFileInfoW", "WStr", varprefix%a_index%, "UInt", 0, "Ptr", &varprefix_i%a_index%, "UInt", fisize, "UInt", 0x100)
			varprefix_h%a_index% := NumGet(varprefix_i%a_index%, 0, "Ptr") 
}	}	}

Icon_animation_loop_init:
if !frames
	return,
loop {
	if     (current < frames)
		    current += 1
	else,   current := 1
	menu,   tray, icon,% ("HICON:*" . varprefix_h%current%)
	sleep,% fps_sleep
	if !playing
		break
}
return,

toggle_anim:
	Playing := !Playing
if Playing {
        settimer, Icon_animation_loop_init, -200
	    menu, tray, check,% "animation (toggle)"
} else,	menu, tray, uncheck,% "animation (toggle)"
return,

xit:
exitapp