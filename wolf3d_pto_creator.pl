
$image_prefix="wolf3d/wolf";

$cube_size=1024;
$count=20;

open(bat,">pano_build.bat");


for($p=0;$p<$count;$p++){

$pano_id=$p;
$out_name="wolf3dpano-$pano_id";
$out_pto=$out_name.".pto";
open(pto,">".$out_pto);

print pto <<CODE;
p w1024 h512 f2 v360 n"PNG" R0 T"UINT8"
m i6
CODE

for($s=0;$s<6;$s++){

$rx=0;
$ry=0;

if($s<3){
$rx=$s*90-90;
}else{
$rx=180;
$ry=180-($s-2)*90;
}

$pic_name=sprintf("%s%04d.jpg",$image_prefix,$p*6+$s+1);
print pto <<CODE;
i f0 w$cube_size h$cube_size r0.0 p$ry.0 y$rx.0 v90.0 n"$pic_name"
CODE

}
close(pto);

print bat <<CODE;
"T:\\Program Files\\Hugin\\bin\\nona.exe" -o $out_name $out_pto
CODE
}

close(bat);


