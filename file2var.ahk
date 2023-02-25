file2var(Path,ByRef Var="",Type="#10") { 
	VarSetCapacity(Var,128),VarSetCapacity(Var,0)
	if(!A_IsCompiled) {
		FileGetSize,nSize,%Path% ; FileRead,Var,*c %Path% ascii possible ;
		FileRead,Var,%Path%
		Return,Var
	}
	If(hMod:= DllCall("GetModuleHandle",UInt,0))
		If(hRes:= DllCall("FindResource",UInt,hMod,Str,Path,Str,Type)) ;RCDATA= #10;
			If(hData:= DllCall("LoadResource",UInt,hMod,UInt,hRes))
				If(pData:= DllCall( "LockResource",UInt,hData)) {
					VarSetCapacity(Var,nSize:= DllCall( "SizeofResource",UInt,hMod,UInt,hRes))
				,	DllCall("RtlMoveMemory",Str,Var,UInt,pData,UInt,nSize)
					return,byref Var
				}
	Return,0
}