
-- todo
-- stage1: center cam 100% in center and move target
-- stage2: fly around center, target in 100% center
-- stage3: go at random position around sphere, fix target, go via center of sphere... 100 times


delete $PanoSearch*

sun=Omnilight rgb:(color 255 255 255) shadowColor:(color 0 0 0) multiplier:2 contrast:0 softenDiffuseEdge:0 nearAttenStart:0 nearAttenEnd:40 farAttenStart:80 farAttenEnd:200 decayRadius:40 atmosOpacity:100 atmosColorAmt:100 shadowMultiplier:1 pos:[0,0,0]
sun.name="PanoSearchSun"

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


for q=1 to points+1 do(


	
at time ((q-1)*framesPerPoint+1) animate on (

	yaw=random 0 360
pitch=random -90 90
roll=0
dist=100
	
rad1=cos(pitch)*dist
ct.pos=[sin(yaw)*rad1,cos(yaw)*rad1,sin(pitch)*dist]
	ct.pos=[0,0,0]


dist=(pow (q/10.0) 5)*1.0-100.0
if(dist<1)then dist=0.00001
print ("Dist:" + (dist as string))

yaw=(pow q 2)*.5-90
pitch=(random -90.0 90.0)*(random 0.0 1.0)*.1
roll=0

rad1=cos(pitch)*dist
c.pos=[sin(yaw)*rad1,cos(yaw)*rad1,sin(pitch)*dist]

illum=255
if(q>25) then illum=100.0-(q-25)/25.0*100.0

meditMaterials[1].selfIllumAmount=illum
	
	)

)