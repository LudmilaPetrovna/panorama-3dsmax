use GD;
use Data::Dumper;


open(dd,$ARGV[0] || "pano.pto");
read(dd,$file,-s(dd));
close(dd);

# parse input file
@cards=();
while($file=~/^i\s*([^\n]+)/gm){
@parts=split(/\s+/,$1);
%fields=();
map{
$key=substr($_,0,1);
$val=substr($_,1);
if($key eq "n" && substr($val,0,1) eq '"'){
$val=substr($val,1,length($val)-2);
}
$fields{$key}=$val;
}@parts;

if($fields{n}=~/\.(png|jpe?g)/i && -s($fields{n})){
push(@cards,{%fields});
}

}

$cardscount=@cards;

# Calc cards (frames) size
# Actually can be any size

$aspect=$cards[0]->{w}/$cards[0]->{h};
$cardwidth=320;
$cardheight=int($cardwidth/$aspect+.5);
print "Creating atlas width cards ${cardwidth}x${cardheight} (aspect ratio:$aspect)\n";

# calc best atlas size
@pows=map{2**$_}(0..14);

$ourpixels=$cardwidth*$cardheight*$cardscount;

foreach $pheight(@pows){
foreach $pwidth(@pows){
$ppixels=$pheight*$pwidth;
if($ppixels<$ourpixels){next;}

$tile_x=int($pwidth/$cardwidth);
$tile_y=int($pheight/$cardheight);
if($tile_x*$tile_y<$cardscount){next;}

push(@possible,[$pwidth,$pheight,$ppixels-$ourpixels+abs($pwidth-$pheight)]);

}
}

@possible=sort{$a->[2] <=> $b->[2]}@possible;

($atlas_width,$atlas_height)=@{$possible[0]};


# calc layout

$tile_x=int($atlas_width/$cardwidth);
$uv_width=$cardwidth/$atlas_width;
$uv_height=$cardheight/$atlas_height;

# create atlas
$output_filename="atlas.jpg";

if(!-s($output_filename)){
$atlas=GD::Image->new($atlas_width,$atlas_height,1);

$pos=0;
foreach $card(@cards){
$filename=$card->{n};
print "Reading $filename...\n";
if($filename=~/\.png$/i){
$image=GD::Image->newFromPng($filename,1);
}else{
$image=GD::Image->newFromJpeg($filename,1);
}
if(!$image){
die "Can't read image $filename!";
}
$ox=($pos%$tile_x)*$cardwidth;
$oy=int($pos/$tile_x)*$cardheight;
$atlas->copyResampled($image,$ox,$oy,0,0,$cardwidth,$cardheight,$image->getBounds());
$pos++;

}

open(oo,">".$output_filename);
binmode(oo);
print oo $atlas->jpeg(90);
close(oo);
}

=pod
* creating metadata
* filename must be with:
[0]width
[1]height
[2]uv_x1..uv_x2
[4]uv_y1..uv_y2
[6]yaw
[7]pitch
[8]roll
[9]fov

=cut
$pos=0;
open(oo,">pano.csv");
foreach $card(@cards){
$ox=($pos%$tile_x)*$cardwidth;
$oy=int($pos/$tile_x)*$cardheight;
$uv_x=$ox/$atlas_width;
$uv_y=1-$oy/$atlas_height;
print oo join(";",
$card->{w},$card->{h},
$uv_x,$uv_y,
$uv_x+$uv_width,$uv_y-$uv_height,
$card->{y},$card->{p},$card->{r},$card->{v},$card->{n})."\n";



$pos++;
}
close(oo);


