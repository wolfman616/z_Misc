#noEnv
setWorkingDir,% a_scriptdir
SetControlDelay, 20
SetKeyDelay, 20
#InstallKeybdHook
#singleInstance,     	Force
;#KeyHistory,         	1
;ListLines,           	On

#maxhotkeysPerInterval, 1440
#maxThreadsPerhotkey,	1
DetectHiddenText, 		On
DetectHiddenWindows, 	On
settitlematchmode,		2
setbatchlines,        	-1
SetWinDelay,         	-1
coordMode,		Mouse,	Screen
coordMode, 		Pixel,	Screen
coordMode, 	  Tooltip,	Screen
sendMode,            	Input
coordMode,%   "ToolTip",%  "Screen"
coordmode,%   "Mouse"  ,%  "Screen"
WM_LB_down  := 	0x00A1
WMResize_N_W 	:= 	13
WMResize_S_E 	:= 	17
WMResize_HTTOP            :=   12
;#define WM_NCLBUTTONDBLCLK              0x00A3
;WMSZ_TOP 3 Top edge
return
#z::
tt(a_now)
mousegetpos x, y, Active_hwnd, ctl_n
Active_hwnd:=winexist("A")
; PostMessage, 0x00A1, 17,% "ahk_id " Active_hwnd
		;PostMessage, %WM_LB_down%, %WMResize_N_W%,% "ahk_id " Active_hwnd

		PostMessage, 0x00A3, %WMResize_HTTOP%,% "ahk_id " Active_hwnd

return
/*
	#define HTERROR             (-2)
	#define HTTRANSPARENT       (-1)
	#define HTNOWHERE           0
	#define HTCLIENT            1
	#define HTCAPTION           2
	#define HTSYSMENU           3
	#define HTGROWBOX           4
	#define HTSIZE              HTGROWBOX
	#define HTMENU              5
	#define HTHSCROLL           6
	#define HTVSCROLL           7
	#define HTMINBUTTON         8
	#define HTMAXBUTTON         9
	#define HTLEFT              10
	#define HTRIGHT             11
	#define HTTOP               12
	#define HTTOPLEFT           13
	#define HTTOPRIGHT          14
	#define HTBOTTOM            15
	#define HTBOTTOMLEFT        16
	#define HTBOTTOMRIGHT       17
	#define HTBORDER            18
	#define HTREDUCE            HTMINBUTTON
	#define HTZOOM              HTMAXBUTTON
	#define HTSIZEFIRST         HTLEFT
	#define HTSIZELAST          HTBOTTOMRIGHT
	#define HTOBJECT            19
	#define HTCLOSE             20
	#define HTHELP              21
*/