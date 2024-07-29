/dev/shm/Wolf3DExtract-master/Source/wolf3dextract -lm 1 1 0 > map-plane0.txt
/dev/shm/Wolf3DExtract-master/Source/wolf3dextract -lm 1 1 1 > map-plane1.txt
/dev/shm/Wolf3DExtract-master/Source/wolf3dextract -lm 1 1 2 > map-plane2.txt
ffmpeg -f rawvideo -s 64x64 -pix_fmt rgb565 -i map-plane0.txt -y map-plane0.png
ffmpeg -f rawvideo -s 64x64 -pix_fmt rgb565 -i map-plane1.txt -y map-plane1.png
ffmpeg -f rawvideo -s 64x64 -pix_fmt rgb565 -i map-plane2.txt -y map-plane2.png
