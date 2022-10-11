#NoEnv  ; (MW:2022) (MW:2022)
#NoTrayIcon
#SingleInstance		off
ListLines,			off
SetTitleMatchMode,	2
SetTitleMatchMode,	Slow
Setworkingdir,% (splitpath(A_AhkPath)).dir
coordmode,	Mouse,	Screen
MouseGetpos,,,Mouse_hWnd,Mouse_ClassNN
(!(%0%=0))? inPath:= (File_in:= A_Args[1]) : quit("NoArgz")
  fil3:= SplitPath(File_in), Target:= (fil3.dir . "\" . fil3.FN . ".jpg")
 (Fil3.ext="JPG"? qual:= "quality 80 " : qual:= "quality 93 ")
  FileGetTime,d8,%1%,M
 _Temp:= ("c:\out\output\" . A_TickCount . ".jpg")
msgb0x("Image2_JPG","Overwrite?:`n(" fil3.fn "." fil3.ext ")","",3,True,"C:\Icon\5383.ico")
IfMsgBox,Cancel
	exitApp,
magick:= "magick"	;	Add EnvvAR imagemagick inst-dir
  mulu:= (magick " convert " quote(inPath) " -format jpg -" qual quote(_Temp))
, sleep(200)

Run(mulu,"","","",wait:=True), sleep(40)

IfMsgBox,Yes
	filemove,% File_in,% Target,1

fileMove,%	_Temp,% Target,1
errorlevel?	msgb0x("err",4):()
while !fileexist(Target)
	sleep,100

fileExist(Target)? InvokeVerb(Target,"Cut")
FileSetTime,%d8%,%Target%,M
;ControlSend,%Mouse_ClassNN%,{f5},ahk_id %Mouse_hWnd% ; always incorrect lol
trayTip,% "Image 2 JPG",% "JPG created & in Clipboard.`nOriginal ReCycled",33,1
sleep,2000
exitApp,