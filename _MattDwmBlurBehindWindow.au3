#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.3.14.5
		Author: MATTHEW WOLFF
			Script function: Windows 10 DWM hook
				Date: 22.2.2022
#ce ----------------------------------------------------------------------------

#noTrayIcon ;#include <GUIConstants.au3> 
#include <WindowsConstants.au3>
#include <msgboxConstants.au3>
#include <WinAPI.au3>
#include <Process.au3>
#include <Misc.au3>
#include <TrayConstants.au3> ; Required for $TRAY_ICONSTATE_SHOW, $TRAY_ITEM_EXIT and $TRAY_ITEM_PAUSE

global 	$BlackClassList = "TaskListThumbnailWnd,SysDragImage,WMPMessenger,Scintilla,BasicWindow,OleMainThreadWndClass ProgMan,WorkerW,Listbox,SideBar_HTMLHostWindow,MozillaWindowClass,Shell_TrayWnd,MSTasklistWClass,ToolbarWindow32,TaskListOverlayWnd,tooltips_class32,WMP Skin Host,WMPTransition,CWmpControlCntr,Shell_LightDismissOverlay,Shell_Flyout,OnScreenPanelWindow,ZafWindow,wacom,nvidia,olechan,kbxLabelClass,WTLAlphaMouse,Tablet,WTouch_,directuihwnd,Net UI Tool Window"
global 	$hDLL, $hWinEventProc, $hHook, $Style, $StyleOld, $Class, $ClassLog
global 	$sStruct = DllStructCreate("dword;int;ptr;int")
local 	$idrestart = TrayCreateItem("restart")

Opt("TrayAutoPause", 0)

traySetIcon ( "1.ico" ) 	;	TraySetPauseIcon( "2.ico" )
DllCall("User32.dll", "bool", "SetProcessDPIAware")
If _Singleton(@ScriptName, 1) = 0 Then
    msgbox($MB_SYSTEMMODAL, "Error", @ScriptFullPath & ' Already Running ')
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
    ;TrayCreateItem("Radio 1", -1, -1, $TRAY_ITEM_RADIO)
  ;  TrayItemSetState(-1, $TRAY_CHECKED)
   ; TrayCreateItem("Radio 2", -1, -1, $TRAY_ITEM_RADIO)
  ;  TrayCreateItem("Radio 3", -1, -1, $TRAY_ITEM_RADIO)
  ;  TrayCreateItem("") ; Create a separator line.

    local $idAbout = TrayCreateItem("About")
  ;  TrayCreateItem("") ; Create a separator line.

    TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.

	while 1
		Switch TrayGetMsg()
			Case $idAbout ; Display a message box about the AutoIt version and installation path of the AutoIt executable.
				msgbox($MB_SYSTEMMODAL, "", "AutoIt tray menu example." & @CRLF & @CRLF & _
					"Version: " & @AutoItVersion & @CRLF & _
					"Install Path: " & StringLeft(@AutoItExe, StringInStr(@AutoItExe, "\", $STR_NOCASESENSEBASIC, -1) - 1)) ; Find the folder of a full path.
			Case $idrestart ; Exit the loop.
				ReCreateMyself()
		EndSwitch
    WEnd
EndFunc   ;==>Example

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

			case "chrome.exe"
				return
			case "opera.exe"
				return
			case "matrix.scr"
				return
			case "RobloxPlayerBeta.exe"
				return
			case "lockapp.exe"
				return
			case "logonui.exe"
				return
			case "firefox.exe"
				return
			case "edge.exe"
				return
			case "steam.exe"
				return
			case "steamwebhelper.exe"
				return
			case "discord.exe"
				return
			case "terraria.exe"
				return
			; case "wmplayer.exe"
				; return
			case "wallpaper64.exe"
				return
			case "wallpaper32.exe"
				return
			case "ui32.exe"
				return
			case "sidebar.exe"
				return
			case "ImageGlass.exe"
				return
			case "sndvol.exe"
				return
			case "StartMenuExperienceHost.exe"
				return
			case "devenv.exe"
				return
			case "dimmer.exe"
				return
			case "RzSynapse.exe"
				return
			case "d2r.exe"
				return
			case "cengine.exe"
				return
			case "ScreenToGif.exe"
				return
			case "NVIDIA Share.exe"
				return
			case "GitHubDesktop.exe"
				return
			case "Autohotkey2.exe" 
				return
			case "GoogleDriveFS.exe" 
				return
			case "Wacom_TabletUser.exe" 
				return
			case "Wacom_TouchUser.exe" 
				return
			case "WacomDesktopCenter.exe" 
				return
			case "Wacom_Tablet.exe" 
				return
			case "gimp-2.10.exe" 
				return
			case "OUTLOOK.EXE" 
				return
			case "WINWORD.EXE" 
				return
		endSwitch

		local $sTitle = winGetTitle($hWnd)
		switch $sTitle
			case "ninjmag"
				return
			case "Roblox"
				return
			case "MIDI IN / OUT"
				return
			case "MIDI"
				return
			case "APCGUI"
				return
			case "APCBackMain"
				return
			case "no_glass"
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
				case "TaskListThumbnailWnd" 
					return
				case "SysDragImage" 
					return
				case "LockScreenControllerProxyWindow" 
					return
				case "COMTASKSWINDOWCLASS" 
					return
				case "MSCTFIME UI" 
					return
				case "TaskListThumbnailWnd" 
					return
				case "WMPMessenger" 
					return
				case "LockScreenBackstopFrame" 
					return
				case "IME" 
					return
				case "Scintilla" 
					return
				case "BasicWindow" 
					return
				case "OleMainThreadWndClass" 
					return
				case "ProgMan" 
					return
				case "WorkerW" 
					return
				case "Listbox" 
					return
				case "SideBar_HTMLHostWindow" 
					return
				case "MozillaWindowClass" 
					return
				case "Shell_TrayWnd" 
					return
				case "MSTasklistWClass" 
					return
				case "ToolbarWindow32" 
					return
				case "TaskListOverlayWnd" 
					return
				case "XAMLMessageWindowClass" 
					return
				case "#43" 
					return
				;case "ConsoleWindowClass" 
					;return
				case "OleDdeWndClass" 
					return
				case "BioFeedbackUX XAML Host" 
					return
				case "OfficePowerManagerWindow" 
					return
				case "UserAdapterWindowClass" 
					return
				case "GDI+ Hook Window Class" 
					return
				case "crashpad_SessionEndWatcher" 
					return
				case "Static" 
					return
				case "CicMarshalWndClass" 
					return
				case "XCPTimerClass" 
					return
				case "Windows.UI.Core.CoreWindow" 
					return
				;case "tooltips_class32" 
					;return
				case "Autohotkey2" 
					return
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
endFunc   	; 		WinEventProc

func _DwmEnableBlurBehindWindow($hWnd)
         const $DWM_BB_ENABLE = 0x00000001
         DllStructSetData($sStruct, 1, $DWM_BB_ENABLE)
         DllStructSetData($sStruct, 2, "1")
         DllStructSetData($sStruct, 4, "1")
         _WinAPI_SetLayeredWindowAttributes($hWnd, 0x000000); Must be here!
         $Ret = DllCall(	"dwmapi.dll", "int", "DwmEnableBlurBehindWindow", "hwnd", $hWnd, "ptr", DllStructGetPtr($sStruct))
         if @error then
             return 0
         else
             return $Ret
         endIf
 endFunc 	; 		DwmEnableBlurBehindWindow

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
endFunc   	; 		SetWinEventHook

Func ReCreateMyself()
   ; If @Compiled Then
      ;  Run(@ScriptFullPath);just run the exe
  ;  Else        ;$AutoIt3Path = RegRead("HKEY_local_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "betaInstallDir");installDir for beta
       $AutoIt3Path = RegRead("HKEY_local_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "InstallDir") ;installDir for production
	 
       $ToRun1 = '"' & $AutoIt3Path & '\AutoIt3.exe "' & ' "' & @ScriptFullPath & '"'
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
endFunc   	; 		OnAutoItexit