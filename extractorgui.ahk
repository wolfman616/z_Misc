goto init

converter:
WMPConv 	:= 	new RemoteWMP
Media 		:= 	WMPConv.player.currentMedia
Controls 	:= 	WMPConv.player.Controls
FullPath	:= 	Media.sourceurl

SplitPath, FullPath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
if !Secs2Sample_Start { ;get start time 
	if Secs2Sample_Start:=round(controls.currentPosition)
		Sample_start_min:= Floor(Secs2Sample_Start/60) 
	else {
		Secs2Sample_Start:="0" ; set start time 0 when it will not be correctly detected by control.current
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
	if (Sample_start_Hr Sample_End_Hr) = 0 
		extract_starttime=%Sample_start_min%:%Sample_start_Sec%
	else
		extract_starttime=%Sample_start_Hr%:%Sample_start_min%:%Sample_start_Sec%
	if (Sample_start_Hr Sample_End_Hr) = 0 
		extract_endtime=%Sample_End_min%:%Sample_End_Sec%
	else 
		extract_endtime=%Sample_End_Hr%:%Sample_End_min%:%Sample_End_Sec%

	GUI_:
	gosub Reg_Read
	
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
	cur_ := "AniCur_Munch"
	settimer AniCur_, -1, -2147483648
	gui, xtract:new , , FFMpeg Process
	gui +HwndQuestionHwnd +LastFound -MinimizeBox 
	gui, xtract:add, DropDownList, w82 x34 vChoice, %Choices%
	if Secs2Sample_Start
			splitstr := "Split @ " . Sample_start_min . ":" . Sample_start_Sec
			if splitdef {
		gui, xtract:add, checkbox, %checkbox_Height% vSplit +checked, %splitstr%
	} else
		gui, xtract:add, checkbox, %checkbox_Height% vSplit, %splitstr%
	If (DefaultChoice = "Extract region") {
		gui, xtract:add, checkbox,%checkbox_Height% w180 vtrim2end, % "Xtract " . Sample_start_min . ":" . Sample_start_Sec . " - end"
						if Sample_start_Sec
					GuiControl, Text, trim2end , % "Xtract " . Sample_start_min . ":" . Sample_start_Sec . " - end"
				else
					GuiControl, Text, trim2end , % "Xtract - end"		
					}
	else If (DefaultChoice = "Delete region") 
		gui, xtract:add, checkbox, %checkbox_Height% w180 vtrim2end, % "Crop " . Sample_start_min . ":" . Sample_start_Sec . " - end"
	else 
		gui, xtract:add, checkbox, %checkbox_Height% vtrim2end +disabled, %del2endstr%
	if trim2enddef 
		GuiControl, , vtrim2end,1
	if PreserveDef
		gui, xtract:add, checkbox, %checkbox_Height% vPreserveFileDate +checked, Preserve Date
	else
		gui, xtract:add, checkbox, %checkbox_Height% vPreserveFileDate, Preserve Date
	if replaceDef
		gui, xtract:add, checkbox, %checkbox_Height% vreplaceoriginal +checked, Replace original
	else
		gui, xtract:add, checkbox, %checkbox_Height% vreplaceoriginal, Replace original
	gui, xtract:add, checkbox, %checkbox_Height% vSave +disabled,Save as default 		; 		would be better 2 appear only after any new selection is made in DropDownList
	gui, xtract:add, Button, x35 Default gPerform w80, OK (Enter)
	gui, xtract:add, Button, x35 w80 gCancel, Cancel (Esc)
	gui, xtract:Show , w151 Center, X-TR4CT0r
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
					GuiControl, Text, trim2end , % "Xtract " . Sample_start_min . ":" . Sample_start_Sec . " - end"
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
settimer, Xtract_Cleanup, -1 
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
Secs2Sample_End := "", Secs2Sample_Start := "", Output_FullUnc := "", Input_Filename_Full := "", Output_Prefix := ""
WMPConv :=	Delete RemoteWMP
choice := "", replaceoriginal:= "", trim2end := "", PreserveFileDate := ""
return

trim2end:
trim2end:= !trim2end
gui, add, checkbox, vSave ,Save as default 	
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

settimer, tooloff, -1500
settimer, Xtract_Cleanup, -1
;settimer, Icon_Alternate, off
gui, destroy
return

Perform:
submittedok := True
global needL := "i)(?:Extract)(?:[ ])[0-9]"
gui, submit
gui, Destroy 
inichoice := choice
if Save 
	settimer, Reg_Write, -1
Secs2Sample_Start :=

If (choice = "Extract region") 
{
	process_Action 	:= "-t"
	process_Type 	:= "Extract" 
}
else If (Choice = "Delete region") 
{
	process_Action 	:= "-to" 
	process_Type 	:= "Trimmed"
}
else if (Choice = "Extract vox") 
{
	process_Action 	:= "-t"
	process_Type 	:= "Extract Vox" 
}
else if (Choice ="Extract inst" ) 
{
	process_Action 	:= "-t"
	process_Type 	:= "Extract Instrumental" 
}

Output_Prefix 	:= (OutNameNoExt . " - " . process_Type)
Output_FullUnc 	:= (OutDir "\" Output_Prefix "." OutExtension)

File_Numbering:
if ( n := fileexist( Output_FullUnc ) ) {
	n := 1, RegXPos := 1, Match:=
	while RegXPos := regexmatch(Output_Prefix, needL, Match, RegXPos) {
		File_Num := Match
		RegXPos = 666
	}
	if !File_Num
		File_Num:=1
	else 
		File_Num := File_Num + 1
	Output_FullUnc=%OutDir%\%Output_Prefix% %File_Num%.%OutExtension%
} else
	Output_FullUnc=%OutDir%\%Output_Prefix%.%OutExtension%
if FileExist(Output_FullUnc) { ; Check_Folder
;	SplitPath, Output_FullUnc , , , , Output_Prefix
	SplitPath, Output_FullUnc , OutFN, OutFDir, OutFExt, Output_Prefix, OutFDrive
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
	extract_data_1=%OutDir%\%OutNameNoExt% - 1st half.%OutExtension%
	if instr(OutNameNoExt, "Trimmed")
		Output_FullUnc=%OutDir%\%OutNameNoExt%.%OutExtension%
	else
		Output_FullUnc=%OutDir%\%OutNameNoExt% - Trimmed.%OutExtension%
		
		msgbox def

	run, %comspec% /c ffmpeg -i "%FullPath%" -ss 0:0:0 -to %extract_starttime% -c:v copy -c:a copy "%extract_data_1%",,hide
	if !trim2end {	
		extract_data_2=%OutDir%\%OutNameNoExt% - 2nd half.%OutExtension%
		run, %comspec% /c ffmpeg -i "%FullPath%" -ss %extract_endtime% -to %Output_Duration% -c:v copy -c:a copy "%extract_data_2%",,hide
		if Split {
			fileMove, %extract_data_1%, %OutDir%\%OutNameNoExt% Part 1
			fileMove, %extract_data_2%, %OutDir%\%OutNameNoExt% Part 2
			goto Check_Output
		}
		FileAppend , file '%extract_data_1%'`n, %extract_data_Concat%
		FileAppend , file '%extract_data_2%'`n, %extract_data_Concat%
		sleep % S
		
		msgbox def
		runWait, %comspec% /c ffmpeg -y -f concat -safe 0 -i "%extract_data_Concat%" -c copy "%Output_FullUnc%",,hidden
		
		fileDelete, %extract_data_1%
		fileDelete, %extract_data_2%
		fileDelete, %extract_data_Concat%			;FileRecycle, %FullPath%
	}
	else Output_FullUnc := extract_data_1
	loop {
		if !(playstate := fileexist(Output_FullUnc))
			sleep 500
		else break
	}
	if trim2end
		fileMove, %extract_data_1%, %Output_FullUnc%
	fileGetTime, Old_D8, %FullPath%, m
		
	Check_Output:
	sleep % S
	; sysmenu 0x00080000

;	Output_Prefix=%OutNameNoExt%
;	Output_FullUnc=%Input_Filename_Full%\%Output_Prefix%.%OutExtension%
	if PreserveFileDate
		fileSetTime, Old_D8, %Output_FullUnc%, m
	if replaceoriginal {
		fileRecycle, %FullPath%
		;Output_FullUnc := FullPath
	}
	sleep 2000
	if !fileExist(FullPath) {
		fileMove, %Output_FullUnc%, %FullPath%
	} else {
		if !tried
			tried = 1
		else
			tried := tried+1
		goto Check_Output
	}
		exit
	} else {	 ; 	extracting not deleting
	if trim2end
		Output_FullUnc := extract_data_1
	A:="", B:=""
	A=%extract_starttime%
	B=%extract_endtime%

	if Split 
		goto dr
		; run, %comspec% /c ffmpeg -i "%FullPath%" -ss %A% %Process_Action% %B% -c:v copy -c:a copy "%Output_FullUnc%",,
	else {
		msgbox else`n%extract_starttime%`n%extract_endtime%`n%Process_Action%

		runWait, %comspec% /c ffmpeg  -i "%FullPath%" -ss %A% -t %B% -c:v copy -c:a copy "%Output_FullUnc%",,hide
		if NewEnc {
			msgbox, FFMPEG Encode section wip ;encode
			return
		} 
		else {
			loop{
				if fileexist(Output_FullUnc) {
					tooltip extraction success
					settimer, tooloff, -1800
					break
				} else {
					tooltip waiting for output file %a_now%`n%Output_FullUnc%`ndoesn't exist check permissions
					settimer, tooloff, -5000
					exit
				}
			}
			}
		if ( choice = "Extract vox" || choice = "Extract inst" ) {
			ffs = conda run spleeter separate "%Output_FullUnc%"
			run %COMSPEC% /C %ffs%,,hide, conda_pid
			if errorlevel 
				msgbox %error%
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
			Input_Filename_Full=%Output_FullUnc%
			if (choice = "Extract vox") { 		
				Main_Result_WAV=C:\Users\%A_UserName%\AppData\Local\Temp\separated_audio\%Output_Prefix%\vocals.wav		
				Output_FullUnc=%OutDir%\%Output_Prefix% - Extracted Vox.wav
			;	if !raw
			;		msgbox do encode
			;	else {
					Check_Output_2:
					if !fileexist(Main_Result_WAV) { ; check spleeter files have appeared
						sleep % S
						goto Check_Output_2
					} else {
						msgbox, %Main_Result_WAV% exist 
					}
					fileMove %Main_Result_WAV%, %Output_FullUnc%
					if errorlevel
						msgbox %errorlevel% 
					Check_Output_Moved:
					if !fileexist(Output_FullUnc) { ; check if previous move has occurred
						sleep % S		
						goto Check_Output_Moved
					}				
					fileDelete, %Input_Filename_Full% ; remove temp output file
					fileRemoveDir, C:\Users\%A_UserName%\AppData\Local\Temp\separated_audio\%Output_Prefix%
			;	}
			} else 
			if ( choice = "Extract inst" ) {		
				Main_Result_WAV=C:\Users\%A_UserName%\AppData\Local\Temp\separated_audio\%Output_Prefix%\accompaniment.wav
			;		if !raw {
			;			msgbox do encode
			;			return
			; } else {
				Output_FullUnc=%OutDir%\%OutNameNoExt% - Extracted Instrumental Content.wav
				fileMove, Main_Result_WAV, Output_FullUnc
				fileRecycle, Input_Filename_Full
				fileRemoveDir, C:\Users\%A_UserName%\AppData\Local\Temp\separated_audio\%Output_Prefix%
			;	}
			}
		}

		Attempt_Cut:
		ttt =% clipboard
		Aa_C:
		if fileexist(Output_FullUnc) {
			if (InvokeVerb(Output_FullUnc, "Cut", True)) {
				if (clipboard = ttt) {
					goto Aa_C
				} else{
					tooltip bum-face
					settimer, tooloff, -1000
				}
			} else {
				sleep, % S
				goto Attempt_Cut
			}
			goSub Xtract_Cleanup
			gui, Destroy
			return
		}

		if !fileexist(Output_FullUnc) {
			sleep % s
			goto aa_C
		}
		return
	}
}

Reg_Read:
regRead, DefaultChoice, HKEY_CURRENT_USER\Software\WMP_MATT,extractor default
regRead, choice, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, 		Extractor Default			
regRead, splitdef, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, 	split Default, 						
regRead, trim2enddef, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, 	trim2end Default
regRead, PreserveDef, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, 	PreserveFileDate
regRead, replaceDef, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, 	replaceoriginal
return

Reg_Write:
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, Extractor Default, 	% choice
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, split Default, 		% split
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, trim2end Default, 	% trim2end
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, PreserveFileDate, 	% PreserveFileDate
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WMP_MATT, replaceoriginal, 	% replaceoriginal
return


Errormsg:	
tooltip bad bad bad WMP		
sleep 4000
reload

Open_ScriptDir()

/* 
// Play States
;from nowdoing.js in WMPLOC.DLL.MUN/256
var psUndefined 			= 0;
var psStopped 				= 1;
var psPaused 				= 2;
var psPlaying 				= 3;
var psScanForward 		= 4;
var psScanReverse 		= 5;
var psBuffering 				= 6;
var psWaiting 				= 7;
var psMediaEnded 		= 8;
var psTransitioning 		= 9;
var psReady 				= 10;
var psReconnecting 		= 11;
var g_kSyncID 				= "{661CCB0E-B835-4256-B566-6D3FD8491FFC}"
var g_kBurnID 				= "{939438A9-CF0F-44D8-9140-599736F0D3A2}"
var g_kBrowseID 			= "deprecated"
var g_kNowPlayingID 	= "{70C02500-7C6F-11D3-9FB6-00105AA620BB}"

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
18849 - Open "add to Library by Searching Computer" dialog RC=FAIL. Use 32849 or postMessage
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
19011 - Open "Save As" dialog RC=FAIL. Use ????? or postMessage
19013 - Save "Now Playling List"<---------------------------------
19014 - New "Now Playing List" <---------------------------------
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
19500 - DVD: Root menu
19501 - DVD: Title menu returns 1 if menu is not available (?)
19502 - DVD: Close menu (Resume)
19503 - DVD: Back
19572 - Update DVD Information RC=FAIL. Use ????? or postMessage
19681 - DVD, VCD or CD Audio
19721 - Show menu Bar
19722 - Hide menu Bar
19723 - Autohide menu Bar
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
32849 - Open "add to Library by Searching Computer" dialog
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
