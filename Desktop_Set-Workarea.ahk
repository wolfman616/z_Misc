#SingleInstance force
#Include <_Struct>
_RECT:="left,top,right,bottom"
global Srekt:=new _Struct(_RECT) 
success := DllCall( "SystemParametersInfo", "uint", 0x0030, "uint", 0, "uint", &Srekt, "uint", 0 )
sleep 500
vWinX := NumGet(&Srekt, 0, "Int")
vWinY := NumGet(&Srekt, 4, "Int")
vWinR := NumGet(&Srekt, 8, "Int")
vWinB := NumGet(&Srekt, 12, "Int")
vWinW := vWinR - vWinX
vWinH := vWinB - vWinY
MsgBox, % Format("x{} y{} w{} h{}", vWinX, vWinY, vWinW, vWinH)
NumPut(1150,&Srekt, 12, "Int") ; set the bottom margins y coord to 50 less than Yres
success := DllCall( "SystemParametersInfo", "uint", 0x002F, "uint", 0, "uint", &Srekt, "uint", SPIF_SENDCHANGE )
return,