; Application WindowClass Background brush fix DLL injector for Gimp 2.10
; default white BackgroundBrush member of its own WNDCLASSEX structure replacement with min/restore workaround fix for initial load phase's splash window, which would otherwise display white , and the main app window which would briefly flicker (jarring).
global balls
#noEnv
#maxhotkeysPerInterval, 1440
#maxThreadsPerhotkey,	1
DetectHiddenText, 		On
DetectHiddenWindows, 	On
settitlematchmode,		2
settitlematchmode,		slow
setbatchlines,        	    -1
SetWinDelay,         	-1
coordMode,		Mouse,	Screen
coordMode, 		Pixel,	Screen
coordMode, 	  Tooltip,	Screen
;#noTrayicon
#Persistent
#SingleInstance force
setbatchlines,  -1
setWorkingDir,  %a_scriptDir%
	global i_handle1,i_handle2,i_handle3

if 0=1
	global Arguments := True
; if !(A_Is64bitOS && A_PtrSize = 4) {  	; if 32 bit AHK run 64bit Unicode AHK
; msgbox no	exitApp
; }

if !(fileexist((wmp :=     "C:\Program Files\zWindows Media Player\wmplayer.exe"))){ 		; check gimp path
	msgbox,,% "Error",%     "Cant find the wmps executable at:`n" wmp
	FileSelectFile, wmp,,% "C:\Program Files\",% "wmp location...",% "Executable / LNK (*.exe; *.lnk)"
}

gosub, Vars
if hun:=winexist("ahk_exe wmplayer.exe") 
{
	WinGet,      LL, List, ahk_Class WMP Skin Host 
	loop,      %LL%
	msgbox % (i_handle%a_index%) := (LL%a_index%)	
	winget, pid, pid, ahk_id %hun%
	goto, injex
}
if Arguments {
	arg = "%1%"
	run,% wmp " " arg ,,min, pid
} else,{
	run,% wmp,,min, pid
}
if !winexist("ahk_pid " . pid)
	winWait,% win:= ("ahk_pid " . pid)

injex:
rThread := InjectAhkDll(pid, dllFile, "")
rThread.Exec(code)
return
settimer xit, -10000
return,

;[[[[[[[[[[[[]]]]]]]]]]]]]]]]][[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]][[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]

Vars:

global dllFile   :="C:\Script\AHK\- LiB\minhook\x64\AutoHotkeyMini.dll"	  
code =
(LTrim
	SetWorkingDir, %A_ScriptDir%
	#Include       C:\Script\AHK\- LiB\minhook\x64\MinHook.ahk
	global hook3 := New MinHook("user32.dll", "CreateWindowExW", "CreateWindowExW_Hook")
	global trigger 
	global LL
	global i_handle1,i_handle2,i_handle3
	
	init()
	return,

	CreateWindowExW_Hook(dwExStyle, lpClassName, lpWindowName, dwStyle, X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam) {
		try if n:=init() 
		n:="Injected"
		return, DllCall(hook3.original
		, "uint", dwExStyle
		, "ptr", lpClassName
		, "ptr", &N
		, "int", dwStyle
		, "int", X
		, "int", Y
		, "int", nWidth
		, "int", nHeight
		, "ptr", hWndParent
		, "ptr", hMenu
		, "ptr", hInstance
		, "ptr", lpParam
		, "ptr")    
	}

	init() {
		dwNewLong   :=  5+1
global balls:=true
		;DllCall("SetClassLongPtrW","Ptr",i_handle1,"Int",-10,"int",dwNewLong)
if i_handle1 {
if DllCall("SetClassLongPtrW", "ptr", i_handle1, "int",-10, "int",dwNewLong)
			winActivate, ahk_class WMP Skin Host
if DllCall("SetClassLongPtrW", "ptr", i_handle2, "int",-10, "int",dwNewLong)
			winActivate, ahk_class WMP Skin Host
if DllCall("SetClassLongPtrW", "ptr", i_handle3, "int",-10, "int",dwNewLong)
			winActivate, ahk_class WMP Skin Host
if DllCall("SetClassLongPtrW", "ptr", i_handle4, "int",-10, "int",dwNewLong)
			winActivate, ahk_class WMP Skin Host
} else {
aa:=1000
while aa
loop 1 {
	if !(ee := winexist("ahk_Class WMP Skin Host"))
		sleep 10
	else, 
	{
	DllCall("SetClassLongPtrW", "ptr", ee, "int",-10, "int",dwNewLong)
sleep 10
}
aa-=1
}
		if !trigger {
			winActivate, ahk_id %ee%
			trigger := true
		}
}
		}
	
		; try	ee :=  winexist("ahk_class gdkWindowToplevel")
		; catch
			; sleep 20
		; DllCall("SetClassLongPtrW", "ptr", ee, "int",-10, "int",dwNewLong)
	; }
			; return
)
return,

xit:
DllCall("MinHook\MH_Uninitialize")
exitapp