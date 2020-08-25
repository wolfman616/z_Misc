#NoEnv
#persistent
#SingleInstance force
SendMode Input
SetWorkingDir %A_ScriptDir%

Clip_Data=%ClipboardAll%
Gui, Add, Text, x12 y10 w310 h30, Please enter note.
Gui, Add, Button, x230 y40 w60 h20, OK ;  OK button
Gui, Add, Edit, x12 y40 w200 h20 vDATA_ENTRY, ; edit box to input a note
Gui, Show, w320 h80, NoteAdd 
GuiControl, Focus, DATA_ENTRY
Retrieved:=0
Return

#IF !Retrieved
~Enter:: ; Define ENTER as hotkey conditionally with pass through
~NumpadEnter:: 
Gui, Submit ; saves entry
if !DATA_ENTRY
	TrayTip, Clipboard,  Write a note, ((a_screenwidth/2)-40), ((a_screenheight/2)-10)
else
	{
	CoordMode ToolTip, Screen
	Output=%A_ScriptDir%\a%DATA_ENTRY%.txt
	FileAppend, %Clip_Data%, %output%
	InvokeVerb(output, "Cut")
	GuiClose: ; Close the GUI
	TrayTip, Clipboard, Clipboard data saved to %DATA_ENTRY%.txt
	Retrieved:=1
	Exitapp
	}

InvokeVerb(path, menu, validate=True) {
	;by A_Samurai
	;v 1.0.1 http://sites.google.com/site/ahkref/custom-functions/invokeverb
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
