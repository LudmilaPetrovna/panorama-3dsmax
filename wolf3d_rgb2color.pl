read(STDIN,$file,1000000);

$file=~s/\/\*.+?\*\///s;

while($file=~/RGB\(\s*(\d+),\s*(\d+),\s*(\d+)\)/gsi){
($r,$g,$b)=map{int($_/63*255)}($1,$2,$3);
print chr($r),chr($g),chr($b);
}

