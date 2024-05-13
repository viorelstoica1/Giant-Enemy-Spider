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
module roata_zimtata(diametru=25, dinti=40, unghi_dinti=30, grosime=3, grosime_gaura=10){
    $fn=dinti;
    diametru_sus=diametru-tan(90-unghi_dinti)*grosime*2;
    unghi = 360/dinti;
    latura_dinte_jos=sin(360/2/dinti)*diametru;
    latura_dinte_sus=sin(360/2/dinti)*diametru_sus;
    difference(){
        cylinder(grosime, diametru/2, diametru_sus/2);
        translate([0,0,-0.01]) cube([grosime_gaura, grosime_gaura, grosime*3+0.02], center = true);
    }
    for (i=[0:unghi:360]){
        hull(){
            translate([cos(i)*diametru/2,sin(i)*diametru/2,0])rotate([90-unghi_dinti,0,-90+i-unghi/2]) 
            linear_extrude(height = 0.01) triangle(c=latura_dinte_jos, b=latura_dinte_jos, a=latura_dinte_jos);
            translate([cos(i)*diametru_sus/2,sin(i)*diametru_sus/2,grosime-0.01])rotate([90-unghi_dinti,0,-90+i-unghi/2]) 
            linear_extrude(height = 0.01) triangle(c=latura_dinte_sus, b=latura_dinte_sus, a=latura_dinte_sus);
        }
    }
}
module roata_anglata(diametru=25, diametru_centru=20, dinti=40, inaltime_dinti=2, grosime=3, centru = 10, freewheel = false){
    $fn = dinti;
    unghi = 360/dinti;
    latura = sqrt(2*((diametru/2)^2) - cos(unghi)*diametru^2/2);
    latura_mica = sqrt(2*((diametru_centru/2)^2) - cos(unghi)*diametru_centru^2/2);
    latura_diagonala = sqrt(((diametru-diametru_centru)/2)^2 + grosime^2);
    unghi_tepi = 90 - asin(grosime/latura_diagonala);
    difference(){
        union(){
            cylinder(grosime, diametru/2, diametru_centru/2);
            for (i=[0:unghi:360]){
                hull(){
                    translate([cos(i)*diametru/2,sin(i)*diametru/2,0])rotate([unghi_tepi,0,-90+i-unghi/2]) 
                    linear_extrude(height = 0.01) triangle(c=latura, b=inaltime_dinti, a=inaltime_dinti);
                    translate([cos(i)*diametru_centru/2,sin(i)*diametru_centru/2,grosime-0.01])rotate([unghi_tepi,0,-90+i-unghi/2]) 
                    linear_extrude(height = 0.01) triangle(c=latura_mica, b=inaltime_dinti, a=inaltime_dinti);
                }
                //$fn=3;
                //translate([cos(i+unghi/2)*diametru/2,sin(i+unghi/2)*diametru/2,0]) rotate([0/*unghi_tepi*/,0,180+i-unghi/2]) rotate([0,0,-25]) cylinder(latura_diagonala, latura/2, latura/2);
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
module roata_transmisie(diametru=25, diametru_tub=10, gauri=2, grosime=5, diametru_gauri = 4, diametru_cerc_gauri = 15,lungime_tub=5, latime_capat = 5){
    difference(){
        cylinder(grosime, diametru/2, diametru/2);
        if(gauri>0 && diametru_gauri > 0 && diametru_cerc_gauri > 0){
            $fn = 30;
            for (j=[0:360/gauri:360]){
                translate([cos(j)*diametru_cerc_gauri/2,sin(j)*diametru_cerc_gauri/2,-0.01]) cylinder(grosime+0.02, diametru_gauri/2, diametru_gauri/2);
            }  
        }
    }
    $fn = 60;
    translate([0,0,grosime])cylinder(lungime_tub, diametru_tub/2, diametru_tub/2);
    translate([-latime_capat/2,-latime_capat/2,grosime+lungime_tub]) cube([latime_capat,latime_capat,latime_capat]);
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
module structura_dreptunghi(lungime=75, diametru=15, diametru_gaura=10, grosime = 7.5, inaltime=40, diametru_surub=2){
    $fn=60;
    color("green")
    difference(){
        union(){
            difference(){
                translate([diametru/2-grosime/2,0,-grosime/2])cube([lungime-diametru+grosime, grosime, inaltime-diametru/2+grosime/2]);
                translate([diametru/2+grosime/2,-0.01,grosime/2]) cube([lungime-diametru-grosime,grosime+0.02,inaltime-diametru/2-grosime*3/2]);
            }
            translate([diametru/2,grosime,]) rotate([90,0,0])cylinder(grosime,diametru/2, diametru/2);
            translate([lungime-diametru/2,grosime,0]) rotate([90,0,0])cylinder(grosime,diametru/2, diametru/2);
        }
        translate([diametru/2,grosime+0.01,inaltime-diametru/2-grosime/2]) rotate([90,0,0])cylinder(grosime+0.02,diametru_surub/2,diametru_surub/2);
        translate([lungime-diametru/2,grosime+0.01,inaltime-diametru/2-grosime/2]) rotate([90,0,0])cylinder(grosime+0.02,diametru_surub/2,diametru_surub/2);
        translate([diametru/2,grosime+0.01,]) rotate([90,0,0])cylinder(grosime+0.02,diametru_gaura/2, diametru_gaura/2);
        translate([lungime-diametru/2,grosime+0.01,0]) rotate([90,0,0])cylinder(grosime+0.02,diametru_gaura/2, diametru_gaura/2);
    }
}
module structura_triunghi(lungime=50, diametru=15, diametru_gaura=10, grosime = 7.5, inaltime=40, diametru_surub=2){
    //TODO aici
    $fn=60;
    unghi = atan((inaltime-diametru/2-grosime/2)/(lungime/2-diametru/2));
    lungime_ipotenuza = sqrt((inaltime-diametru/2-grosime/2)^2 + (lungime/2-diametru/2)^2);
    color("green")
    difference(){
        union(){
            translate([lungime/2-grosime/2,grosime,inaltime-diametru/2-grosime]) rotate([90,0,0])cube([grosime,grosime,grosime]);
            translate([lungime-diametru/2,0,0])rotate([0,180+unghi,0])translate([0,0,-grosime/2])cube([lungime_ipotenuza, grosime, grosime]);
            translate([diametru/2,0,0])rotate([0,-unghi,0])translate([0,0,-grosime/2])cube([lungime_ipotenuza, grosime, grosime]);
            translate([diametru/2-grosime/2,0,-grosime/2])cube([lungime-diametru+grosime, grosime, grosime]);
            translate([diametru/2,grosime,0]) rotate([90,0,0])cylinder(grosime,diametru/2, diametru/2);
            translate([lungime-diametru/2,grosime,0]) rotate([90,0,0])cylinder(grosime,diametru/2, diametru/2);
        }
        translate([lungime/2,grosime+0.01,inaltime-diametru/2-grosime/2]) rotate([90,0,0])cylinder(grosime+0.02,diametru_surub/2,diametru_surub/2);
        translate([diametru/2,grosime+0.01,]) rotate([90,0,0])cylinder(grosime+0.02,diametru_gaura/2, diametru_gaura/2);
        translate([lungime-diametru/2,grosime+0.01,0]) rotate([90,0,0])cylinder(grosime+0.02,diametru_gaura/2, diametru_gaura/2);
    }
}
module structura_motor(latime=90, grosime=8, inaltime=39, diametru_surub_motor=2, latime_suporti=60, inaltime_suporti=65, offset_vertical_suporti=5){
    color("green")translate([0,-latime/2,-inaltime/2])difference(){
        union(){
            cube([grosime,latime, inaltime]);
            translate([0,(latime-latime_suporti-grosime)/2,(inaltime-inaltime_suporti)/2+offset_vertical_suporti])cube([grosime,grosime,inaltime_suporti]);
            translate([0,(latime+latime_suporti-grosime)/2,(inaltime-inaltime_suporti)/2+offset_vertical_suporti])cube([grosime,grosime,inaltime_suporti]);
        }
        translate([-0.01, grosime, grosime])cube([grosime+0.02, latime-2*grosime, inaltime-2*grosime]);
        $fn=30;
        /*gauri montare structura*/
        translate([-0.01,(latime-latime_suporti)/2,(inaltime+inaltime_suporti-grosime)/2+offset_vertical_suporti])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        translate([-0.01,(latime-latime_suporti)/2,(inaltime-inaltime_suporti+grosime)/2+offset_vertical_suporti])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        translate([-0.01,(latime+latime_suporti)/2,(inaltime+inaltime_suporti-grosime)/2+offset_vertical_suporti])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        translate([-0.01,(latime+latime_suporti)/2,(inaltime-inaltime_suporti+grosime)/2+offset_vertical_suporti])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        /*gauri montare motoare*/
        translate([-0.01,latime-grosime-7,inaltime-grosime+2])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        translate([-0.01,latime-grosime-7,grosime-2])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        translate([-0.01,grosime+7,inaltime-grosime+2])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        translate([-0.01,grosime+7,grosime-2])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
    }
}
module schelet_montare(lungime=180, latime=112.5, lungime_laterale=107.5, latime_orizontale=67.5, grosime=7.5, offset_lungime=56.25){
    color("lime"){
    translate([-lungime/2+offset_lungime,-latime/2,0])difference(){
        cube([lungime_laterale,latime,grosime]);
        translate([grosime,grosime,-0.01])cube([lungime_laterale-grosime*2,latime-grosime*2, grosime+0.02]);
    }
    translate([-lungime/2,-latime_orizontale/2,0])difference(){
        cube([lungime,latime_orizontale,grosime]);
        translate([grosime,grosime,-0.01])cube([lungime-grosime*2,latime_orizontale-grosime*2, grosime+0.02]);
    }
    /*cod grav*/
    lungime_spate = sqrt((latime/2-latime_orizontale/2)^2+(offset_lungime)^2);
    unghi_spate = atan((latime/2-latime_orizontale/2)/(offset_lungime));
    translate([-lungime/2+offset_lungime,latime/2,0])rotate([0,0,180+unghi_spate])cube([lungime_spate,grosime,grosime]);
    translate([-lungime/2,-latime_orizontale/2,0])rotate([0,0,-unghi_spate])cube([lungime_spate,grosime,grosime]);

    lungime_fata = sqrt((latime/2-latime_orizontale/2)^2+(lungime-lungime_laterale-offset_lungime)^2);
    unghi_fata = atan((lungime-lungime_laterale-offset_lungime)/(latime/2-latime_orizontale/2));
    translate([lungime_laterale+offset_lungime-lungime/2,-latime/2,0])rotate([0,0,90-unghi_fata])cube([lungime_fata,grosime,grosime]);
    translate([lungime/2,latime_orizontale/2,0])rotate([0,0,unghi_fata+90])cube([lungime_fata,grosime,grosime]);
    }
}
module ansamblu(){
    for(j=[0:3]){
        translate([-140+j*50,25,0]) rotate([0,$t * 360,0]) rotate([90,0,0])roata_anglata(40,25,30,4, grosime = 9, centru = 5, freewheel = false);
        translate([-165+j*50,0,0])rotate([$t * 360,0,0]) rotate([0,90,0]) roata_anglata(40,25,30, 4, grosime = 9, centru = 10);
        translate([-140+j*50,40,0]) rotate([0,$t * 360,0]) rotate([90,0,0]) roata_transmisie(40, 10, 2, 5, 5, 25, 10,5);
    }
    for(j=[0:2]){
        #translate([-160+j*50,0,0]) rotate([$t * 360,0,0]) rotate([0,90,0]) transmisie(lungime = 40, diametru = 15, lungime_conector = 4.5,grosime_conector = 10,terminator = false);
    }
    translate([cos($t*360)*10,10,-sin($t*360)*10]) translate([-40,35,10])picior(40, 90);
    translate([-cos($t*360)*10,8,sin($t*360)*10]) translate([-90,35,-10])picior(40, 70);
    translate([cos($t*360)*10,8,-sin($t*360)*10]) translate([-140,35,10])rotate([0,0,45]) picior(40, 90); 
    translate([-cos($t*360)*10,10,sin($t*360)*10]) translate([10,35,-10]) rotate([0,0,-45])picior(40, 70);

    #rotate([$t * 360,0,0]) rotate([0,0,180]) translate([-9,0,0]) rotate([0,90,0]) transmisie(lungime = 10, diametru = 15, lungime_conector = 4.5,grosime_conector = 10,terminator = true);
    /*Structura de rezistenta*/
    mirror([0,0,1]){
        for(j=[0:1:2]){
            translate([-147.5+j*50,26.25,0])structura_triunghi(lungime=65, diametru=15, inaltime=40, grosime=7.5);
        }
    }
    for(j=[0:1:2]){
        translate([-147.5+j*50,26.25,0])structura_triunghi(lungime=65, diametru=15, inaltime=40, grosime=7.5);
    }
    /*Adaptoarele pentru picioare*/
    translate([cos($t*360 + 6)*10,11,-sin($t*360)*10]) translate([-35,30,35]) rotate([0,-90,0]) adaptor_picior(10, 2, 110, 2, 40);
    translate([-cos($t*360 + 6)*10,11,sin($t*360)*10]) translate([-95,30,-35]) rotate([0,90,0])adaptor_picior(10, 2, 110, 2, 40);
}
if (0){
    translate([0,30,0]) ansamblu();
    mirror([0,1,0]){
        translate([0,30,0]) ansamblu();    
    }
    mirror([0,0,1]) translate([12.5,-37.5,0])rotate([0,0,90])structura_dreptunghi();
    translate([12.5,-37.5,0])rotate([0,0,90])structura_dreptunghi();
    //translate([0,-45,30])rotate([0,0,90])prototype_board();
    translate([-201.5,30,-16]) rotate([90,0,90]) import("servo.stl");
    translate([-201.5,-30,-16]) rotate([90,0,90]) import("servo.stl");
    translate([-183,0,-5]) structura_motor();

    mirror([0,0,1])translate([-85,0,25]) schelet_montare();
    translate([-85,0,25]) schelet_montare();
}
//translate([30,0,0])roata_anglata();
rotate([0,0,$t*360])roata_zimtata();
translate([13.5,0,14])rotate([$t*360+4.5,0,0]) rotate([0,-90,0]) roata_zimtata(unghi_dinti=60, grosime=5.3);
//translate([50,0,0])structura_triunghi();
//translate([15,0,-5]) structura_motor();
