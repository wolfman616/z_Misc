
;test:
;/* 
; Setcontroldelay -1
; SetBatchLines -1
; SetWinDelay -1
; #SingleInstance force
; SendMode,Input
; ListLines,Offonexit("clean")
; sleep,23
; Dicon_fade("out")
; Dicon_fade("in")
; Dicon_fade("out")
; Dicon_fade("in")
; Dicon_fade("out")
; Dicon_fade("in")
; return,

; #p::
; Dicon_fade("out")
; msgbox
; Dicon_fade("in")
; return, 
;*/
;test:

Dicon_fade(fadeinout="") {
	static MainhWnd,hSysListView,hpic,mdc,hProgman,hShellDefView,SysLv_DC,ShDef_DC
	SetBatchLines -1
	SetWinDelay -1
	if(fadeinout="out") {
		pToken:= Gdip_Startup()
		sleep,30
		gui,Back: New,-DPIScale +toolwindow +owner -SysMenu +E0x80000
		gui,Back:+LastFound +HwndMainhWnd -Caption
		gui,pic: New,-DPIScale +hwndhpic +parentBack +ToolWindow E0x80000
		gui,pic:+LastFound -Caption -SysMenu +OwnDialogs
		gui,Back: Show,na x0 y0 w%a_screenwidth% h%a_screenheight%
		main_DC:= DllCall("GetDC","UInt",MainhWnd)
		mdc:= DllCall("GetDC","UInt",hpic)
		 DllCall("gdi32.dll\SetStretchBltMode","Uptr",main_DC,"UInt",3)
		,DllCall("gdi32.dll\SetStretchBltMode","Uptr",SysLv_DC,"UInt",3)
		,DllCall("gdi32.dll\SetStretchBltMode","Uptr",mdc,"UInt",3)
		hProgman:= WinExist("ahk_class WorkerW", "FolderView")? WinExist() : WinExist("ahk_class Progman", "FolderView")
		ShDef_DC:= 	DllCall("GetDC","UInt",hShellDefView:= DllCall("user32.dll\GetWindow","ptr",hProgman,"int",5,"ptr"))
		SysLv_DC:= 	DllCall("GetDC","UInt",	hSysListView:= DllCall("user32.dll\GetWindow","ptr",hShellDefView,"int",5,"ptr"))
		winset,exstyle,+0x08000000,ahk_id %hSysListView%
		DllCall("SetParent","ptr",hpic,"ptr",dd:= desktop())
		sleep,50
		gui,pic: show,na x0 y0 w%a_screenwidth% h%a_screenheight%
		DllCall("UpdateLayeredWindow","Uint",hpic,"Uint",0,"Uint",0,"int64P", a_screenwidth|a_screenheight<<32
		,	"Uint",SysLv_DC,"int64P",0,"Uint",0,"intP",0xff<<16|1<<24, "Uint", 2)
		,	trans(hSysListView,1)
		sleep,40
		loop,255 {
			DllCall("UpdateLayeredWindow","Uint",hpic,"Uint",0,"Uint",0,"int64P",a_screenwidth|a_screenheight<<32
		,	"Uint",SysLv_DC,"int64P",0,"Uint",0,"intP",(0xff-a_index)<<16|1<<24,"Uint",2)
			DllCall("UpdateLayeredWindow","Uint",MainhWnd,"Uint",0,"Uint",0,"int64P",a_screenwidth|a_screenheight<<32
		,	"Uint",mdc,"int64P",0,"Uint",0,"intP",(0xff-a_index)<<16|1<<24,"Uint",2)
			sl33p()
		}
		Gdip_Shutdown(ptoken)
		DllCall("user32.dll\SendMessage", "ptr",hShellDefView, "uint",0x111, "uint",0x7402, "uint",0)
		sleep,30
		return,
	} else,if(fadeinout="in") {
		pToken:= Gdip_Startup()
		winset,exstyle,+0x08000000,ahk_id %hSysListView%
		sleep,20
		loop,255 {
			DllCall("UpdateLayeredWindow","Uint",hpic,"Uint",0,"Uint",0,"int64P", a_screenwidth|a_screenheight<<32
		,	"Uint",SysLv_DC,"int64P",0,"Uint",0,"intP",(0x00+a_index)<<16|1<<24, "Uint", 2)
			DllCall("UpdateLayeredWindow","Uint",MainhWnd,"Uint",0,"Uint",0,"int64P", a_screenwidth|a_screenheight<<32
		,	"Uint",mdc,"int64P",0,"Uint",0,"intP",(0x00+a_index)<<16|1<<24, "Uint", 2)
			sl33p(),
		}
		winset,style,-0x10000000,ahk_id %hSysListView%
		trans(hSysListView,"off")
		winset,style,+0x10000000,ahk_id %hSysListView%
		winset,style,+0x46003A40,ahk_id %hSysListView%
		trans(hpic,1)
		gui,pic:hide
		gui,pic:destroy
		gui,main:destroy
		sleep,40
		Gdip_Shutdown(ptoken)
		return,
	}
}

clean(){
	Gdip_Shutdown(ptoken)
}

trans(hwnd,val) {
	winset,transparent,% val,ahk_id %hwnd%
}

style(hwnd,style) {
	winset,style,% style,ahk_id %hwnd%
}

sl33p() {
	loop,345 {
		sleep,-1,sleep,-1,sleep,-1,sleep,-1,sleep,-1
		sleep,-1,sleep,-1,sleep,-1,sleep,-1,sleep,-1
		sleep,-1,sleep,-1,sleep,-1,sleep,-1,sleep,-1
		sleep,-1,sleep,-1,sleep,-1,sleep,-1,sleep,-1
		sleep,-1,sleep,-1,sleep,-1,sleep,-1,sleep,-1
	}
}