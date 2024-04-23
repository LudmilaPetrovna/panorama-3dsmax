delete $*


mainRadius=100.0

--15x120/30x135=15x30/30x45

targetFov=50.0
	
c=Targetcamera pos:[0,0,0] nearclip:.001 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off
c.fov=targetFov
c.orthoProjection=false

targetX=22
targetY=90-126
	
ct=c.target=(targetObject pos:[sin(targetX)*cos(targetY),cos(targetX)*cos(targetY),sin(targetY)])
	
viewport.setCamera c

anglePerTile=22.5
for renderTileY=0 to 7 do(
for renderTileX=0 to 15 do(

viewFovX1=1.0*renderTileX*anglePerTile
viewFovX2=1.0*renderTileX*anglePerTile+anglePerTile
viewFovY2=90.0-1.0*renderTileY*anglePerTile
viewFovY1=90.0-1.0*renderTileY*anglePerTile-anglePerTile
viewFovH=anglePerTile
viewFovV=anglePerTile

verSubDiv=5
horSubDiv=5


mat=Standard()
mat.diffusemap=bitmapTexture filename:(@"z:\PanoSlicer\tileset-"+(renderTileX as string)+"-"+(renderTileY as string)+".jpg")
mat.selfIllumAmount = 100
showTextureMap mat true
meditMaterials[1]=mat

-- add sun
--Omnilight rgb:(color 255 255 255) shadowColor:(color 0 0 0) multiplier:1 contrast:0 softenDiffuseEdge:0 nearAttenStart:0 nearAttenEnd:40 farAttenStart:80 farAttenEnd:200 decayRadius:40 atmosOpacity:100 atmosColorAmt:100 shadowMultiplier:1 pos:[0,0,0]
--Omnilight rgb:(color 255 255 255) shadowColor:(color 0 0 0) multiplier:1 contrast:0 softenDiffuseEdge:0 nearAttenStart:0 nearAttenEnd:40 farAttenStart:80 farAttenEnd:200 decayRadius:40 atmosOpacity:100 atmosColorAmt:100 shadowMultiplier:1 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [-115.313,-1.29816e-006,29.6984]) isSelected:on
--Omnilight rgb:(color 255 255 255) shadowColor:(color 0 0 0) multiplier:1 contrast:0 softenDiffuseEdge:0 nearAttenStart:0 nearAttenEnd:40 farAttenStart:80 farAttenEnd:200 decayRadius:40 atmosOpacity:100 atmosColorAmt:100 shadowMultiplier:1 showFarAtten:off useFarAtten:off showNearAtten:off useNearAtten:off transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [-92.1114,3.3671e-006,-77.0302]) isSelected:on
--Omnilight rgb:(color 255 255 255) shadowColor:(color 0 0 0) multiplier:1 contrast:0 softenDiffuseEdge:0 nearAttenStart:0 nearAttenEnd:40 farAttenStart:80 farAttenEnd:200 decayRadius:40 atmosOpacity:100 atmosColorAmt:100 shadowMultiplier:1 showFarAtten:off useFarAtten:off showNearAtten:off useNearAtten:off transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [89.3271,3.18454e-006,-72.8538]) isSelected:on
--Omnilight rgb:(color 255 255 255) shadowColor:(color 0 0 0) multiplier:1 contrast:0 softenDiffuseEdge:0 nearAttenStart:0 nearAttenEnd:40 farAttenStart:80 farAttenEnd:200 decayRadius:40 atmosOpacity:100 atmosColorAmt:100 shadowMultiplier:1 showFarAtten:off useFarAtten:off showNearAtten:off useNearAtten:off transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [110.673,-2.02837e-006,46.4037]) isSelected:on

vertexPerRow=(horSubDiv+2)
vertexPerCol=(verSubDiv+2)
totalVertexCount=vertexPerRow*vertexPerCol

m=mesh numverts:totalVertexCount numfaces:0

for q=1 to totalVertexCount do (
verSubSegment=int((q-1)/vertexPerRow)
horSubSegment=q-verSubSegment*vertexPerRow-1
--print("ver: "+(verSubSegment as string)+", hor: "+(horSubSegment as string))
verAngle=viewFovV/(vertexPerCol-1)*verSubSegment+viewFovY1;
horAngle=viewFovH/(vertexPerRow-1)*horSubSegment+viewFovX1
--print("ver: "+(verAngle as string)+", hor: "+(horAngle as string))
	
subSegmentRadius=cos(verAngle)*mainRadius
vertexPosition=[sin(horAngle)*subSegmentRadius,cos(horAngle)*subSegmentRadius,sin(verAngle)*mainRadius]
--Sphere radius:10 segs:5 pos:vertexPosition

setVert m q vertexPosition
if(verSubSegment>0 and horSubSegment>0) do (
	
--faces out of sphere
--meshop.createPolygon m #(q-1,q,q-1-vertexPerRow)
--meshop.createPolygon m #(q-vertexPerRow,q-1-vertexPerRow,q)
	
--faces INTO sphere
	
vert1=q
vert2=q-1
vert3=q-1-vertexPerRow
vert4=q-vertexPerRow

meshop.createPolygon m #(vert1,vert2,vert3)
meshop.createPolygon m #(vert3,vert4,vert1)

)
)

update m

meshop.setNumMaps m 2 keep:false
meshop.getMapSupport m 1
meshop.freeMapChannel m 1
meshop.makeMapPlanar m 1
meshop.setNumTVerts m totalVertexCount


for q=1 to totalVertexCount do (
verSubSegment=int((q-1)/vertexPerRow)
horSubSegment=q-verSubSegment*vertexPerRow-1

-- for full frame
--verAngle=1.0*verSubSegment/vertexPerCol*viewFovV+viewFovY1
--horAngle=1.0*horSubSegment/vertexPerRow*viewFovH+viewFovX1

-- for tile
verAngle=1.0*verSubSegment/vertexPerCol
horAngle=1.0*horSubSegment/vertexPerRow


--print("horAngle: "+(horAngle as string)+", verAngle: "+(verAngle as string))

if(verSubSegment>0 and horSubSegment>0) do (
	
	--faces out of sphere
--meshop.createPolygon m #(q-1,q,q-1-vertexPerRow)
--meshop.createPolygon m #(q-vertexPerRow,q-1-vertexPerRow,q)
	
--faces INTO sphere
	
vert1=q-1-vertexPerRow
vert2=q-vertexPerRow
vert3=q-1
vert4=q

hStep=1.0/(vertexPerRow-1)
	
uv_x2=horSubSegment*hStep
uv_y2=verSubSegment*hStep
uv_x1=uv_x2-hStep
uv_y1=uv_y2-hStep
	
print("UV:"+(uv_x1 as string)+", "+(uv_y1 as string)+", "+(uv_x2 as string)+", "+(uv_y2 as string)+"!")

--Sphere radius:10 segs:5 pos:(getVert m vert1) name:"vert1"
--Sphere radius:10 segs:5 pos:(getVert m vert2) name:"vert2"
--Sphere radius:10 segs:5 pos:(getVert m vert3) name:"vert3"
--Sphere radius:10 segs:5 pos:(getVert m vert4) name:"vert4"

meshop.setMapVert m 1 vert1 [uv_x1,uv_y1,0] --bl
meshop.setMapVert m 1 vert2 [uv_x2,uv_y1,0] --br
meshop.setMapVert m 1 vert3 [uv_x1,uv_y2,0] --tl
meshop.setMapVert m 1 vert4 [uv_x2,uv_y2,0] --tr
)
	)
	
m.material=meditMaterials[1]

update m
)
)
