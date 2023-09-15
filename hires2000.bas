
DIM SCRBASE as word
	
SUB Draw (X as int, Y as byte) STATIC
	Dim MEM as word
	Dim px as byte
	REM PLOT PIXEL
	MEM = SCRBASE + floor(Y/8) * 320 + floor(X/8) * 8 + (Y AND 7)
	PX = 7 - (X AND 7)
	POKE MEM, PEEK(MEM) OR POW(2,PX)
	'PRINT MEM, PEEK(MEM) OR POW(2,PX)
END SUB

'this is a remark
REM INITIALIZE BITMAP MODE

    PRINT CHR$(147) 

	SCRBASE=$2000
	POKE 53272, PEEK(53272) OR 8 : REM BIT MAP AT 8192					
	POKE 53265, PEEK(53265)OR 32 : REM BIT MAP ON	
	
	memset SCRBASE,7999,0
	Call Draw(100,100)
	Call Draw(1,1)
	Call Draw(2,2)
	Call Draw(8,8)