#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.3.14.5
		Author: sPksNinj
			Script function: Windows 10 DWM hook
				Date: 21.03.2021
#ce ----------------------------------------------------------------------------

#NoTrayIcon
#include <TrayConstants.au3> ; Required for the $TRAY_ICONSTATE_SHOW constant.
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPI.au3>
#include <Process.au3>
#include <Misc.au3>
TraySetIcon ( "1.ico" )
TraySetPauseIcon( "2.ico" )
If _Singleton(@ScriptName, 1) = 0 Then
    MsgBox($MB_SYSTEMMODAL, "Warning", "An occurrence is already running, close it first")
    exit
endIf

global $hDLL, $hWinEventProc, $hHook, $Style, $StyleOld
global $sStruct = DllStructCreate("dword;int;ptr;int")
global $BlackClassList = "TaskListThumbnailWnd SysDragImage WMPMessenger Scintilla BasicWindow OleMainThreadWndClass ProgMan WorkerW Listbox SideBar_HTMLHostWindow MozillaWindowClass Shell_TrayWnd "

$hDLL = DllOpen("User32.dll")
$hWinEventProc = DllCallbackRegister("_WinEventProc", "none", "hwnd;int;hwnd;long;long;int;int")
if not @error then
    OnAutoItexitRegister("OnAutoItexit")
else
    MsgBox(16 + 262144, "Error", "DllCallbackRegister(_WinEventProc) did not succeed.")
    exit
endIf

$hHook = _SetWinEventHook($hDLL)
if @error then
    MsgBox(16 + 262144, "Error", "_SetWinEventHook() did not succeed.") 	
    exit
endIf

MsgBox($MB_SYSTEMMODAL, "", @ScriptFullPath)

while 1
    Sleep(5)
;	Example()
wEnd

func _WinEventProc($hHook, $iEvent, $hWnd, $idObject, $idChild, $iEventThread, $iEventTime)
    local $PID = WinGetProcess($hWnd), $sEventProcName = _ProcessGetName($PID)
	if($iEvent = 0x8000) then 
		switch $sEventProcName
			case "chrome.exe"
				return
			case "opera.exe"
				return
			case "firefox.exe"
				return
			case "edge.exe"
				return
			case "steam.exe"
				return
			case "discord.exe"
				return
			case "terraria.exe"
				return
			case "wmplayer.exe"
				return
			case "wallpaper64.exe"
				return
			case "wallpaper32.exe"
				return
			case "sidebar.exe"
				return
			case "MSIAfterburner.exe"
				return
		endSwitch

		local $sTitle = winGetTitle($hWnd)
		switch $sTitle
			case "ninjmag"
				return
			case "Roblox"
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
					_WinAPI_SetLayeredWindowAttributes($hWnd, 0x000000) 	; 	not yet implemented comp
			endSwitch
		endif
		if _DwmEnableBlurBehindWindow($hWnd) then
			$Injsuxs = "dwm Inject - "
			$Injsuxs = $Injsuxs & $class
		endIf
	endIf
endFunc   ;==>_WinEventProc

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
 endFunc ;==>_DwmEnableBlurBehindWindow

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
endFunc   ;==>_SetWinEventHook

func OnAutoItexit()
    if $hWinEventProc then
        Beep(3000, 5)
        DllCallbackFree($hWinEventProc)
    endIf
    if $hHook then DllCall("User32.dll", "int", "UnhookWinEvent", "hwnd", $hHook)
    if $hDLL then DllClose($hDLL)
endFunc   ;==>OnAutoItexit