#NoEnv 		
#Persistent 		
#singleinstance force
#Include VA.ahk
#inputlevel 1
sendMode Input
;SetBatchLines -1
CoordMode window, screen
SetWorkingDir %A_ScriptDir% 

global iconz
icondll := a_scriptDir . "\icons.dll"
Iconz := []
Iconz.Push(LoadPicture(a_scriptDir . "\wmp.ico"))
Iconz.Push(LoadPicture(a_scriptDir . "\wmp2.ico"))
Menu, Tray, color, 080032
Menu, Tray, Icon, % "HBITMAP:*" Iconz.1
Menu, Tray, noStandard
Menu, Tray, MainWindow
Menu, Tray, Add, 	Open script location, Open_ScriptDir,
Menu, Tray, icon, 	Open script location, % icondll , 7
Menu, Tray, Add, 	Open Extract window, Open_xtractfrommenu,
Menu, Tray, icon, 	Open Extract window, % icondll , 5
Menu, Tray, Add, 	Restart Windows Media Player, Restart_WMP,
Menu, Tray, icon, 	Restart Windows Media Player, % icondll , 12
Menu, Tray, Add, 	Pause, WMP_Pause,
Menu, Tray, Add, 	Prev, WMP_Prev,
Menu, Tray, Add, 	Next, WMP_next ,
Menu, Tray, Add, 	Open media location, Open_Containing,
Menu, Tray, icon, 	Open media location, % icondll , 7
Menu, Tray, Add, 	delete, DelCurrent,
Menu, Tray, Add, 	cut, CutCurrent,
Menu, Tray, Add, 	search explorer, SearchExplorer,
Menu, Tray, Add, 	search alternative on sLsK, CopySearchSlSk,

Menu, Tray, icon, 	delete, C:\Icon\Red_Check_Mark_PNG_Clipart-20269534423.ico,


menu, tray, add, Launch midi_in_out, zinout

Menu, Tray, Add, 	Rescue SLSk window, slskrescue,
Menu, Tray, icon, 	Rescue SLSk window, %icondll% , 8
Menu, Tray, Add, 	Sound CPL, scpl,
Menu, Tray, icon, 	Sound CPL, % icondll ,9 

Menu, Tray, Standard

scpl1= "C:\Windows\system32\rundll32.exe", scpl2 := " shell32.dll,Control_RunDLL mmsys.cpl,,playback", scpl := (scpl1 . scpl2)
global WMP, 	global Media, 	global Controls, 	global gnr, 	global choice, 	global newsong, 	global del2endstr := "Delete to end", 	global checkbox_Height := "h15", 	global splitstr := "Split @ a)", 	global submittedok, 	global Genres:="i)(dnb)|(reggae)|(riddim)|(hiphop)|(garage)|(rock)|(ambient)|(samples)|(my music)|(audiobooks)|(sLSk)|(FOAD)", 	Global Needle4:="i)[1234567890.'`)}{(_]|(-khz)(rmx)|(remix)|(mix)|(refix)|(vip)|(featuring)|( feat)|(ft)|(rfl)|(-boss)(-sour)|(its)|(it's)|(-)|(-bpm)|(edit)", 	Global Needle2:="i)(\s[a-z]{1,2}\s)", 	Global Needle3:="( . )|(^[a-z][\s])|(    )|(   )|(  )|[.]", 	Global StartPos_Offset:=0, 	Global StartPos_Offset := 4, 	Global Search_Root:="", 	Global Genre:="", Con_Cat_N_8:="c:\out\temp.txt",c0nda := ("C:\Users\" . A_UserName . "\anaconda3"), 	global TURDS2 := (a_scriptDir . "\wmp2.ico"), 	global TURDS1 := ( a_scriptDir . "\wmp1.ico"), slskrescue := "C:\Script\AHK\Z_MIDI_IN_OUT\slsk_rescue.ahk"

global S := 2000 ;; Sleep Time (ms)
if fileexist(c0nda)
	ANACONDA := True
;VARs::::::::::::;
Stop:=18809, Play:=0x2e0000, Paused:=32808, Prev:=18810, Next:=18811, Vol_Up:=32815, Vol_Down:=32816 ;Paused=18808     
; Loop 2
   ; DllCall( "ChangeWindowMessageFilter", uInt, "0x" (i:=!i?49:233), uint, 1)
;sleep, 30
sleep, 150
process exist, ahk_exe WMPlayer.exe
if Errorlevel, 
	runwait "C:\Program Files\Windows Media Player\wmplayer.exe"
run wmp_colour_control_test.ahk
WMP := new RemoteWMP
sleep, 150
WinTitle := "Windows Media Player"
sleep, 150
Media := WMP.player.currentMedia
sleep, 150
Controls := WMP.player.Controls
sleep, 150
cur =% Media.sourceURL
SplitPath, cur , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	if (WMP.player.playState = 3)  ; Playing = 3
	Menu, Tray, Tip, % "Windows Media Player - Playing`n" 			OutNameNoExt
	else Menu, Tray, Tip, % "Windows Media Player - Paused`n" 	OutNameNoExt
trayTip, Windows Media Player, % OutNameNoExt
settimer playstatetimer, 6000

onexit() {  
	fileDelete, %Con_Cat_N_8%
}
;newsong= % Media.sourceURL
OnMessage(0x4a, "Receive_WM_COPYDATA")  ; 0x4a is WM_COPYDATA
anus := WMP.player.playState
if anus = 3
	setTimer Icon_Alternate, 700  
return

volup:
postMessage, 0x111, vol_up, 0, ,%WinTitle% 	
return
VolDn:
postMessage,  0x111, vol_down, 0, ,%WinTitle%
return
;		ALTgr + PAGE UP 	; 	Volume DOWN	
return

scpl:
runwait %COMSPEC% /C %scpl%,, hide
return

converter:
WMP := new RemoteWMP
sleep, 20
Media := WMP.player.currentMedia
Controls := WMP.player.Controls
sleep, 20
FullPath:=Media.sourceurl

SplitPath, FullPath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
if !Secs2Sample_Start { ;get start time 
	if Secs2Sample_Start:=round(controls.currentPosition)
		Sample_start_min:= Floor(Secs2Sample_Start/60) 
	else {
		Secs2Sample_Start:="0" ;  set start time 0 when it will not be correctly detected by control.current
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
	gosub reg_read
	
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

	gui, xtract:new , , FFMpeg Process
	gui +HwndQuestionHwnd +LastFound 
	gui, xtract:Add, DropDownList, w82 x34 vChoice, %Choices%
	if Secs2Sample_Start
			splitstr := "Split @ " . Sample_start_min . ":" . Sample_start_Sec
			if splitdef {
		gui, xtract:Add, checkbox, %checkbox_Height% vSplit +checked, %splitstr%
	} else
		gui, xtract:Add, checkbox, %checkbox_Height% vSplit, %splitstr%
	If (DefaultChoice = "Extract region") {
		gui, xtract:Add, checkbox,%checkbox_Height% w180 vtrim2end, % "Xtract " . Sample_start_min . ":" . Sample_start_Sec . " - end"
						if Sample_start_Sec
					GuiControl, Text, trim2end , % "Xtract " . Sample_start_min . ":" . Sample_start_Sec . " - end"
				else
					GuiControl, Text, trim2end , % "Xtract - end"		
					}
	else If (DefaultChoice = "Delete region") 
		gui, xtract:Add, checkbox, %checkbox_Height% w180 vtrim2end, % "Crop " . Sample_start_min . ":" . Sample_start_Sec . " - end"
	else 
		gui, xtract:Add, checkbox, %checkbox_Height% vtrim2end +disabled, %del2endstr%
	if trim2enddef 
		GuiControl, , vtrim2end,1
	if PreserveDef
		gui, xtract:Add, checkbox, %checkbox_Height% vPreserveFileDate +checked, Preserve Date
	else
		gui, xtract:Add, checkbox, %checkbox_Height% vPreserveFileDate, Preserve Date
	if replaceDef
		gui, xtract:Add, checkbox, %checkbox_Height% vreplaceoriginal +checked, Replace original
	else
		gui, xtract:Add, checkbox, %checkbox_Height% vreplaceoriginal, Replace original
	gui, xtract:Add, checkbox, %checkbox_Height% vSave +disabled,Save as default 		; 		would be better 2 appear only after any new selection is made in DropDownList
	gui, xtract:Add, Button,  x35 Default gPerform w80, OK  (Enter)
	gui, xtract:Add, Button, x35 w80 gCancel, Cancel  (Esc)
	gui, xtract:Show , w151 Center, FFMpeg Process
	gui, Submit , NoHide
	sleep 1000
	ActiveHwnd := WinExist("A")
	Choice_old := Choice
	trim2end_old := trim2end
	PreserveFileDate_old := PreserveFileDate, 	replaceoriginal_old := replaceoriginal, 	Split_old := Split
	loop {
		if (choice != choice_old) || (trim2end != trim2end_old) || (PreserveFileDate != PreserveFileDate_old) || (replaceoriginal != replaceoriginal_old) || (Split != Split_old) {
				if (Split != Split_old) and Split {
					GuiControl, Text, Split , %splitstr%
					GuiControl, enable, trim2end
				}		
				if (trim2end != trim2end_old) and trim2end {
					GuiControl, enable, Split
					GuiControl, Text, Split , %splitstr%
					GuiControl, Text, trim2end , %del2endstr%
				} 
			If (choice != choice_old)
				GuiControl, Enable, Save
			
			If ((choice = "Extract vox") || (choice = "Extract inst")) {
				GuiControl, disable, replaceoriginal
				if Sample_start_Sec
					GuiControl, Text, trim2end , % "Xtract " . Sample_start_min . ":" . Sample_start_Sec . " - end"
				else
					GuiControl, Text, trim2end , % "Xtract - end"		 
			} else 
				GuiControl, enable, replaceoriginal

			If (choice != choice_old) and (choice = "Extract region") {
				GuiControl, Enable, trim2end
				if Sample_start_Sec
					GuiControl, Text, trim2end , % "Xtract " . Sample_start_min . ":" . Sample_start_Sec . " - end"
				else
					GuiControl, Text, trim2end , % "Xtract - end"		

				GuiControl, Text, Split , %splitstr%
				GuiControl, enable, Split
			}
			If (choice != choice_old) and (choice = "Delete region") {
				GuiControl, Enable, trim2end
				if Sample_start_Sec
					GuiControl, Text, trim2end, % "Crop " . Sample_start_min . ":" . Sample_start_Sec . " - end"
				else
					GuiControl, Text, trim2end, % "Crop - end"
				GuiControl, Text, Split , %splitstr%
				GuiControl, enable, Split
			}	
			if trim2end 
				GuiControl, disable, Split
			else 
			if !trim2end
				GuiControl, enable, Split
			if Split
				GuiControl, disable, trim2end
			else
			if !Split
				GuiControl, enable, trim2end
			Choice_old := Choice, trim2end_old := trim2end, PreserveFileDate_old := PreserveFileDate, replaceoriginal_old := replaceoriginal, Split_old := Split
		}
		sleep 10
		Gui, Submit , NoHide
		if submittedok {
			submittedok := False
			break
		}
		if !ActiveHwnd2 := WinExist("ahk_id " . ActiveHwnd)
			break
	}

return
	xtractGuiClose:
xtractGuiEscape:
Gui, xtract:destroy
submittedok := True
settimer Xtract_Cleanup, -1 
return
}

OnMessage(0x200, "Help")
return

fucktrim:
tooltip wtf
return

	Xtract_GuiClose: ;
	submittedok := True
	gui, Destroy
	return

	Xtract_Cleanup:
	Secs2Sample_End := "", Secs2Sample_Start := "", Output_Filename_Full := "", Input_Filename_Full := "", Output_Prefix := "", 
	;choice := "", replaceoriginal:= "", trim2end := "", PreserveFileDate := ""
	return
	
	trim2end:
	trim2end:= !trim2end
	gui, Add, checkbox, vSave ,Save as default 	
	Gui, Submit , NoHide
	return
	
	Split:
	Split	:=	!Split
	return

	PreserveFileDate:
	PreserveFileDate := !PreserveFileDate
	return

	replaceoriginal:
	replaceoriginal := !replaceoriginal
	return

	Cancel:
	tooltip cancelling
		submittedok := True

	settimer tooloff, -1500
	settimer Xtract_Cleanup, -1
	;setTimer Icon_Alternate, off
	gui, destroy
	return

	Perform:
	submittedok := True
	global needL := "i)(?:Extracted)(?:[ ])[0-9]"
	gui, submit
	gui, Destroy 
	inichoice := choice
	if Save 
		settimer reg_write, -1
	Secs2Sample_Start :=
	If (choice = "Extract region") 
	
		process_Action := "-t", process_Type 		:= "Extracted" 
	else If (Choice = "Delete region")
		process_Action := "-to", process_Type 	:= "Trimmed"
		else if (Choice = "Extract vox")
			process_Action := "-t", process_Type 	:= "Extracted Vox" 
		else if (Choice ="Extract inst" )
			process_Action := "-t", process_Type 	:= "Extracted Instrumental" 

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
	;	SplitPath, Output_Filename_Full , , , , Output_Prefix
		SplitPath, Output_Filename_Full , OutFN, OutFDir, OutFExt, Output_Prefix, OutFDrive
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
		FirstHalf=%OutDir%\%OutNameNoExt% - 1st half.%OutExtension%
		if instr(OutNameNoExt, "Trimmed")
			Output_Filename_Full=%OutDir%\%OutNameNoExt%.%OutExtension%
		else
			Output_Filename_Full=%OutDir%\%OutNameNoExt% - Trimmed.%OutExtension%
			
		run, %comspec% /c ffmpeg -i "%FullPath%" -ss 0:0:0 -to %Start_Time% -c:v copy -c:a copy "%FirstHalf%",,hide
		if !trim2end {	
			SecondHalf=%OutDir%\%OutNameNoExt% - 2nd half.%OutExtension%
			run, %comspec% /c ffmpeg -i "%FullPath%" -ss %End_Time% -to %Output_Duration% -c:v copy -c:a copy "%SecondHalf%",,hide
			if Split {
				fileMove, %FirstHalf%, %OutDir%\%OutNameNoExt% Part 1
				fileMove, %SecondHalf%, %OutDir%\%OutNameNoExt% Part 2
				goto Check_Output
			}
			FileAppend , file '%FirstHalf%'`n, %Con_Cat_N_8%
			FileAppend , file '%SecondHalf%'`n, %Con_Cat_N_8%
			sleep % S
			runWait, %comspec% /c ffmpeg -y -f concat -safe 0 -i "%Con_Cat_N_8%" -c copy "%Output_Filename_Full%",,hidden
			
			fileDelete, %FirstHalf%
			fileDelete, %SecondHalf%
			fileDelete, %Con_Cat_N_8%			;FileRecycle, %FullPath%
		}
		else Output_Filename_Full := FirstHalf
		loop {
			if !(anus := fileexist(Output_Filename_Full))
				sleep 500
			else break
		}
		if trim2end
			fileMove, %FirstHalf%, %Output_Filename_Full%
		fileGetTime, Old_D8, %FullPath%, m
			
		Check_Output:
		sleep % S
		; sysmenu 0x00080000
	
	;	Output_Prefix=%OutNameNoExt%
	;	Output_Filename_Full=%Input_Filename_Full%\%Output_Prefix%.%OutExtension%
		if PreserveFileDate
			fileSetTime, Old_D8, %Output_Filename_Full%, m
		if replaceoriginal {
			fileRecycle, %FullPath%
			;Output_Filename_Full := FullPath
		}
		sleep 2000
		if !fileExist(FullPath) {
			fileMove, %Output_Filename_Full%, %FullPath%
		} else {
			if !tried
				tried = 1
			else
				tried := tried+1
			goto Check_Output
		}
			exit
	} else { 	; 	extracting not deleting
					if trim2end {	
						Output_Filename_Full := FirstHalf

		}

		A:="", B:=""
		A=%Start_Time%
		B=%End_Time%

	if Split 
		goto dr
		; run, %comspec% /c ffmpeg -i "%FullPath%" -ss %A% %Process_Action% %B% -c:v copy -c:a copy "%Output_Filename_Full%",,
	else
		runWait, %comspec% /c ffmpeg -i "%FullPath%" -ss %A% %Process_Action% %B% -c:v copy -c:a copy "%Output_Filename_Full%",,hide
		if NewEnc {
			msgbox, FFMPEG Encode section wip ;encode
			return
		} 
		else {
			loop{
				if fileexist(Output_Filename_Full) {
					tooltip extraction success
					settimer tooloff, -1800
					break
				} else {
					tooltip waiting for output file %a_now%`n%Output_Filename_Full%`ndoesn't exist check permissions
					settimer tooloff, -5000
					exit
				}
			}
		}
	if ( choice = "Extract vox" || choice = "Extract inst" ) {
		ffs = conda run spleeter separate "%Output_Filename_Full%"
		run %COMSPEC% /C %ffs%,,hide, conda_pid
		if errorlevel msgbox %error%
		loop {
			sleep 500
			if WinExist("ahk_pid %conda_pid%") {
				winHide, ahk_exe conda.exe
				sleep 500
				break
				} else {
					tooltip waiting for SPLEETER output file %a_now%
					sleep 850
				}
		}
		Input_Filename_Full=%Output_Filename_Full%
		if (choice="Extract vox") { 		
			Main_Result_WAV=C:\Users\%A_UserName%\AppData\Local\Temp\separated_audio\%Output_Prefix%\vocals.wav		
			Output_Filename_Full=%OutDir%\%Output_Prefix% - Extracted Vox.wav
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
				fileDelete, %Input_Filename_Full% ; remove temp output file
				fileRemoveDir, C:\Users\%A_UserName%\AppData\Local\Temp\separated_audio\%Output_Prefix%
		;	}
		} else 
		if (choice="Extract inst") {		
			Main_Result_WAV=C:\Users\%A_UserName%\AppData\Local\Temp\separated_audio\%Output_Prefix%\accompaniment.wav
		;		if !raw {
		;			msgbox do encode
		;			return
		; } else {
			Output_Filename_Full=%OutDir%\%OutNameNoExt% - Extracted Instrumental Content.wav
			fileMove, Main_Result_WAV, Output_Filename_Full
			fileRecycle, Input_Filename_Full
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
				tooltip bum-face
				settimer tooloff, -1000
		} else {
			sleep, % S
			goto Attempt_Cut
		}
		goSub Xtract_Cleanup
		gui, Destroy
		return
	}
	if !fileexist(Output_Filename_Full) {
		sleep % s
		goto aa_C
	}
	return
}

return
Cutcurrent:
Path2File := Media.sourceURL
if (InvokeVerb(Path2File, "Cut")) { 
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
	else {
	WMP := new RemoteWMP
		;postMessage, 0x111, Paused, 0, ,%WinTitle%
			WMP.TogglePause()
			}
	return

WMP_Prev:
process, Exist, WMPlayer.exe
ifWinNotExist, Windows Media Player
	trayTip, Windows Media Player, process found but window Not,3000,2
else {
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
	} else {
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
genre := "", gnr := ""
process, Exist, WMPlayer.exe
ifWinNotExist, Windows Media Player
{
	trayTip, Windows Media Player, process found but window Not,3000,2
	return
} else {
	oldsong 	=% newsong
	newsong	:= ""
	postMessage, 0x111, Stop, 0, ,%WinTitle%
	sleep, 50
	postMessage, 0x111, Next, 0, ,%WinTitle%
	thecall1:
	sleep, 50
	goSub WMP_Refresh_2
	if (newsong = oldsong) {
		if !tries
			tries 	:= 1
		else tries := tries + 1
		if tries < 5	
			settimer WMP_NEXT, -500
		else return
	} else {
		goSub Genre_Search
		WMP.jump(StartPos_Offset)
		settimer, WMP_Pause, -100
		; sleep, 101
		; postMessage, 0x319, 0, Play, ,%WinTitle%
	}
	return
}
return

CopySearchSlSk:
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
		SplitPath, FullPath,  , , , OutNameNoExt
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

SearchExplorer:
goSub WMP_Refresh_2
goSub Genre_Search
trayTip, Windows Media Player, path
FullPath=%newsong%
SplitPath, FullPath,  , , , OutNameNoExt
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
p 		:= 1, Matched_String := "",	genre := ""
o		:=comobjcreate("Shell.Application")
SplitPath,newsong,file,directory,ext
od	:=o.namespace(directory)
of		:=od.parsename(file)
gnr	:=od.getdetailsof(of,16) ; genre
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
	if (gnr="dnb") || (gnr="drum & bass") || (gnr="drum&bass") || (gnr="drum n bass") 
		StartPos_Offset:=86, p:=999, Genre:="dnb", Search_Root:="S:\- DNB", faggot:=1
	else if (gnr="Reggae") || (gnr="Dancehall") || (gnr="Ragge") || (gnr="Riddim") 
		StartPos_Offset:=14, p:=999, Genre:="reggae", Search_Root:="S:\- REGGAE", faggot:=1
	else if (gnr="Hip-Hop") || (gnr="HipHop") || (gnr="Rap") || (gnr="Gangster Rap") 
		StartPos_Offset:=17, p:=999, Genre:="hiphop", Search_Root:="S:\- HIPHOP", faggot:=1
	else if (gnr="Garage") || (gnr="2 Step") || (gnr="Bassline")
		StartPos_Offset:=45, p:=999, Genre:="garage", Search_Root:="S:\- - MP3 -\Garage", faggot:=1
	else if (gnr="Rock") || (gnr="Rock n Roll") || (gnr="Metal")
		StartPos_Offset:=17, p:=999, Genre:="rock", Search_Root:="S:\- - MP3 -\- Other\Rock", faggot:=1
	else if (gnr="Ambient") || (gnr="Chill Out")
		StartPos_Offset:=30, p:=999, Genre:="ambient", Search_Root:="S:\- - MP3 -\Chill", faggot:=1
	else if (gnr="Spoken Word") || (gnr="Audiobook")
		StartPos_Offset:=0, p:=999, Genre:="audiobooks", Search_Root:="S:\Documents\My Audio", faggot:=1
	; if !genre || !faggot
		; msgBox no genre 
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

DelCurrent: 
process, Exist, WMPlayer.exe
WMP2del := new RemoteWMP
sleep, 300
Media2del := WMP2del.player.currentMedia
goSub WMP_next
setTimer, DELETE_, -400
return

DELETE_:   
try 
	File2Del= % Media2del.sourceURL
catch
	goSub DelCurrent
FileRecycle, % File2Del ;trayTip, Windows Media Player, Deleted %File2Del%, 3, 1
tooltip NIG
tooltip,
return

Add2Playlist:
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

dr:
		SecsDuration:=round(media.getItemInfo("Duration"))
		Sample_Duration_min:= Floor(SecsDuration/60)
		if Sample_Duration_Hr:=Floor(Sample_Duration_min/60)
			Sample_Duration_min:=Sample_Duration_min-(Sample_Duration_Hr*60)
		Sample_Duration_Sec:=SecsDuration-(Sample_Duration_min*60)
		Output_Duration=%Sample_Duration_Hr%:%Sample_Duration_min%:%Sample_Duration_Sec%
		FirstHalf=%OutDir%\%OutNameNoExt% - 1st half.%OutExtension%
		if instr(OutNameNoExt, "Trimmed")
			Output_Filename_Full=%OutDir%\%OutNameNoExt%.%OutExtension%
		else
			Output_Filename_Full=%OutDir%\%OutNameNoExt% - Trimmed.%OutExtension%
			
		run, %comspec% /c ffmpeg -i "%FullPath%" -ss 0:0:0 -to %Start_Time% -c:v copy -c:a copy "%FirstHalf%",,hide

		if !trim2end {	
			SecondHalf=%OutDir%\%OutNameNoExt% - 2nd half.%OutExtension%
			run, %comspec% /c ffmpeg -i "%FullPath%" -ss %End_Time% -to %Output_Duration% -c:v copy -c:a copy "%SecondHalf%",,hide
			if Split {
				fileMove, %FirstHalf%, %OutDir%\%OutNameNoExt% Part 1
				fileMove, %SecondHalf%, %OutDir%\%OutNameNoExt% Part 2
				goto Check_Output2
			}
			FileAppend , file '%FirstHalf%'`n, %Con_Cat_N_8%
			FileAppend , file '%SecondHalf%'`n, %Con_Cat_N_8%
			sleep % S
			runWait, %comspec% /c ffmpeg -y -f concat -safe 0 -i "%Con_Cat_N_8%" -c copy "%Output_Filename_Full%",,hidden
			
			fileDelete, %FirstHalf%
			fileDelete, %SecondHalf%
			fileDelete, %Con_Cat_N_8%			;FileRecycle, %FullPath%
		}
		else Output_Filename_Full := FirstHalf
		loop {
			if !(anus := fileexist(Output_Filename_Full))
				sleep 500
			else break
		}
		if trim2end
			fileMove, %FirstHalf%, %Output_Filename_Full%
		fileGetTime, Old_D8, %FullPath%, m
			
		Check_Output2:
		sleep % S
		; sysmenu 0x00080000
	
	;	Output_Prefix=%OutNameNoExt%
	;	Output_Filename_Full=%Input_Filename_Full%\%Output_Prefix%.%OutExtension%
		if PreserveFileDate
			fileSetTime, Old_D8, %Output_Filename_Full%, m
		if replaceoriginal {
			fileRecycle, %FullPath%
			;Output_Filename_Full := FullPath
		}
		sleep 2000
		if !fileExist(FullPath) {
			fileMove, %Output_Filename_Full%, %FullPath%
		} else {
			if !tried
				tried = 1
			else
				tried := tried+1
			goto Check_Output2
		}
			return

Clip_Commander:
if (clipboard!=Monster_Clip) {
	setTimer Clip_Commander, off
	Menu, Tray, Icon, WMP.ico
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
		if (this.player.playState = 3) { ; Playing = 3
			this.player.Controls.pause()
			setTimer Icon_Alternate, off
			cur =% Media.sourceURL
			SplitPath, cur , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
			Menu, Tray, Tip , % "Windows Media Player`n" OutNameNoExt "`nPaused"
		} else {
			setTimer Icon_Alternate, 700
			this.player.Controls.play()
			cur =% Media.sourceURL
			SplitPath, cur , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
			Menu, Tray, Tip , % "Windows Media Player`n" OutNameNoExt "`nPlaying"
		}
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
        SplitPath, path, name, dir
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
		SplitPath, strExeName, strExeName
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

Open_Containing:
WMP := new RemoteWMP
Media := WMP.player.currentMedia
UNC = % Media.sourceURL
o:=comobjcreate("Shell.Application")
SplitPath,UNC,file,directory,ext
if !errorlevel {
	od:=o.namespace(directory)
	of:=od.parsename(file)
	gnr:=od.getdetailsof(of,16) ;16 = genre
}
Controls := WMP.player.Controls
SplitPath, UNC , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
sleep, 250
1st := (RegExReplace(UNC, "^.+\\|\.[^.]+$")), 2nd := RegExReplace(1st,  "[']|[`]|[)]|[(]|[_]|(  )|( )|(YouTube)", " "), clipboard := RegExReplace(2nd, Needle3, " ") ;"( . )|(    )|(   )|(  )"
run %COMSPEC% /c explorer.exe /select`, "%UNC%",, Hide
sleep %S%
sendInput {F5}
UNC:="", 1st:="", 2nd:=""
return

Receive_WM_COPYDATA(wParam, lParam) {
    StringAddress := (NumGet(lParam + 2*A_PtrSize)), CopyOfData := StrGet(StringAddress)
	switch CopyOfData {
		case "VolUp":
		{
			settimer VolUp, -1
		}
		case "VolDn":
		{
			settimer VolDn, -1
		}
		case "Converter":
		{
			settimer Converter, -1
		}
		case "JumpPrev":
		{
			settimer WMP_Prev, -1
		}
		case "JumpNext":
		{
			settimer WMP_next, -1
		}
		case "PauseToggle":
		{
			settimer WMP_Pause, -1
		}
		case "CutCurrent":
		{
			settimer CutCurrent, -1
		}
		case "DelCurrent":
		{
			settimer DelCurrent, -1
		}
		case "Add2Playlist":
		{
			settimer Add2Playlist, -1
		}
		case "Open_Containing":
		{
			settimer Open_Containing, -1
		}
		case "SearchExplorer":
		{
			settimer SearchExplorer, -1
		}
		case "CopySearchSlSk":
		{
			settimer CopySearchSlSk, -1
		}
		case "Restart_WMP":
		{
			settimer Restart_WMP, -1
		}
		return true
	}
}

Open_xtractfrommenu:
if !Secs2Sample_Start {
	Secs2Sample_Start := "0"
	msgbox undefined region
}
settimer GUI_, -1

return

slskrescue:
run % slskrescue
return

Restart_WMP:
WMP := new RemoteWMP
sleep, % S
Media := WMP.player.currentMedia, Path2File:=Media.sourceURL, Controls := WMP.player.Controls, time:=round(controls.currentPosition)
run taskkill /F /IM WMPlayer.exe 
sleep, % S
sleep, % S
run wmplayer.exe "%Path2File%"
sleep, % S
bum_open:
WMP := new RemoteWMP
if !WMP {
	sleep % S
	goto bum_open
}

bum_take_aim:
if WMP {
	try
		Media := WMP.player.currentMedia
	catch {
		sleep % S
		goto bum_take_aim
	}
} else {
	sleep % S	goto bum_take_aim
}
if !Media {
	sleep % S	goto bum_take_aim
}

bum_start_shitting:
if Media {
	Path2File:=Media.sourceURL
} else {
	sleep % S	goto bum_start_shitting
}
if !Path2File {
	sleep % S	goto bum_start_shitting
}
bum_shit_everywhere:
if Path2File {
	Controls := WMP.player.Controls
} else {
	sleep % S	goto bum_shit_everywhere
}
if !Controls
	goto bum_shit_everywhere
	
bum_start_wiping:
if controls {
	WMP.jump(time)
} else {
	sleep % S	
	goto bum_start_wiping
}
return

zinout:
a = "C:\Program Files\AHK\AutoHotkeyU32_UIA.exe" "C:\Script\AHK\Z_MIDI_IN_OUT\z_in_out.ahk"
run %a%,,hide,zinout_pid
return

reg_read:
RegRead, DefaultChoice, HKEY_CURRENT_USER\Software\WMP_MATT, 	extractor default
RegRead, choice, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, 			Extractor Default			
RegRead, splitdef, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, 		split Default, 						
RegRead, trim2enddef, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, 	trim2end Default, 			
RegRead, PreserveDef, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, 	PreserveFileDate, 
RegRead, replaceDef, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, 	replaceoriginal, 	
return

reg_write:
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, Extractor Default, 	% choice
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, split Default, 			% split
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, trim2end Default, 	% trim2end
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, PreserveFileDate, 	% PreserveFileDate
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, replaceoriginal, 		% replaceoriginal
return

playstatetimer:
try 
if !(WMP.player.playState) {
	try
		WMP := new RemoteWMP
	catch
		sleep 2000
} 
catch 
{
	try
		anus := WMP.player.playState
	catch
		sleep 2000
	if (anus = 3)  { ; Playing = 3
		if !faggot {
			faggot := true
			setTimer Icon_Alternate, 700  
		}
	} else {
		faggot := false
		setTimer Icon_Alternate, off
	}
}
return

Icon_Alternate:
if (A_TimeIdle < (420000 - 1000)) {
	if !IconAlternateEnabled {
		Try
			Menu, Tray, Icon, % "HBITMAP:*" Iconz.2
		Catch {
			sleep 1000
			reload
		}
		IconAlternateEnabled := True

	} else {
		Try
			Menu, Tray, Icon, % "HBITMAP:*" Iconz.1
		Catch { 		
			sleep 1000
			reload
		}
		IconAlternateEnabled := False
	}
}
return

Open_ScriptDir()

; class ATL:553D4A38
; classNN ATL:553D4A381
; Title Now Playing Basket Window
; style 0x56000000
; exstyle 0x00000000
 ; x-2 y-74
; w +2 h+74
/* 
<^>!C::		;altGr x  SAMPLE START / END. 
WMP := new RemoteWMP
sleep, 20
Media := WMP.player.currentMedia
Controls := WMP.player.Controls
sleep, 20
FullPath:=Media.sourceurl
SplitPath, FullPath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
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
		SplitPath, Output_Filename_Full , , , , Output_Prefix
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
var psPlaying 			=  3;
var psStopped 			=  1
var psPaused 			=  2;
var psReady 			= 10;
var psTransitioning 	= 9;
var psUndefined 		= 0;
var g_kSyncID 			= "{661CCB0E-B835-4256-B566-6D3FD8491FFC}"
var g_kBurnID 			= "{939438A9-CF0F-44D8-9140-599736F0D3A2}"
var g_kBrowseID 		= "deprecated"
var g_kNowPlayingID 	= "{70C02500-7C6F-11D3-9FB6-00105AA620BB}"

*/


; Help(wParam, lParam, Msg) {
	; MouseGetPos,,,, OutputVarControl
	; if !OutputVarControlold
		; OutputVarControlold=%OutputVarControl%
	; IfEqual, OutputVarControl, Button3 
	; {
		; if OutputVarControlold != OutputVarControl
		; toolTip save the default action %Choice%
		; OutputVarControlold=%OutputVarControl%
	; } else {
		; sleep % S
		; tooltip
	; }
; }