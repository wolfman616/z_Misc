
+PgDn:: 	;Wheel Right = page down without interfering with selection
	WinGetClass, Active_WinClass , A
	MouseGetPos, , , Mouse_hWnd, Mouse_ClassNN
	WinGetClass, Mouse_WinClass , ahk_id %Mouse_hWnd%
	if Active_WinClass != % Mouse_WinClass ;unfocused
	{
		if Mouse_WinClass in MozillaWindowClass,Chrome_WidgetWin_1
			{
				controlsend, %Mouse_ClassNN%, { PgDn }, ahk_id %Mouse_hWnd%
			} Else if Mouse_WinClass in CabinetWClass,Notepad++,RegEdit_RegEdit,#32770,MainWindowClassName,TMainForm
				{
				if Mouse_ClassNN in DirectUIHWND2,DirectUIHWND3
					SendMessage, 0x115, 3, 2, ScrollBar2, ahk_id %Mouse_hWnd%
				Else	
					SendMessage, 0x115, 3, 2, %Mouse_ClassNN%, ahk_id %Mouse_hWnd%
				} 
		Else if Mouse_ClassNN=WindowsForms10.Window.8.app.0.34f5582_r6_ad1
			controlsend, %Mouse_ClassNN%, { Right } , ahk_id %Mouse_hWnd%
		Else 
			ControlSend, , { PgDn }, ahk_id %Mouse_hWnd%
		}
	Else if Mouse_WinClass in CabinetWClass,Notepad++,RegEdit_RegEdit,#32770,MainWindowClassName,TMainForm
		{
			if Mouse_ClassNN in DirectUIHWND2,DirectUIHWND3 
				SendMessage, 0x115, 3, 2, ScrollBar2, ahk_id %Mouse_hWnd%
		Else	
			SendMessage, 0x115, 3, 2, %Mouse_ClassNN%, ahk_id %Mouse_hWnd%
		} 
	Else Send, { PgDn }
	Return

+PgUp:: 	;Wheel Right = page down without interfering with selection
	WinGetClass, Active_WinClass , A
	MouseGetPos, , , Mouse_hWnd, Mouse_ClassNN
	WinGetClass, Mouse_WinClass , ahk_id %Mouse_hWnd%
	if Active_WinClass != % Mouse_WinClass ; unfocused
		{
		if Mouse_WinClass in MozillaWindowClass,Chrome_WidgetWin_1,
		{
			controlsend, %Mouse_ClassNN%, { PgUp }, ahk_id %Mouse_hWnd%
		} Else if Mouse_WinClass in CabinetWClass,Notepad++,RegEdit_RegEdit,#32770,MainWindowClassName,TMainForm
			{
				if Mouse_ClassNN in DirectUIHWND2,DirectUIHWND3
				{
					SendMessage, 0x115, 2, 2, ScrollBar2, ahk_id %Mouse_hWnd%
				}
				Else {
					SendMessage, 0x115, 2, 2, %Mouse_ClassNN%, ahk_id %Mouse_hWnd%
				}
			} Else if Mouse_ClassNN=WindowsForms10.Window.8.app.0.34f5582_r6_ad1
				controlsend, %Mouse_ClassNN%, { Left } , ahk_id %Mouse_hWnd%
				Else 
					ControlSend, , { PgUp }, ahk_id %Mouse_hWnd%
		}
	Else	if Mouse_WinClass in CabinetWClass,Notepad++,RegEdit_RegEdit,#32770,MainWindowClassName,TMainForm
		{
			if Mouse_ClassNN in DirectUIHWND2,DirectUIHWND3 
				SendMessage, 0x115, 2, 2, ScrollBar2, ahk_id %Mouse_hWnd%
		Else	
			SendMessage, 0x115, 2, 2, %Mouse_ClassNN%, ahk_id %Mouse_hWnd%
		} Else send, { PgUp }
	Return
