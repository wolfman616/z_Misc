; NOTEPAD++ ONLY	"replace all" instances of Hilighted-word with Current-selection	;
			   #noEnv			;(MW:23);
		   #IfTimeout,	200 <---;DANGER*--; (Performance impact if set too low*)
		  #NotrayIcon			;(MW:22);
	  #SingleInstance,	Force
#maxhotkeysPerInterval,	1440
 #maxThreadsPerhotkey,	5
	#InstallMouseHook			; (f:=findahkclones(WtL,rPiD,False)) ;
	#InstallKeybdHook
		 #MenuMaskKey,	vkE8
		  #KeyHistory,	30
			 #UseHook,	On
			listlines,	on
			 SendMode,	Input
SetControlDelay,	-1
		 ;SetKeyDelay,-1
	SetBatchlines,	-1
		 SetWinDelay,	-1
	Settitlematchmode,	2
DetectHiddenWindows,	On
	 DetectHiddenText,	On
	CoordMode,Tooltip,	Screen
	  CoordMode,Caret,	Screen
	  CoordMode,Mouse,	Screen
	  CoordMode,Pixel,	Screen
return,
 
^+f::Settimer,FinreplaceallwithSEL,-50

FinreplaceallwithSEL:
ahwnd:= winexist("a")
wingetclass,aclss,ahk_id %ahwnd%
if(aclss!="Notepad++")
	return,
send,^f
loop {
	sSleep(10)
	if((a2hwnd:= winexist("a"))!=ahwnd)
		break,
} wingetclass,a2clss,ahk_id %a2hwnd%
if(a2clss!="#32770")
	return,
ControlGet,Seltxt,Selected,,edit1,ahk_id %a2hwnd%
ControlClick,x94 y15,ahk_id %a2hwnd%,,,,Pos
ControlSetText,edit2,% Seltxt,ahk_id %a2hwnd%
ControlClick,button31,ahk_id %a2hwnd%
return,