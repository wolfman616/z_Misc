; call from context menu to toggle copy and paste of date info the latter if date info is present in clipboard from a prior call
;#NoEnv 
SetWorkingDir %a_scriptdir%
#persistent
#singleinstance force
menu, tray, icon, pic2icon.ico
s:=1
D8_TARGET=%a_scriptdir%\D8_2_Cpy
Match_Pos:=1, Match_Result:=""
fileread D8_2_Cpy, %a_scriptdir%\D8_2_Cpy
while Match_Pos := regexmatch(D8_2_Cpy, "[0-9]{14}", Match_Result, Match_Pos)
	{
	if fileexist(D8_TARGET)
		{
		Sleep 100
		Offset:=strlen(Match_Result)
		Match_Pos:= Match_Pos + Offset
args =%0%
itemCnt:= args -2
		loop %itemCnt%
			{
			sout:=%S%
			FileSetTime, %Match_Result%, %Sout%, m
			s:=s+1
			}
	
		traytip, File DateModified , Amended
		filedelete %D8_TARGET%
		exit
	}	}
if 0>1
	{
	trayTip, File DateModified, Multiple files selected.  ; not implemented due to the way windows is passing one parameter per call per file
	exitapp
	}
else
	;get_date:
	splitpath 1, inFileName, inDir, inExtension, inNameNoExt, inDrive
	FileGetTime, DateModified1 , %1%, m
if fileexist(D8_2_Cpy)
exit
else
	fileAppend  %DateModified1%	, D8_2_Cpy
	traytip, File DateModified, Copied Date
	exit




