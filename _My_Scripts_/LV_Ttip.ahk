#NoEnv
Global HLV
Gui, Margin, 10, 10
Gui, Add, ListView, w400 r10 hwndHLV +LV0x0400, Column1|Column2|%A_Space% ; LVS_EX_INFOTIP = 0x00000400
Loop, 10
   LV_Add("", "Row" . A_Index . " Column1", "Row" . A_Index . " Column2")
LV_ModifyCol()
Gui, Show, , ListView Sample
OnMessage(0x004E, "WM_NOTIFY")
Return

GuiCLose:
ExitApp

WM_NOTIFY(wParam, lParam) {
   Static LVN_GETINFOTIPA := -157, LVN_GETINFOTIPW := -158
   Critical 500
   HWND := NumGet(lParam + 0, 0, "UPtr")
   Code := NumGet(lParam + 0, A_PtrSize * 2, "Int")
   If (HWND = HLV) && ((Code = LVN_GETINFOTIPW) || (Code = LVN_GETINFOTIPA)) {
      Item   := NumGet(lParam + 4, A_PtrSize * 5, "UPtr")
      TipPtr := NumGet(lParam + 0, A_PtrSize * 4, "UPtr")
      TipLen := NumGet(lParam + 0, A_Ptrsize * 5, "Int")
      TipTxt := "Code: " . Code . "`nTipLen: " . TipLen . "`nRow: " . (Item + 1)
      StrPut(TipTxt, TipPtr, TipLen, Code = LVN_GETINFOTIPW ? "UTF-16" : "CP0")
      Return 0
   }
}

/*
typedef struct tagNMLVGETINFOTIP {
  NMHDR  hdr;
  DWORD  dwFlags;
  LPTSTR pszText;
  int    cchTextMax;
  int    iItem;
  int    iSubItem;
  LPARAM lParam;
} NMLVGETINFOTIP, *LPNMLVGETINFOTIP;
+/