#persistent
#noenv
onexit, xit
VarSetCapacity(Srekt, 16)
if (%1%="reset")
	goto reset
success :=  DllCall("SystemParametersInfo", "uint", 0x0030, "uint", 0, "uint", &Srekt, "uint", 0 )
vWinX   :=  NumGet(&Srekt,   0, "Int")
vWinY   :=  NumGet(&Srekt,   4, "Int")
vWinR   :=  NumGet(&Srekt,   8, "Int")
vWinB   :=  NumGet(&Srekt,  12, "Int")
if (vWinY != 54){ ; my taskbar height at 144 dpi
	exitapp,
		; or
	msgbox,% "Taskbar is non-standard height %vWinY$.`nAre you sure?"
	ifmsgbox, cancel 
		exit,
}
NumPut((vWinb-5),&Srekt, 12, "Int") ; leaving margin 
NumPut((vWinR-3),&Srekt,  8, "Int") 
NumPut((vWinY+4),&Srekt,  4, "Int")  
NumPut((vWinX+7),&Srekt,  0, "Int") 
success := DllCall("SystemParametersInfo", "uint", 0x002F, "uint", 0, "uint", &Srekt, "uint", 0x02 )
settimer xit, -2000
return,

reset:
NumPut(0,&Srekt,    0, "Int")
NumPut(54,&Srekt,   4, "Int") 				
NumPut(3840,&Srekt, 8, "Int") 				
NumPut(1200,&Srekt, 12, "Int")
success := DllCall("SystemParametersInfo", "uint", 0x002F, "uint", 0, "uint", Srekt, "uint", 0x02 )
return,

xit:
DllCall("MinHook\MH_Uninitialize")
exitapp