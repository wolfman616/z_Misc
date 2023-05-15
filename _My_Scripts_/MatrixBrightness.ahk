MatrixBrightness(Bright_Percent="85") {
	cp:= 0.01*(pc:=(Bright_percent>1? Bright_percent/100 : Bright_percent))
	return,matrix_:="
		(LTrim Join Comments
		(	" pc "	| 0		| 0		| 0		| 0 	|
			0		|" pc "	| 0		| 0		| 0 	|
			0		| 0		|" pc "	| 0		| 0 	|
			0		| 0		| 0		| 1		| 0 	|
			" cp "	| " cp "| " cp "| 0		| 1 	|
		)"
}