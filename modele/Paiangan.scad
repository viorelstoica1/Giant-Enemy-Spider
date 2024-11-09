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
module roata_zimtata(diametru=25, dinti=40, unghi_dinti=30, grosime=4, grosime_gaura=7){
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
module roata_transmisie(diametru=25, diametru_tub=10, gauri=2, grosime=5, diametru_gauri = 4, diametru_cerc_gauri = 15,lungime_tub=5, latime_capat = 5, inaltime_capat = 10){
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
    translate([0,0,grosime])cylinder(1, diametru_tub/2+2, diametru_tub/2+2);
    translate([-latime_capat/2,-latime_capat/2,grosime+lungime_tub]) cube([latime_capat,latime_capat,inaltime_capat]);
}
module picior(lungime_sus = 70,lungime_jos = 140, diametru = 10){
    $fn = 30;
    translate([0,0,0]) rotate([-90,0,0]) cylinder(lungime_sus, diametru/2, diametru/2);
    translate([0,lungime_sus + lungime_jos * cos(70), -lungime_jos * sin(70)]) rotate([20,0,0]) cylinder(lungime_jos, diametru/2, diametru/2);
}
module transmisie(lungime=80, diametru=10, grosime_conector = 6, lungime_conector = 5, lungime_terminator = 5,terminator = false){
    $fn = 30;
    translate([-grosime_conector/2,-grosime_conector/2,0]){
    if(terminator){
        translate([grosime_conector/2,grosime_conector/2,0])cylinder(lungime_terminator, grosime_conector/2,grosime_conector/2, center = false);
    }
    else{
        cube([grosime_conector,grosime_conector, lungime_terminator]);
    }
    translate([0,0,lungime_terminator+lungime])cube([grosime_conector,grosime_conector, lungime_conector]);
    translate([grosime_conector/2,grosime_conector/2,lungime_terminator]) cylinder(lungime, diametru/2, diametru/2, center = false);
    }

}
module structura_dreptunghi(lungime=75, diametru=15, diametru_gaura=7, grosime = 7.5, inaltime=40, diametru_surub=3){
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
module structura_triunghi(lungime=50, diametru=15, diametru_gaura=10, grosime = 7.5, inaltime=40, diametru_surub=3){
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
module structura_motor(latime=90, grosime=8, inaltime=39, diametru_surub_motor=3, latime_suporti=60, inaltime_suporti=65, offset_vertical_suporti=5, spatiere=20){
    color("green")translate([0,-latime/2,-inaltime/2])difference(){
        union(){
            cube([grosime,latime, inaltime]);
            translate([0,(latime-grosime)/2,(inaltime-inaltime_suporti)/2+offset_vertical_suporti])cube([spatiere,grosime,inaltime_suporti]);
            //translate([0,(latime+latime_suporti-grosime)/2,(inaltime-inaltime_suporti)/2+offset_vertical_suporti])cube([grosime,grosime,inaltime_suporti]);
        }
        translate([-0.01, grosime, grosime])cube([spatiere+0.02, latime-2*grosime, inaltime-2*grosime]);
        $fn=30;
        /*gauri montare structura*/
        translate([-0.01,latime/2,(inaltime+inaltime_suporti-grosime)/2+offset_vertical_suporti+0.5])rotate([0,90,0])cylinder(spatiere+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        translate([-0.01,latime/2,(inaltime+inaltime_suporti-grosime)/2+offset_vertical_suporti+0.5])rotate([0,90,0])cylinder(spatiere-grosime+0.02, diametru_surub_motor, diametru_surub_motor);
        translate([-0.01,latime/2,(inaltime-inaltime_suporti+grosime)/2+offset_vertical_suporti-0.5])rotate([0,90,0])cylinder(spatiere+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        translate([-0.01,latime/2,(inaltime-inaltime_suporti+grosime)/2+offset_vertical_suporti-0.5])rotate([0,90,0])cylinder(spatiere-grosime+0.02, diametru_surub_motor, diametru_surub_motor);
        //translate([-0.01,(latime)/2,(inaltime+inaltime_suporti-grosime)/2+offset_vertical_suporti])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        //translate([-0.01,(latime+latime_suporti)/2,(inaltime-inaltime_suporti+grosime)/2+offset_vertical_suporti])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        /*gauri montare motoare*/
        translate([-0.01,latime-grosime-7,inaltime-grosime+2])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        translate([-0.01,latime-grosime-7,grosime-2])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        translate([-0.01,grosime+7,inaltime-grosime+2])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
        translate([-0.01,grosime+7,grosime-2])rotate([0,90,0])cylinder(grosime+0.02, diametru_surub_motor/2, diametru_surub_motor/2);
    }
}
module schelet_montare(lungime=180, latime=112.5, lungime_laterale=107.5, latime_orizontale=67.5, grosime=7.5, offset_lungime=56.25, diametru_surub=2.9, gauri_laterale_suruburi=3){
    color("lime"){
        difference(){
            union(){
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
            $fn = 30;
            translate([lungime/2-grosime-0.01,latime_orizontale/2-grosime/2,grosime/2]) rotate([0,90,0]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            translate([lungime/2-grosime-0.01,-latime_orizontale/2+grosime/2,grosime/2]) rotate([0,90,0]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            translate([-lungime/2-0.01,latime_orizontale/2-grosime/2,grosime/2]) rotate([0,90,0]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            translate([-lungime/2-0.01,-latime_orizontale/2+grosime/2,grosime/2]) rotate([0,90,0]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            for (j=[0:1:gauri_laterale_suruburi-1]){
                translate([j*(lungime_laterale-grosime)/(gauri_laterale_suruburi-1)+offset_lungime-lungime/2+grosime/2,latime/2+0.01,grosime/2]) rotate([90,0,0]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
                translate([j*(lungime_laterale-grosime)/(gauri_laterale_suruburi-1)+offset_lungime-lungime/2+grosime/2,-latime/2+grosime+0.01,grosime/2]) rotate([90,0,0]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            }  
            #translate([-lungime/2+offset_lungime+grosime/2,latime_orizontale/2-grosime/2,-0.01]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            #translate([-lungime/2+offset_lungime+grosime/2,-latime_orizontale/2+grosime/2,-0.01]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            #translate([-lungime/2+lungime_laterale+offset_lungime-grosime/2,latime_orizontale/2-grosime/2,-0.01]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
            #translate([-lungime/2+lungime_laterale+offset_lungime-grosime/2,-latime_orizontale/2+grosime/2,-0.01]) cylinder(grosime+0.02, diametru_surub/2, diametru_surub/2);
        }
    }
}
module ansamblu(){
    for(j=[0:3]){
        translate([-140+j*50,25,0]) rotate([0,$t * 360,0]) rotate([90,0,0])roata_zimtata(43, 30, 50, 9);
        translate([-165+j*50,0,0])rotate([$t * 360,0,0]) rotate([0,90,0]) roata_zimtata(43, 30, 50, 9);
        translate([-140+j*50,40,0]) rotate([0,$t * 360,0]) rotate([90,0,0]) roata_transmisie(40, 9.6, 2, 5, 3, 25, 10, 6.8);
    }
    for(j=[0:2]){
        translate([-160.3+j*50,0,0]) rotate([$t * 360,0,0]) rotate([0,90,0]) transmisie(lungime = 40.7, diametru = 10, lungime_conector = 4.5,grosime_conector = 6.7, lungime_terminator = 4.5,terminator = false);
    }
    translate([-189.2,0,0]) rotate([0,0,90]) rotate([90,0,0]) roata_transmisie(40, 9.6, 2, 5, 2, 32, 19, 6.7, 4.5);
    
    difference(){
        union(){
            /*Adaptoarele pentru picioare*/
            translate([cos($t*360 + 6)*10 + 2.5,11,-sin($t*360)*10]) translate([-35,30,35]) rotate([0,-90,0]) adaptor_picior(10, 4, 110, 3.5, 40);
            translate([-cos($t*360 + 6)*10 - 2.5,11,sin($t*360)*10]) translate([-95,30,-35]) rotate([0,90,0])adaptor_picior(10, 4, 110, 3.5, 40);
            //picioarele
            translate([cos($t*360)*10,10,-sin($t*360)*10]) translate([-42.55,15,-5]) legPart(2.5,20,80,-45,1.75,10);
            translate([-cos($t*360)*10,8,sin($t*360)*10]) translate([-97.45,17,-5]) legPart(2.5,20,80,-45,1.75,10);
            translate([cos($t*360)*10,8,-sin($t*360)*10]) translate([-128,22.5,-5])rotate([0,0,45]) legPart(2.5,20,80,-65,0,10);
            translate([-cos($t*360)*10,10,sin($t*360)*10]) translate([-9,27.5,-5]) rotate([0,0,-45]) legPart(2.5,20,80,-65,0,10);
            translate([-7.5,45,-5])cube([10,10,10]);
            translate([-132.5,45,-5])cube([10,10,10]);
            //suporti picioare
            //translate([-7.5,43,-25])cube([10,5,20]);
            //translate([-132.5,43,5])cube([10,5,20]);
            //translate([-32.5,43,5])cube([10,5,20]);
            //translate([-107.5,43,-25])cube([10,5,20]);

        }
        $fn=30;
        translate([-2.5,49.5,0])rotate([-90,0,0])cylinder(20,3.5,3.5);
        translate([-2.5,44,0])rotate([-90,0,0])cylinder(23,1.75,1.75);
        translate([-127.5,69.5,0])rotate([90,0,0])cylinder(20,3.5,3.5);
        translate([-127.5,65,0])rotate([90,0,0])cylinder(23,1.75,1.75);
    }

    rotate([$t * 360,0,0]) rotate([0,0,180]) translate([-12.4,0,0]) rotate([0,90,0]) transmisie(lungime = 10.7, diametru = 10, lungime_conector = 4.5,grosime_conector = 6.7, lungime_terminator = 7.5, terminator = true);
    /*Structura de rezistenta*/
    mirror([0,0,1]){
        for(j=[0:1:2]){
            translate([-147.5+j*50,26.25,0])structura_triunghi(lungime=65, diametru=15, inaltime=40, grosime=7.5);
        }
    }
    for(j=[0:1:2]){
        translate([-147.5+j*50,26.25,0])structura_triunghi(lungime=65, diametru=15, inaltime=40, grosime=7.5);
    }

}
if (0){
    translate([0,30,0]) ansamblu();
    mirror([0,1,0]){
        translate([0,30,0]) ansamblu();    
    }
    mirror([0,0,1]) translate([12.5,-37.5,0])rotate([0,0,90])structura_dreptunghi();
    translate([12.5,-37.5,0])rotate([0,0,90])structura_dreptunghi();
    translate([-202.5,0,-5])structura_motor();
    //translate([0,-45,30])rotate([0,0,90])prototype_board();
    translate([-220.5,30,-16]) rotate([90,0,90]) import("servo.stl");
    translate([-220.5,-30,-16]) rotate([90,0,90]) import("servo.stl");

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

    mirror([0,0,1])translate([-85,0,25]) schelet_montare();
    translate([-85,0,25]) schelet_montare();
}

//structura_motor();

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


    difference(){
        union(){
            /*Adaptoarele pentru picioare*/
            //translate([cos($t*360)*10 + 2.5,11,-sin($t*360)*10]) translate([-35,30,35]) rotate([0,-90,0]) adaptor_picior(10, 4, 110, 3.5, 40);
            translate([-cos($t*360)*10 - 2.5,11,sin($t*360)*10]) translate([-95,30,-35]) rotate([0,90,0])adaptor_picior(10, 4, 110, 3.5, 40);
            //picioarele
            //translate([cos($t*360)*10,10,-sin($t*360)*10]) translate([-42.55,15,-5]) legPart(2.5,20,80,-45,1.75,10);
            translate([-cos($t*360)*10,8,sin($t*360)*10]) translate([-97.45,17,-5]) legPart(2.5,20,80,-45,1.75,10);
            //translate([cos($t*360)*10,8,-sin($t*360)*10]) translate([-128,22.5,-5])rotate([0,0,45]) legPart(2.5,20,80,-65,0,10);
            translate([-cos($t*360)*10,10,sin($t*360)*10]) translate([-9,27.5,-5]) rotate([0,0,-45]) legPart(2.5,20,80,-65,0,10);
            translate([-7.5,45,-5])cube([10,10,10]);
            //translate([-132.5,45,-5])cube([10,10,10]);
            //suporti picioare
            //translate([-7.5,43,-25])cube([10,5,20]);
            //translate([-132.5,43,5])cube([10,5,20]);
            //translate([-32.5,43,5])cube([10,5,20]);
            //translate([-107.5,43,-25])cube([10,5,20]);

        }
        $fn=30;
        translate([-2.5,49.5,0])rotate([-90,0,0])cylinder(20,3.5,3.5);
        translate([-2.5,44,0])rotate([-90,0,0])cylinder(23,1.75,1.75);
        translate([-127.5,69.5,0])rotate([90,0,0])cylinder(20,3.5,3.5);
        translate([-127.5,65,0])rotate([90,0,0])cylinder(23,1.75,1.75);
    }