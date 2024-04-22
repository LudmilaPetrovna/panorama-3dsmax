delete $*


mat=Standard()
--mat.diffusemap=bitmapTexture filename:@"Z:\optic\xor.jpg"
mat.diffusemap=bitmapTexture filename:@"Z:\max\atlas.jpg"
mat.selfIllumAmount = 100
showTextureMap mat true
meditMaterials[1]=mat

close infile
infile=openFile @"Z:\max\pano.csv" mode:"rt" encoding:#utf8

while not (eof infile); do (
csvline=readLine infile
infos=filterString csvline ";"

pic_width=infos[1] as float
pic_height=infos[2] as float
pic_aspect=pic_width/pic_height
uv_x1=infos[3] as float
uv_y1=infos[4] as float
uv_x2=infos[5] as float
uv_y2=infos[6] as float
yaw=infos[7] as float
pitch=infos[8] as float
roll=infos[9] as float
fov=infos[10] as float
origfilename=infos[11]


--if(pitch<-70 or pitch>1) then continue

	
rad0=(random 0.0 500.0)*(random 0.0 1.0)+200.0
rad1=cos(pitch)	*rad0

pl_width=tan(fov/2)*rad0*2.0
pl_height=pl_width/pic_aspect
	
pl=Plane width:pl_width length:pl_height lengthsegs:1 widthsegs:1 pos:[0,0,0]
pl.name=origfilename
m=Matrix3 1
rotateY m (90)

--translate m ,]
rotateX m (roll-90)
rotateY m (pitch)
rotateZ m (yaw+180)


translate m [rad1*cos(yaw),rad1*sin(yaw),sin(pitch)*rad0]


pl.transform=m
pl.material=mat


ConvertToMesh pl

meshop.getNumMaps(pl)==2

--Sphere radius:1 segs:11 pos:(getVert pl 4)
	


meshop.freeMapChannel pl 1
meshop.makeMapPlanar pl 1
meshop.setNumTVerts pl 4
meshop.setMapVert pl 1 1 [uv_x1,uv_y1,0] --bl
meshop.setMapVert pl 1 2 [uv_x2,uv_y1,0] --br
meshop.setMapVert pl 1 3 [uv_x1,uv_y2,0] --tl
meshop.setMapVert pl 1 4 [uv_x2,uv_y2,0] --tr
update pl



)

close infile


