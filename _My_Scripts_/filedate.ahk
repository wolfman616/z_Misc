; call from context menu to toggle copy and paste of date info the latter if date info is present in clipboard from a prior call
#SingleInstance Force
#NoEnv 
;#Persistent
SetWorkingDir %a_scriptdir%
Menu_ICO:="C:\Icon\20\dna 2.ico", Copy_Ico:="C:\Icon\20\copy.ico,0", Paste_ICO:="C:\Icon\20\paste.ico,0", Match_Pos:=1, Match_Result:="", s:=1
D8_TARGET=%a_scriptdir%\D8_2_Cpy
Menu, Tray, Icon, %Menu_ICO%
FileRead, D8_2_Cpy, %D8_TARGET%
While Match_Pos := RegExMatch(D8_2_Cpy, "[0-9]{14}", Match_Result, Match_Pos)	{
	iF (FileExist(D8_TARGET)) {	
		FileGetTime, Old_D8 , %1%, m
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Classes\AllFilesystemObjects\shell\z99 File Admin\shell\copyPaste_mod_date, muiverb, Copy DateModified,
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Classes\AllFilesystemObjects\shell\z99 File Admin\shell\copyPaste_mod_date, Icon, %Copy_Ico%,
		Offset:=StrLen(Match_Result), SOut:=%S%,Match_Pos:= Match_Pos + Offset
		FileSetTime, %Match_Result%, %Sout%, m
		if ErrorLevel
			TrayTip, File DateModified, Error Setting Date - File may be in use 
		Else {
			s:=s+1
			FormatTime, Old_D8 , %Old_D8%
			FormatTime, New_D8 , %Match_Result%
			iniWrite, >%New_D8%  , filedate_hist.ini , %1%, %Old_D8%   
			TrayTip, File DateModified, %New_D8% `n              was`n%Old_D8%
		}
		FileDelete %D8_TARGET%
		ExitApp
	}
}	

Get_date:
		SplitPath 1, inFileName, inDir, inExtension, inNameNoExt, inDrive
		FileGetTime, DateModified1 , %1%, m
		iF FileExist(D8_2_Cpy)
			ExitApp
		Else {
			FileAppend  %DateModified1%	, D8_2_Cpy
			iF !ErrorLevel
				{
				TrayTip, File DateModified, Copied Date
				RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Classes\AllFilesystemObjects\shell\z99 File Admin\shell\copyPaste_mod_date, muiverb, Paste DateModified,
				RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Classes\AllFilesystemObjects\shell\z99 File Admin\shell\copyPaste_mod_date, Icon, %Paste_ICO%,
				}
			else
				TrayTip, File DateModified, Error %error%
		exit
		}
