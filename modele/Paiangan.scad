inaltime_core = 42.5;
lungime_core = 110;
latime_core = 67.5;
grosime_core = 4;

diametru_roata_zimtata = 30;
offset_roata_zimtata = 1.5;
spatiu_roata_zimtata = 0.3;
module motor_reductor(){
    translate([73.5,-34,12]) rotate([180,0,0]) import("motor.stl", 10);
    $fn=6;
    translate([6.5,27.5,5.25]) rotate([-90,0,0])cylinder(16,7,7);
}
module raspberry(){
    difference(){
        cube([65,30, 1.5]);
        translate([3.5, 3.5, -0.01])cylinder($fn = 30, 20, 1.5, 1.5);
        translate([65-3.5, 3.5, -0.01])cylinder($fn = 30, 20, 1.5, 1.5);
        translate([65-3.5, 30-3.5, -0.01])cylinder($fn = 30, 20, 1.5, 1.5);
        translate([3.5, 30-3.5, -0.01])cylinder($fn = 30, 20, 1.5, 1.5);
    }
}
module camera(){
    color("yellow"){
        difference(){
            cube([55,19,1]);
            translate([5,19-2,-0.01]) cylinder($fn=30, 5, 1, 1);
            translate([5,2,-0.01]) cylinder($fn=30, 5, 1, 1);
            translate([52,9.5,-0.01]) cylinder($fn=30, 5, 1, 1);
        }
    }
}
module adaptor_reductor(diametru = 40, grosime = 4, diametru_cerc_gauri = 32, diametru_gauri=2.5){
    difference(){
        cylinder(grosime, diametru/2, diametru/2, $fn = 60);
        translate([0,0,-0.01])cylinder(16,7,7, $fn = 6);
        for (j=[0:360/2:360]){
            translate([cos(j)*diametru_cerc_gauri/2,sin(j)*diametru_cerc_gauri/2,-0.01]) cylinder(grosime+0.02, diametru_gauri/2, diametru_gauri/2, $fn = 30);
        }  
    }
}
module prototype_board(latime=90, lungime=150, grosime=3){
    cube([latime, lungime, grosime]);
}
module adaptor_picior(latime = 8, grosime = 4, inaltime = 30, diametru_gauri = 3, inaltime_picioare = 15){
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
module roata_zimtata(diametru=diametru_roata_zimtata, dinti=40, unghi_dinti=47.5, grosime=9, grosime_gaura=7){
    $fn=dinti;
    diametru_sus=diametru-tan(90-unghi_dinti)*grosime*2;
    unghi = 360/dinti;
    latura_dinte_jos=sin(360/2/dinti)*diametru;
    latura_dinte_sus=sin(360/2/dinti)*diametru_sus;
    inaltime_dinte= sqrt(grosime^2 + ((diametru-diametru_sus)/2)^2);
    difference(){
        union(){
            cylinder(grosime, diametru/2, diametru_sus/2);
            for (i=[0:unghi:360]){
                translate([cos(i)*(diametru/2),sin(i)*(diametru/2),0])
                /*rotate([sin(i)*(90-unghi_dinti),-cos(i)*(90-unghi_dinti),0])*/ rotate([90-unghi_dinti,0,-90+i-unghi/2])
                polyhedron(points=[[0,0,0],[latura_dinte_jos,0,0],[latura_dinte_jos/2,latura_dinte_jos*sqrt(3)/2,0],
                [latura_dinte_jos/2-latura_dinte_sus/2,0,inaltime_dinte],[latura_dinte_jos/2+latura_dinte_sus/2,0,inaltime_dinte],[latura_dinte_jos/2,latura_dinte_sus*sqrt(3)/2,inaltime_dinte]], 
                faces=[[1,2,0],[3,1,0],[4,1,3],[4,2,1],[4,5,2],[5,0,2],[5,3,0],[5,4,3]]);
            }
        }
        translate([0,0,-0.01]) cube([grosime_gaura, grosime_gaura, grosime*3+0.02], center = true);
    }
}
module roata_transmisie(diametru=diametru_roata_zimtata, diametru_tub=9.6, gauri=1, grosime=grosime_core, diametru_gauri = 3, diametru_cerc_gauri = 20,lungime_tub=grosime_core+spatiu_roata_zimtata, latime_capat = 6.6, inaltime_capat = 9){
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
    translate([0,0,grosime])cylinder(spatiu_roata_zimtata, diametru_tub/2+2, diametru_tub/2+2);
    translate([-latime_capat/2,-latime_capat/2,grosime+lungime_tub]) cube([latime_capat,latime_capat,inaltime_capat]);
}
module picior(lungime_sus = 70,lungime_jos = 140, diametru = 10){
    $fn = 30;
    translate([0,0,0]) rotate([-90,0,0]) cylinder(lungime_sus, diametru/2, diametru/2);
    translate([0,lungime_sus + lungime_jos * cos(70), -lungime_jos * sin(70)]) rotate([20,0,0]) cylinder(lungime_jos, diametru/2, diametru/2);
}
module transmisie(lungime=lungime_core/3-9-spatiu_roata_zimtata, diametru=12, grosime_conector = 6.6, lungime_conector = 5, lungime_terminator = 5,terminator = false){
    $fn = 30;
    translate([-grosime_conector/2,-grosime_conector/2,0]){
    if(terminator){
        translate([grosime_conector/2,grosime_conector/2,lungime])cylinder(lungime_terminator, grosime_conector/2,grosime_conector/2, center = false);
    }
    else{
        translate([0,0,lungime])cube([grosime_conector,grosime_conector, lungime_terminator]);
    }
    //translate([0,0,lungime_terminator+lungime])cube([grosime_conector,grosime_conector, lungime_conector]);
    translate([grosime_conector/2,grosime_conector/2,0]) cylinder(lungime, diametru/2, diametru/2, center = false);
    }
}
module structura_dreptunghi(lungime=latime_core-offset_roata_zimtata*2-diametru_roata_zimtata+grosime_core-spatiu_roata_zimtata*2, diametru=14, diametru_gaura=7, grosime = grosime_core, inaltime=inaltime_core/2+grosime_core/2, diametru_surub=3){
    $fn=60;
    color("green")
    translate([-lungime/2,0,0])difference(){
        union(){
            difference(){
                cube([lungime, grosime, inaltime]);
                translate([grosime,-0.01,grosime]) cube([lungime-grosime*2,grosime+0.02,inaltime-grosime*2]);
            }
            translate([grosime/2,grosime,grosime/2]) rotate([90,0,0]) cylinder(grosime+spatiu_roata_zimtata,diametru/2, diametru/2);
            translate([lungime-grosime/2,grosime,grosime/2]) rotate([90,0,0]) cylinder(grosime+spatiu_roata_zimtata,diametru/2, diametru/2);
            //suport suruburi
            translate([grosime/2,grosime,inaltime-grosime/2]) rotate([90,0,0])cylinder(grosime,diametru_surub/2+1,diametru_surub/2+1);
            translate([lungime-grosime/2,grosime,inaltime-grosime/2]) rotate([90,0,0])cylinder(grosime,diametru_surub/2+1,diametru_surub/2+1);
        }
        translate([grosime/2,grosime+0.01,inaltime-grosime/2]) rotate([90,0,0])cylinder(grosime+0.02,diametru_surub/2,diametru_surub/2);
        translate([lungime-grosime/2,grosime+0.01,inaltime-grosime/2]) rotate([90,0,0])cylinder(grosime+0.02,diametru_surub/2,diametru_surub/2);
        translate([grosime/2,grosime+0.01,grosime/2]) rotate([90,0,0])cylinder(grosime+spatiu_roata_zimtata+0.02,diametru_gaura/2, diametru_gaura/2);
        translate([lungime-grosime/2,grosime+0.01,grosime/2]) rotate([90,0,0])cylinder(grosime+spatiu_roata_zimtata+0.02,diametru_gaura/2, diametru_gaura/2);
    }
}
module structura_triunghi(lungime=lungime_core/3, diametru=15, diametru_gaura=10, grosime = grosime_core, inaltime=inaltime_core/2, diametru_surub=3){
    //TODO aici
    $fn=60;
    unghi = atan((inaltime-grosime/2)/(lungime/2));
    lungime_ipotenuza = sqrt((inaltime/2-grosime/2)^2 + (lungime/2+diametru/2)^2);
    color("green")
    difference(){
        union(){
            translate([lungime/2,grosime,inaltime-grosime/2]) rotate([90,0,0])cylinder(grosime,diametru_surub/2+1,diametru_surub/2+1);
            translate([lungime,0,0])rotate([0,180+unghi,0])translate([0,0,-grosime/2])cube([lungime_ipotenuza, grosime, grosime]);
            translate([0,0,0])rotate([0,-unghi,0])translate([0,0,-grosime/2])cube([lungime_ipotenuza, grosime, grosime]);
            translate([diametru/2-grosime/2,0,-grosime/2])cube([lungime-diametru+grosime, grosime, grosime]);
            translate([0,grosime,0]) rotate([90,0,0])cylinder(grosime+spatiu_roata_zimtata,diametru/2, diametru/2);
            translate([lungime,grosime,0]) rotate([90,0,0])cylinder(grosime+spatiu_roata_zimtata,diametru/2, diametru/2);
        }
        translate([lungime/2,grosime+0.01,inaltime-grosime/2]) rotate([90,0,0])cylinder(grosime+0.02,diametru_surub/2,diametru_surub/2);
        translate([0,grosime+0.01,]) rotate([90,0,0])cylinder(grosime+spatiu_roata_zimtata+0.02,diametru_gaura/2, diametru_gaura/2);
        translate([lungime,grosime+0.01,0]) rotate([90,0,0])cylinder(grosime+spatiu_roata_zimtata+0.02,diametru_gaura/2, diametru_gaura/2);
    }
}
module structura_motor(latime=88.5, grosime=8, inaltime=27, diametru_surub_motor=3, latime_suporti=60, inaltime_suporti=65, spatiere=42){
    color("green")translate([0,-latime/2,-inaltime/2])union(){
        difference(){
            union(){
                cube([grosime,latime, inaltime]);
                translate([spatiere-grosime,(latime-grosime)/2,(inaltime-inaltime_suporti)/2])cube([grosime,grosime,inaltime_suporti]);
                //translate([0,(latime+latime_suporti-grosime)/2,(inaltime-inaltime_suporti)/2+offset_vertical_suporti])cube([grosime,grosime,inaltime_suporti]);
                translate([0,(latime-grosime)/2,0])cube([spatiere-grosime,grosime,inaltime]);
            }
            translate([-0.01, grosime, grosime])cube([grosime+0.02, latime-2*grosime, inaltime-2*grosime]);
            $fn=30;
            /*gauri montare structura*/
            translate([-0.01,latime/2,(inaltime+inaltime_suporti-grosime)/2+0.5])rotate([0,90,0])cylinder(spatiere+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
            translate([-0.01,latime/2,(inaltime-inaltime_suporti+grosime)/2-0.5])rotate([0,90,0])cylinder(spatiere+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
            //#translate([0,grosime + 6.5,grosime+5.5]) rotate([0,-90,0])cylinder(grosime,6.6,6.6);
        }
        translate([0,3.5,grosime])rotate([-45,0,0])cube([grosime,5,5]);
        translate([0,3.5,inaltime-grosime])rotate([-45,0,0])cube([grosime,5,5]);
        translate([0,18.5,grosime])rotate([-45,0,0])cube([grosime,5,5]);
        translate([0,18.5,inaltime-grosime])rotate([-45,0,0])cube([grosime,5,5]);
        translate([0,latime-grosime,0]){
            translate([0,-2,grosime])rotate([-45,0,0])cube([grosime,5,5]);
            translate([0,-2,inaltime-grosime])rotate([-45,0,0])cube([grosime,5,5]);
            translate([0,-17,grosime])rotate([-45,0,0])cube([grosime,5,5]);
            translate([0,-17,inaltime-grosime])rotate([-45,0,0])cube([grosime,5,5]);
        }
        translate([0,grosime+14,0])cube([grosime,latime-2*grosime-27,inaltime]);
    }
}
module schelet_montare(lungime=lungime_core+diametru_roata_zimtata/2+offset_roata_zimtata, latime=latime_core, lungime_laterale=lungime_core*2/3+grosime_core, latime_orizontale=latime_core-offset_roata_zimtata*2-diametru_roata_zimtata-spatiu_roata_zimtata*2, grosime=grosime_core, offset_lungime=lungime_core/6-grosime_core/2+diametru_roata_zimtata/2+offset_roata_zimtata, diametru_surub=2.9, gauri_laterale_suruburi=3){
    color("lime"){
        difference(){
            union(){
                translate([-lungime/2+offset_lungime,-latime/2,0])difference(){
                    cube([lungime_laterale,latime,grosime]);
                    translate([grosime,grosime,-0.01])cube([lungime_laterale-grosime*2,latime-grosime*2, grosime+0.02]);
                }
                translate([-lungime/2,-(latime_orizontale+grosime)/2,0])difference(){
                    cube([lungime,latime_orizontale+grosime,grosime]);
                    translate([grosime,grosime,-0.01])cube([lungime-grosime*2,latime_orizontale-grosime, grosime+0.02]);
                }
                //cod grav
                lungime_spate = sqrt((latime/2-latime_orizontale/2-grosime/2)^2+(offset_lungime)^2);
                unghi_spate = atan((latime/2-latime_orizontale/2-grosime/2)/(offset_lungime));
                translate([-lungime/2+offset_lungime,latime/2,0])rotate([0,0,180+unghi_spate])cube([lungime_spate,grosime,grosime]);
                translate([-lungime/2,-latime_orizontale/2-grosime/2,0])rotate([0,0,-unghi_spate])cube([lungime_spate,grosime,grosime]);

                lungime_fata = sqrt((latime/2-latime_orizontale/2-grosime/2)^2+(lungime-lungime_laterale-offset_lungime)^2);
                unghi_fata = atan((lungime-lungime_laterale-offset_lungime)/(latime/2-latime_orizontale/2-grosime/2));
                translate([lungime_laterale+offset_lungime-lungime/2,-latime/2,0])rotate([0,0,90-unghi_fata])cube([lungime_fata,grosime,grosime]);
                translate([lungime/2,latime_orizontale/2+grosime/2,0])rotate([0,0,90+unghi_fata])cube([lungime_fata,grosime,grosime]);
                //suport gauri verticale
                translate([-lungime/2+offset_lungime+grosime/2,latime_orizontale/2,0]) cylinder(grosime, diametru_surub/2+1, diametru_surub/2+1);
                translate([-lungime/2+offset_lungime+grosime/2,-latime_orizontale/2,0]) cylinder(grosime, diametru_surub/2+1, diametru_surub/2+1);
                translate([-lungime/2+lungime_laterale+offset_lungime-grosime/2,latime_orizontale/2,0]) cylinder(grosime, diametru_surub/2+1, diametru_surub/2+1);
                translate([-lungime/2+lungime_laterale+offset_lungime-grosime/2,-latime_orizontale/2,0]) cylinder(grosime, diametru_surub/2+1, diametru_surub/2+1);
                //suport gauri orizontale
                $fn = 30;
                translate([lungime/2-grosime,latime_orizontale/2,grosime/2]) rotate([0,90,0]) cylinder(grosime, diametru_surub/2+1, diametru_surub/2+1);
                translate([lungime/2-grosime,-latime_orizontale/2,grosime/2]) rotate([0,90,0]) cylinder(grosime, diametru_surub/2+1, diametru_surub/2+1);
                translate([-lungime/2,latime_orizontale/2,grosime/2]) rotate([0,90,0]) cylinder(grosime, diametru_surub/2+1, diametru_surub/2+1);
                translate([-lungime/2,-latime_orizontale/2,grosime/2]) rotate([0,90,0]) cylinder(grosime, diametru_surub/2+1, diametru_surub/2+1);
                for (j=[0:1:gauri_laterale_suruburi-1]){
                    translate([j*(lungime_laterale-grosime)/(gauri_laterale_suruburi-1)+offset_lungime-lungime/2+grosime/2,latime/2,grosime/2]) rotate([90,0,0]) cylinder(grosime, diametru_surub/2+1, diametru_surub/2+1);
                    translate([j*(lungime_laterale-grosime)/(gauri_laterale_suruburi-1)+offset_lungime-lungime/2+grosime/2,-latime/2+grosime,grosime/2]) rotate([90,0,0]) cylinder(grosime, diametru_surub/2+1, diametru_surub/2+1);
                }  
            }
            $fn = 30;
            translate([lungime/2-grosime-0.01,latime_orizontale/2,grosime/2]) rotate([0,90,0]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            translate([lungime/2-grosime-0.01,-latime_orizontale/2,grosime/2]) rotate([0,90,0]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            translate([-lungime/2-0.01,latime_orizontale/2,grosime/2]) rotate([0,90,0]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            translate([-lungime/2-0.01,-latime_orizontale/2,grosime/2]) rotate([0,90,0]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            for (j=[0:1:gauri_laterale_suruburi-1]){
                translate([j*(lungime_laterale-grosime)/(gauri_laterale_suruburi-1)+offset_lungime-lungime/2+grosime/2,latime/2+0.01,grosime/2]) rotate([90,0,0]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
                translate([j*(lungime_laterale-grosime)/(gauri_laterale_suruburi-1)+offset_lungime-lungime/2+grosime/2,-latime/2+grosime+0.01,grosime/2]) rotate([90,0,0]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            }  
            translate([-lungime/2+offset_lungime+grosime/2,latime_orizontale/2,-0.01]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            translate([-lungime/2+offset_lungime+grosime/2,-latime_orizontale/2,-0.01]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            translate([-lungime/2+lungime_laterale+offset_lungime-grosime/2,latime_orizontale/2,-0.01]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            translate([-lungime/2+lungime_laterale+offset_lungime-grosime/2,-latime_orizontale/2,-0.01]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
        }
    }
}
module ansamblu(){
    for(j=[0:3]){
        translate([j*lungime_core/3,-spatiu_roata_zimtata,0]) rotate([0,$t * 360,0]) rotate([90,0,0])roata_zimtata();
        translate([j*lungime_core/3-diametru_roata_zimtata/2-offset_roata_zimtata+spatiu_roata_zimtata, -diametru_roata_zimtata/2 - offset_roata_zimtata-spatiu_roata_zimtata,0]) rotate([$t * 360,0,0]) rotate([0,90,0]) roata_zimtata();
        translate([j*lungime_core/3,grosime_core*2+spatiu_roata_zimtata,0]) rotate([0,$t * 360,0]) rotate([90,0,0]) roata_transmisie();
    }
    for(j=[0:2]){
        translate([j*(lungime_core/3)-diametru_roata_zimtata/2+9-offset_roata_zimtata+spatiu_roata_zimtata,-diametru_roata_zimtata/2-offset_roata_zimtata-spatiu_roata_zimtata,0]) rotate([$t * 360,0,0]) rotate([0,90,0]) transmisie();
    }
    rotate([$t * 360,0,0]) translate([lungime_core-diametru_roata_zimtata/2+9-offset_roata_zimtata+spatiu_roata_zimtata,-offset_roata_zimtata-diametru_roata_zimtata/2-spatiu_roata_zimtata,0]) rotate([0,90,0]) transmisie(lungime=6.6, terminator=true);


    translate([-diametru_roata_zimtata/2-offset_roata_zimtata-grosime_core*2-spatiu_roata_zimtata,-offset_roata_zimtata-diametru_roata_zimtata/2-spatiu_roata_zimtata,0]) rotate([0,0,90]) rotate([90,0,0]) roata_transmisie(gauri=2);
    
    /*
    difference(){
        union(){
            //Adaptoarele pentru picioare
            translate([cos($t*360 + 6)*10 + 2.5,11,-sin($t*360)*10]) translate([-35,30,35]) rotate([0,-90,0]) adaptor_picior(10, 4, 110, 3.5, 40);
            translate([-cos($t*360 + 6)*10 - 2.5,11,sin($t*360)*10]) translate([-95,30,-35]) rotate([0,90,0])adaptor_picior(10, 4, 110, 3.5, 40);
            //picioarele
            translate([cos($t*360)*10,10,-sin($t*360)*10]) translate([-42.55,15,-5]) legPart(2.5,20,80,-45,1.75,10);
            translate([-cos($t*360)*10,8,sin($t*360)*10]) translate([-97.45,17,-5]) legPart(2.5,20,80,-45,1.75,10);
            translate([cos($t*360)*10,8,-sin($t*360)*10]) translate([-128,22.5,-5])rotate([0,0,45]) legPart(2.5,20,80,-65,0,10);
            translate([-cos($t*360)*10,10,sin($t*360)*10]) translate([-9,27.5,-5]) rotate([0,0,-45]) legPart(2.5,20,80,-65,0,10);
            translate([-7.5,45,-5])cube([10,10,10]);
            translate([-132.5,45,-5])cube([10,10,10]);
        }
        $fn=30;
        translate([-2.5,49.5,0])rotate([-90,0,0])cylinder(20,3.5,3.5);
        translate([-2.5,44,0])rotate([-90,0,0])cylinder(23,1.75,1.75);
        translate([-127.5,69.5,0])rotate([90,0,0])cylinder(20,3.5,3.5);
        translate([-127.5,65,0])rotate([90,0,0])cylinder(23,1.75,1.75);
    }*/


    mirror([0,0,1]){
        for(j=[0:1:2]){
            translate([j*lungime_core/3,0,0])structura_triunghi();
        }
    }
    for(j=[0:1:2]){
        translate([j*lungime_core/3,0,0])structura_triunghi();
    }
}
if (1){
    if(1){
        translate([(lungime_core-offset_roata_zimtata-diametru_roata_zimtata/2)/2,0,-inaltime_core/2]){
            translate([0,0,0])schelet_montare();
            translate([0,0,inaltime_core-grosime_core])schelet_montare();
        }
        translate([lungime_core,0,grosime_core/2])rotate([0,0,-90]){
            mirror([0,0,1]) structura_dreptunghi();
            translate([0,0,-grosime_core])structura_dreptunghi();
        }
        translate([-diametru_roata_zimtata/2-offset_roata_zimtata,0,grosime_core/2]) rotate([0,0,90]){
            mirror([0,0,1]) structura_dreptunghi();
            translate([0,0,-grosime_core])structura_dreptunghi();
        }
    }

    translate([0,latime_core/2,0]) {
        ansamblu();
        mirror([0,1,0]){
            translate([0,latime_core,0]) ansamblu();
        }
    }

    if(0){
        translate([-224.5,0,0])structura_motor();
        color("blue"){
            translate([-233,-23.5,-5.25]) rotate([0,0,-90])motor_reductor();
            translate([-233,36.5,-5.25]) rotate([0,0,-90])motor_reductor();
        }
        translate([-193.3,-30,0])rotate([90,0,0]) rotate([0,90,0])adaptor_reductor();
        translate([-193.3,30,0])rotate([90,0,0]) rotate([0,90,0])adaptor_reductor();

            difference(){
        union(){
            mirror([0,0,1]) translate([-175,-37.5,0]) rotate([0,0,90])structura_dreptunghi(diametru_gaura = 10);
        translate([-175,-37.5,0]) rotate([0,0,90])structura_dreptunghi(diametru_gaura = 10);
        }
        $fn = 30;
        translate([-190,0,0]) rotate([0,90,0]) cylinder(20, 1.5, 1.5);
        translate([-190,0,29]) rotate([0,90,0]) cylinder(20, 1.5, 1.5);
        translate([-190,0,-29]) rotate([0,90,0]) cylinder(20, 1.5, 1.5);

    }
    }

    translate([(lungime_core/6-grosime_core/2+diametru_roata_zimtata/2+offset_roata_zimtata)/2,0,inaltime_core/2]) adaptor_pcb();
    translate([lungime_core+grosime_core,0,inaltime_core/2]) rotate([0,0,-90]) adaptor_camera();
}

module mountBracket(lungime=10,latime=2,inaltime=10, dG=2)
{
    //dG --> diametru Gaura
    difference()
    {
        cube([lungime,latime,inaltime]);

        rotate([90,0,0]) 
        translate([lungime/2,inaltime/2,-latime-0.5]) 
        cylinder(h=latime+1, d=dG,$fn=50);

    }


}
module bracketExtension(lungimeBara,latime,inaltimePozBara,lungimeBracket,dGP,inaltimeBara)
{
    //dGP --> diametru gaura prindere (diametrul cilindrului dintre cele 2 placi)
    translate([0,0,inaltimePozBara/2]) 
    cube([latime,lungimeBara,inaltimeBara]);

    translate([lungimeBracket-latime,0,inaltimePozBara/2]) 
    cube([latime,lungimeBara,inaltimeBara]);

}

module legPart(radiusBall,lungimeBara,inaltimePicior,fataSpate,razaGaura,cubeXYZ)
{
    // fataSpate muta piciorul fata spate
    difference() 
    {
        hull() 
        {
        translate([radiusBall+radiusBall,lungimeBara-fataSpate,-inaltimePicior]) 
        sphere(r = radiusBall,$fn=50);
        translate([0,lungimeBara,0]) 
        cube([cubeXYZ,cubeXYZ,cubeXYZ]);
        }

        rotate([90,0,0]) translate([cubeXYZ/2,cubeXYZ/2,-lungimeBara-cubeXYZ]) cylinder(h =cubeXYZ+cubeXYZ+1 , r = razaGaura,center=true, $fn=30);
        translate([cubeXYZ/2,24,5]) rotate([-90,0,0])cylinder(h =cubeXYZ+cubeXYZ+1 , r = razaGaura*2,center=false, $fn=30);
    }

}
module pcb(lungime = 90, latime = 70, diametru_gauri=2){
    color("White"){
        difference(){
            cube([lungime, latime, 1]);
            $fn = 30;
            translate([diametru_gauri/2+1, diametru_gauri/2+1,-0.01]) cylinder(1.02, diametru_gauri/2, diametru_gauri/2);
            translate([lungime-diametru_gauri/2-1, diametru_gauri/2+1,-0.01]) cylinder(1.02, diametru_gauri/2, diametru_gauri/2);
            translate([lungime-diametru_gauri/2-1, latime-diametru_gauri/2-1,-0.01]) cylinder(1.02, diametru_gauri/2, diametru_gauri/2);
            translate([diametru_gauri/2+1, latime-diametru_gauri/2-1,-0.01]) cylinder(1.02, diametru_gauri/2, diametru_gauri/2);
        }
    }
}
module adaptor_pcb(grosime=grosime_core, inaltime=2, diametru_gauri=3, lungime = lungime_core*3/5, latime = latime_core-diametru_roata_zimtata-offset_roata_zimtata*2+grosime_core-spatiu_roata_zimtata*2, diametru_gauri_pcb=3, lungime_pcb=30, latime_pcb=65, inaltime_adaptor_pcb=4, lungime_hbridge=55, latime_hbridge=60, inaltime_baterie=30, latime_baterie=15, lungime_baterie = 40, grosime_baterie=4){
    color("Green"){
        translate([0,-latime/2,0]) difference(){
            union(){
                cube([lungime,latime,inaltime]);//montare
                translate([-lungime_pcb, (latime-latime_pcb)/2, 0])cube([lungime_pcb,latime_pcb,inaltime_adaptor_pcb]);//montare pcb
                translate([0,(latime-lungime_hbridge)/2,0])cube([latime_hbridge, lungime_hbridge, inaltime_adaptor_pcb]);//montare hbridge
                translate([lungime-grosime, (latime-lungime_baterie)/2,0])cube([latime_baterie+grosime_baterie*2,lungime_baterie,inaltime_baterie]);
            }
            translate([grosime, grosime, -0.01])cube([lungime-grosime*2,latime-grosime*2,inaltime_adaptor_pcb+0.02]);//gaura pcb
            translate([lungime-grosime+grosime_baterie, (latime-lungime_baterie)/2-0.01,inaltime])cube([latime_baterie,lungime_baterie+0.02,inaltime_baterie]);//gaura baterie
            //gauri hbridge
            translate([diametru_gauri+3+grosime/4,(latime-lungime_hbridge)/2+diametru_gauri+3+grosime/4,-0.01])cube([latime_hbridge-diametru_gauri*2-6-grosime/2, lungime_hbridge-diametru_gauri*2-6-grosime/2, inaltime_adaptor_pcb+0.02]);
            translate([0,(latime-lungime_hbridge)/2+diametru_gauri+3+grosime/4,inaltime])cube([latime_hbridge+0.02, lungime_hbridge-diametru_gauri*2-6-grosime/2, inaltime_adaptor_pcb]);
            translate([diametru_gauri+3+grosime/4,latime/2-lungime_hbridge/2-0.01,inaltime])cube([latime_hbridge-diametru_gauri*2-6-grosime/2, lungime_hbridge+0.02, inaltime_adaptor_pcb]);

            $fn = 30;
            //gauri montare
            translate([grosime/2,grosime/2,-0.01])cylinder(inaltime+0.02, diametru_gauri/2, diametru_gauri/2);
            translate([lungime-grosime/2+11.25,grosime/2,-0.01])cylinder(inaltime+0.02, diametru_gauri/2, diametru_gauri/2);
            translate([lungime-grosime/2+11.25,latime-grosime/2,-0.01])cylinder(inaltime+0.02, diametru_gauri/2, diametru_gauri/2);
            translate([grosime/2,latime-grosime/2,-0.01])cylinder(inaltime+0.02, diametru_gauri/2, diametru_gauri/2);
            //gauri pcb
            translate([-3.5,(latime-latime_pcb+7)/2,-0.01])cylinder(inaltime_adaptor_pcb+0.02, diametru_gauri_pcb/2, diametru_gauri_pcb/2);
            translate([-lungime_pcb+3.5,(latime-latime_pcb+7)/2,-0.01])cylinder(inaltime_adaptor_pcb+0.02, diametru_gauri_pcb/2, diametru_gauri_pcb/2);
            translate([-3.5,(latime+latime_pcb-7)/2,-0.01])cylinder(inaltime_adaptor_pcb+0.02, diametru_gauri_pcb/2, diametru_gauri_pcb/2);
            translate([-lungime_pcb+3.5,(latime+latime_pcb-7)/2,-0.01])cylinder(inaltime_adaptor_pcb+0.02, diametru_gauri_pcb/2, diametru_gauri_pcb/2);
            //gauri hbridge
            translate([diametru_gauri/2+3,(latime-lungime_hbridge+diametru_gauri)/2+3,-0.01])cylinder(inaltime_adaptor_pcb+0.02, diametru_gauri/2, diametru_gauri/2);
            translate([latime_hbridge-diametru_gauri/2-3,(latime+lungime_hbridge-diametru_gauri)/2-3,-0.01])cylinder(inaltime_adaptor_pcb+0.02, diametru_gauri/2, diametru_gauri/2);
            translate([diametru_gauri/2+3,(latime+lungime_hbridge-diametru_gauri)/2-3,-0.01])cylinder(inaltime_adaptor_pcb+0.02, diametru_gauri/2, diametru_gauri/2);
            translate([latime_hbridge-diametru_gauri/2-3,(latime-lungime_hbridge+diametru_gauri)/2+3,-0.01])cylinder(inaltime_adaptor_pcb+0.02, diametru_gauri/2, diametru_gauri/2);
        }
    }
}
module adaptor_camera(grosime = 4, diameru_surub = 3, latime_gauri = latime_core-offset_roata_zimtata*2-diametru_roata_zimtata-spatiu_roata_zimtata*2){
    translate([-30,0,0]) difference(){
        union(){
            translate([30-latime_gauri/2,0,-grosime])cube([latime_gauri,grosime,grosime]);
            translate([0,0,0])cube([60,5,21]);
            translate([30-latime_gauri/2,4,-grosime/2]) rotate([90,0,0]) cylinder($fn = 30, grosime, diameru_surub/2+1, diameru_surub/2+1);
            translate([30+latime_gauri/2,4,-grosime/2]) rotate([90,0,0]) cylinder($fn = 30, grosime, diameru_surub/2+1, diameru_surub/2+1);
        }
        translate([30-latime_gauri/2,4+0.01,-grosime/2]) rotate([90,0,0]) cylinder($fn = 30, grosime+0.02, diameru_surub/2, diameru_surub/2);
        translate([30+latime_gauri/2,4+0.01,-grosime/2]) rotate([90,0,0]) cylinder($fn = 30, grosime+0.02, diameru_surub/2, diameru_surub/2);
        translate([5, -0.01,grosime]) cube([47.5,5+0.02,20]);
        translate([2, 1.75,grosime]) cube([5,1.5,20]);
        translate([52.5-0.01, -0.01,grosime]) cube([5.2,3+0.02,20]);
        translate([52.5-0.01, 2.5,grosime]) cube([5,3,7]);
        translate([54.5, 5.5,grosime+9.5]) rotate([90,0,0]) cylinder($fn = 30, 5,1,1);
    }

}

