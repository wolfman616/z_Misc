#NoEnv ; (MW:2022) (MW:2022) visual cursor hotspot tool wip 2do: append file
#persistent ; ListLines,Off 
#Singleinstance,     Force
DetectHiddenWindows, On
DetectHiddenText,    On
SetTitleMatchMode,   2		
SetTitleMatchMode,   Slow
setWorkingDir,%    A_ScriptDir
SetBatchLines,      -1
SetWinDelay,        -1
SetControlDelay,        -1
coordMode,  ToolTip, Screen	
coordmode,  Mouse  , Screen 
#include <Taskbar>
#include C:\Script\AHK\- _ _ LiB\class_DragDrop.ahk
#Include C:\Script\AHK\- _ _ LiB\GDI+_All.ahk
global dtopdc,homeDC,G_hWnd,IconPath,hWnd_Par,hWndh0t,Marg_Hic,Cur_SzFactored,tl,parx,pary,parw,parh,Cur_W,HotSpot_X,HotSpot_Y,ord,EditX,EditY,CenterOffset
global Scale_Factor,Marg_Parent:=25,Marg_Cur:= 15,Marg_Hic:=40
global SRCCOPY:=0x00330008, NOTSRCCOPY:=0x00CC0020
global SliderOptions:="Range1-5 AltSubmit reverse NoTicks Thick y220 w200 x1 h40 +hWndpar_slider gpar_slider_glabel vScale_Factor"
IconPath:="C:\Icon\- Icons\- CuRS0R\Black-n-Purple Move.cur" ;IconPath:="C:\Icon\- Icons\- CuRS0R\cursor(9).cur"

loop,parse,% "VarZ,MenuZ,M4in",`,
	 gosub,% a_loopfield
return,
hiword(SRCCOPY)
M4in:
OnExit("ExitFunc")
OnMessage(0x203,"OnLButtonDblClk") 

If !(pToken := Gdip_Startup()){
	MsgBox "Gdiplus failed to start. Please ensure you have gdiplus on your system"
	ExitApp
}

(!PtrP? PtrP:= (A_PtrSize = 8)? "uptr*" : "Uint*") 
(!Ptr?  Ptr:=  (A_PtrSize = 8)? "ptr"   : "Uint")
(!IsObject(File:= FileOpen(IconPath,"r"))? msgb0x("error" . exit()))
fileGetSize,szfile,% IconPath,k
VarSetCapacity(Bin, Sz_Kb:= szfile*1024)
sLen:= file.RawRead(Bin,Sz_Kb)
(sLen<192?((File.Close()>>192),exitapp()) : TT("analyzed " szfile "kb"))
Cur_W:= NumGet(Bin,6,"Char"),	HotSpot_X:= NumGet(Bin,10,"UChar") 
Cur_H:= NumGet(Bin,7,"Char"),	HotSpot_Y:= NumGet(Bin,12,"UChar")
varsetcapacity(fileinfo,(fisize:= A_PtrSize + 688)) 
gui,par: New, +AlwaysOnTop +hWndhWnd_Par -dpiscale +lastfound +owner -SysMenu ; +OwnDialogs +ToolWindow   -Caption 
gui,par: Color,%    bc:= DllCall("GetSysColor", "Int", 15, "UInt") ; BTNFACE = 15
Gui,par: Add, Edit,gEditX vEditX x45 y0, %HotSpot_X%
Gui,par: Add, Edit,gEditY vEditY y0 x115,%HotSpot_Y%
gui,par: Margin,% Marg_Parent,% Marg_Parent

gui,par: Add,Picture,y%Marg_Hic% w%Cur_W% h%Cur_H% +hWndparhicon +0x4000000
gui,par: Add,Slider,% SliderOptions,slider ; +0X4000100 +E0x80008  ROUND(curr*0.1) ;(WS_EX_LAYERED := 0x80000),+0x30000 
gui,cur: New,+AlwaysOnTop +hWndG_hWnd -dpiscale -SysMenu +ToolWindow +lastfound -Caption -dpiscale ; +OwnDialogs 

gui,cur: Add,picture,w%Cur_W%  h%Cur_H% +hWndHhicon +0x4000000,% "HICON: " _:=ico2hicon(IconPath) ;0x4000000 draw over siblings
gui,par: Show,center w200
gui,cur: Show,% "na x" a_screenwidth-100 " y" a_screenheight-100 
	controlget, parent_control_handle, hWnd,, static, ahk_id %Parent_hwnd%
DllCall("SetParent", "uint", hWndh0t, "uint", parent_control_handle ) 

homeDC:= DllCall("GetDC","UInt",hWnd_Par)	;pic := "http://www.animatedgif.net/cartoons/A_5odie_e0.gif"
hicoDC:= DllCall("GetDC","UInt",hhicon)		;Gui,par: Add, ActiveX, w100 h150, % "mshtml:<img src='" pic "' />"
dtopdc:= DllCall("GetDC","UInt",shit)		;Gui,par: Show

gui,par: Submit,nohide
gosub,Par_slider_glabel		;gui,cur:hide
winset,transparent,+1,ahk_id %g_hWnd%
return,
 
HotspotMark:
Width:= Height:= 9
YHot:= HotSpot_Y*Scale_Factor, xHot:= HotSpot_X*Scale_Factor
lol:= ((6*Cur_W)-(Cur_SzFactored:= Cur_W*Scale_Factor))
wingetactivestats, tl,parw,parh,parx,pary
Gui,hot: new, -Caption +E0x80000 +hWndhWndh0t -dpiscale ;+parentpar 
Gui,hot: +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui,hot: Show,center w100 h100 NA,cunt
hbm:= CreateDIBSection(Width, Height)
hdc:= CreateCompatibleDC()
obm:= SelectObject(hdc, hbm)
G:= Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G,4)
pPen:= Gdip_CreatePen(0xffff0000,2)
Gdip_DrawEllipse(G,pPen,0,0 ,Height-1,Height-1)
Gdip_DeletePen(pPen)
UpdateLayeredWindow(hWndh0t,hdc,0,0,Width,Height) 
SelectObject(hdc,obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)	;Thegrahics may now be deleted
tx:=parx+(lol*.5)+xhot
ty:=pary +(lol*.5)+yhot+Marg_Parent+Marg_Hic
winmove,ahk_id %hWndh0t%,,%tx%,%ty% 
;DllCall("SetParent", "uint", hWndh0t, "uint", ParHicon2 ) 
return, 

Par_slider_glabel: 
settimer turds,-10
return

turds:
loop 1 {
	(!OldFactor? OldFactor:= Scale_Factor)
	(!oldcurw? oldcurw:= Cur_W*Scale_Factor)
	center:= ((6*Cur_W)-(Cur_SzFactored:= Cur_W*Scale_Factor))*0.5
	gui,par: Add,picture,x1 y31 w200 h180 +hWndParHicon2 ;blank to remove hall-of-mirrors underdraw
	gui,par: Show,na
	DllCall("gdi32.dll\StretchBlt","UInt",homeDC,"Int",center,"Int",CenterOffset:= center+Marg_Parent+Marg_Cur
			,"Int",Cur_SzFactored ,"Int",Cur_SzFactored,"UInt",hicoDC,"UInt",0,"UInt",0,"Int",Cur_W
			,"Int",Cur_W,"UInt",NOTSRCCOPY)	  
	DllCall("UpdateLayeredWindow" ,"Uint",hWnd_Par,"Uint",Marg_Parent+Marg_Cur,"Uint",Marg_Parent+Marg_Cur,"int64P",200|200<<32
								  ,"Uint",hicoDC,"int64P", 0,"Uint",0,"intP",0xFF<<16|1<<24,"Uint",2)
	gosub,HotspotMark
	sleep,60
	oldcurw:= Cur_W*(OldFactor:= Scale_Factor)
}
return,
		;tx:=parx+(lol*.5)+xhot 
        ;ty:=pary+(lol*.5)+yhot+Marg_Parent+Marg_Hic

OnLButtonDblClk(wParam, lParam, msg, hWnd) { ;sets new HotspotMark
	(xhot):= (((loword(lParam)))/Scale_Factor)-Marg_Parent-CenterOffset
	(yhot):= (((hiword(lParam))-(CenterOffset))/Scale_Factor)-Marg_Hic
	(EditX):= HotSpot_X:= floor(((loword(lParam)-(CenterOffset)+Marg_Hic))/Scale_Factor)
	(EditY):= HotSpot_Y:= floor(((hiword(lParam))-(CenterOffset))/Scale_Factor)
	GuiControl,Text,EditX,%EditX%	;Gui,par: Edit,gEditX c x45 y0, %HotSpot_X%
	GuiControl,Text,EditY,%EditY%	;Gui,par: Edit,gEditY vEditY y0 x115,%HotSpot_Y%
	Gui,par:submit,nohide	;tt((hiword(lParam)"y`n" (loword(lParam) "`n" )HotSpot_Y "`n  " HotSpot_X),1)
	gosub,HotspotMark	;cur_fileinfo("")
	id:= DllCall("GetDlgCtrlID", "ptr", hWnd)
	static STN_DBLCLK:= 1
	PostMessage 0x111, id | (STN_DBLCLK << 16), hWnd
	return,0	; return a value to prevent the default handling of this message.
}


EditX:
EditY:
Gui,par:submit,nohide
ord:=substr(a_thislabel,"ed")
if (!(%a_thislabel%)=(%ord%hotspot))
	return,
(%ord%hot):=((%ord%hotspot):=((%a_thislabel%))*Scale_Factor):=(ed%ord%)
;msgb0x((ed%ord%))
gosub,HotspotMark
return,
;WHITE_BRUSH=0; LTGRAY_BRUSH=1; GRAY_BRUSH=2; DKGRAY_BRUSH=3; BLACK_BRUSH=4; WHITE_PEN=6; BLACK_PEN=7

;;#######################################################################

ExitFunc(ExitReason, ExitCode)
{
   global
   ; gdi+ may now be shutdown on exiting the program
   	DllCall("ReleaseDC", "UInt", G_hWnd, "UInt", hdc)
   Gdip_Shutdown(pToken)
   g_vDD := ; Delete this object to unregister it from the super class and release it from the mouse hook.

}
;;#######################################################################

menuz:
menu, Tray, NoStandard
menu, Tray, Add ,% "Open",             ID_VIEW_VARIABLES
menu, Tray, Icon,% "Open",%            "C:\Icon\24\Gterminal_24_32.ico"
menu, Tray, Add ,% "Open Containing",  S_OpenDir
menu, Tray, Icon,% "Open Containing",% "C:\Icon\24\explorer24.ico"
menu, Tray, Add ,% "Edit Script",      ID_TRAY_EDITSCRIPT
menu, Tray, Icon,% "Edit Script",%     "C:\Icon\24\explorer24.ico"
menu, Tray, Add ,% "Reload",           ID_TRAY_RELOADSCRIPT
menu, Tray, Icon,% "Reload",%          "C:\Icon\24\eaa.bmp"
menu, Tray, Add ,% "Suspend VKs",      ID_TRAY_SUSPEND
menu, Tray, Icon,% "Suspend VKs",%     "C:\Icon\24\head_fk_a_24_c1.ico"
menu, Tray, Add ,% "Pause",            ID_TRAY_PAUSE
menu, Tray, Icon,% "Pause",%           "C:\Icon\24\head_fk_a_24_c2b.ico"
menu, Tray, Add ,% "Exit",             ID_TRAY_EXIT
menu, Tray, Icon,% "Exit",%            "C:\Icon\24\head_fk_a_24_c2b.ico"
return,

ID_TRAY_RELOADSCRIPT:
ID_TRAY_RELOADSCRIPT:= 65303
ID_TRAY_EDITSCRIPT:
ID_TRAY_EDITSCRIPT:= 65304
ID_VIEW_VARIABLES:
ID_VIEW_VARIABLES:= 65407
ID_TRAY_SUSPEND:
ID_TRAY_SUSPEND:= 65305
ID_TRAY_PAUSE:
ID_TRAY_PAUSE:= 65306
ID_TRAY_EXIT:
ID_TRAY_EXIT:= 65307
PostMessage,0x0111,(%a_thislabel%),,,% a_scriptName " - AutoHotkey"
return,

AHK_NOTIFYICON(wParam, lParam) {
	static init:=OnMessage(0x404, "AHK_NOTIFYICON")
	switch lParam {
	   ;case 0x205:  ; WM_RBUTTONUP
	   ;case 0x206:  ; WM_RBUTTONDBLCLK 
	   ;case 0x020B: ; WM_XBUTTONDOWN 
	   ;case 0x201:  ; WM_LBUTTONDOWN
	   ;case 0x202:  ; WM_LBUTTONUP
		case 0x203:  ; WM_LBUTTONDBLCLK
			tt("Loading...")
			settimer,ID_VIEW_VARIABLES,-1
			;PostMessage, 0x0111,%ID_VIEW_VARIABLES%,,,% (A_ScriptName " - AutoHotkey")
		case 0x0208: ; WM_MBUTTONUP  
			tt("fdsgg")
			settimer,ID_TRAY_RELOADSCRIPT,-1
}	}

varz:
return,

S_OpenDir:
TT("Opening "   a_scriptdir "...", 667)
Open_Containing(a_scriptFullPath)
return,