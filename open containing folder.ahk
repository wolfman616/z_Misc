#NoEnv
File=%1%
o:=comobjcreate("Shell.Application")
splitpath,file,file,directory
if errorlevel 
exitapp
od:=o.namespace(directory)
of:=od.parsename(file)
if containing_loc:=od.getdetailsof(of,203) {
	;splitpath containing_loc, inFileName, inDir, inExtension, inNameNoExt, inDrive
	Run %COMSPEC% /c explorer.exe /select`, "%containing_loc%"
	}
else msgbox gay
ExitApp
