#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.3.14.5
		Author: sPksNinj
			Script Function:
				Date: 21.03.2021
#ce ----------------------------------------------------------------------------

; Script Start
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <Process.au3>
#include <Misc.au3>
Global $hDLL, $hWinEventProc, $hHook
Global $Struct = DllStructCreate("int cxLeftWidth;int cxRightWidth;int cyTopHeight;int cyBottomHeight;")
Global $sStruct = DllStructCreate("dword;int;ptr;int")

$hDLL = DllOpen("User32.dll")
$hWinEventProc = DllCallbackRegister("_WinEventProc", "none", "hwnd;int;hwnd;long;long;int;int")
If Not @error Then
    OnAutoItExitRegister("OnAutoItExit")
Else
    MsgBox(16 + 262144, "Error", "DllCallbackRegister(_WinEventProc) did not succeed.")
    Exit
EndIf

$hHook = _SetWinEventHook($hDLL)
If @error Then
    MsgBox(16 + 262144, "Error", "_SetWinEventHook() did not succeed.")
    Exit
EndIf

While 1
    Sleep(10)
WEnd

Func _WinEventProc($hHook, $iEvent, $hWnd, $idObject, $idChild, $iEventThread, $iEventTime)
    Local $PID = WinGetProcess($hWnd), $sEventProcName = _ProcessGetName($PID)
		if($iEvent = 0x8000) Then 
				_DwmEnableBlurBehindWindow($hWnd)
		EndIf
EndFunc   ;==>_WinEventProc

Func _DwmEnableBlurBehindWindow($hWnd)
         Const $DWM_BB_ENABLE = 0x00000001
         DllStructSetData($sStruct, 1, $DWM_BB_ENABLE)
         DllStructSetData($sStruct, 2, "1")
         DllStructSetData($sStruct, 4, "1")
         GUISetBkColor(0x000000); Must be here!
         $Ret = DllCall(	"dwmapi.dll", "int", "DwmEnableBlurBehindWindow", "hwnd", $hWnd, "ptr", DllStructGetPtr($sStruct))
         If @error Then
             Return 0
         Else
             Return $Ret
         EndIf
 EndFunc ;==>_DwmEnableBlurBehindWindow

Func _SetWinEventHook($hDLLUser32)
    Local $aRet
	Local Const $ACUNT = 0x8000
    Local Const $WINEVENT_OUTOFCONTEXT = 0x0
    Local Const $WINEVENT_SKIPOWNPROCESS = 0x2
    If Not $hDLLUser32 Or $hDLLUser32 = -1 Then $hDLLUser32 = "User32.dll"
    $aRet = DllCall($hDLLUser32, "hwnd", "SetWinEventHook", _
            "uint", $ACUNT , _
            "uint", $ACUNT , _
            "hwnd", 0, _
            "ptr", DllCallbackGetPtr($hWinEventProc), _
            "int", 0, _
            "int", 0, _
            "uint", BitOR($WINEVENT_OUTOFCONTEXT, $WINEVENT_SKIPOWNPROCESS))
    If @error Then Return SetError(@error, 0, 0)
    Return $aRet[0]
EndFunc   ;==>_SetWinEventHook

Func OnAutoItExit()
    If $hWinEventProc Then
        Beep(3000, 5)
        DllCallbackFree($hWinEventProc)
    EndIf
    If $hHook Then DllCall("User32.dll", "int", "UnhookWinEvent", "hwnd", $hHook)
    If $hDLL Then DllClose($hDLL)
EndFunc   ;==>OnAutoItExit