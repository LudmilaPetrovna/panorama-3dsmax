delete $*

panoRoot=@"T:\GTA-trains\Pano\pano-1711993152-2083x-1263x23\"

bboxmargin=5.0


backmat=RaytraceMaterial ()
backmat.Specular_Level = 152
backmat.glossiness = 73
backmat.Reflect_Color_On = 0
backmat.Reflect_amount = 20
backmat.Transparency_Color_On = off
backmat.Transparency_Amount=100
meditMaterials[2]=backmat

bbmat=Standard();
bbmat.wire=on
bbmat.wireSize=1
bbmat.wireUnits=0
bbmat.faceMap=on
bbmat.twoSided=on
bbmat.faceted=on
bbmat.selfIllumAmount=100
bbmat.opacity=20
bbmat.Diffuse=color 255 255 255
bbmat.Ambient=color 255 255 255
meditMaterials[3]=bbmat


mat=Standard()
--mat.diffusemap=bitmapTexture filename:@"Z:\optic\xor.jpg"
mat.diffusemap=bitmapTexture filename:(panoRoot+@"\atlas.jpg")
mat.selfIllumAmount = 100
showTextureMap mat true
meditMaterials[1]=mat

close infile
infile=openFile (panoRoot+@"\pano.csv") mode:"rt" encoding:#utf8

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
rad0=(random 100.0 700.0)
rad1=cos(pitch)	*rad0

pl_width=tan(fov/2)*rad0*2.0
pl_height=pl_width/pic_aspect
	
pl=Plane width:pl_width length:pl_height lengthsegs:1 widthsegs:1 pos:[0,0,0]
pl.name=origfilename

bb=Box lengthsegs:1 widthsegs:1 heightsegs:1 width:pl_width length:pl_height height:1.0 mapcoords:on pos:[0,0,-1.1]
bb.parent=pl
bb.material=backmat
bb.name=(origfilename+" back mirror plate")

bb=Box lengthsegs:1 widthsegs:1 heightsegs:1 width:(pl_width+bboxmargin*2.0) length:(pl_height+bboxmargin*2.0) height:(bboxmargin*0.9) mapcoords:on pos:[0,0,-bboxmargin]
bb.parent=pl
bb.material=bbmat
bb.name=(origfilename+" bounding box")

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


