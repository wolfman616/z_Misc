WGetTitle(ahkidtype="") {  ;	(!MATTHEW JAMES WOLFF 1980)(MW:2022)(MW:2022)(MW:2022)
   (ahkidtype="") ? (ahkidtype:="A") : () ;if none provided assume target = Active win
	wingettitle,_T,% ahkidtype
	return, retval:=(!(_T="")?(retval:=_T):(retval:="Untilted"))
}                          ;	(!MATTHEW JAMES WOLFF 1980)(MW:2022)(MW:2022)(MW:2022)