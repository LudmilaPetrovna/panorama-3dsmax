delete $SpherePoint*

cols=20*3
rows=3*3

sphereRadius=25.0

totalFrames=cols*rows
totalFrames=150.0


rots_per_y=178.0
rots_per_x=369.0
rots_per_x*=rows



for q=1 to totalFrames do(
	xrotth=rots_per_x * q
	xrotth/=totalFrames
	
	yrotth=rots_per_y * q
	yrotth/=totalFrames
	yrotth=89.0-yrotth
	
	radius1=cos(yrotth)
	pos_z=sin(yrotth)
	radius1*=sphereRadius
	pos_z*=sphereRadius
	
	pos_x=sin(xrotth)
	pos_y=cos(xrotth)
	pos_x*=radius1
	pos_y*=radius1

s=Sphere radius:1.0 smooth:on segs:5 chop:0 slice:off sliceFrom:0 sliceTo:0 mapcoords:on recenter:off
s.name="SpherePoints"
s.pos=[pos_x,pos_y,pos_z]
	
	
	
)