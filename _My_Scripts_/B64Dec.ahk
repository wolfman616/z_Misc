B64Dec(ByRef B64,ByRef Bin ) {  ; By SKAN / 18-Aug-2017 - P5yCh0515 2023
	Local Rqd:= 0, BLen:= StrLen(B64), CRYPT_STRING_BASE64:= 0x1, NULL:= 0
	DllCall("Crypt32.dll\CryptStringToBinary","Str",B64,"UInt",BLen,"UInt",CRYPT_STRING_BASE64
				 ,"UInt",NULL,"UIntP",Rqd,"Int",NULL,"Int",NULL )
	VarSetCapacity(Bin,128), VarSetCapacity(Bin,NULL), VarSetCapacity(Bin,Rqd,NULL)
	DllCall("Crypt32.dll\CryptStringToBinary","Str",B64,"UInt",BLen,"UInt",CRYPT_STRING_BASE64
				 ,"Ptr",&Bin,"UIntP",Rqd,"Int",NULL,"Int",NULL)
	Return,Rqd
}