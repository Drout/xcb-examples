OPTION TARGET = "cplus4"

TYPE Vector3
 x as FLOAT
 y as FLOAT
 z as FLOAT
END TYPE

TYPE sphere
 center as Vector3
 r as FLOAT
 q as FLOAT
END TYPE 

FUNCTION MultVector as Vector3 ( p1 as Vector3, p2 as Vector3) STATIC
 Dim rv as Vector3 ' returnvalue
 rv.x = p1.x * p2.x
 rv.y = p1.y * p2.y
 rv.z = p1.z * p2.z
 return rv
END FUNCTION

FUNCTION MultVectorByScalar as Vector3 ( p1 as Vector3, s as float) STATIC
 Dim rv as Vector3 ' returnvalue
 rv.x = p1.x * s
 rv.y = p1.y * s
 rv.z = p1.z * s
 return rv
END FUNCTION

FUNCTION SubtractVector as Vector3 ( p1 as Vector3, p2 as Vector3) STATIC
 Dim rv as Vector3 ' returnvalue
 rv.x = p1.x - p2.x
 rv.y = p1.y - p2.y
 rv.z = p1.z - p2.z
 return rv
END FUNCTION

FUNCTION AddVector as Vector3 ( p1 as Vector3, p2 as Vector3) STATIC
 Dim rv as Vector3 ' returnvalue
 rv.x = p1.x + p2.x
 rv.y = p1.y + p2.y
 rv.z = p1.z + p2.z
 return rv
END FUNCTION

FUNCTION Vector3Dot as float ( p1 as Vector3, p2 as Vector3) STATIC
 return p1.x * p2.x + p1.y * p2.y + p1.z * p2.z
END FUNCTION

Dim ROWOFFSET as word
Const SpheresCount = 2
dim Spheres(SpheresCount) as sphere @spheredata 

'SUB Plot (X as int, Y as byte) STATIC
SUB Plot (X as int) STATIC
	Dim MEM as word
	Dim px as byte
	REM PLOT PIXEL
	'MEM = SCRBASE + floor(Y/8) * 320 + floor(X/8) * 8 + (Y AND 7)
    MEM = ROWOFFSET + floor(X/8) * 8
	PX = 7 - (X AND 7)
	POKE MEM, PEEK(MEM) OR POW(2,PX)
END SUB

for k as byte = 0 to SpheresCount-1
 spheres(k).q = spheres(k).r * spheres(k).r
next k

spheredata:
 data as float -0.3, -0.8, 3, 0.6 , 0
 data as float 0.9, -1.1, 2, 0.2 , 0 

Dim pp As float

Dim to_sphere As Vector3, Ray As Vector3
Dim Pos As Vector3
Dim n As int, s As float, l As float, u As float, v As float
Dim aa As float, bb As float, dd As float, sc As float

Dim normv As Vector3

Sub FollowRay (j As int, i As byte)
Dim kk as byte
    s=0
    n=-1
    if not ((Pos.Y >= 0) Or (Ray.Y <= 0)) Then 
        s = -Pos.Y / Ray.Y
        n=0
    end if
    k=0
    'For k = 0 To SpheresCount -1
    Do
        to_sphere = SubtractVector(Spheres(k).Center , Pos)
        pp = Vector3Dot(to_sphere, to_sphere) 
        sc = Vector3Dot(to_sphere, Ray)

        If sc > 0 Then :rem the angle between to_sphere and ray is between -90 and +90 degrees
            bb = sc * sc / dd
            aa = Spheres(k).Q - pp + bb
            If aa > 0 Then
                sc = (sqr(bb) - sqr(aa)) / sqr(dd)
                If sc < s Or n < 0 Then 
                    n = k + 1 
                    s = sc
                End If 
            End If
        End If
        k = k + 1
    Loop Until k=SpheresCount
    'Next k
    If n < 0 Then       :rem we hit nothing (so it's the sky)
        'Call Plot(j, i, MODE_SET)
        Return
    End If
    rem we hit something

    rem set the ray to the correct length
    Ray = MultVectorByScalar(Ray, s)
    dd = dd * s * s
    rem go where the ray hit
 
    Pos = AddVector(Pos , Ray)
    If n <> 0 Then          
        rem hit a sphere
        rem reflection
        rem calculate normal vector
        normv = SubtractVector(Pos, Spheres(n-1).Center)
        l = 2 * Vector3Dot(Ray, normv) / Vector3Dot(normv, normv)

        Ray = SubtractVector(Ray , MultVectorByScalar(normv , l))
        Call FollowRay(j, i)
    Else
        rem we hit the floor - finally!            
        rem check the shadows
        kk=0
        'For kk as byte = 0 To SpheresCount-1
        Do
            u = Spheres(kk).Center.X - Pos.X 
            v = Spheres(kk).Center.Z - Pos.Z
            If u * u + v * v <= Spheres(kk).Q Then
                rem we are in the shadow
                'Call Plot(j, i, MODE_SET) 
                Return
            End If
            kk = kk + 1
        Loop until kk=SpheresCount
        'Next kk
        rem checker tile
        If ((Pos.X - floor(Pos.X)) > 0.5) <> ((Pos.Z - floor(Pos.Z)) > 0.5) Then
            'Call PLOT(j, i)
            Call PLOT(j)
        End If
    End If
    Return
End Sub
	
REM INITIALIZE BITMAP MODE

CONST SCRBASE = $4000

REM init screen
ASM
    lda $ff06
    ora #$20 ; enable bitmap mode
    sta $ff06
    lda #$d0 ; bitmap at $4000
    ;lda #$d8 ; bitmap at $6000
    ;lda #$e8 ; bitmap at $A000
    sta $ff12
    ;lda #$40 ; color/luma screen at $4000
    lda #$60 ; color/luma screen at $6000
    sta $ff14
end ASM 

REM setup colors
ASM
    ldx #0
loop1:
    lda #$70
    sta $6000,x
    sta $6100,x
    sta $6200,x
    sta $6300,x
    lda #$01
    sta $6400,x
    sta $6500,x
    sta $6600,x
    sta $6700,x
    inx
    bne loop1
end ASM

memset SCRBASE,8000,0   'clear bitmap area

'poke $ff15, 1
'poke $ff19, 1

Dim SizeX as int 
Dim SizeY as int '  doesn't work as byte

SizeX = 320
SizeY = 200 
   
    For y as byte = 0 To SizeY - 1 
        ROWOFFSET =  SCRBASE + floor(y/8) * 320 + (y AND 7)
        For x as int = 0 To SizeX - 1
            Pos.x = 0.3
    	    Pos.y = -0.5
		    Pos.z = 0
            Ray.x = x - SizeX / 2
            Ray.y = y - SizeY / 2
            Ray.z = SizeX 
            dd = Vector3Dot(Ray, Ray) 
            Call FollowRay(x, y)
        Next x
    Next y

DIM A$ as string *1  
Input a$