#noEnv ; #warn
#persistent
#SingleInstance force
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir
menu, tray, standard
clsidTHISpc:="::{20d04fe0-3aea-1069-a2d8-08002b30309d}"
Thread, NoTimers
FileSelectFolder, destpath, %clsidTHISpc% , 4, % " fuck off "
Thread, NoTimers, false
if !destpath
	exitapp
a = "%1%" "%destpath%" /COPYall /S /SL /XJD   ;/XJD :: eXclude Junction points and symbolic links for Directories.
msgbox copying %1% to %destpath%
ifmsgbox ok,{
	runwait %comspec% /C robocopy %a%,,hide
	msgbox done
}
return

Open_ScriptDir()
