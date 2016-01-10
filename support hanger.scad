wireD = 4;
wireSpacing = 28.5 - 3.5;

module support() {
    #rotate([0,-30,0]) translate([-13.5/2+0.5,0,0]) {
        hull () {
            translate([6/2, 0, 0]) cylinder(d=6, h=100, center=true);
            translate([13.5, 14.5/2, 0]) cylinder(d=0.5, h=100, center=true);
            translate([13.5, -14.5/2, 0]) cylinder(d=0.5, h=100, center=true);
        }
        hull () {
            translate([13.5, 14.5/2, 0]) cylinder(d=0.5, h=100, center=true);
            translate([13.5, -14.5/2, 0]) cylinder(d=0.5, h=100, center=true);
            translate([9, 14.5/2, 0]) cylinder(d=0.5, h=100, center=true);
            translate([9, -14.5/2, 0]) cylinder(d=0.5, h=100, center=true);
        }
    }
}
module easedRect(l, w, h, bevel) {
    rotate([0,90,0])
    translate([-w, 0, 0])
    linear_extrude(height=l, center=false) polygon(
        points=[
            [0, bevel],
            [0, h-bevel],
            [bevel, h],
            [w-bevel, h],
            [w, h-bevel],
            [w, bevel],
            [w-bevel, 0],
            [bevel, 0],
        ]);

}

module wire(d=wireD) {
    rotate([90,0,0])
    cylinder(d=d, h=100, center=true, $fn=12);
}
module shelf() {
    for (i=[0:4]) {
        translate([i*-wireSpacing,0,0])
        wire();
    }

}

module arms() {
    translate([6, 40 - 15, 0]) rotate([0,0,60]) translate([0,-5,0]) easedRect(60,10,10,2);
    translate([6, 15, 0]) rotate([0,0,-60]) translate([0,-5,0]) easedRect(60,10,10,2);
}
difference() {
    translate([-30/2 - 3,-40/2,-10/2]) union() {
        /*cube(size=[30, 40, 10], center=false);*/
        intersection() {
            easedRect(32, 10, 40, 2);
            hull() arms();
        }
        arms();
        /*#translate([8,0,10/2]) rotate([90,0,0]) cylinder(d=3.25, h=100, center=true);*/
    }
    support();
    translate([6,0,0]) cube(size=[1, 40, 40], center=true);
    translate([0, 13, 0]) rotate([0,90,0]) {
        cylinder(d=2.5, h=100, center=true);
        translate([0, 0, 9]) cylinder(d=6, h=100, center=false);
    }
    translate([0, -13, 0]) rotate([0,90,0]) {
        cylinder(d=2.5, h=100, center=true);
        translate([0, 0, 9]) cylinder(d=6, h=100, center=false);
    }
}
