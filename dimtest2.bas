
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


dim spheres(2) as sphere @spheredata 

for k as byte = 0 to 1
 spheres(k).q = spheres(k).r * spheres(k).r
 print "sphere: "; k
 print "center: "; spheres(k).center.x , spheres(k).center.y , spheres(k).center.z 
 print "radius:"; spheres(k).r
next k

spheredata:
 data as float -0.3, -0.8, 3, 0.6 , 0
 data as float 0.9, -1.1, 2, 0.2 , 0 



	
