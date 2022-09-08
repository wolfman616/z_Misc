;~~~~~ 
#noEnv  ; #warn
#persistent,
#SingleInstance,	force
ListLines, 			Off
setBatchLines,		-1
setWinDelay,		-1
sendMode,   		Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard

Butt_Txt		:= 	"Child Butt!"
Butt_Font		:=	"Armada LightCondensed"
Butt_FontSz		:=	"s11"
AttatchMsg		:=	"click desired location 2 attatch!" ,
;CurAniFile		:=	"S:\Documents\Icons\- CuRS0R\_ ani\Fire Cursor.ani"

global 1stclick, global TipHandle, global Title, global Wi, global Hi, global Xi, global Yi, global ParentXs, global ParentYs, global ParentX, global ParentY
return

Butt:
MsgBox, BUTT-ON!
return

#z::
tooltip, % AttatchMsg, -10, -100
TipHandle:=winexist("ahk_class tooltips_class32")
;SetSystemCursor(CurAniFile)
mousegetpos, ParentXs, ParentYs,
settimer, Coord_get, 2
settimer, move_tt, 2
return

Coord_get:
CoordMode,  		mouse, Window		;	ToolTip|Pixel|Mouse|Caret|Menu / Screen|Window|Client
mousegetpos, 	ParentX, ParentY, Parent_Hwnd, Parent_cWnd
if (getKeyState("lbutton", "P")) {
	if !1stclick {
		1stclick:=true, 	
		settimer, Butt_Go, -200
	}
}
return

move_tt:
CoordMode,  	Mouse, Screen
mousegetpos, 	Xc,	   Yc,
CoordMode,  	Mouse, Window
win_move(TipHandle, Xc-125, Yc-125,"","") 
return

Butt_Go:	
settimer, Coord_get, Off
WinGetActiveStats, Title, Wi, Hi, Xi, Yi
if (title 		 = 	"") {
	ParentX 	:= 	ParentX -20
	if  Parenty	>	100
		Parenty :=	Parenty +5
} else {
	if (title 	 	 =	"Mouse Properties") {
		ParentX 	:=	ParentX - 24 
		if  Parenty	 >	25
			Parenty :=	Parenty - 37
	} else {
		ParentX 	:=	ParentX - 30
		if  Parenty	 >	25
			Parenty :=	Parenty - 40
}	}
xx:= ("X" . ParentX), yy:= ("Y" . ParentY)
Gui, +LastFound +ToolWindow +AlwaysOnTop -Caption -Border HWNDGui_Hwnd +E0x00080000
Gui -DPIScale 
DllCall("SetParent", "uint", Gui_Hwnd, "uint", Parent_Hwnd)
Gui, Font, % Butt_FontSz, %Butt_Font%	;Gui, Margin, 0, 0
Gui, Add, Button, xp yp Default gButt, % Butt_Txt
Gui, Show, %xx% %yy%, Child_Butt
settimer, move_tt, Off
settimer, ToolOff, 	-1
1stclick := False
;RestoreCursor()
return

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return
