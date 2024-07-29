use GD;
use Data::Dumper;

=pod
+Скачать первые 5 дисков classic fond

+Сконвертить палитру
+Сконвертить текстуры стен
+Сконвертить спрайты
+Сконвертить уровни
+Сделать atlas
+Загрузить в макс

+временно распаковать уровень через экстрактор
+нарисовать свою карту в стиле пидараса
+нарисовать спрайты коллектаблс и скелетов
+Затереть то, что не рядом с "полом"
-Расставить солдатиков
?экстрактить карту самому
+в максе нарисовать 1 кубик с текстурой, без пола и крышки
+создать двери
+в максе нарисовать спрайт-плоскость с viewAt
+в максе создать референсные кубики и плоскости
+Выстроить кубики по карте
+часть кубиков (двери) развернуть по градусам
=cut



sub loadPng{
my $filename=shift;
my $pic=undef;
if(-s($filename)){
$pic=GD::Image->newFromPng($filename,1);
if($pic){
return($pic);
}
}
return(undef);
}

@walls=map{loadPng("walls-$_.png",1)}(0..49);
@doors=map{loadPng("doors-$_.png",1)}(0..7);
@spr=map{loadPng("spr-$_.png",1)}(0..70);


$tilesize=16;
$mapsize=64;
$canvsize=$tilesize*$mapsize;

open(max,">level1-max.txt");

# mask

open(dd,"map-plane0.txt");
read(dd,$plane0,-s(dd));


$floor="0" x ($mapsize*$mapsize);
for($w=0;$w<$mapsize;$w++){
for($q=0;$q<$mapsize;$q++){
$wall_id=unpack("S",substr($plane0,($q+$w*64)*2,2));
if($wall_id>=0x66){ #is floor
substr($floor,$q+$w*64,1)="1";
}
}
}

$mask="0" x ($mapsize*$mapsize);
for($w=0;$w<$mapsize;$w++){
for($q=0;$q<$mapsize;$q++){
$is_ok=0;
for($s=-1;$s<=1;$s++){
for($a=-1;$a<=1;$a++){
$ox=$q+$a;
$oy=$w+$s;
if($ox<0 || $oy<0 || $ox>=$mapsize || $oy>=$mapsize){
next;
}
if(substr($floor,$ox+$oy*$mapsize,1) eq "1"){
$is_ok++;
last;
}
}
}

if($is_ok){
substr($mask,$q+$w*$mapsize,1)="1";
}

}
}

# walls

$wood=unpack("S",substr($plane0,(9+51*64)*2,2));
#die sprintf("sample: %d (0x%02x)\n",$wood,$wood);
#die Dumper($walls[0x15]);

$canv=GD::Image->new($canvsize,$canvsize,1);

for($w=0;$w<$mapsize;$w++){
for($q=0;$q<$mapsize;$q++){

if(substr($mask,$q+$w*$mapsize,1) ne "1"){next;}

$ox=$q*$tilesize;
$oy=$w*$tilesize;
$wall_id=unpack("S",substr($plane0,($q+$w*64)*2,2));
#printf("%02x ",$wall_id);

# episode 1 don't have 0x1d..0x31
if(($wall_id>=0x1d && $wall_id<=0x31) || ($wall_id>=0x4f && $wall_id<=0x59)){
#$wall_id=0x80;
}

if($wall_id>=0x66){ #is floor
$canv->filledRectangle($ox,$oy,$ox+$tilesize-1,$oy+$tilesize-1,0x707070);
next;
}

if($wall_id==0x15){ #is debug
$canv->filledRectangle($ox,$oy,$ox+$tilesize-1,$oy+$tilesize-1,0xFF0000);
}


$maxout="box $q $w $wall_id\n";

$img=undef;

if($wall_id==0x5a || $wall_id==0x5b){
$rot=$wall_id-0x5a;
$img=$doors[0];
$maxout="doors $q $w 0 $rot\n";
}

if($wall_id>=0x5c && $wall_id<=0x63){
$rot=($wall_id-0x5c)%2;
$img=$doors[6];
$maxout="doors $q $w 6 $rot\n";
}

if($wall_id==0x64 || $wall_id==0x65){
$rot=$wall_id-0x64;
$img=$doors[4];
$maxout="doors $q $w 4 $rot\n";
}

if(!$img){
#$wall_id&=0x3F;
$img=$walls[$wall_id];
}

if($img){
$canv->copyResampled($img,$ox,$oy,0,0,$tilesize,$tilesize,$img->getBounds());
$canv->rectangle($ox,$oy,$ox+$tilesize-1,$oy+$tilesize-1,0x55000000);}
print max $maxout;
}
print "\n";
}


# sprites

open(dd,"map-plane1.txt");
read(dd,$plane1,-s(dd));

for($w=0;$w<$mapsize;$w++){
for($q=0;$q<$mapsize;$q++){

$ox=$q*$tilesize;
$oy=$w*$tilesize;
$spr_id=unpack("S",substr($plane1,($q+$w*64)*2,2));
printf("%02x ",$spr_id);

# episode 1 don't have 0x98..a0, bc..c4, d8..ff
if(0){
#$wall_id=0x80;
}

$img=undef;

if(!$img){
$img=$spr[$spr_id];
}

if($img){
$canv->copyResampled($img,$ox,$oy,0,0,$tilesize,$tilesize,$img->getBounds());
print max "spr $q $w $spr_id\n";
substr($floor,$q+$w*$mapsize,1)="0";
}

}
print "\n";
}

# floors
@floors=();
for($w=0;$w<$mapsize;$w++){
for($q=0;$q<$mapsize;$q++){

$ox=$q*$tilesize;
$oy=$w*$tilesize;
$fl_id=substr($floor,$q+$w*$mapsize,1) eq "1"?1:0;
if($fl_id){
push(@floors,[$q,$w]);
}
}
}

%flr=();
map{$flr{rand()}=$_}@floors;

print max map{"floor $_->[0] $_->[1]\n"}sort{rand()<.5?-1:1}values %flr;

open(dd,">map-plane0-color.png");
print dd $canv->png(9);
close(dd);




