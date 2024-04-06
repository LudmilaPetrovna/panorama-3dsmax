delete $TeaCrowd*

maxdist=50

for q=1 to 30 do (

aa=Teapot radius:(random 0.1 3.0) smooth:on segs:5 body:on handle:on spout:on lid:on pos:(random [-maxdist,-maxdist,0] [maxdist,maxdist,0])
aa.name="TeaCrowd"
rotate aa (angleaxis (random 0.0 360.0) [0,0,1])

	
)