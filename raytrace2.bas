INCLUDE "lib_gfx.bas"
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

dim SCRBASE as word
dim Spheres(2) as sphere @spheredata 

for k as byte = 0 to 1
 spheres(k).q = spheres(k).r * spheres(k).r
next k

spheredata:
 data as float -0.3, -0.8, 3, 0.6 , 0
 data as float 0.9, -1.1, 2, 0.2 , 0 

Const SpheresCount = 2
Dim pp As float

Dim to_sphere As Vector3, Ray As Vector3
Dim Pos As Vector3
Dim n As int, s As float, l As float, u As float, v As float
Dim aa As float, bb As float, dd As float, sc As float

Dim normv As Vector3

Sub FollowRay (j As int, i As byte)
    s=0
    n=-1
    if not ((Pos.Y >= 0) Or (Ray.Y <= 0)) Then 
        s = -Pos.Y / Ray.Y
        n=0
    end if
    For k = 0 To SpheresCount -1
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
    Next k
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
        For kk as byte = 0 To SpheresCount-1
            u = Spheres(kk).Center.X - Pos.X 
            v = Spheres(kk).Center.Z - Pos.Z
            If u * u + v * v <= Spheres(kk).Q Then
                rem we are in the shadow
                'Call Plot(j, i, MODE_SET) 
                Return
            End If
        Next kk
        rem checker tile
        If ((Pos.X - floor(Pos.X)) > 0.5) <> ((Pos.Z - floor(Pos.Z)) > 0.5) Then
            Call PLOT(j, i, MODE_SET)
        End If
    End If
    Return
End Sub
	
	
REM INITIALIZE BITMAP MODE

CALL SetVideoBank(2)
CALL SetBitmapMemory(1)
CALL SetScreenMemory(3)
CALL SetGraphicsMode(STANDARD_BITMAP_MODE)
CALL FillBitmap(0)
CALL FillScreen(SHL(COLOR_WHITE, 4) OR COLOR_RED)

Dim SizeX as int
Dim SizeY as int
SizeX = 320
SizeY = 200 
   
    For y as byte = 0 To SizeY - 1 
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
        'CALL Plot(0, y, MODE_SET)
    Next y
