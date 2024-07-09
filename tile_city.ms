delete $*
clearUndoBuffer()

-- +step 1: build tile city
-- +step 2: build road in center
-- +step 3: spawn cubes 1-2-3m and some of them in wireframe
-- +step 4: spawn spheres 1-2-3m and some of them in wireframe
-- +step 5: spawn cyl towers 0.5/1m with spheres 1-2-3m on top
-- +spawn random at distance from center
-- wireframe
-- add light

city_size=50
city_boxes=100

transparentMat=Standard()
transparentMat.selfIllumAmount = 30
transparentMat.specularLevel = 50
transparentMat.opacity = 20
transparentMat.Diffuse = color 3 177 52
transparentMat.ambient = color 3 177 52

dch=Checker()
dch.coords.U_Tiling=10
dch.coords.V_Tiling=10
transparentMat.diffuseMap=dch

wireMat=Standard()
wireMat.wire=on
wireMat.wireSize=1.5
wireMat.faceted=on
wireMat.twoSided=on
wireMat.selfIllumAmount=15
wireMat.Diffuse=color 0 255 0
wireMat.ambient=color 0 255 0


fn get_random_points_across_road=(

local az=random 0.0 360.0
local dist=1.0*city_size-(random 0.0 city_size)*(random 0.0 1.0)+10.0
local fx=sin(az)*dist
local fy=cos(az)*dist
local ox=fx as Integer
local oy=fy as Integer
local npos=[ox+.5,oy+.5,0]
return npos
	)

fn draw_tile new_pos is_road=(
	local tile
	local bev
	local ncolor
	tile=Rectangle length:1.0 width:1.0 cornerRadius:0
	tile.pivot=[-.5,-.5,0.1]
	tile.pos=new_pos

bev=Bevel()
bev.Segments=1
bev.Level_1_Height=0.1
bev.Level_1_Outline=-0.1
addModifier tile bev

			if is_road then (
				ncolor=random [0,0,0] [50,50,50]
			) else (
				ncolor=random [255,255,255] [128,128,128]
			)
			
tile.wireColor=ncolor
collapseStack tile

return			
			if is_road then (
	tile=Rectangle length:1.0 width:1.0 cornerRadius:0
	tile.pivot=[-.5,-.5,0]
	tile.pos=new_pos
				tile.wireColor=(color 0 255 0)
				tile.render_renderable=true
				tile.render_thickness=0.01
				is_checker=(bit.and (bit.xor new_pos[1] new_pos[2]) 1)
				
				if is_checker == 0 then (
				tile=Plane lengthsegs:1 widthsegs:1 length:1.0 width:1.0
				tile.pivot=[-.5,-.5,-0.001]
				tile.pos=new_pos
					tile.material=transparentMat
					)
			)
	
tt=text size:0.2 kerning:0 leading:0 pos:(new_pos+[0.5,0.5,0])
tt.optimize=true 
tt.adaptive=false 
tt.steps=2
tt.font="Arial"
tt.text=((new_pos[1] as string)+"x"+(new_pos[2] as string))

ee=Extrude()
ee.amount=0.01

addModifier tt ee
tt.wireColor=(color 255 255 255)
collapseStack tt
	
return tile
)

fn draw_city=(
	local q
	local w
	local color
	for w=-city_size to city_size do (
		for q=-city_size to city_size do (
			if abs(q)==2 or abs(w)==2 or q==0 or w==0 then (
				-- this is main road
				road=true


			) else (
				road=false
			)
			
			draw_tile [q,w,0] road
		)
	)
)
	
fn spawnBoxes=(
local q
	local bsize
	for q=1 to city_boxes do (
		bsize=(random 0.0 1.0)*(random 0.0 1.0)*6.0+1.0
		bsize=bsize as Integer
		bb=Box lengthsegs:1 widthsegs:1 heightsegs:1 length:bsize width:bsize height:bsize
		bb.pivot=[bsize,bsize,1]*[-.5,-.5,0.0];
		bb.pos=get_random_points_across_road()-[0.5,0.5,0]
if (random 0 10) < 5 then (
	bb.material=wireMat
)
	)
)

fn spawnTowers maxHeight=(
local q
local t
	for q=1 to city_boxes do (
		npos=get_random_points_across_road()
		height=(random 0.1 maxHeight)*(random 0.0 1.0)*(random 0.0 1.0)
		if maxHeight>0 do (
		t=Cylinder smooth:on capsegs:1
t.height=height
t.heightsegs=1
t.radius=0.5
t.sides=20
t.pos=npos
	)
srad=(random 1 5)*.5
s=Sphere smooth:on chop:0 slice:off sliceFrom:0 sliceTo:0
s.radius=srad
s.segs = 20
s.pos=npos+[0,0,height+srad]
if (random 0 10) < 5 then (
	s.material=wireMat
)
		
	)
)


cam=Freecamera fov:65 targetDistance:0 nearclip:1 farclip:1000 nearrange:0 farrange:1000
cam.transform=(matrix3 [1,0,0] [0,0,1] [0,-1,0] [2.5522,-6.89646e-007,15.7773])
cam.pos=[0,0,2]

viewport.setCamera cam
viewport.SetShowEdgeFaces false
viewport.GetShowEdgeFaces() 
max shade selected
vvv=NitrousGraphicsManager.GetViewportSetting(3)
vvv.VisualStyleMode=#Shaded

undo off(
draw_city()
spawnTowers 100;
spawnTowers 0;
spawnBoxes()
)