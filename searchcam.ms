
delete $PanoSearchCam*

c=Targetcamera pos:[0,0,0] nearclip:.001 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off
c.fov=80
c.orthoProjection=false
c.name="PanoSearchCam"



ct=c.target=(targetObject pos:[0,0,0])
ct.name="PanoSearchCamTarget"

viewport.setCamera c

points=50
frameRate=30
framesPerPoint=frameRate*5
totalFrames=points*framesPerPoint
animationRange=(interval 1f totalFrames)


for q=1 to points do(


	
at time ((q-1)*framesPerPoint+1) animate on (

	yaw=random 0 360
pitch=random -90 90
roll=0
dist=100
	
rad1=cos(pitch)*dist
ct.pos=[sin(yaw)*rad1,cos(yaw)*rad1,sin(pitch)*dist]

	yaw=random 0 360
pitch=random -90 90
roll=0
dist=q*5
	if(q<25) then dist=0
rad1=cos(pitch)*dist
c.pos=[sin(yaw)*rad1,cos(yaw)*rad1,sin(pitch)*dist]

	
	)

)