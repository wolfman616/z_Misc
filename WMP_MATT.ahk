#NoEnv 		
#Persistent 		
#inputlevel 1
sendMode Input
SetBatchLines -1
CoordMode window, screen
detecthiddenwindows on
detecthiddentext on 
#singleinstance force
settitlematchmode 2 
SetWorkingDir %A_ScriptDir% 
; Extract and trim with vocal / instrumental AI  Requires FFMPEG / Anaconda / Python / Spleeter 
														
#include C:\Script\AHK\Z_MIDI_IN_OUT\extractorgui.ahk 	
init:
	
gosub, varz
gosub, init_menu
gosub, main
return,

main:
global numpad_blacklist, wmp, WMP8 ;gosub, togl_numpad_i ; numpd bypass add shit to string above
regWrite, REG_DWORD,% (hkcuWMPprefs := "HKEY_CURRENT_USER\Software\Microsoft\MediaPlayer\Preferences"),% "Volume",% "1"
hotkey, +<^>!Space,	PauseToggle, on
hotkey,  <^>!Space,	PauseToggle, on
numpad_blacklist := "ahk_exe wmplayer.exe, ahk_exe firefox.exe"
wm_allow()
OnMessage(0x4a, "Receive_WM_COPYDATA") ; 0x4a is WM_COPYDATA

if !(fileexist(c0nda))
	ANACONDA := False

process exist, ahk_exe WMPlayer.exe
if Errorlevel 
	run,% "C:\Program Files\Windows Media Player\WMPlayer.exe"
run,%	  "WMP_colour_controls_test.ahk"

WMP 		:= 	new RemoteWMP
Media 		:= 	WMP.player.currentMedia
oldsong 	:= 	Media.sourceURL
id3Art 		:= 	iD3_Artist(oldsong)
id3Ttl  	:= 	iD3_Track(oldsong)
newiD3full 	:= 	iD3_StringGet(oldsong)
Controls 	:= 	WMP.player.Controls
hundle 		:= 	gethandle()
SplitPath, 	oldsong,, OutDir, OutExtension, OutNameNoExt, OutDrive
if !newiD3full 
	newiD3full := OutNameNoExt
playstate := WMP.player.playState
settimer, PlayPstateUpdateInterval, -1
if (playState = 3) { ; Playing = 3
	trigger_PL := True,		trigger_pa := False 
	Pstate(On)
	trayTip, % id3Art " - " id3Ttl, % "WMP Now-Playing", 3, 33
	menu, tray, Tip, % "Windows Media Player - Playing`n" newiD3full
} else { 
	trigger_PL := False
	Pstate(Off)
	menu, tray, Tip, % "Windows Media Player - Paused`n" newiD3full
	trayTip, % (id3Art " - " id3Ttl), % ("WMP Paused"), 3, 33
}
loop 5
	sleep, 50

onexit() { 
	WMP 	:= Delete RemoteWMP
	WMP2 	:= Delete RemoteWMP
	WMP2del	:= Delete RemoteWMP
	if (fileexist(xtractData_Cc)) {
		fileDelete, %xtractData_Cc%
		msgbox,% "post gasm shame found`ncleaning up."
}	}

return,

Cutcurrent:
Path2File 	:= 	Media.sourceURL
cur_ 		:= 	"anicur_drip"
settimer, anicur_, -20, -2147483648
if (InvokeVerb(Path2File, "Cut")) { 
	process,Exist
	hwnd := WinExist("ahk_class tooltips_class32 ahk_pid " Errorlevel)
} 
menu, tray, Icon, % "copy.ico"
Monster_Clip  :=  clipboard
settimer, Clip_Commander, -1000
return,

playy:
WMP.player.Controls.play()
return,

PauseToggle:
if !WMP
	wmp  :=  new remotewmp
WMP.togglePause()
return,

JumpPrev:
;cur_ := "AniCur_Pink"
;settimer, AniCur_, -2, -2147483648

if !WMP {
	WMP 	:= 	Delete 	RemoteWMP
	WMP 	:= 	New 	RemoteWMP
}
WMP.player.Controls.Stop()
sleep, 50
WMP.player.Controls.Previous()
sleep, 50
Media   := 	 WMP.player.currentMedia
 
thecall2:
gosub, WMP_Refresh_2
if (NewSong = oldsong) {
	sleep, 100
	gosub, thecall2
} else {
	WMP.jump(Offset_Start)
	sleep, 200
	WMP.player.Controls.play()
}
return,

/* 
youtube_next:
sendinput, {Media_Next}, chrome
 */

JumpNext:
settimer, PlayPstateUpdateInterval, off
Real_pos := False, genre := "", gnr := "",	NewSong	:= ""
if !WMP
	WMP	:= 	new RemoteWMP
stry1:
try
	Controls.Stop()
catch {
	sleep, 200
	goto,  stry1
}
snext1:
try
	Controls.Next()
catch {
	sleep, 200
	goto,  snext1
}
jmptry1:
try
	WMP.jump(Offset_Start)
catch {
	sleep, 200
	goto,  jmptry1
}
plytry1:
try
	WMP.player.Controls.play()
catch {
	sleep, 200
	goto,  plytry1
}
Precumpair: ;cur_ := "AniCur_bfly" 
try ;settimer, AniCur_, -200, -2147483648
	NewSong := WMP.player.currentMedia.sourceURL
catch {
	sleep, 350
	gosub, Precumpair
}
iD3full := iD3_StringGet2(NewSong)

thecall1:
sleep, 50
if (NewSong == oldsong) {
	f_Htry 	:= 	True
	if !tries
		tries 	:= 	1
	else {
		tries 	:= 	tries + 1
		tooltip %   "trying " tries
		settimer,   tooloff, -1000
	}
	if (tries   <   5) {
		sleep, 300
		goto,  Precumpair
	}
	else return,
} else {
	f_Htry 	:= 	false
	iD3full 	:= 	iD3_StringGet2(NewSong)
	NewSong := oldsong
	real_pos 	:= 	getpos() 
	if Real_pos {
		sleep 500
		if AutoScroll
			SendMessage 0x1014, 0, 	((real_pos * 23)-150),, ahk_id %hundle% ; LVM_SCROLL=0x1014
	} else Tooltip % "ERROR"
	settimer, tooloff, -2000
	gosub, Genre_Search
	if (godie || pastenskip) {
		Real_pos := Real_pos -1
		goto POST_GASM
}	}

return,

CopySearchSlSk:
WMP			:= new RemoteWMP
sleep, 		50
Media		:= WMP.player.currentMedia
Controls	:= WMP.player.Controls
sleep, 		20
FullPath	=% Media.sourceURL
process, Exist, slsk2.exe
if !ErrorLevel	
	trayTip, % "Windows Media Player", % "error slsk not open"
else {
	SplitPath, FullPath, , , , OutNameNoExt
	1st := RegExReplace(OutNameNoExt,Needle4, " ")
	2nd := RegExReplace(1st,Needle2, " ")
	runwait % "C:\script\AHK\Working\slsk fix.ahk"	
	winGetPos,,, Width, Height, %WinTitle%
	mouseGetPos, orig_x, orig_y
	BlockInput, On
	mouseMove, 145, 90,
	send, {LButton}		
	send, % (Stripped_Name := RegExReplace(2nd, Needle3, " "))
	send, {Enter}
	mouseMove, 1787, 218
	send, {LButton}
	mouseMove, orig_x, orig_y, 
	BlockInput, Off
}
return,

SearchYT:
SplitPath,  %  (UNC := 	(((New RemoteWMP).Player.CurrentMedia).SourceURL)),,,, Name
name 				:= 	RegExReplace(name, 	"i)\-" , 	" ")
1st					:= 	RegExReplace(Name,	Needle4, 	" ")
2nd					:= 	RegExReplace(1st,	Needle2, 	" ")
Stripped_Name 		:= 	RegExReplace(2nd, 	Needle3, 	" ")
ytsearchstn 		:= 	""" " . Stripped_Name . " """ 
Run, % ( "firefox.exe -new-tab " . ( ytsearchstr . ytsearchstn ) )
return,

SearchExplorer:
gosub, WMP_Refresh_2
gosub, Genre_Search
trayTip, Windows Media Player, path
FullPath=%NewSong%
SplitPath, FullPath, , , , OutNameNoExt
1st := regExReplace(OutNameNoExt,Needle4, " ")
2nd := regExReplace(1st,Needle2, " ")
run, explorer.exe %Search_Root%
winWaitActive, ahk_exe explorer.exe, , 5
sleep, 1000
send,{ctrl}{f}
sleep, 1500
send,% Stripped_Name := RegExReplace(2nd, "( . )|(^[a-z][\s])|( )|( )|( )|[.]", " ")
sleep, 500
send, {enter}
return,

Genre_Search:
p 		:= 	1, Matched_String := "",	genre := ""
o		:= 	comobjcreate("Shell.Application")
SplitPath,NewSong,file,directory,ext
od		:= 	o.namespace(directory)
of		:= 	od.parsename(file)
gnr		:= 	od.getdetailsof(of,16) ; genre
while p := 	RegExMatch(NewSong, Genres, Matched_String, p + StrLen(Matched_String)) {
	switch Matched_String {
		case "dnb":
			Offset_Start:=86,   p:=999, Genre:="dnb", 	Search_Root:="S:\- DNB"
		case "Drum & Bass":
			Offset_Start:=86,   p:=999, Genre:="dnb", 	Search_Root:="S:\- DNB"
		case "reggae":
			Offset_Start:=11.5, p:=999, Genre:="reggae", Search_Root:="S:\- REGGAE"
		case "rocksteady":
			Offset_Start:=11.5, p:=999, Genre:="reggae", Search_Root:="S:\- REGGAE"
		case "riddim":
			Offset_Start:=11.5, p:=999, Genre:="riddim", Search_Root:="S:\- REGGAE"
		case "hiphop":
			Offset_Start:=17,   p:=999, Genre:="hiphop", Search_Root:="S:\- HIPHOP"
		case "garage":             
			Offset_Start:=45,   p:=999, Genre:="garage", Search_Root:="S:\- - MP3 -\Garage"
		case "rock":               
			Offset_Start:=17,   p:=999, Genre:="rock", 	Search_Root:="S:\- - MP3 -\- Other\Rock"
		case "ambient":            
			Offset_Start:=30,   p:=999, Genre:="ambient", Search_Root:="S:\- - MP3 -\Chill"
		case "samples":
			Offset_Start:=0,    p:=999, Genre:="samples", Search_Root:="S:\Samples"
		case "my music":           
			Offset_Start:=0,    p:=999, Genre:="my music", Search_Root:="S:\Documents\My Music"
		case "audiobooks":         
			Offset_Start:=0,    p:=999, Genre:="audiobooks", Search_Root:="S:\Documents\My Audio"
		case "_SLSK_":
			Offset_Start:=45,   p:=999, Genre:="sLSk"
		case "FOAD":
			Offset_Start:=0,    p:=999, Genre:=""
	}
	if (gnr="dnb") || (gnr="drum & bass") || (gnr="drum&bass") || (gnr="drum n bass") 
		Offset_Start:=86, p:=999, Genre:="dnb", Search_Root:="S:\- DNB",                    f_H	:=	1
	else if (gnr="Reggae") || (gnr="Dancehall") || (gnr="Ragge") || (gnr="Riddim") 		
		Offset_Start:=11.5, p:=999, Genre:="reggae", Search_Root:="S:\- REGGAE",            f_H	:=	1
	else if (gnr="Hip-Hop") || (gnr="HipHop") || (gnr="Rap") || (gnr="Gangster Rap") 		
		Offset_Start:=17, p:=999, Genre:="hiphop", Search_Root:="S:\- HIPHOP",              f_H	:=	1
	else if (gnr="Garage") || (gnr="2 Step") || (gnr="Bassline")		
		Offset_Start:=45, p:=999, Genre:="garage", Search_Root:="S:\- - MP3 -\Garage",      f_H	:=	1
	else if (gnr="Rock") || (gnr="Rock n Roll") || (gnr="Metal")		
		Offset_Start:=17, p:=999, Genre:="rock", Search_Root:="S:\- - MP3 -\- Other\Rock",  f_H	:=	1
	else if (gnr="Ambient") || (gnr="Chill Out")		
		Offset_Start:=30, p:=999, Genre:="ambient", Search_Root:="S:\- - MP3 -\Chill",      f_H	:=	1
	else if (gnr="Spoken Word") || (gnr="Audiobook")		
		Offset_Start:=0, p:=999, Genre:="audiobooks", Search_Root:="S:\Documents\My Audio", f_H	:=	1
	}	
return,

iD3_StringGet(tune="") {
	SplitPath,tune,file,directory,ext
	p 		:= 	1, 	Matched_String := "",	genre := ""
	o		:= 	comobjcreate("Shell.Application")
	oo		:= 	o.namespace(directory)
	of		:= 	oo.parsename(file)
	rtist 	:=	oo.getdetailsof(of,13)
	gnr		:= 	oo.getdetailsof(of,16) ; genre
	titL 	:=	oo.getdetailsof(of,21)
	if (!rtist || !titL)
		return, False
	return, % (rtist . " - " . titL)
}
iD3_StringGet2(tune="") {
	SplitPath,tune,file,directory,ext
	p 		:= 	1, 	Matched_String := "",	genre := ""
	o		:= 	comobjcreate("Shell.Application")
	oo		:= 	o.namespace(directory)
	of		:= 	oo.parsename(file)
	rtist 	:=	oo.getdetailsof(of,13)
	gnr		:= 	oo.getdetailsof(of,16) ; genre
	titL 	:=	oo.getdetailsof(of,21)
	if (!rtist || !titL)
		return, False
	return, % (titL . " - " . rtist)
}

iD3_Artist(tune="") {
	SplitPath,tune,file,directory,ext
	p 		:= 	1, 	Matched_String := "",	genre := ""
	o		:= 	comobjcreate("Shell.Application")
	oo		:= 	o.namespace(directory)
	of		:= 	oo.parsename(file)
	rtist 	:=	oo.getdetailsof(of,13)
	if !rtist
		return, False
	return, rtist
}

iD3_Track(tune="") {
	SplitPath,tune,file,directory,ext
	p 		:= 	1, 	Matched_String := "",	genre := ""
	o		:= 	comobjcreate("Shell.Application")
	oo		:= 	o.namespace(directory)
	of		:= 	oo.parsename(file)
	titL 	:=	oo.getdetailsof(of,21)
	if !titL
		return, False
	return, titL
}

WMP_Refresh: 
if !WMP
	WMP 	:= new RemoteWMP
try
	Media	:= WMP.player.currentMedia
catch
	sleep, 100
try	
	Controls 
	:= WMP.player.Controls
catch
	sleep, 100
return,

WMP_Refresh_2:
if !WMP
	WMP 	:= new RemoteWMP
sleep, 		100
gosub, 		WMP_refresh
sleep, 		100
NewSong 	=% 		WMP.player.currentMedia.sourceURL
id3Art 		:= 	iD3_Artist(NewSong)
id3Ttl  	:= 	iD3_Track(NewSong)
sleep, 		100
return,

DelCurrent: 
Cur_ := "AniCur_Munch"
settimer, AniCur_, -1, -2147483648
if Media2del 
	goto DELETE_

	WMP2del := new RemoteWMP

process, Exist, WMPlayer.exe
settimer, Del_0, -300
return,

Del_0:
Media2del 	:= 	WMP2del.player.currentMedia
sleep, 	100
File2Del 	=% 	Media2del.sourceURL
iD3full2 	:= 	iD3_StringGet(File2Del)
id3Art2 		:= 	iD3_Artist(File2Del)
id3Ttl2  	:= 	iD3_Track(File2Del)
global 	idd_:= 	iD3full
;gosub, 		Nowplayinglist_delcurrent
settimer, 	Nowplayinglist_delcurrent, -1
;goSub, 	JumpNext
settimer, 	JumpNext, -200
setTimer, 	DELETE_, -700	
return,

DELETE_:
if FileExist(File2Del) {
	FileRecycle, % File2Del ;trayTip, Windows Media Player, Deleted %File2Del%, 3, 1
	if ( !errorlevel || !(FileExist(File2Del)) ) {
		tooltip % "Deleted: `n" iD3full2
	} else {
		ARRAYWANK:
		deletearr.push(File2Del)
		for index, element in deletearr
		{
			if (FileExist(element)){
				File2Del:= element
				gosub, DELETE_
				if (FileExist(element)) {
					tooltip % "You spiN, not good"
					settimer, tooloff, -1200
					FileRecycle, % element 
				} else {
					tooltip % "Right round baby gg"
					DEADFILE := deletearr.pop(element) 
					settimer, tooloff, -1200
			}	}
			else trayTip, % id3Art2 " - " id3Ttl2, % "Deleted from stack ", 3, 33
}	}	}

if !(exist := FileExist(File2Del)) {
	trayTip, % id3Art2 " - " id3Ttl2, % "Deleted from stack ", 3, 33
	sleep, 		222
	gosub, 		cleanup
	gosub, 		WMP_refresh
	return,
} else {
	retries := 	retries + 1
	if (retries > 25) {
		msgbox unable to delete after 25
		gosub, 	cleanup
		gosub, 	WMP_refresh
		exit
	} else {
		sleep, 	400
		goto, 	DELETE_
}	}
return,

cleanup:
retries   :=  1
File2Del  :=  ""
Media2del :=  ""
exist     :=  ""
WMP2del   :=  Delete RemoteWMP
tooltip,
return,

add2Playlist:
WMP       :=  new RemoteWMP
sleep,        20
Media     :=  WMP.player.currentMedia
Controls  :=  WMP.player.Controls
sleep,        20
FullPath  :=  Media.sourceurl
sleep,        20
if fileexist("New_Playlist.m3u") {
	if !fileexist Playlist.m3u
		fileMove New_Playlist.m3u, Playlist.m3u
	else, 
		try {
			if !fileexist(Playlist%p_Item%.m3u)
				fileMove New_Playlist.m3u, Playlist%p_Item%.m3u
		} catch {
			p_Item := p_Item+1
			SLEEP, 80
		}
} else,	FileAppend %fullpath%`n, New_Playlist.m3u
return,

Dr:
SecsDuration := (round(media.getItemInfo("Duration")))
Sample_Duration_min  := (Floor(SecsDuration/60))
if Sample_Duration_Hr:= (Floor(Sample_Duration_min/60))
	  Sample_Duration_min := Sample_Duration_min-(Sample_Duration_Hr*60)
Sample_Duration_Sec  := (SecsDuration-(Sample_Duration_min*60))
Output_Duration=%Sample_Duration_Hr%:%Sample_Duration_min%:%Sample_Duration_Sec%
if !Split
	  extract_data_1  =  %OutDir%\%OutNameNoExt% - Extract.%OutExtension%
else
	  extract_data_1  =  %OutDir%\%OutNameNoExt% - 1st half.%OutExtension%
if instr(OutNameNoExt,   "Trimmed")
	  Output_FullUnc  =  %OutDir%\%OutNameNoExt%.%OutExtension%
else, Output_FullUnc  =  %OutDir%\%OutNameNoExt% - Trimmed.%OutExtension%
	fileGetTime, Old_D8, %FullPath%, m
; if errorlevel
	; msgbox error
msgbox def
run, %comspec% /c ffmpeg -i "%FullPath%" -ss 0:0:0 -to %extract_starttime% -c:v copy -c:a copy "%extract_data_1%",,hide

if !trim2end {	
	msgbox % "!trim2end"
	extract_data_1=%OutDir%\%OutNameNoExt% - 1st half.%OutExtension%
	extract_data_2=%OutDir%\%OutNameNoExt% - 2nd half.%OutExtension%
	run, %comspec% /c ffmpeg -i "%FullPath%" -ss %extract_endtime% -to %Output_Duration% -c:v copy -c:a copy "%extract_data_2%",,hide
	if Split
		goto Check_Output2
	FileAppend , file '%extract_data_1%'`n, %xtractData_Cc%
	FileAppend , file '%extract_data_2%'`n, %xtractData_Cc%
	sleep, % S
	msgbox spunkl
	runWait, %comspec% /c ffmpeg -y -f concat -safe 0 -i "%xtractData_Cc%" -c copy "%Output_FullUnc%",,hidden
	fileDelete, %extract_data_1%
	fileDelete, %extract_data_2%
	fileDelete, %xtractData_Cc%			;FileRecycle, %FullPath%
}
else Output_FullUnc := extract_data_1
loop {
	if !(playstate := fileexist(Output_FullUnc))
		sleep, 500
	else break
}
if trim2end
	fileMove, %extract_data_1%, %Output_FullUnc%
	
Check_Output2:
sleep, % S
Output_Prefix:=OutNameNoExt
Output_FullUnc=%Input_Filename_Full%\%Output_Prefix%.%OutExtension%
if PreserveFileDate
	fileSetTime, Old_D8, %Output_FullUnc%, m
if replaceoriginal 
	fileRecycle, %FullPath%	;Output_FullUnc := FullPath
settimer, check_3, -2000
return,

check_3:
if !fileExist(FullPath) {
	fileMove, %Output_FullUnc%, %FullPath%
} else {
	if !tried
		tried = 1
	else
		tried := tried+1
	goto Check_Output2
}
return,

Clip_Commander:
if (clipboard!=Monster_Clip) {
	settimer, Clip_Commander, off
	menu, tray, Icon, WMP.ico
}
return,

class RemoteWMP {
	__New() {
		static IID_IOleClientSite := "{00000118-0000-0000-C000-000000000046}"
		, IID_IOleObject := "{00000112-0000-0000-C000-000000000046}"
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
			return,
		DllCall(NumGet(NumGet(this.ole+0)+3*A_PtrSize), "Ptr", this.ole, "Ptr", 0)
		for k, obj in [this.ole, this.ocs, this.rms]
			ObjRelease(obj)
		this.player := ""
	}
 	Jump(sec) {
		try {
			this.player.Controls.currentPosition += sec
		} catch {
			sleep, 50
	}	}
	
 	TogglePause() {
		trigger_PL 	:= False
		trigger_pa	:= False
		NewSong 	=% Media.sourceURL
		newiD3full 	:= iD3_StringGet(NewSong)
		;id3Art 	:= iD3_Artist(NewSong)
		;id3Ttl  	:= iD3_Track(NewSong)
		try
			NewSong =% Media.sourceURL
		catch 
			sleep, 300
		SplitPath, NewSong,,, OutExtension, OutNameNoExt,
		grontle:
		sleep, 250
		try {
			if BellendsonParade := this.player.playState
			switch BellendsonParade {
				case 0:
					Stat3 := "Undefined"
					msgbox % "undefined playstate please mitigate"
				case 1:				
					Stat3 := "Stopped"
					this.player.Controls.play()
					PState(On)
				case 2:				
					Stat3 := "Paused"
					this.player.Controls.play()
					menu, tray, Tip , % newiD3full "`nPlaying"
					tooltip % "Playing..."
					PState(On)
				case 3:				
					Stat3 := "Playing"
					this.player.Controls.pause()
					menu, tray, Tip , % newiD3full "`nPaused"
					tooltip % "Paused..."
					PState(Off)
				case 4:				
					Stat3 := "ScanForward"
					this.player.Controls.Stop()
					sleep, 100
					this.player.Controls.play()
					PState(On)
				case 5:				
					Stat3 := "ScanReverse"
					this.player.Controls.Stop()
					sleep, 100
					this.player.Controls.play()	
					PState(On)
				case 6:				
					Stat3 := "Buffering"
					this.player.Controls.Stop()
					msgbox danger please readme ;if yes 		this.player.Controls.play()
					sleep, 100
					this.player.Controls.play()
					PState(On)
				case 7:				
					Stat3 := "Waiting"				
					TRY						
						this.player.Controls.Stop()
					CATCH
						sleep, 120	
					tooltip % "waiting 4...`nd4ng3r"
					sleep, 100
					TRY
						this.player.Controls.Play()
					CATCH
						sleep, 120	
					this.player.Controls.play()
					PState(On)
				case 8:				
					Stat3 := "MediaEnded"
					this.player.Controls.Stop()
					msgbox % "media ended?"
					this.player.Controls.play()
					PState(On)
				case 9:				
					Stat3 := "Transitioning"
					if !trannys
						Trannys := 1
					else
						trannys := Trannys + 1
					this.player.Controls.Stop()
					sleep, 500
					this.player.Controls.play()
					PState(On)
				case 10:			
					Stat3 := "Ready"
					tooltip READY... Playing
					this.player.Controls.play()
					PState(On)
				case 11:		
					Stat3 := "Reconnecting"
					msgbox % "media ended?`n`nWho cares? Playing anyway you insuferable`nPRICK!!"
					this.player.Controls.Stop()
					sleep, 500
					this.player.Controls.play()		
					PState(On)
				default:
					msgbox % "No playstate, playing anyway"
					this.player.Controls.Stop()
					sleep, 500
					this.player.Controls.play()
					PState(On)
			}
			settimer, tooloff, -1000
		} catch {
			sleep, 500
			goto grontle
}	}	}	

IWMPRemoteMediaServices_CreateInstance() {
	static vtblUnk, vtblRms, vtblIsp, vtblOls, vtblPtrs := 0, size := (A_PtrSize + 4)*4 + 4
	if !VarSetCapacity(vtblUnk) {
		extfuncs := ["QueryInterface", "addRef", "Release"]

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
	 return, pObj
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
		IUnknown_addRef(this_)
		return, 0 ; S_OK
 }

 if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IWMPRemoteMediaServices) {
		off := NumGet(this_+0, A_PtrSize, "UInt")
		NumPut((this_ - off)+(A_PtrSize + 4), ppvObject+0, "Ptr")
		IUnknown_addRef(this_)
		return, 0 ; S_OK
 }

 if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IServiceProvider) {
 off := NumGet(this_+0, A_PtrSize, "UInt")
 NumPut((this_ - off)+((A_PtrSize + 4)*2), ppvObject+0, "Ptr")
 IUnknown_addRef(this_)
 return, 0 ; S_OK
 }

 if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IOleClientSite) {
 off := NumGet(this_+0, A_PtrSize, "UInt")
 NumPut((this_ - off)+((A_PtrSize + 4)*3), ppvObject+0, "Ptr")
 IUnknown_addRef(this_)
 return, 0 ; S_OK
 }

 NumPut(0, ppvObject+0, "Ptr")
 return, 0x80004002 ; E_NOINTERFACE
}

IUnknown_addRef(this_) {
	off := NumGet(this_+0, A_PtrSize, "UInt")
	iunk := this_-off
	NumPut((_refCount := NumGet(iunk+0, (A_PtrSize + 4)*4, "UInt") + 1), iunk+0, (A_PtrSize + 4)*4, "UInt")
	return, _refCount
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
	return, _refCount
}

IWMPRemoteMediaServices_GetServiceType(this_, pbstrType) {
 NumPut(DllCall("oleaut32\SysAllocString", "WStr", "Remote", "Ptr"), pbstrType+0, "Ptr")
 return, 0
}

IWMPRemoteMediaServices_GetScriptableObject(this_, pbstrName, ppDispatch) {
 return, 0x80004001
}

IWMPRemoteMediaServices_GetCustomUIMode(this_, pbstrFile) {
 return, 0x80004001
}

IServiceProvider_QueryService(this_, guidService, riid, ppvObject) {
 return, IUnknown_QueryInterface(this_, riid, ppvObject)
}
return,

InvokeVerb(path, menu, validate=True) {
	objShell := ComObjCreate("Shell.Application")
	if InStr(FileExist(path), "D") || InStr(path, "::{") {
		objFolder := objShell.NameSpace(path) 
		objFolderItem := objFolder.Self
	} else {
		SplitPath, path, name, dir
		objFolder := objShell.NameSpace(dir)
		objFolderItem := objFolder.ParseName(name)
	}
	if validate {
		colVerbs := objFolderItem.Verbs 
		loop % colVerbs.Count {
			verb := colVerbs.Item(A_Index - 1)
			retmenu := verb.name
			StringReplace, retmenu, retmenu, & 
			if (retmenu = menu) {
				verb.DoIt
				return, True
		}	}
		return, False
	} else objFolderItem.InvokeVerbEx(menu)
} 

AppVolume(app:="", device:="") {
	return, new AppVolume(app, device)
}

class AppVolume {
	ISAVs := []
	__New(app:="", device:="") {
		static		IID_IASM2 := "{77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}"
				, 	IID_IASC2 := "{BFB7FF88-7239-4FC9-8FA2-07C950BE9C6D}"
				, 	IID_ISAV  := "{87CE5498-68D6-44E5-9215-6DA47EF883D8}"
		
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
		return, this.SetVolume(this.GetVolume() + Amount)
	}
	
	GetVolume() {
		for k, pISAV in this.ISAVs
		{
			VA_ISimpleAudioVolume_GetMasterVolume(pISAV, fLevel)
			return, fLevel * 100
		}
	}
	
	SetVolume(level) {
		level := level>100 ? 100 : level<0 ? 0 : level ; Limit to range 0-100
		for k, pISAV in this.ISAVs
			VA_ISimpleAudioVolume_SetMasterVolume(pISAV, level / 100)
		return, level
	}
	
	GetMute() {
		for k, pISAV in this.ISAVs
		{
			VA_ISimpleAudioVolume_GetMute(pISAV, bMute)
			return, bMute
	}	}
	
	SetMute(bMute) {
		for k, pISAV in this.ISAVs
			VA_ISimpleAudioVolume_SetMute(pISAV, bMute)
		return, bMute
	}
	
	ToggleMute() {
		return, this.SetMute(!this.GetMute())
	}
	
	GetprocessName(PID) {
		hprocess := DllCall( "Openprocess"
			, "UInt", 0x1000 ; DWORD dwDesiredAccess (process_QUERY_LIMITED_INFORMATION)
			, "UInt", False ; BOOL bInheritHandle
			, "UInt", PID ; DWORD dwprocessId
			, "UPtr" )
		dwSize := VarSetCapacity(strExeName, 512 * A_IsUnicode, 0) // A_IsUnicode
		DllCall( "QueryFullprocessImageName"
			,"UPtr", hprocess ; HANDLE hprocess
			,"UInt", 0 ; DWORD dwFlags
			,"Str", strExeName ; LPSTR lpExeName
			,"UInt*", dwSize ; PDWORD lpdwSize
			,"UInt" )
		DllCall( "CloseHandle", "UPtr", hprocess, "UInt" )
		SplitPath, strExeName, strExeName
		return, strExeName
}	}

; --- V A additions ---
; ISimpleAudioVolume : {87CE5498-68D6-44E5-9215-6DA47EF883D8}
VA_ISimpleAudioVolume_SetMasterVolume(this, ByRef fLevel, GuidEventContext="") {
	return, DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "float", fLevel, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMasterVolume(this, ByRef fLevel) {
	return, DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "float*", fLevel)
}
VA_ISimpleAudioVolume_SetMute(this, ByRef Muted, GuidEventContext="") {
	return, DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "int", Muted, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMute(this, ByRef Muted) {
	return, DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "int*", Muted)
}

SetAcrylic(thisColor, thisAlpha, hWnd) {
	Static init, accent_state := 4,
	Static pad := A_PtrSize = 8 ? 4 : 0, WCA_ACCENT_POLICY := 19
	NumPut(accent_state, ACCENT_POLICY, 0, "int")
	NumPut(0xff4022ff, ACCENT_POLICY, 8, "int")
	VarSetCapacity(WINCOMPATTRDATA, 4 + pad + A_PtrSize + 4 + pad, 0)
	&& NumPut(WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0, "int")
	&& NumPut(&ACCENT_POLICY, WINCOMPATTRDATA, 4 + pad, "ptr")
	&& NumPut(128, WINCOMPATTRDATA, 4 + pad + A_PtrSize, "uint")
	if !(DllCall("user32\SetWindowCompositionAttribute", "ptr", hWnd, "ptr", &WINCOMPATTRDATA))
		return,
}

Receive_WM_COPYDATA(wParam, lParam) {
	Stringaddress := (NumGet(lParam + 2*A_PtrSize)), CopyOfData := (StrGet(Stringaddress))
	settimer, % CopyOfData, -1
}

Pstate(Timers_State="") {
	switch Timers_State {
		case On:
			IconChangeInterval 		:= 	"700"
			PstateUpdateInterval 	:=	"4400"
		case Off:
			IconChangeInterval 		:= 	Off
			PstateUpdateInterval 	:=	"14400"
	}
	settimer, Icon_Alternate, %IconChangeInterval%
	settimer, PlayPstateUpdateInterval, %PstateUpdateInterval%
}

Open_Containing:
if !WMP {
	WMP := new RemoteWMP
}
Media := WMP.player.currentMedia
UNC = % Media.sourceURL
o:=comobjcreate("Shell.Application")
SplitPath,UNC,file,directory,ext
if !errorlevel {
	od:=o.namespace(directory)
	of:=od.parsename(file)
	gnr:=od.getdetailsof(of,16) 				;16 = genre
}
Controls := WMP.player.Controls
SplitPath, UNC,, OutDir, OutExtension, OutNameNoExt, OutDrive
sleep, 250
1st := (RegExReplace(UNC, "^.+\\|\.[^.]+$")), 2nd := RegExReplace(1st, "[']|[`]|[)]|[(]|[_]|( )|( )|(YouTube)", " "), clipboard := RegExReplace(2nd, Needle3, " ") ;"( . )|( )|( )|( )"
run %COMSPEC% /c explorer.exe /select`, "%UNC%",, Hide
sleep, %S%
sendInput {F5}
UNC:="", 1st:="", 2nd:=""
return,

xtractmenu_open:
if !Secs2Sample_Start {
	Secs2Sample_Start := "0"
	msgbox undefined region
}
settimer, GUI_, -1
return,
 
FIXW:
if !hundle 
	hundle 	:=	gethandle()
sleep, 500
s:=gethandle2("ToolbarWindow323") 
			SendMessage 0x0454, 0, 0x00000089,, ahk_id %s% 	 ; TB_SETEXTENDEDSTYLE=0x0454 tbstyle_Ex_doublebuffer 0x80

f:=gethandle2("ToolbarWindow324") 
			SendMessage 0x0454, 0, 0x00000089,, ahk_id %f%
;tooltip % "Opacity tempfix applied`nfuck off "
SetAcrylic(0x000000, 255, ahk_id %hundle%)

settimer, tooloff, -3000
return,

SLsk_Rescue:
run % SLsk_Rescue
return,

Restart_WMP:
WMP := new RemoteWMP
sleep, % S
Media := WMP.player.currentMedia, Path2File:=Media.sourceURL, Controls := WMP.player.Controls, time:=round(controls.currentPosition)
run taskkill /F /IM WMPlayer.exe 
sleep, % S
sleep, % S
run WMPlayer.exe "%Path2File%"
sleep, % S
reload

togl_numpad:
togl_numpad := !togl_numpad
togl_numpad_i:

if togl_numpad {
	menu, tray, check, Disable Numpad
	if !num_init_trigger {
		num_init_trigger := True
		loop 10 {
			aa := (a_index-1)
			Loop Parse, numpad_blacklist, `,
			{
				Hotkey, IfWinActive, % A_LoopField
				Hotkey, % "Numpad" . aa, zz
				numpadkeys_str := (numpadkeys_str . "," . "Numpad" . aa)
				NumPKeysArr.Push("Numpad" . aa)
		}	}
		Loop Parse, num_others, `,
		{
			bb := A_LoopField
			Loop Parse, numpad_blacklist, `,
			{
				Hotkey, IfWinActive, % A_LoopField
				Hotkey, % bb, zz
				numpadkeys_str := (numpadkeys_str . "," . bb)
				NumPKeysArr.Push(bb)	
		}	}
	} else {
		for index, element in NumPKeysArr
			Hotkey, % element, zz
	}
} else {
	menu, tray, uncheck, Disable Numpad
	if !num_init_trigger {
		num_init_trigger := True
		loop 10 {
			cc := (a_index-1)
			Loop Parse, numpad_blacklist, `,
				Hotkey, IfWinActive, % A_LoopField
				Hotkey, % "Numpad" . cc, zz
				numpadkeys_str := (numpadkeys_str . "," . "Numpad" . cc)
				NumPKeysArr.Push("Numpad" . cc)
		}
		Loop Parse, num_others, `,
		{
			Loop Parse, numpad_blacklist, `,
				Hotkey, IfWinActive, % A_LoopField
				Hotkey, % A_LoopField, zz
				numpadkeys_str := (numpadkeys_str . "," . A_LoopField)
				NumPKeysArr.Push(A_LoopField)	
		}
	} else {
		for index, element in NumPKeysArr
			Hotkey, %element%, off
}	}
return,

zz:
TOOLTIP FGS
bt := a_thishotkey
if (bt contains "$" &&  bt != $)
	bt := strreplace(	bt, "$") 
if (bt contains "^" &&  bt != $)
	bt := strreplace(	bt, "^", "Control + ")
if (bt contains "!" &&  bt != $)	
	bt := strreplace(	bt, "!", "Alt + ")
TT((bt . " Disabled.")) 
return,


ZinOut: 				; 		midi in out script
a = "C:\Program Files\AutoHotkey\AutoHotkeyU32.exe" "C:\Script\AHK\Z_MIDI_IN_OUT\z_in_out.ahk"
run % a,,hide
return,

PlayPstateUpdateInterval: 					; 		wip
playstate	:=
sleep, 		200
WMP 		:= 	new RemoteWMP
Media 		:= 	WMP.player.currentMedia
NewSong 	=% 	Media.sourceURL
playstate 	:= 	WMP.player.playState
sleep, 		300
	
IF (OLDSONG != 	NewSong) {
	trigger_PL 	:= 	False
	trigger_pa	:= 	False
	newiD3full 	:= 	iD3_StringGet(NewSong)
	id3Art 		:= 	iD3_Artist(NewSong)
	id3Ttl  	:= 	iD3_Track(NewSong)
	oldsong 	:= 	NewSong
	SplitPath, 	NewSong,,, OutExtension, OutNameNoExt
	if pastenonext {
		pastenonext := False
		iD3full := iD3full2
		real_pos := real_pos - 1
		sleep 700
		goto POST_GASM
}	} 

ps1212:
try
	playstate := WMP.player.playState
catch {
	sleep, 900 
	goto ps1212
}
if (playstate = 3) { ; Playing = 3
	trigger_pa	:= 	False
	if !trigger_PL {
		trigger_PL := True	
		Pstate(On)
		sleep, 100
		trayTip, % id3Art " - " id3Ttl, % "WMP Now-Playing", 3, 33
		menu, tray, Tip, % "Windows Media Player - Playing`n" 	newiD3full
		OLDSONG := NewSong
	}
} else {
	if (playstate = 2 or playstate = 1) {
		trigger_PL 	:= 	False
		if !trigger_pa {
			trigger_pa 	:= 	True
			PState(Off)
			trayTip, % id3Art " - " id3Ttl, % "WMP Paused", 3, 33
			menu, tray, Tip, % "Windows Media Player - Paused`n" newiD3full
}	}	}
return,

Icon_Alternate: ; if (A_TimeIdle < (420000 - 1000)) {
if !IconAlternateEnabled && trigger_PL {
	Try
		menu, tray, Icon, % ic1,
	Catch
		goto Errormsg		
	IconAlternateEnabled := True
} else {
	if trigger_PL {
		Try
			menu, tray, Icon, % ic2,
		Catch
			goto Errormsg
		IconAlternateEnabled := False
	} 
	else settimer, Icon_Alternate, off
}
return,

CursorReset:
DllCall("SystemParametersInfo", "uint", SPI_SetCurSORS := 0x57, "uint", 0, "ptr", 0, "uint", 0)
return,

AniCur_:
setcur(%cur_%)
return,

SetCur(image_unc="") {
	SetSystemCursor(image_unc)
	sleep, 300
	RestoreCursor()
} 

Nowplayinglist_delcurrent:
WMP8 		:= 	new remotewmp 
Media 		:= 	WMP8.player.currentMedia
Controls 	:= 	WMP8.player.Controls
oldsong 	=% 	Media.sourceURL
SplitPath, oldsong ,,,, iD3full
id3full3 	:= 	iD3_StringGet2(oldsong)
if !hundle
	hundle 	:=	gethandle()
SendMessage, 0x1004, 0, 0,, ahk_id %hundle% 				; LVM_GETITEMCOUNT=0x1004
suck:
wmplist 	:= 	ErrorLevel
real_pos 	:= 	getpos()
POST_GASM:

if !real_pos {
	cntt += 1
	tooltip, % "e   p    o f in s" ; init issue
	sleep, 500
	if cntt < 9
		goto Nowplayinglist_delcurrent
}
	
else {
	SendMessage 0x1008, real_pos, 0,,  ahk_id %hundle% 	; delete
	sleep, 50
	SendMessage 0x1004, 0, 0,, ahk_id %hundle% 			; LVM_GETITEMCOUNT=0x1004
	wmplistnew := ErrorLevel
	if (wmplistnew = wmplist)
		msgbox, % "Error Deleting"
	tracklist.pop(array_pos)
	
	if godie {
		godie 	:= 	False
		WMP8 	:= 	delete RemoteWMP
		goto 	Delete_
	}	
	if pastenskip
		Pastenskip := False
}
Pstate("On")
return,

pastenonext: 											; 	these are all lazy and almost the same work
WMP8 		:= 	new RemoteWMP
sleep, 		80
pastenonext := 	True
Media 		:= 	WMP8.player.currentMedia
oldsong 	=% 	Media.sourceURL
id3full2 	:= 	iD3_StringGet2(oldsong)
return,

godie:		;		main delete entry point				; 	these are all lazy and almost the same work
godie 		:= 	True
pastenskip:
if !godie
	pastenskip 	:= 	True 	; 	you lazy bastard, Matt
WMP8 		:= 	new RemoteWMP
sleep, 		80
WMP2del 	:= 	WMP8
Media 		:= 	WMP8.player.currentMedia
File2Del 	=% 	Media.sourceURL
SplitPath, 	File2Del ,, , , iD3full2,
Controls 	:= 	WMP8.player.Controls
oldsong 	=% 	Media.sourceURL
id3Art2 	:= 	iD3_Artist(oldsong)
id3Ttl2  	:= 	iD3_Track(oldsong)
id3full 	:= 	iD3_StringGet2(oldsong)N
id3full3 	:= 	id3full
goto jumpnext
return,

gethandle() 	{
	WinGet, LL, List, ahk_class WMP Skin Host 
	loop %LL% 	{
		va := LL%a_index%
		sleep 40
		winGet, Style, Style, ahk_id %va%
		winGet, ExStyle, ExStyle, ahk_id %va%
		if (style = 0x16CF0000 && exstyle = 0x000C0100 ) {
			ControlGet, hundl, Hwnd,, SysListView321, % "ahk_id " . va
			if 	 !hundl
				 return, false
			else return, hundl		
}	}	}


gethandle2(cname) 	{
	WinGet, LL, List, ahk_class WMP Skin Host 
	loop %LL% 	{
		va := LL%a_index%
				ControlGet, hundl, Hwnd,, %cname%, % "ahk_id " . va
				}
			if 	 !hundl
				 return, false
			else return, hundl		
}	

getpos() {
	id3fullstr 		:= 	iD3_StringGet2(NewSong)
	if 	!id3fullstr
		id3fullstr 	:= 	iD3_StringGet2(oldsong)

	ControlGet 	ItemList, List,,, ahk_id %hundle%
	if 	!itemlist {
		tooltip no list 
		settimer, TOOLOFF, -300
	}
	Loop Parse, ItemList, `n
	{
		Items := StrSplit(A_LoopField, A_Tab)
		;tooltip % items
		tracklist[A_Index] := Items[1]
		if tracklist[A_Index] = id3fullstr                             
			real_pos := A_Index - 1
	}	
	WMP4 := 	delete remotewmp 
	if	 !real_pos
		 return, false
	else return, real_pos
}

#w::
s:=gethandle2("ToolbarWindow323") 
			postmessage, 0x0454, 0, 0x00000089,, ahk_id %s% 	 ; TB_SETEXTENDEDSTYLE=0x0454 tbstyle_Ex_doublebuffer 0x80
tooltip % S
f:=gethandle2("ToolbarWindow324") 
			postMessage, 0x0454, 0, 0x00000089,, ahk_id %f%
			return,
init_menu:
; Iconz := []
; Iconz.Push(LoadPicture(a_scriptDir . "\WMP.ico"))
icondll 	:= 		a_scriptDir . "\icons.dll"
menu, 	tray, color, 	080032
menu, 	tray, Icon, 	C:\Script\AHK\Z_MIDI_IN_OUT\wmp2.ico
menu, 	tray, noStandard
menu, 	tray, MainWindow
menu, 	tray, add, 		Open script location, Open_ScriptDir
menu, 	tray, icon, 	Open script location, % icondll , 7
menu, 	tray, add, 		Open Extract window, xtractmenu_open
menu, 	tray, icon, 	Open Extract window, % icondll , 5
menu, 	tray, add, 		Restart Windows Media Player, Restart_WMP,
menu, 	tray, icon, 	Restart Windows Media Player, % icondll , 12
menu, 	tray, add, 		Pause, PauseToggle,
menu, 	tray, add, 		Prev, JumpPrev
menu, 	tray, add, 		Next, JumpNext
menu, 	tray, add, 		Open media location, Open_Containing,
menu, 	tray, icon, 	Open media location, % icondll , 7
menu, 	tray, add, 		delete, godie
menu, 	tray, icon, 	delete, C:\Icon\Red_Check_Mark_PNG_Clipart-20269534423.ico,
menu, 	tray, add, 		Cut, CutCurrent
menu, 	tray, icon, 	cut, C:\Icon\24\cut24.ico
menu, 	tray, add, 		search explorer, SearchExplorer, 
menu, 	tray, icon, 	search explorer, C:\Icon\20\search (2).ico
menu, 	tray, add, 		search alternative on sLsK, CopySearchSlSk
menu, 	tray, icon, 	search alternative on sLsK, C:\Icon\24\slsk24.ico
menu, 	tray, add, 		search Youtube, SearchYT
menu, 	tray, icon, 	search Youtube, YouTube.ico,
menu, 	tray, add, 		FIX_WHITEPLAYLIST, FIXW
menu, 	tray, icon, 	FIX_WHITEPLAYLIST, C:\Icon\20\picklink - Copy.bmp
menu, 	tray, add, 		Run midi_in_out, ZinOut
menu, 	tray, icon, 	Run midi_in_out, C:\Icon\24\whistler_run_2.ico
menu, 	tray, add, 		Rescue SLSk window, SLsk_Rescue,
menu, 	tray, icon, 	Rescue SLSk window, %icondll% , 8
menu, 	tray, add, 		Sound CPL, scpl,
menu, 	tray, icon, 	Sound CPL, % icondll ,9 
menu, 	tray, add, 		Disable Numpad, togl_numpad
if togl_numpad 
		menu, tray, check, 		Disable Numpad
else 	menu, tray, uncheck, 	Disable Numpad
menu, 	tray, Standard
return,

scpl:
runwait %COMSPEC% /C %scpl%,, hide
return,

varz:
global DBGTT, tt, togl_numpad, aa, bb, cc, hHeader, cur_, scpl, iconz, godie, pastenskip, numpadkeys_str, PRE_GASM, Stat3, IconChangeInterval, PstateUpdateInterval, iD3full2, num_init_trigger, pastenonext, iD3full, WinTitle, WMPConv, WMP2del, Media2del, trigger_pa, submittedok, wmplistnew, wmplist, PlayPstateUpdateInterval, hundle, real_pos, retries, tracklist, deletearr, NumPKeysArr, num_others, S, Play, Stop, Prev, Next, Pause, Vol_Up, Search_Root, Genre, Vol_Down, WMP, Media, Controls, File2Del, oldsong, playstate, NewSong, Path2File, path2paste, gnr, choice, Output_FullUnc, real_poswmplist, wmplistnewtracklist, godiepastenskip, WMP2del, Media, File2Del, Controls, oldsong, id3Art2, id3Ttl2, id3full, id3full3, id3full2, 

global myDoxdir, MyIconsdir, AniCurPrefix, AniCur_fprint, AniCur_hand, AniCur_Munch, AniCur_Apple, AniCur_banana, AniCur_COFFEE, AniCur_Pink, AniCur_Pian, AniCur_Mnote, AniCur_Vial, AniCur_swords, AniCur_cs, AniCur_city, AniCur_Cogs, AniCur_Clock, AniCur_StopWatch, AniCur_Shutter, AniCur_Camera, AniCur_prop, AniCur_TV, AniCur_mon, AniCur_pingpong, AniCur_peace, AniCur_Plane, AniCur_pred, AniCur_DINOSAUR, AniCur_horse, AniCur_jellyf, AniCur_wasp, AniCur_roach, AniCur_bfly, AniCur_flower, AniCur_flowerz, AniCur_tree, AniCur_Frozen, AniCur_Drip, AniCur_umbr, AniCur_sun, AniCur_1664, AniCur_plasmab, AniCur_pyra, AniCur_tri, AniCur_tric, AniCur_triG, AniCur_palette, AniCur_sheet, AniCur_lbolt, AniCur_wvain, AniCur_rocket, AniCur_orbit, AniCur_95busy1, AniCur_95busy2

togl_numpad :=  True
DBGTT       :=  True
S           :=  2000 ;; sleep, Time (ms)
tt 		    :=  500
CHKBX_H     :=  "h15"

c0nda 		:=  ("C:\Users\" . A_UserName . "\anaconda3")
scpl 		:=  (("" "C:\Windows\system32\rundll32.exe" "") . (" shell32.dll,Control_RunDLL mmsys.cpl,,playback"))
SLsk_Rescue :=  "C:\Script\AHK\Z_MIDI_IN_OUT\slsk_rescue.ahk",
ytsearchstr	:=  "https://www.youtube.com/results?search_query="
Needle3 	:=  "( . )|(^[a-z][\s])|( )|( )|( )|[.]"
Needle2 	:=  "i)(\s[a-z]{1,2}\s)"
xtractData_Cc	:=	"c:\out\temp.txt" 
Needle4     :=	"i)[1234567890.'`)}{(_]|(-khz)(rmx)|(remix)|(mix)|(refix)|(vip)|(featuring)|( feat)|(ft)|(rfl)|(-boss)(-sour)|(its)|(it's)|(-)|(-bpm)|(edit)" 
Genres      :=	"i)(dnb)|(Drum & Bass)|(reggae)|(riddim)|(hiphop)|(garage)|(rock)|(ambient)|(samples)|(my music)|(audiobooks)|(sLSk)|(FOAD)"
num_others  :=  "NumLock,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter,NumpadPgDn,NumpadEnd,NumpadHome,NumpadClear,NumpadDel,NumpadIns,NumpadUp,NumpadLeft,NumpadRight,NumpadDown"
tracklist 	:= 	[]
deletearr 	:= 	[]
NumPKeysArr := 	[]
AutoScroll	:= 	False
On 			:= 	"On"
Off 		:= 	"Off"
trigger_PL 	:= 	False
tvmX 		:= 	0x112C
ic1			:= 	"WMP.ico"
ic2			:= 	"WMP2.ico"
splitstr 	:= 	"Split @ a)"	
del2endstr 	:= 	"Delete to end"
Play := 0x2e0000, Stop := 18809, Prev := 18810, Next := 18811, Pause := 32808, Vol_Up := 32815, Vol_Down = 32816, Offset_Start := 4, retries := 1

myDoxdir         :=  "d:\Documents\"
MyIconsdir       :=  myDoxdir . "My Pictures\Icons\"
AniCurPrefix     :=  ( MyIconsdir . "- CuRS0R\_ ANi\" )
AniCur_fprint	 :=	 ( AniCurPrefix . "MY_BUSY.ANI" )
AniCur_hand		 :=	 ( AniCurPrefix . "HAND.ANI" )
AniCur_Munch	 :=	 ( AniCurPrefix . "CY_04BUS.ANI" )
AniCur_Apple	 :=	 ( AniCurPrefix . "APPLE.ANI" )
AniCur_banana	 :=	 ( AniCurPrefix . "BANANA.ANI" )
AniCur_COFFEE	 :=	 ( AniCurPrefix . "COFFEE.ANI" )
AniCur_Pink		 :=	 ( AniCurPrefix . "OU.ani" )
AniCur_Pian		 :=	 ( AniCurPrefix . "PIANO.ANI" )
AniCur_Mnote	 :=	 ( AniCurPrefix . "JA_01NOR.ANI" )
AniCur_Vial		 :=	 ( AniCurPrefix . "SC_WAIT.ANI" )
AniCur_swords	 :=	 ( AniCurPrefix . "CS_01NOR.ANI" )
AniCur_cs		 :=	 ( AniCurPrefix . "cursor_busy.ANI")
AniCur_city		 :=	 ( AniCurPrefix . "CS_04BUS.ANI" )
AniCur_Cogs		 :=	 ( AniCurPrefix . "MO_WAIT.ANI" )
AniCur_Clock	 :=	 ( AniCurPrefix . "TR_BUSY.ANI" )
AniCur_StopWatch :=	 ( AniCurPrefix . "WI_04BUS.ANI" )
AniCur_Shutter	 :=	 ( AniCurPrefix . "CP_04BUS.ANI" )
AniCur_Camera	 :=	 ( AniCurPrefix . "WO_04BUS.ANI" )
AniCur_prop		 :=	 ( AniCurPrefix . "TR_WAIT.ANI" )
AniCur_TV		 :=	 ( AniCurPrefix . "TV.ANI" )
AniCur_mon		 :=	 ( AniCurPrefix . "PC_BUSY.ANI" )
AniCur_pingpong	 :=	 ( AniCurPrefix . "SC_WAIT.ANI" )
AniCur_peace	 :=	 ( AniCurPrefix . "SX_BUSY.ANI" )
AniCur_Plane	 :=	 ( AniCurPrefix . "WO_01NOR.ANI" )
AniCur_pred		 :=	 ( AniCurPrefix . "pred.ANI" )
AniCur_DINOSAUR	 :=	 ( AniCurPrefix . "DINOSAUR.ANI" )
AniCur_horse	 :=	 ( AniCurPrefix . "HORSE.ANI" )
AniCur_jellyf	 :=	 ( AniCurPrefix . "DA_BUSY.ANI" )
AniCur_wasp		 :=	 ( AniCurPrefix . "DA_WAIT.ANI" )
AniCur_roach	 :=	 ( AniCurPrefix . "NA_BUSY.ANI" )
AniCur_bfly		 :=	 ( AniCurPrefix . "bfly.ANI" )
AniCur_flower	 :=	 ( AniCurPrefix . "NA_WAIT.ANI" )
AniCur_flowerz	 :=	 ( AniCurPrefix . "SX_WAIT.ANI" )
AniCur_tree		 :=	 ( AniCurPrefix . "FL_01NOR.ANI" )
AniCur_Frozen	 :=	 ( AniCurPrefix . "froz.ANI" )
AniCur_Drip		 :=	 ( AniCurPrefix . "DB_04BUS.ANI" )
AniCur_umbr		 :=	 ( AniCurPrefix . "FA_01NOR.ANI" )
AniCur_sun		 :=	 ( AniCurPrefix . "GA_04BUS.ANI" )
AniCur_1664		 :=	 ( AniCurPrefix . "ALLSEEING.ANI" )
AniCur_plasmab	 :=	 ( AniCurPrefix . "SC_BUSY.ANI" )
AniCur_pyra		 :=	 ( AniCurPrefix . "GE_04BUS.ANI" )
AniCur_tri		 :=	 ( AniCurPrefix . "GE_01NOR.ANI" )
AniCur_tric		 :=	 ( AniCurPrefix . "RO_04BUS.ANI" )
AniCur_triG		 :=	 ( AniCurPrefix . "AR_04BUS.ANI" )
AniCur_palette	 :=	 ( AniCurPrefix . "DV_WAIT.ANI" )
AniCur_sheet	 :=	 ( AniCurPrefix . "JA_04BUS.ANI" )
AniCur_lbolt	 :=	 ( AniCurPrefix . "RO_01NOR.ANI" )
AniCur_wvain	 :=	 ( AniCurPrefix . "PD_01NOR.ANI" )
AniCur_rocket	 :=	 ( AniCurPrefix . "SF_01NOR.ANI" )
AniCur_orbit	 :=	 ( AniCurPrefix . "SF_04BUS.ANI" )
AniCur_95busy1	 :=	 ( AniCurPrefix . "WH_BUSY.ANI" )
AniCur_95busy2	 :=	 ( AniCurPrefix . "WI_BUSY.ANI" )
return,

Open_ScriptDir()

