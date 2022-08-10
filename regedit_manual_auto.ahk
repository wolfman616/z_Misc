#noEnv
#MenuMaskKey vkE8
#UseHook On
#InstallMouseHook
#InstallKeybdHook
SetControlDelay, -1
SetKeyDelay, -1
#singleInstance,     	Force
;#WinActivateForce
;SetStoreCapsLockMode, OFF
;#KeyHistory,         	10
;  ListLines,           	off
#maxhotkeysPerInterval, 1440
#maxThreadsPerhotkey,	1
DetectHiddenText, 		On
DetectHiddenWindows, 	On
settitlematchmode,		2 
settitlematchmode,		slow
#IfTimeout 120
setbatchlines,        	    -1
SetWinDelay,         	-1
coordMode,		Mouse,	Screen
coordMode, 		Pixel,	Screen
coordMode, 	  Tooltip,	Screen
sendMode,            	Input
s := winexist("ahk_Class RegEdit_RegEdit")
winactivate, ahk_id %s% 
sleep 100
ControlGet, edithandle, Hwnd ,, Edit1, ahk_id %s%
			ControlClick, Edit1, ahk_id %s% ; working 
            SendMessage,% (EM_SETSEL := 0x00B1), 0, -1,Edit1, ahk_id %s% 
			sleep 100
sendinput, Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers{enter}
