#noEnv ; #warn ;Test code for taskbar subitems icons and buttons in Mozilla FFox ; only inject once
#singleInstance force
#include C:\Script\AHK\- _ _ LiB\uninject.ahk
sendMode Input
global dllfile
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard ;	#Include %A_ScriptDir%\il.ahk
SetWorkingDir %A_ScriptDir%

code :="
(LTrim Comments
#Include C:\Script\AHK\- _ _ LiB\taskbarinterface.ahk
#Include C:\Script\AHK\- _ _ LiB\ico2hicon.ahk
rPiD:= DllCall(""GetCurrentProcessId"")
tbi:= new taskbarInterface(p:= winexist(""ahk_pid "" rPiD))
dim:= taskbarInterface.queryButtonIconSize() ; Get the required dimensions for  &  Load an icon
hIcon2:= ico2hicon(""C:\Icon\256\1384060.ico""),hIcon3:= ico2hicon(""C:\Icon\256\1384060.ico""),hIcon4:= ico2hicon(""C:\Icon\20\play (2).ico"")
bhIcon1:= ico2hicon(""C:\Icon\256\fav.ico""),bhIcon2:= ico2hicon(""C:\Icon\28\rew.ico""),bhIcon3:= ico2hicon(""C:\Icon\28\pause.ico""),bhIcon4:= ico2hicon(""C:\Icon\28\ff.ico""),bhIcon5:= ico2hicon(""C:\Icon\256\cog_settings.2_256.ico"")
; SendMessage,0x80,0,hSmIcon,,ahk_id %p%  ; WM_SETICON, ICON_SMALL
; SendMessage,0x80,1,hIcon2,,ahk_id %p%  ; WM_SETICON, ICON_LARGE
loop 5 {
	tbi.addTab()
	tbi.hideButton(a_index)
	tbi.setButtonIcon(a_index,bhIcon%a_index%)
	tbi.showButton(a_index)
	tbi.setButtonToolTip(a_index,""test_button_"" a_index)
	tbi.dismissPreviewOnButtonClick(a_index)
}
tbi.refreshButtons()
tbi.setProgress(39)
tbi.setTaskbarIcon(hIcon2,hIcon3) ;tbi.SetProgressType(""INDETERMINATE"") ;tbi.flashTaskbarIcon(""green"",99999,900,700)
tbi.addTab()
tbi.allowHooking
tbi.setThumbnailToolTip(""Youtube_Matt"")
tbi.setOverlayIcon(hIcon4,""nigger"")
exit,
)"

if(A_Is64bitOS && A_PtrSize = 4) {
	Run, %A_AhkPath%\..\AutoHotkeyU64.exe "%A_ScriptFullPath%", %A_ScriptDir%
	ExitApp
}

global hIcon1,hIcon1,hIcon3
hIcon1:=LoadPicture("C:\Icon\256\wavve2e.ico","w48 h48")	;Load an icon	; Get the required dimensions
hIcon2:=LoadPicture("C:\Icon\256\wavve2e.ico","w64 h64")
hIcon3:=LoadPicture("C:\Icon\256\wavve2e.ico","w32 h32")
winget,pid_J,pid,ahk_exe firefox.exe
dllFile:= FileExist("AutoHotkeyMini.dll")	? A_ScriptDir "\AutoHotkeyMini.dll"
	: (A_PtrSize=8)						? A_ScriptDir "\ahkDll\x64\AutoHotkeyMini.dll"
	: A_ScriptDir "\ahkDll\x32\AutoHotkeyMini.dll"
rThread := InjectAhkDll(pid_J, dllFile, "")
rThread.Exec(code)
sleep 1000 
DllUnInject(pid_J,"AutoHotkeyMini.dll")
return,

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return
