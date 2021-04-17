#NoEnv 		
#Persistent 		
#singleinstance force
#Include VA.ahk
sendMode Input
;SetBatchLines -1
CoordMode window, screen
SetWorkingDir %A_ScriptDir% 
Menu, Tray, Icon, WMP.ico
Menu, Tray, noStandard
Menu, Tray, Add, Open script folder, Open_script_folder,
Menu, Tray, Add, Restart Windows Media Player, Restart_WMP,
Menu, Tray, Standard

global G3nre, global choice
global S := 1200 ;; Sleep Time (ms)
global newsong
Global Genres:="i)(dnb)|(reggae)|(riddim)|(hiphop)|(garage)|(rock)|(ambient)|(samples)|(my music)|(audiobooks)|(sLSk)|(FOAD)"
Global Needle4:="i)[1234567890.'`)}{(_]|(-khz)(rmx)|(remix)|(mix)|(refix)|(vip)|(featuring)|( feat)|(ft)|(rfl)|(-boss)(-sour)|(its)|(it's)|(-)|(-bpm)|(edit)"
Global Needle2:="i)(\s[a-z]{1,2}\s)", Global Needle3:="( . )|(^[a-z][\s])|(    )|(   )|(  )|[.]"
Global StartPos_Offset:=0, Global StartPos_Offset := 4, Global Search_Root:="", Global Genre:=""
Con_Cat_N_8:="c:\out\temp.txt"
gag=C:\Users\%A_UserName%\anaconda3
if fileexist(gag)
	ANACONDA := True
;VARs::::::::::::;
Stop:=18809, Play:=0x2e0000, Paused:=32808, Prev:=18810, Next:=18811, Vol_Up:=32815, Vol_Down:=32816 ;Paused=18808     
Loop 2
    DllCall( "ChangeWindowMessageFilter", uInt, "0x" (i:=!i?49:233), uint, 1)
sleep, 30
process exist, ahk_exe WMPlayer.exe
if Errorlevel, runwait "C:\Apps\WMPlayer.exe"

WMP := new RemoteWMP
WinTitle=Windows Media Player
sleep, 30
Media := WMP.player.currentMedia
Controls := WMP.player.Controls
trayTip, Windows Media Player, % Media.sourceURL
onexit() {
	fileDelete, %Con_Cat_N_8%
}
;newsong= % Media.sourceURL

;Binds:::::::::::: ::btw::by the way

<^>!q:: 	;	ALTgr + Q  ???
ifWinactive, AHK_Class CabinetWClass || AHK_Class WorkerW
{
	;invoke verb for desktop forgot which one was required
}
return

;		ALTgr + PAGE UP 	; 	Volume Up	
<^>!PgUp::postMessage, 0x111, vol_up, 0, ,%WinTitle% 		
return

;		ALTgr + PAGE UP 	; 	Volume DOWN	
<^>!PgDn::postMessage,  0x111, vol_down, 0, ,%WinTitle% 	; Volume Down	-	;ctrl shift page down
return

<^>!Enter:: 		;	ALTgr + Enter	;	open loc of current file & copy clipboard TITLE and ARTIST info
WMP := new RemoteWMP
Media := WMP.player.currentMedia
UNC = % Media.sourceURL
o:=comobjcreate("Shell.Application")
splitPath,UNC,file,directory,ext
if !errorlevel {
	od:=o.namespace(directory)
	of:=od.parsename(file)
	G3nre:=od.getdetailsof(of,16) ;16 = genre
}
Controls := WMP.player.Controls
splitPath, UNC , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
sleep, 250
1st:= RegExReplace(UNC, "^.+\\|\.[^.]+$")
2nd := RegExReplace(1st,  "[']|[`]|[)]|[(]|[_]|(  )|( )|(YouTube)", " ")
clipboard := RegExReplace(2nd, Needle3, " ") ;"( . )|(    )|(   )|(  )"
run %COMSPEC% /c explorer.exe /select`, "%UNC%",, Hide
sleep %S%
sendInput {F5}
UNC:="", 1st:="", 2nd:=""
return

<^>!i::			;	ALTgr + i
goSub WMP_Copy_Search 	;	Search sLSk and YouTube for current file
return

<^>!s::			;	ALTgr + S
goSub WMP_Copy_Search_explorer 	;	Search file_explorer starting in detected genre location
return

<^>!p::			;	ALTgr + Enter
goSub WMP_add_Playlist 	;	Add to currently building playlist (not current playlist)
return

<^>!Del::			;	ALTgr + Enter
goSub WMP_Del 	;	Delete Current, skip to next
return

<^>!Space::		;	ALTgr + Enter
goSub WMP_Pause 	;	Play Pause
return

<^>!Left::			;	ALTgr + Left Arrow
goSub WMP_Prev 	;	Previous Track
return

<^>!Right::		;	ALTgr + Right Arrow
goSub WMP_Next 	;	Next Track
return

<^>!c::				;	ALTgr + C
wMP := new RemoteWMP
sleep, 20
Media := WMP.player.currentMedia
Controls := WMP.player.Controls
sleep, 20
FullPath:=Media.sourceurl
splitPath, FullPath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
if !Secs2Sample_Start { ;First... get start time 
	if Secs2Sample_Start:=round(controls.currentPosition)
		Sample_start_min:= Floor(Secs2Sample_Start/60) 
	else {
		Secs2Sample_Start:="0" ;  lets set start time 0 when it will not be correctly detected by control.current
		Sample_start_min:= Floor(Secs2Sample_Start/60)
	}
	if Sample_start_Hr:=Floor(Sample_start_min/60)
		Sample_start_min:=Sample_start_min-(Sample_start_Hr*60)
	Sample_start_Sec:=Secs2Sample_Start-(Sample_start_min*60)
} else {
	if Secs2Sample_End:=round(controls.currentPosition)
		Sample_End_min:= Floor(Secs2Sample_End/60)
	if Sample_End_Hr:=Floor(Sample_End_min/60)
		Sample_End_min:=Sample_End_min-(Sample_End_Hr*60)
	Sample_End_Sec:=Secs2Sample_End-(Sample_End_min*60)
	Start_Time=%Sample_start_Hr%:%Sample_start_min%:%Sample_start_Sec%
	End_Time=%Sample_End_Hr%:%Sample_End_min%:%Sample_End_Sec%

	GUI_:
	regRead, DefaultChoice, HKEY_CURRENT_USER\Software\WMP_MATT, extractor default
	c1:="Extract region", c2:="Delete region"
		if ANACONDA {
			c3:="Extract vox", c4:="Extract inst"
			if instr(DefaultChoice,c1) 
				Choices=%c1%||%c2%|%c3%|%c4%
			else if instr(DefaultChoice,c2)
				Choices=%c1%|%c2%||%c3%|%c4%
			else if instr(DefaultChoice,c3)
				Choices=%c1%|%c2%|%c3%||%c4%
			else if instr(DefaultChoice,c4)
				Choices=%c1%|%c2%|%c3%|%c4%|
			else Choices=%c1%||%c2%|%c3%|%c4% 	;	 IF no default is found, Extract region is default
		} else {
			if instr(DefaultChoice,c1) 
				Choices=%c1%||%c2%
			else if instr(DefaultChoice,c2)
				Choices=%c1%|%c2%||
			else Choices=%c1%||%c2%
		}

	gui, Xtract_i:new , , Sampler
	gui +HwndQuestionHwnd
	gui, Add, DropDownList, w82 vChoice, %Choices%
	gui, Add, checkbox, vSave ,save default
	gui, Add, Button,  Default gPerform w80, OK  (Enter)
	gui, Add, Button,  w80 gCancel, Cancel  (Esc)
	gui, Show , Center, Sampler	
	OnMessage(0x200, "Help")
	setTimer Icon_Alternate, 800
	return

	Help(wParam, lParam, Msg) {
		MouseGetPos,,,, OutputVarControl
		if !OutputVarControlold
			OutputVarControlold=%OutputVarControl%
		IfEqual, OutputVarControl, Button3 
		{
			if OutputVarControlold != OutputVarControl
			toolTip ... Pick endpoint again`nOr Close window (x)`nto reset start position
			OutputVarControlold=%OutputVarControl%
		} else {
			sleep % S
			tooltip
		}
	}

	~escape:: 
	ifWinactive ahk_id %HwndQuestionHwnd%
		gosub cancel
	return

	Xtract_GuiClose:
	gui, Destroy
	setTimer Icon_Alternate, off
	gosub Cleanup_xtract
	return

	Cleanup_xtract:
	Secs2Sample_End := "", Secs2Sample_Start := "", Output_Filename_Full := "", inputfilename := "", Output_Prefix := "", choice := ""
	return

	Cancel:
	gui, Destroy
	return

	Perform:
	global needL := "i)(?:Extracted)(?:[ ])[0-9]"
	gui, Submit
	gui, Destroy 
	inichoice := choice
	if Save 
		RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, Extractor Default, %choice%
	Secs2Sample_Start :=
	If choice = Extract region
		process_Action:="-t", process_Type:="Extracted"
	If Choice = Delete region
		process_Action:="-to", process_Type:="Trimmed"
	Output_Prefix=%OutNameNoExt% - %process_Type%
	Output_Filename_Full=%OutDir%\%Output_Prefix%.%OutExtension%

	File_Numbering:
	if ( n := fileexist( Output_Filename_Full ) ) {
		n := 1, RegXPos := 1, Match:=
		while RegXPos := regexmatch(Output_Prefix, needL, Match, RegXPos) {
			File_Num := Match
			RegXPos = 666
		}
		if !File_Num
			File_Num:=1
		else 
			File_Num := File_Num + 1
		Output_Filename_Full=%OutDir%\%Output_Prefix% %File_Num%.%OutExtension%
	} else
		Output_Filename_Full=%OutDir%\%Output_Prefix%.%OutExtension%
	if FileExist(Output_Filename_Full) { ; Check_Folder
		splitPath, Output_Filename_Full , , , , Output_Prefix
		goto File_Numbering
		return
	}
	Output_Prefix=%Output_Prefix% %File_Num%

	If (choice = "Delete region") {
		SecsDuration:=round(media.getItemInfo("Duration"))
		Sample_Duration_min:= Floor(SecsDuration/60)
		if Sample_Duration_Hr:=Floor(Sample_Duration_min/60)
			Sample_Duration_min:=Sample_Duration_min-(Sample_Duration_Hr*60)
		Sample_Duration_Sec:=SecsDuration-(Sample_Duration_min*60)
		Output_Duration=%Sample_Duration_Hr%:%Sample_Duration_min%:%Sample_Duration_Sec%
		FirstHalf=%OutDir%\%OutNameNoExt% - Trimmed first half.%OutExtension%
		SecondHalf=%OutDir%\%OutNameNoExt% - Trimmed 2nd half.%OutExtension%
		runWait, %comspec% /c ffmpeg -i "%FullPath%" -ss 0:0:0 -to %Start_Time% -c:v copy -c:a copy "%FirstHalf%",,hidden
		runWait, %comspec% /c ffmpeg -i "%FullPath%" -ss %End_Time% -to %Output_Duration% -c:v copy -c:a copy "%SecondHalf%",,hidden
		FileAppend , file '%FirstHalf%'`n, %Con_Cat_N_8%
		FileAppend , file '%SecondHalf%'`n, %Con_Cat_N_8%
		sleep 1500
		if instr(OutNameNoExt, "Trimmed")
			Output_Filename_Full=%OutDir%\%OutNameNoExt%.%OutExtension%
		else
			Output_Filename_Full=%OutDir%\%OutNameNoExt% - Trimmed.%OutExtension%
		runWait, %comspec% /c ffmpeg -y -f concat -safe 0 -i "%Con_Cat_N_8%" -c copy "%Output_Filename_Full%",,hidden
		fileDelete, %FirstHalf%
		fileDelete, %SecondHalf%
		fileDelete, %Con_Cat_N_8%
		fileGetTime, Old_D8 , %FullPath%, m
		fileSetTime, Old_D8 , %Output_Filename_Full%, m
		;FileRecycle, %FullPath%
		Check_Output:
		sleep 500
		if !fileExist(FullPath)
			fileMove, Output_Filename_Full, FullPath
		else {
			if !tried
				tried = 1
			else
				tried := tried+1
			goto Check_Output
		}
		exit
	} else {
		A:="", B:=""
		A=%Start_Time%
		B=%End_Time%
		runWait, %comspec% /c ffmpeg -i "%FullPath%" -ss %A% %Process_Action% %B% -c:v copy -c:a copy "%Output_Filename_Full%",,hidden
	msgbox ffmpeg -i "%FullPath%" -ss %A% %Process_Action% %B% 
		if NewEnc {
			msgbox, FFMPEG Encode section wip ;encode
			return
		} 
	}
	if ( choice = "Extract vox" || choice = "Extract inst" ) {
		run, conda run spleeter separate "%Output_Filename_Full%",,hidden
		winWaitActive, ahk_exe conda.exe
		winHide, ahk_exe conda.exe
		inputfilename=%Output_Filename_Full%
		if (choice="Extract vox") { 		
			Main_Result_WAV=C:\Users\%A_UserName%\AppData\Local\Temp\separated_audio\%Output_Prefix%\vocals.wav		
			Output_Filename_Full=%OutDir%\%Output_Prefix% - Voice.wav
		;	if !raw
		;		msgbox do encode
		;	else {
				Check_Output_2:
				if !fileexist(Main_Result_WAV) { ; check spleeter files have appeared
					sleep % S
					goto Check_Output_2
				} else {
					msgbox, %Main_Result_WAV%  exist 
				}
				fileMove %Main_Result_WAV%, %Output_Filename_Full%
				if errorlevel, msgbox %errorlevel% 
				Check_Output_Moved:
				if !fileexist(Output_Filename_Full) { ; check if previous move has occurred
					sleep % S		
					goto Check_Output_Moved
				}				
				fileDelete, %inputfilename% ; remove temp output file
				fileRemoveDir, C:\Users\%A_UserName%\AppData\Local\Temp\separated_audio\%Output_Prefix%
		;	}
		} else 
		if (choice="Extract Music") {		
			Main_Result_WAV=C:\Users\%A_UserName%\AppData\Local\Temp\separated_audio\%Output_Prefix%\accompaniment.wav
		;		if !raw {
		;			msgbox do encode
		;			return
		; } else {
			Output_Filename_Full=%OutDir%\%OutNameNoExt% - Music Content of Extracted.wav
			fileMove, Main_Result_WAV, Output_Filename_Full
			fileRecycle, inputfilename
			fileRemoveDir, C:\Users\%A_UserName%\AppData\Local\Temp\separated_audio\%Output_Prefix%
		;	}
		}
	}

	Attempt_Cut:
	ttt =% clipboard
	Aa_C:
	if fileexist(Output_Filename_Full) {
		if (InvokeVerb(Output_Filename_Full, "Cut", True)) {
			if clipboard = ttt
			{
				goto Aa_C
			} else
				tooltip
		} else {
			sleep, % S
			goto Attempt_Cut
		}
		goSub Cleanup_xtract
		gui, Destroy
		return
	}
	if !fileexist(Output_Filename_Full) {
		sleep 500
		goto aa_C
	}
	return

}
return
<^>!x::		;altGr x  
Path2File:=Media.sourceURL
if InvokeVerb(Path2File, "Cut")
{ 
    process,Exist
    hwnd:=WinExist("ahk_class tooltips_class32 ahk_pid " Errorlevel)
} 
Menu, Tray, Icon, copy.ico
Monster_Clip=%clipboard%
setTimer Clip_Commander, -1000
return

WMP_Pause:
	process, Exist, WMPlayer.exe
	ifWinNotExist, Windows Media Player
		trayTip, Windows Media Player, process found but window Not,3000,2
	else
		postMessage, 0x111, Paused, 0, ,%WinTitle%
	return

WMP_Prev:
process, Exist, WMPlayer.exe
ifWinNotExist, Windows Media Player
	trayTip, Windows Media Player, process found but window Not,3000,2
else
	{
	postMessage, 0x111, Stop, 0, ,%WinTitle%
	sleep, 50
	postMessage, 0x111, Prev, 0, ,%WinTitle%
	sleep, 50
	; WMP := new RemoteWMP
	; Media := WMP.player.currentMedia
	; Controls := WMP.player.Controls
	thecall2:
	goSub WMP_Refresh_2
	if newsong =% oldsong
		{
		;tooltip, newsong = oldsong
		sleep, 100
		goSub thecall2
		}
	else
		{
		WMP.jump(StartPos_Offset)
		sleep, 350
		postMessage, 0x319, 0, Play, ,%WinTitle%
		return
		}
	return
	}
return

/* 
youtube_next:
sendinput, {Media_Next}, chrome
 */

WMP_NEXT:
genre:=
G3nre:=
process, Exist, WMPlayer.exe
ifWinNotExist, Windows Media Player
{
	trayTip, Windows Media Player, process found but window Not,3000,2
	return
} else {
	oldsong =% newsong
	newsong:=
	postMessage, 0x111, Stop, 0, ,%WinTitle%
	sleep, 50
	postMessage, 0x111, Next, 0, ,%WinTitle%
	sleep, 50
	thecall1:
	goSub WMP_Refresh_2
	if newsong =% oldsong
	{
		trayTip Windows Media Player, End of Playlist		
		;tooltip, newsong = oldsong
		exit
	} else {
		goSub Genre_Search
		WMP.jump(StartPos_Offset)
		sleep, 101
		postMessage, 0x319, 0, Play, ,%WinTitle%
	}
	return
}
return

WMP_Copy_Search:
WMP := new RemoteWMP
sleep, 20
Media := WMP.player.currentMedia
Controls := WMP.player.Controls
sleep, 20
FullPath:=Media.sourceurl
sleep, 20
FullPath= % Media.sourceURL
process, Exist, slsk2.exe
     if !ErrorLevel
		{
		trayTip, Windows Media Player,, error slsk not open
	} else {
		splitPath, FullPath,  , , , OutNameNoExt
		1st:= RegExReplace(OutNameNoExt,Needle4, " ")
		2nd:= RegExReplace(1st,Needle2, " ")
		run "C:\script\AHK\Working\slsk fix.ahk"	
		mouseGetPos, orig_x, orig_y
		sleep, 1500	
		winGetPos,,, Width, Height, %WinTitle%
		sleep, 500
		;WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (1400/2)-(400/2)
		mouseMove, 145, 90,,
		send {LButton}
		send % Stripped_Name := RegExReplace(2nd, Needle3, " ")
		send {Enter}
		mouseMove, 1453, 243,,
		send {LButton}
		mouseMove, orig_x, orig_y, 
		clipboard:=Stripped_Name
		return
		}
return

WMP_Copy_Search_explorer:
goSub WMP_Refresh_2
goSub Genre_Search
trayTip, Windows Media Player, path
FullPath=%newsong%
splitPath, FullPath,  , , , OutNameNoExt
1st:= regExReplace(OutNameNoExt,Needle4, " ")
2nd:= regExReplace(1st,Needle2, " ")
run explorer.exe %Search_Root%
winWaitActive, ahk_exe explorer.exe, , 5
sleep, 1000
sendinput ^f
sleep, 1500
send % Stripped_Name := RegExReplace(2nd, "( . )|(^[a-z][\s])|(    )|(   )|(  )|[.]", " ")
sleep, 500
sendinput {enter}
	;send {enter}
	;mouseMove, 1421, 243,,
	;send {LButton}
	;mouseMove, orig_x, orig_y, 
	;clipboard:=3rd
return

Genre_Search:
p := 1, Matched_String := "",	genre := ""
o:=comobjcreate("Shell.Application")
splitPath,newsong,file,directory,ext
od:=o.namespace(directory)
of:=od.parsename(file)
G3nre:=od.getdetailsof(of,16)
while p := RegExMatch(newsong, Genres, Matched_String, p + StrLen(Matched_String)) {
	if Matched_String=dnb
		StartPos_Offset:=86, p:=999, Genre:="dnb", Search_Root:="S:\- DNB"
	else if Matched_String=reggae
		StartPos_Offset:=14, p:=999, Genre:="reggae", Search_Root:="S:\- REGGAE"
	else if Matched_String=riddim
		StartPos_Offset:=14, p:=999, Genre:="riddim", Search_Root:="S:\- REGGAE"
	else if Matched_String=hiphop
		StartPos_Offset:=17, p:=999, Genre:="hiphop", Search_Root:="S:\- HIPHOP"
	else if Matched_String=garage
		StartPos_Offset:=45, p:=999, Genre:="garage", Search_Root:="S:\- - MP3 -\Garage"
	else if Matched_String=rock
		StartPos_Offset:=17, p:=999, Genre:="rock", Search_Root:="S:\- - MP3 -\- Other\Rock"
	else if Matched_String=ambient
		StartPos_Offset:=30, p:=999, Genre:="ambient", Search_Root:="S:\- - MP3 -\Chill"
	else if Matched_String=samples
		StartPos_Offset:=0, p:=999, Genre:="samples", Search_Root:="S:\Samples"
	else if Matched_String=my music
		StartPos_Offset:=0, p:=999, Genre:="my music", Search_Root:="S:\Documents\My Music"
	else if Matched_String=audiobooks
		StartPos_Offset:=0, p:=999, Genre:="audiobooks", Search_Root:="S:\Documents\My Audio"
	else if Matched_String=_SLSK_
		StartPos_Offset:=45, p:=999, Genre:="sLSk"
	else if Matched_String=FOAD
		StartPos_Offset:=0, p:=999, Genre:=""
	if (g3nre="dnb") || (g3nre="drum & bass") || (g3nre="drum&bass") || (g3nre="drum n bass") 
		StartPos_Offset:=86, p:=999, Genre:="dnb", Search_Root:="S:\- DNB", faggot:=1
	else if (g3nre="Reggae") || (g3nre="Dancehall") || (g3nre="Ragge") || (g3nre="Riddim") 
		StartPos_Offset:=14, p:=999, Genre:="reggae", Search_Root:="S:\- REGGAE", faggot:=1
	else if (g3nre="Hip-Hop") || (g3nre="HipHop") || (g3nre="Rap") || (g3nre="Gangster Rap") 
		StartPos_Offset:=17, p:=999, Genre:="hiphop", Search_Root:="S:\- HIPHOP", faggot:=1
	else if (g3nre="Garage") || (g3nre="2 Step") || (g3nre="Bassline")
		StartPos_Offset:=45, p:=999, Genre:="garage", Search_Root:="S:\- - MP3 -\Garage", faggot:=1
	else if (g3nre="Rock") || (g3nre="Rock n Roll") || (g3nre="Metal")
		StartPos_Offset:=17, p:=999, Genre:="rock", Search_Root:="S:\- - MP3 -\- Other\Rock", faggot:=1
	else if (g3nre="Ambient") || (g3nre="Chill Out")
		StartPos_Offset:=30, p:=999, Genre:="ambient", Search_Root:="S:\- - MP3 -\Chill", faggot:=1
	else if (g3nre="Spoken Word") || (g3nre="Audiobook")
		StartPos_Offset:=0, p:=999, Genre:="audiobooks", Search_Root:="S:\Documents\My Audio", faggot:=1
	if !genre || !faggot
		msgBox no genre 
	}
return

WMP_Refresh: 
WMP := new RemoteWMP
Media := WMP.player.currentMedia
Controls := WMP.player.Controls
return

WMP_Refresh_2:
sleep, 200
goSub WMP_refresh
sleep, 200
newsong = % Media.sourceURL
sleep, 200
return

WMP_Del: 
process, Exist, WMPlayer.exe
WMP2del := new RemoteWMP
sleep, 300
Media2del := WMP2del.player.currentMedia
goSub WMP_next
setTimer, DELETE_, -1000
return

DELETE_:   
try 
	File2Del= % Media2del.sourceURL
catch
	goSub WMP_Del
FileRecycle, % File2Del ;trayTip, Windows Media Player, Deleted %File2Del%, 3, 1

return

WMP_add_Playlist:
WMP := new RemoteWMP
sleep, 20
Media := WMP.player.currentMedia
Controls := WMP.player.Controls
sleep, 20
FullPath:=Media.sourceurl
sleep, 20
if fileexist("New_Playlist.m3u") {
	if !fileexist Playlist.m3u
		fileMove New_Playlist.m3u, Playlist.m3u
	else
		try {
			if !fileexist(Playlist%p00f%.m3u)
				fileMove New_Playlist.m3u, Playlist%p00f%.m3u
	} catch {
			p00f:=p00f+1
		}
} else {
	FileAppend %fullpath%`n, New_Playlist.m3u
}
return

Clip_Commander:
if (clipboard!=Monster_Clip) {
	setTimer Clip_Commander, off
	Menu, Tray, Icon, WMP.ico
}
return

Icon_Alternate:
if !toggler {
	ZZ := "WMP2.ico"
	Menu, Tray, Icon, %ZZ%
	toggler := 1
} else {
	ZZ := "WMP.ico"
	Menu, Tray, Icon, %ZZ%
	toggler := 
}
return

class RemoteWMP {
	__New() {
		static IID_IOleClientSite := "{00000118-0000-0000-C000-000000000046}"
		, IID_IOleObject     := "{00000112-0000-0000-C000-000000000046}"
		process, Exist, WMPlayer.exe
		if !ErrorLevel
			trayTip, Windows Media Player, WMPlayer.exe is not running
		if !this.player := ComObjCreate("WMPlayer.OCX.7")
			trayTip, Windows Media Player, Failed to get WMPlayer.OCX.7 object
		this.rms := IWMPRemoteMediaServices_CreateInstance()
		this.ocs := ComObjQuery(this.rms, IID_IOleClientSite)
		this.ole := ComObjQuery(this.player, IID_IOleObject)
		DllCall(NumGet(NumGet(this.ole+0)+3*A_PtrSize), "Ptr", this.ole, "Ptr", this.ocs)
   }
   	__Delete() {
		if !this.player
			return
		DllCall(NumGet(NumGet(this.ole+0)+3*A_PtrSize), "Ptr", this.ole, "Ptr", 0)
		for k, obj in [this.ole, this.ocs, this.rms]
			ObjRelease(obj)
		this.player := ""
   }
   	Jump(sec) {
		try {
				this.player.Controls.currentPosition += sec
		}
		catch 
		{
			sleep 50
		}
	}
   	TogglePause() {
		if (this.player.playState = 3)  ; Playing = 3
			this.player.Controls.pause()
		else
			this.player.Controls.play()
   }
}

IWMPRemoteMediaServices_CreateInstance() {
   static vtblUnk, vtblRms, vtblIsp, vtblOls, vtblPtrs := 0, size := (A_PtrSize + 4)*4 + 4
   if !VarSetCapacity(vtblUnk) {
      extfuncs := ["QueryInterface", "AddRef", "Release"]

      VarSetCapacity(vtblUnk, extfuncs.Length()*A_PtrSize)

      for i, name in extfuncs
         NumPut(RegisterCallback("IUnknown_" . name), vtblUnk, (i-1)*A_PtrSize)
   }
   if !VarSetCapacity(vtblRms) {
      extfuncs := ["GetServiceType", "GetScriptableObject", "GetCustomUIMode"]

      VarSetCapacity(vtblRms, (3 + extfuncs.Length())*A_PtrSize)
      DllCall("ntdll\RtlMoveMemory", "Ptr", &vtblRms, "Ptr", &vtblUnk, "Ptr", A_PtrSize*3)

      for i, name in extfuncs
         NumPut(RegisterCallback("IWMPRemoteMediaServices_" . name, "Fast"), vtblRms, (2+i)*A_PtrSize)
   }
   if !VarSetCapacity(vtblIsp) {
      VarSetCapacity(vtblIsp, 4*A_PtrSize)
      DllCall("ntdll\RtlMoveMemory", "Ptr", &vtblIsp, "Ptr", &vtblUnk, "Ptr", A_PtrSize*3)
      NumPut(RegisterCallback("IServiceProvider_QueryService", "Fast"), vtblIsp, A_PtrSize*3)
   }
   if !VarSetCapacity(vtblOls) {
      extfuncs := ["SaveObject", "GetMoniker", "GetContainer", "ShowObject", "OnShowWindow", "RequestNewObjectLayout"]
      VarSetCapacity(vtblOls, (3 + extfuncs.Length())*A_PtrSize)
      DllCall("ntdll\RtlMoveMemory", "Ptr", &vtblOls, "Ptr", &vtblUnk, "Ptr", A_PtrSize*3)

      for i, name in extfuncs
         NumPut(RegisterCallback("IOleClientSite_" . name, "Fast"), vtblOls, (2+i)*A_PtrSize)
   }
   if !vtblPtrs
      vtblPtrs := [&vtblUnk, &vtblRms, &vtblIsp, &vtblOls]

   pObj := DllCall("GlobalAlloc", "UInt", 0, "Ptr", size, "Ptr")
   for i, ptr in vtblPtrs {
      off := A_PtrSize*(i - 1) + 4*(i - 1)
      NumPut(ptr, pObj+0, off, "Ptr")
      NumPut(off, pObj+0, off + A_PtrSize, "UInt")
   }
   NumPut(1, pObj+0, size - 4, "UInt")
   return pObj
}

IUnknown_QueryInterface(this_, riid, ppvObject) {
   static IID_IUnknown, IID_IWMPRemoteMediaServices, IID_IServiceProvider, IID_IOleClientSite
   if !VarSetCapacity(IID_IUnknown) {
      VarSetCapacity(IID_IUnknown, 16), VarSetCapacity(IID_IWMPRemoteMediaServices, 16), VarSetCapacity(IID_IServiceProvider, 16), VarSetCapacity(IID_IOleClientSite, 16)
      DllCall("ole32\CLSIDFromString", "WStr", "{00000000-0000-0000-C000-000000000046}", "Ptr", &IID_IUnknown)
      DllCall("ole32\CLSIDFromString", "WStr", "{CBB92747-741F-44FE-AB5B-F1A48F3B2A59}", "Ptr", &IID_IWMPRemoteMediaServices)
      DllCall("ole32\CLSIDFromString", "WStr", "{6d5140c1-7436-11ce-8034-00aa006009fa}", "Ptr", &IID_IServiceProvider)
      DllCall("ole32\CLSIDFromString", "WStr", "{00000118-0000-0000-C000-000000000046}", "Ptr", &IID_IOleClientSite)
   }
   
   if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IUnknown) {
      off := NumGet(this_+0, A_PtrSize, "UInt")
      NumPut(this_ - off, ppvObject+0, "Ptr")
      IUnknown_AddRef(this_)
      return 0 ; S_OK
   }

   if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IWMPRemoteMediaServices) {
      off := NumGet(this_+0, A_PtrSize, "UInt")
      NumPut((this_ - off)+(A_PtrSize + 4), ppvObject+0, "Ptr")
      IUnknown_AddRef(this_)
      return 0 ; S_OK
   }

   if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IServiceProvider) {
      off := NumGet(this_+0, A_PtrSize, "UInt")
      NumPut((this_ - off)+((A_PtrSize + 4)*2), ppvObject+0, "Ptr")
      IUnknown_AddRef(this_)
      return 0 ; S_OK
   }

   if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IOleClientSite) {
      off := NumGet(this_+0, A_PtrSize, "UInt")
      NumPut((this_ - off)+((A_PtrSize + 4)*3), ppvObject+0, "Ptr")
      IUnknown_AddRef(this_)
      return 0 ; S_OK
   }

   NumPut(0, ppvObject+0, "Ptr")
   return 0x80004002 ; E_NOINTERFACE
}

IUnknown_AddRef(this_) {
   off := NumGet(this_+0, A_PtrSize, "UInt")
   iunk := this_-off
   NumPut((_refCount := NumGet(iunk+0, (A_PtrSize + 4)*4, "UInt") + 1), iunk+0, (A_PtrSize + 4)*4, "UInt")
   return _refCount
}

IUnknown_Release(this_) {
   off := NumGet(this_+0, A_PtrSize, "UInt")
   iunk := this_-off
   _refCount := NumGet(iunk+0, (A_PtrSize + 4)*4, "UInt")
   if (_refCount > 0) {
      NumPut(--_refCount, iunk+0, (A_PtrSize + 4)*4, "UInt")
      if (_refCount == 0)
         DllCall("GlobalFree", "Ptr", iunk, "Ptr")
   }
   return _refCount
}

IWMPRemoteMediaServices_GetServiceType(this_, pbstrType) {
   NumPut(DllCall("oleaut32\SysAllocString", "WStr", "Remote", "Ptr"), pbstrType+0, "Ptr")
   return 0
}

IWMPRemoteMediaServices_GetScriptableObject(this_, pbstrName, ppDispatch) {
   return 0x80004001
}

IWMPRemoteMediaServices_GetCustomUIMode(this_, pbstrFile) {
   return 0x80004001
}

IServiceProvider_QueryService(this_, guidService, riid, ppvObject) {
   return IUnknown_QueryInterface(this_, riid, ppvObject)
}
return


InvokeVerb(path, menu, validate=True) {
    objShell := ComObjCreate("Shell.Application")
    if InStr(FileExist(path), "D") || InStr(path, "::{") {
        objFolder := objShell.NameSpace(path)   
        objFolderItem := objFolder.Self
    } else {
        splitPath, path, name, dir
        objFolder := objShell.NameSpace(dir)
        objFolderItem := objFolder.ParseName(name)
    }
    if validate {
        colVerbs := objFolderItem.Verbs   
        loop % colVerbs.Count {
            verb := colVerbs.Item(A_Index - 1)
            retMenu := verb.name
            StringReplace, retMenu, retMenu, &       
            if (retMenu = menu) {
                verb.DoIt
                return True
            }
        }
		return False
    } else
        objFolderItem.InvokeVerbEx(Menu)
} 
sleep, 2000
return

AppVolume(app:="", device:="") {
	return new AppVolume(app, device)
}

class AppVolume {
	ISAVs := []
	
	__New(app:="", device:="") {
		static IID_IASM2 := "{77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}"
		, IID_IASC2 := "{BFB7FF88-7239-4FC9-8FA2-07C950BE9C6D}"
		, IID_ISAV := "{87CE5498-68D6-44E5-9215-6DA47EF883D8}"
		
		; Activate the session manager of the given device
		pIMMD := VA_GetDevice(device)
		VA_IMMDevice_Activate(pIMMD, IID_IASM2, 0, 0, pIASM2)
		ObjRelease(pIMMD)
		
		; Enumerate sessions for on this device
		VA_IAudioSessionManager2_GetSessionEnumerator(pIASM2, pIASE)
		ObjRelease(pIASM2)
		
		; Search for audio sessions with a matching process ID or Name
		VA_IAudioSessionEnumerator_GetCount(pIASE, Count)
		Loop, % Count
		{
			; Get this session's IAudioSessionControl2 via its IAudioSessionControl
			VA_IAudioSessionEnumerator_GetSession(pIASE, A_Index-1, pIASC)
			pIASC2 := ComObjQuery(pIASC, IID_IASC2)
			ObjRelease(pIASC)
			
			; If its PID matches save its ISimpleAudioVolume pointer
			VA_IAudioSessionControl2_GetprocessID(pIASC2, PID)
			if (PID == app || this.GetprocessName(PID) == app)
				this.ISAVs.Push(ComObjQuery(pIASC2, IID_ISAV))
			
			ObjRelease(pIASC2)
		}
		
		; Release the IAudioSessionEnumerator
		ObjRelease(pIASE)
	}
	
	__Delete() {
		for k, pISAV in this.ISAVs
			ObjRelease(pISAV)
	}
	
	AdjustVolume(Amount) {
		return this.SetVolume(this.GetVolume() + Amount)
	}
	
	GetVolume() {
		for k, pISAV in this.ISAVs
		{
			VA_ISimpleAudioVolume_GetMasterVolume(pISAV, fLevel)
			return fLevel * 100
		}
	}
	
	SetVolume(level) {
		level := level>100 ? 100 : level<0 ? 0 : level ; Limit to range 0-100
		for k, pISAV in this.ISAVs
			VA_ISimpleAudioVolume_SetMasterVolume(pISAV, level / 100)
		return level
	}
	
	GetMute() {
		for k, pISAV in this.ISAVs
		{
			VA_ISimpleAudioVolume_GetMute(pISAV, bMute)
			return bMute
		}
	}
	
	SetMute(bMute) {
		for k, pISAV in this.ISAVs
			VA_ISimpleAudioVolume_SetMute(pISAV, bMute)
		return bMute
	}
	
	ToggleMute() {
		return this.SetMute(!this.GetMute())
	}
	
	GetprocessName(PID) {
		hprocess := DllCall("Openprocess"
									, "UInt", 0x1000 ; DWORD dwDesiredAccess (process_QUERY_LIMITED_INFORMATION)
									, "UInt", False  ; BOOL  bInheritHandle
									, "UInt", PID    ; DWORD dwprocessId
									, "UPtr")
		dwSize := VarSetCapacity(strExeName, 512 * A_IsUnicode, 0) // A_IsUnicode
		DllCall(	"QueryFullprocessImageName"
					,"UPtr", hprocess  ; HANDLE hprocess
					,"UInt", 0         ; DWORD  dwFlags
					,"Str", strExeName ; LPSTR  lpExeName
					,"UInt*", dwSize   ; PDWORD lpdwSize
					,"UInt")
		DllCall("CloseHandle", "UPtr", hprocess, "UInt")
		splitPath, strExeName, strExeName
		return strExeName
	}
}

; --- V A Additions ---
; ISimpleAudioVolume : {87CE5498-68D6-44E5-9215-6DA47EF883D8}

VA_ISimpleAudioVolume_SetMasterVolume(this, ByRef fLevel, GuidEventContext="") {
	return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "float", fLevel, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMasterVolume(this, ByRef fLevel) {
	return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "float*", fLevel)
}
VA_ISimpleAudioVolume_SetMute(this, ByRef Muted, GuidEventContext="") {
	return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "int", Muted, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMute(this, ByRef Muted) {
	return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "int*", Muted)
}

Restart_WMP:
WMP := new RemoteWMP
sleep, 30
Media := WMP.player.currentMedia
Path2File:=Media.sourceURL
Controls := WMP.player.Controls
time:=round(controls.currentPosition)
run taskkill /F /IM WMPlayer.exe 
sleep, 3800
run wmplayer.exe "%Path2File%"
sleep 100
bum_open:
WMP := new RemoteWMP
if !WMP {
	sleep 100
	goto bum_open
}
bum_take_aim:
if WMP {
	try
		Media := WMP.player.currentMedia
	catch {
		sleep 100
		goto bum_take_aim
	}
} else {
	sleep 100
	goto bum_take_aim
}
if !Media {
	sleep 100
	goto bum_take_aim
}
bum_start_shitting:
if Media {
	Path2File:=Media.sourceURL
} else {
	sleep 100
	goto bum_start_shitting
}
if !Path2File {
	sleep 100
	goto bum_start_shitting
}
bum_shit_everywhere:
if Path2File {
	Controls := WMP.player.Controls
} else {
	sleep 100
	goto bum_shit_everywhere
}
if !Controls
	goto bum_shit_everywhere
bum_start_wiping:
if controls {
	WMP.jump(time)
} else {
	sleep 100
	goto bum_start_wiping
}
return

Open_script_folder:	
runwait %COMSPEC% /C explorer.exe /select`, "%a_scriptFullPath%",, hide
sleep %S%
sendInput {F5}
return

/* 
<^>!C::		;altGr x  SAMPLE START / END. 
WMP := new RemoteWMP
sleep, 20
Media := WMP.player.currentMedia
Controls := WMP.player.Controls
sleep, 20
FullPath:=Media.sourceurl
splitPath, FullPath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
if !Secs2Sample_Start {
	if Secs2Sample_Start:=round(controls.currentPosition)
		Sample_start_min:= Floor(Secs2Sample_Start/60)
	else {
		Secs2Sample_Start:="0"
		Sample_start_min:= Floor(Secs2Sample_Start/60)
	}
	if Sample_start_Hr:=Floor(Sample_start_min/60)
		Sample_start_min:=Sample_start_min-(Sample_start_Hr*60)
	Sample_start_Sec:=Secs2Sample_Start-(Sample_start_min*60)
} else {
	Secs2Sample_End:=round(controls.currentPosition)
	Sample_End_min:= Floor(Secs2Sample_End/60)
	if Sample_End_Hr:=Floor(Sample_End_min/60)
		Sample_End_min:=Sample_End_min-(Sample_End_Hr*60)
	Sample_End_Sec:=Secs2Sample_End-(Sample_End_min*60)
	Start_Time=%Sample_start_Hr%:%Sample_start_min%:%Sample_start_Sec%
	End_Time=%Sample_End_Hr%:%Sample_End_min%:%Sample_End_Sec%
	gui, GuiName:new , , Question
	Gui +HwndQuestionHwnd
	gui, Add, Text,, SAMPLE 
	gui, Add, CheckBox, Checked center vExtract, Extract
	gui, Add, Text,, TRIM 
	gui, Add, CheckBox, center vTrim, Delete	; gui, Add, CheckBox, center vReplace, Replace
	gui, Add, Button, center Default gPerform w80, OK
	gui, Add, Button, center w80 gCancel, Cancel
	gui, Show , Center, Question
	return
	
Cancel:
gui, Destroy
Secs2Sample_Start:=
exit

Perform:
gui, Submit
gui, Destroy 
Secs2Sample_Start:=
If Extract
	process_Action:="-t", process_Type:="Extracted"
If Trim 
	process_Action:="-to", process_Type:="Trimmed"
Output_Prefix=%OutNameNoExt% - %process_Type%
Output_Filename_Full=%OutDir%\%Output_Prefix%.%OutExtension%
global needL := "i)(?:Extracted)(?:[ ])[0-9]"
File_Numbering:
if (n:=fileexist(Output_Filename_Full)) {
	n := 1, RegXPos = 1, Match :=
	DEAD_NIG=%Output_Prefix%
	while RegXPos := regexmatch(DEAD_NIG, needL, Match, RegXPos) {
		File_Num := Match
		RegXPos = 666
	}
	if !File_Num {
		File_Num:=1
	} else {
		File_Num := File_Num + 1
	}
	Output_Filename_Full=%OutDir%\%Output_Prefix% %File_Num%.%OutExtension%
} else
		Output_Filename_Full=%OutDir%\%Output_Prefix%.%OutExtension%
	if FileExist(Output_Filename_Full) { ; Check_Folder
		splitPath, Output_Filename_Full , , , , Output_Prefix
		goSub File_Numbering
}

if Extract && Trim 
{
	Output_Filename_Full=%OutDir%\%OutNameNoExt% - Extracted.%OutExtension%
	runWait, %comspec% /c ffmpeg -i "%FullPath%" -ss %Start_Time% -t %End_Time% -c:v copy -c:a copy "%Output_Filename_Full%",,Hidden
	IF DICKS:=INSTR(OutNameNoExt, "Trimmed")
		Output_Filename_Full=%OutDir%\%OutNameNoExt%.%OutExtension%
	else
		Output_Filename_Full=%OutDir%\%OutNameNoExt% - Trimmed.%OutExtension%
	runWait, %comspec% /c ffmpeg -i "%FullPath%" -ss %Start_Time% -to %End_Time% -c:v copy -c:a copy "%Output_Filename_Full%",,Hidden
	InvokeVerb(Output_Filename_Full, "Cut", True)
	return
}
If Trim {
	SecsDuration:=round(media.getItemInfo("Duration"))
	Sample_Duration_min:= Floor(SecsDuration/60)
	if Sample_Duration_Hr:=Floor(Sample_Duration_min/60)
		Sample_Duration_min:=Sample_Duration_min-(Sample_Duration_Hr*60)
	Sample_Duration_Sec:=SecsDuration-(Sample_Duration_min*60)
	Output_Duration=%Sample_Duration_Hr%:%Sample_Duration_min%:%Sample_Duration_Sec%
	FirstHalf=%OutDir%\%OutNameNoExt% - Trimmed first half.%OutExtension%
	SecondHalf=%OutDir%\%OutNameNoExt% - Trimmed 2nd half.%OutExtension%
	runWait, %comspec% /c ffmpeg -i "%FullPath%" -ss 0:0:0 -to %Start_Time% -c:v copy -c:a copy "%FirstHalf%",,Hidden
	runWait, %comspec% /c ffmpeg -i "%FullPath%" -ss %End_Time% -to %Output_Duration% -c:v copy -c:a copy "%SecondHalf%",,Hidden
	FileAppend , file '%FirstHalf%'`n, %Con_Cat_N_8%
	FileAppend , file '%SecondHalf%'`n, %Con_Cat_N_8%
	sleep 1500
	IF DICKS:=INSTR(OutNameNoExt, "Trimmed")
		Output_Filename_Full=%OutDir%\%OutNameNoExt%.%OutExtension%
	else
		Output_Filename_Full=%OutDir%\%OutNameNoExt% - Trimmed.%OutExtension%
	runWait, %comspec% /c ffmpeg -y -f concat -safe 0 -i "%Con_Cat_N_8%" -c copy "%Output_Filename_Full%",,Hidden
	fileDelete, %FirstHalf%
	fileDelete, %SecondHalf%
	fileDelete, %Con_Cat_N_8%
	fileGetTime, Old_D8 , %FullPath%, m
	fileSetTime, Old_D8 , %Output_Filename_Full%, m	;FileRecycle, %FullPath%

	Check_Output:
	sleep 500
	if !fileExist(FullPath)
		fileMove, Output_Filename_Full, FullPath
	else 
		goto Check_Output
	exit
} else {
	runWait, %comspec% /c ffmpeg -i "%FullPath%" -ss %Start_Time% %process_Action% %End_Time% -c:v copy -c:a copy "%Output_Filename_Full%",,Hidden
	if InvokeVerb(Output_Filename_Full, "Cut", True)
		{
		Secs2Sample_End:="",Secs2Sample_Start:="",Output_Filename_Full:=""
		exit
		}
	return
	}
Escape::gui, Destroy
return
}
return
 */

/* 
;OTHER SHIT::::::::::::


; msgBox, % Media.sourceURL
; msgBox, % Controls.currentPosition . "`n"
        ; . Controls.currentPositionString
; msgBox, % Media.getItemInfo("WM/AlbumTitle")
; All attribute names you can get with Media.getItemInfo(attributeName)
; Loop % Media.attributeCount
   ; attributes .= Media.getAttributeName(A_Index - 1) . "`r`n"
; msgBox, % clipboard := attributes


// Play States

var psUndefined              = 0;
var psStopped                = 1;
var psPaused                 = 2;
var psPlaying                = 3;
var psScanForward            = 4;
var psScanReverse            = 5;
var psBuffering              = 6;
var psWaiting                = 7;
var psMediaEnded             = 8;
var psTransitioning          = 9;
var psReady                  = 10;
var psReconnecting           = 11;


Play
WinMsg - Post Message
Current Window
Message ID: 0x319
WParam: 0
LParam: 0x2e0000


Pause
WinMsg - Post Message
Current Window
Message ID: 0x319
WParam: 0
LParam: 0x2f0000 


Toggle play/pause

WinMsg - Post Message
Current Window (Or search by window title "Windows Media Player")
Message ID: 0x111
WParam: 32808
LParam: 0 

WParams:

16000 - Go to "Now Playing"
16001 - Go to "Guide"
16002 - Go to "Service Task 1" This is the "Music" tab on my player
16003 - Go to "Rip"
16004 - Go to "Library"
16005 - Go to "Service Task 3" This is the "Video" tab on my player
16006 - Go to "Burn"
16007 - Go to "Sync"
16008 - Go to "Service Task 2" This is the "Radio" tab on my player

16009 - Skin Chooser

18724 - Rip Audio CD Doesn't do anything if Media is playing

18777 - "Rip" tab

18779 - Open "Properties" dialog RC=FAIL. Use 32779 or postMessage
18780 - View Full Mode
18781 - View Compact Mode
18782 - Full screen (toggle)
18783 - Show/Hide Playlist (toggle)

18787 - Show/Hide Media Information (toggle)

18789 - Show/Hide Enhancements (toggle)

18791 - Show/Hide Title (toggle)

18799 - Video Size: 50%
18800 - Video Size: 100%
18801 - Video Size: 200%
18802 - Video Size: Fit Video to Player on Resize (toggle)

18805 - Video Size: Fit Player to Video on Start (toggle)

18808 - Play/Pause Track (toggle)
18809 - Stop
18810 - Previous Track
18811 - Next track
18812 - Rewind Only works on video?
18813 - Fast Forward (toggle)

18815 - Volume: Up
18816 - Volume: Down
18817 - Volume: Mute (toggle)

18824 - View Privacy Statement Link to external web page
18825 - Open "Options" dialog RC=FAIL. Use 32825 or postMessage
18826 - Open "Windows Media Player Help"

18834 - Play Speed: Fast
18835 - Play Speed: Normal
18836 - Play Speed: Slow

18842 - Shuffle (toggle)
18843 - Repeat (toggle)

18846 - Download: Visualizations Link to external web page

18849 - Open "Add to Library by Searching Computer" dialog RC=FAIL. Use 32849 or postMessage
18850 - Open "Monitory Folders" dialog RC=FAIL. Use 32850 or postMessage

18861 - Open "File Open" dialog RC=FAIL. Use 32861 or postMessage
18862 - Open "Open URL" dialog RC=FAIL. Use 32862 or postMessage

18871 - Open "Manage Licenses" dialog RC=FAIL. Use 32871 or postMessage
18872 - Open "Open URL" dialog (Same as 18862?) RC=FAIL. Use 32862 or postMessage

Codes 18880 to ????? causes WMP to crash. RC=FAIL or
RC=0. Haven't tried postMessage


18889 - Save "Now Playing List" As RC=FAIL. Use ????? or postMessage

18904 - Work Offline (toggle)

18907 - Burn Audio CD

18909 - Synchronize

18794 - Open "Statistics" dialog

19102 - Print Label Not sure when this is available

19011 - Open "Save As" dialog RC=FAIL. Use ????? or postMessage

19013 - Save "Now Playling List"
19014 - New "Now Playing List"

19141 - Windows Media Player Online Link to external web page
19142 - Download: Supported Devices and Drivers Link to external web page
19143 - Download: Skins Link to external web page

19160 - Troubleshooting Link to external web page

19200 - Info Center View (Under "Now Playing" tab)

19230 - Display "Quiet Mode" Shows "Enhancements" window
19231 - Display "Color Chooser" Shows "Enhancements" window
19232 - Display "Crossfading and Auto Volume Leveling" Shows "Enhancements" window
19233 - Display "Graphic Equalizer" Shows "Enhancements" window
19234 - Display "Media Link for E-Mail" Shows "Enhancements" window
19235 - Display "Play Speed Settings" Shows "Enhancements" window
19236 - Display "SRS WOW Effects" Shows "Enhancements" window
19237 - Display "Video Settings" Shows "Enhancements" window

19497 - Download Plug-ins Link to external web page
19498 - Open Plug-ins Options dialog

19500 - DVD: Root Menu
19501 - DVD: Title Menu returns 1 if menu is not available (?)
19502 - DVD: Close Menu (Resume)
19503 - DVD: Back

19572 - Update DVD Information RC=FAIL. Use ????? or postMessage

19681 - DVD, VCD or CD Audio

19721 - Show Menu Bar
19722 - Hide Menu Bar
19723 - Autohide Menu Bar
19724 - Hide Taskbar (toggle)

19998 - Download: Plug-ins Link to external web page
19999 - Open Plug-ins Options dialog RC=FAIL. Use 19498 or postMessage

26000 - Services List



32777 - Info Center View (Under "Now Playing" tab)

32779 - Open "Properties" dialog
32780 - View Full Mode
32781 - View Compact Mode
32782 - Full screen (toggle)
32783 - Show/Hide Playlist (toggle)

32787 - Show/Hide Media Information (toggle)
32789 - Show/Hide Equilizer (toggle)
32791 - Show/Hide Title (toggle)
32794 - Open "Statistics" dialog
32797 - *** Locks up WMP & eats up CPU. Don't know why ***
32798 - *** Locks up WMP & eats up CPU. Don't know why ***
32805 - "Music" tab
32806 - "Library" tab
32808 - Play/Pause Track (toggle)
32809 - Stop
32810 - Previous Track
32811 - Next Track
32813 - Fast Forward (toggle)
32815 - Volume Up
32816 - Volume Down
32817 - Volume Mute (toggle)

32824 - Link to Privacy Statement (web)
32825 - Open "Options" dialog
32826 - Open "Windows Media Player Help"

32834 - Play Speed: Fast
32835 - Play Speed: Normal
32836 - Play Speed: Slow

32842 - Shuffle (toggle)
32843 - Repeat (toggle)

32846 - Download: Visualizations Link to external web page

32849 - Open "Add to Library by Searching Computer" dialog
32850 - Open "Monitory Folders" dialog

32861 - Open "File Open" dialog
32862 - Open "Open URL" dialog

32871 - Open "Manage Licenses" dialog
32872 - Open "Open URL" dialog (Same as 32862?)

Codes 32880 to ????? causes WMP to crash. RC=FAIL or
RC=0. Haven't tried postMessage.

57601 - Open "File Open" dialog RC=FAIL. Use 32861 or postMessage
57602 - File Close

57665 - exit


;from nowdoing.js in WMPLOC.DLL.MUN/256

// defines
var psPlaying =  3;
var psStopped =  1
var psPaused  =  2;
var psReady   = 10;
var psTransitioning = 9;
var psUndefined = 0;
var g_kSyncID       = "{661CCB0E-B835-4256-B566-6D3FD8491FFC}"
var g_kBurnID       = "{939438A9-CF0F-44D8-9140-599736F0D3A2}"
var g_kBrowseID     = "deprecated"
var g_kNowPlayingID = "{70C02500-7C6F-11D3-9FB6-00105AA620BB}"

*/