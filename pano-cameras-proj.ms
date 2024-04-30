delete $*


displayGamma=2
panoRoot=@"T:\GTA-trains\Pano\pano-1712767012-861x61x83\"

camsmat=Standard()
camsmat.selfIllumAmount = 0
camsmat.diffuseMap=CompositeTexturemap()
camsmat.diffuseMap.mapEnabled.count=190
meditMaterials[5]=camsmat

close infile
infile=openFile (@"z:\PanoSlicer\pano.csv") mode:"rt" encoding:#utf8
slotpoint=1
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

proj=Targetcamera fov:45 nearclip:1 farclip:1000 nearrange:0 farrange:1000 
proj.name=("TargetSpot:"+origfilename)
proj.pos=[0,0,0]
proj.target=(Targetobject pos:[sin(yaw)*cos(pitch),cos(yaw)*cos(pitch),sin(pitch)])

scamtex=Camera_Map_Per_Pixel()
scamtex.camera=proj
scamtex.texture=Bitmaptexture fileName:(panoRoot+@"\"+origfilename)
camsmat.diffuseMap.mapList[slotpoint]=scamtex
slotpoint+=1
	
	)
--)
close infile



