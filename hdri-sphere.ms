delete $PanoSphere*

s=Sphere radius:50 smooth:on segs:32 chop:0 slice:off sliceFrom:0 sliceTo:0 mapcoords:on recenter:off
s.name="PanoSphere"
s.pos=[0,0,0]

bt=bitmaptexture filename:@"D:\path-to-maps\hdri_mountain.hdr"
m=Standardmaterial diffusemap:bt twoSided:true
s.mat=m

showTextureMap m bt on
