
fn loadAtlas=(
mat=Standard()
mat.diffusemap=bitmapTexture filename:(@"z:\wolf3d\atlas.png")
mat.opacitymap=bitmapTexture filename:(@"z:\wolf3d\atlas.png")

mat.opacitymap.rgbOutput = 1
mat.opacitymap.monoOutput = 1
mat.opacitymap.rgbOutput = 0
mat.opacitymap.preMultAlpha = off
mat.opacitymap.alphaSource = 0
	
mat.selfIllumAmount = 100
showTextureMap mat true
meditMaterials[1]=mat
)

fn drawBox wall_id0=(
	
	if wall_id0<1 do (
		throw "parameter must not be 0"
	)

	m=mesh numverts:12 numfaces:8
	m.name="wall_ref_"+(wall_id0 as string)
	setVert m 1 [0,0,0]
	setVert m 2 [0,0,1]
	setVert m 3 [1,0,0]
	setVert m 4 [1,0,1]
	setVert m 5 [1,1,0]
	setVert m 6 [1,1,1]

	setVert m 7 [1,1,0]
	setVert m 8 [1,1,1]
	setVert m 9 [0,1,0]
	setVert m 10 [0,1,1]
	setVert m 11 [0,0,0]
	setVert m 12 [0,0,1]

	

	for q=0 to 2 do(
		vert1=(q*2)+1
		vert2=(q*2)+2
		vert3=(q*2)+3
		vert4=(q*2)+4
	meshop.createPolygon m #(vert2,vert1,vert3)	
		meshop.createPolygon m #(vert3,vert4,vert2)

	)
	for q=3 to 4 do(
		vert1=(q*2)+1
		vert2=(q*2)+2
		vert3=(q*2)+3
		vert4=(q*2)+4
	meshop.createPolygon m #(vert2,vert1,vert3)	
		meshop.createPolygon m #(vert3,vert4,vert2)

	)
	
update m

meshop.setNumMaps m 2 keep:false
meshop.getMapSupport m 1
meshop.freeMapChannel m 1
meshop.makeMapPlanar m 1
meshop.setNumTVerts m 12
wall_id=0

	wall_id=wall_id0-1
	wall_id*=2
	print wall_id
	tile_x=mod wall_id 16
	tile_y=int (wall_id/16)
	print ((tile_x as string)+"x"+(tile_y as string))
	
	uv_x1=64.0*tile_x/1024.0
	uv_x2=64.0*(tile_x+1)/1024.0
	uv_x3=64.0*(tile_x+2)/1024.0
	uv_y2=1-64.0*(tile_y+0)/1024.0
	uv_y1=1-64.0*(tile_y+1)/1024.0

	
meshop.setMapVert m 1 1 [uv_x1,uv_y1,0]
meshop.setMapVert m 1 2 [uv_x1,uv_y2,0]
meshop.setMapVert m 1 3 [uv_x2,uv_y1,0]
meshop.setMapVert m 1 4 [uv_x2,uv_y2,0]
meshop.setMapVert m 1 5 [uv_x3,uv_y1,0]
meshop.setMapVert m 1 6 [uv_x3,uv_y2,0]

meshop.setMapVert m 1 7 [uv_x1,uv_y1,0]
meshop.setMapVert m 1 8 [uv_x1,uv_y2,0]
meshop.setMapVert m 1 9 [uv_x2,uv_y1,0]
meshop.setMapVert m 1 10 [uv_x2,uv_y2,0]
meshop.setMapVert m 1 11 [uv_x3,uv_y1,0]
meshop.setMapVert m 1 12 [uv_x3,uv_y2,0]
	
m.material=meditMaterials[1]
m
)


fn drawDoors door_id0=(
	
	m=mesh numverts:8 numfaces:4
	m.name="door_ref_"+(door_id0 as string)
	setVert m 1 [0,0.001,0]
	setVert m 2 [0,0.001,1]
	setVert m 3 [1,0.001,0]
	setVert m 4 [1,0.001,1]
	setVert m 5 [1,0.999,0]
	setVert m 6 [1,0.999,1]
	setVert m 7 [0,0.999,0]
	setVert m 8 [0,0.999,1]

	for q=0 to 1 do(
		vert1=(q*4)+1
		vert2=(q*4)+2
		vert3=(q*4)+3
		vert4=(q*4)+4
	meshop.createPolygon m #(vert1,vert2,vert3)	
	meshop.createPolygon m #(vert4,vert3,vert2)

	)
	
update m

meshop.setNumMaps m 2 keep:false
meshop.getMapSupport m 1
meshop.freeMapChannel m 1
meshop.makeMapPlanar m 1
meshop.setNumTVerts m 8

	
	wall_id=door_id0+98
	print wall_id
	tile_x=mod wall_id 16
	tile_y=int (wall_id/16)
	print ((tile_x as string)+"x"+(tile_y as string))
	
	uv_x1=64.0*tile_x/1024.0
	uv_x2=64.0*(tile_x+1)/1024.0
	uv_y2=1-64.0*(tile_y+0)/1024.0
	uv_y1=1-64.0*(tile_y+1)/1024.0

	
meshop.setMapVert m 1 1 [uv_x1,uv_y1,0]
meshop.setMapVert m 1 2 [uv_x1,uv_y2,0]
meshop.setMapVert m 1 3 [uv_x2,uv_y1,0]
meshop.setMapVert m 1 4 [uv_x2,uv_y2,0]
meshop.setMapVert m 1 5 [uv_x1,uv_y1,0]
meshop.setMapVert m 1 6 [uv_x1,uv_y2,0]
meshop.setMapVert m 1 7 [uv_x2,uv_y1,0]
meshop.setMapVert m 1 8 [uv_x2,uv_y2,0]
	
m.material=meditMaterials[1]

m
)


fn drawSprite spr_id0=(
	
	m=mesh numverts:4 numfaces:2
	m.name="spr_ref_"+(spr_id0 as string)
	
	setVert m 1 [-.5,0,0]
	setVert m 2 [-.5,0,1]
	setVert m 3 [.5,0,0]
	setVert m 4 [.5,0,1]

		vert1=1
		vert2=2
		vert3=3
		vert4=4
	meshop.createPolygon m #(vert2,vert1,vert3)	
	meshop.createPolygon m #(vert3,vert4,vert2)

	
update m
	
	
cnt=LookAt_Constraint ()
cnt.appendTarget $gamecam 100.0
cnt.target_axisFlip = on
cnt.target_axis = 1
cnt.StoUP_axis = 2
cnt.StoUP_axisFlip = off
cnt.upnode_axis = 2

m.rotation.controller = cnt
	
meshop.setNumMaps m 2 keep:false
meshop.getMapSupport m 1
meshop.freeMapChannel m 1
meshop.makeMapPlanar m 1
meshop.setNumTVerts m 4

	
	wall_id=spr_id0+112-1
	print wall_id
	tile_x=mod wall_id 16
	tile_y=int (wall_id/16)
	print ((tile_x as string)+"x"+(tile_y as string))
	
	uv_x1=64.0*tile_x/1024.0
	uv_x2=64.0*(tile_x+1)/1024.0
	uv_y2=1-64.0*(tile_y+0)/1024.0
	uv_y1=1-64.0*(tile_y+1)/1024.0

	
meshop.setMapVert m 1 1 [uv_x1,uv_y1,0]
meshop.setMapVert m 1 2 [uv_x1,uv_y2,0]
meshop.setMapVert m 1 3 [uv_x2,uv_y1,0]
meshop.setMapVert m 1 4 [uv_x2,uv_y2,0]
	
m.material=meditMaterials[1]
m
)

fn initRefs=(
	local q
	local w
loadAtlas()
delete $gamecam*
--gamecam=Targetcamera name:"gamecam" fov:45 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off target:(Targetobject())
gamecam=Freecamera pos:[0,0,0] nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off
gamecam.fov=90
gamecam.orthoProjection=false
gamecam.name="GameCam"
	
delete $wall_ref_*
for q=1 to 53 do(
	w=drawBox q
	w.pos=[q,100,0]
)
delete $door_ref_*
for q=0 to 5 do(
	w=drawDoors q
	w.pos=[q,102,0]
)
delete $spr_ref_*
for q=3 to 50 do(
	w=drawSprite q
	w.pos=[q,104,0]
)
)


fn placeObjects=(
local level
level=openFile (@"z:\wolf3d\level1-max.txt") mode:"rt" encoding:#utf8

delete $wall_at*
delete $spr_at*
delete $door_at*
floors=#()
	
while not (eof level); do (
object_info=readLine level
object_fields=filterString object_info " "

if object_fields[1]=="floor" do (
append floors [object_fields[2] as float,object_fields[3] as float,0.0]
)
	
if object_fields[1]=="box" do (
 nn=instance (getNodeByName ("wall_ref_"+object_fields[4]))
 nn.pos=[object_fields[2] as float,object_fields[3] as float,0]
 nn.name="wall_at_"+(nn.pos as string)
)
	
if object_fields[1]=="spr" do (
id=(object_fields[4] as integer)-20
	if id>50 then continue
	if id<3 then continue

 nn=instance (getNodeByName ("spr_ref_"+(id as string)))
	 
 nn.pos=[(object_fields[2] as float)+.5,(object_fields[3] as float)+.5,0]
 nn.name="spr_at_"+(nn.pos as string)
)


if object_fields[1]=="doors" do (
id=(object_fields[4] as integer)

	cube_id="wall_ref_53" -- locked door
	if id==6 do ( -- elevator door
	 cube_id="wall_ref_52"	
	)
	
	if id==0 then ( --any open door
		nn=instance (getNodeByName "door_ref_2")
	) else (
		nn=instance (getNodeByName cube_id)
	)

if object_fields[5]=="1" do (
	nn.pos=[0,0,0]
	nn.pivot=[.5,.5,0]
	rotate nn (angleaxis 90 [0,0,1])
	nn.pivot=[0,0,0]
)

 nn.pos=[(object_fields[2] as float),(object_fields[3] as float),0]
 nn.name="door_at_"+(nn.pos as string)

)


)
close level
)

fn flyGameCamera=(
	local positions=floors.count
	
	animationRange=(interval 1f (positions*6+1))
	
	for q=1 to positions do(
		for st=1 to 6 do (
			frame_num=(q-1)*6+(st-1)+1

		rx=0
	ry=0
	if st<4 then (
		rx=st*90-180
	) else (
		rx=180
		ry=180-(st-3)*90
	)

mm=matrix3 1
rotateX mm 90
rotateZ mm (-rx)
rotateX mm (-ry)

			at time frame_num animate on (
gamecam.transform=mm
gamecam.pos=floors[q]+[0.5,0.5,0.5]
)
		)
	)
)

fn createCeilingAndFloor=(
local mat	
mat=Standard()
mat.diffusemap=bitmapTexture filename:(@"z:\wolf3d\atlas-numbers.png")
mat.diffusemap.coords.U_Tiling =1
mat.diffusemap.coords.V_Tiling =1
mat.twoSided = on
mat.selfIllumAmount = 100
showTextureMap mat true
meditMaterials[2]=mat

delete $Plane*
-- floor
obj=Plane length:64.0 width:64.0 pos:[32,32,0]
obj.material=mat
obj.name="planes_floor"

-- ceiling	
obj=Plane length:64.0 width:64.0 pos:[32,32,1]
obj.material=mat	
obj.name="planes_ceiling"
rotate obj (angleaxis 180 [1,0,0])

)

fn setupCamForPano=(

displaySafeFrames=true
fileOutGamma=5.0
displayGamma=1.0
rendTimeType=2 -- Seq

rendSaveFile=true
rendLockImageAspectRatio=false
rendTimeType=1 -- Single frame
scanlineRender.antiAliasing=false
scanlineRender.antiAliasFilter = quadratic()
scanlineRender.filterMaps=false
scanlineRender.mapping=true
scanlineRender.shadows=false
scanlineRender.enableSSE=true

frameRate=10
rendOutputFilename = @"v:\wolf3d\wolf.jpg"
renderWidth=1024
renderHeight=1024
renderSceneDialog.update()
)

--floors=#()
--initRefs()
--placeObjects()
--createCeilingAndFloor()
--flyGameCamera()
setupCamForPano()
