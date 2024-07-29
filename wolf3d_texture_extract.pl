use GD;

open(dd,"pal.bin");
read(dd,$pal,768);
close(dd);

@palette=map{unpack("N","\x00".substr($pal,$_*3,3))}(0..255);

$atlas=GD::Image->new(1024,1024,1);
$atlas->alphaBlending(0);
$atlas->saveAlpha(1);



open(dd,"MAPHEAD.WL6");
read(dd,$maphead,-s(dd));
close(dd);
if(substr($maphead,0,2) ne "\xcd\xab"){
die "Possible broken MAPHEAD.WL6!";
}

open(dd,"GAMEMAPS.WL6");
read(dd,$maps,-s(dd));
close(dd);


for($q=0;$q<100;$q++){
$map_offset=unpack("I",substr($maphead,2+$q*4,4));
($plane0,$plane1,$plane2,$plane0_size,$plane1_size,$plane2_size,$map_width,$map_height,$title)=unpack("IIISSSSSA16",
substr($maps,$map_offset,42));
if($map_width!=$map_height || $map_width!=64){
print STDERR "Map size $q $map_offset  $map_width x $map_height, it's wrong!\n";
next;
}
print "($plane0,$plane1,$plane2,$plane0_size,$plane1_size,$plane2_size,$map_width,$map_height,$title)\n";


}




open(dd,"VSWAP.WL6");

read(dd,$file,-s(dd));


($chunks_count,$tex_count,$tex_sprite_count)=unpack("SSS",substr($file,0,6));

@headers=();
for($q=0;$q<$chunks_count;$q++){
push(@headers,[unpack("I",substr($file,6+$q*4,4)),unpack("S",substr($file,6+$chunks_count*4+$q*2,2))]);
}


open(dd,">textures.bin");
print dd substr($file,$headers[0]->[0],$tex_count*64*64);
close(dd);
#`cat textures.bin| perl pal8_to_rgb.pl | ffmpeg -f rawvideo -pix_fmt rgb24 -s 64x64 -i - -vf transpose -y test-tex-%4d.png`;



# export text per files

$wallnames=<<DAT;
01	Wall: Grey stone cube
02	Wall: Grey stone cube
03	Wall: Grey stone cube with flag
04	Wall: Grey stone cube with picture
05	Wall: Blue stone cube with cell door
06	Wall: Grey stone cube with bird and archway
07	Wall: Blue stone cube with cell door and skeleton
08	Wall: Blue stone cube
09	Wall: Blue stone cube
0a	Wall: Wood cube with picture of bird
0b	Wall: Wood cube with picture
0c	Wall: Wood cube
0d	Eleva: Elevator door (no red door handle) (ie. from prvs level)
0e	Wall: Steel cube (N/S="Verbotem", E/W="Achtung")
0f	Wall: Steel cube
10	Exit: Landscape view (N/S=sky & green land, E/W=dark & stars?)
11	Wall: Red brick cube
12	Wall: Red brick cube with green wreath
13	Wall: Purple and green cube
14	Wall: Red brick cube with tapestry of bird
15	Wall: Inside elevator (N/S=hand rail,  E/W=controls in down position)
16	Wall: Inside elevator (N/S=blank wall, E/W=controls in up position)
17	Wall: Wood cube with green branches over a cross
18	Wall: (v1.1+) Grey stone cube with green moss/slime
19	Wall: Pink and green cube
1a	Wall: (v1.1+) Grey stone cube with green moss/slime
1b	Wall: Grey stone cube
1c	Wall: Grey stone cube (N/S="Verbotem", E/W="Achtung")
1d	Wall: (Eps.2+) Brown cave
1e	Wall: (Eps.2+) Brown cave with blood
1f	Wall: (Eps.2+) Brown cave with blood
20	Wall: (Eps.2+) Brown cave with blood
21	Wall: (Eps.2+) Stained glass window of Hitler
22	Wall: (Eps.2+) Blue brick wall with skulls
23	Wall: (Eps.2+) Grey brick wall
24	Wall: (Eps.2+) Blue brick wall with swastikas
25	Wall: (Eps.2+) Grey brick wall with hole
26	Wall: (Eps.2+) Red/grey/brown wall
27	Wall: (Eps.2+) Grey brick wall with crack
28	Wall: (Eps.2+) Blue brick wall
29	Wall: (Eps.2+) Blue stone wall with verboten sign
2a	Wall: (Eps.2+) Brown tiles
2b	Wall: (Eps.2+) Grey brick wall with map
2c	Wall: (Eps.2+) Orange stone wall
2d	Wall: (Eps.2+) Orange stone wall
2e	Wall: (Eps.2+) Brown tiles
2f	Wall: (Eps.2+) Brown tiles with banner
30	Wall: (Eps.2+) Orange panel on wood wall
31	Wall: (Eps.2+) Grey brick wall with Hitler
40	Wall: Grey stone cube
41	Wall: Grey stone cube
42	Wall: Grey stone cube
43	Wall: Grey stone cube with flag
44	Wall: Grey stone cube with picture
45	Wall: Blue stone cube with cell door
46	Wall: Grey stone cube with bird and archway
47	Wall: Blue stone cube with cell door and skeleton
48	Wall: Blue stone cube
49	Wall: Blue stone cube
4a	Wall: Wood cube with picture of bird
4b	Wall: Wood cube with picture
4c	Wall: Wood cube
4d	Eleva: Elevator door (no red door handle)
4e	Wall: Steel cube (N/S="Verbotem", E/W="Achtung")
4f	Wall: Steel cube
50	Exit: Exit (N/S=sky & green land, E/W=dark & stars?)
51	Wall: Red brick cube
52	Wall: Red brick cube with green wreath
53	Wall: Pink and green cube
54	Wall: Red brick cube with tapestry of bird
55	Wall: Inside elevator (N/S=hand rail,  E/W=controls in down position)
56	Wall: Inside elevator (N/S=blank wall, E/W=controls in up position)
57	Wall: Wood cube with green branches over a cross
59	Wall: Pink and green cube
5a	VDoor: Steel door (east/west doorway) (vertical on map)
5b	HDoor: Steel door (north/south doorway) (horizontal on map)
5c	Lock: Locked version of 5a (need gold key to open)
5d	Lock: Locked version of 5b (need gold key to open)
5e	Lock: Locked version of 5a (need silver key to open)
5f	Lock: Locked version of 5b (need silver key to open)
60	Lock: Locked version of 5a (can't open)
61	Lock: Locked version of 5b (can't open)
62	Lock: Locked version of 5a (can't open)
63	Lock: Locked version of 5b (can't open)
64	Eleva: Elevator door with a grey stone cube on north and south side
65	Eleva: Elevator door with a grey stone cube on east  and west  side
6b	Floor: Floor
6c	Floor: Floor
6d	Floor: Floor
6e	Floor: Floor
6f	Floor: Floor
70	Floor: Floor
71	Floor: Floor
72	Floor: Floor
74	Floor: Floor
75	Floor: Floor
76	Floor: Floor
77	Floor: Floor
78	Floor: Floor
79	Floor: Floor
7a	Floor: Floor
7b	Floor: Floor
7c	Floor: Floor
7d	Floor: Floor
7e	Floor: Floor
7f	Floor: Floor
80	Floor: Floor
81	Floor: Floor
82	Floor: Floor
83	Floor: Floor
84	Floor: Floor
85	Floor: Floor
86	Floor: Floor
87	Floor: Floor
88	Floor: Floor
89	Floor: Floor
8a	Floor: Floor
8b	Floor: Floor
8c	Floor: Floor
8d	Floor: Floor
8e	Floor: Floor
8f	Floor: Floor
DAT

while($wallnames=~/^([\da-f]+)\s+(.+)$/mgi){
$names[hex($1)]=$1."-".$2;
}

$tex=GD::Image->new(64,64,1);
$tex->alphaBlending(0);
$tex->saveAlpha(0);

for($t=0;$t<$tex_count;$t++){
($tex_offset,$tex_len)=@{$headers[$t]};
print STDERR "Exporting texture $t: ($tex_offset,$tex_len)\n";
if($tex_len!=64*64){die "Wrong texture size!";}

for($q=0;$q<64;$q++){
for($w=0;$w<64;$w++){
$tex->setPixel($q,$w,$palette[ord(substr($file,$tex_offset++,1))]);
}
}

$tex_filename="texture-$t-".$names[int($t/2)+1];
$tex_filename=~s/[^a-z\d\-]+/_/gsi;
$tex_filename.=".png";

$tex_filename="walls-".(int($t/2)+1).($t%2?"-dark":"").".png";

$ax=($t%16)*64;
$ay=int($t/16)*64;

if($t>=98){
$tex_filename="doors-".($t-98).".png";
}

open(dd,">".$tex_filename);
print dd $tex->png(9);
close(dd);

$atlas->copy($tex,$ax,$ay,0,0,64,64);

if($ax==64 && $ay==0){
$ceiling=GD::Image->new(64,64,1);
$ceiling->copy($tex,0,0,0,0,64,64);
}

}


# export sprites

$spr=GD::Image->new(64,64,1);



print STDERR "sprites $tex_count .. $tex_sprite_count\n";
for($q=$tex_count;$q<$tex_sprite_count;$q++){
#for($q=$tex_count;$q<=155;$q++){

$sprite=substr($file,$headers[$q]->[0],$headers[$q]->[1]);

($left,$right,$pix_pool_max)=unpack("SSS",substr($sprite,0,6));
$posts=$right-$left+1;
$offsets=substr($sprite,4,$posts*2);
$pix_pool=4+$posts*2;
#print STDERR "($left,$right)\n";

$spr->alphaBlending(0);
$spr->saveAlpha(1);
$spr->filledRectangle(0,0,63,63,0x7f000000);

for($p=0;$p<$posts;$p++){
$post_offset=unpack("S",substr($offsets,$p*2,2));
while(1){
($end,$null,$start)=unpack("SSS",substr($sprite,$post_offset,6));
$post_offset+=6;
if($end==0){last;}
$end/=2;
$start/=2;
for($w=$start;$w<$end;$w++){
$spr->setPixel($left+$p,$w,$palette[ord(substr($sprite,$pix_pool++,1))]);
}

}

}

$spr_filename="test-sprite-".($q-$tex_count+1).".png";
$spr_filename="spr-".($q-$tex_count+1-3+0x17).".png";

$aid=$q-$tex_count;
$ax=($aid%16)*64;
$ay=int($aid/16+7)*64;

open(dd,">".$spr_filename);
print dd $spr->png(9);
close(dd);

$atlas->copy($spr,$ax,$ay,0,0,64,64);

}



open(dd,">atlas.png");
print dd $atlas->png(9);
close(dd);



# create numbers for ceiling and floor
$tilesize=32;

$atlas=GD::Image->new(64*$tilesize,64*$tilesize,1);
$atlas->alphaBlending(0);
$atlas->saveAlpha(0);

$atlas->filledRectangle(0,0,64*$tilesize,64*$tilesize,0x707070);

for($w=0;$w<64;$w++){
for($q=0;$q<64;$q++){

$ox=$tilesize*$q;
$oy=$tilesize*$w;

$atlas->copyResampled($ceiling,$ox,$oy,0,0,$tilesize,$tilesize,64,64);
$atlas->rectangle($ox,$oy,64*$tilesize,64*$tilesize,0x202020);

$ox=$tilesize*$q+2;
$oy=$tilesize*$w+9;

$xor=($q^$w)&1;

$oy+=$xor?-4:4;

#    gdSmallFont
#    gdLargeFont
#    gdMediumBoldFont
#    gdTinyFont
#    gdGiantFont


$atlas->string(gdSmallFont,$ox,$oy,"${q}x${w}",0xFFFFFF);



}
}


open(dd,">atlas-numbers.png");
print dd $atlas->png(9);
close(dd);


