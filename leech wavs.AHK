#singleinstance force
SetTitleMatchMode, 2
#persistent on
SendMode Input  
SetWorkingDir %A_ScriptDir%
coordmode tooltip, screen
global Matched_String:="",global p,global name2,global Link_Match:=
WAV_Index:= 0, p := 1, yyy :=1,
NeedleWav:="i)(https:\/\/[a-z\d-]+[\\\/\w \.-]*\/?[a-z\s\w\d_'-]*\.wav)"
sURL=% clipboard
surlA=%sURL%
SplitPath, sURLa, namex, dirx, extx, name_no_extx, drivex
Folder_Name:="s:\IN\_WAV"
FileCreateDir, %Folder_Name%\%a_now%
F1=%Folder_Name%\%a_now%.txt
SplitPath, sURL, name, dir, ext, name_no_ext, drive
Fileread, HTML_Data, %F1%
if errorlevel
	{
	urldownloadtoFile,%surl%,%f1%
	if errorlevel
		{			
		tooltip ERROR %error%`n%sURL%,4000,4000
		Filedelete %F1%
		SetTimer Tooloff, -5000
		exit
		}
	Fileread, HTML_Data, %f1%
	Filedelete %f1%
	p:= 1,	Matched_String:= ""
	while p := RegExMatch(HTML_Data, NeedleWav, Matched_String, p + StrLen(Matched_String)) {
	FoundWav:=1,	WAV_Index := WAV_Index + 1, p := p + StrLen(Matched_String), Link_Match := StrReplace(Matched_String, "\" , "")		
	SplitPath, Link_Match, name2, dir2, ext2, name_no_ext2, drive2
	name2:=StrReplace(name2, "/","")		;name2:=regexreplace(name2, "\/","")
	File_Name=%Link_Match%
	urldownloadtoFile,%Link_Match%,%Folder_Name%\%name2%
	sleep 300
	}
tooltip,% "Wav Leech Operation Success`nFiles:" WAV_Index "`nDownloaded to" Folder_Name,4000,4000 
SetTimer Tooloff, -5000
Exit  
}		

Tooloff:
Tooltip,
return
