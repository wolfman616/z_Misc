#noEnv 
#SingleInstance, Force
sendMode,        Input
setWorkingDir,%  a_scriptDir
#KeyHistory,     0
ListLines,       Off
SetBatchLines,  -1
SetMouseDelay,  -1
SetWinDelay,   -1
CoordMode, Mouse, Screen
;SetControlDelay, -1
;SetKeyDelay, -1, -1
;***************************************************************************************************
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard
;***************************************************************************************************
#Include <gdi+_all>  ;<------       Replace with your copy of GDIP
#Include <LayeredWindow>  ;<------  Layered window lib
;***************************************************************************************************
global curhilite, Trailz_enabled, CUR_FX_Enabled
curhilite        :=  TRue
Trailz_enabled   :=  TRue
OnExit,          GuiClose
settimer,        BALLZ, -1
;*************************END**************************************************************************

#c::
BALLZ:
if !CUR_FX_Enabled
	  setTimer, CUR_FX_Enable,  -1
else, setTimer, CUR_FX_Disable, -1
return,

GuiClose:
MainWindow.DeleteWindow( TurnOffGdip := 1 )
mainwindow := ""
ExitApp

highlighttimer:
MouseGetPos,tx,ty
MainWindow.ClearWindow()
if curhilite
Gdip_FillEllipse(MainWindow.G, BrshCurHighLight , tx-20, ty-20 , 40, 40)
if Trailz_enabled
	Loop, % Circles.Length()
		(Circles[A_Index].Move(tx,ty))?((Circles[A_Index].Active)?(Circles[A_Index].Draw()))
MainWindow.UpdateWindow()
return,
	
class Circle {
	__New(x,y,pGraphics,Brush){
		This.D := This._Random(3,15)
		This.Position := New HB_Vector(x - This.D *0.5, y - This.D *0.5)		;~ This.Speed := This._Random(10.00,20.00)
		This.Speed := This._Random(20.00,40.00)		;~ This.Speed := This._Random(5.00,20.00)
		This.Acc := New HB_Vector()
		This.Target := New HB_Vector()
		This.Graphics := pGraphics
		This.Brush := Brush
		This.Distance := 0
		This._SetTarget( x, y)
	}
	Draw(){
		Gdip_FillEllipse(This.Graphics, This.Brush, This.Position.X, This.Position.Y, This.D, This.D)
	}
	_SetTarget(tx,ty){
		local dist 
		This.Target := ""
		if(This.LastTX=tx&&This.LastTY=ty){
			This.Position.X := tx - (This.D*0.5) 
			This.Position.Y := ty - (This.D*0.5)
			This.Active := 0
			return
		}
		This.Active := 1
		This.LastTX := tx
		This.LastTY := ty
		This.Target := New HB_Vector(tx-(This.D *0.5),ty-( This.D *0.5))
		dist := This.Position.dist(This.Target)
		This.Distance := dist / This.Speed
	}
	Move(tx,ty){
		if(--This.Distance>0){
			This.Acc.X := This.Target.X 
			This.Acc.Y := This.Target.Y
			This.Acc.Sub(This.Position)
			This.Acc.SetMag(This.Speed)
			This.Position.Add(This.Acc)
		}else{
			This._SetTarget(tx,ty)
		}
		return 1
	}
	_Random(Min,Max){
		local Out
		Random,Out,Min,Max
		return Out
	}
}
Class HB_Vector	{
	__New(x:=0,y:=0){
		This.X:=x
		This.Y:=y
	}
	Add(Other_HB_Vector){
		This.X+=Other_HB_Vector.X
		This.Y+=Other_HB_Vector.Y
	}
	Sub(Other_HB_Vector){
		This.X-=Other_HB_Vector.X
		This.Y-=Other_HB_Vector.Y
	}
	mag(){
		return Sqrt(This.X*This.X + This.Y*This.Y)
	}
	magsq(){
		return This.Mag()**2
	}	
	setMag(in1){
		m:=This.Mag()
		This.X := This.X * in1/m
		This.Y := This.Y * in1/m
		return This
	}
	mult(in1,in2:="",in3:="",in4:="",in5:=""){
		if(IsObject(in1)&&in2=""){
			This.X*=In1.X 
			This.Y*=In1.Y 
		}else if(!IsObject(In1)&&In2=""){
			This.X*=In1
			This.Y*=In1
		}else if(!IsObject(In1)&&IsObject(In2)){
			This.X*=In1*In2.X
			This.Y*=In1*In2.Y
		}else if(IsObject(In1)&&IsObject(In2)){
			This.X*=In1.X*In2.X
			This.Y*=In1.Y*In2.Y
		}	
	}
	div(in1,in2:="",in3:="",in4:="",in5:=""){
		if(IsObject(in1)&&in2=""){
			This.X/=In1.X 
			This.Y/=In1.Y 
		}else if(!IsObject(In1)&&In2=""){
			This.X/=In1
			This.Y/=In1
		}else if(!IsObject(In1)&&IsObject(In2)){
			This.X/=In1/In2.X
			This.Y/=In1/In2.Y
		}else if(IsObject(In1)&&IsObject(In2)){
			This.X/=In1.X/In2.X
			This.Y/=In1.Y/In2.Y
		}	
	}
	dist(in1){
		return Sqrt(((This.X-In1.X)**2) + ((This.Y-In1.Y)**2))
	}
	dot(in1){
		return (This.X*in1.X)+(This.Y*In1.Y)
	}
	cross(in1){
		return This.X*In1.Y-This.Y*In1.X
	}
	Norm(){
		m:=This.Mag()
		This.X/=m
		This.Y/=m
	}
}
return,

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return

CUR_FX_Enable:
MainWindow := New LayeredWindow(x := -1 , y := -1 , w := A_ScreenWidth+1 , h := A_ScreenHeight+1 , window := 1 , title := "MIDI" , smoothing := 2 , options := "+AlwaysOnTop -Caption +toolwindow +owner -SysMenu +AlwaysOnTop -DPIScale +E0x08000020" , autoShow := 1 , GdipStart := 1)
;~ Brush := Gdip_BrushCreateSolid("0x2200FF00")
BrshTrailz        :=  Gdip_BrushCreateSolid("0x338800ff")
BrshCurHighLight  :=  Gdip_BrushCreateSolid("0x7700aaff")
MouseGetPos, x, y
Circles := []
if Trailz_enabled
	loop, 50
		Circles[A_Index] := New Circle(x,y,MainWindow.G,BrshTrailz)
gui, 1: +LastFound +Hwndmousetracker  +E0x08000020 -Caption -DPIScale +toolwindow +owner -SysMenu
sleep, 10
gui, 1:Show, noactivate, midi
gui, 1: +LastFound +Hwndmousetracker  +E0x08080020 -Caption -DPIScale +owner -SysMenu
CUR_FX_Enabled := true	
setTimer, highlighttimer, 16
return,
	
CUR_FX_Disable:
gui, 1:hide,
setTimer, highlighttimer, off
gui, 1:destroy
MainWindow.DeleteWindow( TurnOffGdip := 1 )
mainwindow:=
CUR_FX_Enabled := False
return,
