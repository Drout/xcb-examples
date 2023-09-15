Const spheres As Int = 3
Dim pp, px, py, pz As float
Dim dx, dy, dz As float
Dim x, y, z As float
Dim n, s, l, u, v As float
Dim aa, bb, dd, sc As float
Dim nn, nx, ny, nz As float
Dim r(spheres) As float
Dim q(spheres) As float
Dim c(spheres, 3) As float
'Dim image1 As Bitmap

Sub Draw(x As int, y As int)
    'image1.SetPixel(x, y, Color.Black())
    'PictureBox1.Image = image1
End Sub


Sub FollowRay(j As int, i As int)
l100:
n = y >= 0 Or dy <= 0 : If Not n Then s = -y / dy
For k as byte = 1 To spheres
px = c(k, 0) - x : py = c(k, 1) - y : pz = c(k, 2) - z
pp = px * px + py * py + pz * pz
sc = px * dx + py * dy + pz * dz
If sc <= 0 Then GoTo l200
bb = sc * sc / dd
aa = q(k) - pp + bb
If aa <= 0 Then GoTo l200
sc = (sqr(bb) - sqr(aa)) / sqr(dd)
If sc < s Or n < 0 Then n = k : s = sc
l200:
Next k
If n < 0 Then
Return
End If
dx = dx * s : dy = dy * s : dz = dz * s : dd = dd * s * s
x = x + dx : y = y + dy : z = z + dz
If n = 0 Then GoTo l300
nx = x - c(n, 0) : ny = y - c(n, 1) : nz = z - c(n, 2)
nn = nx * nx + ny * ny + nz * nz
l = 2 * (dx * nx + dy * ny + dz * nz) / nn
dx = dx - nx * l : dy = dy - ny * l : dz = dz - nz * l
GoTo l100
l300:
For k = 1 To spheres
    u = c(k, 0) - x : v = c(k, 2) - z : If u * u + v * v <= q(k) Then Return
Next k
If (x - floor(x) > 0.5) <> (z - floor(z) > 0.5) Then call Draw(j, i)
Return
End Sub


Sub Raytrace()
Dim SizeX as int 
SizeX = 320
Dim SizeY as byte
SizeY = 200
r(1) = 0.2 : r(2) = 0.6
c(1, 0) = 0.9 : c(1, 1) = -1.1 : c(1, 2) = 2 : c(2, 0) = -0.3 : c(2, 1) = -0.8 : c(2, 2) = 3
rem image1 = New Bitmap(SizeX, SizeY)
For k as byte = 1 To spheres-1
    q(k) = r(k) * r(k)
Next k
For i as byte = 0 To SizeY - 1 
    For j as int = 0 To SizeX - 1
        x = 0.3 : y = -0.5 : z = 0
        dx = j - SizeX / 2 : dy = i - SizeY / 2 : dz = 475 : dd = dx * dx + dy * dy + dz * dz
        call FollowRay(j, i)
    Next j
Next i
End Sub