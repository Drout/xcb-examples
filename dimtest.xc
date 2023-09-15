TYPE sphere
 x as FLOAT
 y as FLOAT
 z as FLOAT
 r as FLOAT
END TYPE 

dim c(2) as sphere @spheredata 
dim q(2) as float

for k as byte = 0 to 1
 q(k) = c(k).r * c(k).r
 print k, c(k).x, c(k).y, c(k).z
next k
print sqr(9)

spheredata:
 data as float -0.3, -0.8, 3, 0.6
 data as float 0.9, -1.1, 2, 0.2