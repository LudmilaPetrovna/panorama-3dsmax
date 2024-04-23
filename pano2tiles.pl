use GD;
use Data::Dumper;


$tilesize=256;
$filename=$ARGV[0] || "pano.png";

$tile=GD::Image->new($tilesize,$tilesize,1);

if($filename=~/\.png$/i){
$image=GD::Image->newFromPng($filename,1);
}else{
$image=GD::Image->newFromJpeg($filename,1);
}

$imgsize=[$image->getBounds()];
for($w=0;$w<$imgsize->[1];$w+=$tilesize){
for($q=0;$q<$imgsize->[0];$q+=$tilesize){
$outname="tileset-".($q/$tilesize)."-".($w/$tilesize).".jpg";
print "Processing $outname\n";
$tile->copyResampled($image,0,0,$q,$w,$tilesize,$tilesize,$tilesize,$tilesize);

open(oo,">".$outname);
binmode(oo);
print oo $tile->jpeg(90);
close(oo);


}
}

