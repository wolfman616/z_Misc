SplitPath(Path="" ) {					; unc_target := "C:\Windows\system\win,ini"
 SplitPath,Path,D,Ext,NameNoExt,Drive	;==========================================
 return,y:=({	"Dir"  : D				; msgb0x((res:= splitpath(unc_target)).dir)
	   ,		"Ext"  : Ext			;or
	   ,		"Drive": Drive			; res:= splitpath(unc_target)
	   ,		"Name" : NameNoExt		; msgbox % res.dir
	   ,		"Path" : Path })		; return,
}										;==========================================