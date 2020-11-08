#NoEnv 		
#Persistent 		
#singleinstance force
#Include VA.ahk
SendMode Input
SetBatchLines -1
CoordMode window, screen
Menu, Tray, Icon, WMP.ico
SetWorkingDir %A_ScriptDir% 		
Global Genres:="i)(dnb)|(reggae)|(riddim)|(hiphop)|(garage)|(rock)|(ambient)|(samples)|(my music)|(audiobooks)|(sLSk)|(FOAD)"
Global Needle4:="i)[1234567890.'`)}{(_]|(-khz)(rmx)|(remix)|(mix)|(refix)|(vip)|(featuring)|( feat)|(ft)|(rfl)|(-boss)(-sour)|(its)|(it's)|(-)|(-bpm)"
Global Needle2:="i)(\s[a-z]{1,2}\s)", Global Needle3:="( . )|(^[a-z][\s])|(    )|(   )|(  )|[.]"
Global StartPos_Offset:=0, Global StartPos_Offset := 4, Global Search_Root:="", Global Genre:=""
concat:="c:\out\temp.txt"
;VARs::::::::::::;
Stop:=18809, Play:=0x2e0000, Paused:=32808, Prev:=18810, Next:=18811, Vol_Up:=32815, Vol_Down:=32816 ;Paused=18808     
Loop 2
    DllCall( "ChangeWindowMessageFilter", uInt, "0x" (i:=!i?49:233), uint, 1)
Sleep, 30
process exist, ahk_exe WMPlayer.exe
if Errorlevel
	TrayTip, WMP, Error %Error%
Else
runwait "C:\Apps\WMPlayer.exe"
WMP := new RemoteWMP
WinTitle=Windows Media Player
Sleep, 30
Media := WMP.player.currentMedia
Controls := WMP.player.Controls
TrayTip, Windows Media Player, % Media.sourceURL
onexit() {
FileDelete, %concat%
}
;newsong= % Media.sourceURL

;Binds::::::::::::^>+PgUp
^PgUp::PostMessage, 0x111, vol_up, 0, ,%WinTitle% 		; Volume Up 		- 	;ctrl shift page up
Return

^PgDn::PostMessage,  0x111, vol_down, 0, ,%WinTitle% 	; Volume Down	-	;ctrl shift page down
Return

^>+Enter::			;ctrl shift enter - CLIPBOARD TITLE and ARTIST 	;TrayTip, % Media.sourceURL
WMP := new RemoteWMP
Media := WMP.player.currentMedia
unc= % Media.sourceURL
Controls := WMP.player.Controls
Sleep, 250
1st:= RegExReplace(unc, "^.+\\|\.[^.]+$")
2nd := RegExReplace(1st,  "[']|[`]|[)]|[(]|[_]|(  )|( )|(YouTube)", " ")
Clipboard := RegExReplace(2nd, Needle3, " ") ;"( . )|(    )|(   )|(  )"
ClipWait
TrayTip, Windows Media Player, %unc% x %2nd%
unc:="", 1st:="", 2nd:=""
Return

<^>!i::			;alt gr and I
GoSub WMP_Copy_Search
Return

<^>!s::			;alt gr and I
GoSub WMP_Copy_Search_explorer
Return

<^>!Del::			;ctrl shift del
GoSub WMP_Del
Return

<^>!Space::		;ctrl shift space
GoSub WMP_Pause
Return

<^>!Left::			;ctrl shift left
GoSub WMP_Prev
Return


<^>!Right::		;altGr right
GoSub WMP_Next
Return

<^>!C::		;altGr x  SAMPLE START / END. 

WMP := new RemoteWMP
Sleep, 20
Media := WMP.player.currentMedia
Controls := WMP.player.Controls
Sleep, 20
FullPath:=Media.sourceurl
SplitPath, FullPath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive

if !Secs2Sample_Start
	{
	Secs2Sample_Start:=round(controls.currentPosition)
	Sample_start_min:= Floor(Secs2Sample_Start/60)
	if Sample_start_Hr:=Floor(Sample_start_min/60)
		Sample_start_min:=Sample_start_min-(Sample_start_Hr*60)
	Sample_start_Sec:=Secs2Sample_Start-(Sample_start_min*60)
	}
else
	{
	Secs2Sample_End:=round(controls.currentPosition)
	Sample_End_min:= Floor(Secs2Sample_End/60)
	if Sample_End_Hr:=Floor(Sample_End_min/60)
		Sample_End_min:=Sample_End_min-(Sample_End_Hr*60)
	Sample_End_Sec:=Secs2Sample_End-(Sample_End_min*60)
	Start_Time=%Sample_start_Hr%:%Sample_start_min%:%Sample_start_Sec%
	End_Time=%Sample_End_Hr%:%Sample_End_min%:%Sample_End_Sec%
	Gui, GuiName:new , , Question
	Gui +HwndQuestionHwnd
	Gui, Add, Text,, SAMPLE 
	Gui, Add, CheckBox, Checked center vExtract, Extract
	Gui, Add, Text,, TRIM 
	Gui, Add, CheckBox, center vTrim, Delete
	Gui, Add, CheckBox, center vReplace, Replace
	Gui, Add, Button, center w80 gPerform, OK
	Gui, Add, Button, center w80 gCancel, Cancel
	Gui, Show , Center, Question
	Return
	
Cancel:
	Gui, Destroy
	Exit

Perform:
	Gui, Submit
	Gui, Destroy 
	If Extract
		Process_Action:="-t", Process_Type:="Extracted"
	If Trim
		Process_Action:="-to", Process_Type:="Trimmed"
	Output_Prefix=%OutDir%\%OutNameNoExt% - %Process_Type%
	Output_Filename_Full=%Output_Prefix%.%OutExtension%
	while FileExist(Output_Filename_Full) { ; Check_Folder
		Multiple_Num := Multiple_Num + 1
		Output_Filename_Full=%Output_Prefix%-%Multiple_Num%.%OutExtension%
		}
	if Extract && Trim
		{
		Output_Filename_Full=%OutDir%\%OutNameNoExt% - Extracted.%OutExtension%
		RunWait, %comspec% /c ffmpeg -i "%FullPath%" -ss %Start_Time% -t %End_Time% -c:v copy -c:a copy "%Output_Filename_Full%"
		if InvokeVerb(Output_Filename_Full, "Cut", True)
			{
			Output_Filename_Full=%OutDir%\%OutNameNoExt% - Trimmed.%OutExtension%
			RunWait, %comspec% /c ffmpeg -i "%FullPath%" -ss %Start_Time% -to %End_Time% -c:v copy -c:a copy "%Output_Filename_Full%"
			}
		}
	If Trim
		{
		SecsDuration:=round(media.getItemInfo("Duration"))
		Sample_Duration_min:= Floor(SecsDuration/60)
		if Sample_Duration_Hr:=Floor(Sample_Duration_min/60)
			Sample_Duration_min:=Sample_Duration_min-(Sample_Duration_Hr*60)
		Sample_Duration_Sec:=SecsDuration-(Sample_Duration_min*60)
		Output_Duration=%Sample_Duration_Hr%:%Sample_Duration_min%:%Sample_Duration_Sec%
		FirstHalf=%OutDir%\%OutNameNoExt% - Trimmed first half.%OutExtension%
		SecondHalf=%OutDir%\%OutNameNoExt% - Trimmed 2nd half.%OutExtension%
		RunWait, %comspec% /c ffmpeg -i "%FullPath%" -ss 0:0:0 -to %Start_Time% -c:v copy -c:a copy "%FirstHalf%"
		RunWait, %comspec% /c ffmpeg -i "%FullPath%" -ss %End_Time% -to %Output_Duration% -c:v copy -c:a copy "%SecondHalf%"
		FileAppend , file '%FirstHalf%'`n, %concat%
		FileAppend , file '%SecondHalf%'`n, %concat%
		sleep 1500
		Output_Filename_Full=%OutDir%\%OutNameNoExt% - Trimmed.%OutExtension%
		RunWait, %comspec% /c ffmpeg -f concat -safe 0 -i "%concat%" -c copy "%Output_Filename_Full%"
		FileDelete, %FirstHalf%
		FileDelete, %SecondHalf%
		FileDelete, %concat%
		FileGetTime, Old_D8 , %FullPath%, m
		FileSetTime, Old_D8 , %Output_Filename_Full%, m
		FileRecycle, %FullPath%
		Bugga:
		sleep 500
		if !fileExist(FullPath)
			FileMove, Output_Filename_Full, FullPath
		else 
			goto bugga
		Exit
	} Else {
		RunWait, %comspec% /c ffmpeg -i "%FullPath%" -ss %Start_Time% %Process_Action% %End_Time% -c:v copy -c:a copy "%Output_Filename_Full%"
		if InvokeVerb(Output_Filename_Full, "Cut", True)
			{
			Secs2Sample_End:="",Secs2Sample_Start:="",Output_Filename_Full:=""
			Exit
			}
		Return
		}
	Escape::Gui, Destroy
	}

<^>!x::		;altGr x  
Path2File:=Media.sourceURL
if InvokeVerb(Path2File, "Cut")
	{ 
    Process,Exist
    hwnd:=WinExist("ahk_class tooltips_class32 ahk_pid " Errorlevel)
	}  ; run WMP_cut.ahk ;cut mp3 to clipboard
Menu, Tray, Icon, copy.ico
Monster_Clip=%Clipboard%
SetTimer Clip_Commander, 1000
Return


WMP_Pause:
	Process, Exist, WMPlayer.exe
	ifWinNotExist, Windows Media Player
		TrayTip, Windows Media Player, Process found but window Not,3000,2
	Else
		PostMessage, 0x111, Paused, 0, ,%WinTitle%
	Return

WMP_Prev:
	Process, Exist, WMPlayer.exe
	ifWinNotExist, Windows Media Player
		TrayTip, Windows Media Player, Process found but window Not,3000,2
	Else
		{
		PostMessage, 0x111, Stop, 0, ,%WinTitle%
		Sleep, 50
		PostMessage, 0x111, Prev, 0, ,%WinTitle%
		Sleep, 50
		; WMP := new RemoteWMP
		; Media := WMP.player.currentMedia
		; Controls := WMP.player.Controls
		thecall2:
		GoSub WMP_Refresh_2
		if newsong =% oldsong
			{
			;tooltip, newsong = oldsong
			Sleep, 100
			GoSub thecall2
			}
		Else
			{
			WMP.jump(StartPos_Offset)
			Sleep, 350
			PostMessage, 0x319, 0, Play, ,%WinTitle%
			Return
			}
		Return
		}
	Return

/* 
youtube_next:
sendinput, {Media_Next}, chrome
 */


WMP_NEXT:
Process, Exist, WMPlayer.exe
ifWinNotExist, Windows Media Player
	{
	TrayTip, Windows Media Player, Process found but window Not,3000,2
	Return
	}
Else
	{
	oldsong =% newsong
	PostMessage, 0x111, Stop, 0, ,%WinTitle%
	Sleep, 50
	PostMessage, 0x111, Next, 0, ,%WinTitle%
	Sleep, 50
	thecall1:
	GoSub WMP_Refresh_2
	if newsong =% oldsong
		{
		TrayTip Windows Media Player, End of Playlist		
		;tooltip, newsong = oldsong
		Exit
		} Else	{
		GoSub Genre_Search
		WMP.jump(StartPos_Offset)
		Sleep, 101
		PostMessage, 0x319, 0, Play, ,%WinTitle%
		}
	Return
	}
 
WMP_Copy_Search:
{
WMP := new RemoteWMP
Sleep, 20
Media := WMP.player.currentMedia
Controls := WMP.player.Controls
Sleep, 20
FullPath:=Media.sourceurl
Sleep, 20
Process, Exist, slsk2.exe
     if !ErrorLevel
		{
		TrayTip, Windows Media Player,, error slsk not open
	} Else {
		SplitPath, FullPath,  , , , OutNameNoExt
		1st:= RegExReplace(OutNameNoExt,Needle4, " ")
		2nd:= RegExReplace(1st,Needle2, " ")
		Run "C:\script\AHK\Working\slsk fix.ahk"	
		MouseGetPos, orig_x, orig_y
		Sleep, 1500	
		WinGetPos,,, Width, Height, %WinTitle%
		Sleep, 500
		;WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (1400/2)-(400/2)
		MouseMove, 145, 90,,
		Send {LButton}
		Send % Stripped_Name := RegExReplace(2nd, Needle3, " ")
		Send {Enter}
		MouseMove, 1453, 243,,
		Send {LButton}
		MouseMove, orig_x, orig_y, 
		Clipboard:=Stripped_Name
		Return
		}
}

WMP_Copy_Search_explorer:
{
GoSub WMP_Refresh_2
GoSub Genre_Search
TrayTip, Windows Media Player, path
FullPath=%newsong%
splitpath, FullPath,  , , , OutNameNoExt
1st:= RegExReplace(OutNameNoExt,Needle4, " ")
2nd:= RegExReplace(1st,Needle2, " ")
run explorer.exe %Search_Root%
winwaitactive, ahk_exe explorer.exe, , 5
Sleep, 1000
sendinput ^f
Sleep, 1500
Send % Stripped_Name := RegExReplace(2nd, "( . )|(^[a-z][\s])|(    )|(   )|(  )|[.]", " ")
Sleep, 500
sendinput {enter}
	;Send {enter}
	;MouseMove, 1421, 243,,
	;Send {LButton}
	;MouseMove, orig_x, orig_y, 
	;Clipboard:=3rd
	;Return
}

Genre_Search:
	{
	p:= 1
	Matched_String:= ""
	genre:=""
	while p := RegExMatch(newsong, Genres, Matched_String, p + StrLen(Matched_String)) {
		if Matched_String=dnb
			StartPos_Offset:=86, p:=999, Genre:="dnb", Search_Root:="S:\- DNB"
		Else if Matched_String=reggae
			StartPos_Offset:=14, p:=999, Genre:="reggae", Search_Root:="S:\- REGGAE"
		Else if Matched_String=riddim
			StartPos_Offset:=14, p:=999, Genre:="riddim", Search_Root:="S:\- REGGAE"
		Else if Matched_String=hiphop
			StartPos_Offset:=17, p:=999, Genre:="hiphop", Search_Root:="S:\- HIPHOP"
		Else if Matched_String=garage
			StartPos_Offset:=45, p:=999, Genre:="garage", Search_Root:="S:\- - MP3 -\Garage"
		Else if Matched_String=rock
			StartPos_Offset:=17, p:=999, Genre:="rock", Search_Root:="S:\- - MP3 -\- Other\Rock"
		Else if Matched_String=ambient
			StartPos_Offset:=30, p:=999, Genre:="ambient", Search_Root:="S:\- - MP3 -\Chill"
		Else if Matched_String=samples
			StartPos_Offset:=0, p:=999, Genre:="samples", Search_Root:="S:\Samples"
		Else if Matched_String=my music
			StartPos_Offset:=0, p:=999, Genre:="my music", Search_Root:="S:\Documents\My Music"
		Else if Matched_String=audiobooks
			StartPos_Offset:=0, p:=999, Genre:="audiobooks", Search_Root:="S:\Documents\My Audio"
		Else if Matched_String=sLSk
			StartPos_Offset:=45, p:=999, Genre:="sLSk"
		Else if Matched_String=FOAD
			StartPos_Offset:=0, p:=999, Genre:=""
		Return
		}
	}


WMP_Refresh: 
{
WMP := new RemoteWMP
Media := WMP.player.currentMedia
Controls := WMP.player.Controls
Return
}

WMP_Refresh_2:
{
Sleep, 200
GoSub WMP_refresh
Sleep, 200
newsong= % Media.sourceURL
Sleep, 200
Return
}


WMP_Del: 
{
Process, Exist, WMPlayer.exe
WMP2del := new RemoteWMP
Sleep, 300
Media2del := WMP2del.player.currentMedia
GoSub WMP_next
SetTimer, DELETE_, -1000
Return
}

DELETE_:   
{   
try 
File2Del= % Media2del.sourceURL
catch
GoSub WMP_Del
FileRecycle, % File2Del
TrayTip, Windows Media Player, Deleted %File2Del%, 3, 1
Return
}


Clip_Commander:
if clipboard!=%Monster_Clip%
{
	SetTimer Clip_Commander, off
Menu, Tray, Icon, WMP.ico
}
Else Return


class RemoteWMP
{
   __New()  {
      static IID_IOleClientSite := "{00000118-0000-0000-C000-000000000046}"
           , IID_IOleObject     := "{00000112-0000-0000-C000-000000000046}"
      Process, Exist, WMPlayer.exe
      if !ErrorLevel
         TrayTip, Windows Media Player, WMPlayer.exe is not running
      if !this.player := ComObjCreate("WMPlayer.OCX.7")
		TrayTip, Windows Media Player, Failed to get WMPlayer.OCX.7 object
      this.rms := IWMPRemoteMediaServices_CreateInstance()
      this.ocs := ComObjQuery(this.rms, IID_IOleClientSite)
      this.ole := ComObjQuery(this.player, IID_IOleObject)
      DllCall(NumGet(NumGet(this.ole+0)+3*A_PtrSize), "Ptr", this.ole, "Ptr", this.ocs)
   }
   
   __Delete()  {
      if !this.player
         Return
      DllCall(NumGet(NumGet(this.ole+0)+3*A_PtrSize), "Ptr", this.ole, "Ptr", 0)
      for k, obj in [this.ole, this.ocs, this.rms]
         ObjRelease(obj)
      this.player := ""
   }
   
   Jump(sec)  {
      this.player.Controls.currentPosition += sec
   }
   
   TogglePause()  {
      if (this.player.playState = 3)  ; Playing = 3
         this.player.Controls.pause()
      Else
         this.player.Controls.play()
   }
}

IWMPRemoteMediaServices_CreateInstance()
{
   static vtblUnk, vtblRms, vtblIsp, vtblOls, vtblPtrs := 0, size := (A_PtrSize + 4)*4 + 4
   if !VarSetCapacity(vtblUnk)  {
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

   Return pObj
}

IUnknown_QueryInterface(this_, riid, ppvObject)
{
   static IID_IUnknown, IID_IWMPRemoteMediaServices, IID_IServiceProvider, IID_IOleClientSite
   if !VarSetCapacity(IID_IUnknown)  {
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
      Return 0 ; S_OK
   }

   if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IWMPRemoteMediaServices) {
      off := NumGet(this_+0, A_PtrSize, "UInt")
      NumPut((this_ - off)+(A_PtrSize + 4), ppvObject+0, "Ptr")
      IUnknown_AddRef(this_)
      Return 0 ; S_OK
   }

   if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IServiceProvider) {
      off := NumGet(this_+0, A_PtrSize, "UInt")
      NumPut((this_ - off)+((A_PtrSize + 4)*2), ppvObject+0, "Ptr")
      IUnknown_AddRef(this_)
      Return 0 ; S_OK
   }

   if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IOleClientSite)  {
      off := NumGet(this_+0, A_PtrSize, "UInt")
      NumPut((this_ - off)+((A_PtrSize + 4)*3), ppvObject+0, "Ptr")
      IUnknown_AddRef(this_)
      Return 0 ; S_OK
   }

   NumPut(0, ppvObject+0, "Ptr")
   Return 0x80004002 ; E_NOINTERFACE
}

IUnknown_AddRef(this_)
{
   off := NumGet(this_+0, A_PtrSize, "UInt")
   iunk := this_-off
   NumPut((_refCount := NumGet(iunk+0, (A_PtrSize + 4)*4, "UInt") + 1), iunk+0, (A_PtrSize + 4)*4, "UInt")
   Return _refCount
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
   Return _refCount
}

IWMPRemoteMediaServices_GetServiceType(this_, pbstrType)
{
   NumPut(DllCall("oleaut32\SysAllocString", "WStr", "Remote", "Ptr"), pbstrType+0, "Ptr")
   Return 0
}

IWMPRemoteMediaServices_GetScriptableObject(this_, pbstrName, ppDispatch)
{
   Return 0x80004001
}

IWMPRemoteMediaServices_GetCustomUIMode(this_, pbstrFile)
{
   Return 0x80004001
}

IServiceProvider_QueryService(this_, guidService, riid, ppvObject)
{
   Return IUnknown_QueryInterface(this_, riid, ppvObject)
}
Return


InvokeVerb(path, menu, validate=True) {
    objShell := ComObjCreate("Shell.Application")
    if InStr(FileExist(path), "D") || InStr(path, "::{") {
        objFolder := objShell.NameSpace(path)   
        objFolderItem := objFolder.Self
    } Else {
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
                Return True
            }
        }
		Return False
    } Else
        objFolderItem.InvokeVerbEx(Menu)
} 
Sleep, 2000
Return

AppVolume(app:="", device:="")
{
	Return new AppVolume(app, device)
}

class AppVolume
{
	ISAVs := []
	
	__New(app:="", device:="")
	{
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
			VA_IAudioSessionControl2_GetProcessID(pIASC2, PID)
			if (PID == app || this.GetProcessName(PID) == app)
				this.ISAVs.Push(ComObjQuery(pIASC2, IID_ISAV))
			
			ObjRelease(pIASC2)
		}
		
		; Release the IAudioSessionEnumerator
		ObjRelease(pIASE)
	}
	
	__Delete()
	{
		for k, pISAV in this.ISAVs
			ObjRelease(pISAV)
	}
	
	AdjustVolume(Amount)
	{
		Return this.SetVolume(this.GetVolume() + Amount)
	}
	
	GetVolume()
	{
		for k, pISAV in this.ISAVs
		{
			VA_ISimpleAudioVolume_GetMasterVolume(pISAV, fLevel)
			Return fLevel * 100
		}
	}
	
	SetVolume(level)
	{
		level := level>100 ? 100 : level<0 ? 0 : level ; Limit to range 0-100
		for k, pISAV in this.ISAVs
			VA_ISimpleAudioVolume_SetMasterVolume(pISAV, level / 100)
		Return level
	}
	
	GetMute()
	{
		for k, pISAV in this.ISAVs
		{
			VA_ISimpleAudioVolume_GetMute(pISAV, bMute)
			Return bMute
		}
	}
	
	SetMute(bMute)
	{
		for k, pISAV in this.ISAVs
			VA_ISimpleAudioVolume_SetMute(pISAV, bMute)
		Return bMute
	}
	
	ToggleMute()
	{
		Return this.SetMute(!this.GetMute())
	}
	
	GetProcessName(PID) {
		hProcess := DllCall("OpenProcess"
		, "UInt", 0x1000 ; DWORD dwDesiredAccess (PROCESS_QUERY_LIMITED_INFORMATION)
		, "UInt", False  ; BOOL  bInheritHandle
		, "UInt", PID    ; DWORD dwProcessId
		, "UPtr")
		dwSize := VarSetCapacity(strExeName, 512 * A_IsUnicode, 0) // A_IsUnicode
		DllCall("QueryFullProcessImageName"
		, "UPtr", hProcess  ; HANDLE hProcess
		, "UInt", 0         ; DWORD  dwFlags
		, "Str", strExeName ; LPSTR  lpExeName
		, "UInt*", dwSize   ; PDWORD lpdwSize
		, "UInt")
		DllCall("CloseHandle", "UPtr", hProcess, "UInt")
		SplitPath, strExeName, strExeName
		Return strExeName
	}
}

; --- Vista Audio Additions ---
;
; ISimpleAudioVolume : {87CE5498-68D6-44E5-9215-6DA47EF883D8}
;
VA_ISimpleAudioVolume_SetMasterVolume(this, ByRef fLevel, GuidEventContext="") {
	Return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "float", fLevel, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMasterVolume(this, ByRef fLevel) {
	Return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "float*", fLevel)
}
VA_ISimpleAudioVolume_SetMute(this, ByRef Muted, GuidEventContext="") {
	Return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "int", Muted, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMute(this, ByRef Muted) {
	Return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "int*", Muted)
}




/* 

;OTHER SHIT::::::::::::


; MsgBox, % Media.sourceURL
; MsgBox, % Controls.currentPosition . "`n"
        ; . Controls.currentPositionString
; MsgBox, % Media.getItemInfo("WM/AlbumTitle")
; All attribute names you can get with Media.getItemInfo(attributeName)
; Loop % Media.attributeCount
   ; attributes .= Media.getAttributeName(A_Index - 1) . "`r`n"
; MsgBox, % Clipboard := attributes


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

18779 - Open "Properties" dialog RC=FAIL. Use 32779 or PostMessage
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
18825 - Open "Options" dialog RC=FAIL. Use 32825 or PostMessage
18826 - Open "Windows Media Player Help"

18834 - Play Speed: Fast
18835 - Play Speed: Normal
18836 - Play Speed: Slow

18842 - Shuffle (toggle)
18843 - Repeat (toggle)

18846 - Download: Visualizations Link to external web page

18849 - Open "Add to Library by Searching Computer" dialog RC=FAIL. Use 32849 or PostMessage
18850 - Open "Monitory Folders" dialog RC=FAIL. Use 32850 or PostMessage

18861 - Open "File Open" dialog RC=FAIL. Use 32861 or PostMessage
18862 - Open "Open URL" dialog RC=FAIL. Use 32862 or PostMessage

18871 - Open "Manage Licenses" dialog RC=FAIL. Use 32871 or PostMessage
18872 - Open "Open URL" dialog (Same as 18862?) RC=FAIL. Use 32862 or PostMessage

Codes 18880 to ????? causes WMP to crash. RC=FAIL or
RC=0. Haven't tried PostMessage


18889 - Save "Now Playing List" As RC=FAIL. Use ????? or PostMessage

18904 - Work Offline (toggle)

18907 - Burn Audio CD

18909 - Synchronize

18794 - Open "Statistics" dialog

19102 - Print Label Not sure when this is available

19011 - Open "Save As" dialog RC=FAIL. Use ????? or PostMessage

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
19501 - DVD: Title Menu Returns 1 if menu is not available (?)
19502 - DVD: Close Menu (Resume)
19503 - DVD: Back

19572 - Update DVD Information RC=FAIL. Use ????? or PostMessage

19681 - DVD, VCD or CD Audio

19721 - Show Menu Bar
19722 - Hide Menu Bar
19723 - Autohide Menu Bar
19724 - Hide Taskbar (toggle)

19998 - Download: Plug-ins Link to external web page
19999 - Open Plug-ins Options dialog RC=FAIL. Use 19498 or PostMessage

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
RC=0. Haven't tried PostMessage.

57601 - Open "File Open" dialog RC=FAIL. Use 32861 or PostMessage
57602 - File Close

57665 - Exit


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