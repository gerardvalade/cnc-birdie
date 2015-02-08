include <MCAD/units.scad>;
include <MCAD/materials.scad>;
include <bom.scad>;

module shim(de, di, h, code, label) {
	size = str(de,"x",di,"x",h);

	module bomShim(c, l) {
		bom(str(c,"-",size), str(l," ",size,"mm"), ["hardware"]);
	}

	if(code) {
		bomShim(code, label);
	} else {
		bomShim("shim", "Shim");
	}

	re = de / 2;
	ri = di / 2;
	color(Steel)
	difference() {
		cylinder(
				h,
				re,
				re,
				true);
		cylinder(
			h+epsilon,
			ri,
			ri,
			true);
	}
}

module precisionShim10x5x1() {
	shim(10,5,1,"precision-shim", "Precision Shim");
}

module shim_test() {
	$fn = 32;
	precisionShim10x5x1();
}