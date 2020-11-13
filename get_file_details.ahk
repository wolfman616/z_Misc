o:=comobjcreate("Shell.Application")
fileselectfile,file,c:\
splitpath,file,file,directory
if errorlevel
	exitapp
od:=o.namespace(directory)
of:=od.parsename(file)
loop,286
	{
	if (turd%a_index%:=((append:=od.getdetailsof(of,a_index))?a_index " - " od.getdetailsof("",a_index) ": " append "":""))
		{
		turd:=turd%a_index%
		if a_index=1
			spunk:=turd
		else
			Spunk=%Spunk%`n%Turd%
		}
	}
fileappend, % Spunk, %file%.txt
run, "%file%.txt"