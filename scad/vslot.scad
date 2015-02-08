include <MCAD/units.scad>;
include <MCAD/materials.scad>
use <MCAD/shapes.scad>;
use <bom.scad>;

vslot_color_black = [0.27, 0.27, 0.3];
vslot_color = Aluminum;

module vslot(length=50, sections=1, finish, epsilon=0.04) {
	size = sections * 20;
	bom(str("vslot20x", size, "x", length), str("v-slot 20x", size, " (", length , "mm)"), ["rail", "extrusion", "structure"]);
	cutext = [[12.00,4.50],[10.00,4.50],[8.20,2.78],[8.20,5.50],[6.56,5.50],[3.90,2.84],[3.90,0.21],[3.69,0.00],[3.90,-0.21],[3.90,-2.84],[6.56,-5.50],[8.20,-5.50],[8.20,-2.78],[10.00,-4.50],[12.00,-4.50]];
	cutint = [[16.10,0.21],[16.10,2.84],[12.70,6.24],[12.70,8.78],[7.30,8.78],[7.30,6.24],[3.90,2.84],[3.90,0.21],[3.69,0.00],[3.90,-0.21],[3.90,-2.84],[7.30,-6.24],[7.30,-8.78],[12.70,-8.78],[12.70,-6.24],[16.10,-2.84],[16.10,-0.21],[16.31,0.00],];
	cutcorner = [[8.20,8.20],[6.57,8.20],[6.57,7.66],[7.66,6.57],[8.20,6.57]];

	module profile() {
		difference() {
			translate([0,0,length/2])
			roundedBox(20 * sections, 20, length, 1.5);
			for(i = [0,180]) rotate([0,0,-i]) translate([10 * (sections - 1), 0, -epsilon/2]) {
				linear_extrude(length+20) polygon(cutext);
				translate([5,-2.89,-20]) cube([10,5.78,length+40]);
			}

			for(i = [90,270]) rotate([0,0,-i])
				for(j = [0:sections-1]) translate([0, (sections - 1) * 10 - 20 * j, -epsilon/2]) {
					linear_extrude(length+epsilon) polygon(cutext);
					translate([5,-2.89,-20]) cube([10,5.78,length+40]);
				}

			for(i = [0:sections-1]) translate([i * 20 - 10 * (sections - 1),0,-epsilon/2])
				cylinder(length+20, 2.1, 2.1);

			for(i = [90,270]) rotate([0,0,-i])
				translate([0,(sections - 1) * 10,-epsilon/2])
				linear_extrude(length+epsilon) polygon(cutcorner);
			for(i = [ 0,180]) rotate([0,0,-i])
				translate([(sections - 1) * 10,0,-epsilon/2])
				linear_extrude(length+epsilon) polygon(cutcorner);

			if(sections > 1)
				for(i = [0:sections-2]) translate([(sections - 3) * 10 - i * 20, 0, -epsilon/2])
					linear_extrude(length+epsilon) polygon(cutint);
		}
	}

	if(finish)
		color(finish) profile();
	else
		color(vslot_color) profile();
}

module vslot20x20(length, finish) { vslot(length, 1, finish); }

module vslot20x40(length, finish) { vslot(length, 2, finish); }

module vslot20x60(length, finish) { vslot(length, 3, finish); }

module vslot20x80(length, finish) { vslot(length, 4, finish); }


module vslot_test() {
	$fn = 32;

	vslot20x20(100);

	translate([0, 40, 0])
	vslot20x40(100, vslot_color_black);

	translate([0, 80, 0])
	vslot20x60(100);

	translate([0, 120, 0])
	vslot20x80(100, vslot_color_black);
}




