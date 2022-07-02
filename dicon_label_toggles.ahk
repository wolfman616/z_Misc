; Toggle Desktop Icon Labels On/off
WinGet, LL, List, ahk_class WorkerW
loop,  %LL%	{
	controlget,  desklistviewhnd,hwnd,, SysListView321,% "ahk_id " LL%A_Index%
	sendmessage, 0x1004, 0, 0,, Ahk_ID %desklistviewhnd% ; get count of lvm
	if !(errorlevel  = "FAIL") { 
		itemcount   :=  errorlevel
		main_hwnd   :=  LL%A_Index%
		sendmessage, 0x1037,0,0,,Ahk_ID %desklistviewhnd% ; 0x1037 lvm_get ex style
		lv_ex_style :=  errorlevel
		if   (lv_ex_style & 0x00020000) ; 0x00020000 = hidelabels
			desktop_icon_labels   := False
		else, desktop_icon_labels := True
		
		if !desktop_icon_labels {
			lv_ex_style +=  0x00020000	
			traytip, Dicon, lablz on
		} else {
			lv_ex_style -= 0x00020000	
			traytip, Dicon, lablz off
		}
		sendmessage 0x1036, 0, lv_ex_style,, ahk_id %desklistviewhnd%  ;set lvm ex style#
} 	}
sleep 3000
return,			