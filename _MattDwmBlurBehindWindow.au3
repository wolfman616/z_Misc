#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.3.14.5
		Author: MATTHEW J WOLFF
			Script function: Windows 10 Event hook ->  DWM 
				Date: 17.4.2022
#ce ----------------------------------------------------------------------------

#noTrayIcon                  ; #include <GUIConstants.au3>  
#include <Process.au3>
#include <TrayConstants.au3> ; Req 4 $TRAY_ICONSTATE_SHOW, $TRAY_ITEM_EXIT and $TRAY_ITEM_PAUSE
#include <WindowsConstants.au3>
#include <MsgboxConstants.au3>
#include <WinAPI.au3>
#include <Process.au3>
#include <Misc.au3>
#include <File.au3>
#include <WinAPIProc.au3>
#include <Array.au3>

DllCall("User32.dll", "bool", "SetProcessDPIAware") 

global $hDLL, $hWinEventProc, $hHook, $Style, $StyleOld, $Class, $ClassLog, $sStruct, $BlackClassList
$sStruct = DllStructCreate("dword;int;ptr;int")
$BlackClassList = "TaskListThumbnailWnd,SysDragImage,WMPMessenger,Scintilla,BasicWindow,OleMainThreadWndClass ProgMan,WorkerW,Listbox,SideBar_HTMLHostWindow,MozillaWindowClass,Shell_TrayWnd,MSTasklistWClass,ToolbarWindow32, TaskListOverlayWnd,tooltips_class32,WMP Skin Host, WMPTransition,CWmpControlCntr,Shell_LightDismissOverlay,Shell_Flyout,OnScreenPanelWindow,ZafWindow,wacom,nvidia,olechan,kbxLabelClass,WTLAlphaMouse,Tablet,WTouch_,directuihwnd,Net UI Tool Window,midi,MultitaskingViewFrame"
Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
Local $aPathSplit = _PathSplit(@ScriptFullPath, $sDrive, $sDir, $sFileName, $sExtension)
;_ArrayDisplay($aPathSplit, "_PathSplit of " & @ScriptFullPath)
local $idrestart = TrayCreateItem("restart")
;$arrProc = ProcessList()
;_ArrayDisplay($arrProc,  "2D display transposed", "|7", 64))
traySetIcon(      "1.ico" ) 	
TraySetPauseIcon( "2.ico" )
Opt("TrayAutoPause", 1)
DllCall("User32.dll", "bool", "SetProcessDPIAware")
If _Singleton(@ScriptName, 1) = 0 Then
    msgbox($MB_SYSTEMMODAL, "Error", @ScriptFullPath & ' Already Running ')
	Run("explorer.exe " & $sDrive & $sDir)
	_WinAPI_TerminateProcess ( $hProcess [, $iExitCode = 0] )
    exit
endIf

$hDLL = DllOpen("User32.dll")
$hWinEventProc = DllCallbackRegister("_WinEventProc", "none", "hwnd;int;hwnd;long;long;int;int")
if not @error then
    OnAutoItexitRegister("OnAutoItexit")
else
    msgbox(16 + 262144, "Error", "DllCallbackRegister(_WinEventProc) did not succeed.")
    exit
endIf

$hHook = _SetWinEventHook($hDLL)
if @error then
    msgbox(16 + 262144, "Error", "_SetWinEventHook() did not succeed.") 	
    exit
;else
	;msgbox($MB_SYSTEMMODAL, "", @ScriptFullPath)
endIf

while 1
    Sleep(1)
	Traywatch()
wEnd	

Func Traywatch()
  ;  TrayCreateItem("Radio 1", -1, -1, $TRAY_ITEM_RADIO)
  ;  TrayItemSetState(-1, $TRAY_CHECKED)
  ;  TrayCreateItem("") ; Create a separator line.
     local $idAbout = TrayCreateItem("About")
  ;  TrayCreateItem("") ;   separator line.
	TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.
	while 1
		Switch TrayGetMsg()
			Case $idAbout
				msgbox($MB_SYSTEMMODAL, "", "AutoIt tray menu example." & @CRLF & @CRLF & _
					"Version: " & @AutoItVersion & @CRLF & _
					"Install Path: " & StringLeft(@AutoItExe, StringInStr(@AutoItExe, "\", $STR_NOCASESENSEBASIC, -1) - 1))
				ReCreateMyself()
		EndSwitch
    WEnd
EndFunc ;==>TrayWatch

func _WinEventProc($hHook, $iEvent, $hWnd, $idObject, $idChild, $iEventThread, $iEventTime)
    local $PID = WinGetProcess($hWnd), $sEventProcName = _ProcessGetName($PID)
	if($iEvent = 0x8000) then 
		switch $sEventProcName
			; case "autoit3_x64.exe"
				; msgbox(16 + 262144, "SIDE", "Gay") 	
				; $Class = _WinAPI_GetClassName($hWnd)
				; if $Class = "#32768" then
				; msgbox(16 + 262144, "SIDE", "ssssGay") 	
					; return
				; endif
			case "chrome.exe","opera.exe","firefox.exe","edge.exe","WINWORD.EXE","OUTLOOK.EXE","devenv.exe","GitHubDesktop.exe","Autohotkey2.exe"
				return
			case "logonui.exe","lockapp.exe","matrix.scr","wallpaper64.exe","wallpaper32.exe","StartMenuExperienceHost.exe"
				return
			case "steam.exe","steamwebhelper.exe","terraria.exe","cengine.exe","RobloxPlayerBeta.exe","discord.exe" 
				return
			case "AccessibilityInsights.exe","ui32.exe","ImageGlass.exe","PowerToys.exe","RzSynapse.exe"
				return
			case "ScreenToGif.exe","d2r.exe","dimmer.exe","GoogleDriveFS.exe","sidebar.exe","NVIDIA Share.exe"
				return
			case "Wacom_TabletUser.exe","Wacom_TouchUser.exe","WacomDesktopCenter.exe","Wacom_Tablet.exe","inkscape.exe" 
				return
			;case "gimp-2.10.exe","sndvol.exe"
			;	return
		endSwitch

		local $sTitle = winGetTitle($hWnd)
		switch $sTitle
			case "no_glass","MIDI","MIDI IN / OUT","ninjmag","APCBackMain","APCGUI","Lingering Line","Roblox"
				return
		endSwitch
		
		$Class = _WinAPI_GetClassName($hWnd)
		if StringInStr ($BlackClassList, $Class) then
			return
		else
			switch $Class
				case "SysShadow" 
					$iStyle = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
					$iStyleold = $iStyle
					_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitXOR($iStyle, $WS_VISIBLE, $WS_DISABLED, $WS_EX_TRANSPARENT))
					WinSetTrans($hWnd, "", 0)
					$iStyle = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
					if $iStyle <> $iStyleold then
						$new = $iStyle - $iStyleold
						;ToolTip($new, 0, 40)
					endIf
					return		
				case "#32768" 
					_WinAPI_SetLayeredWindowAttributes($hWnd, 0x000000) 	; 	not working  
				case "TaskListThumbnailWnd","SysDragImage","LockScreenControllerProxyWindow","COMTASKSWINDOWCLASS","MSCTFIME UI","WMPMessenger","#43" 
					return
				case "TaskListThumbnailWnd","LockScreenBackstopFrame","IME","Scintilla","BasicWindow","OleMainThreadWndClass","ProgMan","WorkerW","Listbox" 
					return
				case "SideBar_HTMLHostWindow","MozillaWindowClass","Shell_TrayWnd","MSTasklistWClass","ToolbarWindow32","TaskListOverlayWnd","XAMLMessageWindowClass" 
					return
				case "BioFeedbackUX XAML Host","OfficePowerManagerWindow","UserAdapterWindowClass","GDI+ Hook Window Class""Static","crashpad_SessionEndWatcher" 
					return
				case "CicMarshalWndClass","XCPTimerClass","Windows.UI.Core.CoreWindow","Autohotkey2","OleDdeWndClass"
					return
				;case "tooltips_class32","ConsoleWindowClass" 
					;return
				case else
				#CS 
					$ClassLog = $ClassLog & @CRLF & $Class
					ToolTip($ClassLog, 0, 40)
				#CE
			endSwitch
		endif
		if _DwmEnableBlurBehindWindow($hWnd) then
			$Injsuxs = "Injected - "
			$Injsuxs = $Injsuxs & $class
			$ClassLog = $ClassLog & @CRLF & $Injsuxs
		endIf
	endIf
endFunc  ;==>WinEventProc

func _DwmEnableBlurBehindWindow($hWnd)
	const $DWM_BB_ENABLE = 0x00000001
	DllStructSetData($sStruct, 1, $DWM_BB_ENABLE)
	DllStructSetData($sStruct, 2, "1")
	DllStructSetData($sStruct, 4, "1")
	_WinAPI_SetLayeredWindowAttributes($hWnd, 0x000000); Must be here!
	$Ret = DllCall( "dwmapi.dll", "int", "DwmEnableBlurBehindWindow", "hwnd", $hWnd, "ptr", DllStructGetPtr($sStruct))
	if @error then
		return 0
	else
		return $Ret
	endIf
 endFunc ;==>DwmEnableBlurBehindWindow

func _SetWinEventHook($hDLLUser32)
    local $aRet
	local const $EVENT_OBJECT_CREATE = 0x8000
    local const $WINEVENT_OUTOFCONTEXT = 0x0
    local const $WINEVENT_SKIPOWNPROCESS = 0x2
    if not $hDLLUser32 Or $hDLLUser32 = -1 then $hDLLUser32 = "User32.dll"
    $aRet = DllCall($hDLLUser32, "hwnd", "SetWinEventHook", _
            "uint", $EVENT_OBJECT_CREATE , _
            "uint", $EVENT_OBJECT_CREATE , _
            "hwnd", 0, _
            "ptr", DllCallbackGetPtr($hWinEventProc), _
            "int", 0, _
            "int", 0, _
            "uint", BitOR($WINEVENT_OUTOFCONTEXT, $WINEVENT_SKIPOWNPROCESS))
    if @error then return SetError(@error, 0, 0)
    return $aRet[0]
endFunc   	;==>SetWinEventHook

Func ReCreateMyself()
  ; If @Compiled Then
      ;  Run(@ScriptFullPath);just run the exe
  ;  Else        ;$AutoIt3Path = RegRead("HKEY_local_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "betaInstallDir");installDir for beta
       $AutoIt3Path = RegRead("HKEY_local_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "InstallDir") ;installDir for production
       $ToRun1 = (StringLeft(@AutoItExe, StringInStr(@AutoItExe, "\", $STR_NOCASESENSEBASIC, -1) - 1)) & " & @ScriptFullPath & ")
      ConsoleWrite($ToRun1 & @CRLF);to test we have got it right
      Run($ToRun1)
  ;  EndIf
    Exit
EndFunc   ;==>ReCreateMyself

func OnAutoItexit()
    if $hWinEventProc then
        Beep(3000, 5)
        DllCallbackFree($hWinEventProc)
    endIf
    if $hHook then DllCall("User32.dll", "int", "UnhookWinEvent", "hwnd", $hHook)
    if $hDLL then DllClose($hDLL)
endFunc   	;==>OnAutoItexit