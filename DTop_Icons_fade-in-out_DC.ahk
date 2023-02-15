Setcontroldelay -1
SetBatchLines -1
SetWinDelay -1
#SingleInstance force
ListLines,Off
SendMode,Input
CoordMode,Mouse,Screen
global mdc,main_hwnd,hpic
onexit("clean")
tt("Begin")
sleep,900
gui,Back:New,-DPIScale +toolwindow +owner -SysMenu +E0x80020 ;+AlwaysOnTop
gui,Back:+LastFound +HwndMainhWnd -Caption
gui,Back:color,99ccff
winSet,Transcolor,99ccff
pToken:= Gdip_Startup()	;	winset,transcolor, 0
gui,pic: New,-DPIScale +hwndhpic  +parentBack +ToolWindow E0x80020 ;+AlwaysOnTop +e0x20
gui,pic: +LastFound -Caption -SysMenu +OwnDialogs
gui,pic: color,0f3f5c	;	winset,transcolor,0f00f0
gui,Back:Show,na x0 y0 w%a_screenwidth% h%a_screenheight%
main_DC:= DllCall("GetDC","UInt",MainhWnd)
	mdc:= DllCall("GetDC","UInt",hpic)
 DllCall("gdi32.dll\SetStretchBltMode","Uptr",main_DC,"UInt",3)
,DllCall("gdi32.dll\SetStretchBltMode","Uptr",SysLv_DC,"UInt",3)
,DllCall("gdi32.dll\SetStretchBltMode","Uptr",mdc,"UInt",3)
hProgman:= WinExist("ahk_class WorkerW", "FolderView")? WinExist()
:  WinExist("ahk_class Progman", "FolderView")
ShDef_DC:= 	DllCall("GetDC","UInt",hShellDefView:= DllCall("user32.dll\GetWindow","ptr",hProgman,"int",5,"ptr"))
SysLv_DC:= 	DllCall("GetDC","UInt",	hSysListView:= DllCall("user32.dll\GetWindow","ptr",hShellDefView,"int",5,"ptr"))
DllCall("SetParent","ptr",hpic,"ptr",dd:= desktop()) ; DllCall("SetParent","ptr",hpic,"ptr",MainhWnd)
gui,pic: show,na x0 y0 w%a_screenwidth% h%a_screenheight% 	;	winset,transcolor,0f00f0
DllCall("UpdateLayeredWindow","Uint",hpic,"Uint",0,"Uint",0,"int64P", a_screenwidth|a_screenheight<<32
,		"Uint",SysLv_DC,"int64P",0,"Uint",0,"intP",0xff<<16|1<<24, "Uint", 2)
,trans(hSysListView,1)
mdc:= DllCall("GetDC","UInt",hpic) 
,tt("Replaced",1)
sleep,900

;;Show:= -1
;DllCall("UpdateLayeredWindow","Uint",MainhWnd,"Uint",0,"Uint",0,"int64P", a_screenwidth|a_screenheight<<32
;,	"Uint",mdc,"int64P",0,"Uint",0,"intP",0xff<<16|1<<24, "Uint", 2)
;;if !(abc:=(DllCall("user32.dll\IsWindowVisible","ptr",hSysListView)=Show)){
;;	winhide,ahk_id %hSysListView%
;;	sleep,1000
;;	DllCall("user32.dll\SendMessage", "ptr",hShellDefView,"uint",0x111,"uint",0x7402,"uint",0)
;;}
mdc:= DllCall("GetDC","UInt",hpic)
sleep,1000

tt("Fade-out",1)
loop,255 {
	sl33p()
	DllCall("UpdateLayeredWindow","Uint",hpic,"Uint",0,"Uint",0,"int64P",a_screenwidth|a_screenheight<<32
,	"Uint",SysLv_DC,"int64P",0,"Uint",0,"intP",(0xff-a_index)<<16|1<<24,"Uint",2)
	DllCall("UpdateLayeredWindow","Uint",MainhWnd,"Uint",0,"Uint",0,"int64P",a_screenwidth|a_screenheight<<32
,	"Uint",mdc,"int64P",0,"Uint",0,"intP",(0xff-a_index)<<16|1<<24,"Uint",2)
}
sleep,1000

tt("Fade-in",1)
loop,255 {
	sl33p()
	DllCall("UpdateLayeredWindow","Uint",hpic,"Uint",0,"Uint",0,"int64P", a_screenwidth|a_screenheight<<32
,	"Uint",SysLv_DC,"int64P",0,"Uint",0,"intP",(0x00+a_index)<<16|1<<24, "Uint", 2)
	DllCall("UpdateLayeredWindow","Uint",MainhWnd,"Uint",0,"Uint",0,"int64P", a_screenwidth|a_screenheight<<32
,	"Uint",mdc,"int64P",0,"Uint",0,"intP",(0x00+a_index)<<16|1<<24, "Uint", 2)
}
;;	DllCall("user32.dll\SendMessage", "ptr",hShellDefView, "uint",0x111, "uint",0x7402, "uint",0)
winset,style,-0x10000000,ahk_id %hSysListView%
trans(hSysListView,"off")
winset,style,+0x10000000,ahk_id %hSysListView%
winset,style,+0x46003A40,ahk_id %hSysListView%
trans(hpic,1)
gui,pic: hide
gui,pic: destroy
return,

clean(){
	Gdip_Shutdown(ptoken)
}

trans(hwnd,val) {
	winset,transparent,% val,ahk_id %hwnd%
}

style(hwnd,style) {
	winset,style,% style,ahk_id %hwnd%
}

TT(TxT="",X:="",Y="",Dur="") {
	(TxT=""? TxT:= A_now)
	if(x && !isint(X)) {
		((isint(Y))? (Y? Dur:= Y))	;Transpose potential Dur arg.
		somethingElseThatMightBeDeclarableLater:= (Dur? Dur:())
		switch,(tt_loc:=X)	{
			case "center"	: X:=	(A_screenwidth *.5) -80,Y:= (A_screenheight*.5) -35
			case "!tray"	: X:=	(A_screenwidth -10),	Y:= (A_screenheight -10)
			case "tray"		: X:=	(A_screenwidth -10),	Y:=	45
		}
	} else,(!Y&&!Dur? Dur:= ((X)? X:-880))				;(Def timeout 880ms)
	((Dur&&!Dur=0)? ((Dur<100)&&(-100<Dur))? Dur*=1000)	;(Timeout as param.2 (int||str))
	ToolTip,% TxT,% (X&&Y? X:""),% (X&&Y? Y:""),1		;(y="center"? y:= (A_screenheight*.5)-35)
	SetTimer,Time0ut,% ((instr(Dur,"-")||(Dur<0))? Dur:("-" . Dur))
	return,~errOrlevel
} ; (x="center"?Dur:=y, x:=(A_screenwidth*0.5)-80, y:=(A_screenheight*.5)-35,)

sl33p() {
	loop,500 {
		sleep,-1,sleep,-1,sleep,-1,sleep,-1,sleep,-1
		sleep,-1,sleep,-1,sleep,-1,sleep,-1,sleep,-1
		sleep,-1,sleep,-1,sleep,-1,sleep,-1,sleep,-1
		sleep,-1,sleep,-1,sleep,-1,sleep,-1,sleep,-1
		sleep,-1,sleep,-1,sleep,-1,sleep,-1,sleep,-1
	}
}

Time0ut() {
	tooltip,
	return,
}