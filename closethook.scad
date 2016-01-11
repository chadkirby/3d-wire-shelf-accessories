// upstairs closet shelves
rackD = 9;
rackSpacing = 49.5 - 8;

// ikea shop shelves:
rackD = 7.5;
rackSpacing = 30 - 6.75;


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

module rotCcl(d) {
    rotate([0,90,0]) cylinder(d=d, h=hookWidth, center=true);
}
module clipCcl(thick) {
    difference() {
        rotCcl(d=rackSpacing*2 + rackD + thick*2);
        rotCcl(d=rackSpacing*2 + rackD);
    }
}

module clip2() {
    x = -rackD - 5;
    y = -rackSpacing;
    linear_extrude(height = hookWidth)
    polygon([
        [x, y],
        [x + 5, y - rackD - 3],
        [0, y - rackD - 3]
    ]);

}
module clip() {
    intersection() {
        union() {
            intersection() {
                intersection() {
                    translate([0,17,-5]) rotCcl(d=rackSpacing*2 + rackD + 2*3);
                    translate([0,-10,-1.3]) rotCcl(d=rackSpacing*2 + rackD + 2*1.5);
                }
                union () {
                    translate([0,17,-5]) clipCcl(3);

                    difference() {
                        translate([0,-10,-1.3]) clipCcl(1.5);
                        translate([0,15,0]) rotate([0,90,0]) cylinder(r=rackSpacing + rackD/2, h=hookWidth, center=true, $fn=60);
                    }
                }
                translate([0,-2,-rackSpacing-9]) rotate([0, 90, 0]) cylinder(r=11, h=hookWidth, center=true);
            }
            intersection() {
                translate([0,15,0]) clipCcl(1.5);
                translate([0,-10,-1.3]) clipCcl(2.5);
            }
        }
        translate([0,0,-50]) cube(size=[hookWidth-0.01, 100, 100], center=true);
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

difference() {
    union() {
        clip();
        /*clip2();*/
        color("red") difference() {
            hookHull();
            // make sure there's room to get the wire under the hook
            if (rackSpacing < rackD * 4) {
                translate([0,-0.6 * (rackD + hookThick), 1.75 * (rackD + 2)]) hull() {
                    translate(knobCoords(0)) rotCcl(d=rackD + 2);
                    translate(knobCoords(1)) rotCcl(d=hookThick*1.6);
                }
            }
            quarterCcl(rackSpacing + rackD/2, rackD, 100);

        }
        knob();
        color("orange") hull() {
            translate(knobCoords(0.75)) rotCcl(d=1);
            translate([0,bottomZ+2,0]) translate(knobCoords(0)) rotCcl(d=rackD + hookThick/2);
            translate([0,0,10]) translate(knobCoords(0)) rotCcl(d=1);
        }
    }
    rackWires();
    translate([10, 0, -6]) rotate([50, 0, 45]) rackWires();
}
