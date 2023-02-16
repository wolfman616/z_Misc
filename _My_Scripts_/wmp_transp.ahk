a_scriptStartTime:= a_tickCount ; (MW:2022) (MW:2022)
#NoEnv 
menu,tray,icon,% "C:\Icon\24\Gterminal_24_32.ico"
; #IfTimeout,200 ;* DANGER * : Performance impact if set too low. *think about using this*.
; ListLines,Off 
#persistent 
#Singleinstance,	Force
#include C:\Script\AHK\- _ _ LiB\GDI+_All.ahk
DetectHiddenWindows,On
DetectHiddenText,	On
SetTitleMatchMode,	2
SetTitleMatchMode,	Slow
Setworkingdir,% (splitpath(a_AhkPath)).dir
SetBatchLines,		-1
SetWinDelay,		-1
coordMode,	ToolTip,Screen
coordmode,	Mouse,	Screen
OnMessage(0x201,"lbd")
OnMessage(0x404,"AHK_NOTIFYICON")
loop,parse,% "VarZ,MenuZ",`,
	 gosub,% a_loopfield
	 
global exStyles= 0x0000008, SliderVal:= 0
, Transp_W:= 800, Transp_H:= 32, tr, Ratio_SliderL, dur, Current_T, Current_T_Old, Playing, SliderVal,gui_zpos,gui_pos1,ImgFilePath1,Playmark_X,Playmark_Y,hwnd1, chkd, transpVol_hwnd, Childvol_slider,transpSl_hwnd,ready2calc:=true, SliderValold, AppVol,Child_slider
, Transpvol_W:=Transp_W*.25 , Transpvol_H:= 32
, TranspSlider_X:= (a_screenwidth -Transp_W), TranspSlider_Y:= (a_screenheight -Transp_H*1.5)
, TranspVol_X:= (a_screenwidth -Transp_W)+230, TranspVol_Y:= (a_screenheight -Transp_H*3)
, opt_topmost:= true, topmoist, increment_transp
, TranspSlider_L:= Transp_W-20 ;780
, TranspVol_L:= Transpvol_W-20 ;780
, TransBack_Amt:= 64, AppVol
, WMPMATT:= "wmp_Matt.ahk ahk_class AutoHotkey"

wm_allow()
Result:= Send_WMCOPYDATA("init_transport",WMPMATT)
sleep,700
AppVol-=12

opt_topmost? topmoist:="+alwaysontop" :  topmoist:= ""
gui,par:new,-DPIScale %topmoist% +hwndparhwnd -Caption +e0xa080000
gui,tran:New,+e%exStyles% -DPIScale +toolwindow %topmoist% +hWndtranspSl_hwnd -Caption +e0x8000000 ;+parentpar
gui,tran:Add,Slider,Range0-100 AltSubmit NoTicks Thick w%Transp_W% H%Transp_H% +hWndChild_slider gSlider_Labl vSliderVal,%Current_T%
gui,Vol:New,+e%exStyles% -DPIScale +toolwindow %topmoist% +hWndtranspVol_hwnd -Caption +e0x8000000 ;+parentpar
gui,Vol:Add,Slider,Range0-100 AltSubmit NoTicks Thick w%Transpvol_W% H%Transpvol_H% +hWndChildvol_slider vAppVol
gui,tran:show,na hide x%TranspSlider_X% y%TranspSlider_Y%
gui,Vol:show,na hide x%TranspVol_X% y%TranspVol_Y%
;gui,par:show,na  w%Transp_W% h64 x%TranspVol_X% y%TranspVol_Y%
; DllCall( "AnimateWindow","Ptr",transpSl_hwnd,"Int",200,"UInt",0x90000)
trans(transpSl_hwnd,TransBack_Amt)
trans(transpVol_hwnd,TransBack_Amt)

; create 2nd pic; "the desired image"
ImgFilePath1 := "C:\Users\ninj\Desktop11\vsbD112.tmp.png"
gui_pos1:= "x3042 y1189", Playmark_X:= 3042, Playmark_Y:= 1169, gui_zpos:= "+UIBand"
gui_noactiv81:= "NoActivate"

tr:= wingetpos(transpSl_hwnd)
,Ratio_SliderL:= 101/TranspSlider_L
,Ratio_volL:= 101/TranspVol_L

Result:= Send_WMCOPYDATA("init_transport",WMPMATT)

settimer,Playmark_Init,-1

sleep,300

settimer,ani1,-21
settimer,ani3,-21
settimer,ani2,-21

OnMessage(0x04a,"RX_WM_COPYDATA")
OnMessage(0x20A,"WM_MWheel")
return, ;GUI_SHOWN;
;-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'

ani1:
Win_Animate(parhwnd,"slide hneg",300)
return, ;GUI_SHOWN;

ani2:
Win_Animate(transpSl_hwnd,"slide hneg",300)
return, ;GUI_SHOWN;

ani3:
Win_Animate(transpVol_hwnd,"slide hneg",100)
return, ;GUI_SHOWN;

;-= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ 
Playmark_Init:
hwnd1:= 1mgdr4w(ImgFilePath1,1,Playmark_X,Playmark_Y,"br")
winset,exstyle,+0x08800020,ahk_id %hwnd1%
,style(hwnd1,"-0x040a0000"), style(hwnd1,"+0x08000000")
return,

transpdrag:
settimer,transpdrag,1
ready2calc:= True
if(!(s:=getkeystate("lbutton","p"))) {
	settimer,transpdrag,off
	return,
}
mousegetpos,xxx,,mhwnd
SliderVal:= ((Tagg:= xxx-TranspSlider_X) *Ratio_SliderL)-3
if(!SliderValold)
	SliderValold:= SliderVal
else,if(SliderValold= SliderVal) {
	return,
} else,Result:= Send_WMCOPYDATA("x" SliderVal,WMPMATT)
try,guiControl,,% Child_slider,% SliderVal
win_move(hwnd1,3042+ (SliderVal/Ratio_SliderL) -36,1189,128,3,"")
SliderValold:= SliderVal
return,

VolDrag:
mousegetpos,xx,,mhwnd
if(!(s:=getkeystate("lbutton","p"))) {
	ready2calc:= True
	settimer,voldrag,off
	return,
}

AppVol:= (vagg:= (xx-TranspVol_X)-25) *Ratio_volL
,Result:= Send_WMCOPYDATA("v" AppVol,WMPMATT)
try,guiControl,,% Childvol_slider,% AppVol
sleep,10
return,

LBD(wParam="",lParam="") {
	global transpVol_hwnd,Ratio_SliderL,SliderVal
	,Child_slider,WMPMATT,playing,hwnd1,Ratio_volL,ready2calc
	mousegetpos,,,mhwnd
	xs:= (lParam &0xffff) -8
	, ys:= lParam>> 16
	if(!ready2calc)
		return,1
	ready2calc:= False
	if(mhwnd=transpVol_hwnd) {
		AppVol:= Xs *Ratio_volL
		,Result:= Send_WMCOPYDATA("v" AppVol,WMPMATT)
		try,guiControl,,% Childvol_slider,% AppVol-12
		settimer,voldrag,1
		return,1
	} if(mhwnd=transpSl_hwnd) {
		if(playing) {
			settimer,play_inc,1000
			settimer,play_chk,7000
			settimer,state_chk,off
		}	Result:= Send_WMCOPYDATA("x" SliderVal:= xs*Ratio_SliderL,WMPMATT)
		try,guiControl,,% Child_slider,% SliderVal
		win_move(hwnd1,3042+ (SliderVal/Ratio_SliderL) -30,1189,128,3,"")
		settimer,transpdrag,180
		return,1
	} else,return,1
}

WM_MWheel(wParam,lParam) {
	mousegetpos,,,hwnd ;tt(format("{:#x}",wParam))
	if(hwnd=transpVol_hwnd) {
		shift:= (wParam &0x0004)? true : false
		if(wParam=0x780000||wParam=0x780004||wParam=0x780008) {
			(shift? (AppVol+=10) : (AppVol++))	;wheelup
			Result:= Send_WMCOPYDATA("v" AppVol,WMPMATT)
			try,guiControl,,% Childvol_slider,% AppVol
		} else,if(wParam=0xFF880008||wParam=0xFF880004||wParam=0xFF880000) {
			(shift? (AppVol-=10) : (AppVol--)) ;wheeldown
			Result:= Send_WMCOPYDATA("v" AppVol,WMPMATT)
			try,guiControl,,% Childvol_slider,% AppVol
		}
		tt(AppVol)
		return,0
	} else,if(hwnd=transpSl_hwnd)
		return,
	else,return,
}

RX_WM_COPYDATA(byref wParam,byref lParam) {
	global Current_T,dur,Child_slider,Playing,SliderVal,Ratio_SliderL,hwnd1,AppVol
	CopyOfData:= StrGet(NumGet(lParam +2 *a_PtrSize))
	switch,_:= substr(CopyOfData,1,1) {
		case,"d" : dur:= LTrim(CopyOfData,"d")
			if(Current_T) {
				try,guiControl,,% Child_slider,% SliderVal:= Current_T *(100 /dur)
				xt:=3042+ (SliderVal /Ratio_SliderL) -30
				,win_move(hwnd1,xt,1189,128,3,"")
			} else,return,Current_T:= 0.1
			return,
		case,"i" : return,Current_T:= LTrim(CopyOfData,"i")
		case,"p" : increment_transp:= ""
			settimer,play_inc,-50
			settimer,play_chk,5000
			settimer,state_chk,off
			return,Playing:= True
		case,"s" : settimer,play_inc,off
			settimer,play_chk,off
			settimer,state_chk,2300
			return,Playing:= false
		case,"v" : AppVol:= LTrim(CopyOfData,"v")
			guiControl,,% Childvol_slider,% AppVol-12
			return,
}	}

state_chk:
Result:= Send_WMCOPYDATA("c" SliderVal:= Xs *Ratio_SliderL,WMPMATT)
return,

play_inc:
guiControl,,% Child_slider,% SliderVal+= (100 /dur)
xt:=3040 +(SliderVal /Ratio_SliderL) -30
,win_move(hwnd1,xt,1189,128,3,"")
,play_inc_delay:= (100 /dur) *10000
settimer,play_inc,% play_inc_delay
return,

play_chk:
Current_T_Old:= Current_T
try,chkd:= Current_T*(100/dur)
if(!chkd)||(!Current_T)
	settimer,state_chk,-1
	return,
if(chkd>(SliderVal +3) || (chkd<SliderVal-3)) {
	(!playing? playing:=True)
	Result:= Send_WMCOPYDATA("init_transport",WMPMATT)
	loop,20
		if(Current_T!=Current_T_Old) {
			Current_T_Old:= Current_T
			break,
		} else,sleep,20
	tt("resyncing 2: " chkd  " was: " SliderVal,5000)
}
else,chkd:= Current_T:= ""
,tt("     OK     `nt" chkd)
return,

Slider_Labl:
;tt(SliderVal)
return,

vol_Labl:
;Result:= Send_WMCOPYDATA("v" vvol:= Xs *Ratio_volL,WMPMATT)
return,

1mgdr4w(imageFilePath,id_num,xpos:="",ypos:="",zpos:="") {
	global
	pToken:= Gdip_Startup(), pImage:= Gdip_CreateBitmapFromFile(imageFilePath)
	w_Cur:= Gdip_GetImageWidth(pImage), H_Cur:= Gdip_GetImageHeight(pImage)
	mDC:= Gdi_CreateCompatibleDC(0), mBM:= Gdi_CreateDIBSection((mDC),w_Cur,H_Cur,32)
	oBM:= Gdi_SelectObject(mDC,mBM), pGFX:= Gdip_CreateFromHDC(mDC)
	Gdip_DrawImageRectI(pGFX,pImage,0,0,w_Cur,H_Cur)
	(zpos = "aot" || zpos = "UIBand")?	aotop:="+AlwaysOnTop" : aotop:=""
	gui,Pwn%id_num%:	 New
	gui,Pwn%id_num%:	-DPIScale +LastFound -Caption +toolwindow +E0x8080028 +HWNDhGui%id_num%
	gui,pic_%id_num%:	 New,-dpiscale +ParentPwn%id_num% %aotop% +ToolWindow +E0x8080028 ;-DPIScale
	gui,pic_%id_num%:	+LastFound -Caption
	if( xpos="br"||ypos="br" )
		 gui_pos%id_num%:= ("x" . (a_screenwidth-w_Cur) . " y" . (a_screenheight-H_Cur))  ; offset to bottom right of display
	else,guipos%id_num%:= ("x" .  w_Cur . " y" . H_Cur)
	gui,Pwn%id_num%:	 Show,% "noactivate " gui_pos%id_num% "w" w_Cur " h" H_Cur
	gui,Pwn%id_num%:	-Caption %aotop%
	DllCall("UpdateLayeredWindow","Uint",hGui%id_num%,"Uint",0,"Uint",0,"int64P",w_Cur|H_Cur<<32
	,"Uint",mDC,"int64P",0,"Uint",0,"intP",0xFF<<16|1<<24, "Uint", 2)
	GDI_SelectObject(mDC,oBM), Gdi_DeleteObject(mBM)
	Gdi_DeleteDC(mDC), Gdip_DeleteGraphics(pGraphics)
	Gdip_DisposeImage(pImage), Gdip_Shutdown(pToken)
	if(zpos!="UIBand")
		return,hGui%id_num%
	else,return,hGui%id_num%
}

exstyle(hwnd,exstyle) {
	winset,exstyle,% exstyle,ahk_id %hwnd% 
}

style(hwnd,style) {
	winset,style,% style,ahk_id %hwnd%
}

trans(hwnd,val) {
	winset,transparent,%val%,ahk_id %hwnd%
}

reload() {
	reload,
	exitapp,
}

menuz:
menu,Tray,NoStandard
menu,Tray,Add,%	 splitpath(a_scriptFullPath).fn,% "do_nothing"
menu,Tray,disable,% splitpath(a_scriptFullPath).fn
menu,Tray,Add ,% "Open",%	"MenHandlr"
menu,Tray,Icon,% "Open",%	"C:\Icon\24\Gterminal_24_32.ico"
menu,Tray,Add ,% "Open Containing",%	"MenHandlr"
menu,Tray,Icon,% "Open Containing",%	"C:\Icon\24\explorer24.ico"
menu,Tray,Add ,% "Edit",%	"MenHandlr"
menu,Tray,Icon,% "Edit",%	"C:\Icon\24\explorer24.ico"
menu,Tray,Add ,% "Reload",%	"MenHandlr"
menu,Tray,Icon,% "Reload",%	"C:\Icon\24\eaa.bmp"
menu,Tray,Add,%	 "Suspend",%	"MenHandlr"
menu,Tray,Icon,% "Suspend",%	"C:\Icon\24\head_fk_a_24_c1.ico"
menu,Tray,Add,%	 "Pause",%		"MenHandlr"
menu,Tray,Icon,% "Pause",%		"C:\Icon\24\head_fk_a_24_c2b.ico"
menu,Tray,Add ,% "Exit",%		"MenHandlr"
menu,Tray,Icon,% "Exit",%		"C:\Icon\24\head_fk_a_24_c2b.ico"
(ahkexe:= splitpath(a_AhkPath)).fn
,	 (_:= (splitpath(a_scriptFullPath).fn) " Started`n@ " time4mat() "   In:  "
.	_:= (a_tickCount-a_scriptStartTime) " Ms")
sleep,100
_:="", a_scriptStartTime:= time4mat(a_now,"H:m - d\M")
menu,Tray,Tip,% splitpath(a_scriptFullPath).fn "`nRunning, Started @`n" a_scriptStartTime

do_nothing:
return,

MenHandlr(isTarget="") {
	switch,(isTarget=""? a_thismenuitem : isTarget) {
		case,"Open Containing": TT("Opening "   a_scriptdir "..." Open_Containing(a_scriptFullPath),1)
		case,"edit","Open","SUSPEND","pAUSE":
			PostMessage,0x0111,(%a_thismenuitem%),,,% a_ScriptName " - AutoHotkey"
		case,"RELOAD": reload()
		case,"EXIT": exitapp
		default: islabel(a_thismenuitem)? timer(a_thismenuitem,-10) : ()
	}	
	return,1
}

AHK_NOTIFYICON(byref wParam="",byref lParam="") {
	switch lParam {
	;	case,0x0206: ; WM_RBUTTONDBLCLK	;	case,0x020B: ; WM_XBUTTONDOWN
	;	case,0x0201: ; WM_LBUTTONDOWN	;	case,0x0202: ; WM_LBUTTONUP
		case,0x0204: 
			return,settimer,menutray,-1 ; WM_RBUTTONdn
		case,0x0203: 
			(_:="",wParam:=""),
			;settimer,ID_VIEW_VARIABLES,-10
			PostMessage,0x0111,%open%,,,% a_ScriptName " - AutoHotkey"
			sleep(80),lParam:=(sleep(11),tt("Loading...","tray",1)) ; WM_doubleclick  
	}
	return,
}

menutray(){
	global
	Menu,Tray,Show
}

varz:
global	EDIT:=65304, open:=65407, Suspend:=65305, PAUSE:=65306, exit:=6530
global	This_PiD:= DllCall("GetCurrentProcessId")
return,