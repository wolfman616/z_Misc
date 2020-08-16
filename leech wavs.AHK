#singleinstance force
SetTitleMatchMode, 2
#persistent on
SendMode Input  
SetWorkingDir %A_ScriptDir%
Global Matched_String:="",Global p,Global name2,Global Link_Match:=
WAV_Index:= 0, p := 1, yyy :=1,
NeedleWav:="i)(https:\/\/[a-z\d-]+[\\\/\w \.-]*\/?[\(\)a-z\s\w\d_'-]*\.wav)"
url=% Clipboard
SplitPath, url, namex, dirx, extx, name_no_extx, drivex
Folder_Name:="s:\IN\_WAV"
FileCreateDir, %Folder_Name%\%a_now%
F1=%Folder_Name%\%a_now%.txt
SplitPath, url, name, dir, ext, name_no_ext, drive
Fileread, HTML_Data, %F1%
if ErrorLevel
	{
	urlDownloadToFile,%url%,%f1%
	if ErrorLevel
		{			
		TrayTip, %Domain%, ERROR %error%`n%url%
		Filedelete %F1%
		exit
		}
	FileRead, HTML_Data, %f1%
	FileDelete %F1%
	p:= 1,	Matched_String:= ""
	While p := RegExMatch(HTML_Data, NeedleWav, Matched_String, p + StrLen(Matched_String)) {
	WAV_Index := WAV_Index + 1, p := p + StrLen(Matched_String), Link_Match := StrReplace(Matched_String, "\" , "")		
	SplitPath, Link_Match, name2, dir2, ext2, name_no_ext2, drive2
	name2:=StrReplace(name2, "/","")		;name2:=regexreplace(name2, "\/","")
	File_Name=%Folder_Name%\%name2%
	if !FileExist File_Name
		urlDownloadtoFile,%Link_Match%,%File_Name%
	sleep 50
	}
TrayTip, %Domain%, % "Wav Leech Operation Success`nFiles:" WAV_Index "`nDownloaded to`n" Folder_Name,4000,4000 
Exit  
}		
