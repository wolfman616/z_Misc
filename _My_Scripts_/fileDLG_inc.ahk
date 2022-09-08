fileDLG_inc(increment="", parent_handle="", control_title="", control_handle="") {  
global                                           ; auto increment file save dialog by MW(2022)
	if !control_title                            ; 1st... confirm arguments supplied
		control_title  :=  "Edit1"               ; save-file common dialog edit combobox
	if !increment
		increment  :=  1
	if !control_handle                           {
		if !parent_handle                        {
			WinGetActiveTitle, Wintitle_active
			if !(instr(Wintitle_active, "save")) {
				WinGetClass, win_class , A
				if win_class != #32770
					return, 0
			}
			parent_handle  :=        winexist( "A" )
			parent_handle  :=  ("ahk_id " . parent_handle)
			controlget, control_handle, hwnd,,% control_title,% parent_handle
	}	}	 
	
	controlGetText, txt_orig,% control_title,% parent_handle 
	if !RegExMatch(txt_orig, "(\d+)(?!.*\d)", d_, 1)    
		return, 0                                ; only accept the mark of the vorderman                 
	tx  := RegExReplace(Format((4matL_:=("{:0" . (len:=strlen(d_)) . "}")),txt_orig), "(\d+)(?!.*\d)",d_b:=format(4matL_,  (d_ += increment)))
	rem := ((len:=(strlen(tx)))-(strlen(d_b)))
;                                                ; set incremented text in place
	controlSetText,% control_title,% tx,% parent_handle	
	
	;Below Selects a range of characters in the edit control. If the start is 0 and the end is -1, all the text in the edit control is selected. If the start is -1, any current selection is deselected.
	
	SendMessage, 0x00B1,% len - 1,% len,% control_title,% parent_handle	
;	SendMessage, 0x00B1,% rem,% len,% control_title,% parent_handle ; EM_SETSEL := 0x00B1 ; selects whole incremenet text including prefixed 0s

	return,1
}