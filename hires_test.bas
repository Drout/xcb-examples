DIM SCRBASE as word
	
SUB Draw (X as int, Y as byte) STATIC
	Dim MEM as word
	Dim px as byte
	REM PLOT PIXEL
	MEM = SCRBASE + floor(Y/8) * 320 + floor(X/8) * 8 + (Y AND 7)
	PX = 7 - (X AND 7)
	POKE MEM, PEEK(MEM) OR POW(2,PX)
	PRINT MEM, PEEK(MEM) OR POW(2,PX)
END SUB

REM INITIALIZE BITMAP MODE
	'see details: http://iancoog.altervista.org/C/D018.txt
	poke $dd00, (peek($dd00) and 252) or 2  'bank 1 selected : $4000-$7FFF
	poke $d018, $38 						'0011 1000 -- Matrix: $4C00 ($0C00 + bank offset), 
											'bitmap: $6000 ($2000 + bank offset)
	poke $d011 , peek($d011) OR 32  		' BIT MAP ON	

	SCRBASE=$6000
    'PRINT CHR$(147) 
	memset SCRBASE,8000,0   'clear bitmap area
	memset $4C00,1000,18    'set colors: white on red

	Call Draw(100,100)
	Call Draw(1,0)
	Call Draw(2,2)
	Call Draw(10,10)