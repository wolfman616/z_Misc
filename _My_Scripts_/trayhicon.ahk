trayhicon(ico_path){
	hicon_path:=ico2hicon(ico_path)
	menu, tray, icon,% "HICON: " hicon_path
	if errorlevel
		return, 0
	else, return, 1
}