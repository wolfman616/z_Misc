; Floater-Widget-launcher thing-of-beauty /eyesore 
#NoEnv ;#Notrayicon ;PSYCH0S1S 2022; Run with UI Access for best results.
global timeoff:= -1880, timeon:= -999
,gui_pos1,gui_pos2,gui_pos3,hwnd2,hwnd3
,wmp_transp_hwnd,Brightness_hwnd

menu,tray,icon,% "C:\Icon\256\Psy0wl.ico",,48
 
#include C:\Script\AHK\- _ _ LiB\GDI+_All.ahk
#persistent
#KeyHistory,		0
#Singleinstance,	Force

setbatchlines,		-1
SetWinDelay,		-1
setcontroldelay,	-1

DetectHiddenWindows,On
DetectHiddenText,On
SetTitleMatchMode,	2
ListLines,			Off

coordMode,	ToolTip,Screen
coordmode,	Mouse,	Screen

setworkingDir,% (aHkeXe:= splitpath(A_AhkPath)).dir

menu tray,add,hide me pls,TrayHide_timeout
menu tray,icon,hide me pls,C:\Icon\32\32.ico
menu tray,add,dont hide pls,dontTrayHide_timeout
menu tray,icon,dont hide pls,C:\Icon\32\32.ico
menu,tray,add,Move element 1,Move1
menu,tray,add,Move element 2,Move2
menu,tray,add,Move element 3,Move3
menu,tray,add,Remove element 1,Remove1
menu,tray,add,Remove element 2,Remove2
menu,tray,add,Remove element 3,Remove3
menu,tray,add,add new element 4,new4
menu tray,add,% "titlebar\tray",TitleiTogl

OnMessage(0x3,"wm_move")
OnMessage(0x04a,"Receive_WM_COPYDATA") ; 0x4a=WM_COPYDATA
OnMessage(0x201,"LeftButtonDown")
OnMessage(0x204,"RightButtonDown")

timer("TrayHide_timeout",-10000)

process,exist,aerohost.exe
if(errorlevel) { ; AeroGlass watermark cover-up workaround. ;
	ImgFilePath1:= a_scriptdir "\images\aeroglassblack.png"
	gui_pos1	:= "x3541 y1010", gui_noactiv81:= "noactivate"
}

; create 2nd pic; "desired image Un-illuminated"
ImgFilePath2:= a_scriptdir "\images\PSYCHOSIS_5.4.png"
gui_pos2	:= "x3501 y1010", gui_zpos2:= "+UIBand"
gui_noactiv82:= "noactivate"

; create 3rd pic "desired image illuminated"
ImgFilePath3:= a_scriptdir "\images\illuminated5.png" 
gui_pos3	:= "x3501 y1010", gui_zpos3:= "+UIBand"
gui_noactiv83:= "noactivate"

loop,parse,% "ImgFilePath1,ImgFilePath2,ImgFilePath2,ImgFilePath3",`,
	if(!fileexist(%A_loopfield%))
		FileSelectFile,%A_loopfield%,,% "D:\Documents\My Pictures",% "Imp0rt Img-File to layer " . id_L
	else,switch,A_loopfield {
		case,"ImgFilePath1" : hwnd1:= 1mgdr4w(ImgFilePath1,1,"br","br","neither always on top nor UI_BAND")
		case,"ImgFilePath2" : hwnd2:= 1mgdr4w(ImgFilePath2,3,"br","br","UIBand")
			winset,exstyle,+0x08800010,ahk_id %hwnd2%
			style(hwnd2,"-0x040a0000")
		case,"ImgFilePath3" : hwnd3:= 1mgdr4w(ImgFilePath3,4,"br","br","UIBand")
			winset,exstyle,+0x08800010,ahk_id %hwnd3%
			style(hwnd3,"-0x040a0000")
	}
wm_move()

settimer,% "Phase_off",-1
return,
;'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`'~'`';

RightButtonDown() {
tt("gay")
return,0
}

~^!escape:: ; ctl-alt-escape ;
GuiEscape:
GuiClose:
exitapp,

New1:
New2:
New3:
New4:
New5:
id_L:= SubStr(a_thislabel,-1 ,1)
switch,a_thislabel { ; case "New4":		; menu,tray,add,add new element 5,new5	; case "New5":	 ; menu,tray,add,add new element 6,new6
	 default:
		FileSelectFile,ImgNew%id_L%,,% "D:\Documents\My Pictures",% "Imp0rt Img-File to layer " . id_L
		,*.png;*.jpg;*.bmp;,*.ico;*.jpeg;*.webm;*.webp		
		msgb0x("Zpos","UIBAND OR NORMAL")
		ifmsgbox,ok
			 bandopt:= "UIBand"
		else,bandopt:= "dribble" ; gui,Pwn%id_L%:New,+hWnd
		hGui%id_L%:= 1mgdr4w(ImgNew%id_L%,id_L,"br","br",bandopt)
}
return,

move1:
move2:
move3:
move4:
move5:
id_L := SubStr(a_thislabel,-1,1)
gui,Pwn%id_L%:-e0x20
; switch a_thislabel {
	; case "move5":
	; case "move4":
	; case "move3":
	; case "move2":
	; case "move1":
; }
return,

TitleiTogl:
((titlei:= !titlei)? titleitem:= " +toolwindow -caption " : titleitem:= "")
return,

Remove1:
Remove2:
Remove3:
Remove4:
Remove5:
id_L := SubStr(a_thislabel,-1,1)
switch,a_thislabel { ; case "Remove5":; case "Remove4":; case "Remove3":; case "Remove2":; case "Remove1":
	default: gui,Pwn%id_L%: Destroy
}
return,

Phase_off() { ; Lights out.
	global hwnd2,hwnd3,timeoff
	DllCall("ShowWindow","Ptr",hwnd2,"Int",4)
	,style(hwnd3,"-0x10000000")
	sleep,10
	settimer,% "Phase_on",% timeoff
}

Phase_on() { ; Lights on.
	global hwnd2,hwnd3,timeon
	DllCall("ShowWindow","Ptr",hwnd3,"Int",4)
	,style(hwnd2,"-0x10000000")
	sleep,10
	settimer,% "Phase_off",% timeon
}

LeftButtonDown(wParam,lParam) { ; testing clickability ;
	global adv,ass_val,Child_slider,WMPMATT,playing,hwnd1
	xs:= (lParam &0xffff), ys:= lParam>> 16
	tt(xs "`n" ys)
	if((xs>159)&&(xs<182)) {
		
		if(wmp_transp_hwnd) 
		{
			winshow,ahk_Class WMP Skin Host
			winrestore,ahk_Class WMP Skin Host
 winactivate,ahk_Class WMP Skin Host
		} else,run,% "C:\Script\AHK\Z_MIDI_IN_OUT\wmp_transp.ahk"
	}
	return,0
}

wm_move() {
	global	; Foreign scripts sometimes active in the screen region ;
		; if present this scripts guipos is adjusted ;		
	static wmp_transp:= "wmp_transp.ahk" ;WMP-Transport sliders satellite script;
	,	bright_sld:= "DisplayBrightnessSlider2hWnd.ahk" ;Screenbrightness gui;
	 wmp_transp_hwnd:= winexist(wmp_transp " Ahk_class AutoHotkey")
	,Brightness_hwnd:= winexist(bright_sld " Ahk_class AutoHotkey")
	,(wmp_transp_hwnd=0x0? wmp_transp_hwnd:=False:())
	,(Brightness_hwnd=0x0? Brightness_hwnd:=False:())
	 win_move(hwnd2,a_screenwidth-351-(Brightness_hwnd?18:0),a_screenheight-331-(wmp_transp_hwnd?32:0),351,331,"")
	,win_move(hwnd3,a_screenwidth-351-(Brightness_hwnd?18:0),a_screenheight-331-(wmp_transp_hwnd?32:0),351,331,"")
}

1mgdr4w(imageFilePath,id_num,xpos:="",ypos:="",zpos:="") {
	global
	pToken:= Gdip_Startup(), pImage:= Gdip_CreateBitmapFromFile(imageFilePath)
	w_Cur:= Gdip_GetImageWidth(pImage), H_Cur:= Gdip_GetImageHeight(pImage)
	mDC:= Gdi_CreateCompatibleDC(0), mBM:= Gdi_CreateDIBSection((mDC),w_Cur,H_Cur,32)
	oBM:= Gdi_SelectObject(mDC,mBM), pGFX:= Gdip_CreateFromHDC(mDC)
	Gdip_DrawImageRectI(pGFX,pImage,0,0,w_Cur,H_Cur)
	(zpos="aot" || zpos="UIBand")? aotop:="+AlwaysOnTop" : aotop:=""
	gui,Pwn%id_num%: New
	gui,Pwn%id_num%:-DPIScale +owndialogs +owner +LastFound -Caption +toolwindow -0x10000000 +E0x8080008 +HWNDhGui%id_num%
	gui,pic_%id_num%:New,-dpiscale +ParentPwn%id_num% %aotop% +ToolWindow +E0x8080008,cunt ;-DPIScale
	gui,pic_%id_num%:+LastFound -Caption
	if(xpos="br"||ypos="br")
		 gui_pos%id_num%:= "x" (a_screenwidth-w_Cur) " y" (a_screenheight-H_Cur) ; offset to bottom right of display ;
	else,guipos%id_num%:= "x" w_Cur " y" H_Cur
	gui,Pwn%id_num%:Show,% "hide noactivate " gui_pos%id_num% "w" w_Cur " h" H_Cur
	gui,Pwn%id_num%:-Caption %aotop%
	;gui,pic_%id_num%:-E0x20

	DllCall("UpdateLayeredWindow","Uint",hGui%id_num%,"Uint",0,"Uint",0,"int64P",w_Cur|H_Cur<<32
	,"Uint",mDC,"int64P",0,"Uint",0,"intP",0xFF<<16|1<<24, "Uint", 2)
	gui,Pwn%id_num%:Show,hide na
	GDI_SelectObject(mDC,oBM), Gdi_DeleteObject(mBM)
	Gdi_DeleteDC(mDC), Gdip_DeleteGraphics(pGraphics)
	Gdip_DisposeImage(pImage), Gdip_Shutdown(pToken)
	;if(zpos != "UIBand") ;return,hGui%id_num% ;else,;
	return,hGui%id_num%
}

exstyle(hwnd,exstyle) {
	winset,exstyle,% exstyle,ahk_id %hwnd% 
}

style(hwnd,style) {
	winset,style,% style,ahk_id %hwnd%
}

trans(hwnd,val) {
	winset,transparent,% val,ahk_id %hwnd%
}

ShowWindow(hWnd,nCmdShow:= 1) {
	DllCall("ShowWindow","Ptr",hWnd,"Int",nCmdShow)
}

sl33p() {
	static Start_,Started,Delay,i,Rate,Rate_
	(!started? (Start_:= a_TickCount, i:= 1, Started:= True, Rate_:= 35))
	((I=222)? (Rate_:= (a_TickCount-Start_), Started:= False) : i++)
	loop,% Rate:= (9000/Rate_) {
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
		sleep,0 ,sleep,0 sleep,0 sleep,0 sleep,0 sleep,0 sleep,0
}	}

TrayHide_timeout:
dontTrayHide_timeout:
switch,a_thislabel {
	case,"dontTrayHide_timeout"	: timer("TrayHide_timeout",off)
	case,"TrayHide_timeout"		: menu,tray,noicon
}