rackD = 7;
rackSpacing = 49.5 - 8.5;
hookWidth = 12;
hookThick = 8;


module rackWire() {
    rotate([0, 90, 0]) cylinder(d=rackD, h=100, center=true);
}
module rack() {
    hull() {
        translate([0, 6 + rackD/2, 0]) rackWire();
        translate([0, 6 + rackD/2, 20]) rackWire();
    }
    translate([-5, 57, rackD/2-1]) rotate([90, 0, 0]) cylinder(d=3.5, h=100, center=true);
    translate([5, 57, rackD/2-1]) rotate([90, 0, 0]) cylinder(d=3.5, h=100, center=true);
    translate([0, 57, rackD/2-1]) rotate([90, 0, 0]) cylinder(d=3.5, h=100, center=true);
}

module screw() {
    translate([0, 4, 0]) {
        rotate([90, 0, 0]) cylinder(d=4.5, h=100, center=false);
        rotate([-90, 0, 0]) cylinder(d1=4.5, d2=9, h=3, center=false);
        translate([0, 3, 0]) rotate([-90, 0, 0]) cylinder(d=9, h=100, center=false);
    }
}
module hook() {
    intersection() {
        translate([0, 9, 0]) cube(size=[35, 18, 45], center=true);
        rotate([0, 90, 0]) cylinder(r=21, h=15, center=true);
    }
}
difference() {
    hook();
    rack();
    translate([0, 10+6, 10+2.25]) cube(size=[40, 20, 20], center=true);
    translate([0, 0, 14])  screw();
    translate([0, 0, -14])  screw();
}
