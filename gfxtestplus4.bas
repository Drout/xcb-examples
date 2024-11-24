OPTION TARGET = "cplus4"
dim SCRBASE as word

SUB Plot (X as int, Y as byte) STATIC
	Dim MEM as word
	Dim px as byte
	REM PLOT PIXEL
	MEM = SCRBASE + floor(Y/8) * 320 + floor(X/8) * 8 + (Y AND 7)
	PX = 7 - (X AND 7)
	POKE MEM, PEEK(MEM) OR POW(2,PX)
	'PRINT MEM, PEEK(MEM) OR POW(2,PX)
END SUB


REM INITIALIZE BITMAP MODE

SCRBASE = $8000

'poke $FF12, (peek($FF12) and 215) or 32 ' hires at $4000, 215= 1100 0111 clear bit 4 5 6 and set bit 5

'poke $FF14, (peek($FF14) and 7) or $3C   '0011 1100 0000 0000  '0011 1100

'poke $FF06, peek($FF06) or 32

REM init screen
ASM
    lda $ff06
    ora #$20 ; enable bitmap mode
    sta $ff06
    ;lda #$d8 ; bitmap at $6000
    lda #$e0 ; bitmap at $8000
    ;lda #$e8 ; bitmap at $A000
    sta $ff12
    lda #$40 ; color/luma screen at $4000
    sta $ff14
end ASM 

REM setup colors
ASM
    ldx #0
loop1:
    lda #$70
    sta $4000,x
    sta $4100,x
    sta $4200,x
    sta $4300,x
    lda #$01
    sta $4400,x
    sta $4500,x
    sta $4600,x
    sta $4700,x
    inx
    bne loop1
end ASM

memset SCRBASE,8000,0   'clear bitmap area

'poke $ff15, 1
'poke $ff19, 1

Dim SizeX as int
Dim SizeY as int
SizeX = 320
SizeY = 200 
   
    For y as byte = 0 To 200
        'For x as int = 0 To 100
            CALL Plot(y,y)
        'Next x
    Next y

DIM A$ as string *1  
Input a$