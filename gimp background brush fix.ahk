; Application WindowClass Background brush fix DLL injector for Gimp 2.10
; default white BackgroundBrush member of its own WNDCLASSEX structure replacement with min/restore workaround fix for initial load phase's splash window, which would otherwise display white , and the main app window which would briefly flicker (jarring).

#noEnv
#SingleInstance force
#noTrayicon
#Persistent
setWorkingDir %a_scriptDir%
setbatchlines, -1
global gimp := "C:\Program Files\GIMP 2\bin\gimp-2.10.exe"
if (A_Is64bitOS && A_PtrSize = 4) {
	run, %A_AhkPath%\..\AutoHotkeyU64.exe "%A_ScriptFullPath%", %A_ScriptDir%
	exitApp
}
if !(fileexist(gimp)){
	msgbox,,% "Error",% "Cant find the gimps executable at:`n" gimp
	FileSelectFile, gimp,,% "C:\Program Files\",% "gimp location...",% "Executrable / LNK (*.exe; *.lnk)"
}
gosub, Vars
run,% gimp,,min, pid
winWait,% win:= ("ahk_pid " . pid)
rThread := InjectAhkDll(pid, dllFile, "")
rThread.Exec(code)
settimer xit, -10000
return,

;[[[[[[[[[[[[]]]]]]]]]]]]]]]]][[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]][[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]

Vars:

dllFile   := FileExist("AutoHotkeyMini.dll") ? "C:\Script\AHK\- LiB\minhook\x64\AutoHotkeyMini.dll"
          : (A_PtrSize = 8)                  ? "C:\Script\AHK\- LiB\minhook\x64\AutoHotkeyMini.dll"
          : "C:\Script\AHK\- LiB\minhook\x64\AutoHotkeyMini.dll"	  
code =
(LTrim
	SetWorkingDir, %A_ScriptDir%
	#Include       C:\Script\AHK\- LiB\minhook\x64\MinHook.ahk
	global hook3 := New MinHook("user32.dll", "CreateWindowExW", "CreateWindowExW_Hook")
    MH_EnableHook()
	turd()
	return,

	CreateWindowExW_Hook(dwExStyle, lpClassName, lpWindowName, dwStyle, X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam) {
		FileAppend, CreateWindowExW_Hook, C:\OUT2\DBUG.txt
		n:="Injected"
		return DllCall(hook3.original
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
	turd() {
		try	ee :=  winexist("ahk_class gdkWindowToplevel")
		catch
			sleep 20
		dwNewLong   :=  5+1
		DllCall("SetClassLongPtrW", "ptr",ee, "int",-10, "int",dwNewLong)
		winActivate, ahk_class gdkWindowToplevel
		return
	}
)
return,
xit:
MH_Uninitialize()
exitapp