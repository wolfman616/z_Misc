#NoEnv 
;#Persistent
#SingleInstance
SetWorkingDir %A_ScriptDir% 
SplitPath, 1 , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
Gui, GuiName:new , , Poop
Gui +HwndMyGuiHwnd
Gui, Add, Text,, Start Pos Min:
Gui, Add, Edit, w80 Center R1 Number vStart_Min
Gui, Add, Text,, Start Pos Sec:
Gui, Add, Edit, w80 Center R1 Number vStart_Sec
GuiControl,, Start_Min, 0
GuiControl,, Start_Sec, 0
Gui, Add, Text,, End Pos Min:
Gui, Add, Edit, w80 Center R1 Number vEnd_Min
Gui, Add, Text,, End Pos Sec:
Gui, Add, Edit, w80 Center R1 Number vEnd_Sec
GuiControl,, End_Min, 0
GuiControl,, End_Sec, 0
Gui, Add, CheckBox, center vRemove, Remove
Gui, Add, Button, Center w80 gSub, OK
Gui, Show , Center, Poop
Return

Sub:
Gui, Submit
Gui, Destroy ;Start_Min:=Start_Min * 60	;Start_Pos:=Start_Min + Start_Sec	;End_Min:=End_Min * 60	;End_pos:=End_Min + End_Sec
Time_Start=00:%Start_Min%:%Start_Sec%
Time_End=00:%End_Min%:%End_Sec%
if Remove
	Process_Action:="-to", Process_Type:="Trimmed"
else 
	Process_Type:="Extracted", 	Process_Action:="-t"
Output_Prefix=%OutDir%\%OutNameNoExt% - %Process_Type%
Output_Filename_Full=%Output_Prefix%.%OutExtension%
while FileExist(Output_Filename_Full) { ; Check_Folder
	Multiple_Num := Multiple_Num + 1
	Output_Filename_Full=%Output_Prefix%-%Multiple_Num%.%OutExtension%
	}
RunWait, %comspec% /c ffmpeg -i "%1%" -ss %Time_Start% %Process_Action% %Time_End% -c:v copy -c:a copy "%Output_Filename_Full%"
InvokeVerb(Output_Filename_Full, "Cut", True)
ExitApp

Escape::ExitApp

InvokeVerb(path, menu, validate=True) {
    objShell := ComObjCreate("Shell.Application")
    if InStr(FileExist(path), "D") || InStr(path, "::{") {
        objFolder := objShell.NameSpace(path)   
        objFolderItem := objFolder.Self
    } else {
        SplitPath, path, name, dir
        objFolder := objShell.NameSpace(dir)
        objFolderItem := objFolder.ParseName(name)
		}
    if validate {
        colVerbs := objFolderItem.Verbs   
        loop % colVerbs.Count {
            verb := colVerbs.Item(A_Index - 1)
            retMenu := verb.name
            StringReplace, retMenu, retMenu, &       
            if (retMenu = menu) {
                verb.DoIt
                Return True
            }
        }
		Return False
    } else
        objFolderItem.InvokeVerbEx(Menu)
} 
