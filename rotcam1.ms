delete $PanoCam*

opticFov=30.0
cols=ceil(360.0/opticFov*3.0) as Integer
rows=ceil(180.0/opticFov*3.0) as Integer

totalFrames=(cols*rows) as Integer
--totalFrames=5000


rendOutputFilename = "v:/path-output/road/tt.jpg"
renderWidth=48
renderHeight=32

--c=Targetcamera pos:[0,0,3] fov:45 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off
--c.fov=90
--c.orthoProjection=false
--c.name="PanoCam"

c=Freecamera pos:[0,0,0] nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off
c.fov=90
c.orthoProjection=false
c.name="PanoCam"

freeCam=c

--ct=c.target=(targetObject pos:[0,0,0])
--ct.name="PanoCamTarget"

viewport.setCamera c

rendSaveFile=true
rendSaveFile = true
rendLockImageAspectRatio=false
rendTimeType=2 -- Active time segment (animationRange)
scanlineRender.antiAliasing=false
scanlineRender.antiAliasFilter = quadratic()
scanlineRender.filterMaps=false
scanlineRender.mapping=true
scanlineRender.shadows=false
scanlineRender.enableSSE=true

frameRate=10
animationRange=(interval 1f totalFrames)

renderSceneDialog.update()

-- render this file with "nona -o outname file.pto"

outpto=createFile "v:/path-output/panotest1.pto" -- writeBOM:false)
outmen=createFile "v:/path-output/panotest1-mender.txt" -- writeBOM:false)

format "p w2048 h1024 f2 v360 n\"PNG\" R0 T\"UINT8\"\n" to:outpto
format "m i6\n" to:outpto

format "p f2 w2048 h1024 v360 n\"TIFF_m c:LZW r:CROP\"\n" to:outmen
format "m g1 i0 f0 m2 p0.00784314\n" to:outmen

ptoPrefix="i f0"
ptoPrefix+=" w"+(renderWidth as string)
ptoPrefix+=" h"+(renderHeight as string)

rx=0
ry=0
rz=0
cf=90

for q=1 to totalFrames do(
	
rx=-360.0*rows*q/totalFrames
ry=-90+180.0*q/totalFrames

rz=q*1.2345
--cf=abs(sin(180.0*q/totalFrames)*22)+1.0
	
	cf=opticFov
	
	filename="tt"+(formattedPrint q format:"04d")+".jpg"
	
	pto=ptoPrefix
	pto+=" r"+(rz as string)
	pto+=" p"+((-ry) as string)
	pto+=" y"+((-rx) as string)
	pto+=" v"+(cf as string) -- current FOV
	pto+=" n\""+filename+"\"\n"
	
	men="o w640 h480 f0 TrX0 TrY0 TrZ0 a0 b0 c0 d0 e0 g0 p0 r0 t0 v90 y"+(yaw as string)+"  n\"C:\\Shared\\dist\\road\\tt"+(formattedPrint q format:"04d")+".jpg\"\n"

	format pto to:outpto
	format men to:outmen

	
	at time q animate on (
		mm=matrix3 1
rotateY mm 90
rotateX mm 90
rotateX mm -rz
rotateY mm -ry
rotateZ mm rx
		freeCam.transform=mm
		freeCam.fov=cf

		)
	
)

freeCam.pos=[0,0,5]

close outpto
close outmen

