	AncestorpTr(hWnd,gaFlags="2") { ;*flags to tell if ur ancestor was gay   ;1 GA_PARENT:	       Retrieves parent window.
	return,DllCall("GetAncestor","int",hWnd,"uint",%gaFlags%,"uint")         ;            This does not include the owner,
}                                                                       	 ;     as it does with the GetParent function.
																			 ;2 GA_ROOT:	         Retrieves root window
AncestorROOTpTr(hWnd,gaFlags="3") {                                     	 ;     by walking the chain of parent windows.
	Ancwind:=DllCall("GetAncestor","int",hWnd,"uint",%gaFlags%,"uint")  	 ;3 GA_ROOTOWNER: Retrieves owned root window
	winget,p,processname,ahk_id %Ancwind%									 ;  by walking the chain of parent and  owner
	return,(p?r:=p:r:=0)  	 												 ;              windows returned by GetParent.
}