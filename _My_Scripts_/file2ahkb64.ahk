; Copy "file-contents" as "base64" in "ahk script"-style, concatenated, "var-chunked declaration-text" (search and replace VarName64 to taste) ;
sleep,10
if(!A_Args[1])
	exitapp,
FileGetSize,nBytes,% a_args[1]
FileRead,Bin,% "*c " a_args[1]
Clipboard:= B64Enc(Bin,nBytes)
return,

B64Enc(ByRef Bin,nBytes,LineLength:=16380,LeadingSpaces:=1,VariableName="VarName64") { ; SKAN / 18-Aug-2017 ; MW 2023
	;(VariableName="VarName64")?splitpath(Bin)
	Local Rqd := 0, B64, B := "", N := 0 - LineLength + 1, CRYPT_STRING_BASE64:= 0x1,NULL:=0
	((VariableName="")?LeadingSpaces:= 0)
	DllCall("Crypt32.dll\CryptBinaryToString","Ptr",&Bin,"UInt",nBytes,"UInt",CRYPT_STRING_BASE64,"Ptr",NULL,"UIntP",Rqd)
	VarSetCapacity(B64,Rqd *(A_Isunicode? 2 : 1 ),0)
	DllCall("Crypt32.dll\CryptBinaryToString","Ptr",&Bin,"UInt",nBytes,"UInt",CRYPT_STRING_BASE64,"Str",B64,"UIntP",Rqd)
	B64:= StrReplace(B64:= StrReplace(B64,"="),"`r`n")
	Loop,% Ceil(StrLen(B64) /LineLength)
		B.= Format("{1:" LeadingSpaces "s}","" ) . SubStr(B64,N+=LineLength,LineLength)
		b:=LTrim(B," ")
		B:=strreplace(B," ", chr(34) . "`n" . VariableName . ".=" . chr(34))
		b:= VariableName . ":=" . chr(34) . b . chr(34)
	Return,RTrim(B,"`n")
}