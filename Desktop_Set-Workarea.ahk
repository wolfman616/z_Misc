#persistent
#noenv
#SingleInstance force
;#Include <_Struct>

onexit, xit
;global _RECT   :=  "left,top,right,bottom"
;global Srekt   :=  new _Struct(_RECT) 
VarSetCapacity(Srekt, 16)
success :=  DllCall("SystemParametersInfo", "uint", 0x0030, "uint", 0, "uint", &Srekt, "uint", 0 )
vWinX   :=  NumGet(&Srekt,   0, "Int")
vWinY   :=  NumGet(&Srekt,   4, "Int")
vWinR   :=  NumGet(&Srekt,   8, "Int")
vWinB   :=  NumGet(&Srekt,  12, "Int")
if (vWinY != 54){
	exitapp,
		;or
	msgbox,% "Taskbar is non-standard height %vWinY$.`nAre you sure?"
	ifmsgbox, cancel 
		exit,
}
;MsgBox, % Format("x{} y{} w{} h{}",vWinX,vWinY,vWinr,vWinb)
NumPut((vWinb-5),&Srekt, 12, "Int") ; leaving margin 
NumPut((vWinR-3),&Srekt,  8, "Int") 
NumPut((vWinY+4),&Srekt,  4, "Int")  
NumPut((vWinX+7),&Srekt,  0, "Int") 
success := DllCall("SystemParametersInfo", "uint", 0x002F, "uint", 0, "uint", &Srekt, "uint", SPIF_SENDCHANGE )
settimer xit, -2000
return,

if !(%1%="reset")
	return,
reset:
NumPut(0,&Srekt,    0, "Int")
NumPut(54,&Srekt,   4, "Int") 				
NumPut(3840,&Srekt, 8, "Int") 				
NumPut(1200,&Srekt, 12, "Int")
success := DllCall("SystemParametersInfo", "uint", 0x002F, "uint", 0, "uint", Srekt, "uint", SPIF_SENDCHANGE )
return,

xit:
DllCall("MinHook\MH_Uninitialize")
exitapp