#include <GUIConstants.au3>

 $Struct = DllStructCreate("int cxLeftWidth;int cxRightWidth;int cyTopHeight;int cyBottomHeight;")
 $sStruct = DllStructCreate("dword;int;ptr;int")

 Global $MyArea[4] = [50, 50, 50, 50]

 $GUI = GUICreate("Windows Vista DWM", 243, 243)
 $Apply = GUICtrlCreateButton("Apply", 80, 104, 83, 25, 0)
 GUISetState()

 While 1
	$iMsg = GUIGetMsg()
	Switch $iMsg
	Case $GUI_EVENT_CLOSE
		Exit
	Case $Apply
		_Vista_ApplyGlass($GUI)
		_Vista_EnableBlurBehind($GUI)
		_Vista_EnableBlurBehind($GUI)
	EndSwitch
 WEnd

 Func _Vista_ApplyGlass($hWnd, $bColor = 0x000000)

         GUISetBkColor($bColor); Must be here!
         $Ret = DllCall(	"dwmapi.dll", 
								"long", 
								"DwmExtendFrameIntoClientArea", 
								"hwnd", $hWnd, 
								"long*", DllStructGetPtr($Struct))
         If @error Then
             Return 0
             SetError(1)
         Else
             Return $Ret
         EndIf

 EndFunc ;==>_Vista_ApplyGlass

 Func _Vista_ApplyGlassArea($hWnd, $Area, $bColor = 0x000000)

         If IsArray($Area) Then
             DllStructSetData($Struct, "cxLeftWidth", $Area[0])
             DllStructSetData($Struct, "cxRightWidth", $Area[1])
             DllStructSetData($Struct, "cyTopHeight", $Area[2])
             DllStructSetData($Struct, "cyBottomHeight", $Area[3])
             GUISetBkColor($bColor); Must be here!
             $Ret = DllCall(	"dwmapi.dll", 
									"long*", 
									"DwmExtendFrameIntoClientArea", 
									"hwnd", $hWnd, 
									"ptr", DllStructGetPtr($Struct))
             If @error Then
                 Return 0
             Else
                 Return $Ret
             EndIf
         Else
             MsgBox(16, "_Vista_ApplyGlassArea", "Area specified is not an array!")
         EndIf

 EndFunc ;==>_Vista_ApplyGlassArea

 Func _Vista_EnableBlurBehind($hWnd, $bColor = 0x000000)

         Const $DWM_BB_ENABLE = 0x00000001

         DllStructSetData($sStruct, 1, $DWM_BB_ENABLE)
         DllStructSetData($sStruct, 2, "1")
         DllStructSetData($sStruct, 4, "1")

         GUISetBkColor($bColor); Must be here!
         $Ret = DllCall(	"dwmapi.dll", 
								"int", 
								"DwmEnableBlurBehindWindow", 
								"hwnd", $hWnd, 
								"ptr", DllStructGetPtr($sStruct))
         If @error Then
             Return 0
         Else
             Return $Ret
         EndIf

 EndFunc ;==>_Vista_EnableBlurBehind

 Func _Vista_ICE()
     $ICEStruct = 	DllStructCreate(	"int;")
     $Ret = 			DllCall(					"dwmapi.dll", 
														"int", 
														"DwmIsCompositionEnabled", 
														"ptr", DllStructGetPtr($ICEStruct))
     If @error Then
         Return 0
     Else
         Return DllStructGetData($ICEStruct, 1)
     EndIf
 EndFunc ;==>_Vista_ICE