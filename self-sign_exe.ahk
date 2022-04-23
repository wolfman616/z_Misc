#noEnv
#SingleInstance force
setWorkingDir %a_scriptDir%

cert_commandline =
(
	wsl -e osslsigncode sign -pkcs12 "/mnt/c/temp/Your_Cert_Name.pfx" -pass "%User_p%" -n "%app_%" -i "https://www.yourwebsitename.com" -t "http://timestamp.comodoca.com/authenticode" -in "/mnt/c/temp/MyUnSignedApp.exe" -out "/mnt/c/temp/MySignedApp.exe"
)

if A_IsUnicode { ; ANSI SCRIPT
	msgbox,% 0x10010,% "Unicode error",% "Unicode ahk detected.`bPlease load with ANSI AHK",3
	run, %A_AhkPath%\..\AutoHotkeyA32_UIA - admin.exe "%A_ScriptFullPath%", %A_ScriptDir%
	ExitApp
}

fileSelectfile, app_,,% "C:\Program Files\",% "Executable to self-sign...",% "Executable / LNK (*.exe; *.lnk)"
if !app_ 
	goto xit
	
inputBox, User_p ,% "    Enter Password",% "P:", HIDE,% w:=256,% h:=100,((a_screenwidth * 0.5)-(w * 0.5)),((a_screenheight * 0.5)-(h * 0.5))
if errorlevel
	goto xit

msgbox,% result := RunWaitOne((commandline_str := (comspec . " /C " . cert_commandline)))
exitapp,

RunWaitOne(command) {
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec(ComSpec " /C " command)
    return exec.StdOut.ReadAll()
}

xit:
msgbox,% 0x10010,%     Error,Exiting, 3
exitapp,