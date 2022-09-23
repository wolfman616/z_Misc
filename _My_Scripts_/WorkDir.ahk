WorkDir( unc="" ) { ; the working directory
	unc=""? unc:= A_AhkPath
	wDir:= (ahkexe:= splitpath()).dir
	Setworkingdir,% wDir
	return,wDir
}