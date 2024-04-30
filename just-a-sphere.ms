--delete $*

mainRadius=100.0

	
viewFovX1=0.0
viewFovX2=360.0
viewFovY1=-90.0
viewFovY2=90.0
viewFovH=360.0
viewFovV=180.0

verSubDiv=35
horSubDiv=25


mat=Standard()
mat.diffusemap=bitmapTexture filename:(@"z:\PanoSlicer\pano.jpg")
mat.selfIllumAmount = 100
showTextureMap mat true
meditMaterials[1]=mat

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
verAngle=1.0*verSubSegment/vertexPerCol
horAngle=1.0*horSubSegment/vertexPerRow

--print("horAngle: "+(horAngle as string)+", verAngle: "+(verAngle as string))

if(verSubSegment>0 and horSubSegment>0) do (
	
--faces INTO sphere
	
vert1=q-1-vertexPerRow
vert2=q-vertexPerRow
vert3=q-1
vert4=q

hStep=1.0/(vertexPerRow-1)
vStep=1.0/(vertexPerCol-1)
	
uv_x2=horSubSegment*hStep
uv_y2=verSubSegment*vStep
uv_x1=uv_x2-hStep
uv_y1=uv_y2-vStep
	
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
