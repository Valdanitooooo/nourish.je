$fn=20;

length = 85.5;
width = 15;
thickness = 6;
screwRadius = 1.5;

penholder();

module penholder() {
  hullThickness = 4.5;
  hull() {
      translate([length-hullThickness, 0, thickness])
        cube(size=[hullThickness,width,1]);
      translate([length-hullThickness,0,thickness+20])
        cube(size=[hullThickness,width+20,5]);
  }
  difference() {
    cube(size=[length, width, thickness]);
    translate([0,0,-1]) {
      translate([6,width/2,0])
        cylinder(r=screwRadius, h=thickness+2);
      translate([length-6,width/2,0])
        cylinder(r=screwRadius, h=thickness+2);
      translate([27,width/2,0])
        cylinder(r=4.75, h=thickness+2);
      translate([60,width/2,0])
        cylinder(r=4.75, h=thickness+2);
    }
    translate([27, width/4, thickness/2])
      rotate([90,0,0])
        cylinder(r=screwRadius, h=4);
    translate([60, width/4, thickness/2])
      rotate([90,0,0])
        cylinder(r=screwRadius, h=4);
  }
}
