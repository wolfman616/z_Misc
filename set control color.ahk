#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#Singleinstance
#persistent
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include C:\Script\AHK\gdip2.ahk


Gui, Add, Edit, w320 h50 HwndMyTextHwnd, Here is some text that is given`na custom background color.
Gui, Add, Edit, w320 h50 HwndMyTextHwnd2, Here is some text that is given`na custom background color.
Gui, Add, Edit, w320 h50 HwndMyTextHwnd3, Here is some text that is given`na custom background color.
Gui +LastFound
GuiHwnd := WinExist()
Gui Show
return

#SPACE::
MouseGetPos, x, y, win
WinGet, ActiveControlList, ControlListhwnd,  ahk_id %win%
Loop, Parse, ActiveControlList, `n
	{
;SetSysColorToControl(A_LoopField, SysColor:=26)
;Gdip_BitmapFromHWND(A_LoopField, clientOnly:=0)
;Gdip_BlurBitmap(pBitmap, BlurAmount, usePARGB:=0, quality:=7)
	;SetBk(A_LoopField, win, 0x0000FF, 0xFF0000)
;CColor(A_LoopField, "220066", "00aaff")
SetBk(A_LoopField, win, 0x0000FF, 0xFF0000)
	sleep 20
	ControlSetText, , hjhjhjhjhjhj, ahk_id %A_LoopField%
	sleep 20

	Tooltip %A_LoopField% 
	}
return

^r::
run tesst.ahk
exitapp

SetBk(hWnd, ghwnd, bc, tc=0xff0000) {
	a := {}
	a["ch"] := hWnd
	a["gh"] := ghwnd
	a["bc"] := ((bc&255)<<16)+(((bc>>8)&255)<<8)+(bc>>16)
	a["tc"] := ((tc&255)<<16)+(((tc>>8)&255)<<8)+(tc>>16)
	WindowProc("Set", a, "", "")
}

WindowProc(hwnd, uMsg, wParam, lParam)
{
	Static Win := {}
	Critical
	If (uMsg = 0x133) and Win[hwnd].HasKey(lparam)
	{
		DllCall("SetTextColor", "UInt", wParam, "UInt", Win[hwnd, lparam, "tc"] )
		DllCall("SetBkColor", "UInt", wParam, "UInt", Win[hwnd, lparam, "bc"] )
		return Win[hwnd, lparam, "Brush"]  ; Return the HBRUSH to notify the OS that we altered the HDC.
	}
	If (hwnd = "Set")
	{
		a := uMsg
		Win[a.gh, a.ch] := a
		If not Win[a.gh, "WindowProcOld"]
			Win[a.gh,"WindowProcOld"] := DllCall("SetWindowLong", "Ptr", a.gh, "Int", -4, "Int", RegisterCallback("WindowProc", "", 4), "UInt")
		If Win[a.gh, a.ch, "Brush"]
			DllCall("DeleteObject", "Ptr", Brush)
		Win[a.gh, a.ch, "Brush"] := DllCall("CreateSolidBrush", "UInt", a.bc)
		; array_list(Win)
		return
	}
	return DllCall("CallWindowProcA", "UInt", Win[hwnd, "WindowProcOld"], "UInt", hwnd, "UInt", uMsg, "UInt", wParam, "UInt", lParam)
}


CColor(Hwnd, Background="", Foreground="") {
	return CColor_(Background, Foreground, "", Hwnd+0)
}

CColor_(Wp, Lp, Msg, Hwnd) { 
	static 
	static WM_CTLCOLOREDIT=0x0133, WM_CTLCOLORLISTBOX=0x134, WM_CTLCOLORSTATIC=0x0138
		  ,LVM_SETBKCOLOR=0x1001, LVM_SETTEXTCOLOR=0x1024, LVM_SETTEXTBKCOLOR=0x1026, TVM_SETTEXTCOLOR=0x111E, TVM_SETBKCOLOR=0x111D
		  ,BS_CHECKBOX=2, BS_RADIOBUTTON=8, ES_READONLY=0x800
		  ,CLR_NONE=-1, CSILVER=0xC0C0C0, CGRAY=0x808080, CWHITE=0xFFFFFF, CMAROON=0x80, CRED=0x0FF, CPURPLE=0x800080, CFUCHSIA=0xFF00FF, CGREEN=0x8000, CLIME=0xFF00, COLIVE=0x8080, CYELLOW=0xFFFF, CNAVY=0x800000, CBLUE=0xFF0000, CTEAL=0x808000, CAQUA=0xFFFF00
 		  ,CLASSES := "Button,ComboBox,Edit,ListBox,Static,RICHEDIT50W,SysListView32,SysTreeView32"
	
	If (Msg = "") {      
		if !adrSetTextColor
			adrSetTextColor	:= DllCall("GetProcAddress", "uint", DllCall("GetModuleHandle", "str", "Gdi32.dll"), "str", "SetTextColor")
		   ,adrSetBkColor	:= DllCall("GetProcAddress", "uint", DllCall("GetModuleHandle", "str", "Gdi32.dll"), "str", "SetBkColor")
		   ,adrSetBkMode	:= DllCall("GetProcAddress", "uint", DllCall("GetModuleHandle", "str", "Gdi32.dll"), "str", "SetBkMode")
	
      ;Set the colors (RGB -> BGR)
		BG := !Wp ? "" : C%Wp% != "" ? C%Wp% : "0x" SubStr(WP,5,2) SubStr(WP,3,2) SubStr(WP,1,2) 
		FG := !Lp ? "" : C%Lp% != "" ? C%Lp% : "0x" SubStr(LP,5,2) SubStr(LP,3,2) SubStr(LP,1,2)

	  ;Activate message handling with OnMessage() on the first call for a class 
		WinGetClass, class, ahk_id %Hwnd% 
		If class not in %CLASSES% 
			return A_ThisFunc "> Unsupported control class: " class

		ControlGet, style, Style, , , ahk_id %Hwnd% 
		if (class = "Edit") && (Style & ES_READONLY) 
			class := "Static"
	
		if (class = "Button")
			if (style & BS_RADIOBUTTON) || (style & BS_CHECKBOX) 
				 class := "Static" 
			else return A_ThisFunc "> Unsupported control class: " class
		
		if (class = "ComboBox") { 
			VarSetCapacity(CBBINFO, 52, 0), NumPut(52, CBBINFO), DllCall("GetComboBoxInfo", "UInt", Hwnd, "UInt", &CBBINFO) 
			hwnd := NumGet(CBBINFO, 48)		;hwndList
			%hwnd%BG := BG, %hwnd%FG := FG, %hwnd% := BG ? DllCall("CreateSolidBrush", "UInt", BG) : -1

			IfEqual, CTLCOLORLISTBOX,,SetEnv, CTLCOLORLISTBOX, % OnMessage(WM_CTLCOLORLISTBOX, A_ThisFunc) 

			If NumGet(CBBINFO,44)	;hwndEdit
				Hwnd :=  Numget(CBBINFO,44), class := "Edit"
		} 

		if class in SysListView32,SysTreeView32
		{
			m := class="SysListView32" ? "LVM" : "TVM" 
			SendMessage, %m%_SETBKCOLOR, ,BG, ,ahk_id %Hwnd%
			SendMessage, %m%_SETTEXTCOLOR, ,FG, ,ahk_id %Hwnd%
			SendMessage, %m%_SETTEXTBKCOLOR, ,CLR_NONE, ,ahk_id %Hwnd%
			return
		}

		if (class = "RICHEDIT50W")
			return f := "RichEdit_SetBgColor", %f%(Hwnd, -BG)

		if (!CTLCOLOR%Class%)
			CTLCOLOR%Class% := OnMessage(WM_CTLCOLOR%Class%, A_ThisFunc) 

		return %Hwnd% := BG ? DllCall("CreateSolidBrush", "UInt", BG) : CLR_NONE,  %Hwnd%BG := BG,  %Hwnd%FG := FG
   } 
 
 ; Message handler 
	critical					;its OK, always in new thread.

	Hwnd := Lp + 0, hDC := Wp + 0
	If (%Hwnd%) { 
		DllCall(adrSetBkMode, "uint", hDC, "int", 1)
		if (%Hwnd%FG)
			DllCall(adrSetTextColor, "UInt", hDC, "UInt", %Hwnd%FG)
		if (%Hwnd%BG)
			DllCall(adrSetBkColor, "UInt", hDC, "UInt", %Hwnd%BG)
		return (%Hwnd%)
	}
}
