; play animation of sequentially named series of ico files (ie: 1.ico, 2.ico, 3.ico)
#noEnv 
#persistent
#SingleInstance,   off
;SETWINDELAY,      -1
;SETBATCHLINES,    -1

global frames, fps_desired, fps_sleep, Playing, filePath, OutFileName, OutDir, hnd, uid, current

if      0 != 1  
; wo/parameter: Not recommended, animates self (tray / gui) ; CPU INTENSIVE in comparison (+ 400%) this is due to it setting the icon fresh each new non repeated frame. More of a demonstration that practical.
	FileSelectFile, filePath ,,% "D:\Documents\My Pictures\",% "select",% "iCO Files (*.ICO)"
else if 0  = 1   
; w/ parameter: can pass tray.UID for 3rd pty apps tray.ico
{ 				
	Menu, Tray, NoIcon
	loop, parse, 1,% ";", ; parse the arguments (proc_handle / uid/ iconpath)
	{
		if (a_index = "1")
			filePath  := a_loopfield
		else if (a_index = "2")
			hnd  := a_loopfield
		else if (a_index = "3")
			uid  := a_loopfield
	}
	if !(fileexist( filePath ) ) {
		msgbox,,%   "Error",% "Cant find `n" filePath
		FileSelectFile, filePath ,,% "D:\Documents\My Pictures\",% "select",% "iCO Files (*.ICO)"
}	}
SplitPath, filePath,, OutDir, OutExtension, OutNameNoExt
;split icon path looking for the presence of multi-sequence of incrememnting filenames 
if !res:=regeXmatch(OutNameNoExt, "(\d+)(?!\w)") {
	msgbox,5,% "error with selected filename",% "must be sequentially named series of icons with numeric suffix`nlike myicon1.ico / myicon2.ico"	
	ifmsgbox retry
		reload,
	ifmsgbox cancel
		exitapp,
} else, ico_pfix:=regeXreplace(OutNameNoExt, "(\d+)(?!\w)", "")

if hnd
	(%ico_pfix%hnd)      := hnd
if uid
	(%ico_pfix%uid)      := uid
(%ico_pfix%frame_index)  := []
(%ico_pfix%Pgraphics)    := {}
(%ico_pfix%frames)

IniRead, fps_desired,% (OutDir . "\" . ico_pfix . ".ini"), animationinfo, fpsdesired, 8
IniRead, frameindex,%  (OutDir . "\" . ico_pfix . ".ini"), animationinfo, frames

if fps_desired 
	  fps_sleep := ( 1000 / ((%ico_pfix%fps_desired) := fps_desired) )
else  fps_sleep :=   100

if frameindex {
	loop, parse, frameindex, `,
	{
		(%ico_pfix%frame_index)[a_index] := a_loopfield
		(%ico_pfix%frames) :=   A_index  ;  count total
	}	
	
	loop,% (%ico_pfix%frames) {
		varprefix%a_index% := (OutDir . "\" . ico_pfix . a_index . ".ico")
		VarSetCapacity(varprefix_i%a_index%, fisize := A_PtrSize + 688)
		
		if DllCall("shell32\SHGetFileInfoW", "WStr", varprefix%a_index%, "UInt", 0, "Ptr", &varprefix_i%a_index%, "UInt", fisize, "UInt", 0x100)
		
			(%ico_pfix%Pgraphics)[a_index]:= ({"HpGfx" : (NumGet(varprefix_i%a_index%, 0, "Ptr")) : "name" : varprefix%a_index%})
	}
	
	
} else if (framecount()) {
		  menu, tray, check,% "animation (toggle)" 
		  settimer, Icon_animation_loop_init, -200
} ;else,  msgbox Err

;-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'-~-'`'
Icon_animation_loop_init:
if  (!frames && !(%ico_pfix%frames) )
	 return,
else
if   frames
	 TheBusiness(%ico_pfix%hnd,%ico_pfix%uid,(varprefix_h%current%))
else TheBusiness(%ico_pfix%hnd,%ico_pfix%uid,(%ico_pfix%frames)) 

Playing := True
return,


Icon_animation_toggle:
	Playing := !Playing
if  Playing {
        settimer, Icon_animation_loop_init, -200
	    menu, tray, check,%   "animation (toggle)"
} else,	menu, tray, uncheck,% "animation (toggle)"
return,

framecount() {
	loop {
		if ( exist := fileexist((OutDir . "\" . ico_pfix . a_index . ".ico")) ) {
			varprefix%a_index% := (OutDir . "\" . ico_pfix . a_index . ".ico")
			VarSetCapacity(varprefix_i%a_index%, fisize := A_PtrSize + 688)
			if DllCall("shell32\SHGetFileInfoW", "WStr", varprefix%a_index%, "UInt", 0, "Ptr", &varprefix_i%a_index%, "UInt", fisize, "UInt", 0x100)
			varprefix_h%a_index% := NumGet(varprefix_i%a_index%, 0, "Ptr") 
		} else,	return, (frames := a_index -1)
} 	}

TheBusiness(hWnd:="", u_i_D:="", framen:="") {
	global
	(framen%ico_pfix%):= framen 
	(hwnd%ico_pfix%)  := Format("{:#x}",hWnd)
	(u_i_D%ico_pfix%) := u_i_D
	
	%ico_pfix%ind := ( Current := 1 )
		
	settimer, ti5m0r,% fps_sleep	
	return,
	
	ti5m0r: ;{
	if  (%ico_pfix%ind  < (%ico_pfix%frames)) { ; (%ico_pfix%frame_index)[current])
		 %ico_pfix%ind +=  1
		if (current != (%ico_pfix%frame_index)[%ico_pfix%ind]) {
			current := (%ico_pfix%frame_index)[%ico_pfix%ind]
		}
	} else, current := ( %ico_pfix%ind := 1 )

	if   (u_i_D%ico_pfix%)
		  TrayIcon_Set((hwnd%ico_pfix%), (u_i_D%ico_pfix%), (%ico_pfix%Pgraphics)[current].HpGfx, 0, 0)
	else, menu, tray, icon,% (%ico_pfix%Pgraphics)[current].Name
	if   !playing
		  settimer, ti5m0r, off
	return, ;}
}

xit:
exitapp,