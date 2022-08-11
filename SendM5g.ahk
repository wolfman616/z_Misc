SendM5g(Message, hwnd = "", wParam := 0, lParam := 0)   {   ; (!MATTHEW JAMES WOLFF 1980)
	SendMessage,% Message,% wParam,% lParam,,% !hwnd ?   ; (!timeout ? timeout := 989)
	, x:=""  :  x:=("ahk_id " . hwnd)	             ; (!sane  ? sleep, %timeout%)
	Return, ErrorLevel                                   ; (MW:2022)(MW:2022)(MW:2022)
}
