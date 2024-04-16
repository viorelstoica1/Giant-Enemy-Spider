use <triangle.scad>

module prototype_board(latime=90, lungime=150, grosime=3){
    cube([latime, lungime, grosime]);
}
module roata(dinti=40, inaltime_dinti=2, diametru=25, gauri=6, grosime=3, diametru_gauri = 0,
 diametru_cerc_gauri=0, diametru_centru = 0){
    $fn = dinti;
    unghi = 360/dinti;
    unghi_gauri = 360/gauri;
    latura = sqrt(2*((diametru/2)^2) - diametru^2/2*cos(unghi));
    difference(){
        union(){
            cylinder(h = grosime, d = diametru, center = false);
            for (i=[0:unghi:360]){
                translate([cos(i)*diametru/2,sin(i)*diametru/2,0])rotate([0,0,-90+i-unghi/2]) linear_extrude(grosime, center=false) triangle(c=latura, b=inaltime_dinti, a=inaltime_dinti);
            }
        }
        if(gauri>0 && diametru_gauri > 0 && diametru_cerc_gauri > 0){
            for (j=[0:unghi_gauri:360]){
                translate([cos(j)*diametru_cerc_gauri/2,sin(j)*diametru_cerc_gauri/2,-0.01]) cylinder(grosime+0.02, diametru_gauri/2, diametru_gauri/2);
            }  
        }
        if(diametru_centru > 0){
            translate([0,0,0]) cylinder(grosime*2+0.02, diametru_centru/2, diametru_centru/2, center =  true);
        }
    }
}

module adaptor_picior(latime = 8, grosime = 4, inaltime = 30, diametru_gauri = 2, inaltime_picioare = 15){
    $fn = 30;
    color("red")difference(){
        union(){
            cube([latime, grosime, inaltime]); 
            translate([-inaltime_picioare,0,0]) cube([inaltime_picioare, grosime, latime]);
            translate([-inaltime_picioare,0,inaltime - latime]) cube([inaltime_picioare, grosime, latime]);
        }

        translate([-inaltime_picioare +latime/2,grosime+0.01,latime/2]) rotate([90,0,0]) cylinder(grosime+0.02,diametru_gauri/2, diametru_gauri/2);
        translate([-inaltime_picioare +latime/2,grosime+0.01,-latime/2 +inaltime]) rotate([90,0,0]) cylinder(grosime+0.02,diametru_gauri/2, diametru_gauri/2);
    }

    color("yellow");
}
//TODO: gauri montare sub roata anglata !!!!!!!!!!!
module roata_anglata(diametru=25, diametru_centru=20, dinti=40, inaltime_dinti=2, grosime=3, centru = 10, freewheel = false){
    $fn = dinti;
    unghi = 360/dinti;
    latura = sqrt(2*((diametru/2)^2) - diametru^2/2*cos(unghi));
    latura_mica = sqrt(2*((diametru_centru/2)^2) - diametru_centru^2/2*cos(unghi));
    latura_diagonala = sqrt(((diametru-diametru_centru)/2)^2 + grosime^2);
    //unghi_tepi = 90 - asin(grosime/latura_diagonala);
    difference(){
        union(){
            cylinder(grosime, diametru/2, diametru_centru/2);
            for (i=[0:unghi:360]){
                hull(){
                    translate([cos(i)*diametru/2,sin(i)*diametru/2,0])rotate([0/*unghi_tepi*/,0,-90+i-unghi/2]) 
                    linear_extrude(height = 0.01) triangle(c=latura, b=inaltime_dinti, a=inaltime_dinti);
                    translate([cos(i)*diametru_centru/2,sin(i)*diametru_centru/2,grosime])rotate([0/*unghi_tepi*/,0,-90+i-unghi/2]) 
                    linear_extrude(height = 0.01) triangle(c=latura_mica, b=inaltime_dinti, a=inaltime_dinti);
                }
            }
        }
        if(freewheel == true){
            translate([0,0,-0.01]) cylinder(grosime*3+0.02, centru/2, centru/2, center=true);
        }
        else{
            translate([0,0,-0.01]) cube([centru, centru, grosime*3+0.02], center = true);
        }
    }


}

module picior(lungime_sus = 70,lungime_jos = 140, diametru = 10){
    $fn = 30;
    translate([0,0,0]) rotate([-90,0,0]) cylinder(lungime_sus, diametru/2, diametru/2);
    translate([0,lungime_sus + lungime_jos * cos(70), -lungime_jos * sin(70)]) rotate([20,0,0]) cylinder(lungime_jos, diametru/2, diametru/2);
}

module transmisie(lungime=80, diametru=10, grosime_conector = 6, lungime_conector = 5, terminator = false){
    $fn = 30;
    translate([-grosime_conector/2,-grosime_conector/2,0]){
    if(terminator){
        translate([grosime_conector/2,grosime_conector/2,0])cylinder(lungime_conector, grosime_conector/2,grosime_conector/2, center = false);
    }
    else{
        cube([grosime_conector,grosime_conector, lungime_conector]);
    }
    translate([0,0,lungime_conector+lungime])cube([grosime_conector,grosime_conector, lungime_conector]);
    translate([grosime_conector/2,grosime_conector/2,lungime_conector]) cylinder(lungime, diametru/2, diametru/2, center = false);
    }

}

module prindere_transmisie(lungime = 80, grosime = 5, diametru=20, diametru_interior = 15, lungime_interioara = 30){
    translate([-lungime/2,0,0])difference(){
        union(){
            cube([lungime, grosime, grosime]);
            translate([lungime/2-lungime_interioara/2-diametru/2,grosime,grosime/2])rotate([90,0,0])cylinder(grosime, diametru/2, diametru/2);
            translate([lungime/2+lungime_interioara/2+diametru/2,grosime,grosime/2])rotate([90,0,0])cylinder(grosime, diametru/2, diametru/2);
        }
            translate([lungime/2-lungime_interioara/2-diametru/2,grosime+0.01,grosime/2])rotate([90,0,0])cylinder(grosime+0.02, diametru_interior/2, diametru_interior/2);
            translate([lungime/2+lungime_interioara/2+diametru/2,grosime+0.01,grosime/2])rotate([90,0,0])cylinder(grosime+0.02, diametru_interior/2, diametru_interior/2);
    }

}
module ansamblu(){
    translate([-140,25,0]) rotate([0,$t * 360,0]) rotate([90,0,0])roata_anglata(40,25,30,4, grosime = 9, centru = 5, freewheel = true);
    translate([-165,0,0])rotate([$t * 360,0,0]) rotate([0,90,0]) roata_anglata(40,25,30, 4, grosime = 9, centru = 10);
    translate([-cos($t*360 - 6)*10,0,sin($t*360)*10]) translate([10,35,-10]) rotate([0,0,-45])picior(70, 130);

    %translate([-160,0,0]) rotate([$t * 360,0,0]) rotate([0,90,0]) transmisie(lungime = 40, diametru = 15, lungime_conector = 4.5,grosime_conector = 10,terminator = false);
    translate([-115,0,0])rotate([$t * 360,0,0]) rotate([0,90,0]) roata_anglata(40,25,30, 4, grosime = 9, centru = 10);
    translate([-90,25,0]) rotate([0,$t * 360,0])rotate([90,0,0])roata_anglata(40,25,30,4, grosime = 9, centru = 5, freewheel = true);
    translate([cos($t*360)*10,0,-sin($t*360)*10]) translate([-40,35,10])picior(70, 150);

    %translate([-110,0,0]) rotate([$t * 360,0,0]) rotate([0,90,0]) transmisie(lungime = 40, diametru = 15, lungime_conector = 4.5,grosime_conector = 10,terminator = false);
    translate([-65,0,0])rotate([$t * 360,0,0]) rotate([0,90,0]) roata_anglata(40,25,30, 4, grosime = 9, centru = 10);
    translate([-40,25,0]) rotate([0,$t * 360,0]) rotate([90,0,0])roata_anglata(40,25,30,4, grosime = 9, centru = 5, freewheel = true);
    translate([-cos($t*360)*10,0,sin($t*360)*10]) translate([-90,35,-10])picior(70, 130);

    %translate([-60,0,0]) rotate([$t * 360,0,0]) rotate([0,90,0]) transmisie(lungime = 40, diametru = 15, lungime_conector = 4.5,grosime_conector = 10,terminator = false);
    translate([-15,0,0])rotate([$t * 360,0,0]) rotate([0,90,0]) roata_anglata(40,25,30, 4, grosime = 9, centru = 10);
    translate([10,25,0]) rotate([0,$t * 360,0]) rotate([90,0,0])roata_anglata(40,25,30,4, grosime = 9, centru = 5, freewheel = true);
    translate([cos($t*360)*10,0,-sin($t*360)*10]) translate([-140,35,10])rotate([0,0,45]) picior(70, 150); 
    
    %rotate([$t * 360,0,0]) rotate([0,0,180]) translate([-40,0,0]) rotate([0,90,0]) transmisie(lungime = 40, diametru = 15, lungime_conector = 4.5,grosime_conector = 10,terminator = true);
    
    translate([cos($t*360 + 6)*10,0,-sin($t*360)*10]) translate([-35,30,35]) rotate([0,-90,0]) adaptor_picior(10, 2, 110, 2, 40);
    translate([-cos($t*360 + 6)*10,0,sin($t*360)*10]) translate([-95,30,-35]) rotate([0,90,0])adaptor_picior(10, 2, 110, 2, 40);
}
if (1){
    translate([0,30,0]) ansamblu();
    mirror([0,1,0]){
        translate([0,30,0]) ansamblu();
    }
}
translate([40,0,-2.5])rotate([0,0,90])prindere_transmisie(75, 5, 20, 12, 40);
//translate([0,-45,30])rotate([0,0,90])prototype_board();
translate([-200,30,-16]) rotate([90,0,90]) import("servo.stl");
translate([-200,-30,-16]) rotate([90,0,90]) import("servo.stl");