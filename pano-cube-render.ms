delete $PanoCam*
clearListener()
clearUndoBuffer()

opticFov=90.0
pathOutputPrefix=@"v:\pano-cube"

cube_sides=#("left","front","right","top","back","bottom")
cube_sides[1]

c=Freecamera pos:[0,0,0] nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off
c.fov=90
c.orthoProjection=false
c.name="PanoCam"
viewport.setCamera c
displaySafeFrames=true
fileOutGamma=2.0
displayGamma=2.0

fn setupFrameForCubeRender frameNum frameFilename=(
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
animationRange=(interval 1f 6)

rendOutputFilename = frameFilename
renderWidth=1024
renderHeight=1024

renderSceneDialog.update()

)


-- save to Hugin project with pre-defined params
outpto=createFile (pathOutputPrefix+"-hugin.pto")
format "p w4096 h2048 f2 v360 n\"PNG\" R0 T\"UINT8\"\n" to:outpto
format "m i6\n" to:outpto

for q=1 to 6 do(

	filename=pathOutputPrefix+"-"+cube_sides[q]+".jpg"
	rx=0
	ry=0
	
	if q<4 then (
		rx=q*90-180
	) else (
		rx=180
		ry=180-(q-3)*90
	)
	
print("Creating cubemap: "+([rx,ry] as string)+", out:"+filename)
	
-- make camera animation
at time q animate on (
		mm=matrix3 1
rotateX mm 90
rotateZ mm (-rx)
rotateX mm (-ry)
		c.transform=mm
		)

-- render frame
setupFrameForCubeRender q filename
--render vfb:false gamma:2.0 frame:q camera:c outputfile:filename
		
-- save data to hugin project
print("frame "+(q as string)+", angles "+([rx,ry] as string))
pto="i f0"
pto+=" w"+(renderWidth as string)
pto+=" h"+(renderHeight as string)
pto+=" r0.0"
pto+=" p"+((ry) as string)
pto+=" y"+((rx) as string)
pto+=" v"+(c.fov as string)
pto+=" n\""+filename+"\"\n"

format pto to:outpto
)

close outpto

-- move cam
c.pos=[0,0,5]


rendTimeType=2 -- Seq
rendOutputFilename = pathOutputPrefix+"-all.jpg"
renderSceneDialog.update()
