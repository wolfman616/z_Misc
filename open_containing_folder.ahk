#NoEnv ; #Persistent 
#SingleInstance Force
Menu, Tray, NoStandard
Menu, Tray, Add, Open script folder, Open_script_folder,
Menu, Tray, Standard
Task_Sched:="mmc.exe taskschd.msc /s", Loc:=1, S:=1100 ; S sleep millisecs for handling explorer launch delay
NeedL=i)(\"([\w\d]*[\.]*[\w\d]*)([\.]*[a-z]{2,4})) ;o="a
File=%1% ; Passed argument from context object
FileGetShortcut, %1% , OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
if errorlevel
		Run %COMSPEC% /c explorer.exe /select`, "%1%",, Hide
else {
	if (OutTarget="C:\Windows\System32\schtasks.exe") { 
		Run %COMSPEC% /c %Task_Sched%,, Hide			
		While an00s:=regexmatch(OutArgs, NeedL, returning, loc) { ; strip argument from tasksched LNK
			Loc := 999
			Sleep %S% ; allow launch tasksched in order to then steal foc 
			msgbox %returning%" 	; o="a ; ***Hint** k
		}
	} Else {
		Run %COMSPEC% /c explorer.exe /select`, "%OutTarget%",, Hide
		Sleep %S%
		SendInput {F5}
	}
	Return
}
Open_script_folder:	
Run %COMSPEC% /c explorer.exe /select`, "%A_ScriptFullPath%",, Hide
Sleep %S%
SendInput {F5}
Return

/* old code
o:=comobjcreate("Shell.Application")
splitpath,file,file,directory,ext
if !errorlevel {
	od:=o.namespace(directory)
	of:=od.parsename(file)
	if (containing_loc:=od.getdetailsof(of,203)) { ;202 - Link status: Unresolved	
		if containing_loc=C:\Windows\System32\schtasks.exe 
		{
			Run %COMSPEC% /c %Task_Sched%,, Hide
	 } Else {
			splitpath,containing_loc,file2,directory2,ext2
			If !ext2 {
				containing_loc:=od.getdetailsof(of,194)
			}
			Run %COMSPEC% /c explorer.exe /select`, %containing_loc%\,, Hide
			;msgbox %containing_loc% pubes
		}
	} Else {
		GINGER_PUBES:=od.getdetailsof(of,202)
		Return
	}
}
*/

	