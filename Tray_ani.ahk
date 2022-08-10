#noEnv
#persistent
#SingleInstance,%      "Force"
DetectHiddenWindows,%  "On"
;DetectHiddenText,%    "On"
SetTitleMatchMode,%    "2"		
SetTitleMatchMode,%   "Slow" 
setWorkingDir,% 		a_scriptDir

#INCLUDE C:\Script\AHK\- LiB\Trayicon.ahk ;#INCLUDE C:\Script\AHK\- LiB\TrayIcon_GetInfo.ahk

global frames, fps_desired, fps_sleep, Playing, trarray, HN, NID, max_index, fileinfo, fileinfo3, steam_iconhandle

fps_desired := 12, fps_sleep := ( 1000 / fps_desired ), trarray := []

;hnd:=winexist("wmp_Matt.ahk")  

gosub steamicon_make_hicon

;hnd:=winexist("AHK_EXE MSIAfterburner.exe")  

if (framecount()) {
	Playing := True ;	menu, tray, check,% "animation (toggle)"
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

 trarray := ( ad := TrayIcon_GetInfo() ) ; get all tray items !trarray := TrayIcon_GetInfo("MSIAfterburner.exe")

 ;msgbox % "uid " trarray[1].uid "`nhwnd " trarray[1].hwnd "`nidcmd "  trarray[1].idcmd "`npid " trarray[1].pid "`nidx " trarray[1].idx "`nhicon " trarray[1].hicon "`nlocation " trarray[1].tray "`npname " trarray[1].process "`nclss "  trarray[1].class  ; 
 
gosub, tray_count

loop %max_index% { 
	; tt:= tt . " " . ( P_N := trarray[a_index].process)
	P_N := trarray[a_index].process
	switch P_N {
		case "Wacom_TabletUser.exe":
			loc:= trarray[a_index].tray
			if !(loc = "Shell_TrayWnd") { 
				tooltip % "Located in Tray: "   target_orig:=a_index " (Overflow)" ;	TrayIcon_Move(2,4)
				;msgbox % (ringp := trarray[a_index].idx  ) "`n"  (ring := trarray[a_index].uid  ) 
			}
			hnd := trarray[a_index].hwnd
		case "steam.exe":
			hh := (trarray[a_index].hwnd), uu := (trarray[a_index].uid)
			TrayIcon_Set(hh,uu,steam_iconhandle,0, 0)
}	}  
; tooltip,% tt
; Gui,    +LastFound 
; hGui  := WinExist() ; dummy hwnd
; Tray_Add( hGui, "OnDummyTrayIcon", "shell32.dll:3", "My Tray Icon")
return,


 ; Gui,  +LastFound
 ; hGui := WinExist() 
 ;
 ; Tray_Add( hGui, "OnDummyTrayIcon", "shell32.dll:1", "My Tray Icon")

;	OnDummyTrayIcon(Hwnd, Event){
;	  	if (Event != "R")		;return if event is not right click
;			return
;;		MsgBox Right Button clicked
;	return 
; PostMessage, nMsg, 2, 0x204, , ahk_id %HN%
;hicon:=		 LoadPicture("1.ico",,1)

global fileinfo2
VarSetCapacity(fileinfo2, fisize := A_PtrSize + 688)
    if ass:=DllCall("shell32\SHGetFileInfoA", "Str", (a_scriptDir . "\2.ico")
        , "UInt", 0, "Ptr", &fileinfo2, "UInt", fisize, "UInt", 0x100)
  	; hicon2 := NumGet(fileinfo2, 0, "Ptr")
	; hicon  := LoadPicture("1.ico",,1)
 VarSetCapacity(NID, szNID := ((A_IsUnicode ? 2 : 1) * 384 + A_PtrSize*5 + 40),0)
    NumPut( szNID, NID, 0                           )
    NumPut( hn,  NID, (A_PtrSize == 4) ? 4   : 8  )
    NumPut( 1028,   NID, (A_PtrSize == 4) ? 8   : 16 )
    NumPut( 2,     NID, (A_PtrSize == 4) ? 12  : 20 )
    NumPut( "shell32.dll:3", NID, (A_PtrSize == 4) ? 20  : 32 )
    ; NIM_MODIFY := 0x1
    DllCall("Shell32.dll\Shell_NotifyIconA", "UInt",0x1, "Ptr",&NID)
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
	TrayIcon_Set(hnd, 1,varprefix_h%current%,0, 0)
	;menu,   tray, icon,% ("HICON:*" . varprefix_h%current%)
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

tray_count:
loop 
	if (ldoc:= trarray[a_index].hicon)
		max_index := a_index 
	else, break
return,

steamicon_make_hicon:
VarSetCapacity(fileinfo, fisize := A_PtrSize + 688)
if DllCall("shell32\SHGetFileInfoA", "Str", "C:\Icon\24\stemen.ico"
, "UInt", 0, "Ptr", &fileinfo, "UInt", fisize, "UInt", 0x100)
	steam_iconhandle := NumGet(fileinfo, 0, "Ptr") 
return,

xit:
exitapp
^Left::
hot:= TrayIcon_GetHotItem()
TrayIcon_Move(hot, hot-1)
tooltip % TrayIcon_GetInfo(hot-1)
return
^right::
hot:= TrayIcon_GetHotItem()
TrayIcon_Move(hot, hot+1)
tooltip % TrayIcon_GetInfo(hot+1)
return
^up::
tooltip, % "sfdf " . trarrays:=TrayIcon_Button("AutoHotkey.exe", sButton := "R", bDouble := true, index := 1)
as:=NumGet(fileinfo, 0, "Ptr")
;        settimer, Icon_animation_loop_init, -200msgbox % TrayIcon_Set(hnd, 1028,hic, 0, 0), 0,0)
        settimer, Icon_animation_loop_init, -200

return
#f::
menu, tray, icon,% "HICON:*shell32.dll:5"
return,
#g::
menu, tray, icon,% "HICON:*shell32.dll:6"
return,
#h::
return,

Tooltip:="CUNT"
NIF_ICON=2, NIF_MESSAGE=1, NIF_TIP=4, MM_SHELLICON := 0x500
uid=100
 ;Tray_Modify(hn,"", x,"") 
	VarSetCapacity( NID, 88, 0) 
	 ,NumPut(88,	NID)
	 ,NumPut(HN,	NID, 4)
	 ,NumPut(++uid,	NID, 8)
	 ,NumPut(2, NID, 12)
	 ,NumPut((hFlags := NIF_ICON | NIF_TIP | NIF_MESSAGE), NID, 16)
	 ,NumPut(X, NID, 20)
	 ,DllCall("lstrcpyn", "uint", &NID+24, "str", Tooltip, "int", 64)
	 	DllCall("shell32.dll\Shell_NotifyIconW", "uint", 0, "uint", &NID)

return,

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return
