include <MCAD/units.scad>;
include <MCAD/materials.scad>;
include <bom.scad>;

ballBearing625_2rs_height = 5;
ballBearing625_2rs_radius = 8;
ballBearing625_2rs_radius_hole = 2.5;

module ballBearing625_2rs() {
	bom("ob-ball-bearing-625-2rs", "OpenBuild Ball Bearing 625 2RS", ["bearing", "hardware"]);
	r1 = 4;   // ???
	r2 = 6.5; // ???
	h1 = 4.5; // ???
	difference() {
		union() {
			color(Steel)
			difference() {
				cylinder(
					ballBearing625_2rs_height,
					ballBearing625_2rs_radius,
					ballBearing625_2rs_radius,
					true);
				cylinder(
					ballBearing625_2rs_height+epsilon,
					r2,
					r2,
					true);
			}
			color("Black")
			cylinder(
				h1,
				r2,
				r2,
				true
			);
			color(Steel)
			cylinder(
				ballBearing625_2rs_height,
				r1,
				r1,
				true);
		}
		color(Steel)
		cylinder(
			ballBearing625_2rs_height+epsilon,
			ballBearing625_2rs_radius_hole,
			ballBearing625_2rs_radius_hole,
			true);
	}
}

module bearing_test() {
	$fn = 32;
	ballBearing625_2rs();
}