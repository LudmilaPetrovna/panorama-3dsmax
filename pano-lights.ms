delete $*

-- Ne poluchilos, ne fortanulo

panoRoot=@"T:\GTA-trains\Pano\pano-1712767012-861x61x83\"


prostinya=Standard()
prostinya.selfIllumAmount = 0
prostinya.adLock=off
prostinya.ambient = color 0 0 0
prostinya.Diffuse = color 100 100 100
prostinya.Specular = color 0 0 0
prostinya.specularLevel = 0
meditMaterials[3]=prostinya


pl=Plane width:200.0 length:200 pos:[0,0,-20]
pl.material=prostinya

close infile
infile=openFile (@"z:\PanoSlicer\pano.csv") mode:"rt" encoding:#utf8

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
	
	--if(origfilename=="frame-0000094.png") then (

proj=targetSpot rgb:(color 255 255 255) multiplier:1 contrast:0 softenDiffuseEdge:0 nearAttenStart:0 nearAttenEnd:0 farAttenStart:0 farAttenEnd:0 decayRadius:40 atmosOpacity:100 atmosColorAmt:100 shadowMultiplier:1
proj.name=("TargetSpot:"+origfilename)
proj.hotspot=fov
proj.falloff=fov
proj.aspect=pic_aspect
proj.pos=[0,0,0]

proj.target=(Targetobject pos:[sin(yaw)*cos(pitch),cos(yaw)*cos(pitch),sin(pitch)])
proj.projector=on
--proj.projectorMap=meditMaterials[1].diffuseMap
proj.projectorMap=bitmapTexture filename:(panoRoot+@"\"+origfilename)
proj.showNearAtten=on
proj.showFarAtten=on
	
	)
--)
close infile



