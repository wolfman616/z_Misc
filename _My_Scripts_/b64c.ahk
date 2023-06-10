b64c(base64input) {
	VarSetCapacity(B64, 3864 << !!A_IsUnicode)
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &base64input, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
		Return,False
	VarSetCapacity(Dec, DecLen, 0)
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &base64input, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
		Return,False
	hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
	pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
	DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
	DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
	return,pStream
}