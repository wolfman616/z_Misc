#NoEnv
#persistent
#singleinstance force
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance force
STAR=%clipboardall%
Gui, Add, Text, x12 y10 w310 h30, Please enter note.
Gui, Add, Button, x230 y40 w60 h20, OK ;  OK button
Gui, Add, Edit, x12 y40 w200 h20 vDATA_ENTRY, ; edit box to input a note
Gui, Show, w320 h80, NoteAdd 
GuiControl, Focus, DATA_ENTRY
retrieved:=0
Return

#IF !retrieved
~Enter:: ; Define ENTER as hotkey conditionally with pass through
~NumpadEnter:: 
	Gui, Submit ; saves entry
	if !DATA_ENTRY
		tooltip, your cock doesnt seem to have appeared, ((a_screenwidth/2)-40), ((a_screenheight/2)-10)
	else
		{
		output=%A_ScriptDir%\a%DATA_ENTRY%.txt
		FileAppend, %STAR%, %output%
		InvokeVerb(output, "Cut")
		GuiClose: ; Close the GUI
		ToolTIP= Clipboard data in %A_ScriptDir%\%DATA_ENTRY%.txt`n File copied to clipboard
		tooltip, %ToolTIP%,center,center
		settimer tooloff, -1500
		retrieved:=1
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

tooloff:
tooltip,
return









/* 



Gui, Add, Edit, vMyEdit w135, Add Notes and press Enter`n

gui, show












while GetKeyState, returned , enter , p
{
if returned 
break
}
GuiControlGet, MyEdit
gui, hide
ToolTIP:= "Clipboard data in %A_ScriptDir%\SHITCUNT.txt`n File copied to clipboard"
tooltip, %tooltip%, (a_screenwidth/2)-40, (a_screenheight/2)-10

settimer tooloff, 1000
return

tooloff:
tooltip,
return
 */