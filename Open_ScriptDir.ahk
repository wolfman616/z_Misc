Open_ScriptDir(){
	Open_ScriptDir:
	toolTip %a_scriptFullPath%
	z=explorer.exe /select, %a_scriptFullPath%
	run %comspec% /C %z%,, hide
	settimer ToolOff, -666
	settimer Refresh_f5, -2000
	return

	Refresh_f5:
	sendInput {F5}
	return

	ToolOff:
	toolTip,
	return
}