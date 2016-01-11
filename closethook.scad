// upstairs closet shelves
rackD = 9;
rackSpacing = 49.5 - 8;

// ikea shop shelves:
rackD = 7.5;
rackSpacing = 25 - 6.75;


// sturdy
hookWidth = 10;
hookThick = 8;

// light weight:
/*hookWidth = 6;
hookThick = 6;*/

hookLength = 40;

bottomZ = -rackD*0.8;

module rackWire(inflate=0) {
    rotate([0, 90, 0]) cylinder(d=rackD+inflate, h=100, center=true);
}
module rackWires() {
    rackWire();
    translate([0, 0, -rackSpacing]) rackWire();
}

module beveledCyl(d, h, bevel) {
    hull() {
        translate([0,0,-h/2]) cylinder(r1=d/2-bevel, r2=d/2, h=bevel, center=false);
        translate([0,0,h/2 - bevel]) cylinder(r2=d/2-bevel, r1=d/2, h=bevel, center=false);
    }
}
module hookHull() {
    difference() {
        rotate([0, 90, 0]) {
            d = rackD + 2 * hookThick;
            intersection() {
                beveledCyl(d=d, h=hookWidth, bevel=2.5, center=true);
                translate([-50,0,0]) cube(size=[100, 100, 100], center=true);
            }
            hull() {
                translate([0, rackD/2 + hookThick/2, 0]) beveledCyl(d=hookThick, h=hookWidth, bevel=2.5, center=true);
                translate([2*rackD, rackD/2, 0]) beveledCyl(d=hookThick, h=hookWidth, bevel=2.5, center=true);
            }
            hull() {
                translate([2*rackD, rackD/2, 0]) beveledCyl(d=hookThick, h=hookWidth, bevel=2.5, center=true);
                translate([rackSpacing - hookThick/2, -0.5*hookThick, 0]) beveledCyl(d=2*hookThick, h=hookWidth, bevel=2.5, center=true);
            }
        }

        // cut out path for top shelf wire
        hull() {
            rackWire();
            translate([0, -2 * hookThick, -0.5 * rackSpacing]) rackWire();
            translate([0, -hookThick, -0.5 * rackSpacing]) rackWire();
        };
    }
}
module quarterCcl(d0, d1, h) {
    intersection() {
        rotate([0, 90, 0]) {
            difference() {
                cylinder(r=d0, h=h, center=true, $fn=60);
                cylinder(r=d0 - d1, h=h, center=true);

            }
        }
        translate([-h/2, 0, -d0 - d1 - hookThick]) cube(size=[h, d0 + d1 + hookThick, d0 + d1 + hookThick], center=false);
    }
}

module rotCcl(d, hinflate = 0) {
    rotate([0,90,0]) cylinder(d=d, h=hookWidth + hinflate, center=true);
}
module clipCcl(thick) {
    difference() {
        rotCcl(d=92 + thick*2);
        rotCcl(d=92);
    }
}

function knobCoords(dist) = [0, -hookLength * dist, -rackSpacing + hookLength*0.5*dist];

module knob() {
    color("blue") hull() {
        translate(knobCoords(1)) rotate([0, 90, 0]) {
            beveledCyl(d=2*(hookThick*0.8), h=hookWidth, bevel=2.5, center=true);
        }
        translate(knobCoords(0)) rotCcl(d=hookThick - 1);
    }
}

module clip3() {
    clipThick = 1.5;
    translate([0, 0, -rackSpacing]) {
        difference() {
            rotCcl(d=rackD+2*clipThick);
            hull() {
                rotCcl(d=rackD, hinflate=1);
                translate([0,rackD,0]) rotCcl(d=rackD, hinflate=1);

            }
        }
        hull() {
            translate([0,0,-rackD/2 - 1]) rotCcl(d=clipThick);
            translate([0,7,-rackD/2 + 1]) rotCcl(d=clipThick);
        }
        hull() {
            translate([0,7,-rackD/2 + 1]) rotCcl(d=clipThick);
            translate([0,7 + 2,-rackD/2]) rotCcl(d=1);
        }
    }
}
difference() {
    union() {
        clip3();
        /*clip2();*/
        color("red") difference() {
            hookHull();
            // make sure there's room to get the wire under the hook
            if (rackSpacing < rackD * 4) {
                translate([0,-0.6 * (rackD + hookThick), 1.75 * (rackD + 2)]) hull() {
                    translate(knobCoords(0)) rotCcl(hinflate=1, d=rackD + 2);
                    translate(knobCoords(1)) rotCcl(hinflate=1, d=hookThick*1.6);
                }
            }
            quarterCcl(rackSpacing + rackD/2, rackD, 100);

        }
        knob();
        color("orange") hull() {
            translate(knobCoords(0.75)) rotCcl(d=1);
            translate([0,bottomZ,0]) translate(knobCoords(0)) rotCcl(d=rackD + hookThick/2);
            translate([0,hookThick/2,10]) translate(knobCoords(0)) rotCcl(d=1);
        }
    }
    rackWires();
    *translate([5, 0, -3]) rotate([50, 0, 45]) rackWires();
}
