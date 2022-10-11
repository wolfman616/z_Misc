2jpg(File_in, File_Out="", PreserveDate=True, 2clip=True) {
	ListLines,Off
	coordmode,Mouse,Screen
	MouseGetpos,,,Mouse_hWnd,Mouse_ClassNN
	fil3:= SplitPath( File_in )
	(Fil3.ext="JPG"? qual:= "quality 80 " : qual:= "quality 93 ")
	FileGetTime,d8,%1%,M
	_Temp:= ("c:\out\output\" . A_TickCount . ".jpg")
	(!File_Out? msgb0x("Image2_JPG","Overwrite?:`n(" fil3.fn "." fil3.ext ")","",3,True,"C:\Icon\5383.ico")
	, File_Out:= (fil3.dir . "\" . fil3.FN . ".jpg"), ow:= True)
	IfMsgBox,Cancel
		return,
	  mulu:= ("magick convert " quote(File_in) " -format jpg -" qual quote(_Temp))
	, sleep(200)

	run(mulu,"","","",wait:=True), sleep(40)
	if ow
	or IfMsgBox,Yes
		filemove,% File_in,% File_Out,1

	fileMove,%	_Temp,% File_Out,1
	errorlevel?	msgb0x("err",4):()
	while !fileexist(File_Out)
		sleep,100
	(2clip? (fileExist(File_Out)? InvokeVerb(File_Out,"Cut")))
	if PreserveDate
		FileSetTime,%d8%,%File_Out%,M
}