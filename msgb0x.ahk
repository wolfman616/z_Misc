MsgB0x(text,title="",flags="",timeout="") {                 ; (!MATTHEW JAMES WOLFF 1980)
	(!flags ? flags:=0x0), (!title ? title:="Attention") ; (!timeout ? timeout := 989)
	msgbox,% flags,% title,% text,% timeout	             ; (!sane  ? sleep, %timeout%)
	return, 1                                            ; (MW:2022)(MW:2022)(MW:2022)
}
